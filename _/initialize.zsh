#!/bin/zsh

##
## define global config variables
##

# assign the current datetime (with nano-secs)
export _zc__start="$(date +%s.%N)"

# configures whether debug mode is enabled (overwrites quiet mode)
export _zc__debug="${_zc__debug:-true}"

# configures whether quiet mode is enabled
export _zc__quiet="${_zc__quiet:-false}"

# configures whether logging is enabled
export _zc__logging="${_zc__logging:-true}"

# configures the file to log to
export _zc__logpath="${_zc__logpath:-${HOME}/.zsh-conf.log}"

# export output indentation level
export _zc__out_lvl=0

# export user path
export _zc__user_path="${HOME}"

# export root path of this project
export _zc__root_path="$(
    realpath "${ZSH_CUSTOM}/.." 2> /dev/null || \
    readlink "${ZSH_CUSTOM}/.." 2> /dev/null || \
    printf -- "${ZSH_CUSTOM}/.."
)"

# export configs path of this project
export _zc__conf_path="${_zc__root_path}/configs"

# export plugins path of this project
export _zc__plug_path="${_zc__root_path}/plugins"

# export dot-files path of this project
export _zc__dots_path="${_zc__root_path}/dot-files"


##
## define global config functions
##

# check if the first passed value matches any of the other function arguments
function _zc__has_matches() {
    local    primary="${1:l}"
    local -a matches=("${@:2}")

    for m in "${matches[@]}"; do
        [[ "${m:l}" == "${primary}" ]] && return 0
    done

    return 1
}

# gets the type of the passed name (for ex: builtin, function, etc)
function _zc__get_type_of() {
    whence -w "${@}" | sed -E 's/([^:]+): (.+)/\2/g'
}

# checks if the passed function name exists
function _zc__is_function() {
    _zc__has_matches "$(_zc__get_type_of "${1}")" 'function' 'builtin'
}

# checks if the passed function name exists and calls it if found
function _zc__try_to_call() {
    _zc__is_function "${1}" && ${1} "${@:2}"
}

# parse bool-castable value to "true" or "false" string value
function _zc__bool_to_str() {
    local -a boolean_set_t=("${boolean_str_t}" '1' 't' 'true'  'enable'  'enabled'  'on' )
    local -a boolean_set_f=("${boolean_str_f}" '0' 'f' 'false' 'disable' 'disabled' 'off')
    local    imputed_value="${1:-}"
    local    boolean_str_t="${2:-true}"
    local    boolean_str_f="${3:-false}"
    local    default_value="${4:-}"

    [[ -n ${default_value} ]] && \
        default_value="$(_zc__bool_to_str "${default_value}" "${boolean_str_t}" "${boolean_str_f}")"
    [[ -z ${default_value} ]] && \
        default_value="${boolean_str_f}"

    if _zc__has_matches "${imputed_value}" "${boolean_set_t[@]}"; then
        printf -- "${boolean_str_t}"; return
    fi

    if _zc__has_matches "${imputed_value}" "${boolean_set_f[@]}"; then
        printf -- "${boolean_str_f}"; return
    fi

    printf -- "${default_value}"
}

# parses bool values (and "bool-like" or "bool-castable" values) to a bool return code of either 0 or 1
function _zc__bool_to_ret() {
    local imputed_value="${1:-}"
    local boolean_str_t="${2:-true}"
    local boolean_str_f="${3:-false}"
    local default_value="${4:-}"
    local resolved_bool="$(
        _zc__bool_to_str \
            "${imputed_value}" \
            "${boolean_str_t}" \
            "${boolean_str_f}" \
            "${default_value}"
    )"

    if [[ $(_zc__bool_to_str "${imputed_value}" "${boolean_str_t}" "${boolean_str_f}" "${default_value}") == "${boolean_str_t}" ]]; then
        return 0
    fi

    return 1
}

# parses bool-castable values and checks if result is true
function _zc__bool_is_t() {
    _zc__bool_to_ret "${@}" || return 1
}

# parses bool-castable values and checks if result is false
function _zc__bool_is_f() {
    ! _zc__bool_to_ret "${@}" || return 1
}

# returns a status code of 0 or 1 to signify if debug mode is enabled
function _zc__is_debug_enabled() {
    _zc__bool_is_t "${_zc__debug}"
}

# returns a status code of 0 or 1 to signify if silent mode is enabled
function _zc__is_quiet_enabled() {
    _zc__bool_is_f "${_zc__debug}" && _zc__bool_is_t "${_zc__quiet}"
}

# gets the current output indentation level
function _zc__out_lvls_get() {
    printf -- '%d' "${_zc__out_lvl:-0}"
}

# increases the output indentation level
function _zc__out_lvls_add() {
    _zc__out_lvl="$(($(_zc__out_lvls_get) + 1))"
}

# decreases the output indentation level
function _zc__out_lvls_del() {
    _zc__out_lvl="$(($(_zc__out_lvls_get) - 1))"
}

# handle logging of output text
function _zc__log() {
    if ! _zc__bool_to_ret "${_zc__logging}"; then
        return
    fi


    _zc__logpath
}

# handle printf error text
function _zc__out_failure_handler() {
    local orig_msg="${1}"
    local args_num="$(( ${#} - 1 ))"
    local fail_fmt="Could not compile text "%s" with "%d" replacements(s). Error message: "%s".\n"
    local fail_msg="$(printf -- "${@}" 2>&1 >/dev/null)"

    _zc__try_to_call _zc__out_pref fail

    printf -- "${fail_fmt}" "${orig_msg}" "${args_num}" "${fail_msg}" 2> /dev/null
}

# text output wrapper around printf to avoid easily caused errors
function _zc__out() {
    local out_buffer

    if [[ -n ${2} ]] && ! out_buffer="$(printf -- "${@:2}" 2> /dev/null)"; then
        out_buffer="$(_zc__out_failure_handler "${@:2}")"
    fi

    if _zc__bool_to_ret "${1}"; then
        out_buffer+='\n'
    fi

    printf "${out_buffer}"
}

# text output wrapper around printf to avoid easily caused errors
function _zc__out_text() {
    _zc__out f "${@}"
}

# line output wrapper around printf to avoid easily caused errors
function _zc__out_line() {
    _zc__out t "${@}"
}

# output tabs for each level of sourcing depth
function _zc__out_inds() {
    for i in $(seq 1 $(_zc__out_lvls_get)); do
        _zc__out_text '  '
    done

    if [[ $(_zc__out_lvls_get) -gt 0 ]]; then
        _zc__out_text '- '
    else
        _zc__out_text '• '
    fi
}

# output the prefix of a typed
function _zc__out_pref() {
    _zc__out_text '(zsh-cfg@%.03f) [%s] ' "$(date +%s\.%N)" "${1:l}"
    _zc__out_inds
}

# output a "typed" log line
function _zc__out_type() {
    _zc__out_pref "${1}"
    _zc__out "${@:2}"
}

# output an "info-typed" log line
function _zc__out_info() {
    if ! _zc__is_quiet_enabled; then
        _zc__out_type info t "${@}"
    fi
}

# output a "failure-typed" log line
function _zc__out_fail() {
    if ! _zc__is_quiet_enabled; then
        _zc__out_type fail t "${@}"
    fi
}

# output a "critical-failure-typed" log line
function _zc__out_crit() {
    if ! _zc__is_quiet_enabled; then
        _zc__out_type crit t "${@}"
        _zc__out_type exit t 'Exiting due to prior critical error ...'
        sleep 5; exit 1
    fi
}

# output a "debug-typed" log line
function _zc__dbg() {
    if _zc__is_debug_enabled; then
        _zc__out_type debug t "${@}"
    fi
}

# output a "debug-typed" action starting log line (does not end in newline)
function _zc__dbg_act_init() {
    if _zc__is_debug_enabled; then
        _zc__out_type debug f "${1} ... " "${@:2}"
    fi
}

# output a "debug-typed" action resulting log line using prior command's return code (completes output from _zc__dbg_act_init)
function _zc__dbg_act_ends() {
    if ! _zc__is_debug_enabled; then
        return
    fi

    if ! _zc__bool_to_ret "${1:-0}"; then
        _zc__out_text '[done]'
    else
        _zc__out_text '[fail]'
    fi

    if [[ $# -gt 1 ]]; then
        _zc__out_text ' (%s)' "$(_zc__out_text "${@:2}")"
    fi

    _zc__out_line
}

# forces "success" action resulting log line using _zc__dbg_act_ends
function _zc__dbg_act_ends_done() {
    _zc__dbg_act_ends 0 "${@}"
}

# forces "failure" action resulting log line using _zc__dbg_act_ends
function _zc__dbg_act_ends_fail() {
    _zc__dbg_act_ends 1 "${@}"
}

# selects first found file (using passed argument order) as active config file
function _zc__sel_user_conf_file() {
    local files=("${@}")

    for f in ${(a)files}; do
        if [[ -r ${f} ]] && [[ -s ${f} ]]; then
            _zc__out_text "${f}"
            return
        fi
    done

    return 1
}

# resolve the user config file location for the given "type" and "name"
function _zc__get_user_conf_file() {
    local type="${1}"
    local name="${2}"
    local ivar="$(_zc__out_text '_zc__%s_path' "${type}")"

    _zc__sel_user_conf_file "${_zc__user_path}/.${name}" "${(P)ivar:-${_zc__root_path}}/${name}"
}

# resolves shell-expanded value from passed value
function _zc__get_val_expands() {
    _zc__out_text "${~${(e)1}}"
}

# resolves verbose version of _zc__get_val_expands
function _zc__get_val_verbose() {
    local val_normal="${1}"
    local val_expand="$(_zc__get_val_expands "${1}")"

    if [[ ${val_normal} == ${val_expand} ]]; then
        _zc__out_text '%s' "${val_normal}"
    else
        _zc__out_text '%s (%s)' "${val_normal}" "${val_expand}"
    fi
}

# export variable using the passed name and value
function _zc__run_export_var() {
    local n="${1}"
    local v="${2}"
    local r=0

    if export "${n}"="$(_zc__get_val_expands "${v}")" 2> /dev/null; then
        _zc__dbg 'Exported new env variable: "%s" => "%s"' "${n}"  "$(_zc__get_val_verbose "${v}")"
    else
        _zc__dbg 'Failures encountered exporting new env variable: "%s" => "%s"' "${n}"  "$(_zc__get_val_verbose "${v}")"
        r=1
    fi

    return ${r}
}

# creates an alias using the passed name and value
function _zc__run_alias_cmd() {
    local n="${1}"
    local v="${2}"
    local r=0

    if alias "${n}"="$(_zc__get_val_expands "${v}")" 2> /dev/null; then
        _zc__dbg 'Assigned new env aliasing: "%s" => "%s"' "${n}"  "$(_zc__get_val_verbose "${v}")"
    else
        _zc__dbg 'Failures encountered assigning new env aliasing: "%s" => "%s"' "${n}"  "$(_zc__get_val_verbose "${v}")"
        r=1
    fi

    return ${r}
}

# get list of config-scoped functions
function _zc_l__get_scoped_subs() {
    functions | \
        grep -oE '^_zc__[^(]+' | \
        sort | \
        uniq
}

# get list of config-scoped variables
function _zc_l__get_scoped_vars() {
    { typeset -p & typeset -px; } | \
        grep -oE '^(export|typeset) [a-Z -]+?_zc__[^=]+' 2> /dev/null | \
        sed -E 's/^.+(_zc__.+)$/\1/g' 2> /dev/null | \
        sort | \
        uniq
}

# perform fake cleanup (unsetting) of config-scoped functions
function _zc__run_clean_scoped_subs() {
    _zc__dbg 'Handling cleanup of config functions ...'
    _zc__out_lvls_add

    for f ($(_zc_l__get_scoped_subs)) {
        _zc__dbg_act_init 'Unsetting config function: "%s"' "${f}"
        _zc__dbg_act_ends_done
    }

    _zc__out_lvls_del
}

# perform fake cleanup (unsetting) of config-scoped variables
function _zc__run_clean_scoped_vars() {
    _zc__dbg 'Handling cleanup of config variables ...'
    _zc__out_lvls_add

    for v ($(_zc_l__get_scoped_vars)) {
        _zc__dbg_act_init 'Unsetting config variable: "%s"' "${v}"
        _zc__dbg_act_ends_done
    }

    _zc__out_lvls_del
}

##
## perform main initialization operations
##

# load configuration files from "configs" folder
for c in ${_zc__conf_path}/*.zsh; do
    _zc__dbg 'Sourcing configuration file: "%s"' "${c}"
    _zc__out_lvls_add

    source "${c}"

    _zc__out_lvls_del
done

##
## perform cleanup (remove all internal script subs and vars)
##

# do performative cleanup operations (log to-be-unset-later conf-scoped subs and vars)
_zc__run_clean_scoped_subs
_zc__run_clean_scoped_vars

# display length of time zsh-conf tool
_zc__dbg 'Starting up customized shell environment took "%.4f" seconds to complete ...' "$(
    echo "$(date +%s.%N) - ${_zc__start}" | bc
)"

# do real cleanup operations (unset conf-scoped subs and vars)
for v ($(_zc_l__get_scoped_vars)) { unset -v "${v}" &> /dev/null; }
for f ($(_zc_l__get_scoped_subs)) { unset -f "${f}" &> /dev/null; }

# cleanup last-to-be-remove subs
unset -f _zc_l__get_scoped_subs 2> /dev/null
unset -f _zc_l__get_scoped_vars 2> /dev/null

##
## EOF
##
