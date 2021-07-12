#!/bin/zsh
#
# read sshfs mount

zmodload zsh/mapfile

_zc__sfs_aliases=("${(f)mapfile[$(
    _zc__get_user_conf_file 'dots' "${_zc__dots_file_assign_sfs_aliases_list}"
)]}")

for l in ${(a)_zc__sfs_aliases}; do
    _zc__run_alias_sfs "${l%\=*}" "${l##*\=}"
done

zmodload -u zsh/mapfile
