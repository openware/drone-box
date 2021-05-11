variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "region" {
  default = "eu-west-1"
}

variable "source_ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "ssh_private_key_path" {
  type = string
  default = "./config/secrets/deploy.key"
}

variable "ssh_public_key_path" {
  type = string
  default = "./config/secrets/deploy.key.pub"
}

variable "ssh_user" {
  type        = string
  description = "Name of the SSH user to use"
  default     = "admin"
}

variable "volume_type" {
  type = string
}

variable "volume_size" {
  type = string
}
