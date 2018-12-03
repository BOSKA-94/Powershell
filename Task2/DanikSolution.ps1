$yt_api_key = "trnsl.1.1.20181108T081418Z.b856c76d6324e41f.6d4ff5458c8894d1502134d4e322e27841317fc9"; 
$yt_lang = "ru-en";

$uriFile = 'https://raw.githubusercontent.com/daniilkorytko/Different/master/Test3.json'
$MainText = (Invoke-WebRequest -Uri $uriFile).Content

$MainText = $MainText.Replace('т. е.','то есть')
$MainText = $MainText.Replace(';',',')
$MainText = $MainText.Replace("`t"," ")

$text = @{
    text =@{
        paragraphs =@()
    }
}

$MainParag = $MainText.Split("`n")

for($nomerPar = 0; $nomerPar -lt $($MainParag.Length); $nomerPar++)
{
    
    $yt_text = $MainParag[$nomerPar]
    if($yt_text -like ""){break;}

    $strings = $yt_text.Split(".") 

    $yt_link = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=$yt_api_key&text=$yt_text&lang=$yt_lang";
    $InvokeWebRequest = Invoke-WebRequest -URI $yt_link 
    $Per = $InvokeWebRequest.Content | convertFrom-json 

    $rezText = $Per.text
    $rezText = $rezText.Replace('e.g.','that is')
    $rezStrings = $rezText.Split(".") 

    $finalTest = ""
    for($nomerString=0; $nomerString -lt $strings.Length; $nomerString++){
        if($strings[$nomerString] -match "[a-z]"){
            $finalTest += $strings[$nomerString]
        }
        else {
            $finalTest += $rezStrings[$nomerString]
        }
        if($nomerString -ne $($strings.Length-1)){$finalTest +='.'}
    }

    $text.text.paragraphs += [ordered]@{ index = "$($nomerPar+1)"; Original = "$yt_text"; Translated = "$finalTest" }

}
$text | ConvertTo-json -Depth 5| Out-File '.\Task2Korytko.json' -Force

Export-Clixml -Path '.\Task2Korytko.xml' -InputObject $text -Depth 5 -Force