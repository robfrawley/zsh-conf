#!/bin/zsh

_zc__nvm_version='default'

if command -v nvm &> /dev/null; then
    _zc__dbg_act_init 'Selecting nvm runtime to enable by default: "%s"' "${_zc__nvm_version}"
    nvm use "${_zc__nvm_version}" &> /dev/null
    _zc__dbg_act_ends $? "$(nvm current 2> /dev/null || printf -- 'unable to select nvm version')"
else
    _zc__dbg 'Skipping nvm runtime selection (failed to locate "nvm") ...'
fi
