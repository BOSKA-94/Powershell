$list = Get-Content .\servers.txt
$servers = @{
    Servers = @()
}
function GetInfo {
    Param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [array[]]
        $list
    )
    foreach ($i in $list) {
        $Freespace = (Invoke-Command -ThrottleLimit 3 -ComputerName $i -ScriptBlock {((get-WmiObject win32_logicaldisk) | Where-Object {$_.deviceID -eq "C:"})}).freespace / 1gb

        $CPU = Invoke-Command -ThrottleLimit 3 -ComputerName $i -ScriptBlock {Get-Process | Sort-Object cpu -Descending | Select-Object -First 5 -Property Name, Id}

        $LoadCPU = (Invoke-Command -ThrottleLimit 3 -ComputerName $i -ScriptBlock {Get-WmiObject win32_processor | select LoadPercentage}).LoadPercentage

        $servers.Servers += [ordered]@{ 
            NameServer  = [string]$i;
            Freespace   = $Freespace;
            ProcessName = $CPU.Name; 
            ProcessID   = $CPU.Id;
            LoadCPU     = $LoadCPU 
        }   
    }   
}
GetInfo($list)
$servers | ConvertTo-Json -Depth 5 | Out-File '.\Statistick.json' -Force


