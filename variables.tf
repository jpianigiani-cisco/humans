variable "vpc_corporate_office_cidr_block" { type = string}
variable "tenant_cidr" {type = "string"}
variable "humans" { type = list(string)}
variable "application_name" { type = "string"}
variable "tfrun_identifier" {type = "string"}
variable "environment_list" {type = list(string)}
variable "az1" {type = "string"}
variable "ec2_instance_ami" {type = "string"}
variable "ec2_instance_type_human" {type = "string"}
variable "keyname" {type = "string"}
variable "DEV-frontend-nodes-public-ips" {type = "string"}
variable "VAL-frontend-nodes-public-ips" {type = "string"}
variable "PRO-frontend-nodes-public-ips" {type = "string"}

# ec2 instance type
variable "ec2_instance_type_human" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.small"
}

variable "humans" { default =  ["Jonny The Dev", "Sarah the Val","Brandon The Ops"] }





