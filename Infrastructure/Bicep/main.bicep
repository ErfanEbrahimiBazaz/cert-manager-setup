targetScope='subscription'

param resourceGroupName string = 'CertificateIssuer101'
param resourceGroupLocation string = 'westeurope'

resource newRG 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}

module aksModule 'aks.bicep' = {
  name: 'deployAks'
  scope: newRG
  params: {
    clusterName: 'aks101cluster'
    dnsPrefix: 'aks101'
    location: resourceGroupLocation
    agentCount: 3
    agentVMSize: 'Standard_D2s_v3'
    osDiskSizeGB: 0
    linuxAdminUsername: 'azureuser'
    sshRSAPublicKey: '<replace with your own key>'
  }
}
