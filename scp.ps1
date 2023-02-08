<#
.SYNOPSIS
Script for downloading/uploading files to a remote Linux-based host using scp.
.DESCRIPTION
Run either full script, or pieces of it as needed. Once credentials are stored securely in the $cred var they do not need to be typed in again.
Instructions: Change the Param() block below to match the details for your target host.
.NOTES
If you've never run a powershell script before, the PowerShell ISE software included with Windows is recommened, so you won't have to download anything new. You can run the whole script or specific selected parts of it while editing.
But ISE is no longer maintained and the new PowerShell editor recommended by Microsoft is now vscode. Plus with vscode you can edit PowerShell and Python scripts side-by-side.
Or, to run this script directly from a powershell.exe terminal, you must dot-source it with a period and a space:
C:\> . "C:\Users\my username\Documents\GitHub\Python-DynDNS\scp.ps1"
If you get ExecutionPolicy errors, try:
C:\> Set-ExecutionPolicy Bypass
.EXAMPLE
. "$env:USERPROFILE\Documents\GitHub\Python-DynDNS\scp.ps1"
.PARAMETER RemotePathDL
Download path for the remote computer. This should point directly to the folder to be downloaded.
E.g.:
"/home/pi/dyndns"
.PARAMETER RemotePathUL
Upload path to the remote computer. If copying a whole folder, this should point to the parent folder to be copied into.
E.g.:
"/home/pi/"
#>
[CmdletBinding()]
Param (
	$RemoteComputer = "10.210.69.42",
	$Port = 22,
	$RemoteUsername = "pi",
	$RemotePathDL = "/home/pi/dyndns",
	$RemotePathUL = "/home/pi/",
	$LocalFolder = "$env:USERPROFILE\Documents\GitHub\python-pi-multi-dyndns\"
)

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Install Posh-SSH module from PSGallery for Get-SCPItem and Set-SCPItem commands:"

#https://www.powershellgallery.com/packages/Posh-SSH
$ModuleName = "Posh-SSH"
Try {
	Import-Module $ModuleName -ErrorAction Stop
} Catch {
	Install-Module $ModuleName
}

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Store password to remote host securely in a encrypted var for later use:"

If (!$cred) {$cred = Get-Credential -Message "Storing credentials securely in-memory for later scp file operations" -UserName $RemoteUsername}

# Download params for later use:
$LocalPath = "$LocalFolder" + "download"
#$PathType = "File"
$PathType = "Directory"

# Setup Upload parameters for later use:
$RemoteParams = @{
	ComputerName = $RemoteComputer
	Credential = $cred
	Port = $Port
}
$LocalSubFolder = Join-Path -Path $LocalFolder -ChildPath "dyndns"

#/Parameters setup
#-----------------------------------------------------------------------------------------------------------------------

Write-Host "DOWNLOAD operations using Get-SCPItem:"

# Download all DynDNS folder files

If (!(Test-Path -Path $LocalPath)) {mkdir $LocalPath}
Get-SCPItem -ComputerName $RemoteComputer -Credential $cred -Destination $LocalPath -Path $RemotePathDL -Port $Port -PathType $PathType

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "UPLOAD operations using Set-SCPItem"

# Fresh upload of all files:

$LocalPath = $LocalSubFolder
Set-SCPItem -Destination $RemotePathUL -Path $LocalPath @RemoteParams

# Upload sensitive parameters folder:

$ParamsPath = "$RemotePathDL"
$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "params"
Set-SCPItem -Destination $ParamsPath -Path $LocalPath @RemoteParams

# Upload dynamic DNS python script:

$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "dyndns.py"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams

# Upload log cleanup shell script:

$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "logcleanup.sh"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams

# Upload setup.sh script:

$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "setup.sh"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams

# Upload rand.sh script:

$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "rand.sh"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams

#-----------------------------------------------------------------------------------------------------------------------

# Upload log files:

<#
$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "dyndns.log"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams

$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "dyndns-LastMonth.log"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams
#>

#-----------------------------------------------------------------------------------------------------------------------



