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

## terraform validate
Verifies that the configuration files (e.g., .tf files) are syntactically correct

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

## terraform taint
- terraform taint on a resource, it marks that resource for destruction and recreation during the next terraform apply
- Before u apply taint command, you have to seen the resources in state file which needs to be tainted for this u can use <br>
terraform state list <br>
terraform taint <resource_type>.<resource_name> <br>
For example, if you want to ensure that a null_resource or any other resource is always recreated during each terraform apply, you would do the following<br>
terraform taint null_resource.test-null[0] <br>
terraform untaint <resource_type>.<resource_name> <br>
untained removes the taint and prevents the resource from being recreated on the next apply unless explicitly changed. <br>

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
1. **String**: A sequence of characters.<br>
```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```
2. **number**:  Numeric values (integer or float).<br>
```hcl 
variable "instance_count" {
  type    = number
  default = 3
}
```
3. **bool**: Boolean value (true or false).<br>
```hcl
 variable "enable_public_ip" {
  description = "Enable public IP address"
  type        = bool
  default     = true
}
```
4. **List** : 
list that will contain more than one element in it.<br>
```hcl
variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["user1", "user2", "user3s"]
}
```
5. **Map**: 
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
6.**lookup**:
- lookup(key, value)<br>
- lookup(var.amis, var.region) <br>
    Retrieves the AMI ID for the region specified in var.region<br>
  lookup functions is used to map keypair to its value . suppose you specifcied region name in the .tfvars then the terraform will select the specific region amis hardcoded in the .tfvars to deploy  <br>


7. **element**:
- subnet_id = element(var.subnets, count.index) <br>
- var.subnets                       : A variable that is expected to be a list of subnet IDs.<br>
- count.index                       : An index value provided by the count meta-argument, which iterates over resources in a loop.count.index. The default index starts from 0 <br>
- element(var.subnets, count.index) : This retrieves the subnet ID at the position specified by count.index in the var.subnets list. <br>
```hcl
variable "subnets" {
  type = list(string)
  default = ["subnet-abc123", "subnet-def456", "subnet-ghi789"]
}
resource "aws_instance" "example" {
  count = length(var.subnets)

  ami           = "ami-0c55b159cbfafe1f0" # Example AMI
  instance_type = "t2.micro"
  subnet_id     = element(var.subnets, count.index)
  tags = {
    Name = "Instance-${count.index +1}"
  }
}
```
8. **Conditional Expressions**<br>

Conditional expressions in Terraform are used to define conditional logic within your configurations. They allow you to make decisions or set values based on conditions. Conditional expressions are typically used to control whether resources are created or configured based on the evaluation of a condition.<br>

The syntax for a conditional expression in Terraform is:<br>

```hcl
condition ? true_val : false_val
```

- `condition` is an expression that evaluates to either `true` or `false`.
- `true_val` is the value that is returned if the condition is `true`.
- `false_val` is the value that is returned if the condition is `false`.

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
1. **file provisioner**:<br>
As the name suggests file provisioner can be used for transferring and copying the files from one machine to another machine.<br>
Not only file but it can also be used for transferring/uploading the directories.<br>
- Terraform provisioners only run when the resource (EC2 instance) is created. If the EC2 instance already exists, the file will not be copied again unless the instance is destroyed and recreated.<br>
2. **local-exec provisioner**:<br>
It will always be used to perform local operations onto your local machine.<br>
3. **remote-exec provisioner**:<br>
 it is always going to work on the remote machine. remote-exec you can specify the commands of shell scripts that want to execute on the remote machine.<br>
 - Supporting arguments for remote provisioners
  1. **inline** - With the help of an inline argument you can specify the multiple commands which you want to execute in an ordered fashion.<br>
 ```hcl
   provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote provisioner >> hello.txt",
    ]
    }
  ```
2. **script** - It can be used to copy the script from local machine to remote machine and it always contains a relative path.<br>
3. **scripts** - Here you can specify the multiple local scripts which want to copy or transfer to the remote machine and execute over there.<br>
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

##  specific version of Terraform
Declare Required Terraform Version in your root module (typically in `main.tf` or `versions.tf`):

```hcl
terraform {
  required_version = "1.6.6"
}
```

You can also use version constraints:

```hcl
terraform {
  required_version = ">= 1.5.0, < 1.7.0"
}
```
---

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

# Alias Argument

In **Terraform**, the `alias` argument is used to define **multiple configurations** of the same provider. This is especially helpful when:

* You need to **use the same provider with different regions/accounts**
* You want to **use multiple credentials**
* You must **split resources across provider configurations**

### Basic Syntax

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}
```

Here, two AWS provider configurations are defined:

* Default: `us-east-1`
* Aliased: `us-west-2` (accessed via `provider = aws.west`)


###  Example Use Case – Deploying Resources in Two Regions

```hcl
resource "aws_s3_bucket" "east_bucket" {
  bucket = "my-east-bucket"
  provider = aws  # Uses default provider (us-east-1)
}

resource "aws_s3_bucket" "west_bucket" {
  bucket = "my-west-bucket"
  provider = aws.west  # Uses aliased provider (us-west-2)
}
```

###  Important Notes

* Every resource using the aliased provider **must explicitly declare** the provider like `provider = aws.alias_name`.
* Aliases are **local to a module**. If you want to use it in child modules, you must **pass it explicitly** using `providers` block.

---


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
   terraform import <resource type>.<resource name>(anything) <resource-id >
   Example: terraform import aws_instance.example  i-0d97c46c9c8c65123
   ```

---

### Null Resource
-   As in the name you see a prefix null which means this resource will not exist on your Cloud Infrastructure(AWS, Google Cloud, Azure). <br>
- Terraform null_resource does not have a state which means it will be executed as soon as you run $ terraform apply command but no state will be saved. <br>
Using trigger to execute null_resource everytime. trigger will only work when it detects the change in the key-value pair. <br>
```hcl
resource "null_resource" "null_resource_simple" { 
  triggers = {
    id = aws_instance.ec2_example.id  
  }
  provisioner "local-exec" {
    command = "echo Hello World"
  }
}
```

### If you changed manually in the configuration  of resource and you want to import it again 
> terraform state rm <resource type>.<resource name>  <br>
> terraform import <resource type>.<resource name><anything> <resource id > <br>

### Terraform depends 
- The "depends_on" meta argument in Terraform is used to specify dependencies between resources within a Terraform configuration <br>
-  multiple resources in the "depends_on" meta argument by providing a list of resource references. You must follow the following two conditions  <br>
 > Each resource reference should be enclosed in square brackets <br>
 > The list of references should be separated by commas. <br>

 
## Terraform locals
- Local values can be helpful to avoid repeating the same values or expressions multiple times in a configuration, but if overused they can also make a configuration hard to read by future maintainers by hiding the actual values used <br>
- Locals are defined in a `locals` block and can be referenced throughout the configuration using the `local.<NAME>` syntax. <br>

### Syntax
```hcl
locals {
  <NAME> = <EXPRESSION>
}
```

### Example
```hcl
locals {
  project_name = "my-app"
  region       = "us-west-2"
  common_tags  = {
    Environment = "production"
    Project     = local.project_name
  }
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = local.common_tags
}

output "project_region" {
  value = "${local.project_name}-${local.region}"
}
```

### Explanation of Example
- `project_name` and `region` are defined as local variables.
- `common_tags` is a map that uses `local.project_name` to avoid hardcoding.
- The `aws_instance` resource uses `local.common_tags` for its tags.
- The `output` block combines `local.project_name` and `local.region` to produce a value like `my-app-us-west-2`.

