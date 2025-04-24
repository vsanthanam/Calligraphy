#!/bin/bash
set -ex

swift run --package-path . -- SiteGenerator "$@"
