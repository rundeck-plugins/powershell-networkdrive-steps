#Requires -Version 4
<#
.SYNOPSIS
  Sandbox Create
.DESCRIPTION
  Map a drive from path
.PARAMETER DriveLetter
    DriveLetter
.PARAMETER Path
    The Path
.NOTES
  Version:        1.0.0
  Author:         Rundeck
  Creation Date:  12/12/2017
  
#>

Param (
	[string]$DriveLetter,
	[string]$Path
	)

begin {

}

process {

	try{

		If (-Not ( Test-Path $Path) )
		{
			Write-Error "Error: destination path doesn't exists"
        	exit 1
		}

		Write-Host "DriveLetter: $($DriveLetter)"
		Write-Host "Path directory: $($Path)"


		If ((Test-Path "$($DriveLetter):"))
		{
			Write-Host "Drive already exists, skipping mapping"
			exit 0

		}else{

			$nodeUsername = $env:RD_NODE_USERNAME
			$jobName =  "RundeckJobs-Mapping"

			Get-ScheduledJob  | Where-Object {$_.name -Match "$($jobName)*"} | ForEach-Object { 
				param($jobName) 
				write-host "Job exists, removing"
				Unregister-ScheduledJob -Name $jobName -Force 
            } -ErrorAction SilentlyContinue -ArgumentList ($jobName) | Out-Null

			Register-ScheduledJob -Name $jobName -ScriptBlock { 
					param($DriveLetter,$Path) 
					New-PSDrive -Persist  -Scope Global  -Name $DriveLetter -PSProvider "FileSystem" -Root $Path 
				} -ArgumentList ($DriveLetter,$Path)   | Out-Null
			
			(Get-ScheduledJob -Name $jobName).StartJob() | Out-Null

			Get-Job | Wait-Job | Out-Null
			
			Write-Host "Drive mapped successfully"

		} 		

	}Catch{
        Write-Error "Error: $($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
        exit 1
    }


}