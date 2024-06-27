# tf-imm-lab-basic


This repo contains basic labs for learning the Intersight provider for Terraform.

  Instructions for each lab module are in-line in the "main.tf" file
  for each lab module.

The primary requirement for this lab is to have two variables set to access Intersight.
The easiest way to set them for TF is to set local environment variables with the prefix TF_VAR_

## Intersight Variables (Mac Examle)
export TF_VAR_apikey=<your_intersight_api_key>

export TF_VAR_secretkey=`cat ~/Downloads/SecretKey.txt` 

The above example is based on the secret key being in your Downloads folder.  Adjust for your environment.
You must add BackTics (same key as ~ tilda, not a single quote) around the "cat ~/Downloads/SecretKey.txt" in Export command.

It doesn't matter how you create the environment variables in your OS, as long as they are preceeded with TF_VAR_

On mac, run "env" from CLI to verify environment variables.  Note, they are not persistent.  If you close your CLI, they dissappear.

# Common Terraform Commands
terraform init -upgrade
terraform plan
terraform apply
terraform destroy
