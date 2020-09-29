# Danger Systems Buildkite Plugin

Run [danger]([https://](https://danger.systems/)) as part of your pipeline.

## Configuration

### Within Culture Amp

1. You’ll need to add the `cultureamp-ci-private` user on GitHub to your
   repository with `write` access to the repo (write access is required to set
   the status of your PR).

2. Add the following to your `pipeline.yml`:

```yml
steps:
  - label: ":zap: Danger"
    key: danger
    agents:
      queue: build-unrestricted
    plugins:
    - cultureamp/danger-systems#v0.0.2:
      language: js
      language_version: 12
```

Within Culture Amp’s build pipelines this will pull in the
`DANGER_SYSTEMS_GITHUB_TOKEN` automatically and make it available to the
environment.

### Outside Culture Amp

1. Create a GitHub API token for user with `write` access to your repository.

2. Add the following to your `pipeline.yml`:

```yml
steps:
  - label: ":zap: Danger"
    key: danger
    plugins:
    - cultureamp/danger-systems#v0.0.2:
      language: js
      language_version: 12
```

2. Ensure that the API token is available to the pipeline as
   `DANGER_SYSTEMS_GITHUB_TOKEN`.

Note that this differs from the token danger expects for GitHub integration
(`DANGER_GITHUB_API_TOKEN`). This was done intentionally to make it clearer
what the token is used for and is mapped to the expected variable within
the run command.

## Usage

The plugin is currently very simple. It will look for either a `dangerfile.ts`
or `dangerfile.js` in the root of your repository and run it.

Here’s a simple example from the danger documentation:

```ts
import { message, danger } from "danger"

const modifiedMD = danger.git.modified_files.join("- ")
message("Changed Files in this PR: \n - " + modifiedMD)
```

## Limitations

* The plugin is only configured to work with GitHub

## Developing

To lint the plugin:

```shell
docker-compose run --rm lint
```
