# Terraform
###The infrastructure contains:

- VPC with 4 subnets 2 public and 2 private in 2 different AZS

- NAT gateway in a public subnet

- Internet gateway and an external facing LB to route traffic to 2 Public EC2s that acts as nginx proxy

- The Proxy forwards traffic to an internal facing LB that routes traffic between 2 Private EC2s which hosts your Application

- All routing tables and security groups are included

- Backend to make statefile remotely stored in a bucket for state lock
