param(
    [string]$filename = ''
)
$params = @{
    NotAfter = (Get-Date).AddYears(10)
    CertStoreLocation = 'Cert:\CurrentUser\My'
    Type = 'CodeSigning' 
    FriendlyName =  $filename
}
New-SelfSignedCertificate @params
Export-Certificate -Cert (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Where-Object{($_.FriendlyName -eq $filename)})[0] -FilePath code_signing.crt
Import-Certificate -FilePath .\code_signing.crt -Cert Cert:\CurrentUser\TrustedPublisher
Import-Certificate -FilePath .\code_signing.crt -Cert Cert:\CurrentUser\Root
Set-AuthenticodeSignature "$($filename).exe" -Certificate (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Where-Object{($_.FriendlyName -eq $filename)})[0]