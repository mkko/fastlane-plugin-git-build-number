#!/usr/bin/env bash

cd "$(dirname "$0")"
source version_utils.sh

# Use cases:
# - print out next build number
# - tag with build number
# - 

# As an optional arguments
tag_prefix=$1
build_num_selector='\bb\d\+\b'

tag_regex='^.*refs/tags/build/(.*)$'
build_regex='(^|[^a-zA-Z0-9_])b([0-9]+)($|[^a-zA-Z0-9_])'

version_numbers=$(get_versions)
build_numbers=$(get_build_numbers $version_numbers)

# echo "$build_numbers"
#echo "max: $(max $build_numbers)"

next_build_number=$(get_head_build_number)

if [[ -z "$next_build_number" ]]; then
    # Get the highest build number.
    next_build_number=$(max $build_numbers)

    # Bump it.
    next_build_number=$((next_build_number+1))
fi

echo $next_build_number