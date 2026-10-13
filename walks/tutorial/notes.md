# babykev, one move at a time

This tutorial goes through the tagged steps of babykev, on its branch `tutorial`, and the small commits between
them. Each small commit is a move, one action. In do mode, you make each move yourself from its notes:

1. Type the code, or run the command in the grey block.
2. Run the command at the end of the move, which shows what the move did.
3. Press **Done**.

In watch mode, **Show** checks out the commit of each move, and the notes explain what changed.

The notes are for timewalk. To read the tutorial on GitHub, open TUTORIAL-watch.md or TUTORIAL-do.md, beside this
file. Each comes from these notes, with the commands in code blocks and a link to the commit of every move.

- **A command** is a line that starts with `$ `. In timewalk, a click types it into the terminal at the step.
- **A grey block** is code to type, or a command that makes the move.
- **Under `files:`**, `diff PATH` is a file that the move changes, and `file PATH` is a file as the move leaves
  it. `show:` names the line to look at.

## tut-00 Where we start

The project starts with no code. The first commit has the README, the licence, the notice and a `.gitignore`. A step of
the tutorial usually starts with `just setup`. But tut-00 and tut-01 cannot, because the justfile comes in the
move tut-01.4.

The step changes these files:

- `README.md`: a new file of 74 lines; what babykev is, where it comes from, the tools to install, and how the
  history is organised.
- `LICENSE`: a new file of 202 lines; the Apache License, Version 2.0, the licence of kev.
- `NOTICE`: a new file of 8 lines; the credit to kev.
- `.gitignore`: a new file of 10 lines; the files that git does not track.

Read the README first. Then read `.gitignore`.

files:
- file `README.md`: what babykev is, and the request it reads. The table gives the three types of question.
  show: ``| `choice` | One of several named options | The chosen option, a probability for each option, and a confidence |``
- file `.gitignore`: the lines that `uv init` writes in a new folder. `__pycache__/` and `*.py[oc]` are the
  compiled Python files. `build/`, `dist/`, `wheels/` and `*.egg-info` are the files of a build. `.venv` is the
  environment of the project.
  show: `.venv`

`uv init` writes this `.gitignore` only when it also makes the git repository. Here the repository exists before
`uv init` runs in the next step, so the first commit has the lines already. Each later line of `.gitignore` comes
with the move that first makes the file it ignores.

$ ls -a
$ cat .gitignore

`ls -a` lists `.` and `..`, the folder itself and the folder above it, then `.git`, the folder of the repository,
and the four files. If you ran a later step before, `ls -a` also lists `.venv`. Git ignores `.venv`, so a move
back to tut-00 leaves it where it is.

## tut-01 The project

The moves of this step make the project. uv makes a Python package with a command, and a justfile names the tasks
of the project. At the start of the step, the project has no justfile, so the step does not start with
`just setup`.

Do not run `just` in the project before tut-01.4. `just` looks for a justfile in the folder, and then in the
folders above it. In the walk repository, the folder above the project has the justfile of the walk. So before
tut-01.4, `just setup` runs the recipe `setup` of the walk, and not one of babykev.

### tut-01.1 uv makes the project

Now we make the project with uv. `uv init` makes the files of a Python project. `--package` makes a package in
`src/babykev/`, with a command that runs its function `main`. `--name babykev` names the project, and
`--python 3.13` sets the version of Python.

do$ uv init --package --name babykev --python 3.13

`uv init` leaves the README alone, because the project has one. Next, `uv lock` writes `uv.lock`, the exact
versions of every package that the project needs. The project needs no package yet, so `uv.lock` lists babykev
alone. `uv lock` prints the Python that it found, and `Resolved 1 package`.

do$ uv lock

::: watch
Open the four new files of the move.
:::

The move changes these files:

- `.python-version`: a new file of 1 line; `3.13`, the version of Python that uv installs for the project.
- `pyproject.toml`: a new file of 14 lines; the name, the version, the Python, the command and the build.
- `src/babykev/__init__.py`: a new file of 2 lines; the function `main`.
- `uv.lock`: a new file of 8 lines; the package babykev, from this folder.

Read `pyproject.toml` first.

files:
- file `pyproject.toml`: `[project.scripts]` makes a command `babykev` that runs `main` of the package `babykev`.
  `[build-system]` names `uv_build`, the tool that builds the package.
  show: `babykev = "babykev:main"`
- file `src/babykev/__init__.py`: the function that the command runs. It prints a greeting.
  show: `print("Hello from babykev!")`
- file `uv.lock`: babykev itself, installed from this folder. `editable` means that a change to the code shows at
  the next run, with no new install.
  show: `source = { editable = "." }`

$ uv run babykev

`uv run` makes `.venv`, the environment of the project, builds babykev, installs it into `.venv`, and runs the
command. It prints `Using CPython 3.13.3`, `Creating virtual environment at: .venv`, `Building babykev`,
`Built babykev` and `Installed 1 package`, then the greeting, `Hello from babykev!`. The version of Python on your
machine can differ. If you ran a later step before, `.venv` is there already. `uv run` then uninstalls the
packages of that step, and does not print `Creating virtual environment`.

`uv init` also writes the version of uv that you have into the line `requires` of `[build-system]`. So your
`pyproject.toml` can differ there too. timewalk compares `pyproject.toml` and `uv.lock` by the names of their
packages, without the versions, so the move still matches.

$ git status --short

::: do
`git status --short` lists `.python-version`, `pyproject.toml`, `src/` and `uv.lock` with `??`, because git does
not track them yet.
:::

::: watch
`git status --short` prints nothing, because the commit of the move has the new files.
:::

`git status --short` never lists `.venv`, because `.gitignore` names it.

### tut-01.2 The description, the licence and the author

Now we put the words of babykev into `pyproject.toml`, in place of the words of uv. The description says what
babykev is. `license` names the licence, and `license-files` names the two files that a package of babykev carries
with it.

::: do
In `pyproject.toml`, replace the line `description` with this line:

```toml
description = "A small decision model: one state, typed questions, a probability for every answer"
```

Then add these three lines after the line `readme = "README.md"`:

```toml
license = "Apache-2.0"
license-files = ["LICENSE", "NOTICE"]
authors = [{ name = "Rahul Dave" }]
```
:::

::: watch
Read the change of `pyproject.toml`.
:::

The move changes one file:

- `pyproject.toml`: 4 lines added, 1 removed; the description, the licence, its files and the author.

files:
- diff `pyproject.toml`: the words of babykev.
  show: `license-files = ["LICENSE", "NOTICE"]`

$ uv lock --check

`uv lock --check` says if `uv.lock` still matches `pyproject.toml`. It prints `Resolved 1 package` and ends
with exit code 0. The new lines change no dependency, so `uv.lock` stays as it was.

### tut-01.3 The command babykev, with help

Now we give babykev a command of its own, in `src/babykev/cli.py`. `babykev help` prints what the command can do.
Any other word ends with an error and exit code 2. The greeting of uv goes.

::: do
Make `src/babykev/cli.py`:

```python
"""The babykev command. `babykev help` says what it can do; every command arrives here."""

import sys

HELP = """\
babykev: a small decision model. Context, typed questions, and a probability for every answer.

usage: babykev COMMAND [FLAGS]
       babykev help

There are no commands yet.
"""


def main() -> None:
    """Print the help, or refuse a command that does not exist yet."""
    words = sys.argv[1:]
    if words and words[0] not in ("help", "--help", "-h"):
        print(f"babykev: no command named {words[0]!r}. Run `babykev help`.", file=sys.stderr)
        raise SystemExit(2)
    print(HELP, end="")
```

Delete the two lines of `src/babykev/__init__.py`, and leave the file with nothing in it, not even a blank line.
In `pyproject.toml`, change the command to `babykev = "babykev.cli:main"`.
:::

::: watch
Open the new file and the two changes of the move.
:::

The move changes these files:

- `pyproject.toml`: 1 line added, 1 removed; the command runs `main` of `babykev.cli`.
- `src/babykev/__init__.py`: 2 lines removed; the greeting goes, and the file is empty.
- `src/babykev/cli.py`: a new file of 21 lines; adds `HELP` and `main`.

Read `src/babykev/cli.py` first.

files:
- file `src/babykev/cli.py`: `main` reads the words after `babykev`. A word other than `help`, `--help` or `-h`
  ends the command with exit code 2.
  show: `raise SystemExit(2)`
- diff `pyproject.toml`: the command now runs `main` of the module `cli`.
  show: `babykev = "babykev.cli:main"`

$ uv run babykev help
$ uv run babykev train

`pyproject.toml` changed in tut-01.2 and in this move, so `uv run` builds babykev again. It prints `Building babykev`, `Built babykev`,
`Uninstalled 1 package` and `Installed 1 package`, and then the help. `babykev train` prints
``babykev: no command named 'train'. Run `babykev help`.`` and ends with exit code 2.

### tut-01.4 A justfile with the recipe setup

Now we name the first task of the project, in a `justfile`. `just` reads the file. Each task is a recipe. A
recipe is a name, then the commands to run, indented. The first task is setup. It runs `uv sync --locked`, so we run that command
first.

$ uv sync --locked

`uv sync` makes `.venv` exactly as `uv.lock` says. `--locked` makes it refuse a `uv.lock` that no longer matches
`pyproject.toml`. Here it prints `Resolved 1 package` and `Checked 1 package`, because `.venv` is already right.

::: do
Make `justfile`:

```just
# babykev: every task is a recipe here. `just` lists them.

[private]
default:
    @just --list --unsorted

# Install Python and every dependency into .venv, exactly as the lockfile says
[group('setup')]
setup:
    uv sync --locked
```
:::

::: watch
Open `justfile`.
:::

`just` alone runs the first recipe, `default`, which lists the others. `[private]` keeps `default` out of the
list. The comment above a recipe is its line in the list. `[group('setup')]` puts the recipe under a heading.

The move changes one file:

- `justfile`: a new file of 10 lines; the recipes `default` and `setup`.

files:
- file `justfile`: the recipe `setup` and its line.
  show: `setup:`

$ just --show setup
$ just setup
$ just --list --unsorted
$ just --show default
$ just

`just --show setup` prints the recipe. `just setup` prints the command, `uv sync --locked`, then runs it.
`just --list --unsorted` lists the one recipe, under `[setup]`. `just --show default` prints the recipe
`default`, which runs that command, so `just` alone prints the same list.

### tut-01.5 The recipe help

Now we add a recipe `help`, which explains a task. `just help setup` prints the line of the recipe `setup`. The
recipe `setup` also answers the word `help`, so `just setup help` prints the same line. The variable `program`
names the command once. `help` uses it now, and the recipes of later steps that run the command use it too.

::: do
Replace `justfile` with this file:

```just
# babykev: every task is a recipe here. `just` lists them; `just help VERB` explains one.

program := "babykev"

# Each word after a recipe's name reaches its commands whole, as "$1", "$2" and so on; "$@" is all of them
set positional-arguments

[private]
default:
    @just --list --unsorted

# Explain a verb: its line, and the program's flags where the program has them. Alone, the list
[no-exit-message]
help *verb:
    #!/usr/bin/env sh
    if [ "$#" -eq 0 ]; then just --list --unsorted; exit 0; fi
    shown=$(just --show "$1") || exit 1
    printf '%s\n' "$shown" | head -1 | sed 's/^# //'
    if printf '%s\n' "$shown" | grep -qF '{{ "{{ program }}" }} '"$1"; then
        uv run {{ program }} "$1" help
    fi

# Install Python and every dependency into .venv, exactly as the lockfile says
[group('setup')]
setup *args:
    @{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
```
:::

::: watch
Read the change of `justfile`.
:::

`help` takes the name of a recipe. It prints the first line of `just --show` for that recipe, without its `# `.
For a recipe with a comment, that line is the comment. A recipe of a later step that runs the program, as `uv run {{ program }} VERB`, also gets the help of the
program. The line with `grep` looks for that text in the recipe.

`just` replaces each `{{ ... }}` in a recipe with its value. So the text `{{ program }}` cannot stand in a recipe
as it is. `{{ "{{ program }}" }}` is a value in quotes, and `just` writes it as the text `{{ program }}`.

::: do
Type the line with `grep` exactly as it is.
:::

`set positional-arguments` gives each word after the name of a recipe to its commands whole, as `"$1"`. The `@` at
the start of the line of `setup` stops `just` from printing the command before it runs it.

The move changes one file:

- `justfile`: 19 lines added, 3 removed; the variable `program`, the recipe `help`, and `setup` answers `help`.

files:
- diff `justfile`: the recipe `help`, and `setup` with the word `help`.
  show: `help *verb:`

$ just --show help
$ just help
$ just help setup
$ just setup help
$ just --show setup
$ just setup
$ just

`just --show help` prints the recipe. `just help` alone prints the list. `just help setup` and `just setup help`
each print the line of `setup`. `just --show setup` prints the new body of `setup`, with `@` and the `if`. `just setup` prints `Resolved 1 package`
and `Checked 1 package`, and no longer prints `uv sync --locked` first, because of the `@`. `just` now lists `help`
first, then `setup` under `[setup]`.

### tut-01.6 The README says how to start, and what each file is

Now the README says how to start, and what each file of the project is. It gets two sections, "Start" and
"What is here", above the section "How the history is organised".

The move is the last move of tut-01, and the commit of the tag `tut-01`. So the subject of its commit starts with
`tut-01:`, and not with `tut-01.6:`.

::: do
In `README.md`, add these lines above the line `## How the history is organised`. Leave one blank line between
the new lines and that heading.

```markdown
## Start

Run `just setup` first. It installs Python and every dependency into `.venv`, exactly as `uv.lock` says.
Then `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is the help of the
program itself.

## What is here

| Path | What it is |
|---|---|
| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, and the exact versions to install |
| `src/babykev/` | The code. `cli.py` is the command `babykev` |
| `justfile` | Every task of the project, one recipe each. `just help` explains them |
| `README.md` | This file |
| `LICENSE`, `NOTICE` | The licence, and the credit to kev |
| `.python-version` | The version of Python that the project uses |
| `.gitignore` | The files that git does not track, for example `.venv` |

```
:::

::: watch
Read the change of `README.md`.
:::

The move changes one file:

- `README.md`: 18 lines added; the sections "Start" and "What is here".

files:
- diff `README.md`: how to start, and a table of the files.
  show: ``Run `just setup` first. It installs Python and every dependency into `.venv`, exactly as `uv.lock` says.``

$ just setup
$ uv run babykev help

Two of the commands of "Start" work here. `just setup` prints `Resolved 1 package` and `Checked 1 package`, and
`uv run babykev help` prints the help. The other two, `just` and `just help VERB`, ran in tut-01.5.
