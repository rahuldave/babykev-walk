## Documentation, just before a holiday

<img src="pictures/memes/commitstrip-documentation-before-vacation.jpg" alt="CommitStrip, Documentation just before vacation" style="max-height: 480px; max-width: 100%">

CommitStrip, *Documentation just before vacation*, 27 July 2016, commitstrip.com

---

## The code documents itself

| Command | Prints |
|---|---|
| `just docs list` | every module, class and function of the package, one line each |
| `just docs module api` | one module, as plain Markdown |
| `just docs check` | every gap, and exit code 1 if there is one |

- The recipe `just docs` gives its words to `smalldocs api`, with `--dir docs`, the folder of the settings
- The Markdown has no links. It is for people at a terminal, and for AI agents

---

## Types and docs, written once

```python
def render(
    v: JSONContent,  # Text, a number, a list or an object, from a request
    indent: int = 0,  # How deeply the value is nested. Each level indents by two spaces
) -> str:  # The text that the model sees
    """Flatten str | object | array into text the model sees. Field names are kept as labels."""
```

- The **type** is in the signature
- The **meaning** is in a comment beside each parameter and beside the return, a **docment**
- The **docstring** says what the function is for
- smalldocs reads all three, and writes the reference. Nothing is written twice, so nothing can disagree

---

## What documented code looks like

```python
def render(
    v: JSONContent,  # Text, a number, a list or an object, from a request
    indent: int = 0,  # How deeply the value is nested. Each level indents by two spaces
) -> str:  # The text that the model sees
```

- The type says `int`, and the docment says what the number means. A docment says what the type cannot say

```python
class Noul(BaseModel):
    """A question of yes or no. Its criteria, if it has them, describe false and true."""

    type: Literal["noul"] = Field(description="Marks the question as one of yes or no")
```

- A field of a pydantic model has no signature to put a comment on, so it carries `description=`. The docs check
  reads it as it reads a docment

---

## The gaps

`just docs check` holds every function, method and class to one rule. It asks for a docment on every parameter and
on the return, a docstring, and a description on every field of a pydantic model.

| File | Complete |
|---|---|
| `babykev.api` | 0 of 12 |
| `babykev.cli` | 1 of 1 |
| `tests/unit/test_api.py` | 23 of 29 |
| `tests/unit/test_cli.py` | 0 of 3 |

- 24 of 45, and 46 gaps. The linter asks already for the types and the docstrings
- So the gaps are the docments, the descriptions of the fields, and the docstring of a private method
- Like coverage, the check counts. Coverage counts the lines that the tests run, and the check counts what has
  documentation

---

## Docments and the formatter

- The formatter keeps a comment on its line, so a docment survives `just fmt`
- A line of more than 100 characters can lose one. The formatter splits the line, and the comment lands away
  from what it describes
- The linter and the formatter are then happy. Only the docs check sees the lost docment
- So a docment is one short line, and the docstring holds the rest
- At `tut-13`, a docment of 119 characters on the return of `to_record` lost its place this way, and `just docs check` said `44 of 45`
