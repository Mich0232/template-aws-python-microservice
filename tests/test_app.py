from dataclasses import dataclass

import pytest

from src import app


@pytest.fixture
def lambda_context():
    @dataclass
    class LambdaContext:
        function_name: str = "test"
        memory_limit_in_mb: int = 128
        invoked_function_arn: str = (
            "arn:aws:lambda:eu-west-1:123456789012:function:test"
        )
        aws_request_id: str = "da658bd3-2d6f-4e7b-8ec2-937234644fdc"

    return LambdaContext()


@pytest.fixture
def name():
    return "john"


def test_lambda_handler(lambda_context):
    minimal_event = {
        "rawPath": "/hello",
        "requestContext": {
            "requestContext": {
                "requestId": "227b78aa-779d-47d4-a48e-ce62120393b8"
            },  # correlation ID
            "http": {
                "method": "GET",
            },
            "stage": "$default",
        },
    }
    # Example of API Gateway HTTP API request event:
    # https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-lambda.html

    ret = app.lambda_handler(minimal_event, lambda_context)
    assert ret["statusCode"] == 200
    assert ret["body"] == '{"message":"hello unknown!"}'


def test_hello_name(lambda_context, name):
    minimal_event = {
        "rawPath": f"/hello/{name}",
        "requestContext": {
            "requestContext": {"requestId": "227b78aa-779d-47d4-a48e-ce62120393b8"},
            "http": {
                "method": "GET",
            },
            "stage": "$default",
        },
    }

    ret = app.lambda_handler(minimal_event, lambda_context)
    assert ret["statusCode"] == 200
    assert ret["body"] == f'{{"message":"hello {name}!"}}'


def test_404_not_found(lambda_context):
    minimal_event = {
        "rawPath": "/nonexistingpath",
        "requestContext": {
            "requestContext": {"requestId": "227b78aa-779d-47d4-a48e-ce62120393b8"},
            "http": {
                "method": "GET",
            },
            "stage": "$default",
        },
    }

    ret = app.lambda_handler(minimal_event, lambda_context)
    assert ret["statusCode"] == 404
    assert ret["body"] == '{"statusCode":404,"message":"Not found"}'


def test_500_exception(lambda_context):
    minimal_event = {"rawPath": "/partialevent"}

    with pytest.raises(KeyError):
        app.lambda_handler(minimal_event, lambda_context)
