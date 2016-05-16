output "launch_configuration" {
  value = "${aws_instance.radius.public_ip}"
}
