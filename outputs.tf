output "launch_configuration" {
  value = "${aws_autoscaling_group.radius.launch_configuration}"
}
