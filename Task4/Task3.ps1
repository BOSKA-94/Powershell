$uri = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$path = "C:\Users\Kiryl_Baskaulau\Desktop\Powershell\Task4\HtmlAgilityPack.1.8.10\lib\Net45\HtmlAgilityPack.dll"
Invoke-WebRequest -Uri $uri -OutFile "nuget.exe" -UseBasicParsing -Verbose
.\nuget.exe install HtmlAgilityPack -Version 1.8.10 
[HtmlAgilityPack.HtmlWeb]$web = @{}
[HtmlAgilityPack.HtmlDocument]$git = $web.LoadFromBrowser("https://github.com/trending") 
[HtmlAgilityPack.HtmlNodeCollection]$Names = $git.DocumentNode.SelectNodes("//h3")
$NamesList = $Names.innertext 
[HtmlAgilityPack.HtmlNodeCollection]$Address = $git.DocumentNode.SelectNodes("//h3/a")
$AddressList = $Address.innertext 
$AddressList = $AddressList.Replace(" ", "")
[HtmlAgilityPack.HtmlNodeCollection]$Stars = $git.DocumentNode.SelectNodes("//a[1][@class='muted-link d-inline-block mr-3']") 
$Starscount = $Stars.innertext
[HtmlAgilityPack.HtmlNodeCollection]$Starstoday = $git.DocumentNode.SelectNodes("//span[@class='d-inline-block float-sm-right']")     
$Starstodaycount = $Starstoday.innertext 
[HtmlAgilityPack.HtmlNodeCollection]$Language = $git.DocumentNode.SelectNodes("//span[@itemprop='programmingLanguage']")
$LanguageList = $Language.innertext  
$Giturl = "https://github.com/"
$json = @{
    Trending = @{
        Repositories = @()
    }
}
for ($n = 0; $n -lt $NamesList.Count; $n++) {
    $json.Trending.Repositories += [ordered]@{ 
        Name       = "$($Nameslist[$n])";
        Addres     = "$($Giturl + $AddressList[$n])";
        Language   = "$($LanguageList[$n])";
        StarsTotal = "$($StarsCount[$n])";
        StarsToday = "$($Starstodaycount[$n])" 
    }
}
$json | ConvertTo-json -Depth 5| Out-File '.\Task4Baskaulau.json' -Force