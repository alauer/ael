variable "azs" {
  type = "list"

  default = [
    "us-east-1a",
    "us-east-1b",
  ]
}

variable "vpc_id" {
  default = "vpc-02380157a9220e983"
}

variable "db_password" {
  default = "etad3nzm>DK$G8gA"
}
