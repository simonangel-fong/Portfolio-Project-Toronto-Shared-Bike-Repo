import os
import sys
import json
import boto3
import unittest
import importlib
from moto import mock_aws

# lambda path
LAMBDA_PATH = "src/web-app/lambda"
# app var
PROJECT = os.environ.get('PROJECT', 'toronto-shared-bike')
APP = os.environ.get('APP', 'data-warehouse')
ENV = os.environ.get('ENV', 'dev')
AWS_REGION = os.environ.get('aws_region', 'ca-central-1')
# tb name
MV_TRIP_USER_MONTH = f"{PROJECT}-{APP}-{ENV}-mv_trip_user_year_month"


class TestTripMonth(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # moto context
        cls.mock = mock_aws()
        cls.mock.start()

        # setup boto3
        os.environ.setdefault("AWS_DEFAULT_REGION", "ca-central-1")
        os.environ.setdefault("AWS_REGION", "ca-central-1")
        os.environ.setdefault("AWS_ACCESS_KEY_ID", "test")
        os.environ.setdefault("AWS_SECRET_ACCESS_KEY", "test")
        os.environ.setdefault("AWS_SESSION_TOKEN", "test")

        # set env used
        os.environ.setdefault('PROJECT', PROJECT)
        os.environ.setdefault('APP', APP)
        os.environ.setdefault('ENV', ENV)

        # Create table
        cls.region = AWS_REGION
        cls.dynamodb = boto3.resource("dynamodb", region_name=cls.region)
        cls.table_name = MV_TRIP_USER_MONTH

        cls.dynamodb.create_table(
            TableName=cls.table_name,
            KeySchema=[{"AttributeName": "pk", "KeyType": "HASH"}],
            AttributeDefinitions=[
                {"AttributeName": "pk", "AttributeType": "S"}],
            BillingMode="PAY_PER_REQUEST",
        )

        trip_hour_tb = cls.dynamodb.Table(cls.table_name)
        trip_hour_tb.put_item(Item={"pk": "c5dad626-4730-4201-93f0-fb316ea0e700", "dim_year": "2019", "dim_month": 1,
                              "dim_user": "casual", "trip_count": 1942, "duration_sum": 5121502})
        trip_hour_tb.put_item(Item={"pk": "beedf3d2-0d62-4772-9943-2a3278fe55b8", "dim_year": "2019", "dim_month": 1,
                              "dim_user": "annual", "trip_count": 59517, "duration_sum": 42683850})
        trip_hour_tb.put_item(Item={"pk": "37f553bc-d973-4e03-b084-f63e8a689bab", "dim_year": "2020", "dim_month": 1,
                              "dim_user": "casual", "trip_count": 4579, "duration_sum": 9914383})
        trip_hour_tb.put_item(Item={"pk": "6f0f0144-b83e-45aa-8fce-ec8e2b38b2f4", "dim_year": "2020", "dim_month": 1,
                              "dim_user": "annual", "trip_count": 97481, "duration_sum": 67696873})

        # Import your lambda handler
        sys.path.insert(0, LAMBDA_PATH)
        cls.target = importlib.import_module("main")

    @classmethod
    def tearDownClass(cls):
        # Stop the moto context once after all tests
        cls.mock.stop()

    # test case
    def test_trip_month_all(self):
        # /trip-month
        event = {
            "httpMethod": "GET",
            "path": "/trip-month",
            "queryStringParameters": None
        }
        resp = self.target.lambda_handler(event, None)

        # status code
        self.assertEqual(resp["statusCode"], 200)
        # count
        body = json.loads(resp["body"])
        print(body)
        self.assertEqual(body["count"], 4)
        # data
        data = {(
            r["dim_year"],
            r["dim_month"],
            r["dim_user"],
            r["trip_count"],
            r["duration_sum"]
        ) for r in body["data"]}
        self.assertEqual(
            data,
            {(2019, 1, "casual", 1942, 5121502),
                (2019, 1, "annual", 59517, 42683850),
                (2020, 1, "casual", 4579, 9914383),
                (2020, 1, "annual", 97481, 67696873)}
        )

    def test_trip_month_filter_year(self):
        # /trip-month?year=2019
        event = {
            "httpMethod": "GET",
            "path": "/trip-month",
            "queryStringParameters": {"year": "2019"},
        }
        resp = self.target.lambda_handler(event, None)

        # status code
        self.assertEqual(resp["statusCode"], 200)
        # count
        body = json.loads(resp["body"])
        self.assertEqual(body["count"], 2)
        # data
        data = {(
            r["dim_year"],
            r["dim_month"],
            r["dim_user"],
            r["trip_count"],
            r["duration_sum"]
        ) for r in body["data"]}
        self.assertEqual(
            data,
            {
                (2019, 1, "casual", 1942, 5121502),
                (2019, 1, "annual", 59517, 42683850)
            }
        )

    def test_trip_month_filter_user(self):
        # /trip-month?user=casual
        event = {
            "httpMethod": "GET",
            "path": "/trip-month",
            "queryStringParameters": {"user": "casual"},
        }
        resp = self.target.lambda_handler(event, None)

        # status code
        self.assertEqual(resp["statusCode"], 200)
        # count
        body = json.loads(resp["body"])
        self.assertEqual(body["count"], 2)
        # data
        data = {(
            r["dim_year"],
            r["dim_month"],
            r["dim_user"],
            r["trip_count"],
            r["duration_sum"]
        ) for r in body["data"]}
        self.assertEqual(
            data,
            {(2019, 1, "casual", 1942, 5121502),
                (2020, 1, "casual", 4579, 9914383), }
        )
