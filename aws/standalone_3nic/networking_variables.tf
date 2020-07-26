########################################################################################
#
#  Copyright (c) 2019 Citrix Systems, Inc.
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#      * Redistributions of source code must retain the above copyright
#        notice, this list of conditions and the following disclaimer.
#      * Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.
#      * Neither the name of the Citrix Systems, Inc. nor the
#        names of its contributors may be used to endorse or promote products
#        derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL Citrix Systems, Inc. BE LIABLE FOR ANY
#  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
########################################################################################



########################################################################################
# AWS Username to prepend all Terraform generated objects -- Your initials work well
########################################################################################

variable "se_name" {
  default = "delete-me"
}

########################################################################################
# AWS Access key and secret -- Create your access key and secret in the IAM dashboard
# under your user account
########################################################################################

variable "aws_access_key" {
  description = "The AWS access key"
}

variable "aws_secret_key" {
  description = "The AWS secret key"
}

########################################################################################
# AWS SSH key pair and public key -- Create a keypair via EC2 dashboard or create your
# own and upload it via the EC2 dashboard
########################################################################################

 variable "aws_ssh_key_name" {
   description = "SSH key name stored on AWS EC2 to access EC2 instances"
 }

 variable "aws_ssh_public_key" {
   description = "The public part of the SSH key you will use to access EC2 instances"
 }

# resource "tls_private_key" "example" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "generated_key" {
#   key_name   = "${var.se_name}.pem"
#   public_key = "${tls_private_key.example.public_key_openssh}"
# }

########################################################################################
# Network -- These should be unique
########################################################################################

variable "vpc_cidr_block" {
  description = "The CIDR block that will be used for all needed subnets"
  default = "10.0.0.0/16"
}

variable "management_subnet_cidr_block" {
  description = "The CIDR block that will be used for the management subnet. Must be contained inside the VPC cidr block."
  default = "10.0.0.0/24"
}

variable "client_subnet_cidr_block" {
  description = "The CIDR block that will be used for the client subnet. Must be contained inside the VPC cidr block."
  default = "10.0.1.0/24"
}

variable "server_subnet_cidr_block" {
  description = "The CIDR block that will be used for the server subnet. Must be contained inside the VPC cidr block."
  default = "10.0.2.0/24"
}

variable "controlling_subnet" {
  description = "The CIDR block of the machines that will SSH into the NSIPs of the VPX HA pair."
  default = "0.0.0.0/0"
  }

########################################################################################
# AWS Region and Availability Zone
########################################################################################

variable "aws_region" {
  description = "The AWS region to create things in"
  default     = "us-west-2"
}

variable "aws_availability_zone" {
  description = "Availability zone to create things in"
  default     = "us-west-2a"
}

########################################################################################
# VPX AMI map -- change these to suit your need
########################################################################################

variable "vpx_ami_map" {
  description = <<EOF

AMI map for VPX
Defaults to VPX BYOL version 13.x

EOF


  default = {
    "us-west-2" = "ami-0a679a9d6bbbd5147"
    "us-west-1" = "ami-0e608e7c3ca33944b"
  }
}

variable "ns_instance_type" {
  description = <<EOF
EC2 instance type.

The following values are allowed:

t2.medium
t2.large
t2.xlarge
t2.2xlarge
m3.large
m3.xlarge
m3.2xlarge
m4.large
m4.xlarge
m4.2xlarge
m4.4xlarge
m4.10xlarge
c4.large
c4.xlarge
c4.2xlarge
c4.4xlarge
c4.8xlarge

EOF


default = "m4.xlarge"
}

########################################################################################
# ADM Agent AMI map -- change these to suit your need
########################################################################################

variable "adm_ami_map" {
  description = <<EOF

AMI map for ADM Agent
Defaults to ADM Agent version 13.x

EOF


  default = {
    "us-west-2" = "ami-0b30f21b3ccac2121"
    "us-west-1" = "ami-0b9834f003326ee3c"
  }
}

variable "adm_instance_type" {
  description = <<EOF
EC2 instance type.

The following values are allowed:

t2.medium
t2.large
t2.xlarge
t2.2xlarge
m3.large
m3.xlarge
m3.2xlarge
m4.large
m4.xlarge
m4.2xlarge
m4.4xlarge
m4.10xlarge
c4.large
c4.xlarge
c4.2xlarge
c4.4xlarge
c4.8xlarge

EOF


default = "m4.xlarge"
}
