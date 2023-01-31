vpc_cidr    = "10.0.0.0/16"
vpc_name    = "paula-vpc"
subnet_cidr = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#              [public1]        [public2]       [private1]      [private2]
zone1              = "us-east-1a"
zone2              = "us-east-1b"
cidr_from_anywhere = "0.0.0.0/0"