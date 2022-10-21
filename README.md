# Set-AzureAdHardMatch.ps1
Hard match a User or Users to Azure AD

Start like:

Get-ADUser -Identity xxxxx | % { .\Set-AzureAdHardMatch.ps1 -ObjectGUID $_.ObjectGUID -UserPrincipalName $_.UserPrincipalName}
  
  or
  
Get-ADUser -Filter * -SearchBase xxxxx | % { .\Set-AzureAdHardMatch.ps1 -ObjectGUID $_.ObjectGUID -UserPrincipalName $_.UserPrincipalName}
