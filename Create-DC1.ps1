#Script to create TROUGHTON

#Declare Variables
$VMStore  = 'D:\Virtual Machines'
$VHDStore = 'D:\Virtual Hard Disks'
$VMSwitch = "vSwitch-LAN"

$VMName    = 'Lab-DC1'
$VMRAM     = 1024MB
$OSDrive   = 20GB
$DataDrive = 5GB
$ISO       = 'E:\~ISOStore\Windows\Server 2019\en_windows_server_2019_updated_sept_2019_x64_dvd_199664ce.iso'

#Create Folder Structure
$VMRoot  = "$VMStore\$VMName"
$VHDPath = "$VHDStore\$VMName"
If (!(Test-Path $VMRoot)) { New-Item -ItemType Directory -Path $VMRoot }
If (!(Test-Path $VHDPath)) { New-Item -ItemType Directory -Path $VHDPath }

#region Create OS Drive VHD
If (!(Test-Path -Path "$VHDPath\OSDrive.vhdx")) {
    Write-Host "Creating Virtual Disk $VHDPath\OSDrive.vhdx"
    $VHD = New-VHD -Path "$VHDPath\OSDrive.vhdx" -Fixed -SizeBytes $OSDrive
}
Else {
    Write-Host "Using existing Virtual Disk $VHDPath\OSDrive.vhdx"
    $VHD = Get-VHD -Path "$VHDPath\OSDrive.vhdx"
}
#endregion

#region Create Data Drive VHD
If (!(Test-Path -Path "$VHDPath\DataDrive.vhdx")) {
    Write-Host "Creating Virtual Disk $VHDPath\DataDrive1.vhdx"
    $VHD = New-VHD -Path "$VHDPath\DataDrive.vhdx" -Fixed -SizeBytes $DataDrive
}
Else {
    Write-Host "Using existing Virtual Disk $VHDPath\DataDrive.vhdx"
    $VHD = Get-VHD -Path "$VHDPath\DataDrive.vhdx"
}
#endregion

#Create new VM
Write-Host "Create VM $VMName"
$VM = New-VM -Path $VMStore -Name $VMName -MemoryStartupBytes $VMRAM -Generation 2
Set-VM -Name $VMName -ProcessorCount 2
Write-Host "Add VHD to VM $VMName"
Add-VMHardDiskDrive -Path $($VHD.Path) -VM $VM -ControllerType SCSI  #Add VHDX to VM
Remove-VMNetworkAdapter -VM $VM                                                 #Remove vNIC created with VM
Add-VMNetworkAdapter -VM $VM -SwitchName $VMSwitch                              #Add vNIC attached to vSwitch
Add-VMDvdDrive -VM $VM –Path $ISO -ControllerNumber 0