configuration Level2A
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {

        Registry DisableTLS10
        {
            Ensure      = "Present" 
            Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0"
            ValueName   = "Enabled"
            ValueData   = "0"
            ValueType = 'Dword'
        }
        Registry DisableTLS11
        {
            Ensure      = "Present" 
            Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1"
            ValueName   = "Enabled"
            ValueData   = "0"
            ValueType = 'Dword'
        }
        Registry EnableTLS12
        {
            Ensure      = "Present" 
            Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2"
            ValueName   = "Enabled"
            ValueData   = "1"
            ValueType = 'Dword'
        }
        File TestFile
        {
            DestinationPath = "C:\Temp\Reboot.bat"
            Ensure = 'Present'
            Contents = "shutdown -r -t 00 -f"            
        }
        WindowsFeature ADTools
        {
            Name = 'RSAT-ADDS-Tools'
            Ensure = 'Present'            
        }
		Script DisableFirewall
		{
			SetScript = 
			{ 
				Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
			}
			TestScript = {}
			GetScript = { @{ Result = (Get-NetFirewallProfile -Profile Domain,Public,Private) } }          
		}

    }
}