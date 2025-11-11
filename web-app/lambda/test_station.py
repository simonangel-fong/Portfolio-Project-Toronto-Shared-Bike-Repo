import os
import sys
import json
import boto3
import unittest
import importlib
from moto import mock_aws

# lambda path
LAMBDA_PATH = "../"
# app var
PROJECT = os.environ.get('PROJECT', 'toronto-shared-bike')
APP = os.environ.get('APP', 'data-warehouse')
ENV = os.environ.get('ENV', 'dev')
AWS_REGION = os.environ.get('aws_region', 'ca-central-1')
# tb name
MV_STATION_YEAR = f"{PROJECT}-{APP}-{ENV}-mv_station_year"


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
        cls.table_name = MV_STATION_YEAR

        cls.dynamodb.create_table(
            TableName=cls.table_name,
            KeySchema=[{"AttributeName": "pk", "KeyType": "HASH"}],
            AttributeDefinitions=[
                {"AttributeName": "pk", "AttributeType": "S"}],
            BillingMode="PAY_PER_REQUEST",
        )

        station_tb = cls.dynamodb.Table(cls.table_name)
        station_tb.put_item(Item={"pk": "65e08285-6dd5-4826-b67b-964caabd770e","dim_year": 2019, "station_count": 469})
        station_tb.put_item(Item={"pk": "bb44d3ba-bdd6-41cf-8291-f68be2239c54","dim_year": 2020, "station_count": 611})
        station_tb.put_item(Item={"pk": "5090dcec-7282-441c-86da-c3bee8608160","dim_year": 2021, "station_count": 627})
        station_tb.put_item(Item={"pk": "2d4295c7-cc4b-47b5-90e0-3e50764353de","dim_year": 2022, "station_count": 682})

        # Import your lambda handler
        sys.path.insert(0, LAMBDA_PATH)
        cls.target = importlib.import_module("main")

    @classmethod
    def tearDownClass(cls):
        # Stop the moto context once after all tests
        cls.mock.stop()

    # test case
    def test_station_all(self):
        # /station
        event = {
            "httpMethod": "GET",
            "path": "/station",
            "queryStringParameters": None
        }
        resp = self.target.lambda_handler(event, None)

        # status code
        self.assertEqual(resp["statusCode"], 200)
        # count
        body = json.loads(resp["body"])
        self.assertEqual(body["count"], 4)
        # data
        data = {(r["dim_year"], r["station_count"]) for r in body["data"]}
        self.assertEqual(
            data,
            {(2019, 469), (2020, 611), (2021, 627), (2022, 682)}
        )

    def test_station_year(self):
        # /station?year=2019
        event = {
            "httpMethod": "GET",
            "path": "/station",
            "queryStringParameters": {"year": 2019},
        }
        resp = self.target.lambda_handler(event, None)

        # status code
        self.assertEqual(resp["statusCode"], 200)
        # count
        body = json.loads(resp["body"])
        self.assertEqual(body["count"], 1)

        # data
        records = body["data"]
        self.assertEqual(len(records), 1)
        self.assertEqual(records[0]["dim_year"], 2019)
        self.assertEqual(records[0]["station_count"], 469)
