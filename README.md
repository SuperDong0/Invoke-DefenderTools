# Invoke-DefenderTools
PowerShell module with several useful Windows Defender functions to aid in post-exploitation.

```
PS D:\> Invoke-DefenderTools -help

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

PS D:\>
```

