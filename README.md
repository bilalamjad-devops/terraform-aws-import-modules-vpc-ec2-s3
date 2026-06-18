# Import Existing AWS Infrastructure into Terraform Modules (Step-by-Step Guide)


Infrastructure as Code (IaC) is one of Terraform's greatest strengths, but what happens if your AWS resources already exist?

This is a common situation for many engineers. Perhaps you manually created a VPC, launched an EC2 instance for testing, or provisioned an S3 bucket before learning Terraform. Recreating everything from scratch isn't always practical.

Fortunately, Terraform provides the terraform import command, which allows you to bring existing infrastructure under Terraform management without recreating or deleting resources.



Terraform import is a command that uses an existing cloud resource's unique ID to establish a link between that resource and your Terraform state, bringing it under Terraform's management.



In this tutorial, we'll build an AWS environment manually using the AWS Management Console and then import those resources into a modular Terraform project.

By the end of this guide, Terraform will manage the following AWS resources:

- Custom VPC
- Public Subnet
- Internet Gateway
- Route Table
- EC2 Instance
- Security Group for EC2
- Amazon S3 Bucket



### Why Learn Terraform Import?

In real-world environments, not every cloud resource is created with Terraform. Many organizations already have existing infrastructure that was created manually or by another team.

Instead of rebuilding everything, Terraform Import allows you to connect those existing resources to your Terraform state, making them manageable through Infrastructure as Code.

This is an essential skill for DevOps Engineers, Cloud Engineers, and Platform Engineers working with existing AWS environments.




### Project Architecture

Our project follows this workflow:
```project-architecture
AWS Console
      │
      ▼
Create Infrastructure Manually
      │
      ▼
Terraform Import
      │
      ▼
Terraform State
      │
      ▼
Terraform Plan
```

Notice that Terraform does not create new resources during the import process.

Instead, it records the relationship between an existing AWS resource and the Terraform state file. Once imported, Terraform can manage that infrastructure just like resources it created itself.



### Create a Custom VPC:

A Virtual Private Cloud (VPC) is your own isolated network within AWS. It provides complete control over IP addressing, routing, and network security.

In this project, we'll create a custom VPC so that all of our AWS resources belong to the same private network.


- Go to VPC Dashboard > Your VPCs > Create VPC.

- Choose "VPC only".

- Name tag: `My-VPC`

- IPv4 CIDR block: `10.0.0.0/16`

- Click "Create VPC".

<img width="1600" height="900" alt="import 1" src="https://github.com/user-attachments/assets/9151f291-4533-481d-a9ca-570280904018" />

<img width="1600" height="900" alt="import 2" src="https://github.com/user-attachments/assets/ff79163f-993d-48dc-a2f1-fe04ef88191e" />

<img width="1600" height="900" alt="import 3" src="https://github.com/user-attachments/assets/ca99eb8e-0f33-4dc7-a45d-eab41a574d70" />

<img width="1600" height="900" alt="import 4" src="https://github.com/user-attachments/assets/27548895-3a14-4cd0-b4aa-5b01f387a4cd" />





### Create a Public Subnet:

- Go to VPC Dashboard > Subnets > Create subnet.

-  VPC ID: Select My-VPC.

- Subnet name: `Public-subnet-a`

- Availability Zone: ap-south-1a (or your preferred AZ in ap-south-1).

- IPv4 CIDR block: `10.0.1.0/24`

- Click "Create subnet".

- Crucial Step: Enable Auto-assign Public IP:

- Select your Public-subnet-a subnet.

- Go to "Actions" > "Modify auto-assign IP settings".

- CHECK "Enable auto-assign public IPv4 address". Click "Save".


<img width="1600" height="900" alt="import 5 subnet" src="https://github.com/user-attachments/assets/ea55e0ff-1948-4b84-b226-bdf2ac42b9fb" />


<img width="1600" height="900" alt="import 6" src="https://github.com/user-attachments/assets/02926fb8-9590-4ed5-b59f-e5d9c64aed75" />


<img width="1600" height="900" alt="import 7" src="https://github.com/user-attachments/assets/5f0c0a9f-c989-4ed6-b1a1-24c8ee146afd" />


<img width="1600" height="900" alt="import 8" src="https://github.com/user-attachments/assets/56a850a7-0c4f-43b9-bdd5-e2181dfdc506" />


<img width="1600" height="900" alt="import 9" src="https://github.com/user-attachments/assets/3f685076-1721-4ffd-8886-5e2f6fd34488" />

<img width="1600" height="900" alt="import 10" src="https://github.com/user-attachments/assets/899ddd47-8e31-4a8f-adf6-4264cd020600" />


<img width="1600" height="900" alt="import 11" src="https://github.com/user-attachments/assets/f22b1293-3b6d-4c38-95a2-733429e81e40" />




### Create an Internet Gateway (IGW):

- Go to VPC Dashboard > Internet Gateways > Create internet gateway.

- Name tag: `My-internet-gateway`

- Click "Create internet gateway".

- Attach to VPC: Select your new IGW, go to "Actions" > "Attach to VPC". Select My-VPC.

Record the IGW ID (e.g., igw-xxxxxxxxxxxxxxxxx).

<img width="1600" height="900" alt="import 12 igw" src="https://github.com/user-attachments/assets/f894084d-f6d3-4ac1-8f46-36343fbb02eb" />

<img width="1600" height="900" alt="import 13" src="https://github.com/user-attachments/assets/967a5fb3-835e-467d-a3c4-a9b3835df8db" />

<img width="1600" height="900" alt="import 14" src="https://github.com/user-attachments/assets/323915de-fadb-46e9-94d3-16c37bc0a2aa" />

<img width="1600" height="900" alt="import 15" src="https://github.com/user-attachments/assets/197bbab8-0992-4727-ac11-fad9071b70db" />

<img width="1600" height="900" alt="import 16" src="https://github.com/user-attachments/assets/5c1f3929-c943-462d-a8c0-aeee5e8ff807" />

<img width="1600" height="900" alt="import 17" src="https://github.com/user-attachments/assets/f7996440-29fc-48eb-9ddf-e5f92a599d2a" />



### Create a Public Route Table:

- Go to VPC Dashboard > Route Tables > Create route table.

- Name tag: `Public-route-table-a`

- VPC: Select My-VPC.

- Click "Create route table".

- Record the Route Table ID (e.g., rtb-xxxxxxxxxxxxxxxxx).

- Associate with Subnet: Go to "Subnet associations" tab > "Edit subnet associations". Select your Public-subnet-a. Click "Save associations".

- Add Internet Route: Select your Public-route-table-a. Go to "Routes" tab > "Edit routes" > "Add route".

  - Destination: 0.0.0.0/0

  - Target: Select "Internet Gateway" and choose your My-internet-gateway.

- Click "Save changes".

- Associate with Subnet: Go to "Subnet associations" tab > "Edit subnet associations". Select your Public-subnet-a. Click "Save associations".


<img width="1600" height="900" alt="import 18 routetable" src="https://github.com/user-attachments/assets/6a7283dc-b2fc-4017-88c2-d44bde8386e4" />

<img width="1600" height="900" alt="import 19" src="https://github.com/user-attachments/assets/c14af0e8-7382-4efd-bfae-8a7ee6dd02ce" />

<img width="1600" height="900" alt="import 20" src="https://github.com/user-attachments/assets/61b3ad3c-e46e-4fab-beb0-579eb3502dc8" />


<img width="1600" height="900" alt="import 21" src="https://github.com/user-attachments/assets/6e9f4561-4f66-4a77-baaa-ada2f69faa5f" />


<img width="1600" height="900" alt="import 22" src="https://github.com/user-attachments/assets/1a338969-ec54-4dee-b09f-345526930843" />

<img width="1600" height="900" alt="import 23" src="https://github.com/user-attachments/assets/3a2f2d14-7561-4e83-9755-b2f45e2385c5" />

<img width="1600" height="900" alt="import 24" src="https://github.com/user-attachments/assets/82f5dee9-41f1-4cd4-a052-56c494b0b99b" />







### Launch an EC2 Instance:

- Go to EC2 Dashboard > Instances > Launch instances.

- Name: `My-EC2`

- AMI: Search for "Amazon Linux 2023 AMI" and select a valid one for ap-south-1 (e.g., ami-0d03cb826412c6b0f).

- Instance type: t2.micro

- Key pair (login): Choose an existing key pair or create a new one.

- Network settings:

  - VPC: Select My-VPC.

  - Subnet: Select Public-subnet-a.

  - Auto-assign public IP: This should show "Enable" (inherited from subnet).

- Firewall (security groups): Select "Create security group".

  - Security group name: `My-EC2-SG` (Use this exact name).

  - Description: Security group for My-EC2 instance (Use this exact description).

  - Add inbound rule: Type SSH, Source Anywhere (0.0.0.0/0).

- Click "Launch instance".

- Record the EC2 Instance ID (e.g., i-xxxxxxxxxxxxxxxxx).

- Record the Custom Security Group ID (for My-EC2-SG, e.g., sg-xxxxxxxxxxxxxxxxx).


<img width="1600" height="900" alt="import 25 ec2" src="https://github.com/user-attachments/assets/456bba4a-7d6d-4b76-8119-1e838728be18" />

<img width="1600" height="900" alt="import 26" src="https://github.com/user-attachments/assets/a0bdb4ad-dc4f-4fa0-b851-bc5e152b9c43" />

<img width="1600" height="900" alt="import 27" src="https://github.com/user-attachments/assets/429ff19d-791b-4c68-b4bd-9a501a80b323" />


<img width="1600" height="900" alt="import 28" src="https://github.com/user-attachments/assets/5d98831a-3d18-4cb7-bb54-f7fe57eff7ac" />

<img width="1600" height="900" alt="import 29" src="https://github.com/user-attachments/assets/bebebad9-5f23-48ed-8e82-86ae28d0d5aa" />


<img width="1600" height="900" alt="import 30" src="https://github.com/user-attachments/assets/2704283f-04b3-4a05-b024-1d35990201dd" />













### Create an S3 Bucket:

- Go to S3 Dashboard > Buckets > Create bucket.

- Bucket name: `my-existing-s3-bucket-name-08-july-2025` (MUST be globally unique).

- AWS Region: Select AP-South-1.

- Block Public Access settings: Keep the default (all public access blocked).

- Tags: Do NOT add any tags here. Leave this section empty.

- Click "Create bucket".

- Record the S3 Bucket Name (e.g., my-existing-s3-bucket-name-08-july-2025).

- Find Default Security Group ID:

- Go to VPC Dashboard > Security Groups.

- Filter by your new VPC ID (My-VPC).

- Find the security group named default.

- Record its Security Group ID (e.g., sg-xxxxxxxxxxxxxxxxx)

<img width="1600" height="900" alt="import 31 s3" src="https://github.com/user-attachments/assets/e71b0542-1cfc-4950-bbef-f6f2fc028a39" />

<img width="1600" height="900" alt="import 32" src="https://github.com/user-attachments/assets/80f72938-05a6-4187-9bd7-c85899eab44a" />

<img width="1600" height="900" alt="import 33" src="https://github.com/user-attachments/assets/5a3c2074-1e02-45ed-8789-c5638b2f571e" />

<img width="1600" height="900" alt="import 34" src="https://github.com/user-attachments/assets/76dfed0b-c99a-4940-a0e0-51543305e084" />




## Terraform Project Setup

```bash
.
├── main.tf
├── variables.tf
├── terraform.tfvars
└── modules/
    ├── ec2/
    │   ├── ec2.tf
    │   └── variables.tf
    ├── s3/
    │   ├── s3.tf
    │   └── variables.tf
    └── vpc/
        ├── vpc.tf
        ├── variables.tf
        └── outputs.tf
```

### clone repository

<img width="1600" height="900" alt="import 35 clone" src="https://github.com/user-attachments/assets/baaac7c3-f8f5-4aac-bcc0-24ef3311272d" />


```git
git clone
```

<img width="1600" height="900" alt="import 35 terraform init 35" src="https://github.com/user-attachments/assets/b48d497b-88e9-4973-863b-e3a53aed24b7" />


Terraform init:
```bash
terraform init
```

### Import Existing AWS Resources (One by One)

Please copy the IDs of resources like this:

<img width="1600" height="900" alt="import 36" src="https://github.com/user-attachments/assets/74c7748d-16a6-4b1e-b99e-bb2ca53063b3" />

<img width="1600" height="900" alt="import 37" src="https://github.com/user-attachments/assets/3f9b721d-cb08-417b-b4e7-8250b8123fd4" />


Terraform import:
```bash
# 1. Import the VPC
terraform import 'module.vpc.aws_vpc.imported_vpc' 'YOUR_ACTUAL_VPC_ID_HERE'

# 2. Import the Internet Gateway
terraform import 'module.vpc.aws_internet_gateway.imported_igw' 'YOUR_ACTUAL_IGW_ID_HERE'

# 3. Import the Subnet
terraform import 'module.vpc.aws_subnet.imported_subnet' 'YOUR_ACTUAL_SUBNET_ID_HERE'

# 4. Import the Route Table
terraform import 'module.vpc.aws_route_table.imported_rt' 'YOUR_ACTUAL_RT_ID_HERE'

# 5. Import the Route Table Association (ID format: subnet-id/route-table-id)
terraform import 'module.vpc.aws_route_table_association.imported_rta' 'YOUR_ACTUAL_SUBNET_ID_HERE/YOUR_ACTUAL_RT_ID_HERE'

# 6. Import the Custom Security Group (e.g., 'My-EC2-SG')
# Find its ID in the AWS console under VPC -> Security Groups
terraform import 'module.ec2.aws_security_group.custom_sg' 'YOUR_ACTUAL_CUSTOM_SECURITY_GROUP_ID_HERE'

# 7. Import the EC2 Instance
# Use the ACTUAL EC2 INSTANCE ID here (it starts with 'i-')
terraform import 'module.ec2.aws_instance.imported_ec2' 'YOUR_ACTUAL_EC2_INSTANCE_ID_HERE'

# 8. Import the S3 Bucket
terraform import 'module.s3.aws_s3_bucket.imported_bucket' 'YOUR_ACTUAL_S3_BUCKET_NAME_HERE'

# 9. Import the Default Security Group
# Find its ID in the AWS console under VPC -> Security Groups (name "default")
terraform import 'module.vpc.aws_default_security_group.default' 'YOUR_ACTUAL_DEFAULT_SECURITY_GROUP_ID_HERE'
```


Terraform plan

<img width="1600" height="900" alt="import 38" src="https://github.com/user-attachments/assets/5b3714fc-cf99-4aae-80ee-ca292f9f57d5" />


```bash
terraform plan
```



Terraform destroy:
```bash
terraform destroy
```

<img width="1600" height="900" alt="import 39" src="https://github.com/user-attachments/assets/fc4cfabf-40cc-4d51-bccf-c59cbda63cb3" />

<img width="1600" height="900" alt="import 40" src="https://github.com/user-attachments/assets/17cf8f64-27ee-4d1d-b963-e26b707b5e64" />











