**Install Kubernetes CLI**

`brew install kubectl` (k8s command line client tool)

Detailed installation and steps for installation on other platforms (windows/linux): https://kubernetes.io/docs/tasks/tools/install-kubectl/

**Install Terraform**

`brew tap hashicorp/tap`

`brew install hashicorp/tap/terraform`

Detailed Installation and steps for installation on other platforms (windows/linux): https://learn.hashicorp.com/tutorials/terraform/install-cli

**Setup Minikube**

Install Minikube using brew (you need VirtualBox or Hyperkit installed)

`brew install minikube` (minikube version latest)

Detailed installation and steps for installation on other platforms (windows/linux): https://minikube.sigs.k8s.io/docs/start/

`minikube start --memory 6000 --cpus=4 --driver=hyperkit`

For windows run below command:

`minikube start --memory 6000 --cpus=4--driver=virtualbox --no-vtx-check`

In the logs you can see if minikube is using hyperkit driver or virtual box driver.

If it's the virtual box driver, you can open VirtualBox and see the minikube instance running, and for the first time it can take upto 10-15 min.

If it’s hyperkit, move on to the next step.

`eval $(minikube docker-env)`

 _(connect host CLI to docker runtime inside minikube - need to do it every time on new terminal window)_

######_Copy certificates to .kube folder (Required only if you want to run deployment on jenkins. For local, uncomment commented code in provide.tf and comment  line #1-7_)

```$xslt
cp ~/.minikube/ca.crt ~/.kube/client-ca-cert.pem
cp ~/.minikube/profiles/minikube/client.crt ~/.kube/client-cert.pem
cp ~/.minikube/profiles/minikube/client.key ~/.kube/client-key.pem
```

**Setup Jenkins on Minikube**

Install Helm (https://helm.sh/docs/intro/install/)

`brew install helm`

Add jenkins repo in helm

```
helm repo add jenkinsci https://charts.jenkins.io

helm repo update
```

Create Persistance volume for Jenkins

`kubectl apply -f jenkins/jenkins-volume.yaml`

Create Service Account for Jenkins Master

`kubectl apply -f jenkins/jenkins-sa.yaml`

Install Jenkins workload on Minikube instance

`helm install jenkins -f jenkins/jenkins-values.yaml jenkinsci/jenkins`

######**_Note: This would roughly take around 15-20mins_**


**Run the following commands to be able to run Deployment on Jenkins**

`kubectl exec -it jenkins-0 /bin/sh` > `cd /root` > `mkdir .kube` > `exit`

```$xslt
kubectl cp  ~/.kube/client-cert.pem jenkins-0:/root/.kube/client-cert.pem
kubectl cp  ~/.kube/client-key.pem jenkins-0:/root/.kube/client-key.pem
kubectl cp  ~/.kube/client-ca-cert.pem jenkins-0:/root/.kube/client-ca-cert.pem
```
 
Once done, Access Jenkins service
           
`minikube service jenkins` 

Get Jenkins admin user password for login

`kubectl get secret jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode`

On the Jenkins UI, perform the following steps:
- Go to `Manage Jenkins` and click on `Global Tool Configuration`
- Under `Terraform`, click on `Terraform Installations` > `AddTerraform` > `Install from bintray.com` > Select version `Terraform 0.14.7 linux(amd 64)` from the dropdown.
- Click on `Save`
- Go to the Home Page and click on `Free Style Project`. Give any name to the Project.
- Under `General` Tab, click on the checkbox, `This Project is parameterized` and add a `String` parameter `minikube_ip`
- Under `Source Code Management`, select `Git` and add the URL: `https://github.com/ThoughtworksGGN/iac_agility_today_base.git`
- Under `Build Environment`, select `Terraform`
- Under Build, execute the following shell script
```bash
    cd $WORKSPACE/platform/terraform
    /var/jenkins_home/tools/org.jenkinsci.plugins.terraform.TerraformInstallation/terraform/terraform init
    /var/jenkins_home/tools/org.jenkinsci.plugins.terraform.TerraformInstallation/terraform/terraform apply --auto-approve -var minikube_ip=${minikube_ip}
```

**Deploy `metadata-service` application using terraform on single node k8s cluster i.e, Minikube**

`terraform apply --auto-approve -var minikube_ip=<minikube ip>`


TF K8S Source: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider?in=terraform/use-case
