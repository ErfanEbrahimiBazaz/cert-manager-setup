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
    sshRSAPublicKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDcY7LI+FAZRP7W+VfsQqWuDYsQR4qXruubSMYoqodwoXsUzHZ+BRvgP5tjLDdMKcUTml183CrikUxd73tC4odCcJ1bTt83tM7qrS8nkR8N5UGnHZHzNfpdKivNDYMoFxP9dIwYCJXcppJ4+aGbEAwwW2VLdmjdRHI86St83Xdwx/Ai4u2Nr5TfNdHfOLt9Vb+q9N/ERUYqnTJTpR7suraPdG8XK9mw2Fsq5GHo3GScy9eMkGyVYnrtk4eCAKEOJAkBfkoj05JPerQciwWkaLqnP8wjLC0jo0lSnBjUJGx/SEhSU2jD0wN5cmfK9f59a/WNDenuoz7YcnjBLjnBl3joe4o3Xd02yqVVuwkcqXbXVzCB/gEhbOEiUX1/Mjva1j5jMrGt3GYwu+wNCRAi7pyf+3D+QhDog4RMos1HXGwc7Guxv92ruXXuKuWhRvqw7nZogtpywBfN0iaTzm2xv3ehHMaUv15xR3H/A3KuwDJzCl2AWUrtnBEhmBnlC/HlwL4/VTGcshcqKb7kyJ/1GAVK0TFIdlNpvoKOD75BN+PpsrZBeRIgUhdLtv1G7xCCmZ84H3A9XwgD3DnJiuFLL04cRl+3vSe896vMH1wzmL8JE5fp1irzdBdFBTWG7pFzA/I5ApqV4HCSZUfzGIghP4xJ0azUtUOlpQw/OCwbYQWnjQ== erfan@FalconZanpakuto'
    domainName: 'moravaei.com'
  }
}
