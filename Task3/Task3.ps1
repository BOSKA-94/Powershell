$path = "C:\Windows"
#Set-Location $path
$list = (Get-ChildItem -Path $path -Force -File *).Name
$maxJobs = 3
$results = @();
for ($i = 0; $i -lt $list.Count ; $i++) {
    $count = Get-Job | Where-Object {$_.state -eq "running"}
    if ($count.Count -lt $maxJobs) {
        $job = Start-Job -Name "Job$i" -ScriptBlock {
            param([int]$i,
                [string[]]$list)
            $file = $list[$i]
            Write-Output $file
        } -ArgumentList ($i, $list)
        $Results += Receive-Job -Name $job.Name;
    }
    else {
        ($job = Start-Job -Name "Job$i" -ScriptBlock {
                param([int]$i,
                    [string[]]$list)
                $file = $list[$file]
                Write-Output $file
            } -ArgumentList ($i, $list))
        $Results += Receive-Job -Name $job.Name;
        Start-Sleep -Milliseconds 30
    }
}
$Results
Get-Job | Where-Object {$_.state -eq "completed"} | Remove-Job