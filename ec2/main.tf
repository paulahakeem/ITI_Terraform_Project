resource "aws_instance" "publicvm1" {
 ami           = var.ami_id
 instance_type = var.vm_type
 associate_public_ip_address = true
 subnet_id = var.publicsubnet1-id
 vpc_security_group_ids = [var.securitygroupid]
 key_name = "paula_key"
 tags = {
    Name = "publicvm1"
  }
 provisioner "local-exec" {
  when = create
   command = "echo public_ip1  ${self.public_ip} >> ./public_ip.txt"
 }
 provisioner "remote-exec" {
    inline = var.provisionerdata
     connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("./ec2/paula_key.pem")
      host = self.public_ip
    }
  }
}

resource "aws_instance" "publicvm2" {
 ami           = var.ami_id
  instance_type = var.vm_type
  associate_public_ip_address = true
  subnet_id = var.publicsubnet2-id
  vpc_security_group_ids = [var.securitygroupid]
  key_name = "paula_key"
  tags = {
    Name = "publicvm2"
  }
  provisioner "local-exec" {
    when = create
   command = "echo public_ip2  ${self.public_ip} >> ./public_ip.txt"
 }
 connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("./ec2/paula_key.pem")
      host = self.public_ip
    }

 provisioner "remote-exec" {
    inline =         var.provisionerdata 
  }
}

resource "aws_instance" "privatevm1" {
 ami           = var.ami_id
  instance_type = var.vm_type
  associate_public_ip_address = false
  subnet_id = var.privatesubnet1-id
  vpc_security_group_ids = [var.securitygroupid]
  tags = {
    Name = "privatevm2"
  }
  
  user_data = file("ec2/install.sh")

}

resource "aws_instance" "privatevm2" {
 ami           = var.ami_id
  instance_type = var.vm_type
  associate_public_ip_address = false
  subnet_id = var.privatesubnet2-id
  vpc_security_group_ids = [var.securitygroupid]
  tags = {
    Name = "privatevm2"
  }
  
  user_data = file("ec2/install.sh")
}
