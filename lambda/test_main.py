import pytest
import main
import json

@pytest.fixture
def mock_dynamodb(monkeypatch):
    class MockTable:
        def scan(self, **kwargs):
            # Simulate filtering by year if FilterExpression is present
            if 'FilterExpression' in kwargs:
                return {'Items': [{'pk': '1', 'bike_count': 100, 'dim_year': 2019}]}
            return {'Items': [
                {'pk': '1', 'bike_count': 100, 'dim_year': 2019},
                {'pk': '2', 'bike_count': 200, 'dim_year': 2020}
            ]}
    class MockDynamoDB:
        def Table(self, name):
            return MockTable()
    monkeypatch.setattr(main, "dynamodb", MockDynamoDB())

def test_options_request():
    event = {
        'httpMethod': 'OPTIONS',
        'path': '/mv_bike_count'
    }
    response = main.lambda_handler(event, None)
    assert response['statusCode'] == 204
    assert 'Access-Control-Allow-Origin' in response['headers']

def test_get_mv_bike_count(mock_dynamodb):
    event = {
        'httpMethod': 'GET',
        'path': '/mv_bike_count'
    }
    response = main.lambda_handler(event, None)
    assert response['statusCode'] == 200
    assert 'Access-Control-Allow-Origin' in response['headers']
    items = json.loads(response['body'])
    assert isinstance(items, list)
    assert any(item['pk'] == '1' for item in items)

def test_get_mv_bike_count_with_year(mock_dynamodb):
    event = {
        'httpMethod': 'GET',
        'path': '/mv_bike_count',
        'queryStringParameters': {'year': '2019'}
    }
    response = main.lambda_handler(event, None)
    assert response['statusCode'] == 200
    items = json.loads(response['body'])
    assert isinstance(items, list)
    assert all(item['dim_year'] == 2019 for item in items)

def test_unsupported_path():
    event = {
        'httpMethod': 'GET',
        'path': '/unknown_path'
    }
    response = main.lambda_handler(event, None)
    assert response['statusCode'] == 404
    assert response['body'] == 'Not Found'