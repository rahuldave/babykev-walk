## just: the project's interface

```just
# Install Python and every dependency into .venv, exactly as the lockfile says
[group('setup')]
setup:
    uv sync --locked
```

- A recipe is a named command. `just setup` runs it
- `just` alone lists every recipe, with the comment above it
- `just --show setup` prints what is behind the name

Whoever calls a recipe does not need to know what is behind it. When the command changes, the call does not.

---

## Why automate

<img src="pictures/memes/xkcd-1319-automation.png" alt="xkcd 1319, Automation" style="max-height: 480px; max-width: 100%">

xkcd.com/1319, *Automation*. CC BY-NC 2.5

---

## The justfile, line by line

![The justfile of tut-01, with a note on what each part does](pictures/justfile.svg)

---

## The help recipe, line by line

![The help recipe of tut-01, with a note on each line](pictures/justfile-help.svg)

```
$ just help setup
Install Python and every dependency into .venv, exactly as the lockfile says

$ just help nosuch
error: Justfile does not contain recipe `nosuch`
```

---

## How to ask what a recipe does

```
just                 the list, grouped
just help test       one recipe: the comment above it, and babykev's own help when the recipe runs babykev
just test help       the same, the other way round
just --show test     the recipe itself
```

- The recipe `test` gives its extra words to pytest. For example, `just test -k render` runs `uv run pytest -k render`
- People and AI agents run the same recipes. Later, git runs them before each commit, and a server runs them each time we send our commits to GitHub
