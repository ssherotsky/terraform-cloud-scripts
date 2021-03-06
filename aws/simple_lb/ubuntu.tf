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

resource "aws_instance" "ubuntu" {
  ami           = var.ubuntu_ami_map[var.aws_region]
  instance_type = "t2.micro"
  key_name      = "georgen"

  network_interface {
    network_interface_id = element(aws_network_interface.server_management.*.id, count.index)
    device_index         = 0
  }

  tags = {
    Name = format("Terraform Service Node %d", count.index)
  }

  count = var.backend_services_count
}

resource "null_resource" "networking_setup" {
  connection {
    host = element(aws_instance.ubuntu.*.public_ip, count.index)
    user = "ubuntu"
  }

  depends_on = [
    aws_network_interface.server_data,
    aws_instance.ubuntu,
  ]
  provisioner "remote-exec" {
    inline = [
      format(
        "sudo ip addr add dev eth1 %v/24",
        element(aws_network_interface.server_data.*.private_ip, count.index),
      ),
      "sudo ip link set eth1 up",
      "sudo apt update -y",
      "sudo apt install -y apache2",
      format(
        "sudo bash -c 'echo \"Hello from Terraformed Apache Web Server %v\" > /var/www/html/index.html'",
        count.index + 1,
      ),
      "sudo systemctl restart apache2",
    ]
  }

  count = var.backend_services_count
}

resource "aws_network_interface" "server_management" {
  subnet_id = var.management_subnet_id

  security_groups = [var.management_security_group_id]

  tags = {
    Name = format("Terraform Ubuntu Management %d", count.index)
  }

  count = var.backend_services_count
}

resource "aws_network_interface" "server_data" {
  subnet_id       = var.server_subnet_id
  security_groups = [var.server_security_group_id]

  tags = {
    Name = format("Terraform Ubuntu Data %d", count.index)
  }

  attachment {
    instance     = element(aws_instance.ubuntu.*.id, count.index)
    device_index = 1
  }

  count = var.backend_services_count
}
