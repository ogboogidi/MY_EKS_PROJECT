locals {
  eks_tags = {
    project     = "eks_cluster"
    application = "kubernetes.io"
    environment = "dev"
  }

}