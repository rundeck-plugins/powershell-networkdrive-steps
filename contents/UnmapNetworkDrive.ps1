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

process {

	try{

		Write-Host "Removing DriveLetter: $($DriveLetter)"

		$username = $env:RD_NODE_USERNAME
		$jobName =  "RundeckJobs-Mapping"
		
		Get-ScheduledJob  | Where-Object {$_.name -eq $jobName} | ForEach-Object { 
			Unregister-ScheduledJob -Name $($_.name) -Force
		}
		
		If (-Not (Test-Path "$($DriveLetter):"))
		{
			Write-Host "Drive doesn't exists, skipping removing"
			exit 0

		}

		#Remove-PSDrive -Name $DriveLetter
		Invoke-Expression -Command "net use $($DriveLetter): /delete"

	}Catch{
        Write-Error "Error: $($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
        exit 1
    }



}