$text = @{
    text = @{
        paragraphs = @()
    }
}
$original = Get-Content -Path ".\Powershell.txt"
function Translate-English ($original) {
    $key = "trnsl.1.1.20181108T114951Z.4977d5af59387281.98991f28415537df638a9e22addb8d59a56e8916"
    $from = "ru"
    $to = "en"
    $out = Invoke-RestMethod -uri "https://translate.yandex.net/api/v1.5/tr.json/translate?key=$key&text=$original&lang=$from-$to&format=plain" 
    add-Content .\Text.txt -Value $out.text
}
foreach($i in $original) {
    Translate-English ($i)
}
$translated = Get-Content -Path ".\Text.txt"
for ($n = 0; $n -lt $($original.Length); $n++) {
    $text.text.paragraphs += [ordered]@{ 
        index      = "$($n+1)";
        Original   = "$($original[$n])";
        Translated = "$($translated[$n])" 
    }
}
$text | ConvertTo-json -Depth 5| Out-File '.\Task2Baskaulau.json' -Force
Export-Clixml -Path '.\Task2Baskaulau.xml'  -InputObject $text -Depth 5 -Force 
