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
  default = ["DEV","VAL","PRO"]
  }
variable "az1" {
  type = string 
  default = "us-east-1a"
  }
variable "ec2_instance_ami" {
  type = string
  default = ""
  }
variable "ec2_instance_type_human" {
    type =string
    default = ""
    }
variable "keyname" {
  type = string
  default = ""
  }
variable "DEV-frontend-nodes-public-ips" {
  type = string
  default="http://ciscomcd-l-mcd-pwubzyme-135f9644802a34bc.elb.us-east-1.amazonaws.com:8080/"
  }
variable "VAL-frontend-nodes-public-ips" {
  type = string
  default ="http://ciscomcd-l-mcd-pwubzyme-135f9644802a34bc.elb.us-east-1.amazonaws.com:8080/"
  }
variable "PRO-frontend-nodes-public-ips" {
  type = string
  default="http://ciscomcd-l-mcd-pwubzyme-135f9644802a34bc.elb.us-east-1.amazonaws.com:8080/"
  }

# ec2 instance type
variable "ec2_instance_type_human" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.small"
}

variable "humans" { 
  type = "list(string)"
  default =  ["Jonny The Dev", "Sarah the Val","Brandon The Ops"]
   }





