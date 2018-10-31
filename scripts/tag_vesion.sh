#!/usr/bin/env bash

cd "$(dirname "$0")"
source version_utils.sh

version=$1
build="$2"
prefix="${3// /}"
if [[ ! -z "$prefix" ]]; then
    prefix="$prefix/"
fi
    
tag_name="$prefix$version+b$build"

tag_cmd="git tag"
tag_push_cmd="git push"

fail() {
    printf "ERROR: $@\n" 1>&2
    exit 1
}

usage() {
    printf "ERROR: $@\n" 1>&2
    echo "Usage: tag_version <version> <build> [<os>]"
    exit 1
}

if [[ -z "$version" ]]; then
    usage "No version number given"
fi

if [[ -z "$build" ]]; then
    usage "No build number given"
fi

# Check if the specified tag already exists for this commit.
matches=$(git ls-remote --tags --refs --quiet | grep `git rev-parse HEAD` | grep "\srefs/tags/$tag_name\$")
if [[ "$?" -eq "1" ]]; then
    echo "Tagging head: $tag_name"
    $tag_cmd $tag_name && $tag_push_cmd --quiet origin $tag_name || fail "Tagging version failed; does it exist already?"
else
    echo "Skipping, $tag_name already exists for head"
fi
