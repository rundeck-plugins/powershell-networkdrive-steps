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
	[string]$Driver,
	[string]$Path,
	[string]$User,
	[string]$Pass,
    [string]$Override
	)

begin {

}

process {

	try{

		Write-Host "Driver: $($Driver)"
		Write-Host "Path directory: $($Path)"
        Write-Host "Username: $($User)"
        Write-Host "Override: $($Override)"

        If ((Test-Path "$($Driver):") -and $Override -eq "false")
		{
			Write-Host "Drive already exists, skipping mapping"
			exit 0

		}else{


            If ((Test-Path "$($Driver):") -and $Override -eq "true"){
                Invoke-Expression -Command "net use $($Driver): /delete"
            }

	    $jobName =  "RundeckJobs-Mapping$($Driver)"

            Get-ScheduledJob  | Where-Object {$_.name -eq $jobName} | ForEach-Object {
                write-host "Job exists, removing!"
                Unregister-ScheduledJob -Name $($_.name) -Force
            }
	    
	    $Path = $Path -replace '^\s'
	    $Path = $Path -replace '\s$'

			Register-ScheduledJob -Name $jobName -ScriptBlock {
					param($Driver,$Path,$User,$Pass)

                    try{
                        Invoke-Expression -Command "net use $($Driver): `"$($Path)`" $($Pass) /user:$($User)"
                        #New-PSDrive -Persist  -Scope Global  -Name $Driver -PSProvider "FileSystem" -Root $Path
                    }catch [System.Exception]{
                        Write-host "Error creating mapping"
                    }

				} -ArgumentList ($Driver,$Path,$User,$Pass) | Out-Null

			Write-Host "Drive mapped registered"
		} 		

	}Catch{
        Write-Error "Error: $($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
        exit 1
    }

}
