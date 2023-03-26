config {
  module = true
  force = false
  disabled_by_default = false
}

plugin "terraform" {
    enabled = true
    preset = "all"
    version = "0.2.2"
    source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

plugin "aws" {
    enabled = true
    version = "0.22.1"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
