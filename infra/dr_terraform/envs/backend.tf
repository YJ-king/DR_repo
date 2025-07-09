terraform {
  backend "s3" {
    bucket  = "yjking-terraform-state"
    key     = "dr/envs/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}

