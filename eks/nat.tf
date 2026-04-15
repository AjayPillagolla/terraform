# to provide internet access to private subnets

# create a static public ip manually to be used in Nat aws_internet_gateway

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${local.env}-nat"
  }

}

resource "aws_nat_gateway" "nat" {
 allocation_id = aws_eip.nat.id
 subnet_id = aws_subnet.public_zone1.id

 depends_on = [aws_internet_gateway.igw]

 tags = {
    Name ="${local.env}-nat"
 }
}