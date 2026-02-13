locals {
  availability_zones = toset(slice(data.aws_availability_zones.azs.names, 0, var.number_of_azs))
}