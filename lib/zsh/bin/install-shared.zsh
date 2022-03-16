#!/usr/bin/env zsh

##
## This file is part of the `robfrawley/zsh-conf` package.
##
## (c) Rob Frawley 2nd <rmf@src.run>
##
## For the full copyright and license information, view the LICENSE.md
## file distributed with this source code.
##

source "${${${(%):-%x}:P}:h}/../inc/common.zsh"

declare -A _shared_symlink_list=(
   [lib/share/nanorc]=".share/nanorc"
)

if ! _make_symbolic_link "${_self_path_base}/../../share/nanorc" "${HOME}/.share/nanorc"; then
    printf 'SYM-LINK-FAILURE\n'
fi
exit

function _create_share_symlink() {
    local repo_path="${1}"
    local user_path="${2}"

    printf -- ''
}

function main() {


    for k v in ${(kv)_share_symlink_list}; do
        _create_share_symlink "${k}" "${v}"
    done
}

main "${@}"
