#!/bin/zsh

zmodload zsh/mapfile

_zc__var_exports=("${(f)mapfile[$(
    _zc__get_user_conf_file 'dots' "${_zc__dots_file_assign_env_exports_list}"
)]}")

for l in ${(a)_zc__var_exports}; do
    _zc__run_export_var "${l%\=*}" "${l##*\=}"
done

zmodload -u zsh/mapfile
