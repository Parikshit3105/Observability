# Observability Stack Deployment Guide
![image](https://github.com/Parikshit3105/Observability/assets/131677053/9c6abcb1-9a6d-47d0-a087-e7ed9af91aca)


This guide provides instructions for deploying an Observability Stack on AWS using Terraform. The stack includes Prometheus and Grafana services to monitor resources effectively.

## Functionality of Stack

The Observability Stack facilitates the quick deployment of a secure, highly available, scalable, and cost-effective AWS infrastructure for monitoeing system. It includes the following AWS resources:
- EC2 Instance and Security Group
- IAM Role with SSM Access, S3 Full Access, Describe Instance Access
- Launch Template
- Auto Scaling Group and Attached Security Group
- Target Groups for Prometheus and Grafana
- Load Balancer

## Prerequisites

Before deploying the Observability Stack, ensure you have the following:
- Terraform configured on the local system
- Access key and secret key for IAM role creation, IAM policy creation, launch template creation, auto scaling group creation, target group creation, load balancer creation, and security group creation.
- PEM file for SSH access
- Private subnet ID (1) and public subnet IDs(3)
- VPC ID and CIDR range
- Latest Ubuntu AMI ID

## Deployment Steps

1. Clone this repository to your local machine.
2. Navigate to the `ObservabilityStack` directory.
3. Open the `terraform.tfvars` file and fill in the required variables.
4. Save the changes.
5. Open a command line interface and navigate to the `ObservabilityStack` directory.
6. Run the following commands:
   
   ```bash
   terraform init
   terraform plan
   terraform apply

## Additional Steps:

Once the infrastructure is created and you can access the Grafana dashboard, follow these additional steps:

- Configure the Grafana data source.
- Import the required dashboards.
- Update the Prometheus configuration file as per requirements.
### Additional supporting services:

- Blackbox exporter
- Node exporter
- Alert manager

## Cleanup:
To clean up the resources created, use the following command:

  ```bash
  terraform destroy

