## Types and docs, written once

```python
def choice_confidence(
    p: list[float],  # The probability of each option
) -> float:  # 0 for a guess, 1 when one option has all the probability
    """Measure how far the most likely option stands above a guess among `len(p)` options."""
```

- The **type** is in the signature
- The **meaning** is in a comment beside each parameter: a **docment**
- The **docstring** says what the function is for
- Nothing is written twice, so nothing can disagree

---

## Docments and the formatter

- The formatter never joins a line that carries a comment, so docments survive `just fmt`
- One way to lose one: a line longer than 100 characters. The formatter wraps it, and the comment lands away from its parameter
- Only `docs check` notices. So lines stay at 100

---

## The program documents itself

| Command | Prints |
|---|---|
| `babykev docs list` | every module, class and function, one line each |
| `babykev docs module api` | one module as plain Markdown |
| `babykev docs check` | what is typed and documented, and every gap. Exit 1 if any |

- Plain Markdown, no links: for people at a terminal, and for agents
- fastcore's `docments` reads the comments beside the parameters

---

## The site is built from the same text

- `docs/apidocs.py` writes a reference page per module from `babykev docs`, before every render
- Quarto renders the site into `docs/_site/`. `just docs` builds it
- A name in backticks becomes a link to its entry
- At step 04 only `docs.py` is documented: `docs check` says 50 of 88, with 84 gaps. It is not in `check` yet

---

## Step 04b: every function documented

- 84 gaps filled: docments on `api.py` and the tests, descriptions on every model field
- `docs check`: 88 of 88
- `just docs check` joins `just check`. From now on, an undocumented function cannot be committed
