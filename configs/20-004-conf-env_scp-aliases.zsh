#!/bin/zsh
#
# read sshfs mount
#

# load zsh/mapfile
zmodload zsh/mapfile

_zc__scp_aliases=("${(f)mapfile[$(
    _zc__get_user_conf_file 'dots' "${_zc__dots_file_assign_scp_aliases_list}"
)]}")

for l in ${(a)_zc__scp_aliases}; do
    _zc__run_alias_scp "${l%\=*}" "${l##*\=}"
done

zmodload -u zsh/mapfile
