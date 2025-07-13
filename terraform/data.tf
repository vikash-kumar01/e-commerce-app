data "aws_ami" "os_image" {
  owners = ["099720109477"]
  filter {
    name   = "image-id"
    values = ["ami-020cba7c55df1f615"]
  }
}


