## Naming Rules in Terraform identifier rules
1. Must start with a letter <br>
2. Can contain letters, numbers, hyphens (-), and underscores (_) <br>
3. Cannot start with a number <br>
4. Avoid special characters like !@#% <br>
```hcl
 valid Terraform identifiers
 my_instance, my-instance, webServer1, ec2_instance
 ```
 ```hcl
 invalid Terraform identifiers
 123ec2_instance (starts with a number), my!instance (contains an invalid special character) ec2@instance
```

### question1 : ec2 instance is generated with help of main.tf file in the project1 folder . by using terraform apply command i created a ec2 instance in the console. later on i have added tags in the aws_instance. then i have applied main.tf file . but as added tags to the recently created. why not it created a ec2 instance again ?
Answer: The reason Terraform did not create a new EC2 instance after you added tags and ran terraform apply is because Terraform tracks the existing EC2 instance using its "state file". Instead of creating a new instance, it identifies that the existing instance needs to be updated.


### Mutable arguments: These arguments can be changed without destroying the resource. Terraform will update the resource in place
1.EC2 Instance        : 	     tags, key_name, security_groups, user_data, iam_instance_profile, monitoring<br>
2.S3 Bucket           :	       tags, versioning, cors_rule, website<br>
3.Security Group      :	       ingress, egress, tags<br>
4.RDS Instance        :	       tags, allocated_storage, apply_immediately<br>
5.Load Balancer       :	       tags, access_logs, idle_timeout<br>

### Immutable arguments: These arguments cannot be changed in place. When you modify them, Terraform destroys and recreates the resource.
1.EC2 Instance  :	      ami, instance_type, availability_zone, subnet_id, placement_group, key pairs<br>
2.RDS Instance  :	      engine_version, instance_class, allocated_storage, multi_az<br>
3.ELB           :	      load_balancer_type, subnets, security_groups<br>
4.EBS Volume    :	      size, type, iops<br>
5.VPC           :	      cidr_block, enable_dns_support, enable_dns_hostnames<br>

1. main.tf (Desired State)              : This file defines the desired infrastructure (like resources, configurations, etc.).<br>
2. .terraform/                          : Contains provider plugins and other metadata. It is ignored by Terraform.<br>
3. .terraform.lock.hcl                  : Used for dependency locking to ensure consistent provider versions. It is not used for configuration.<br>
4. terraform.tfstate (Current State)    :
 - Tracks the current state of the infrastructure.<br>
 -  It is only read during terraform plan or terraform apply to compare the current state  with the desired state.<br>
5. terraform.tfstate.backup             : A backup of the last known good terraform.tfstate file. It is only a backup and not used in configuration<br>

## terraform init
This command is used to initialize your Terraform configuration directory. It performs several tasks:
Downloads the necessary provider plugins.<br>
Initializes the backend (if defined in the configuration).<br>
Sets up the working directory for Terraform to use.<br>

## terraform plan
This command generates and shows an execution plan for Terraform.<br>
It gives you an opportunity to confirm that the changes are what you expect.<br>
When you run the terraform plan command, Terraform compares your current state (# terraform state list: which is stored in the terraform.tfstate file) with the desired state defined in your configuration files (e.g., main.tf, variables.tf, etc.)<br>

## terraform apply
This command will display the plan and prompt you for confirmation.<br>
After you confirm, Terraform will execute the changes to the infrastructure<br>
### terraform apply -auto-approve
Applies the changes without asking for confirmation<br>

## terraform destroy
Display the plan to destroy resources.<br>
Prompt you for confirmation.<br>
After confirmation, destroy all resources defined in the state.<br>
### terraform destroy -auto-approve
This will destroy the resources without asking for confirmation.<br>
#terraform state show aws_instance.example<br>

## terraform state show (aws_instance.example)
Details of a specific EC2 instance of Instance ID, Public IP, Private IP, Availability Zone, Tags, and more<br>

## You need to supply variable during the terraform init
terraform init --var-file=terraform.tfvars <br>

## You need to supply variable during the terraform plan
terraform plan --var-file=terraform.tfvars<br>
 
## You need to supply variable during the terraform apply
terraform apply   --var-file=terraform.tfvars <br>
terraform destroy --var-file=terraform.tfvars <br>

## variables.tf: 
This file is where you define your variables. It includes the name, type, and description of the variables. Specifies the type of variable (e.g., string, map(string), bool, list, number).<br>
## terraform.tfvars
This file contains the values for the variables defined in variables.tf.<br>
 

## variables
Syntax 
```hcl
       variable < your_variable_name> {
        Description = "Instance type t2.micro"  # Meaning full description
        type        =  string                   # examples : string, number, bool, list , map, set...                   
        default     = "t2.micro"                # variable default value
       }
 ```	   
## Simple Values variables(Terraform functions)
As the name suggests Simple Values variables are which hold only a single value. Here the types of Simple Value variables <br>
1. String : A sequence of characters.<br>
```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```
2. number:  Numeric values (integer or float).<br>
```hcl 
variable "instance_count" {
  type    = number
  default = 3
}
```
3. bool: Boolean value (true or false).<br>
```hcl
 variable "enable_public_ip" {
  description = "Enable public IP address"
  type        = bool
  default     = true
}
```
4. List
list that will contain more than one element in it.<br>
```hcl
variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["user1", "user2", "user3s"]
}
```
5. Map
map variable type where you can define the key-value pair.<br>
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
## terraform output
Output values make information about your infrastructure available on the command line.<br>
```hcl
output "instance_ips" {
  value = {
    public_ip  = aws_instance.example.public_ip
    private_ip = aws_instance.example.private_ip
  }
} 
```
displays the instance private/public ips of the ec2 instance<br>

## Terraform Provisioner
Terraform Provisioners are used to performing certain custom actions and tasks either on the local machine or on the remote machine
The custom actions can vary in nature and it can be -<br>
- Running custom shell script on the local machine<br>
- Running custom shell script on the remote machine<br>
- Copy file to the remote machine<br>
Generic Provisioners (file, local-exec, and remote-exec)<br>
1. file provisioner<br>
As the name suggests file provisioner can be used for transferring and copying the files from one machine to another machine.<br>
Not only file but it can also be used for transferring/uploading the directories.<br>
- Terraform provisioners only run when the resource (EC2 instance) is created. If the EC2 instance already exists, the file will not be copied again unless the instance is destroyed and recreated.<br>
2. local-exec provisioner<br>
It will always be used to perform local operations onto your local machine.<br>
3. remote-exec provisioner<br>
 it is always going to work on the remote machine. remote-exec you can specify the commands of shell scripts that want to execute on the remote machine.<br>
 - Supporting arguments for remote provisioners
  1. inline - With the help of an inline argument you can specify the multiple commands which you want to execute in an ordered fashion.<br>
 ```hcl
   provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote provisioner >> hello.txt",
    ]
    }
  ```
2. script - It can be used to copy the script from local machine to remote machine and it always contains a relative path.<br>
3. scripts - Here you can specify the multiple local scripts which want to copy or transfer to the remote machine and execute over there.<br>
   You cannot pass any arguments to scripts using the script or scripts arguments to this provisioner. If you want to specify arguments, upload the script with the file provisioner and then use inline to call it. <br>
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
 terraform configuration so that you can re-use the configuration and keep your terraform code more clean and modular<br>
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
Terraform workspaces is a very logical concept where you can have multiple states of your infrastructure configuration. To put this in simple words if you are running an infrastructure configuration in development environment then the same infrastructure can be run in the production environment.<br>
If you have not defined any workspace then there is always a default workspace created by terraform, so you always work in a default workspace of terraform. <br>
You can list the number of terraform workspaces by running the command terraform workspace show. Also, you can not delete the default workspace.<br>
   - terraform workspace new <workspace name>    :  You must also type in new for creating a new workspace <br>
   - terraform workspace list                    :  list all the workspaces which we have created previously<br>
   - terraform workspace show                    :  which can help you to show the active running workspace in which you are working.<br>
   - terraform workspace select <workspace name> :  switch between the workspaces<br>
   - terraform workspace delete <workspace name> : delete the target workspace <br>

# Data resources
Terraform data sources can be beneficial if you want to retrieve or fetch the data from the cloud service providers such as AWS, AZURE, and GCP.<br>
Terraform Data Sources are a kind of an API that fetches the data/information from the resources running under the cloud infra and sending it back to terraform configuration for further use.<br>
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
Any change which you make to your resource will be first reflected into the terraform state file before updating it onto the cloud infrastructure. Any information which is stored inside the terraform state file is known as metadata.<br>
If you have more than one developer working on Terraform project then it is always recommended to use remote backend(AWS S3 Bucket) to store your state file remotely.<br>
```hcl
terraform {
    backend "s3" {
        bucket = "jhooq-terraform-s3-bucket"
        key    = "jhooq/terraform/remote/s3/terraform.tfstate"
        region     = "eu-central-1"
    }
}
```
After storing the .tfstate in s3 bucket , u see the local tfstate is missing . again u have to apply terraform init , plan , apply.<br>
> terraform init -migrate-state.<br>
> terraform state pull 
 - It is quite often for a developer to take a break from work and during the break if developer's terraform project is out of sync then it is always recommended to get in sync with all the updates which has happened<br>
 - If you are storing terraform state file remotely then you should always use terraform state pull before you start working with your terraform project<br>
### Why Terraform State Locking is important?
 - It prevents Terraform state file(terraform.tfstate) from accidental updates by putting a lock on file so that the current update can be finished before processing the new change.<br>
    The feature of Terraform state locking is supported by AWS S3 and Dynamo DB.<br>
    ```hcl
    resource "aws_dynamodb_table" "state_locking" {
    hash_key = "LockID"
    name     = "dynamodb-state-locking"
    attribute {
     name = "LockID"
     type = "S"
     }
     billing_mode = "PAY_PER_REQUEST"
     }
     ```
## Terraform Debug and validation
 ```hcl
   export TF_LOG=Debug
   echo STF_LOG
   export TF_LOG_PATH="C:\Users\user\Documents"
 ```
 ```hcl
   $env:TF_LOG = "DEBUG"
   $env:TF_LOG #check the TF_log
   $env:TF_LOG_PATH = "C:\Users\user\Documents\terraform\terraform-debug.log"
   Remove-Item Env:\TF_LOG
   Remove-Item Env:\TF_LOG_PATH

```
## Restoring Statefile
 if the statefile is deleted or corrupted ,we restore it using terraform import command 
 ```hcl
   terraform import <terraform resource name> <resource id >
   ```
    