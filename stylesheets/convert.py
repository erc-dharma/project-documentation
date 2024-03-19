#!/usr/bin/env python3

import os, sys, platform, tempfile, subprocess, json
from urllib import request

system = platform.system()
if system == "Windows":
	browser, shell = "start", True
elif system == "Darwin":
	browser, shell = "open", False
else:
	browser, shell = "xdg-open", False

if len(sys.argv) != 2:
	print(f"Usage: {sys.argv[0]} FILE", file=sys.stderr)
	sys.exit(1)

path = sys.argv[1]
with open(path, "rb") as f:
	data = f.read().decode("UTF-8")

tmp_dir = tempfile.gettempdir()
output = os.path.join(tmp_dir, "dharma_output.html")

url = "https://dharmalekha.info/convert"
doc = {
	"path": path,
	"data": data,
}
req = request.Request(url, json.dumps(doc).encode("UTF-8"), headers={'Content-Type':'application/json'})
resp = request.urlopen(req)
with open(output, "wb") as f:
	f.write(resp.read())

subprocess.run([browser, output], shell=shell)
