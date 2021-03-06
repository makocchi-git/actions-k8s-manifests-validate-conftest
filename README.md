# Validate Kubernetes manifests by conftest

[<img src="https://github.com/makocchi-git/actions-k8s-manifests-validate-conftest/workflows/Perform checks/badge.svg"/>](https://github.com/makocchi-git/actions-k8s-manifests-validate-conftest/actions)

Validate [Kubernetes](https://github.com/kubernetes/kubernetes) manifests in your repository.  
This action uses [conftest](https://github.com/open-policy-agent/conftest) for validating.

<img src="./img/check.png" alt="sample comment" width="80%" />

## Usage

### Basic

```yaml
# .github/workflows/manifests-validation.yml
name: Pull Request Check

on: [pull_request]

jobs:
  validation:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: validate manifest-dir
        uses: makocchi-git/actions-k8s-manifests-validate-conftest@1.1.0
        with:
          file: manifest-dir
          token: ${{ secrets.GITHUB_TOKEN }}
```

### Using custom policies in your repository

Default [kubernetes policies](https://github.com/instrumenta/policies/tree/master/kubernetes) are installed to `/policy` in the working container.  
If you want to use your own policies, commit your rego files into any directory and set it's path into `policy` parameter.

```yaml
      # use policy/your_awesome_regos as your custom policy directory
      - name: validate manifest-dir with custom policies
        uses: makocchi-git/actions-k8s-manifests-validate-conftest@1.1.0
        with:
          file: manifest-dir
          policy: policy/your_awesome_regos
          token: ${{ secrets.GITHUB_TOKEN }}
```

### Using external custom policies

You can use external custom policies for validation.

```yaml
      # policies will download from github.com/makocchi-git/sample-kubernetes-rego-policy before validation
      - name: validate manifest-dir with external custom policies
        uses: makocchi-git/actions-k8s-manifests-validate-conftest@1.1.0
        with:
          file: manifest-dir
          update: github.com/makocchi-git/sample-kubernetes-rego-policy
          policy: policy/your_awesome_regos # this parameter will be ignored
          token: ${{ secrets.GITHUB_TOKEN }}
```

### Input parameters

| Parameter  | Description                                                                                 | Default   |
| ---------- | ------------------------------------------------------------------------------------------- | --------- |
| `file`     | File or directory to validate                                                               | `.`       |
| `output`   | Output format for conftest results - valid options are: [stdout json tap table]             | `stdout`  |
| `policy`   | Path to the Rego policy files directory                                                     | `/policy` |
| `trace`    | Enable more verbose trace output for rego queries                                           | `false`   |
| `update`   | A list of urls can be provided to the update flag, which will download before the tests run | `""`      |
| `comment`  | Write validation details to pull request comments                                           | `true`    |
| `token`    | Github token for api. This is required if `comment` is true                                 | `""`      |

