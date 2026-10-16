## The files that are not Python

The tests and the linter read the Python. The config files need checks of their own:

| Check | The file it reads | A new package? |
|---|---|---|
| `validate-pyproject pyproject.toml` | `pyproject.toml`, against its standard | yes |
| `uv lock --check` | `uv.lock`, against `pyproject.toml` | no, uv has it |
| `just --fmt --check --unstable` | the `justfile` | no, just has it |
| `yamllint --strict .` | every YAML file, such as `.pre-commit-config.yaml` | yes |

- A broken `.pre-commit-config.yaml` breaks every commit, and nothing in Python sees it
- Each check is one command. The step brings them in one at a time

---

## yamllint and its settings

```yaml
# The settings of yamllint, which checks every YAML file of the project
extends: default
ignore-from-file: .gitignore  # the files that git ignores, such as everything in .venv
rules:
  document-start: disable  # a file need not start with a line of three dashes
  line-length: {max: 100}  # as long as a line of the Python code
```

- On its defaults, yamllint read `.venv` too, asked for `---` at the top of each file, and allowed 80 characters
- Each setting answers one of those findings. None of them was made up to show the tool
- `--strict` makes a warning fail, as an error does

---

## validate-pyproject: checks `pyproject.toml`

- `pyproject.toml` has a format that a standard writes down. It says which sections there are, which keys each
  may hold, and what kind of value each key takes
- `validate-pyproject pyproject.toml` checks the file against the standard. When all is well, it prints
  `Valid file: pyproject.toml`
- Write the key `requires_python` in place of `requires-python`, and the check fails. The first and the last line
  of what it prints are below

```
[ERROR] `project` must not contain {'requires_python'} properties
...
Invalid file: pyproject.toml
```

---

## `uv lock --check`: is the lockfile up to date?

- No new package is needed, because uv has the check. `--check` compares `uv.lock` with `pyproject.toml`, and
  changes nothing
- When the two agree, it prints `Resolved 29 packages`
- Write `"pydantic>=2.14"` in place of `"pydantic>=2.14.1"` in `pyproject.toml`, and do not run `uv lock`. The
  check then fails, and prints the lines below

```
error: The lockfile at `uv.lock` needs to be updated, but `--check` was provided.

hint: To update the lockfile, run `uv lock`.
```

---

## `just --fmt --check`: is the justfile formatted?

- No new package is needed, because just has its own formatter. just still marks the formatter as unstable, so
  the command needs `--unstable`
- When the justfile is formatted, it prints nothing
- Write `program:="babykev"`, with no spaces, and it prints the justfile as a diff of 78 lines. Two of them carry
  the change, and the last says why the check failed

```
-program:="babykev"
+program := "babykev"
...
error: Formatted justfile differs from original.
```
