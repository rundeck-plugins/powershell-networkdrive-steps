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

Begin {
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

		}else{
			New-PSDrive -Persist  -Scope Global  -Name $DriveLetter -PSProvider "FileSystem" -Root $Path

		} 		

	}Catch{
        Write-Error "Error: $($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
        exit 1
    }



}