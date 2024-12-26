resource "null_resource" "test-null" {
  depends_on = [aws_instance.public-server] 
  
  # Make the count based on the number of instances
  count = length(aws_instance.public-server)

  # File provisioner to upload the script
  provisioner "file" {
    source      = "user-data.sh"
    destination = "/tmp/user-data.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Ensure the correct username (default is 'ubuntu' for Ubuntu AMIs)
      private_key = file("C:/Users/user/Desktop/cloud_keys/aws-us-east-1.pem")  # Path to your private key
      host        = element(aws_instance.public-server.*.public_ip, count.index)  # Get the correct public IP of each instance
    }
  }

  # Remote-exec provisioner to run the script on the instance
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /tmp/user-data.sh",  # Make the script executable
      "sudo /tmp/user-data.sh",  # Execute the script
      "sudo apt update",  # Update apt package lists
      "sudo apt install jq unzip -y",  # Install additional packages (example)
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Ensure the correct username (default is 'ubuntu' for Ubuntu AMIs)
      private_key = file("C:/Users/user/Desktop/cloud_keys/aws-us-east-1.pem")  # Path to your private key
      host        = element(aws_instance.public-server.*.public_ip, count.index)  # Get the correct public IP of each instance
    }
  }
}
