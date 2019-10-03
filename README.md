# kubectl-ecr
Add AWS ECR access tokens to Kubernetes

## Why:
AWS ECR access tokens are JSON webtokens with a lifetime of 12 hours, you need to refresh your keys in order to retain access to ECR.

## How:
This container sends your ECR access token to all namespaces of your kubernetes cluser via `kubectl`.
Rancher project and user namespaces will be ignored to avoid recursion issues.

## Config:

Add a cronjob deployment with the following settings:

1. Add config map for AWS console

File: config
Example content:
```
[default]
region = eu-central-1
```

File: credentials
Example content:
```
[default]
aws_access_key_id = BGHIA52TFY4OUQ4KLLMP
aws_secret_access_key = fH4EDLBkEWP7krnRH224Y23Iy8O4Z3daNzAWVFlj
```

Mount both files in /root/.aws

2. Add config map for .kube/config

File: config
Example content:
```
Your .kube/config file
```

3. Add two variables to your deployment:
```
region = eu-central-1
accountid = 123456789012
```

FAQ: 

- Question: Where can I find my accountid?

Answer: Your account id is part of your ECR registry URL: `123456789012`.dkr.ecr.eu-central-1.amazonaws.com

- Question: Where can I find my region?

Answer: Your region is part of your ECR registry URL: 123456789012.dkr.ecr.`eu-central-1`.amazonaws.com

- Question: I do not want to sent my access tokens to all namespaces.

Answer: Please send a pull request.

- Question: I have multiple registries, how do I add them?

Answer: Either set up multiple cronjobs or sent a pull request.

- Question: Why do I have to set my region twice?

Answer: Because I'm lazy, please sent a pull request.
