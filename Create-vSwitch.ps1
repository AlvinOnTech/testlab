$vSwitchDef = [ordered]@{
   Name       = 'Lab-DMZ'
   SwitchType = 'Internal'
   Notes      = 'DMZ for Lab - 192.168.2.0/24'
}


If (!(Get-VMSwitch -Name $vSwitchDef['Name'])) {
    # If you can't find the vSwitch, create it
    New-VMSwitch @vSwitchDef
}
Else {
    # Set the new settings for the vSwitch
    Set-VMSwitch @vSwitchDef
}
