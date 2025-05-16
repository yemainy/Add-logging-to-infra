# yemi-logready

## Project Overview

**yemi-logready** is an AWS infrastructure project designed to enhance observability by enabling detailed logging for your application environment. This project configures:

- **Application Load Balancer (ALB) access logging** to capture HTTP request data.
- **CloudWatch log groups** to collect logs from EC2 instances.
- Meaningful **tags** for all logging resources.
- Outputs key resource information such as ALB DNS, CloudWatch log group names, and S3 buckets for logs.
- Optional setup of CloudWatch metric filters, alarms, and dashboards for proactive monitoring.

---

## Features

- **ALB Access Logs** stored securely in an S3 bucket for auditing and traffic analysis.
- **CloudWatch Logs** for centralized application and system logs from EC2 instances.
- **Tagging** of all resources to enable easier identification and cost allocation.
- **CloudWatch Alarms and Dashboards** for real-time monitoring and alerting.
- Supports **HTTPS** with ACM certificates and Route 53 DNS integration.
  
---

## Prerequisites

- AWS account with appropriate permissions.
- Registered domain in Route 53 (e.g., `apexminders.com`).
- Terraform installed locally (version >= 1.0).
- ACM certificate for your subdomain (e.g., `logs.apexminders.com`).

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/yemi-logready.git
cd yemi-logready
````

### 2. Configure Terraform Variables

Edit `terraform.tfvars` or set environment variables for:

* `vpc_id` — Your existing VPC ID or create a new one.
* `subnet_ids` — List of public/private subnet IDs.
* `domain_name` — Your domain (e.g., `apexminders.com`).
* `alb_subdomain` — Subdomain for the ALB (e.g., `logs` for `logs.apexminders.com`).

### 3. Request and Validate ACM Certificate

* Request a certificate for your ALB domain (e.g., `logs.apexminders.com`) via AWS ACM.
* Validate via DNS by adding CNAME records in Route 53.

### 4. Deploy Infrastructure

```bash
terraform init
terraform apply
```

* Confirm the resources will be created.
* Review outputs after deployment:

  * ALB DNS name
  * CloudWatch Log Group names and ARNs
  * S3 bucket for ALB logs

### 5. Access Your Application

* Visit `https://logs.apexminders.com` (replace with your subdomain).
* The site should be secured with the ACM certificate and serve traffic via ALB.

### 6. Monitor Logs and Alerts

* Go to **AWS CloudWatch Logs** to view EC2 application logs.
* Check your **S3 bucket** for ALB access logs.
* (Optional) Configure CloudWatch dashboards and alarms as per the provided Terraform modules.

---

## Useful Terraform Outputs

| Output Name                 | Description                               |
| --------------------------- | ----------------------------------------- |
| `alb_dns_name`              | DNS name of the Application Load Balancer |
| `cloudwatch_log_group_name` | Name of CloudWatch log group for EC2 logs |
| `cloudwatch_log_group_arn`  | ARN of the CloudWatch log group           |
| `alb_logs_bucket`           | S3 bucket name storing ALB access logs    |

---

## Troubleshooting

* **502 Bad Gateway**: Ensure your EC2 instances are healthy and responding on the correct ports. ami must be userdata compatible html.
* **HTTPS certificate errors**: Make sure ACM certificate is validated and attached to the ALB listener.
* **Cannot access domain**: Verify Route 53 DNS records point to the ALB.

---

## Future Enhancements

* Add **Auto Scaling Groups** for EC2 instances.
* Integrate **CloudWatch alarms** and **SNS notifications**.
* Deploy **CloudWatch dashboards** for centralized monitoring.
* Automate **CI/CD** pipeline for application deployments.

---

## License

MIT License




