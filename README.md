## Setting up infrastructure

We are using bicep to setup the infrastructure. The bicep files can be found under Infrastructure/Bicep folder.

To generate a public-private key pair to connect to the nodes if necessary, you can use the following command:
```
ssh-keygen -t rsa -b 4096 -f aks_key
```

![Infrastructure setup](Images/Infrastructure.png)

## Executing the bicep commands:

```
az deployment sub create --location westeurope --template-file main.bicep --mode Complete
```

## Connect to kubernetes cluster
```
az account set --subscription b822363d-6075-4596-987a-1f24bce600dd
az aks get-credentials --resource-group CertificateIssuer101 --name aks101cluster --overwrite-existing
```

## Setting up cert-manage on K8S

cert-manager is a powerful and extensible X.509 certificate controller for Kubernetes and OpenShift workloads. It will obtain certificates from a variety of Issuers, both popular public Issuers as well as private Issuers, and ensure the certificates are valid and up-to-date, and will attempt to renew certificates at a configured time before expiry.

1. Setup the right powershell flags/environment variables:
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')
```
2. Install helm on your local machine using winget or choco (choco is recommended):
```
choco install kubernetes-helm
# or
winget install Helm
```
3. Install cert-manager helm repo:
```
helm repo add jetstack https://charts.jetstack.io --force-update
```

4. Install cert-manager:
```
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.17.0 \
  --set crds.enabled=true

helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.17.0 --set crds.enabled=true
```

**Note:** Step 1 to 3 have to be applied once per machine.

## Containerize application

## Push applicaiton to ACR

## K9S commands

## Attach ACR to AKS

For some reasons Bicep fails to connet ACR to AKS. Run the following to connect these two:

```
az aks update -n <AKS_CLUSTER_NAME> -g <RESOURCE_GROUP> --attach-acr <ACR_NAME>
az aks update -n aks101cluster -g CertificateIssuer101 --attach-acr aks101acr
```

## Create Kubernetes Resources
1. Create a new namespace
```
kubectl create namespace dotnet-application
```
2- Create a deployment file:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: razor-app
  namespace: dotnet-application
spec:
  replicas: 1
  selector: 
    matchLabels:
      app: razor-app
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  minReadySeconds: 5 
  template:
    metadata:
      labels:
        app: razor-app
    spec:
      nodeSelector:
        "kubernetes.io/os": linux
      serviceAccountName: default
      containers:
        - name: razor-app
          image: aks101acr.azurecr.io/aks-app1:1.0.0
          imagePullPolicy: Always
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
```
2.2. Apply the deployment file:
```
kubectl apply -f deployment.yml -n dotnet-application
```

Note: In case you need to delete a deployment, use:
```
kubectl delete -f deployment.yml -n dotnet-application
```

3. Create a service
```
apiVersion: v1
kind: Service
metadata:
  name: razor-app
  namespace: dotnet-application
  labels: {}
spec:
  type: ClusterIP #LoadBalancer
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      name: http
  selector: 
    app: razor-app
```

Apply the changes:

```
kubectl apply -f service.yml -n dotnet-application
```

Note: In case to delete a service, use:

```
kubectl delete -f deployment.yml -n dotnet-application
```

## Read Kubernetes resources
```
kubectl get deployments --all-namespaces=true
kubectl get deployments --namespace <namespace-name>
kubectl describe deployment <deployment-name> --namespace <namespace-name>
kubectl logs -l <label-key>=<label-value>
kubectl logs -l app=razor-app -n dotnet-application
```

## Debugging
### Connecting to a running pod
```
kubectl exec -it <pod-name> -n dotnet-application -- netstat -tulpn
kubectl exec -it razor-app-7799bc6677-crn4c -n dotnet-application -- netstat -tulpn

```

## Selector and label naming

1. In deployment file spec.selector.matchLabels has to be same as spec.template.metadata.Labels

```
spec:
  replicas: 1
  selector: 
    matchLabels:
      app: razor-app
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  minReadySeconds: 5 
  template:
    metadata:
      labels:
        app: razor-app
```

2. In deployment file and service file must have the same label:

label in deployment

```
# deployment.yml
template:
  metadata:
    labels:
      app: razor-app-deployment-selector
```
Selector in service:
```
# servive.yml
selector:
  app: razor-app-service-selector
```

**Note**: CertificateIssuer which is a custome resource definition doesn't have a namespace, a so-called non-namespaced resource.

## To Dos

1. How to connect an ACR to K8S cluster?
2. How to deploy a razor page web app to K8S in a new namespace?
3. How to use the cert-manager to issue a certificate?
4. How does our application utilize the issued certificate?
5. Github workflows to automate build an push images into ACR by using dockerfile.
6. Replace the following line with bicep:
```
az aks update -n aks101cluster -g CertificateIssuer101 --attach-acr aks101acr
```
7. Make all AKS services private, and expose them via ingress or alternative solutions.
8. Create a keyvault with Bicep.
9. Create a bash script to sync certificates from AKS to keyvault.
10. K9S commands
