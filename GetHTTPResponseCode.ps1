# This script will iterate over a plaintext list and return the HTTP response code
# If the domain is not found, it will not product a HTTP response code
# Note: This requires Powershell V7 to utilise -skiphttperrorcheck

$uriFilePath = "C:\Users\$env:username\Desktop\uris.txt"
$outputpath = "C:\Users\$env:username\Desktop\UriResponseCodes.csv"

Get-Content $uriFilePath | 
Foreach {$uri = $_; 
try 
    {Invoke-WebRequest -uri $uri -Method GET -Headers @{"accept"="text/html"} -useragent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0" -skiphttperrorcheck}
catch
    {New-Object -TypeName psobject -Property @statuscode } } |
 Select @{Name="RequestURI";Expression={$uri}}, StatusCode |
 Export-Csv $outputpath