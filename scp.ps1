<#
.SYNOPSIS
Script for downloading/uploading files to a remote Linux-based host using scp.
.DESCRIPTION
Run either full script, or pieces of it as needed. This script will load the 'Posh-SSH' module from PowerShell Gallery for the Get-SCPItem and Set-SCPItem commands: https://www.powershellgallery.com/packages/Posh-SSH If there are any errors with loading/installing the 'Posh-SSH' module, try Running as Administrator.

SETUP INSTRUCTIONS: 
1. Edit this file (scp.ps1): Change the variables in the Param() block below to match the details for your target host.
    - This project is based on using a Raspberry Pi as your server, so most of the defaults below should work with other Pi configs too.
2. Run the full script. You will be asked to type in the server password on first-time-run. First all the download operations will happen, and then uploads, so any errors about there being no files to download yet on first-run can be ignored. A new folder called 'download' will be created on the local machine for this. This script can be run over-and-over again multiple times to populate it.
    - For more info & tips on running PowerShell .ps1 scripts, see the NOTES section of this help text.

TIP: Once credentials are stored securely in the $cred var, the password does not need to be typed in again to re-run more scp commands (Get-SCPItem and Set-SCPItem). This only works if the $cred var stays saved in the same PowerShell session. The best way to do this is to open this script in either PowerShell ISE (built-in to Windows, just search it in the Start Menu) or vscode (Visual Studio Code, Microsoft has ceased development on ISE and this is now the officially-recommended PowerShell editor). Alternatively you can still run it from a PowerShell.exe terminal too, but to keep the vars loaded in the session you must 'dot-source' the script while calling it. For example:
PS\> cd "C:\path to\python-pi-multi-dyndns"
PS\> . .\scp.ps1
Note the very first period/dot, then a space, then the path to the .ps1 file to execute. This format is required for 'dot-sourcing'.
.NOTES
If you've never run a powershell script before, the 'PowerShell ISE' software included with Windows is recommened, so you won't have to download anything new. (Just search for it in Start menu). You can run either the whole script or specific selected parts of it.
However ISE is no longer maintained, and the PowerShell editor officially recommended by Microsoft is now vscode (Visual Studio Code). Plus with vscode you can edit PowerShell, Python, shell scripts, etc. side-by-side.
Or, to run this script directly from a powershell.exe terminal, you must dot-source it with a period and a space:
C:\> . "C:\Users\my cool username\Documents\GitHub\python-pi-multi-dyndns\scp.ps1"
- or -
C:\> . "$env:USERPROFILE\Documents\GitHub\python-pi-multi-dyndns\scp.ps1"
If you get Execution Policy errors, try:
C:\> Get-ExecutionPolicy
C:\> Set-ExecutionPolicy RemoteSigned
C:\> Set-ExecutionPolicy Unrestricted
C:\> Set-ExecutionPolicy Bypass
Each of these commands is in order from least-risky to most-risky. Recommended to start with 'RemotedSigned' then test if the script will run, and only work your way down this list if it doesn't.
For more info, type:
C:\> help about_Execution_Policies
.EXAMPLE
. "$env:USERPROFILE\Documents\GitHub\python-pi-multi-dyndns\scp.ps1"

This command uses the dot-source method to call this script and will keep its vars loaded in the current session. On first run you will be required to type in the server's password, but after that, those credentials will be stored securely in memory.

The $env:USERPROFILE environment var will return the path to the current user's profile folder, e.g.: "C:\Users\User Name"
.LINK
https://www.powershellgallery.com/packages/Posh-SSH
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
# Parameters setup

# Set-up the remaining vars we'll need for the rest of the script:

Write-Host "Store password to remote host securely in a encrypted var for later use:"

If (!$cred) {$cred = Get-Credential -Message "Storing credentials securely in-memory for later scp file operations" -UserName $RemoteUsername}

# Download params for later use:
$DownloadLocalPath = "$LocalFolder" + "download"
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

If (!(Test-Path -Path $DownloadLocalPath)) {mkdir $DownloadLocalPath}
Get-SCPItem -ComputerName $RemoteComputer -Credential $cred -Destination $DownloadLocalPath -Path $RemotePathDL -Port $Port -PathType $PathType

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "UPLOAD operations using Set-SCPItem"

# Fresh upload of all files:

$LocalPath = $LocalSubFolder
Set-SCPItem -Destination $RemotePathUL -Path $LocalPath @RemoteParams

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Upload sensitive parameters folder:

$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "params"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams

# Upload lib folder:

$LocalLibPath = Join-Path -Path $LocalSubFolder -ChildPath "lib"
Set-SCPItem -Destination $RemotePathDL -Path $LocalLibPath @RemoteParams

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Upload dynamic DNS python script:

$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "dyndns.py"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams

# Upload log cleanup shell script:

$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "logcleanup.sh"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams

# Upload setup.sh script:

$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "setup.sh"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams

# Upload log files:

<#
$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "dyndns.log"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams

$LocalPath = Join-Path -Path $LocalSubFolder -ChildPath "dyndns-LastMonth.log"
Set-SCPItem -Destination $RemotePathDL -Path $LocalPath @RemoteParams
#>

#-----------------------------------------------------------------------------------------------------------------------



