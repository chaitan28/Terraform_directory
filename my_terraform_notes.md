## Naming Rules in terraform
1.It must be unique within the current module.
2.It must follow Terraform identifier rules:
3.Must start with a letter.
4.Can contain letters, numbers, hyphens (-), and underscores (_).
5.Cannot start with a number.
Avoid special characters like !@#%.
### question1 : ec2 instance is generated with help of main.tf file in the project1 folder . by using terraform apply command i created a ec2 instance in the console. later on i have added tags in the aws_instance. then i have applied main.tf file . but as added tags to the recently created. why not it created a ec2 instance again ?
Answer: The reason Terraform did not create a new EC2 instance after you added tags and ran terraform apply is because Terraform tracks the existing EC2 instance using its "state file". Instead of creating a new instance, it identifies that the existing instance needs to be updated.


### Mutable arguments: These arguments can be changed without destroying the resource. Terraform will update the resource in place
1.EC2 Instance      : 	     tags, key_name, security_groups, user_data, iam_instance_profile, monitoring
2.S3 Bucket           :	       tags, versioning, cors_rule, website
3.Security Group      :	       ingress, egress, tags
4.RDS Instance        :	       tags, allocated_storage, apply_immediately
5.Load Balancer       :	       tags, access_logs, idle_timeout

### Immutable arguments: These arguments cannot be changed in place. When you modify them, Terraform destroys and recreates the resource.
1.EC2 Instance  :	      ami, instance_type, availability_zone, subnet_id, placement_group, key pairs
2.RDS Instance  :	      engine_version, instance_class, allocated_storage, multi_az
3.ELB           :	      load_balancer_type, subnets, security_groups
4.EBS Volume    :	      size, type, iops
5.VPC           :	      cidr_block, enable_dns_support, enable_dns_hostnames

main.tf (Desired State)              : This file defines the desired infrastructure (like resources, configurations, etc.).
.terraform/                          : Contains provider plugins and other metadata. It is ignored by Terraform.
.terraform.lock.hcl                  : Used for dependency locking to ensure consistent provider versions. It is not used for configuration.
terraform.tfstate (Current State)    : 1.Tracks the current state of the infrastructure.
                                       2. It is only read during terraform plan or terraform apply to compare the current state  with the desired state.
terraform.tfstate.backup             : A backup of the last known good terraform.tfstate file. It is only a backup and not used in configuration

## terraform init
This command is used to initialize your Terraform configuration directory. It performs several tasks:
Downloads the necessary provider plugins.
Initializes the backend (if defined in the configuration).
Sets up the working directory for Terraform to use.

## terraform plan
This command generates and shows an execution plan for Terraform.
It gives you an opportunity to confirm that the changes are what you expect.
When you run the terraform plan command, Terraform compares your current state (# terraform state list: which is stored in the terraform.tfstate file) with the desired state defined in your configuration files (e.g., main.tf, variables.tf, etc.)

## terraform apply
This command will display the plan and prompt you for confirmation.
After you confirm, Terraform will execute the changes to the infrastructure
### terraform apply -auto-approve
Applies the changes without asking for confirmation

## terraform destroy
Display the plan to destroy resources.
Prompt you for confirmation.
After confirmation, destroy all resources defined in the state.
### terraform destroy -auto-approve
This will destroy the resources without asking for confirmation.
#terraform state show aws_instance.example

## terraform state show (aws_instance.example)
Details of a specific EC2 instance of Instance ID, Public IP, Private IP, Availability Zone, Tags, and more

## You need to supply variable during the terraform init
terraform init --var-file=terraform.tfvars 

## You need to supply variable during the terraform plan
terraform plan --var-file=terraform.tfvars
 
## You need to supply variable during the terraform apply
terraform apply   --var-file=terraform.tfvars 
terraform destroy --var-file=terraform.tfvars 

## variables.tf: 
This file is where you define your variables. It includes the name, type, and description of the variables. Specifies the type of variable (e.g., string, map(string), bool, list, number).
## terraform.tfvars
This file contains the values for the variables defined in variables.tf.
 

## variables
Syntax 
```hcl
       variable < your_variable_name> {
        Description = "Instance type t2.micro"  # Meaning full description
        type        =  string                   # examples : string, number, bool, list , map, set...                   
        default     = "t2.micro"                # variable default value
       }
 ```	   
Simple Values variables
As the name suggests Simple Values variables are which hold only a single value. Here the types of Simple Value variables -
1. String : A sequence of characters.
```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```
2. number:  Numeric values (integer or float).
```hcl 
variable "instance_count" {
  type    = number
  default = 3
}
```
3. bool: Boolean value (true or false).
```hcl
 variable "enable_public_ip" {
  description = "Enable public IP address"
  type        = bool
  default     = true
}
```
4. List
list that will contain more than one element in it.
```hcl
variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["user1", "user2", "user3s"]
}
```
5. Map
map variable type where you can define the key-value pair.
```hcl
variable "project_environment" {
  description = "project name and environment"
  type        = map(string)
  default     = {
    project     = "project-alpha",
    environment = "dev"
  }
}
```
# terraform output
Output values make information about your infrastructure available on the command line.
```hcl
output "instance_ips" {
  value = {
    public_ip  = aws_instance.example.public_ip
    private_ip = aws_instance.example.private_ip
  }
} 
```
displays the instance private/public ips of the ec2 instance

# Terraform Provisioner
Terraform Provisioners are used to performing certain custom actions and tasks either on the local machine or on the remote machine
The custom actions can vary in nature and it can be -
> Running custom shell script on the local machine
> Running custom shell script on the remote machine
> Copy file to the remote machine
Generic Provisioners (file, local-exec, and remote-exec)
1. file provisioner
As the name suggests file provisioner can be used for transferring and copying the files from one machine to another machine.
Not only file but it can also be used for transferring/uploading the directories.
> Terraform provisioners only run when the resource (EC2 instance) is created. If the EC2 instance already exists, the file will not be copied again unless the instance is destroyed and recreated.
2. local-exec provisioner
It will always be used to perform local operations onto your local machine.
3. remote-exec provisioner
 it is always going to work on the remote machine. remote-exec you can specify the commands of shell scripts that want to execute on the remote machine.
 > Supporting arguments for remote provisioners
   1.inline - With the help of an inline argument you can specify the multiple commands which you want to execute in an ordered fashion.
   ```hcl
   provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote provisioner >> hello.txt",
    ]
}
```
   2.script - It can be used to copy the script from local machine to remote machine and it always contains a relative path.
   3.scripts - Here you can specify the multiple local scripts which want to copy or transfer to the remote machine and execute over there.
   You cannot pass any arguments to scripts using the script or scripts arguments to this provisioner. If you want to specify arguments, upload the script with the file provisioner and then use inline to call it. 
   Example:
   ```hcl
   resource "aws_instance" "web" {
     provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
    ]
  }
}
```
# MODULES
 terraform configuration so that you can re-use the configuration and keep your terraform code more clean and modular
 ```hcl
provider "aws" {
   region     = var.web_region
   access_key = var.access_key
   secret_key = var.secret_key
}

module "jhooq-webserver-1" {
  source = ".//module-1"
}

module "jhooq-webserver-2" {
  source = ".//module-2"
}
```
# Terraform Workspaces
Terraform workspaces is a very logical concept where you can have multiple states of your infrastructure configuration. To put this in simple words if you are running an infrastructure configuration in development environment then the same infrastructure can be run in the production environment.If you have not defined any workspace then there is always a default workspace created by terraform, so you always work in a default workspace of terraform. You can list the number of terraform workspaces by running the command terraform workspace show. Also, you can not delete the default workspace.
   > terraform workspace new <workspace name>    :  You must also type in new for creating a new workspace 
   > terraform workspace list                    :  list all the workspaces which we have created previously
   > terraform workspace show                    :  which can help you to show the active running workspace in which you are working.
   > terraform workspace select <workspace name> :  switch between the workspaces
   > terraform workspace delete <workspace name> : delete the target workspace 

# Data resources
Terraform data sources can be beneficial if you want to retrieve or fetch the data from the cloud service providers such as AWS, AZURE, and GCP.Terraform Data Sources are a kind of an API that fetches the data/information from the resources running under the cloud infra and sending it back to terraform configuration for further use.
```hcl
data "aws_instance" "myawsinstance" {
    filter {
      name = "tag:Name"
      values = ["Terraform EC2"]
    }

    depends_on = [
      "aws_instance.ec2_example"
    ]
} 
```
# terraform state file (.tfstate)
> terraform init -migrate-state