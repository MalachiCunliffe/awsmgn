# Variables
$Username = "mgninstall"
$Password = "TO_UPDATE"  # Modify this password to ensure it is secure
$MGNInstallerURL = "https://aws-application-migration-service-ap-southeast-2.s3.amazonaws.com/latest/windows/AwsReplicationWindowsInstaller.exe"
$InstallerPath = "C:\Temp\AwsReplicationWindowsInstaller.exe"

# AWS Temporary Credentials
# To generate temporary credentials, use AWS STS AssumeRole API:
#   1. Create an IAM Role with AWSApplicationMigrationAgentInstallationPolicy
#   2. Run: aws sts assume-role --role-arn <role-arn> --role-session-name <session-name>
#   3. Extract AccessKeyId, SecretAccessKey, and SessionToken from the response
# Replace the values below with your temporary credentials
$AWSAccessKeyId = "YOUR_AWS_ACCESS_KEY_ID"
$AWSSecretAccessKey = "YOUR_AWS_SECRET_ACCESS_KEY"
$AWSSessionToken = "YOUR_AWS_SESSION_TOKEN"
$AWSRegion = "ap-southeast-2"

# Create a new local user and add to Administrators group
Write-Host "Creating local user $Username..."
$SecurePassword = ConvertTo-SecureString -AsPlainText $Password -Force
New-LocalUser -Name $Username -Password $SecurePassword -Description "Local admin user for AWS MGN" -FullName "MGN Installer"

# Add the user to the Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $Username
Write-Host "User $Username has been added to the Administrators group."

# Download the AWS MGN installer
Write-Host "Downloading AWS MGN agent installer..."
Invoke-WebRequest -Uri $MGNInstallerURL -OutFile $InstallerPath

# Install the AWS MGN agent with specified parameters including session token
Write-Host "Installing AWS MGN agent with temporary credentials..."

# Silent install, but leave replication OFF
Start-Process -FilePath $InstallerPath -ArgumentList "--region $AWSRegion --aws-access-key-id $AWSAccessKeyId --aws-secret-access-key $AWSSecretAccessKey --aws-session-token $AWSSessionToken --no-prompt --no-replication" -Wait

# Cleanup the installer
Remove-Item -Path $InstallerPath -Force
Write-Host "Installation complete and installer cleaned up."

# End of script
