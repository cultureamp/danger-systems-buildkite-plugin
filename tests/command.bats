#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

@test "Exits early when no associated PR" {
  export BUILDKITE_PULL_REQUEST=""

  run "$PWD/hooks/command"

  assert_success
}

@test "Fails when no language specified" {
  export BUILDKITE_PULL_REQUEST="123"
  export BUILDKITE_DANGER_SYSTEMS_LANGUAGE=""

  run "$PWD/hooks/command"

  assert_failure
}

@test "Runs danger-js when js specified as language" {
  export BUILDKITE_PULL_REQUEST="123"
  export BUILDKITE_DANGER_SYSTEMS_LANGUAGE="js"

  stub docker "docker output"

  run "$PWD/hooks/command"

  assert_output --partial "Running danger-js"

  assert_success
}

@test "Runs danger-ruby when ruby specified as language" {
  export BUILDKITE_PULL_REQUEST="123"
  export BUILDKITE_DANGER_SYSTEMS_LANGUAGE="ruby"

  stub docker "docker output"

  run "$PWD/hooks/command"

  assert_output --partial "Running danger-ruby"

  assert_success
}
