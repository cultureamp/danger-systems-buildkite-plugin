⚠️ This plugin has been deprecated (for now) in favour of
[danger-systems-github-action](https://github.com/cultureamp/danger-systems-github-action).

***

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
      language: ruby
      language_version: 2.7.1
```

2. Ensure that the API token is available to the pipeline as
   `DANGER_SYSTEMS_GITHUB_TOKEN`.

Note that this differs from the token danger expects for GitHub integration
(`DANGER_GITHUB_API_TOKEN`). This was done intentionally to make it clearer
what the token is used for and is mapped to the expected variable within
the run command.

### Language

The plugin supports different implementations of danger by specifying a
`language` option. The available options are:

- `js` — JavaScript (and TypeScript)
- `ruby` — Ruby

Each implementation can specify a `language_version` option to ensure the
danger process runs in the environment you’re expecting. The version is fed
directly to the docker build process, so it should work for any of the following
images available on Docker Hub:

- `js` will run in any [node docker image](https://hub.docker.com/_/node/)
  matching `node:#{language_version}-alpine`
- `ruby` will run in any [node docker image](https://hub.docker.com/_/ruby/)
  matching `ruby:#{language_version}-slim-buster`

## Usage

### JavaScript and TypeScript

If you’ve chosen `js` as the configured language, the plugin will:

* Install your npm dependencies via `yarn`
* Copy your app source into its runtime
* Look for either a `dangerfile.ts` or `dangerfile.js` in the root of your
  repository and run it

Here’s a simple example from the danger documentation:

```ts
import { message, danger } from "danger"

const modifiedMD = danger.git.modified_files.join("- ")
message("Changed Files in this PR: \n - " + modifiedMD)
```

### Ruby

If you’ve chosen `ruby` as the configured language, the plugin will:

* Install any dependencies configured within a `group :danger` in your Gemfile
* Copy your app source into its runtime
* Look for the `Dangerfile` in the root of your repository and run it

Here’s a simple example from the danger documentation:

```ruby
message("Hello, I am message from danger.")
```

The ruby version of the plugin expects you to have at least the following in
your Gemfile:

```
group :danger do
  gem "danger"
end
```

Note that only gems within that group will be available within the `Dangerfile`
when it runs — no other default gems or groups will be installed. This is a
limitation of the plugin structure to try to ensure that the base docker image
does not require specific libraries to install your dependencies.

## Limitations

* The plugin is only configured to work with GitHub

## Developing

To lint the plugin:

```shell
docker-compose run --rm lint
```
