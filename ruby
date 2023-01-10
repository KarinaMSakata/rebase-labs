#!/bin/bash

docker run \
  -it \
  --rm \
  --name ruby \
  --network rebase-labs \
  ruby \
  bash