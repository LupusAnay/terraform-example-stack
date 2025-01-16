identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment "development" {
  inputs = {
    regions = ["eu-central-1"]
    role_arn = "arn:aws:iam::636264994951:role/stacks-henculus-stacks-example"
    identity_token = identity_token.aws.jwt
    default_tags = { terraform-example-stack = "terraform-example-stack" }
  }
}
