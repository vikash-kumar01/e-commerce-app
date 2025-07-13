> [!IMPORTANT]  
> Before you begin setting up this project, make sure the following tools are installed and configured properly on your system:

## Setup & Initialization <br/>

### 1. Install Terraform
* Install Terraform<br/>
#### Linux & macOS
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```
### Verify Installation
```bash
terraform -v
```
### Initialize Terraform
```bash
terraform init
```
### 2. Install AWS CLI
AWS CLI (Command Line Interface) allows you to interact with AWS services directly from the command line.

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
```
###  Install AWS CLI in Windows 'powershell'
```msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi```


 ```aws configure```


> #### This will prompt you to enter:<br/>
- **AWS Access Key ID:**<br/>
- **AWS Secret Access Key:**<br/>
- **Default region name:**<br/>
- **Default output format:**<br/>

> [!NOTE] 
> Make sure the IAM user you're using has the necessary permissions. You’ll need an AWS IAM Role with programmatic access enabled, along with the Access Key and Secret Key.

## Getting Started

> Follow the steps below to get your infrastructure up and running using Terraform:<br/>

1. **Clone the Repository:**
First, clone this repo to your local machine:<br/>
```bash
git clone https://github.com/vikash-kumar01/e-commerce-app.git
cd terraform
```
2. **Generate SSH Key Pair:**
Create a new SSH key to access your EC2 instance:
```bash
ssh-keygen -f cloudwithvikash-key
```
This will prompt you to create a new key file named terra-key.

3. **Private key permission:** Change your private key permission:
```bash
chmod 400 cloudwithvikash-key
```

4. **Initialize Terraform:**
Initialize the Terraform working directory to download required providers:
```bash
terraform init
```
5. **Review the Execution Plan:**
Before applying changes, always check the execution plan:
```bash
terraform plan
```
6. **Apply the Configuration:**
Now, apply the changes and create the infrastructure:
```bash
terraform apply
```
> Confirm with `yes` when prompted.

7. **Access Your EC2 Instance;** <br/>
After deployment, grab the public IP of your EC2 instance from the output or AWS Console, then connect using SSH:
```bash
ssh -i cloudwithvikash-key ubuntu@<public-ip>
```
8. **Update your kubeconfig:**
wherever you want to access your eks wheather it is yur local machine or bastion server this command will help you to interact with your eks.
> [!CAUTION]
> you need to configure aws cli first to execute this command:

```bash
aws configure
```

```bash
aws eks --region us-east-1 update-kubeconfig --name mrdevops-dev-eks
```
9. **Check your cluster:**
```bash
kubectl get nodes
```
