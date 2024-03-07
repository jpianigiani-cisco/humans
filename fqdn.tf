variable "frontend-nodes-public-fqdns" {
  type = list(string)
  default=["ciscomcd-l-mcd-wrotceoz-64b8fd6b0cc70dcd.elb.us-east-1.amazonaws.com:8080",
          "ciscomcd-l-mcd-wrotceoz-64b8fd6b0cc70dcd.elb.us-east-1.amazonaws.com:8180",
          "ciscomcd-l-mcd-wrotceoz-64b8fd6b0cc70dcd.elb.us-east-1.amazonaws.com:8280"]
}

variable "frontend-nodes-public-fqdns_ssh" {
  type = list(string)
  default=["ciscomcd-l-mcd-wrotceoz-64b8fd6b0cc70dcd.elb.us-east-1.amazonaws.com:8022",
          "ciscomcd-l-mcd-wrotceoz-64b8fd6b0cc70dcd.elb.us-east-1.amazonaws.com:8122",
          "ciscomcd-l-mcd-wrotceoz-64b8fd6b0cc70dcd.elb.us-east-1.amazonaws.com:8222"]
}