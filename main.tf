module "network" {
  source             = "./network"
  vpc_cidr           = var.vpc_cidr
  vpc_name           = var.vpc_name
  subnets_cidr       = var.subnet_cidr
  az1                = var.zone1
  az2                = var.zone2
  cidr_from_anywhere = var.cidr_from_anywhere

}
module "ec2" {
  source       = "./ec2"
  mysubnet1-id = module.network.subnet_id1
}