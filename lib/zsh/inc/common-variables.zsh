#!/usr/bin/env zsh

##
## This file is part of the `robfrawley/zsh-conf` package.
##
## (c) Rob Frawley 2nd <rmf@src.run>
##
## For the full copyright and license information, view the LICENSE.md
## file distributed with this source code.
##

#
# resolve absolute path real name of this script
#
declare -xr _self_path_name="${${${ZSH_ARGZERO/-zsh/}:-${(%):-%x}}:P}"

#
# resolve absolute path base name of this script
#
declare -xr _self_path_base="${_self_path_name:h}"

#
# resolve file name of this script (including extension)
#
declare -xr _self_file_name="${_self_path_name:t}"

#
# resolve file name of this script (excluding extension)
#
declare -xr _self_file_base="${_self_file_name:r}"

#
# resolve file extension of this script
#
declare -xr _self_file_extn="${_self_file_name:e}"
