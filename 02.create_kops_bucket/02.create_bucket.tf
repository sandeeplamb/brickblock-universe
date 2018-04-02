resource "aws_s3_bucket" "starLordKopsBucketBB" {
  bucket 	= "starlordkopsbucketbb"
  acl    	= "private"

  tags {
    name 	= "starLordKopsBucketBB"
    TF  	= "Made-From-Terraform"
    purpose  	= "kops-state-storage"
  }
}

