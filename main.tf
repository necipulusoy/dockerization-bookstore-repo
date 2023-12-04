resource "github_repository" "myrepo" {
    name = "dockerization-bookstore-repo"
    auto_init = true  
    visibility = "public"
}

resource "github_branch_default" "main" {
    branch = "main"
    repository = github_repository.myrepo.name  
}

resource "github_repository_file" "myfiles" {
    for_each = toset(var.files)    
    content = file(each.value)
    file = each.value
    repository = github_repository.myrepo.name
    commit_message = "managed by terraform"
    overwrite_on_create = true
    branch = "main"

}

data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "template_file" "userdata" {
  template = file("user-data.sh")
  vars = {
    user-data-github-token = var.github-token
    user-data-github-name  = var.github-name
    server-name            = var.server-name
  }
}

resource "aws_instance" "tfmyec2" {
  ami = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
  user_data = base64encode(data.template_file.userdata.rendered)
  depends_on = [ github_repository_file.myfiles ]
  tags = {
    Name = var.tag
  }
}

resource "aws_security_group" "tf-sec-gr" {
  name = "${var.tag}-terraform-sec-grp"
  tags = {
    Name = var.tag
  }

  dynamic "ingress" {
    for_each = var.docker-instance-ports
    iterator = port
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port =0
    protocol = "-1"
    to_port =0
    cidr_blocks = ["0.0.0.0/0"]
  }
} 

data "aws_route53_zone" "selected" {
  name = var.hosted-zone
}

resource "aws_route53_record" "bookstore" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "bookstore.${var.hosted-zone}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.tfmyec2.public_ip]  
}