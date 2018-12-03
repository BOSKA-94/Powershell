$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName VM2     
$cert
$secPassword = ConvertTo-SecureString -String 'Administrator2018' -Force -AsPlainText

$certPath = "Cert:\LocalMachine\My\$($cert.Thumbprint)"
Export-PfxCertificate -Cert $certPath -FilePath C:\cert\selfcert.pfx -Password $secPassword
Import-PfxCertificate -Password $secPassword -FilePath C:\cert\selfcert.pfx -CertStoreLocation 'Cert:\CurrentUser\My'