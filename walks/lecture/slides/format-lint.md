## ruff format: one style, with no arguments

- Python had several formatters, each with many options. Go shipped one, `gofmt`, with none, and Python followed
  with Black
- The formatter of ruff writes Black's style, and is much faster. It has almost no options, so nobody argues
  about quotes or line breaks again
- A formatter changes how the code looks, and never what it does. The tests pass after it as before
- `ruff format` rewrites the files. `ruff format --check` only says which files it would rewrite
- The recipe `just fmt` runs `ruff format`. With Black, the recipe would run Black, and its name would stay

---

## ruff check: a linter

- A linter reads the code and reports mistakes and code that breaks a rule. It changes a file only when it is
  asked to
- A formatter leaves a wrong line wrong, only tidier. A linter finds some wrong code. `F821` is a name that is
  used and never defined. `ruff rule F821` explains it
- Each rule has a code. The first letters name a family of rules:

| Family | Finds |
|---|---|
| `E`, `W`, `F` | errors, stray whitespace, and names that nobody uses |
| `I` | imports out of order |
| `B` | likely bugs, such as a `zip` that drops items silently |
| `UP`, `SIM` | old syntax, and code that could be simpler |
| `S` | security, such as `eval`, or `assert` in the package |
| `N` | names: classes in CamelCase, functions and variables in lower case |

- `ruff check --fix` makes the fixes that ruff counts as safe. A fix that could change what the code does waits
  for `--unsafe-fixes`, or for a person

---

## The formatter and the linter, on the file before them

`api.py` with the two fixes, before ruff, as at `tut-06`:

| After | Findings of the linter |
|---|---|
| the file as it was | 17 |
| `just fmt`, the formatter | 8 |
| `just lint --fix`, the safe fix | 7 |
| a person | 0 |

- The formatter took the four `E701`, two statements on one line, and five of the six `E501`, a line over 100
  characters. It never rewraps the text of a docstring
- The safe fix is `I001`, the order of the imports
- A person wrote the other 7, such as `X | Y` for `Union`, `k` for `K`, and `strict=True` on both calls of `zip`
- `ruff rule CODE` explains any code

---

## The indentation question

<img src="pictures/memes/commitstrip-indentation.jpg" alt="CommitStrip, The Indentation Question" style="max-height: 480px; max-width: 100%">

CommitStrip, *The Indentation Question*, 14 February 2013, commitstrip.com
