## Template Repository: AWS Lambda microservice

### Tools

|         | Application | IaaC        |
|---------|-------------|-------------|
| Tool    | Python      | Terraform   |
| Version | 3.9         | 1.5.2 (AWS) |


### Setup
The goal of this template is to provide:
 - python linters setup (black, isort, flake8) using pre-commit
 - python microservice structure using [aws_lambda_powertools](https://github.com/aws-powertools/powertools-lambda-python)
 - testing setup using pytest
 - Cloud infrastructure (AWS) using IaaC (Terraform)
 - Terraform linters
 - Github Actions workflows to run tests, linters and execute Terraform 


### Usage

Clone the repository to your local machine.

#### Python setup

Create a virtual environment

```shell
python -v venv .venv
source .venv/bin/active
```

Install dependencies:

```shell
python -m pip install -r requirements-dev.txt
```

#### Pre-commit

```shell
pre-commit install
pre-commit run --all-files
```

This will run black, flake8, mypy, and Terraform linters on all files in the repository.


#### Terraform setup

Navigate to the infra/terraform directory and run terraform init to initialize the Terraform configuration.

```shell
cd infra/terraform
terraform init
```

These commands will create the infrastructure specified in the Terraform configuration.

```shell
terraform plan
terraform apply
```

Run pre-commit for the Terraform configuration

Install tflint: https://github.com/terraform-linters/tflint

```shell
pre-commit run -a terraform
```


### Testing

To run the tests, you can use the following command:

```shell
pytest
```

You can also use the -v option to get more detailed output:

```shell
pytest -v
```
