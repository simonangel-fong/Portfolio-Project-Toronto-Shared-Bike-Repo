import os
import sys
import json
import boto3
import unittest
import importlib
from moto import mock_aws

# lambda path
LAMBDA_PATH = "web-app/lambda"
# app var
PROJECT = os.environ.get('PROJECT', 'toronto-shared-bike')
APP = os.environ.get('APP', 'data-warehouse')
ENV = os.environ.get('ENV', 'dev')
AWS_REGION = os.environ.get('aws_region', 'ca-central-1')
# tb name
MV_TOPSTATION_USER_YEAR = f"{PROJECT}-{APP}-{ENV}-mv_top_station_user_year"


class TestStation(unittest.TestCase):
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
        cls.table_name = MV_TOPSTATION_USER_YEAR

        cls.dynamodb.create_table(
            TableName=cls.table_name,
            KeySchema=[{"AttributeName": "pk", "KeyType": "HASH"}],
            AttributeDefinitions=[
                {"AttributeName": "pk", "AttributeType": "S"}],
            BillingMode="PAY_PER_REQUEST",
        )

        station_tb = cls.dynamodb.Table(cls.table_name)
        station_tb.put_item(Item={"pk": "f28cba0b-7b49-4147-80d6-c4aaab83c451", "dim_year": "2019",
                            "trip_count": 17778, "dim_user": "annual", "dim_station": "Sherbourne St / Wellesley St E"})
        station_tb.put_item(Item={"pk": "f7033533-14b7-4f10-b2fa-0c8c0e17d807", "dim_year": "2019",
                            "trip_count": 13538, "dim_user": "casual", "dim_station": "York St / Queens Quay W"})
        station_tb.put_item(Item={"pk": "9df29c3c-4f61-4a2c-a86c-5523d2ad4ad3", "dim_year": "2020",
                            "trip_count": 16947, "dim_user": "annual", "dim_station": "Queens Quay E / Lower Sherbourne St"})
        station_tb.put_item(Item={"pk": "9712c0de-3a57-40b0-97dd-934639052351", "dim_year": "2020",
                            "trip_count": 19762, "dim_user": "casual", "dim_station": "Lake Shore Blvd W / Ontario Dr"})

        # Import your lambda handler
        sys.path.insert(0, LAMBDA_PATH)
        cls.target = importlib.import_module("main")

    @classmethod
    def tearDownClass(cls):
        # Stop the moto context once after all tests
        cls.mock.stop()

    # test case
    def test_top_station_all(self):
        # /top-station
        event = {
            "httpMethod": "GET",
            "path": "/top-station",
            "queryStringParameters": None
        }
        resp = self.target.lambda_handler(event, None)

        # status code
        self.assertEqual(resp["statusCode"], 200)
        # count
        body = json.loads(resp["body"])
        self.assertEqual(body["count"], 4)
        # data
        data = {(r["dim_year"], r["trip_count"]) for r in body["data"]}
        # data
        data = {(
            r["dim_year"],
            r["dim_user"],
            r["trip_count"],
            r["dim_station"]
        ) for r in body["data"]}
        self.assertEqual(
            data,
            {(2019, "annual", 17778, "Sherbourne St / Wellesley St E"),
                (2019, "casual", 13538, "York St / Queens Quay W"),
                (2020, "annual", 16947, "Queens Quay E / Lower Sherbourne St"),
                (2020, "casual", 19762, "Lake Shore Blvd W / Ontario Dr")}
        )

    def test_top_station_year(self):
        # /top-station?year=2019
        event = {
            "httpMethod": "GET",
            "path": "/top-station",
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
            r["dim_user"],
            r["trip_count"],
            r["dim_station"]
        ) for r in body["data"]}
        self.assertEqual(
            data,
            {(2019, "annual", 17778, "Sherbourne St / Wellesley St E"),
                (2019, "casual", 13538, "York St / Queens Quay W"), }
        )

    def test_top_station_user(self):
        # /top-station?user=casual
        event = {
            "httpMethod": "GET",
            "path": "/top-station",
            "queryStringParameters": {"user": "casual"},
        }
        resp = self.target.lambda_handler(event, None)

        # status code
        self.assertEqual(resp["statusCode"], 200)
        # count
        body = json.loads(resp["body"])
        print(body)
        self.assertEqual(body["count"], 2)

        # # data
        # data = {(
        #     r["dim_year"],
        #     r["dim_user"],
        #     r["trip_count"],
        #     r["dim_station"]
        # ) for r in body["data"]}
        # self.assertEqual(
        #     data,
        #     {(2019, "annual", 17778, "Sherbourne St / Wellesley St E"),
        #         (2020, "casual", 19762, "Lake Shore Blvd W / Ontario Dr")}
        # )
