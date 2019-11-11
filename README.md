# fa-ci-platform

The CI platform for FA consist in a Jenkins X installation in an AWS EKS cluster that defines CI/CD pipelines for different apps within the FA company.

## Platform features
- The platform is mounted in a Kubernetes environment with EBS persistent volumes for its high availability and scalability.
- The pipelines are defined in Jenkinsfiles.
- The infrastructure for the platform and the apps is defined in Terraform.
- For testing purposes we will use a personal domain: somosaltum.com.
- Notifications in Github (GitOps).

## Project contents
- terraform/: contains the infrastructure as code in Terraform for the FA apps and FA ci-platform.
- helm/: contains the values for the deployed charts (in our case, the nginx controller via Terraform).
- app/: contains the code base of the FA UMSL app.

## Jenkins X installation
### Prerequisites:
- Install JX CLI
brew tap jenkins-x/jx
brew install jx
- Install EKSCTL tool
brew tap weaveworks/tap
brew install eksctl
### Installation commands
jx install --provider=eks --default-environment-prefix=fa-jx --skip-ingress --ingress-deployment=nginx-ingress-controller --ingress-service=nginx-ingress-controller --domain=somosaltum.com

## Possible improvements
- Get a SSL certificate to configure the HTTPS communication.
- Different EKS clusters for different environments.
