#!/usr/bin/env zsh

##
## This file is part of the `robfrawley/zsh-conf` package.
##
## (c) Rob Frawley 2nd <rmf@src.run>
##
## For the full copyright and license information, view the LICENSE.md
## file distributed with this source code.
##

function _out_text() {
    printf -- "${1}" "${@:2}"
}

function _out_line() {
    printf -- "${1}\n" "${@:2}"
}

function _err_text() {
    _out_text 1>&2
}

function _err_line() {
    _out_line 1>&2
}

function _err_retn() {
    _out_line '%d' "${1}"
    _err_line "${2:-fail}\n" "${@:3}"
}

function _out_common_variables() {
    for v in _self_path_name _self_path_base _self_file_name _self_file_base _self_file_extn; do
        printf '[%s] => "%s"\n' "${v}" "${(P)v}"
    done
}

function _make_symbolic_link() {
    local source="${1}"
    local target="${2}"

    _out_text 'Creating symbolic link "%s" => "%s" ... ' "${target}" "${source}"

    [[ -L ${target} ]] \
        && rm -fr --preserve-root "${target}"

    mkdir -p "${target:h}" 2> /dev/null \
        || (_err_line 'fail' && return 1)

    cd "${target:h}" 2> /dev/null \
        || return "$(_err_retn 2)"

    [[ -e ${source} ]] \
        || source="${source:P}"

    [[ -e ${source} ]] \
        || return "$(_err_retn 3)"

    ln -s "${source}" "${target}" 2> /dev/null \
        && _out_line 'done' \
        || _err_line 'fail'
}
