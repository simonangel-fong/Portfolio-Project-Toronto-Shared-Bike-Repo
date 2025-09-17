import os
import json
import importlib
import boto3
from moto import mock_aws

def test_bike_no_params():
    with mock_aws():
        # configure Env var
        os.environ["AWS_ACCESS_KEY_ID"] = "testing"
        os.environ["AWS_SECRET_ACCESS_KEY"] = "testing"
        os.environ["AWS_SESSION_TOKEN"] = "testing"
        os.environ["AWS_DEFAULT_REGION"] = "us-east-1"
        os.environ["PROJECT"] = "toronto-shared-bike"
        os.environ["APP"] = "data-warehouse"
        os.environ["ENV"] = "dev"

        # Create the table
        ddb = boto3.resource("dynamodb", region_name="us-east-1")
        table_name = f'{os.environ["PROJECT"]}-{os.environ["APP"]}-{os.environ["ENV"]}-mv_bike_year'
        ddb.create_table(
            TableName=table_name,
            KeySchema=[{"AttributeName": "dim_year", "KeyType": "HASH"}],
            AttributeDefinitions=[{"AttributeName": "dim_year", "AttributeType": "N"}],
            BillingMode="PAY_PER_REQUEST",
        )
        tbl = ddb.Table(table_name)
        
        # Seed a couple of rows
        tbl.put_item(Item={"dim_year": 2023, "bike_count": 1200})
        tbl.put_item(Item={"dim_year": 2024, "bike_count": 1500})

        # Import AFTER env + tables exist so boto3 points at Moto
        import main as sut
        importlib.reload(sut)

        # Call the handler: GET /bike with no query params
        event = {"httpMethod": "GET", "path": "/bike", "queryStringParameters": None}
        resp = sut.lambda_handler(event, None)

        # Assert
        assert resp["statusCode"] == 200
        body = json.loads(resp["body"])
        assert body["count"] == 2
        got = {(r["dim_year"], r["bike_count"]) for r in body["data"]}
        assert got == {(2023, 1200), (2024, 1500)}
