terraform {
  backend "s3" {
    bucket         = "dream-vacations-capstone-tfstate"
    key            = "capstone/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "dream-vacations-capstone-tf-locks"
    encrypt        = true
  }
}
