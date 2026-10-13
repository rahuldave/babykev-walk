## uv: one tool for Python, environments and packages

| Before | With uv |
|---|---|
| pyenv, to install a Python | nothing: uv fetches the one `.python-version` names |
| venv and pip, to make an environment | `uv sync` |
| pip-tools or poetry, to pin versions | `uv lock`, which writes `uv.lock` |
| pipx, to run a tool once | `uvx ruff` |
| "activate the environment first" | `uv run <command>`: no activation |

---

## Two files describe the environment

- **`pyproject.toml`** says what the project needs, loosely. People write it
- **`uv.lock`** names the exact version of every package, for every platform. uv writes it
- Both are committed. Every machine gets the same environment
- `uv sync --locked` installs exactly what `uv.lock` says. If `uv.lock` does not match `pyproject.toml`, it stops with an error. It never writes `uv.lock` itself. A person runs `uv lock` to write it again
- The justfile sets `UV_LOCKED=1`, so every recipe that runs uv refuses a lockfile that does not match

---

## Groups of packages that only developers need

```toml
[project]
dependencies = ["pydantic", "torch", "transformers", "peft", "safetensors"]

[dependency-groups]          # for working on the project, never shipped
test = ["pytest", "pytest-cov", "hypothesis"]
lint = ["ruff", "ty", "pre-commit", "yamllint", "validate-pyproject", "hadolint-bin"]
docs = ["smalldocs"]
dev  = [{include-group = "test"}, {include-group = "lint"}, {include-group = "docs"}]
```

`uv sync` gives a developer everything. `uv sync --no-dev` gives an image only what the program runs, at tut-08.
