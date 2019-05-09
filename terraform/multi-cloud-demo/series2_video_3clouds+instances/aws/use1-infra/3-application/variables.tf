variable "azs" {
  type = "list"

  default = [
    "us-east-1a",
    "us-east-1b",
  ]
}

variable "db_password" {
  default = "etad3nzmDKG8gA"
}

variable "filename" {
  default = "cloud-config.cfg"
}
