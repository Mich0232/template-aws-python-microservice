from aws_lambda_powertools import Logger, Metrics, Tracer
from aws_lambda_powertools.event_handler import APIGatewayHttpResolver
from aws_lambda_powertools.logging import correlation_paths
from aws_lambda_powertools.metrics import MetricUnit
from aws_lambda_powertools.utilities.typing import LambdaContext

logger = Logger(service="ExampleApp")
tracer = Tracer(service="ExampleApp")
metrics = Metrics(namespace="Examples", service="ExampleApp")
app = APIGatewayHttpResolver()


@app.get("/hello/<name>")
@tracer.capture_method
def hello_name(name):
    tracer.put_annotation(key="User", value=name)
    logger.info(f"Request from {name} received")
    metrics.add_metric(name="SuccessfulGreetings", unit=MetricUnit.Count, value=1)
    return {"message": f"hello {name}!"}


@app.get("/hello")
@tracer.capture_method
def hello():
    tracer.put_annotation(key="User", value="unknown")
    logger.info("Request from unknown received")
    metrics.add_metric(name="SuccessfulGreetings", unit=MetricUnit.Count, value=1)
    return {"message": "hello unknown!"}


@tracer.capture_lambda_handler
@logger.inject_lambda_context(
    correlation_id_path=correlation_paths.API_GATEWAY_HTTP, log_event=True
)
def lambda_handler(event, context: LambdaContext):
    try:
        return app.resolve(event, context)
    except Exception as e:
        logger.exception(e)
        raise
