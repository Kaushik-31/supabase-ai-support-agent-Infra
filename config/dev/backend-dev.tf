terraform {
  backend "s3" {
    bucket         = "terraform-state-ACCOUNT_ID-dev"
    key            = "supabase-chatbot/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-dev"
  }
}
