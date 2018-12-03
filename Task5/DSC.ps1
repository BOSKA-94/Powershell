Configuration InstallGit {
    param(
        [string[]]$ComputerName = "localhost",
        [string[]]$GitDir = "C:\PortableGit\"
    )
    Node $ComputerName {
        Script downloadGit {
            SetScript  = { 
                If (!(Test-Path -Path "$GitDir" -PathType Container)) { 
                    New-Item -ItemType Directory -Path "C:\" -Name "PortableGit"
                }
                $gitUri = "https://github.com/git-for-windows/git/releases/"
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $page = Invoke-WebRequest -Uri $gitUri -UseBasicParsing
                $LinkLatest = ($page.Links | where {$_.OuterHtml -match "(/git-for-windows/git/releases/download/)(.*)(PortableGit)(.*)(64-bit.7z.exe)"}).href | select -First 1 
                $downloadLinkLatest = "https://github.com" + $LinkLatest
                $LinkLatest | where {$_ -match "(PortableGit*)(.*)"} | foreach ($Matches[0])
                $fileNameLatest = $Matches[0]
                $fullPathLatest = Join-Path -Path $GitDir -ChildPath $fileNameLatest
                Invoke-WebRequest -Uri $downloadLinkLatest -OutFile $fullPathLatest -UseBasicParsing -Verbose 

                $LinkPrevious = ($page.Links | where {$_.OuterHtml -match "(/git-for-windows/git/releases/download/)(.*)(PortableGit)(.*)(64-bit.7z.exe)"}).href | select -First 2 | select -Last 1
                $downloadLinkPrevious = "https://github.com" + $LinkPrevious
                $LinkPrevious | where {$_ -match "(PortableGit*)(.*)"} | foreach ($Matches[0])
                $fileNamePrevious = $Matches[0]
                $fullPathPrevious = Join-Path -Path $GitDir -ChildPath $fileNamePrevious
                Invoke-WebRequest -Uri $downloadLinkPrevious -OutFile $fullPathPrevious -UseBasicParsing -Verbose 
            }
            TestScript = {
                Test-Path "C:\PortableGit\PortableGit*.exe"
            }
            GetScript  = {
                #Something             
            }
        }
        Script ExtractGit {
            SetScript  = {
                $PathGit = "C:\Users\Kiryl_Baskaulau\Downloads\PortableGit-2.19.1-64-bit.7z.exe";
                $DestinationGit = "C:\Git";       
                Function Expand-Archive([string]$Path, [string]$Destination) {
                    $7z_Application = "C:\Program Files\7-Zip\7z.exe"
                    $7z_Arguments = @(
                        'x'							## eXtract files with full paths
                        '-y'						## assume Yes on all queries
                        "`"-o$($Destination)`""		## set Output directory
                        "`"$($Path)`""				## <archive_name>
                    )
                    & $7z_Application $7z_Arguments 
                }
                Expand-Archive -Path $fullPathLatest -Destination $DestinationGit
            }
            TestScript = {
                Test-Path $DestinationGit
            }
            GetScript  = {
                #Something            
            }
        }
        Script installJRE {
            SetScript  = {
                $workdirectory = "c:\JRE"
                If (!(Test-Path -Path $workdirectory -PathType Container)) { 
                    New-Item -Path $workdirectory  -ItemType directory 
                }
                $arguments = '
                INSTALL_SILENT=Enable
                AUTO_UPDATE=Enable
                SPONSORS=Disable
                REMOVEOUTOFDATEJRES=1
                '
                $arguments | Set-Content "$workdirectory\jreinstall.cfg"
                $source = "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=230511_2f38c3b165be4555a1fa6e98c45e0808"
                $destination = "$workdirectory\jreInstall.exe"
                $client = New-Object System.Net.WebClient
                $client.DownloadFile($source, $destination)
                Start-Process -FilePath "$workdirectory\jreInstall.exe" -ArgumentList INSTALLCFG="$workdirectory\jreinstall.cfg"
                Start-Sleep -s 120
                $env:JAVA_HOME = "C:\Program Files (x86)\Java\jre1.8.0_161\bin"
            }
            TestScript = {
                Test-Path "C:\JRE"
            }
            GetScript  = {
                #Something            
            }
        }
    }
}
InstallGit 
Start-DscConfiguration  .\InstallGit -Verbose -Wait -Force -ComputerName 'localhost'