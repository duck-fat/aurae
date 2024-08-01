# GitHub Workflows

Please use the following naming convention such that we can easily map failed
builds back to YAML files here in the repository.

```
$number-$testcommands
```

Where **number** is just a unique identifier to easily map failed builds to YAML
files. See below for more guidance on choosing a number. Where **testcommands**
are the commands that a user can replicate on their computer! Do NOT test
commands that can not be easily replicated! This structure allows us to easily
understand which workflow to look at from the github actions web ui.

```
001-make-pki-test-auraed.yaml
```

## Choosing a number

- 001-099: Reserved for workflows that don't use a container image
- 101-199: Reserved for workflows using container runners
- 201-299: Reserved for workflows that don't fall under the previous two
  categories

## Testing workflows

Workflows can be testing using the tool [act](https://github.com/nektos/act).
You'll need to install that locally, then you can run commands to test each file
individually, locally:

`make ci-local file=001-tester-ubuntu-make-test.yml`
