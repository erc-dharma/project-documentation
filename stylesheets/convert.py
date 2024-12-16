#!/usr/bin/env python3

import os, sys, platform, tempfile, subprocess, json
from urllib import request, error

system = platform.system()
if system == "Windows":
	# The "start" command seems to be a shell builtin, only works in a
	# shell.
	browser, shell = "start", True
elif system == "Darwin":
	browser, shell = "open", False
else:
	browser, shell = "xdg-open", False

if len(sys.argv) != 2:
	print(f"Usage: {sys.argv[0]} FILE", file=sys.stderr)
	sys.exit(1)

path = sys.argv[1]
# Adding rstrip() below because newline chars appear at the end of filenames on
# Dorotea's computer, for some reason. We can reasonably expect newline chars
# not to appear in filenames on a "normal" computer.
with open(path.rstrip("\r\n"), "rb") as f:
	data = f.read().decode("UTF-8")

tmp_dir = tempfile.gettempdir()
output = os.path.join(tmp_dir, "dharma_output.html")

url = "https://dharmalekha.info/convert"
if os.getenv("DHARMA_DEBUG"):
	url = "http://localhost:8023/convert"
doc = {
	"path": path,
	"data": data,
}
headers = {
	"Content-Type": "application/json",
	"Sec-CH-UA-Platform": system,
}
req = request.Request(url, json.dumps(doc).encode("UTF-8"), headers=headers)

try:
	resp = request.urlopen(req)
	with open(output, "wb") as f:
		f.write(resp.read())
except error.URLError as e:
	code = getattr(e, "code", "no error code")
	print(f"Server unreachable: {e.reason} ({code}).", file=sys.stderr)
	print(f"Please retry in a few minutes. If this persists, contact the data manager.", file=sys.stderr)
	sys.exit(1)

# We do not add check_output=True to the following because Windows returns
# EXIT_FAILURE even on success, for some reason.
subprocess.run([browser, output], shell=shell)
