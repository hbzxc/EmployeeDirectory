$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$User = "hblazier@gsisg.com"
$Pword = Get-Content "$dir\$User.cred" | ConvertTo-SecureString

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
$Site = "https://gsicompanies.sharepoint.com/sites/EmployeeDirectory"

Connect-PnPOnline -Url $Site -Credentials $Credential

$loc = "$dir\EmployeeDirectory.csv"

$import = Import-CSV -path $loc
$ListLen = Get-PnPListItem -List "All"

$ListLen.ID | Out-File "$dir\CurList.txt"

$newArray = Get-Content -path "$dir\CurList.txt"
$FinalArray = $newArray.split(" ")
Write-Host $FinalArray[0]
Write-host "This is the new Array" $FinalArray[$ListLen.count - 1]

if ($ListLen.ID -ne $null) {
    Write-Host "List is not empty"
    for ($i = [int]$FinalArray[0]; $i -le $FinalArray[$ListLen.count - 1]; $i++) {
        $names = Get-PnPListItem -List "All" -Id $i
        Write-Host "Removing" 
        Remove-PnPListItem -List "All" -Identity $i -Force
    }
} else {
    Write-Host "List is empty"
}

Start-Sleep -seconds 5

foreach ($Record in $import){
    Write-Host "updating the List for" $Record.'First Name'
    Add-PnPListItem -List "All" -Values @{
    "Title" = $Record.'Display Name';
    "Email" = $Record.'Primary Email';
    "SecondaryEmail" = $Record.'Alternate Email';
    "JobTitle" = $Record. 'Job Title';
    "Department" = $Record.'Department';
    "PhoneNumber" = $Record.'Phone';
    "Location" = $Record.'Location'
    }
}

Start-Sleep -seconds 5
Write-Host "This is the legnth of the list now --------" $ListLen.count