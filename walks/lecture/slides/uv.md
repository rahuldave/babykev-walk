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
- Both are in the repository. Every machine gets the same environment
- `uv sync --locked` installs exactly what `uv.lock` says. If `uv.lock` does not match `pyproject.toml`, it stops with an error. It never writes `uv.lock` itself. A person runs `uv lock` to write it again

---

## Groups of packages that only developers need

```toml
[project]
dependencies = [
    "pydantic>=2.14.1",
]

[tool.uv]
# uv sync and uv run install every dependency group, not only dev
default-groups = "all"

[dependency-groups]
lint = [
    "ruff>=0.17.1",
]
test = [
    "pytest>=9.1.1",
    "pytest-cov>=7.1.0",
]
```

- `uv add pydantic` writes pydantic into `dependencies`. Anyone who installs babykev gets pydantic too
- `uv add --group test pytest` writes the group `test`. It is for the people who work on the project
- By default, `uv sync` installs only a group named `dev`, and this project has none. `default-groups = "all"` makes
  it install every group, so `just setup` installs pytest and ruff
