## First, the two fixes

The two tests that failed in the last step pass now. The tests did not change. The code did.

- **A guess now has confidence 0.** When the model cannot tell the levels apart, the answer used to say it was half sure. Now it says it is not sure at all. The code measured how spread out the answer was against the wrong yardstick: the whole length of the scale, instead of how spread out a guess is. With three levels, each given a third:
  - How spread out the answer is: the levels are 0, 1 and 2 steps from the first, so ⅓×0 + ⅓×1 + ⅓×2 = **1 step**
  - Old yardstick, first level to last: **2 steps**. Confidence 1 − 1/2 = **0.5**
  - New yardstick, how spread out a guess is, around the middle level: ⅓×1 + ⅓×0 + ⅓×1 = **0.67 steps**. 1 − 1/0.67 = **−0.5**. The formula counts anything below 0 as 0, so an answer as spread out as a guess, or more, has confidence **0**
- **The probabilities add up to 1 again.** Each one was rounded to two decimal places. With 77 options, each 0.013 became 0.01, and the total came to 0.77. Now they are rounded to four places, and the total stays close to 1

This step also brings the tools. We run them next, and the next commit holds what they left behind.

---

## ruff format: style without arguments

- Python had several formatters, each with many options. Go shipped one, `gofmt`, with none, and Python followed with Black
- The ruff formatter copies Black's style and is much faster. Almost no options, so nobody argues about quotes or line breaks again
- `ruff format` is what you call. We map this to `just fmt`. If we had used Black, we would do the same.
- `just fmt` rewrites the files. `just fmt --check` only says which it would change
- On `api.py` as it arrived: 114 lines became 141, and the longest line went from 209 characters to 107
- The formatter changes how the code looks, never what it does: after `just fmt`, `just test` still says 52 passed

---

## ruff can also act as a linter

- A linter is a tool that analyzes code for errors, style issues, and compliance with coding standards. It reports; a formatter changes the file
- A formatter leaves a wrong line wrong, only tidier. A linter catches some wrong code: `F821` is a name used but never defined. `ruff rule F821` explains it
- `ruff check` tells you some of these: 

| Rules | Find |
|---|---|
| `E`, `W`, `F` | Errors, and names nobody uses |
| `I` | Imports out of order |
| `B` | Likely bugs: a mutable default, a `zip` that silently stops early |
| `UP`, `SIM` | Old syntax, and code that could be simpler |
| `S` | Security: `eval`, a hard-coded password |
| `N` | Names: classes in CamelCase, functions and variables in lower case |
| `ANN`, `D1` | Missing type annotations and docstrings |

Every rule is in `pyproject.toml`, with a comment saying why.

---

## ruff can fix some of these

One can start with `ruff check --fix`. This is mapped to `just lint --fix`. For our code:

| After | Findings |
|---|---|
| the commit | 79 |
| `just fmt` (the formatter) | 70 |
| `just lint --fix` | 69 |
| `just lint --fix --unsafe-fixes` | 37 |

- `ruff rule CODE` explains any code
- The last 37 need a person: a docstring, a type, a name. That is step 03
