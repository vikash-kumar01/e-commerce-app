# resource "aws_security_group" "node_group_remote_access" {
#   name   = "allow HTTP"
#   vpc_id = var.vpc_id
#   ingress {
#     description = "port 22 allow"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     description = " allow all outgoing traffic "
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# module "eks" {

#   source  = "terraform-aws-modules/eks/aws"
#   version = "20.37.1"

#   cluster_name                    = var.cluster_name
#   cluster_version                 = "1.31"
#   cluster_endpoint_public_access  = false
#   cluster_endpoint_private_access = true

#   //access entry for any specific user or role (jenkins controller instance)
#   access_entries = {
#     # One access entry with a policy associated
#     example = {
#       principal_arn = "arn:aws:iam::${var.aws_account_id}:user/terraform"

#       policy_associations = {
#         example = {
#           policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#           access_scope = {
#             type = "cluster"
#           }
#         }
#       }
#     }
#   }


#   cluster_security_group_additional_rules = {
#     access_for_bastion_jenkins_hosts = {
#       cidr_blocks = ["0.0.0.0/0"]
#       description = "Allow all HTTPS traffic from jenkins and Bastion host"
#       from_port   = 443
#       to_port     = 443
#       protocol    = "tcp"
#       type        = "ingress"
#     }
#   }


#   cluster_addons = {
#     coredns = {
#       most_recent = true
#     }
#     kube-proxy = {
#       most_recent = true
#     }
#     vpc-cni = {
#       most_recent = true
#     }
#   }

#   vpc_id                   = var.vpc_id
#   subnet_ids               = var.public_subnets
#   control_plane_subnet_ids = var.private_subnets

#   # EKS Managed Node Group(s)

#   eks_managed_node_group_defaults = {

#     instance_types = ["t3.large"]

#     attach_cluster_primary_security_group = true

#   }



#   eks_managed_node_groups = {

#     mrdevops-demo-ng = {
#       min_size     = 1
#       max_size     = 3
#       desired_size = 1

#       instance_types = ["t3.large"]
#       capacity_type  = "SPOT"

#       disk_size                  = 35
#       use_custom_launch_template = false # Important to apply disk size!

#       remote_access = {
#         ec2_ssh_key               = var.key_name
#         source_security_group_ids = [aws_security_group.node_group_remote_access.id]
#       }

#       tags = {
#         Name        = "mrdevops-demo-ng"
#         Environment = "dev"
#         ExtraTag    = "e-commerce-app"
#       }
#     }
#   }

#   tags = var.tags


# }

# data "aws_instances" "eks_nodes" {
#   instance_tags = {
#     "eks:cluster-name" = var.cluster_name
#   }

#   filter {
#     name   = "instance-state-name"
#     values = ["running"]
#   }

#   depends_on = [module.eks]
# }


resource "aws_security_group" "cluster" {
  name        = "eks-cluster-sg"
  description = "EKS Cluster security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all HTTPS traffic from Jenkins and Bastion host"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "node_group_remote_access" {
  name   = "eks-node-group-ssh"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}

data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role_policy.json
}

data "aws_iam_policy_document" "eks_node_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_security_group.cluster.id]
  }

  tags = var.tags
}

resource "aws_eks_node_group" "mrdevops_demo_ng" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.public_subnets

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.large"]
  disk_size      = 35
  capacity_type  = "SPOT"

  remote_access {
    ec2_ssh_key               = var.key_name
    source_security_group_ids = [aws_security_group.node_group_remote_access.id]
  }

  tags = {
    Name        = "mrdevops-demo-ng"
    Environment = "dev"
    ExtraTag    = "e-commerce-app"
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"
}

data "aws_instances" "eks_nodes" {
  instance_tags = {
    "eks:cluster-name" = var.cluster_name
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [aws_eks_node_group.mrdevops_demo_ng]
}