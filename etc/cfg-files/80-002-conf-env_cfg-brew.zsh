#!/bin/zsh

#
# variable definitions
#

_zc__brew_root_path='/opt/brew'
_zc__brew_bins_path="${_zc__brew_root_path}/bin"
_zc__brew_exec_file="${_zc__brew_bins_path}/brew"
_zc__brew_exec_opts='shellenv'

#
# function definitions
#

function _zc__check_brew_root_path() { test -r "${_zc__brew_root_path}" -a -d "${_zc__brew_root_path}"; }
function _zc__check_brew_bins_path() { test -r "${_zc__brew_bins_path}" -a -d "${_zc__brew_bins_path}"; }
function _zc__check_brew_exec_file() { test -r "${_zc__brew_exec_file}" -a -f "${_zc__brew_exec_file}"; }

function _zc__assay_brew_vers_text() { _zc__check_brew_exec_file && "${_zc__brew_exec_file}" --version || printf 'null'; }

function _zc__parse_brew_vers_gitc() { tail -n1 <<< "$(</dev/stdin)" | sed -E 's/.+([a-z0-9]{11,}).+([0-9]{4}(-[0-9]{2}){2}).+/\2@\1/g'; }
function _zc__parse_brew_vers_semv() { head -n1 <<< "$(</dev/stdin)" | awk '{print $2}'; }
function _zc__fetch_brew_vers_gitc() { _zc__assay_brew_vers_text | _zc__parse_brew_vers_gitc; }
function _zc__fetch_brew_vers_semv() { _zc__assay_brew_vers_text | _zc__parse_brew_vers_semv; }

#
# perform checks for expected paths and files
#

_zc__dbg_act_init 'Checking brew path assets: "BREW_ROOT_PATH" => "%s"' "${_zc__brew_root_path}"
_zc__check_brew_root_path
_zc__dbg_act_ends ${?}

_zc__dbg_act_init 'Checking brew path assets: "BREW_BINS_PATH" => "%s"' "${_zc__brew_bins_path}"
_zc__check_brew_bins_path
_zc__dbg_act_ends ${?}

_zc__dbg_act_init 'Checking brew path assets: "BREW_EXEC_FILE" => "%s"' "${_zc__brew_exec_file}"
_zc__check_brew_exec_file
_zc__dbg_act_ends ${?}

#
# check that all expected paths and files exist and are readable
#

if ! _zc__check_brew_root_path || ! _zc__check_brew_bins_path || ! _zc__check_brew_exec_file; then
    #
    # inform the user that initialization failed
    #
    _zc__dbg 'Skipping brew environment (failed to locate one or more required assets: "%s", "%s", "%s") ...' \
        "${_zc__brew_root_path}" \
        "${_zc__brew_bins_path}" \
        "${_zc__brew_exec_file}"
    _zc__brew_eval_call=0
else
    #
    # inform the user of the initialization attempt result
    #
    _zc__dbg_act_init 'Invoking brew environment: "BREW_EVAL_CALL" => "%s"' "eval \"\$(\"${_zc__brew_exec_file}\" ${_zc__brew_exec_opts})\""
    eval "$("${_zc__brew_exec_file}" ${_zc__brew_exec_opts})" &> /dev/null
    _zc__dbg_act_ends ${?}
fi
