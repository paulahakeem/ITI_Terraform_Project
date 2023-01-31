vpc_cidr    = "10.0.0.0/16"
vpc_name    = "MainVpc"
subnet_cidr = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#              [public1]        [public2]       [private1]      [private2]
zone1              = "us-east-1a"
zone2              = "us-east-1b"
cidr_from_anywhere = "0.0.0.0/0"
vm_type            = "t2.micro"
ami_id             = "ami-00874d747dde814fa"
# provisiondata =
#       ["sudo apt update -y",
#       "sudo apt install -y nginx",
#       "echo 'server { \n listen 80 default_server; \n  listen [::]:80 default_server; \n  server_name _; \n  location / { \n  proxy_pass http://${module.network.pivatedns}; \n  } \n}' > default",
#       "sudo mv default /etc/nginx/sites-enabled/default",
#       "sudo systemctl stop nginx",
#       "sudo systemctl start nginx"]
  