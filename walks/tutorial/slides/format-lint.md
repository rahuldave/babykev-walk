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

## Types in every signature

- A type annotation says what a parameter takes and what a function returns, as in
  `def round_prob(x: float) -> float`
- Python does not check annotations when it runs. A reader does, and so does a type checker
- The family `ANN` of ruff asks for an annotation on every parameter and every return value
- A function that returns nothing says so, with `-> None`
- ruff can write `-> None` itself. Where it cannot guess a type, a person writes it

---

## A docstring on every public name

- A docstring is the string on the first line of a module, a class or a function. `help()` and the editor
  show it
- The rules `D1` of ruff ask for a docstring on every public module, class and function. A name that starts
  with `_` is private, and needs none
- ruff cannot write a docstring. Only a person knows what the code is for
