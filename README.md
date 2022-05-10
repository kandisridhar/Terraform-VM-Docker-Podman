
Azure Terraform Application deployment into Virtual Machine
# Azure-Terraform-Dotnet-POC

                                               Set Up Environment in Azure Via Terraform

Pre-Requiesites :
1. Azure Subscription
2. Download Terraform
3. Write Terraform files to create Environmnet in Azure . Environment consist  of Vnet,Subnets,Instances(public subnet – VM, Private Subnet – SQL database).  

Azure DevOps CI/CD Pipelines :-

CI Pipeline :
	1. Repositiory name to retrieve files (Azure Repo,Git)
	2. Tasks List for Artifact creation
	3. Dotnet Core Application consists following tasks
	i.    Restore
	ii    Build
	iii.  Publish
	iv.  Copy Files of Terraform to Artifact
	v.   PublishBuildArtifacts

CD Pipeline : 
	1. Define Artifact
	2. Stages :
	    Environment Creation Stage : (Agent Pool – Hosted Agent) 
			i. Create Storage accont and container to store Terraform State file (Azure CLI)
			ii. Get Storage account key by using Powershell commands.
				$key=(Get-AzureRmStorageAccountKey -ResourceGroupName 
				$(terraformstoragerg) -AccountName $(terraformstorageaccount)).Value[0]
				Write-Host "Power shell Output"
				Write-Host "##vso[task.setvariable variable=storagekey;]$key"
			 
			iii. Replace Tokens to replace variable values .
			iv. Terraform Installer
			v. Terraform init
			vi. Terraform plan
			vii. Terraform validate and apply
	    
		Note : Once Environment creation completed, we have to create Self-Hosted Agent for  Copy files task in next stage. Pre-Apprval Condition need to implement before Application Deployment stage.
	   
	   Application Deployment into VM stage : (Agent Pool – Self-Hosted Agent)
		       i. Copy files Task 