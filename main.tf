locals{
    corporate_subnets_list_vpc = cidrsubnets(var.vpc_corporate_office_cidr_block,[ for i in range(length(var.humans)): 3]...)
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

 # ------------------------------------------------------  
      # INTERNET GATEWAYS
      # creating internet gateway for Front End
   resource "aws_internet_gateway" "corporate_igw" {
         vpc_id = aws_vpc.teashop_office.id
   
         tags = {
            Name = format("mcd-demo-%s-%s-igw-%s",
                  "OFFICE", 
                  var.application_name,
                  var.tfrun_identifier)
            #Name = "mcd-demo-teashop-frontend-igw"
            Tier = "humans"
            Application = var.application_name
            Environment = "office"
            ResourceGroup =var.tfrun_identifier
   
         }

         depends_on = [aws_vpc.teashop_office]

      } 
#-----


   # ---------------------------------------------
   # ROUTE TABLES - FRONTEND
   # creating route table for Front End - Allow 0/0 in as it needs to be provisioned by TF
   resource "aws_route_table" "rt_office" {
         vpc_id = aws_vpc.teashop_office.id
         route          {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.corporate_igw.id
         }

         tags = {
            Name = format("mcd-demo-teashopoffice-to-igw-rt-%s-%s",var.application_name,var.tfrun_identifier)
            Tier = "teashop-office"
            Application = var.application_name
            Environment = "humans"
            ResourceGroup = var.tfrun_identifier
         }
   }
   resource "aws_main_route_table_association" "public"{
            vpc_id = aws_vpc.teashop_office.id
            route_table_id = aws_route_table.rt_office.id
   }
   # ROUTE TABLE ASSOCIATIONS
   # associate route table to the public subnet
   resource "aws_route_table_association" "rt_office_rt" {
      count =length(var.environment_list)
      subnet_id      = aws_subnet.corporate_subnet[count.index].id
      route_table_id = aws_route_table.rt_office.id
      }
#------
resource "aws_security_group" "human_sg" {
      name        = "human_sg"
      description = "Allow anything to dev, val , prod"
      vpc_id      = aws_vpc.teashop_office.id

      tags = {
         Name = format("mcd-demo-%s-humans-sg-%s",
            var.application_name,var.tfrun_identifier)
         Tier = "humans"
         Application = var.application_name
         ResourceGroup = var.tfrun_identifier
      }
      }
resource "aws_vpc_security_group_ingress_rule" "allow_in_ssh_ipv4_human"{
      security_group_id = aws_security_group.human_sg.id
      cidr_ipv4         = "0.0.0.0/0"
      from_port         = 22
      ip_protocol       = "tcp"
      to_port           = 22
      }

      resource "aws_vpc_security_group_ingress_rule" "allow_in_1111_ipv4_human" {
      security_group_id = aws_security_group.human_sg.id
      cidr_ipv4         = "0.0.0.0/0"
      from_port         = 1
      ip_protocol       = "tcp"
      to_port           = 65535
      }
      
      #resource "aws_vpc_security_group_ingress_rule" "allow_in_icmp_ipv4_human" {
      #   security_group_id = aws_security_group.human_sg.id
      #   cidr_ipv4         = aws_vpc.teashop_office.cidr_block
      #   ip_protocol       = "icmp"
      #   from_port         = -1
      #   to_port           = -1
      #}

      resource "aws_vpc_security_group_egress_rule" "allow_out_all_traffic_ipv4_human" {
      security_group_id = aws_security_group.human_sg.id
      cidr_ipv4         = "0.0.0.0/0"
      ip_protocol       = "-1" # semantically equivalent to all ports
      }


      resource "aws_instance" "one_human" {
        count =length(var.environment_list)
        ami                     = var.ec2_instance_ami
        instance_type           = var.ec2_instance_type_human
        availability_zone       = var.az1
         subnet_id               = aws_subnet.corporate_subnet[count.index].id
      
         key_name                = var.keyname
         associate_public_ip_address = true

         vpc_security_group_ids  = [aws_security_group.human_sg.id]
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

         depends_on = [  aws_security_group.human_sg, aws_vpc.teashop_office ]
       }

      resource "null_resource" "human-config"{ 
         count = length(var.frontend-nodes-public-fqdns)
   
         
         provisioner "remote-exec"{
                     inline = ["while [ ! -f /tmp/signal ]; do sleep 3; done",]
         }
         
         
         #triggers = {
         #   configfile = templatefile (   "${path.module}/human.sh" , 
         #                                 #{frontendip = aws_instance.ec2_backend.private_ip}
         #                                 {backendip = var.}
         #   )
         #}
         provisioner "file" {
               source     = "./mylocustfiles/locustfile.py"
               destination = "/tmp/locustfile.py"
         }
         

         provisioner "remote-exec" {
               inline = [format("locust -f /tmp/locustfile.py -H %s ",var.frontend-nodes-public-fqdns[count.index])]
         }
         connection {
               type        = "ssh"
               user        = "ubuntu"
               private_key = "${file("~/.ssh/${var.keyname}.pem")}"
               host        = aws_instance.one_human[count.index].public_dns
               agent       = false

            }

         depends_on = [ aws_instance.one_human ]
      
      }

        