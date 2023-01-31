#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Terraform_Deployed_by_paula$(hostname -f)</h1>" | sudo tee /var/www/html/index.html