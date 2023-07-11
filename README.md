## Template Repository: Python 3.9  + Terraform 1.5.2 (AWS)
This is a template repository for a Python 3.9 project that includes Terraform infrastructure setup on AWS cloud.  

The repository is pre-configured with pre-commit hooks that run black, flake8, mypy, and Terraform linters to ensure code consistency and quality.

The Python source files are located in the `src` directory.  

The tests created using pytest are located in the tests directory, and the Terraform configuration is in the `infra/terraform` directory.

### Prerequisites

- python 3.9.16
- terraform 1.5.2

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
