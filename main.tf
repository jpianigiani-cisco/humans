locals{
    corporate_subnets_list_vpc = cidrsubnets(var.vpc_corporate_office_cidr_block,[ for i in range(length(var.humans)): 8]...)
}

resource "aws_vpc" "teashop_office" {
      cidr_block       = var.vpc_corporate_office_cidr_block
         enable_dns_hostnames = true
         enable_dns_support   = true

         tags = {
            Name = format("mcd-demo-%s-%s-%s","teashop_office","humans",var.tfrun_identifier)
            Tier = "teashop-hq"
            Application = var.application_name
            ResourceGroup = var.tfrun_identifier

         }
      }

resource "aws_subnet" "corporate_subnet" {  
         count =length(var.environment_list)
         vpc_id            = aws_vpc.teashop_office.id
         cidr_block        = local.corporate_subnets_list_vpc[count.index]
         availability_zone = var.az1

         tags = {
            Name = format(
               "mcd-demo-%s-%s-subnet-%s",
               var.environment_list[count.index],
               var.application_name,
               var.tfrun_identifier)
            Tier = "humans"
            Application = var.application_name
            Environment = var.environment_list[count.index]
            ResourceGroup =var.tfrun_identifier

         }
      }

resource "aws_security_group" "human_sg" {
      name        = "human_sg"
      description = "Allow anything to dev, val , prod"
      vpc_id      = aws_vpc.teashop_office

      tags = {
         Name = format("mcd-demo-%s-humans-sg-%s",var.application_name,var.tfrun_identifier)
         Tier = "humans"
         Application = var.application_name
         ResourceGroup = var.tfrun_identifier
      }
      }
resource "aws_vpc_security_group_ingress_rule" "allow_in_ssh_ipv4_frontend" {
      security_group_id = aws_security_group.human_sg.id
      cidr_ipv4         = "0.0.0.0/0"
      from_port         = 22
      ip_protocol       = "tcp"
      to_port           = 22
      }

      resource "aws_vpc_security_group_ingress_rule" "allow_in_1111_ipv4_frontend" {
      security_group_id = aws_security_group.human_sg.id
      cidr_ipv4         = "0.0.0.0/0"
      from_port         = 1
      ip_protocol       = "tcp"
      to_port           = 65535
      }
      
      resource "aws_vpc_security_group_ingress_rule" "allow_in_icmp_ipv4_frontend" {
         security_group_id = aws_security_group.human_sg.id
         cidr_ipv4         = aws_vpc.teashop_office.cidr_block
         ip_protocol       = "icmp"
         from_port         = -1
         to_port           = -1
      }

      resource "aws_vpc_security_group_egress_rule" "allow_out_all_traffic_ipv4_frontend" {
      security_group_id = aws_security_group.human_sg.id
      cidr_ipv4         = "0.0.0.0/0"
      ip_protocol       = "-1" # semantically equivalent to all ports
      }


      resource "aws_instance" "one_human" {
        count =length(var.environment_list)
        ami                     = var.ec2_instance_ami
        instance_type           = var.ec2_instance_type_human
        availability_zone       = var.az1
         subnet_id               = aws_subnet.corporate_subnet[count.index]
      
         key_name                = var.keyname
         associate_public_ip_address = true

         vpc_security_group_ids  = [aws_security_group.human_sg]
         root_block_device {
            volume_size = 10 # in GB 
            volume_type = "gp3"
            encrypted   = false
         } 
         tags = {
            Name = format("mcd-demo-humans-%s-%s-%s-%s",var.application_name,var.environment_list[count.index],var.humans[count.index],var.tfrun_identifier)
            #Name = "mcd-demo-teashop-backend"
            Tier = "humans"
            Application = var.humans[count.index]
            Environment = var.environment_list[count.index]
            ResourceGroup = var.tfrun_identifier


         }
         
         user_data = file("${path.module}/cloud-init-human.yaml")
       }

        