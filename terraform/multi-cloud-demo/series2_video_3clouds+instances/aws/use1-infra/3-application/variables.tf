variable "azs" {
  type = "list"

  default = [
    "us-east-1a",
    "us-east-1b",
  ]
}

variable "vpc_id" {
  default = "vpc-0e6fac0fe39c0db00"
}
