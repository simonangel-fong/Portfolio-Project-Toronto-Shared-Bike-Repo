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
MV_TRIP_USER_HOUR = f"{PROJECT}-{APP}-{ENV}-mv_trip_user_year_hour"


class TestTripHour(unittest.TestCase):
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
        cls.table_name = MV_TRIP_USER_HOUR

        cls.dynamodb.create_table(
            TableName=cls.table_name,
            KeySchema=[{"AttributeName": "pk", "KeyType": "HASH"}],
            AttributeDefinitions=[
                {"AttributeName": "pk", "AttributeType": "S"}],
            BillingMode="PAY_PER_REQUEST",
        )

        trip_hour_tb = cls.dynamodb.Table(cls.table_name)
        trip_hour_tb.put_item(Item={"pk": "b72c3d30-d559-400f-9548-cb38d6f6b2e3", "dim_year": "2019", "dim_hour": 0,
                              "dim_user": "annual", "trip_count": 17510, "duration_sum": 12344885})
        trip_hour_tb.put_item(Item={"pk": "c39da87e-0aee-4025-bccc-b55f5fa31bf9", "dim_year": "2019", "dim_hour": 0,
                              "dim_user": "casual", "trip_count": 7193, "duration_sum": 10322748})
        trip_hour_tb.put_item(Item={"pk": "442e02b0-b9a1-4b44-a221-a905f552b33d", "dim_year": "2020", "dim_hour": 0,
                              "dim_user": "annual", "trip_count": 18855, "duration_sum": 14435457})
        trip_hour_tb.put_item(Item={"pk": "47333451-a9cd-4512-87b8-3f2bf6a077c3", "dim_year": "2020", "dim_hour": 0,
                              "dim_user": "casual", "trip_count": 17337, "duration_sum": 33151982})

        # Import your lambda handler
        sys.path.insert(0, LAMBDA_PATH)
        cls.target = importlib.import_module("main")

    @classmethod
    def tearDownClass(cls):
        # Stop the moto context once after all tests
        cls.mock.stop()

    # test case
    def test_trip_hour_all(self):
        # /trip-hour
        event = {
            "httpMethod": "GET",
            "path": "/trip-hour",
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
            r["dim_hour"],
            r["dim_user"],
            r["trip_count"],
            r["duration_sum"]
        ) for r in body["data"]}
        self.assertEqual(
            data,
            {(2019, 0, "annual", 17510, 12344885),
                (2019, 0, "casual", 7193, 10322748),
                (2020, 0, "annual", 18855, 14435457),
                (2020, 0, "casual", 17337, 33151982)}
        )

    def test_trip_hour_filter_year(self):
        # /trip-hour?year=2019
        event = {
            "httpMethod": "GET",
            "path": "/trip-hour",
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
            r["dim_hour"],
            r["dim_user"],
            r["trip_count"],
            r["duration_sum"]
        ) for r in body["data"]}
        self.assertEqual(
            data,
            {(2019, 0, "annual", 17510, 12344885),
             (2019, 0, "casual", 7193, 10322748),
             }
        )

    def test_trip_hour_filter_user(self):
        # /trip-hour?user=casual
        event = {
            "httpMethod": "GET",
            "path": "/trip-hour",
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
            r["dim_hour"],
            r["dim_user"],
            r["trip_count"],
            r["duration_sum"]
        ) for r in body["data"]}
        self.assertEqual(
            data,
            {(2019, 0, "casual", 7193, 10322748),
             (2020, 0, "casual", 17337, 33151982)}
        )
