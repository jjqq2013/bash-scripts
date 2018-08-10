#!/bin/bash

[[ $1 == --run ]] || >&2 printf 'start dry-run ...\n'

PROMPT=""

[[ $(uname) == Darwin ]] && REPLACE_DIR_SYMLINK=-h || REPLACE_DIR_SYMLINK=""

while read l; do
    s=$(readlink "$l") && \
    [[ $s == /* ]] && S="$(relpath "$l" ".$s")" && \
    if [[ $1 == --run ]]; then
        ln -sfv $REPLACE_DIR_SYMLINK "$S" "$l"
    else
        >&2 printf '# %-60s -> %-60s -> %s\n' "$l" "$s" "$S"
        PROMPT=1
    fi
done < <(find . -type l)

[[ $PROMPT ]] && >&2 printf '\n finished dry-run. To run actually, please append --run option.\n'
