<#
Powershell Skript - Written by Bosse Klein
This script checks if a Windows Service is running and exports the result to a textfile.
The textfile is used by the Prometheus Windows Exporter Textfile Collector.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$ServiceName
)

$arrService = Get-Service -Name "$ServiceName"
$exportPath = "C:\Prometheus\Textfile_Exporter\" + $ServiceName + "_Status.prom"

write-host $arrService

If (Test-Path $exportPath) {
    Remove-Item $exportPath
}
else {
    New-Item $exportPath -ItemType File
}

'# HELP Win_Service_Status_Check Checks if a Windows Service is running' | Out-File $exportPath
'# TYPE Win_Service_Status_Check gauge ' | Out-File $exportPath -Append

if ($arrService.Status -eq "Running") {
    'Win_Service_Status_Check{ServiceName="' + $ServiceName + '"} 1' | Out-File $exportPath -Append

} else {
    'Win_Service_Status_Check{ServiceName="' + $ServiceName + '"} 0' | Out-File $exportPath -Append
}

exit