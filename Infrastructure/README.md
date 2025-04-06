## Setting up infrastructure

## Connect to kubernetes cluster
```
az account set --subscription b822363d-6075-4596-987a-1f24bce600dd
az aks get-credentials --resource-group CertificateIssuer101 --name aks101cluster --overwrite-existing
```
## Read Kubernetes resources
```
kubectl get deployments --all-namespaces=true
kubectl get deployments --namespace <namespace-name>
kubectl describe deployment <deployment-name> --namespace <namespace-name>
kubectl logs -l <label-key>=<label-value>
kubectl logs -l app=razor-app -n dotnet-application
```

## Setting up cert-manager
cert-manager is a powerful and extensible X.509 certificate controller for Kubernetes and OpenShift workloads. It will obtain certificates from a variety of Issuers, both popular public Issuers as well as private Issuers, and ensure the certificates are valid and up-to-date, and will attempt to renew certificates at a configured time before expiry.

### Install helm
```
winget install Helm
```

## Containerize application

## Push applicaiton to ACR

## Attach ACR to AKS

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

# kubectl apply -f service.yaml -n sample
```
### Connecting to a running pod
```
kubectl exec -it <pod-name> -n dotnet-application -- netstat -tulpn
kubectl exec -it razor-app-7799bc6677-crn4c -n dotnet-application -- netstat -tulpn

```

## To Dos

1- How to connect an ACR to K8S cluster?
2- How to deploy a razor page web app to K8S in a new namespace?
3- How to use the cert-manager to issue a certificate?
4- How does our application utilize the issued certificate?
5- Github workflows to automate build an push images into ACR by using dockerfile.
6- Replace the following line with bicep:
```
az aks update -n aks101cluster -g CertificateIssuer101 --attach-acr aks101acr
```
7- Make all AKS services private, and expose them via ingress or alternative solutions.
8- Create a keyvault with Bicep.
9- Create a bash script to sync certificates from AKS to keyvault.
