#!/usr/bin/env sh

set -e

die() {
	echo "$1" 1>&2
	exit 1
}

case "$OS" in
	*Windows*)
		platform=Windows;;
	*)
		platform="$(uname -s)";;
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
test -d "$tmp_dir" || die "Cannot find tmp directory location"

input="$1"
test -n "$input" || die "Not input file specified"

output="$tmp_dir/dharma_output.html"

curl -s -F "file=@$input" -o "$output" https://dharman.in/convert || die "Cannot connect to dharman.in"

case "$platform" in
	Windows)
		explorer "$output";;
	Darwin)
		open "$output";;
	*)
		xdg-open "$output";;
esac
