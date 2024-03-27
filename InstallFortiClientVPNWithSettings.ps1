<#
.SYNOPSIS
This script updates the FortiClient VPN and applies custom registry settings.

.DESCRIPTION
The script downloads the FortiClient VPN installer and a registry file from specified URLs, installs the VPN quietly without initiating a restart, applies the registry settings, and informs the user that a restart is required to complete the update process.

.NOTES
Author: Aviad Ofek
Date: [Insert Date Here]
Please ensure you have administrative privileges before running this script.

.EXAMPLE
To run the script, navigate to the directory containing the script and execute it using PowerShell with administrative privileges.
#>

# Define source URLs
$installerSourceUrl = "http://example.com/path/to/FortiClientVPN_Installer_Sample.exe"
$regFileSourceUrl = "http://example.com/path/to/SampleVPNSettings.reg"

# Define destination paths
$installerDestinationPath = "C:\temp\FortiClientVPN_OfflineInstaller_7.2.3.exe"
$regFileDestinationPath = "C:\temp\MyVPM.reg"

# Ensure the destination folder exists
if (-not (Test-Path -Path "C:\temp")) {
    New-Item -ItemType Directory -Force -Path "C:\temp"
}

# Download the installer and .reg file using Invoke-WebRequest
Invoke-WebRequest -Uri $installerSourceUrl -OutFile $installerDestinationPath
Invoke-WebRequest -Uri $regFileSourceUrl -OutFile $regFileDestinationPath

# Execute the installer silently without initiating a restart
Start-Process -FilePath $installerDestinationPath -ArgumentList "/quiet", "/norestart" -Wait

# Import the registry file silently
Start-Process -FilePath "regedit.exe" -ArgumentList "/s", "`"$regFileDestinationPath`"" -Wait

# Optionally, remove the installer and reg file after installation
Remove-Item -Path $installerDestinationPath
Remove-Item -Path $regFileDestinationPath

# Display a message to the user
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show('The FortiClient VPN has been updated. In order to complete the update, you must restart your computer as soon as possible. Thank you! - CP IT Department', 'Update Incomplete', 'OK', 'Information')

