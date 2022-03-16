#!/usr/bin/env zsh

##
## This file is part of the `robfrawley/zsh-conf` package.
##
## (c) Rob Frawley 2nd <rmf@src.run>
##
## For the full copyright and license information, view the LICENSE.md
## file distributed with this source code.
##

#
# declare file dependency list
#
declare -r -a _self_deps_list=(
    'common-variables.zsh'
    'common-functions.zsh'
)

#
# define dependency failure output function
#
function _out_source_fail() {
    local dep_name="${1}"
    local dep_path="${2}"
    local err_desc="${3:-undefined error encountered}"

    printf 'Failed to include dependency "%s" as file "%s" (%s)...\n' \
        "${dep_name}" \
        "${dep_path}" \
        "${err_desc}"
}

#
# define dependency sourcing function
#
function _run_source_file() {
    local dep_name="${1}"
    local dep_path="${dep_name:P}"

    if [[ ! -f ${dep_path} ]]; then
        dep_path="${${${(%):-%x}:P}:h}/${dep_name}"
    fi

    if [[ ! -f ${dep_path} ]]; then
        _out_source_fail \
            "${dep_name}" \
            "${dep_path}" \
            'file does not exist'
    elif ! source "${dep_path}"; then
        _out_source_fail \
            "${dep_name}" \
            "${dep_path}" \
            'sourcing file failed'
    fi
}

#
# source additional self-defined common includes
#
for _dep_name in ${(v)_self_deps_list}; do
    _run_source_file "${_dep_name}"
done

#
# source additional self-defined common includes
#
for _dep_name in ${(v)_main_deps_list}; do
    _run_source_file "${_dep_name}"
done
