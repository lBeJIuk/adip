# Docker image publishing

Simple action for docker image publishing

Example of use:

```
name: workflow_name
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
   - name: Build $ Publish
      uses: lbejiuk/adip@v1
      with:
        TOKEN: ${{secrets.token}}
        PACKAGE_REPOSITORY: 'private_pkg'
```
