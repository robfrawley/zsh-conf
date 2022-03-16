#!/bin/zsh

zmodload zsh/mapfile

#
# load user-home-dir-dot-file listing paths to prefix to their environment path variable
#
_zc__prefix_dir_listing=("${(f)mapfile[$(
    _zc__get_user_conf_file 'dots' "${_zc__dots_file_prefix_dir_to_path_list}"
)]}")

#
for v in ${(a)_zc__prefix_dir_listing}; do
    _zc__run_cfg_env_path_var_cmd "${v}"
    p="$(_zc__get_val_expands "${v}")"

    if [[ -d "${p}" ]] && [[ ! "${PATH}" =~ ":${p}$" ]] && [[ ! "${PATH}" =~ "^${p}:" ]] && [[ ! "${PATH}" =~ ":${p}:" ]]; then
        _zc__dbg_act_init 'Adding preceding dir to PATH env variable: "%s"' "$(_zc__get_val_verbose "${v}")"
        export PATH="${p}:${PATH}"
        _zc__dbg_act_ends ${?}
    fi
done

_zc__append_dir_listing=("${(f)mapfile[$(
    _zc__get_user_conf_file 'dots' "${_zc__dots_file_append_dir_to_path_list}"
)]}")

for v in ${(a)_zc__append_dir_listing}; do
    p="$(_zc__get_val_expands "${v}")"

    if [[ -d "${p}" ]] && [[ ! "${PATH}" =~ ":${p}$" ]] && [[ ! "${PATH}" =~ "^${p}:" ]] && [[ ! "${PATH}" =~ ":${p}:" ]]; then
        _zc__dbg_act_init 'Adding appending dir to PATH env variable: "%s"' "$(_zc__get_val_verbose "${v}")"
        export PATH="${PATH}:${p}"
        _zc__dbg_act_ends ${?}
    fi
done

zmodload -u zsh/mapfile
