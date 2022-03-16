#!/bin/zsh

zmodload zsh/mapfile

_zc__cmd_aliases=("${(f)mapfile[$(
    _zc__get_user_conf_file 'dots' "${_zc__dots_file_assign_cmd_aliases_list}"
)]}")

for l in ${(a)_zc__cmd_aliases}; do
    _zc__run_alias_cmd "${l%\=*}" "${l##*\=}"
done

zmodload -u zsh/mapfile
