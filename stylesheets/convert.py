#!/usr/bin/env python3

import os, sys, platform, tempfile, subprocess

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

input = sys.argv[1]
tmp_dir = tempfile.gettempdir()
output = os.path.join(tmp_dir, "dharma_output.html")

subprocess.run(["curl", "-s", "-F", f"file=@{input}", "-o", output, "https://dharmalekha.info/convert"], check=True)
subprocess.run([browser, output], shell=shell)
