
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