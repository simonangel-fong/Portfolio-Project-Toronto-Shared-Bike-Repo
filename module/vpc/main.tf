resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project}-${var.app}-${var.env}-vpc"
  }
}

output "aws_vpc_id" {
  value = aws_vpc.vpc.id
}
