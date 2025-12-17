data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


locals {
  user_data = <<-EOF
    #!/bin/bash
    # Script d'installation automatique de Nginx
    
    # Mise à jour du système
    yum update -y
    
    # Installation de Nginx
    yum install nginx -y
    
    # Création d'une page d'accueil personnalisée
    cat > /usr/share/nginx/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
        <title>Mon Architecture AWS</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                color: white;
            }
            .container {
                text-align: center;
                background: rgba(255, 255, 255, 0.1);
                padding: 40px;
                border-radius: 15px;
                backdrop-filter: blur(10px);
            }
            h1 { font-size: 2.5em; margin-bottom: 20px; }
            p { font-size: 1.2em; }
            .info { margin-top: 30px; font-size: 0.9em; opacity: 0.8; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Architecture AWS Terraform</h1>
            <p>Serveur Web Nginx déployé avec succès!</p>
            <p>Instance dans AZ-B (Public Subnet 2)</p>
            <div class="info">
                <p>Projet étudiant - Bachelier 3 Informatique</p>
                <p>VPC: 10.0.0.0/16 | Subnet: 10.0.2.0/24</p>
            </div>
        </div>
    </body>
    </html>
    HTML
    
    # Démarrage et activation de Nginx au démarrage
    systemctl start nginx
    systemctl enable nginx
    
    # Création d'un fichier de vérification
    echo "Nginx installed successfully at $(date)" > /var/log/nginx-install.log
  EOF
}


resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[1].id  
  vpc_security_group_ids = [aws_security_group.web_server.id]
  
  
  user_data = local.user_data
  
  
  root_block_device {
    volume_size           = 30  
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }
  
  
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"  
    http_put_response_hop_limit = 1
  }
  
  tags = {
    Name = "${var.project_name}-web-server-1"
    Role = "WebServer"
    AZ   = var.availability_zones[1]
  }
}