@description('The name of the Managed Cluster resource.')
param clusterName string = 'aks101cluster'

@description('The location of the Managed Cluster resource.')
param location string //= resourceGroup().location

@description('The location of the DNS zone.')
param dnsLocation string = 'global'

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 8

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param agentCount int = 3

@description('The size of the Virtual Machine.')
param agentVMSize string = 'standard_d2s_v3'

@description('User name for the Linux Virtual Machines.')
param linuxAdminUsername string = 'mouser101'

@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAB...snip...UcyupgH azureuser@linuxvm\'')
param sshRSAPublicKey string

@description('The name of the Azure Container Registry (ACR).')
param acrName string = 'aks101moacr'

@description('The SKU for the ACR (Basic, Standard, Premium).')
param acrSku string = 'Standard'

@description('The name of the DNS zone (e.g., example.com)')
param domainName string

resource acr 'Microsoft.ContainerRegistry/registries@2022-12-01' = {
  name: acrName
  location: location
  sku: {name: acrSku}
  properties: {}
}

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
    // ACR integration: Grant AKS access to the ACR
    addonProfiles: {
      AzureKeyvaultSecretsProvider: {
        enabled: false
      }
    }
  }
}

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: domainName
  location: dnsLocation
}

resource manageDisk 'Microsoft.Compute/disks@2024-03-02' = {
  name: '${clusterName}-disk'
  location: location
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 8
  }
}

// Role assignment to allow AKS to pull images from ACR
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(aks.id, 'acrpull-role-assignment')  // Ensure a unique name
  scope: acr
  properties: {
    principalId: aks.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // //'AcrPull'  // Role to allow pulling from ACR
    principalType: 'ServicePrincipal'
  }
}

// Role assignment to allow AKS to pull images from ACR
resource roleAssignmentDiskAKS 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(aks.id, 'disk-contributer-role-assignment')  // Ensure a unique name
  scope: acr
  properties: {
    principalId: aks.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
    principalType: 'ServicePrincipal'
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
