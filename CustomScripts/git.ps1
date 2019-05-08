#
# Initialize all new disks (not yet initialized)
#
$disk = Get-Disk | Where-Object {$_.partitionStyle -eq 'RAW'}
If([string]::IsNullOrEmpty($disk)-eq $false)
{
    #
    # Initialize Disks in RAW mode
    #
    Initialize-Disk -InputObject $disk -PartitionStyle MBR
    #
    # Create partitions
    #
    $disk | New-Partition -AssignDriveLetter -UseMaximumSize
    $partitions = get-partition |  Where-Object {$_.disknumber -ge 2}
    #
    # Format all volumes
    #
format-volume -Partition $partitions -FileSystem NTFS
}
#
# Install Chocolatey
#
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#
# Create a list of packages to be processed
#
$Packages = @("git", "git-credential-manager-for-windows", "DotNet4.5.2","vscode", "azcopy", "vscode-powershell", "armclient")
#
# Process eack package for installation
#
choco feature enable -n allowGlobalConfirmation
ForEach ($PackageName in $Packages)
{choco install $PackageName -y}
