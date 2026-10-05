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

- **`pyproject.toml`** is written by people: what the project needs, loosely
- **`uv.lock`** is written by uv: exactly which version of everything, for every platform
- Both are committed. Every machine gets the same environment
- `uv sync --locked` refuses a lockfile that is out of date. The justfile exports `UV_LOCKED=1`, so no recipe ever re-locks quietly

---

## Groups: what only developers need

```toml
[project]
dependencies = ["pydantic", "fastcore", "torch", "transformers", "peft", "safetensors"]

[dependency-groups]          # for working on the project, never shipped
test = ["pytest", "pytest-cov", "hypothesis"]
lint = ["ruff", "ty", "pre-commit", "yamllint", "validate-pyproject", "hadolint-bin"]
dev  = [{include-group = "test"}, {include-group = "lint"}]
```

`uv sync` gives a developer everything. `uv sync --no-dev` gives an image only what the program runs (step 05b).
