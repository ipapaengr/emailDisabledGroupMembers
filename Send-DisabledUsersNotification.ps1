$groupName = 'SomeGroup'
$splat = @{
	To = 'recipient@domain.com'
	From = 'sender@domain.com'
	Subject = "Disabled users in group '$($groupName)'"
	SmtpServer = 'smtp.domain.com'
	# UseSsl = $true # Uncomment to use SSL
	# Port = 587     # Uncomment to use SSL
}
$disabledUsers = Get-ADGroup -Identity 'SomeGroup' -Property members |
	Select-Object -ExpandProperty Members |
	Get-ADUser |
	Where-Object {-not $_.Enabled} |
	Select-Object -ExpandProperty SamAccountName
If ($disabledUsers) {
	$body = @"
The following members of '$($groupName)' are currently disabled:
$($disabledUsers -join "`r`n")
"@
	Send-MailMessage @splat -Body $body
}
