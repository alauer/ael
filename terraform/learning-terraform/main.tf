provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  }
  region = "us-east-2"
}
