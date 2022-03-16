#!/bin/zsh

for _zc__less_colorize_bin_name in chroma pygmentize; do
	# enable colored less if python3?-pygmentize or chroma package is available
	if _zc__less_colorize_bin="$(command -v ${_zc__less_colorize_bin_name})" && [[ -x "${_zc__less_colorize_bin}" ]]; then
		_zc__less_colorize_cmd="$(printf '| %s %%s 2> /dev/null' "${_zc__less_colorize_bin}")"

		_zc__dbg_act_init 'Exported new env variable: "LESSOPEN" => "%s"' "${_zc__less_colorize_cmd}"
		export LESSOPEN="${_zc__less_colorize_cmd}"
		_zc__dbg_act_ends ${?}

		break
	fi
done
