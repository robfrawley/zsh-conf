#!/bin/zsh

zmodload zsh/mapfile

_zc__dirs_preceding_path="${HOME}/.zsh-conf_add-dir-preceding-env-path.list"
_zc__dirs_preceding=("${(f)mapfile[${_zc__dirs_preceding_path}]}")

if [[ -r "${_zc__dirs_preceding_path}" ]]; then
  for v in ${(a)_zc__dirs_preceding}; do
    p="$(_zc__get_val_expands "${v}")"

    if [[ -d "${p}" ]] && [[ ! "${PATH}" =~ ":${p}$" ]] && [[ ! "${PATH}" =~ "^${p}:" ]] && [[ ! "${PATH}" =~ ":${p}:" ]]; then
      _zc__dbg_act_init 'Adding preceding dir to PATH env variable: "%s"' "$(_zc__get_val_verbose "${v}")"
      export PATH="${p}:${PATH}"
      _zc__dbg_act_ends $?
    fi
  done
fi

_zc__dirs_appending_path="${HOME}/.zsh-conf_add-dir-appending-env-path.list"
_zc__dirs_appending=("${(f)mapfile[${_zc__dirs_appending_path}]}")

if [[ -r "${_zc__dirs_appending_path}" ]]; then
  for v in ${(a)_zc__dirs_appending}; do
    p="$(_zc__get_val_expands "${v}")"

    if [[ -d "${p}" ]] && [[ ! "${PATH}" =~ ":${p}$" ]] && [[ ! "${PATH}" =~ "^${p}:" ]] && [[ ! "${PATH}" =~ ":${p}:" ]]; then
      _zc__dbg_act_init 'Adding appending dir to PATH env variable: "%s"' "$(_zc__get_val_verbose "${v}")"
      export PATH="${PATH}:${p}"
      _zc__dbg_act_ends $?
    fi
  done
fi

zmodload -u zsh/mapfile