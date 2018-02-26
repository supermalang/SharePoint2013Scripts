<#
    Auteur : Elhadji Malang DIEDHIOU
    Description : 
    Prerequis : 
    NB : Il y a des problèmes avec les sites de type Host Named Site Collection
    Voir l'article suivant : http://tanveerkhan-sharepoint.blogspot.sn/2015/05/issue-accessing-host-named-site.html
#>

# 1. Add the dll references files
#dll
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime") | Out-Null
 
#SOM
Add-PSSnapIn Microsoft.SharePoint.PowerShell


# Initialize client context object with the site URL.
$siteURL  = Read-Host -Prompt "Veuillez donner l'URL de la collection de site. Exemple : http://sp2013 "
$credentials = Get-Credential -Message "Veuillez renseigner vos identifiants d'administrateur SharePoint"

$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteURL) 
$ctx.Credentials = $credentials 

$web = $ctx.Site.RootWeb  
$userActions = $web.UserCustomActions  
$ctx.Load($userActions)   
$ctx.ExecuteQuery()   

$newRibbonItem = $userActions.Add()  
$newRibbonItem.RegistrationId = "0x0101004083F5C11E89854C8C533CDD54D27E5901"  
$newRibbonItem.Title = "Custom Ribbon"  
$newRibbonItem.RegistrationType = [Microsoft.SharePoint.Client.UserCustomActionRegistrationType]::ContentType  
$newRibbonItem.Location = "DisplayFormToolbar" 

$ribbonUI = '
<CommandUIExtension>  
                    <CommandUIDefinitions>  
                        <CommandUIDefinition Location="Ribbon.List.Actions.Controls._children">  
                            <Button Id="Ribbon.List.Actions.ShowAlert" Alt="Show Alert" Sequence="100"  
                                 Command="ShowRibbonAlert"  
                                 LabelText="Custom Alert"  
                                 TemplateAlias="o1"  
                                 Image32by32="_layouts/15/images/alertme.png"  
                                 Image16by16="_layouts/15/images/alertme.png" />  
                       </CommandUIDefinition>  
                    </CommandUIDefinitions>  
                    <CommandUIHandlers>  
                        <CommandUIHandler Command="ShowRibbonAlert"  
                             CommandAction="javascript:alert(''hi'');"/>  
                    </CommandUIHandlers>  
                </CommandUIExtension >'  
  
$newRibbonItem.CommandUIExtension = $ribbonUI  
$newRibbonItem.Update()  
$ctx.Load($newRibbonItem)  
$ctx.ExecuteQuery()  


$itemsToDelete = @()  
if($userActions.Count -le 0){  
    Write-Host "No Ribbon Items found to delete"  
}  
else{  
    foreach($userAction in $userActions){  
        $itemsToDelete += $userAction                  
    }  
    foreach($item in $itemsToDelete){  
        Write-Host "Deleting Ribbon Item : " $item.Title  
        $item.DeleteObject()  
    }  
    $ctx.ExecuteQuery()  
} 