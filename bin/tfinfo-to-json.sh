#!/bin/bash

terraform show -no-color | \
	python -c '
import sys
import json

pk = None

data = {}
for line in sys.stdin.read().split("\n"):
	if len(line.strip()) == 0: continue
	elif not line.startswith(" "):
		pk = line.strip(":").split(".", 1)
		if pk[0] not in data:
			data[pk[0]] = {}

		data[pk[0]][pk[1]] = {}
	else:
		(a, b) = line.split(" = ", 1)
		data[pk[0]][pk[1]][a.strip()] = b

sys.stdout.write(json.dumps(data))
'
