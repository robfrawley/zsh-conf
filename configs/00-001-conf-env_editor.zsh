#!/bin/zsh

# assign editor environment variable
if [[ ! -n ${SSH_CONNECTION} ]] && command -v subl &> /dev/null; then
    # assign gui-based editor for local sessions
    _zc__export_editor="$(
        command -v subl 2> /dev/null || \
        printf -- subl
    )"
else
    # assign CLI-based editor for remote sessions
    _zc__export_editor="$(
        command -v nano 2> /dev/null || \
        printf -- nano
    )"
fi

# assign language environment variable
_zc__dbg_act_init 'Exported new env variable: "EDITOR" => "%s"' "${_zc__export_editor}"
export EDITOR="${_zc__export_editor}"
_zc__dbg_act_ends $?
