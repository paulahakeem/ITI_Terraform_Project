module "network" {
  source             = "./network"
  vpc_cidr           = var.vpc_cidr
  vpc_name           = var.vpc_name
  subnets_cidr       = var.subnet_cidr
  az1                = var.zone1
  az2                = var.zone2
  cidr_from_anywhere = var.cidr_from_anywhere
  publicvmid1  = module.ec2.publicvmid1
  publicvmid2  = module.ec2.publicvmid1
  privatevmid1 = module.ec2.privatevmid1
  privatevmid2 = module.ec2.privatevmid2


}
module "ec2" {
  source          = "./ec2"
  ami_id          = var.ami_id
  vm_type         = var.vm_type
  securitygroupid = module.network.secgroupid
  publicsubnet1      = module.network.public_subnet_id1
  publicsubnet2      = module.network.public_subnet_id2
  privatesubnet1     = module.network.private_subnet_id1
  privatesubnet2     = module.network.private_subnet_id2



  # provisionerdata = var.provisiondata
}