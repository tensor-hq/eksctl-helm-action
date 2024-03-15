# eksctl-helm-action

Github Action to authenticate with eksctl and use helm/kubectl.

Huge credits to [helm-eks-action](https://github.com/koslib/helm-eks-action) (this is basically a fork with a few additional lines)
but authenticating using `eksctl` instead of passing through `KUBE_CONFIG_DATA`.

## Example

Secrets required: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` (aws-configure-credentials)

Inputs:

- `eks_cluster`: name of the EKS cluster (NAME in `eksctl get cluster`)
- `plugins`: comma-separated list of helm plugins (their URLs)
- `command`: the command(s) you want to run (which can be `kubectl`/`helm`)

```yaml
name: deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: helm deploy
        uses: tensor-hq/eksctl-helm-action@main
        with:
          eks_cluster: my-prod-cluster
          plugins: "https://github.com/jkroepke/helm-secrets" # optional
          command: |-
            helm upgrade <release name> --install --wait <chart> -f <path to values.yaml>
            kubectl get pods
```
