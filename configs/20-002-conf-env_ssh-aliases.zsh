#!/bin/zsh

zmodload zsh/mapfile

_zc__ssh_aliases=("${(f)mapfile[$(
    _zc__get_user_conf_file 'dots' "${_zc__dots_file_assign_ssh_aliases_list}"
)]}")

for l in ${(a)_zc__ssh_aliases}; do
    _zc__run_alias_ssh "${l%\=*}" "${l##*\=}"
done

zmodload -u zsh/mapfile
