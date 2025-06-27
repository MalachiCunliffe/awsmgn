# Variables
$Username = "mgninstall"
$Password = "TO_UPDATE"  # Modify this password to ensure it is secure
$MGNInstallerURL = "https://aws-application-migration-service-ap-southeast-2.s3.amazonaws.com/latest/windows/AwsReplicationWindowsInstaller.exe"
$InstallerPath = "C:\Temp\AwsReplicationWindowsInstaller.exe"

# AWS Credentials (Replace with the credentials from the IAM user in the target AWS account)
$AWSAccessKeyId = "YOUR_AWS_ACCESS_KEY_ID"
$AWSSecretAccessKey = "YOUR_AWS_SECRET_ACCESS_KEY"
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

# Install the AWS MGN agent with specified parameters
Write-Host "Installing AWS MGN agent..."
Start-Process -FilePath $InstallerPath -ArgumentList "--region $AWSRegion --aws-access-key-id $AWSAccessKeyId --aws-secret-access-key $AWSSecretAccessKey --no-prompt" -Wait

# Cleanup the installer
Remove-Item -Path $InstallerPath -Force
Write-Host "Installation complete and installer cleaned up."

# End of script