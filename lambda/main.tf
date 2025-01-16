data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir = "${path.module}/hello-world"

  output_path = "${path.module}/../../../tmp/hello-world.zip"
}

data "local_file" "lambda_hello_world" {
  filename = data.archive_file.lambda_hello_world.output_path
}

resource "aws_s3_object" "lambda_hello_world" {
  bucket = var.bucket_id

  key = "hello-world.zip"

  content_base64 = data.local_file.lambda_hello_world.content_base64

  etag = data.local_file.lambda_hello_world.content_md5
}

resource "random_pet" "lambda_function_name" {
  prefix = "hello-world-lambda-changed"
  length = 2
}

resource "aws_lambda_function" "hello_world" {
  function_name = random_pet.lambda_function_name.id

  s3_bucket = var.bucket_id
  s3_key = aws_s3_object.lambda_hello_world.key

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256

  runtime = "python3.9"
  handler = "hello.LambdaFunctions::Handler.process"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = random_pet.lambda_function_name.id

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

