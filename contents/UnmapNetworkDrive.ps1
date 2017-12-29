#Requires -Version 4
<#
.SYNOPSIS
  Sandbox Create
.DESCRIPTION
  Map a drive from path
.PARAMETER DriveLetter
    DriveLetter
.NOTES
  Version:        1.0.0
  Author:         Rundeck
  Creation Date:  12/12/2017
  
#>

Param (
	[string]$DriveLetter
)

Begin {
	try{

		Write-Host "Removing DriveLetter: $($DriveLetter)"

		If (-Not (Test-Path "$($DriveLetter):"))
		{
			Write-Host "Drive doesn't exists, skipping removing"
			exit 0

		}

 		Remove-PSDrive -Name $DriveLetter


	}Catch{
        Write-Error "Error: $($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
        exit 1
    }



}