#2
ConvertTo-Html 
#example
Get-Process | ConvertTo-Html -Property Name, Path, Company -Title "Process Information" | Out-File proc.htm; ii proc.htm

Out-File; Export-Csv; Set-Content
format-*
Set-Alias -Name "Task" -Value Get-date
Get-Process S* 
Get-Date
New-NetFirewallRule -DisplayName "Block Outbound Port 80" -Direction Outbound -LocalPort 80 -Protocol TCP -Action Block
Get-Date -Year ((Get-Date).Year - 100)
(Get-Date -Year ((Get-Date).Year - 100)).DayOfWeek
(Get-Hotfix).InstalledOn
Add-Content -Path C:\1.txt -Value "Task"