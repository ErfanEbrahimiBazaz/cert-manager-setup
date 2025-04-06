# Define the resource group name to delete
$resourceGroupName = "CertificateIssuer101"

# Confirm with the user before proceeding (optional but recommended)
Write-Host "You are about to delete the resource group: $resourceGroupName"
$confirmation = Read-Host "Are you sure? (yes/no)"

if ($confirmation -eq "yes") {
    # Execute the az cli command to delete the resource group
    Write-Host "Deleting resource group $resourceGroupName..."
    az group delete --name $resourceGroupName --yes --no-wait

    # Check the exit code to confirm success
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Resource group $resourceGroupName deletion initiated successfully."
    } else {
        Write-Host "Error: Failed to initiate deletion of resource group $resourceGroupName. Please check your Azure CLI setup or permissions."
    }
} else {
    Write-Host "Deletion aborted by user."
}