terraform {
  backend "s3" {
    bucket = "genai-devops-terraform-state-030901817847"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
