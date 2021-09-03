$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$User = "hblazier@company.com"
$Pword = Get-Content "$dir\$User.cred" | ConvertTo-SecureString
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

$loc = "$dir\NotHDT.csv"

<#
Get-Content -path $loc -Encoding UTF8

$A = Import-Csv -Path $loc
$A | Get-Member
$A | Select-Object owner | = $test
$test

#>


$import = Import-CSV -path $loc

ForEach ($i in $import) {

    $PhNumber = $i.'Phone Changes'
    $AD = $i.AD
    $user = get-aduser $ad
    set-aduser -Identity $AD -OfficePhone $PhNumber
}

Connect-AzureAD -Credential $Credential 
Connect-MsolService -Credential $Credential



#turns off error reporting
#$ErrorActionPreference = "SilentlyContinue"


ForEach ($i in $import) {
    $PhNumber = $i.'Phone Changes'
    $email = $i.UserPrincipalName
    $PhoneCarrier = $i.'Phone Carrier'

    Write-Host "Updating "$email

    set-AzureADUser -ObjectID $email -TelephoneNumber $PhNumber

    <#
    if ($PhoneCarrier -eq "HDT") {
        set-AzureADUser -ObjectID $email -TelephoneNumber $PhNumber
        Write-Host "Setting up office Phone"
    } else {
        set-AzureADUser -ObjectID $email -mobile $PhNumber
        Write-Host "Setting up mobile Phone"
    }#>
}

#$FirstName = "Henry"
#$LastName = "Blazier"
#$PhNumber = "000-000-0000"
#get-aduser -filter {(surname -eq $LastName) -and (GivenName -eq $FirstName)} | set-aduser -add @{"telephoneNumber"=$PhNumber}