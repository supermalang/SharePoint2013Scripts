# On charge le SharePoint PowerShell Snapin
Write-Host
Write-Host " Chargement du Shell SharePoint " -ForegroundColor Black -BackgroundColor Gray
Write-Host
$snappin = Get-PSSnapin | Where-Object {$_.Name -eq 'Microsoft.SharePoint.PowerShell' }
if($snappin -eq $null){
    Add-PSSnapin Microsoft.SharePoint.PowerShell
}
Write-Host "     Shell SharePoint Chargé"

Register-SPWorkflowService -SPSite "http://bataxal1.sde.com" -WorkflowHostUri "http://spapp1.ibnet.com:12291" -AllowOAuthHttp
