Get-Contact -Filter 'proxyaddresses -ne "$null"' -ResultSetSize $null -Properties DisplayName, proxyAddresses, Distinguishedname -searchBase (Get-ADDomain | select -ExpandProperty DistinguishedName) |
    select DisplayName,
@{n = "OU" ; e = {$_.Distinguishedname | ForEach-Object {($_ -split '(OU=)',2)[1,2] -join ''}}},
@{n = "PrimarySMTP" ; e = {( $_.proxyAddresses | ? {$_ -cmatch "SMTP:*"}).Substring(5) -join ";" }},
@{n = "smtp" ; e = {( $_.proxyAddresses | ? {$_ -cmatch "smtp:*"}).Substring(5) -join ";" }},
@{n = "x500" ; e = {( $_.proxyAddresses | ? {$_ -match "x500:*"}).Substring(0) -join ";" }},
@{n = "SIP" ; e = {( $_.proxyAddresses | ? {$_ -match "SIP:*"}).Substring(4) -join ";" }} |
    Export-Csv ADContacts.csv -NTI  
