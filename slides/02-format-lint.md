## ruff format: style without arguments

- One formatter, almost no options. Nobody debates quotes or line breaks again
- `just fmt` rewrites the files. `just fmt --check` only says which it would change
- On `api.py` as it arrived: 114 lines became 141, and the longest line went from 209 characters to 107
- A commit that only formats changes no behaviour, so it is read once

---

## ruff check: what a formatter cannot see

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

## 79 findings, and what removes them

| After | Findings |
|---|---|
| the commit | 79 |
| `just fmt` | 70 |
| `just lint --fix` | 69 |
| `just lint --fix --unsafe-fixes` | 37 |

- `ruff rule CODE` explains any code
- The last 37 need a person: a docstring, a type, a name. That is step 03

---

## The two fixes

- `score_confidence` compares the spread to the spread of a guess, so a guess scores 0
- `round_prob` rounds to four decimals: 77 options sum to 1.001, and 255 are off by at most 0.013

This step brings the tools. We run them here. The next commit holds what they left behind.
