$path = "C:\Users\Kiryl_Baskaulau\Desktop\Powershell\Task4\DISM.log"
$logs = Get-content -Path $path | where {$_ -match " Error "}
$message = $logs | where {$_ -match "(0x.*\d)"} | foreach {$Matches[0]}
$Global:count = 0;
foreach ($item in $logs) {
    if ($item -match "0x8") {
        $item + " " + $message[$count] | Out-File -FilePath C:\PowerShellLog.log -Append 
        $count++
    }
    else {
        $item + " No message code" | Out-File -FilePath C:\PowerShellLog.log -Append 
    }   
}