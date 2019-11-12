# fa-ci-platform

The CI platform for FA consist in a Jenkins X installation in an AWS EKS cluster that defines CI/CD pipelines for different apps within the FA company.

## Platform features
- The platform is mounted in a Kubernetes environment with EBS persistent volumes for its high availability and scalability.
- The pipelines are defined in Jenkinsfiles.
- The infrastructure for the platform and the apps is defined in Terraform.
- For testing purposes we will use a personal domain: somosaltum.com.
- Notifications in Github by Jenkins (GitOps).

## Project contents
- terraform/: contains the infrastructure as code in Terraform for the FA apps and FA ci-platform.
- helm/: contains the values for the deployed charts (in our case, the nginx controller via Terraform).

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

## Testing and monitoring tools installation
### Prometheus installation commands
helm upgrade prometheus stable/prometheus -f helm/prometheus.yaml --namespace monitoring --set rbac.create=true --install
### Grafana installation commands
helm upgrade grafana stable/grafana --set=ingress.enabled=True,ingress.hosts={grafana.somosaltum.com} --namespace monitoring --set rbac.create=true  --install
### Sonarqube installation commands
helm upgrade sonarqube stable/sonarqube --set=ingress.enabled=True,ingress.hosts={sonar.somosaltum.com} --namespace jx --install

## Pipelines definitions
When working in a PR branch:
1. Application tests
2. Quality code analysis
3. CI Build and push snapshot
When the PR is merged to master:
4. Integration tests
5. Build Release
6. Promote to Staging
7. Promote to Production (manual step)

## Further improvements
- Get a SSL certificate to configure the HTTPS communication.
- Different EKS clusters for different environments.
- Notifications to Github and Slack if stages fail.
- Installation of a Sonarqube server.
