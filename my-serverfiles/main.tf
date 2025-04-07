 resource "aws_instance" "ansible_node" {
  ami                    = "ami-0e35ddab05955cf57"
  instance_type          = "t2.medium"
  key_name               = "mohanm"
  vpc_security_group_ids = ["sg-0b768b95cbfa4806a"]
  associate_public_ip_address = true   # Ensures a public IP is assigned

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./mohanm.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = ["echo 'wait to start instance'"]
  }

  tags = {
    Name = "ansible_node"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.ansible_node.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/health-care/my-serverfiles/health-playbook.yml"
  }
}
