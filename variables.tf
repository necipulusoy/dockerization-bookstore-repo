variable "provider-region" {
  type    = string
  default = "us-east-1"

}

variable "github-token" {
  type = string

}

variable "github-name" {
  type = string

}

variable "files" {
    default = ["bookstore-api.py", "Dockerfile", "docker-compose.yml", "requirements.txt"]
  
}

variable "server-name" {
  type = string

}

variable "instance_type" {
  type    = string
  default = "t2.micro"

}

variable "key_name" {
  type = string

}

variable "tag" {
  type    = string
  default = "Web Server of Bookstore"
}

variable "docker-instance-ports" {
  type        = list(number)
  description = "docker-instance-sec-gr-inbound-rules"
  default     = [22, 80]
}


variable "hosted-zone" {
  type = string

}