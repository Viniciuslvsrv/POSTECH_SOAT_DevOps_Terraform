provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "fiap_vpc" {
  id = "vpc-02c2ba60989faba37"
}

resource "aws_subnet" "subnet_1" {
  id                 = "subnet-001a52e2c24572b0f"
  vpc_id             = aws_vpc.fiap_vpc.id
  cidr_block         = "172.31.0.0/20"
  availability_zone  = "us-east-1d"
}

resource "aws_subnet" "subnet_2" {
  id                 = "subnet-0544588be5ae9de4d"
  vpc_id             = aws_vpc.fiap_vpc.id
  cidr_block         = "172.31.32.0/20"
  availability_zone  = "us-east-1c"
}

resource "aws_subnet" "subnet_3" {
  id                 = "subnet-0d9acc67474146986"
  vpc_id             = aws_vpc.fiap_vpc.id
  cidr_block         = "172.31.16.0/20"
  availability_zone  = "us-east-1b"
}

resource "aws_eks_cluster" "fiap_eks_cluster" {
  name     = "fiap-tech-challenge"
  role_arn = "arn:aws:iam::581324664826:role/LabRole"

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_1.id,
      aws_subnet.subnet_2.id,
      aws_subnet.subnet_3.id,
    ]
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  kubernetes_version = "1.31"

  logging {
    cluster_logging = [
      {
        types   = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
        enabled = false
      },
    ]
  }
}
