#!/usr/bin/env bash

function extract_version() {
    if [[ $@ =~ $tag_regex ]]
    then
        echo "${BASH_REMATCH[1]}"
    fi
}

function extract_build_number() {
    if [[ $@ =~ $build_regex ]]
    then
        echo "${BASH_REMATCH[2]}"
    fi
}

function get_versions() {
    while read line
    do
        extract_version $line
    done < <(git ls-remote --tags --refs --quiet)
}

function get_build_numbers() {
    for version in $@
    do
        extract_build_number $version
    done
}

function get_head_version() {
    local raw=$(git ls-remote --tags --refs --quiet | grep `git rev-parse HEAD`)
    echo "$(extract_version $raw)"
}

function get_head_build_number() {
    local current_version=$(get_head_version)
    echo "$(extract_build_number $current_version)"
}

function max() {
    max=0
    for n in $@ ; do
        ((n > max)) && max=$n
    done
    echo $max
}
