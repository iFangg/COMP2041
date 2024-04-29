#!/usr/bin/env python3
import sys

code = "#!/usr/bin/env python3\nimport sys\n\ncode = \"{}\"\nprint(code.format(code))\n"
print(repr(code.format(code)))
