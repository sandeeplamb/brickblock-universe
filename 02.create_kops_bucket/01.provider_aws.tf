provider "aws" {
  region 		= "${var.my_region}"
  access_key 		= "${var.my_secret}"
  secret_key 		= "${var.my_secret_key}"
}

