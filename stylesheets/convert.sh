#!/usr/bin/env sh

set -e

case "$OS" in
	*Windows*)
		platform=Windows;;
	*)
		platform="$(uname -s)"
esac

if test -n "$TMPDIR"; then
	tmp_dir="$TMPDIR"
elif test -n "$TEMP"; then
	tmp_dir="$TEMP"
elif test -n "$TMP"; then
	tmp_dir="$TMP"
else
	tmp_dir=/tmp
fi

input="$1"
output="$tmp_dir/dharma_output.html"

curl --silent -F "file=@$input" -o "$output" https://dharman.in/convert

case "$platform" in
	"Windows")
		explorer "$output";;
	"Darwin")
		open "$output";;
	*)
		xdg-open "$output";;
esac
