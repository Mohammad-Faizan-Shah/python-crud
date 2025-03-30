# Terraform EKS & RDS Deployment Guide

This repository contains Terraform configuration to deploy an Amazon EKS cluster with supporting infrastructure for a Python CRUD application.

## Prerequisites

Before you begin, make sure you have the following installed:

1. **AWS CLI** - For authentication with AWS  
   [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

2. **Terraform** - For infrastructure provisioning  
   [Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Configuration

### AWS Authentication

Configure your AWS credentials using:

```sh
aws configure
```

You’ll need to provide:

	•	AWS Access Key ID
	•	AWS Secret Access Key
	•	Default AWS Region
	•	Default Output Format (optional)

# Required Variables

Create a terraform.tfvars file in the root directory with the following variables:

## Required
db_password = "YourStrongPasswordHere"

## Optional - override defaults if needed

    kubernetes_version = 1.32
    vpc_cidr = "10.0.0.0/16"
    aws_region = "us-east-1"
    db_username = "crud_user"
    db_name = "crud_db"

⚠ Important: Never commit your terraform.tfvars file to version control as it contains sensitive information.

# Deployment Steps

1. ### Initialize Terraform
  Run the following command to initialize Terraform:
  ```sh
terraform init
```

2. ### Review the Terraform Plan

To see what resources will be created, run:

    terraform plan

3. ### Apply the Terraform Configuration

To deploy the infrastructure, run:

    terraform apply

Type yes when prompted to confirm the deployment.

After applying, note the MySQL endpoint URL from the outputs - you'll need this to configure the application:


4. ### Grant IAM access entries to EKSCluster
	1.	Go to the AWS Console and navigate to EKS Clusters.
	2.	Select the EKS Cluster that you created.
	3.	Click Access → IAM access entries.
	4.	Follow the form and add AmazonEKSClusterAdminPolicy.
	5.	Save the changes.

5. ### Configure kubectl to Connect to Your Cluster

After the deployment is complete, configure kubectl to connect to your new EKS cluster:

    aws eks update-kubeconfig --region $(terraform output -raw aws_region) --name $(terraform output -raw cluster_id)

📌 Notes
	•	Ensure your AWS credentials have the necessary permissions to create and manage EKS resources.
	•	Modify the variables in terraform.tfvars as needed to customize your deployment.
	•	Always review Terraform plans before applying changes.


