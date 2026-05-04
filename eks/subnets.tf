# private subnet 1
resource "aws_subnet" "private_zone1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = local.zone1

  tags = {
    "Name"                                                 = "${local.env}-private-${local.zone1}"
    "kubernetes.io/role/internal-alb"                      = "1" # Special tag used by EKS to create private load balancers
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
    #  kubernetes.io/cluster/clustername Optional but recommended if you want to provision multiple eks clusters in a single account , value can be with owned or shared

  }
}

# private subnet 2

resource "aws_subnet" "private_zone2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = local.zone2

  tags = {
    "Name"                                                 = "${local.env}-private-${local.zone2}"
    "kubernetes.io/role/internal-alb"                      = "1" # Special tag used by EKS to create private load balancers
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
    #  kubernetes.io/cluster/clustername Optional but recommended if you want to provision multiple eks clusters in a single account , value can be with owned or shared

  }
}

# public subnet 1

resource "aws_subnet" "public_zone1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = local.zone1
  map_public_ip_on_launch = true # Some services and VM's require public IP addresses so enable this

  tags = {
    Name                                                   = "${local.env}-public-${local.zone1}"
    "kubernetes.io/role/elb"                               = "1" # to create eks clusters in public subnet
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"

  }
}

# public subnet 2

resource "aws_subnet" "public_zone2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = local.zone2
  map_public_ip_on_launch = true # Some services and VM's require public IP addresses so enable this

  tags = {
    Name                                                   = "${local.env}-public-${local.zone2}"
    "kubernetes.io/role/elb"                               = "1" # to create eks clusters in public subnet
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"

  }
}


