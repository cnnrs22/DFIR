#Create I/O variables based on a list of single domains per line on the users desktop
$DNSFilePath = "C:\Users\$env:username\Desktop\DomainNames.txt"
$outputpath = "C:\Users\$env:username\Desktop\DNSResolution.csv"

#Get the DNS Names
$domainnames = Get-Content $DNSFilePath

#Start transcript for errors (this will be where you're able to see what domains failed)
start-transcript -path C:\Users\$env:username\Desktop\Errors.txt

#Iterate over the list
$dnsres = ForEach ($domain in $domainnames){Resolve-DnsName $domain -ErrorAction Continue}

#Create Empty Array
$DomainArray = @()

#Create loop and new object to iterate and store responses
ForEach ($d in $dnsres){
$DNSObj = New-Object PSCustomObject -Property @{
    Name = $d.Name
    TTL = $d.TTL
    Type = $d.Type
    IP = $d.IPAddress
    }
    $DomainArray += $DNSObj
}
$DomainArray | Export-Csv $outputpath -NoTypeInformation

Stop-Transcript

#clean up error file and oiut
Get-Content "C:\Users\$env:username\Desktop\Errors.txt" | Select-String "DNS name does not exist" -Context 0 | out-file "C:\Users\$env:username\Desktop\NXDomain.txt"
Get-Content "C:\Users\$env:username\Desktop\NXDomain.txt"