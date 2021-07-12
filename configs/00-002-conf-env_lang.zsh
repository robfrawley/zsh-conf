#!/bin/zsh

_zc__export_lang="en_US.UTF-8"

# assign language environment variable
_zc__dbg_act_init 'Exported new env variable: "LANG" => "%s"' "${_zc__export_lang}"
export LANG="${_zc__export_lang}"
_zc__dbg_act_ends ${?}
