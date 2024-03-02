variable "vpc_corporate_office_cidr_block" { 
    type = string
    default = "10.21.0.0/24"
}
variable "tenant_cidr" {
  type = string
  default = "10.0.0.0/16" 
}
variable "application_name" { 
  type = string
  default = "TEASHOP" 
}
variable "tfrun_identifier" {
  type = string
  default = "test_human"
}
variable "environment_list" {
  type = list(string) 
  default = ["DEV"]
  #,"VAL","PRO"]
}
variable "az1" {
  type = string 
  default = "us-east-1a"
}
variable "ec2_instance_ami" {
  type = string
  default =     "ami-0c7217cdde317cfec"
}
variable "keyname"{
  description = "name of RSA Key to use to connect Terraform to EC2 instances"
  type = string
  default = "terraform-key-devops-admin-ubuntu"
}
variable "DEV-frontend-nodes-public-ips" {
  type = string
  default="ciscomcd-l-mcd-fryvyect-def871c80a917fb2.elb.us-east-1.amazonaws.com"
}
variable "VAL-frontend-nodes-public-ips" {
  type = string
  default ="ciscomcd-l-mcd-fryvyect-def871c80a917fb2.elb.us-east-1.amazonaws.com"
}
variable "PRO-frontend-nodes-public-ips" {
  type = string
  default="ciscomcd-l-mcd-fryvyect-def871c80a917fb2.elb.us-east-1.amazonaws.com"
}
variable "ec2_instance_type_human" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.small"
}
variable "humans" { 
  type = list(string)
  default =  ["JonnyTheDev", "SarahtheVal","BrandonTheOps"]
}
