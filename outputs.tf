output "instance_public_ip" {
  value = "http://${aws_instance.tfmyec2.public_ip}"
}

output "websiteurl" {
  value = aws_route53_record.bookstore.name
}