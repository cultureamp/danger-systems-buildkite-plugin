ARG RUBY_IMAGE_VERSION
ARG BASE_IMAGE=ruby:${RUBY_IMAGE_VERSION}-slim-buster
FROM ${BASE_IMAGE}

ENV LANG=C.UTF-8

RUN mkdir /home/app
WORKDIR /home/app

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -qq --no-install-recommends \
  build-essential \
  git \
  < /dev/null > /dev/null \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ENV GITHUB_REGISTRY_TOKEN ""

# ENV vars that danger cares about
ENV DANGER_GITHUB_API_TOKEN ""
ENV BUILDKITE ""
ENV BUILDKITE_REPO ""
ENV BUILDKITE_PULL_REQUEST ""
ENV BUILDKITE_BUILD_URL ""
