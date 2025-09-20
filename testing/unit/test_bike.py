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
AWS_REGION = os.environ.get('AWS_REGION', 'ca-central-1')
# tb name
MV_BIKE_YEAR = f"{PROJECT}-{APP}-{ENV}-mv_bike_year"


class TestBike(unittest.TestCase):
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
        cls.table_name = MV_BIKE_YEAR

        cls.dynamodb.create_table(
            TableName=cls.table_name,
            KeySchema=[{"AttributeName": "pk", "KeyType": "HASH"}],
            AttributeDefinitions=[
                {"AttributeName": "pk", "AttributeType": "S"}],
            BillingMode="PAY_PER_REQUEST",
        )

        bike_tb = cls.dynamodb.Table(cls.table_name)
        bike_tb.put_item(Item={
                         "pk": "12af2191-d6f6-4caf-8ac6-6f9ae03eca46", "dim_year": 2019, "bike_count": 4901})
        bike_tb.put_item(Item={
                         "pk": "c9110fb1-83b9-4cb3-a92c-310bb5bb6ca8", "dim_year": 2020, "bike_count": 6759})
        bike_tb.put_item(Item={
                         "pk": "0072cc01-6036-451d-8cc6-5498faa67818", "dim_year": 2021, "bike_count": 6499})
        bike_tb.put_item(Item={
                         "pk": "a8eca7ef-c283-4b4b-8bfb-065847325f1f", "dim_year": 2022, "bike_count": 6829})

        # Import your lambda handler
        sys.path.insert(0, LAMBDA_PATH)
        cls.target = importlib.import_module("main")

    @classmethod
    def tearDownClass(cls):
        # Stop the moto context once after all tests
        cls.mock.stop()

    # test case
    def test_bike_all(self):
        # /bike
        event = {
            "httpMethod": "GET",
            "path": "/bike",
            "queryStringParameters": None
        }
        resp = self.target.lambda_handler(event, None)

        # status code
        self.assertEqual(resp["statusCode"], 200)
        # count
        body = json.loads(resp["body"])
        self.assertEqual(body["count"], 4)
        # data
        data = {(r["dim_year"], r["bike_count"]) for r in body["data"]}
        self.assertEqual(
            data,
            {(2019, 4901), (2020, 6759), (2021, 6499), (2022, 6829)}
        )

    def test_bike_year(self):
        # /bike?year=2019
        event = {
            "httpMethod": "GET",
            "path": "/bike",
            "queryStringParameters": {"year": 2019},
        }
        resp = self.target.lambda_handler(event, None)
        print(resp)

        # status code
        self.assertEqual(resp["statusCode"], 200)
        # count
        body = json.loads(resp["body"])
        self.assertEqual(body["count"], 1)

        # data
        records = body["data"]
        self.assertEqual(len(records), 1)
        self.assertEqual(records[0]["dim_year"], 2019)
        self.assertEqual(records[0]["bike_count"], 4901)
