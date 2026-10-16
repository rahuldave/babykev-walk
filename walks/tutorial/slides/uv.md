## uv: one tool for Python, environments and packages

| Before | With uv |
|---|---|
| pyenv, to install a Python | nothing: uv fetches the Python that the file `.python-version` names |
| venv and pip, to make an environment | `uv sync` |
| pip-tools or poetry, to pin versions | `uv lock`, which writes `uv.lock` |
| pipx, to run a tool once | `uvx ruff` |
| "activate the environment first" | `uv run <command>`: no activation |

---

## Two files describe the environment

- **`pyproject.toml`** names the packages the project needs, and it can give the lowest version of each that will do. People write it
- **`uv.lock`** names the exact version of every package, for every platform. uv writes it
- Both are committed. Every machine gets the same environment
- `uv sync --locked` installs exactly what `uv.lock` says. If `uv.lock` does not match `pyproject.toml`, it stops with an error. It never writes `uv.lock` itself. A person runs `uv lock` to write it again
- The justfile sets `UV_LOCKED=1`, so every recipe that runs uv refuses a lockfile that does not match

---

## Groups of packages that only developers need

```toml
[project]
dependencies = ["peft", "pydantic", "safetensors", "torch", "transformers"]

[tool.uv]
default-groups = "all"

[dependency-groups]          # for working on the project, never shipped
docs = ["smalldocs"]
lint = ["actionlint-py", "hadolint-bin", "pre-commit", "ruff", "ty", "validate-pyproject", "yamllint"]
test = ["hypothesis", "pytest", "pytest-cov"]
```

- `uv sync` gives a developer every group, because of `default-groups = "all"`
- `--no-default-groups` leaves the groups out. The run image installs only what the program needs with it
- `--no-default-groups --group docs` installs the package and one group. The workflow of the docs does that

---

## A group of packages for the tests

```toml
[project]
dependencies = [
    "pydantic>=2.14.1",
]

[tool.uv]
default-groups = "all"

[dependency-groups]
test = [
    "pytest>=9.1.1",
    "pytest-cov>=7.1.0",
]
```

- `uv add pydantic` writes pydantic into `dependencies`. Anyone who installs babykev gets pydantic too
- `uv add --group test pytest` writes the group `test`. It is for the people who work on the project
- By default, `uv sync` installs only a group named `dev`, and this project has no such group. `default-groups = "all"`
  makes it install every group, so `just setup` installs pytest
