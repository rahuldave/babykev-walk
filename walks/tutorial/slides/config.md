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
