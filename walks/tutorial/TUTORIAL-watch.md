<!-- Made by timewalk-export from the notes of the walk. Do not edit it by hand: run timewalk-export again. -->

# babykev, one move at a time

In watch mode, you read each move. The notes explain what it changed, and its commit holds the code. [The same tutorial in do mode](TUTORIAL-do.md).

The tutorial builds babykev, a small decision model, and the engineering around it. babykev reads a document
and a set of typed questions, and gives a probability for every answer. Its model comes from the first commit of
[kev](https://github.com/jaredpalmer/kev), by Jared Palmer. The tutorial adds the rest, one move at a time. It adds
packaging with uv, one interface with `just`, tests, format, lint, types, docs, and the tests of the model.

The project is on the branch `tutorial` of [babykev](https://github.com/rahuldave/babykev/tree/tutorial). Each
step is a tag, `tut-00`, `tut-01` and so on. The small commits between two tags are the moves. Each move does one
thing, and ends with a command that shows what it did.

The tutorial has two modes, with the same text:

- **Watch mode** explains what each move changed. The code of each move is already there.
- **Do mode** gives every line to type, and every command that makes the move.

## tut-00 Where we start

[The code at tut-00](https://github.com/rahuldave/babykev/tree/tut-00)

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

Files to read:
- [`README.md`](https://github.com/rahuldave/babykev/blob/853dc617e08ec1097c71d8f20b64328fd982daea/README.md): what babykev is, and the request it reads. The table gives the three types of question.
  - look at: ``| `choice` | One of several named options | The chosen option, a probability for each option, and a confidence |``
- [`.gitignore`](https://github.com/rahuldave/babykev/blob/853dc617e08ec1097c71d8f20b64328fd982daea/.gitignore): the lines that `uv init` writes in a new folder. `__pycache__/` and `*.py[oc]` are the
  compiled Python files. `build/`, `dist/`, `wheels/` and `*.egg-info` are the files of a build. `.venv` is the
  environment of the project.
  - look at: `.venv`

`uv init` writes this `.gitignore` only when it also makes the git repository. Here the repository exists before
`uv init` runs in the next step, so the first commit has the lines already. Each later line of `.gitignore` comes
with the move that first makes the file it ignores.

```bash
ls -a
cat .gitignore
```

`ls -a` lists `.` and `..`, the folder itself and the folder above it, then `.git`, the folder of the repository,
and the four files. If you ran a later step before, `ls -a` also lists `.venv`. Git ignores `.venv`, so a move
back to tut-00 leaves it where it is.

## tut-01 The project

[The code at its Start](https://github.com/rahuldave/babykev/tree/853dc617e08ec1097c71d8f20b64328fd982daea), the commit before tut-01.1. [The code at tut-01](https://github.com/rahuldave/babykev/tree/tut-01) is the code after its moves.

The moves of this step make the project. uv makes a Python package with a command, and a justfile names the tasks
of the project. At the start of the step, the project has no justfile, so the step does not start with
`just setup`.

Do not run `just` in the project before tut-01.4. `just` looks for a justfile in the folder, and then in the
folders above it. In the walk repository, the folder above the project has the justfile of the walk. So before
tut-01.4, `just setup` runs the recipe `setup` of the walk, and not one of babykev.

### tut-01.1 uv makes the project

[The commit of this move](https://github.com/rahuldave/babykev/commit/78e1d60e18951199f8106ffb92d1d5d9956c8338) shows what the move changes.

Now we make the project with uv. `uv init` makes the files of a Python project. `--package` makes a package in
`src/babykev/`, with a command that runs its function `main`. `--name babykev` names the project, and
`--python 3.13` sets the version of Python.

The move ran: `uv init --package --name babykev --python 3.13`

`uv init` leaves the README alone, because the project has one. Next, `uv lock` writes `uv.lock`, the exact
versions of every package that the project needs. The project needs no package yet, so `uv.lock` lists babykev
alone. `uv lock` prints the Python that it found, and `Resolved 1 package`.

The move ran: `uv lock`

Open the four new files of the move.

The move changes these files:

- `.python-version`: a new file of 1 line; `3.13`, the version of Python that uv installs for the project.
- `pyproject.toml`: a new file of 14 lines; the name, the version, the Python, the command and the build.
- `src/babykev/__init__.py`: a new file of 2 lines; the function `main`.
- `uv.lock`: a new file of 8 lines; the package babykev, from this folder.

Read `pyproject.toml` first.

Files to read:
- [`pyproject.toml`](https://github.com/rahuldave/babykev/blob/78e1d60e18951199f8106ffb92d1d5d9956c8338/pyproject.toml): `[project.scripts]` makes a command `babykev` that runs `main` of the package `babykev`.
  `[build-system]` names `uv_build`, the tool that builds the package.
  - look at: `babykev = "babykev:main"`
- [`src/babykev/__init__.py`](https://github.com/rahuldave/babykev/blob/78e1d60e18951199f8106ffb92d1d5d9956c8338/src/babykev/__init__.py): the function that the command runs. It prints a greeting.
  - look at: `print("Hello from babykev!")`
- [`uv.lock`](https://github.com/rahuldave/babykev/blob/78e1d60e18951199f8106ffb92d1d5d9956c8338/uv.lock): babykev itself, installed from this folder. `editable` means that a change to the code shows at
  the next run, with no new install.
  - look at: `source = { editable = "." }`

```bash
uv run babykev
```

`uv run` makes `.venv`, the environment of the project, builds babykev, installs it into `.venv`, and runs the
command. It prints `Using CPython 3.13.3`, `Creating virtual environment at: .venv`, `Building babykev`,
`Built babykev` and `Installed 1 package`, then the greeting, `Hello from babykev!`. The version of Python on your
machine can differ. If you ran a later step before, `.venv` is there already. `uv run` then uninstalls the
packages of that step, and does not print `Creating virtual environment`.

`uv init` also writes the version of uv that you have into the line `requires` of `[build-system]`. So your
`pyproject.toml` can differ there too. timewalk compares `pyproject.toml` and `uv.lock` by the names of their
packages, without the versions, so the move still matches.

```bash
git status --short
```

`git status --short` prints nothing, because the commit of the move has the new files.

`git status --short` never lists `.venv`, because `.gitignore` names it.

### tut-01.2 The description, the licence and the author

[The commit of this move](https://github.com/rahuldave/babykev/commit/7c8244abe7608620d60e8fbe4cd6af898e62033f) shows what the move changes.

Now we put the words of babykev into `pyproject.toml`, in place of the words of uv. The description says what
babykev is. `license` names the licence, and `license-files` names the two files that a package of babykev carries
with it.

Read the change of `pyproject.toml`.

The move changes one file:

- `pyproject.toml`: 4 lines added, 1 removed; the description, the licence, its files and the author.

Files to read:
- [`pyproject.toml`](https://github.com/rahuldave/babykev/blob/7c8244abe7608620d60e8fbe4cd6af898e62033f/pyproject.toml), [its change](https://github.com/rahuldave/babykev/commit/7c8244abe7608620d60e8fbe4cd6af898e62033f#diff-50c86b7ed8ac2cf95bd48334961bf0530cdc77b5a56f852c5c61b89d735fd711): the words of babykev.
  - look at: `license-files = ["LICENSE", "NOTICE"]`

The change of `pyproject.toml`:

```diff
@@ -1,8 +1,11 @@
 [project]
 name = "babykev"
 version = "0.1.0"
-description = "Add your description here"
+description = "A small decision model: one state, typed questions, a probability for every answer"
 readme = "README.md"
+license = "Apache-2.0"
+license-files = ["LICENSE", "NOTICE"]
+authors = [{ name = "Rahul Dave" }]
 requires-python = ">=3.13"
 dependencies = []
 
```

```bash
uv lock --check
```

`uv lock --check` says if `uv.lock` still matches `pyproject.toml`. It prints `Resolved 1 package` and ends
with exit code 0. The new lines change no dependency, so `uv.lock` stays as it was.

### tut-01.3 The command babykev, with help

[The commit of this move](https://github.com/rahuldave/babykev/commit/9f14d1bd7030a7b7171976b9f4caf7695e59c8c3) shows what the move changes.

Now we give babykev a command of its own, in `src/babykev/cli.py`. `babykev help` prints what the command can do.
Any other word ends with an error and exit code 2. The greeting of uv goes.

Open the new file and the two changes of the move.

The move changes these files:

- `pyproject.toml`: 1 line added, 1 removed; the command runs `main` of `babykev.cli`.
- `src/babykev/__init__.py`: 2 lines removed; the greeting goes, and the file is empty.
- `src/babykev/cli.py`: a new file of 21 lines; adds `HELP` and `main`.

Read `src/babykev/cli.py` first.

Files to read:
- [`src/babykev/cli.py`](https://github.com/rahuldave/babykev/blob/9f14d1bd7030a7b7171976b9f4caf7695e59c8c3/src/babykev/cli.py): `main` reads the words after `babykev`. A word other than `help`, `--help` or `-h`
  ends the command with exit code 2.
  - look at: `raise SystemExit(2)`
- [`pyproject.toml`](https://github.com/rahuldave/babykev/blob/9f14d1bd7030a7b7171976b9f4caf7695e59c8c3/pyproject.toml), [its change](https://github.com/rahuldave/babykev/commit/9f14d1bd7030a7b7171976b9f4caf7695e59c8c3#diff-50c86b7ed8ac2cf95bd48334961bf0530cdc77b5a56f852c5c61b89d735fd711): the command now runs `main` of the module `cli`.
  - look at: `babykev = "babykev.cli:main"`

The change of `pyproject.toml`:

```diff
@@ -10,7 +10,7 @@ requires-python = ">=3.13"
 dependencies = []
 
 [project.scripts]
-babykev = "babykev:main"
+babykev = "babykev.cli:main"
 
 [build-system]
 requires = ["uv_build>=0.12.13,<0.13.0"]
```

```bash
uv run babykev help
uv run babykev train
```

`pyproject.toml` changed in tut-01.2 and in this move, so `uv run` builds babykev again. It prints `Building babykev`, `Built babykev`,
`Uninstalled 1 package` and `Installed 1 package`, and then the help. `babykev train` prints
``babykev: no command named 'train'. Run `babykev help`.`` and ends with exit code 2.

### tut-01.4 A justfile with the recipe setup

[The commit of this move](https://github.com/rahuldave/babykev/commit/b789df6ea94b753f330d9a1e3de3591fd683c9b4) shows what the move changes.

Now we name the first task of the project, in a `justfile`. `just` reads the file. Each task is a recipe. A
recipe is a name, then the commands to run, indented. The first task is setup. It runs `uv sync --locked`, so we run that command
first.

```bash
uv sync --locked
```

`uv sync` makes `.venv` exactly as `uv.lock` says. `--locked` makes it refuse a `uv.lock` that no longer matches
`pyproject.toml`. Here it prints `Resolved 1 package` and `Checked 1 package`, because `.venv` is already right.

Open `justfile`.

`just` alone runs the first recipe, `default`, which lists the others. `[private]` keeps `default` out of the
list. The comment above a recipe is its line in the list. `[group('setup')]` puts the recipe under a heading.

The move changes one file:

- `justfile`: a new file of 10 lines; the recipes `default` and `setup`.

Files to read:
- [`justfile`](https://github.com/rahuldave/babykev/blob/b789df6ea94b753f330d9a1e3de3591fd683c9b4/justfile): the recipe `setup` and its line.
  - look at: `setup:`

```bash
just --show setup
just setup
just --list --unsorted
just --show default
just
```

`just --show setup` prints the recipe. `just setup` prints the command, `uv sync --locked`, then runs it.
`just --list --unsorted` lists the one recipe, under `[setup]`. `just --show default` prints the recipe
`default`, which runs that command, so `just` alone prints the same list.

### tut-01.5 The recipe help

[The commit of this move](https://github.com/rahuldave/babykev/commit/e7683c3fed608fab60cdb83661ad21a72836c6f1) shows what the move changes.

Now we add a recipe `help`, which explains a task. `just help setup` prints the line of the recipe `setup`. The
recipe `setup` also answers the word `help`, so `just setup help` prints the same line. The variable `program`
names the command once. `help` uses it now, and the recipes of later steps that run the command use it too.

Read the change of `justfile`.

`help` takes the name of a recipe. It prints the first line of `just --show` for that recipe, without its `# `.
For a recipe with a comment, that line is the comment. A recipe of a later step that runs the program, as `uv run {{ program }} VERB`, also gets the help of the
program. The line with `grep` looks for that text in the recipe.

`just` replaces each `{{ ... }}` in a recipe with its value. So the text `{{ program }}` cannot stand in a recipe
as it is. `{{ "{{ program }}" }}` is a value in quotes, and `just` writes it as the text `{{ program }}`.

`set positional-arguments` gives each word after the name of a recipe to its commands whole, as `"$1"`. The `@` at
the start of the line of `setup` stops `just` from printing the command before it runs it.

The move changes one file:

- `justfile`: 19 lines added, 3 removed; the variable `program`, the recipe `help`, and `setup` answers `help`.

Files to read:
- [`justfile`](https://github.com/rahuldave/babykev/blob/e7683c3fed608fab60cdb83661ad21a72836c6f1/justfile), [its change](https://github.com/rahuldave/babykev/commit/e7683c3fed608fab60cdb83661ad21a72836c6f1#diff-deb9bb56fb122db0b605aa5b63f95a4665c905b18dd670e1fa6c877576a94ff1): the recipe `help`, and `setup` with the word `help`.
  - look at: `help *verb:`

The change of `justfile`:

```diff
@@ -1,10 +1,26 @@
-# babykev: every task is a recipe here. `just` lists them.
+# babykev: every task is a recipe here. `just` lists them; `just help VERB` explains one.
+
+program := "babykev"
+
+# Each word after a recipe's name reaches its commands whole, as "$1", "$2" and so on; "$@" is all of them
+set positional-arguments
 
 [private]
 default:
     @just --list --unsorted
 
+# Explain a verb: its line, and the program's flags where the program has them. Alone, the list
+[no-exit-message]
+help *verb:
+    #!/usr/bin/env sh
+    if [ "$#" -eq 0 ]; then just --list --unsorted; exit 0; fi
+    shown=$(just --show "$1") || exit 1
+    printf '%s\n' "$shown" | head -1 | sed 's/^# //'
+    if printf '%s\n' "$shown" | grep -qF '{{ "{{ program }}" }} '"$1"; then
+        uv run {{ program }} "$1" help
+    fi
+
 # Install Python and every dependency into .venv, exactly as the lockfile says
 [group('setup')]
-setup:
-    uv sync --locked
+setup *args:
+    @{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
```

```bash
just --show help
just help
just help setup
just setup help
just --show setup
just setup
just
```

`just --show help` prints the recipe. `just help` alone prints the list. `just help setup` and `just setup help`
each print the line of `setup`. `just --show setup` prints the new body of `setup`, with `@` and the `if`. `just setup` prints `Resolved 1 package`
and `Checked 1 package`, and no longer prints `uv sync --locked` first, because of the `@`. `just` now lists `help`
first, then `setup` under `[setup]`.

### tut-01.6 The README says how to start, and what each file is

[The commit of this move](https://github.com/rahuldave/babykev/commit/83a6740548a73924b70e34d66e28838c4059a542) shows what the move changes.

Now the README says how to start, and what each file of the project is. It gets two sections, "Start" and
"What is here", above the section "How the history is organised".

The move is the last move of tut-01, and the commit of the tag `tut-01`. So the subject of its commit starts with
`tut-01:`, and not with `tut-01.6:`.

Read the change of `README.md`.

The move changes one file:

- `README.md`: 18 lines added; the sections "Start" and "What is here".

Files to read:
- [`README.md`](https://github.com/rahuldave/babykev/blob/83a6740548a73924b70e34d66e28838c4059a542/README.md), [its change](https://github.com/rahuldave/babykev/commit/83a6740548a73924b70e34d66e28838c4059a542#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5): how to start, and a table of the files.
  - look at: ``Run `just setup` first. It installs Python and every dependency into `.venv`, exactly as `uv.lock` says.``

The change of `README.md`:

```diff
@@ -51,6 +51,24 @@ Install two tools on your machine, uv and just. The project installs everything
 | [uv](https://docs.astral.sh/uv/) | Python itself, the dependencies, and running the program |
 | [just](https://just.systems/) | The tasks of the project. `just` lists them |
 
+## Start
+
+Run `just setup` first. It installs Python and every dependency into `.venv`, exactly as `uv.lock` says.
+Then `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is the help of the
+program itself.
+
+## What is here
+
+| Path | What it is |
+|---|---|
+| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, and the exact versions to install |
+| `src/babykev/` | The code. `cli.py` is the command `babykev` |
+| `justfile` | Every task of the project, one recipe each. `just help` explains them |
+| `README.md` | This file |
+| `LICENSE`, `NOTICE` | The licence, and the credit to kev |
+| `.python-version` | The version of Python that the project uses |
+| `.gitignore` | The files that git does not track, for example `.venv` |
+
 ## How the history is organised
 
 The project is built in steps, on the branch `tutorial`. Each step has a tag, `tut-00`, `tut-01` and so
```

```bash
just setup
uv run babykev help
```

Two of the commands of "Start" work here. `just setup` prints `Resolved 1 package` and `Checked 1 package`, and
`uv run babykev help` prints the help. The other two, `just` and `just help VERB`, ran in tut-01.5.

## tut-02 The contract, and its unit tests

[The code at its Start](https://github.com/rahuldave/babykev/tree/83a6740548a73924b70e34d66e28838c4059a542), the commit before tut-02.1. [The code at tut-02](https://github.com/rahuldave/babykev/tree/tut-02) is the code after its moves.

The moves of this step bring in the contract of kev, the file `api.py`, and test it. kev's file comes in as he
wrote it, then five sample requests. pytest and the recipe `test` come next, then the tests of the command,
coverage, and the tests of the contract. Two of the
tests find two bugs of kev. A move fixes each bug, so the step ends with every test passing.

From this step on, a step starts with `just setup`. After tut-01, it prints `Resolved 1 package` and
`Checked 1 package`, because `.venv` already matches `uv.lock`. In a new copy, it makes `.venv` first.

```bash
just setup
```

### tut-02.1 Pydantic, the first dependency

[The commit of this move](https://github.com/rahuldave/babykev/commit/d69a3571237444b3227f077be36a125974462b14) shows what the move changes.

Now we add the first dependency, pydantic. pydantic checks that data has the shape that a class describes.
`uv add` writes the package into `pyproject.toml`, writes `uv.lock` again, and installs the package into `.venv`.

The move ran: `uv add pydantic`

`uv add pydantic` prints `Resolved 6 packages`, and lists what it installed. It installed pydantic and the four
packages that pydantic needs, `annotated-types`, `pydantic-core`, `typing-extensions` and
`typing-inspection`. A line with `~` says that it built babykev again, because `pyproject.toml` changed.

Read the change of `pyproject.toml`.

The move changes these files:

- `pyproject.toml`: 3 lines added, 1 removed; pydantic in `dependencies`.
- `uv.lock`: 138 lines added; pydantic and the four packages it needs, each with its exact version.

Files to read:
- [`pyproject.toml`](https://github.com/rahuldave/babykev/blob/d69a3571237444b3227f077be36a125974462b14/pyproject.toml), [its change](https://github.com/rahuldave/babykev/commit/d69a3571237444b3227f077be36a125974462b14#diff-50c86b7ed8ac2cf95bd48334961bf0530cdc77b5a56f852c5c61b89d735fd711): the first dependency. `>=2.14.1` is the version that `uv add` found, as the lowest
  version to accept. On another day, `uv add` can find a newer version.
  - look at: `"pydantic>=2.14.1",`

The change of `pyproject.toml`:

```diff
@@ -7,7 +7,9 @@ license = "Apache-2.0"
 license-files = ["LICENSE", "NOTICE"]
 authors = [{ name = "Rahul Dave" }]
 requires-python = ">=3.13"
-dependencies = []
+dependencies = [
+    "pydantic>=2.14.1",
+]
 
 [project.scripts]
 babykev = "babykev.cli:main"
```

```bash
uv tree --depth 1
```

`uv tree` prints the dependencies as a tree. `--depth 1` keeps the packages that babykev names itself. It
prints `babykev v0.1.0` and, under it, `pydantic v2.14.1`.

### tut-02.2 api.py of kev, as he wrote it

[The commit of this move](https://github.com/rahuldave/babykev/commit/d9fabb5a82412ea89d51228b50036016fc4cc3e2) shows what the move changes.

Now we bring in the contract, `api.py` of the first commit of kev, as he wrote it. The contract says what a
request is and what an answer is.

Open `src/babykev/api.py`.

The move changes one file:

- `src/babykev/api.py`: a new file of 111 lines; the pydantic models of a request and its questions, and the
  functions of the mapping.

Files to read:
- [`src/babykev/api.py`](https://github.com/rahuldave/babykev/blob/d9fabb5a82412ea89d51228b50036016fc4cc3e2/src/babykev/api.py): a request has a state and its questions by name. Each question is a `Noul`, a
  `Choice` or a `Score`, and its field `type` says which.
  - look at: `class SystemOneRequest(BaseModel):`

```bash
sed -n '14,42p' src/babykev/api.py
```

Lines 14 to 42 are the models. Each class says what its data must look like. `Literal["score"]` accepts only
the text `score`. `Field(min_length=2, max_length=MAX_OPTIONS)` asks a score for 2 to 255 levels. A `Choice`
checks its number of options in its own validator, `_check`, on lines 25 to 28. Line 42 is
`model: str = "kev-latest"`, a field of kev's server, which the next move removes.

```bash
wc -l src/babykev/api.py
uv run python -c "from babykev.api import SystemOneRequest; print(SystemOneRequest)"
```

`wc -l` counts 111 lines. The import prints `<class 'babykev.api.SystemOneRequest'>`, so the file loads with
pydantic. kev wrote some lines longer than 100 characters, and put some statements after a colon on one line.
The file follows no single format, and tut-03 formats it.

Nobody ran `uv add` in watch mode. So before the import, `uv run` installs what `uv.lock` names, and prints
`Installed 6 packages`.

### tut-02.3 api.py loses the parts of the server of kev

[The commit of this move](https://github.com/rahuldave/babykev/commit/7b89ec32795a13f7a868d068d0ce0dba44b45e1b) shows what the move changes.

Now we remove the parts of `api.py` that belong to the server of kev. kev served the model over HTTP, and
babykev has no server.

Read the change of `src/babykev/api.py`.

The first line named the address of the server, `POST /v1/systemone`. The field `model` named the model for the
server to run. `output_tokens` counted the tokens of an answer for a bill, and needs the tokenizer of a model.

The move changes one file:

- `src/babykev/api.py`: 1 line added, 8 removed; the docstring, the field `model` and `output_tokens`.

Files to read:
- [`src/babykev/api.py`](https://github.com/rahuldave/babykev/blob/7b89ec32795a13f7a868d068d0ce0dba44b45e1b/src/babykev/api.py), [its change](https://github.com/rahuldave/babykev/commit/7b89ec32795a13f7a868d068d0ce0dba44b45e1b#diff-a6448e2abf8c1bc7f2825f939f004ea6e229901f0ffda841eb815192e39cc448): a request now has two fields, `state` and `questions`.
  - look at: `    questions: dict[str, Question] = Field(min_length=1)`

The change of `src/babykev/api.py`:

```diff
@@ -1,4 +1,4 @@
-"""TypeSafe-compatible request/response shapes (POST /v1/systemone) mapped onto the single pointer primitive.
+"""The contract: request and answer shapes, mapped onto the single pointer primitive.
 
 Noul   -> 2 options [false, true];            answer = p(true)
 Choice -> options 'name' or 'name: desc';      answer = argmax, probabilities by name, confidence
@@ -39,7 +39,6 @@ Question = Union[Noul, Choice, Score]
 
 class SystemOneRequest(BaseModel):
     state: JSONContent
-    model: str = "kev-latest"
     questions: dict[str, Question] = Field(min_length=1)
 
 
@@ -103,9 +102,3 @@ def to_answers(probs: list[list[float]], meta: list[dict]) -> dict[str, Any]:
             score = sum(i * pi for i, pi in enumerate(p))
             out[m["id"]] = {"type": "score", "score": r2(score), "legend": m["legend"], "probabilities": {str(i): r2(v) for i, v in enumerate(p)}, "confidence": r2(score_confidence(p))}
     return out
-
-
-def output_tokens(tok, answers: dict) -> int:
-    """Billing-style figure: tokens of the serialised answers. Not a measure of generation (there is none)."""
-    import json
-    return len(tok(json.dumps(answers), add_special_tokens=False).input_ids)
```

```bash
wc -l src/babykev/api.py
uv run python -c "from babykev.api import SystemOneRequest; print(sorted(SystemOneRequest.model_fields))"
```

`wc -l` now counts 104 lines. `model_fields` lists the fields of a pydantic model, and the command prints
`['questions', 'state']`.

### tut-02.4 Five requests about cheese, as sample data

[The commit of this move](https://github.com/rahuldave/babykev/commit/c3a4d0dfdf7f2ee373314ff66ff239a1633db3ec) shows what the move changes.

Now we add five requests about cheese, which the tests read. Each line of the file is one request, in JSON. Each
question has a `label`, the right answer.

Open `data/cheese/sample.jsonl`.

The move changes one file:

- `data/cheese/sample.jsonl`: a new file of 5 lines; five requests, one on each line.

Files to read:
- [`data/cheese/sample.jsonl`](https://github.com/rahuldave/babykev/blob/c3a4d0dfdf7f2ee373314ff66ff239a1633db3ec/data/cheese/sample.jsonl): each line is a request with a `state` and its `questions`. The state is a
  JSON object on three lines, and text on the other two.

```bash
head -n 1 data/cheese/sample.jsonl | python3 -m json.tool
```

`python3 -m json.tool` prints JSON with one key on each line. The first request is about the cheese Coquetdale,
and asks three questions:

- `vegetarian` is a `noul` with the label `true`.
- `intensity` is a `score` of four levels with the label `1`, the second level.
- `milk` is a `choice` of five options with the label `cow`.

Each question also has the fields `label` and `src`, which the contract does not name. pydantic leaves out a
field that a model does not name, so the label never reaches the model.

### tut-02.5 Pytest, in the group test

[The commit of this move](https://github.com/rahuldave/babykev/commit/d90688910864b816eb2a01227e39cb418d736704) shows what the move changes.

Now we add pytest, the tool that runs the tests. pytest is for the people who work on babykev, and a package of
babykev does not need it. So it goes into a dependency group, `test`.

The move ran: `uv add --group test pytest`

`uv add --group test` writes the group `test` in `pyproject.toml`, under `[dependency-groups]`. It prints
`Resolved 12 packages`, and lists pytest and the four packages it needs. But `uv sync` installs only the group
`dev` by default, and `just setup` runs `uv sync --locked`. So the group `dev` must include the group `test`.

The move ran: `uv lock`

`uv lock` writes `uv.lock` again with the group `dev`, and prints `Resolved 12 packages`.

Read the change of `pyproject.toml`.

The move changes these files:

- `pyproject.toml`: 6 lines added; the groups `test` and `dev`.
- `uv.lock`: 73 lines added; pytest and the four packages it needs.

Files to read:
- [`pyproject.toml`](https://github.com/rahuldave/babykev/blob/d90688910864b816eb2a01227e39cb418d736704/pyproject.toml), [its change](https://github.com/rahuldave/babykev/commit/d90688910864b816eb2a01227e39cb418d736704#diff-50c86b7ed8ac2cf95bd48334961bf0530cdc77b5a56f852c5c61b89d735fd711): the group `test` has pytest, and the group `dev` includes the group `test`.
  - look at: `dev = [{ include-group = "test" }]`

The change of `pyproject.toml`:

```diff
@@ -17,3 +17,9 @@ babykev = "babykev.cli:main"
 [build-system]
 requires = ["uv_build>=0.12.13,<0.13.0"]
 build-backend = "uv_build"
+
+[dependency-groups]
+test = [
+    "pytest>=9.1.1",
+]
+dev = [{ include-group = "test" }]
```

```bash
just setup
uv run pytest
```

`just setup` prints `Resolved 12 packages`, and installs pytest and the four packages it needs.

`uv run pytest` looks for tests and finds none. It prints `collected 0 items` and `no tests ran`, and ends with
exit code 5. pytest uses exit code 5 to say that it found no test.

### tut-02.6 The recipe test

[The commit of this move](https://github.com/rahuldave/babykev/commit/f8070fd6c464826cd78869e17e6872e2032ee36b) shows what the move changes.

Now we give pytest a recipe, `test`. The command behind it ran in the last move, `uv run pytest`.

Read the change of `justfile`.

`test` gives every word after its name to pytest, as `"$@"`. So `just test -k render` runs
`uv run pytest -k render`. The word `help` alone prints the line of the recipe. pytest prints what failed, so
`[no-exit-message]` stops `just` from adding a line of its own when pytest ends with an error.

The move changes one file:

- `justfile`: 6 lines added; the recipe `test`, in the group `quality`.

Files to read:
- [`justfile`](https://github.com/rahuldave/babykev/blob/f8070fd6c464826cd78869e17e6872e2032ee36b/justfile), [its change](https://github.com/rahuldave/babykev/commit/f8070fd6c464826cd78869e17e6872e2032ee36b#diff-deb9bb56fb122db0b605aa5b63f95a4665c905b18dd670e1fa6c877576a94ff1): the recipe `test`.
  - look at: `test *args:`

The change of `justfile`:

```diff
@@ -24,3 +24,9 @@ help *verb:
 [group('setup')]
 setup *args:
     @{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
+
+# Run the tests. Extra words go to pytest: just test -k render
+[group('quality')]
+[no-exit-message]
+test *args:
+    @{{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
```

```bash
just --show test
just test
just help test
just
```

`just --show test` prints the recipe. `just test` runs pytest, which finds no test, prints `no tests ran` and
ends with exit code 5. `just` prints no line of its own about the error. `just help test` prints the line of the
recipe. `just` lists `test` under a new heading, `[quality]`.

### tut-02.7 The tests of the command

[The commit of this move](https://github.com/rahuldave/babykev/commit/779ee3b22d67605253e5ef86afaae5ad0b90d2a4) shows what the move changes.

Now we write the first tests, the tests of the command `babykev`. A test is a function whose name starts with
`test_`, in a file whose name starts with `test_`. pytest runs each test, and a test passes when none of its
`assert` lines fails.

Open `tests/unit/test_cli.py`, and read the change of `pyproject.toml`.

The move changes these files:

- `pyproject.toml`: 3 lines added; pytest looks for tests in `tests/` alone.
- `tests/unit/test_cli.py`: a new file of 28 lines; adds `run` and two tests.

Files to read:
- [`tests/unit/test_cli.py`](https://github.com/rahuldave/babykev/blob/779ee3b22d67605253e5ef86afaae5ad0b90d2a4/tests/unit/test_cli.py): `monkeypatch` and `capsys` are fixtures of pytest. A test names a fixture as an
  argument, and pytest passes it in. `monkeypatch` sets `sys.argv`, the words of the command line, and puts it
  back after the test. `capsys` catches what the program prints.
  - look at: `@pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])`
- [`pyproject.toml`](https://github.com/rahuldave/babykev/blob/779ee3b22d67605253e5ef86afaae5ad0b90d2a4/pyproject.toml), [its change](https://github.com/rahuldave/babykev/commit/779ee3b22d67605253e5ef86afaae5ad0b90d2a4#diff-50c86b7ed8ac2cf95bd48334961bf0530cdc77b5a56f852c5c61b89d735fd711): the settings of pytest. pytest looks for tests in `tests/` alone.
  - look at: `testpaths = ["tests"]`

The change of `pyproject.toml`:

```diff
@@ -23,3 +23,6 @@ test = [
     "pytest>=9.1.1",
 ]
 dev = [{ include-group = "test" }]
+
+[tool.pytest.ini_options]
+testpaths = ["tests"]
```

```bash
just setup
just test
```

`just setup` builds babykev again, because `pyproject.toml` changed. `just test` prints `testpaths: tests` and
`collected 5 items`, then `5 passed`. The two functions make five tests, because `parametrize` runs the first
function once for each of its four values.

```bash
sed -n '21,28p' tests/unit/test_cli.py
just test -k unknown
```

Lines 21 to 28 are the second test. `pytest.raises(SystemExit)` passes only when the code inside it ends the
program. The test then checks the exit code, 2, and the two parts of the message. `-k unknown` runs the tests
with `unknown` in their name. pytest prints `5 items / 4 deselected / 1 selected` and `1 passed`.

### tut-02.8 Coverage on every run of the tests

[The commit of this move](https://github.com/rahuldave/babykev/commit/98af229d49b0b7db467e469f75819f8ac2bddfb8) shows what the move changes.

Now each run of the tests also measures coverage, the lines of `src/babykev` that the tests run. pytest-cov is a
plugin of pytest that measures it.

The move ran: `uv add --group test pytest-cov`

`uv add` puts pytest-cov in the group `test`. It prints `Resolved 14 packages`, and installs `coverage` and
`pytest-cov`.

Read the changes of `pyproject.toml` and `.gitignore`.

`addopts` gives pytest these options on every run. `--cov=babykev` measures the package babykev, and
`--cov-report=term-missing` prints a table with the lines that no test ran.

The move changes these files:

- `.gitignore`: 3 lines added; `.coverage`.
- `pyproject.toml`: 3 lines added; pytest-cov, and the options of every run.
- `uv.lock`: 108 lines added, 2 removed; coverage and pytest-cov.

Files to read:
- [`pyproject.toml`](https://github.com/rahuldave/babykev/blob/98af229d49b0b7db467e469f75819f8ac2bddfb8/pyproject.toml), [its change](https://github.com/rahuldave/babykev/commit/98af229d49b0b7db467e469f75819f8ac2bddfb8#diff-50c86b7ed8ac2cf95bd48334961bf0530cdc77b5a56f852c5c61b89d735fd711): the options of every run.
  - look at: `addopts = "--cov=babykev --cov-report=term-missing"`
- [`.gitignore`](https://github.com/rahuldave/babykev/blob/98af229d49b0b7db467e469f75819f8ac2bddfb8/.gitignore), [its change](https://github.com/rahuldave/babykev/commit/98af229d49b0b7db467e469f75819f8ac2bddfb8#diff-bc37d034bad564583790a46f19d807abfe519c5671395fd494d8cce506c42947): the file of the data of coverage.
  - look at: `.coverage`

The change of `pyproject.toml`:

```diff
@@ -21,8 +21,11 @@ build-backend = "uv_build"
 [dependency-groups]
 test = [
     "pytest>=9.1.1",
+    "pytest-cov>=7.1.0",
 ]
 dev = [{ include-group = "test" }]
 
 [tool.pytest.ini_options]
 testpaths = ["tests"]
+# Every run measures how much of src/babykev the tests run, and lists the lines they do not
+addopts = "--cov=babykev --cov-report=term-missing"
```

The change of `.gitignore`:

```diff
@@ -8,3 +8,6 @@ wheels/
 
 # Virtual environments
 .venv
+
+# The data of coverage, which pytest-cov writes on each run
+.coverage
```

```bash
just setup
just test
```

`just test` prints `5 passed`, and a table under the tests. `cli.py` has 8 statements, and the tests run all of
them, 100%. `api.py` has 66 statements, and no test runs any of them, 0%. The column `Missing` gives `7-104`,
the lines from the first import to the end. The total is 11%, 8 of 74 statements.

```bash
git status --short --ignored
```

`git status --short --ignored` lists `.coverage` with `!!`, so git ignores it. Among the other lines with `!!`
are `.venv/` and `.pytest_cache/`. pytest writes `.pytest_cache/` with a `.gitignore` of its own inside.

### tut-02.9 The tests of the request

[The commit of this move](https://github.com/rahuldave/babykev/commit/c134e22787522e846ee8ef08eb124c40113e95e7) shows what the move changes.

Now we test the shape of a request. The tests check each line of the sample data against the contract, and
check that the contract refuses a request that is wrong.

Open `tests/unit/test_api.py`.

The move changes one file:

- `tests/unit/test_api.py`: a new file of 113 lines; two tests of the sample data, and seven tests of
  validation.

Files to read:
- [`tests/unit/test_api.py`](https://github.com/rahuldave/babykev/blob/c134e22787522e846ee8ef08eb124c40113e95e7/tests/unit/test_api.py): `SAMPLE_LINES` reads the five requests of the sample data. `cheese_request`
  makes one request with a question of each type, for the tests to share.
  - look at: `def test_sample_line_fits_the_contract(line):`

```bash
just test
```

`just test` prints `22 passed`: 17 tests of `api.py` and the 5 of the command. The two tests of the sample data
each run once for each of the five lines, so they make 10 tests. `api.py` is now at 77%, with 15 statements
missing, on lines 78-79, 85-86, 90 and 94-104. The missing lines are the two functions of confidence, `r2`,
and `to_answers`. No test of this move turns probabilities into answers.

```bash
sed -n '42,50p' tests/unit/test_api.py
just test -k sample
```

Lines 42 to 50 are the first test of the sample data. `parametrize` gives it each line of the file in turn.
`model_validate` checks the line against the contract, and raises an error if the line does not fit.

`-k sample` prints `10 passed, 12 deselected`. In the table, `cli.py` is at 38% now, with lines 17-21 missing.
The tests of the command did not run, and coverage counts only the tests that ran.

### tut-02.10 The tests of the mapping

[The commit of this move](https://github.com/rahuldave/babykev/commit/f66a7f2c0f27e2ddcb08f3d2b07af694b6d0a767) shows what the move changes.

Now we test the mapping. `render` turns JSON into the text that the model reads, `to_record` turns a request
into options, and `to_answers` turns probabilities into answers.

Read the change of `tests/unit/test_api.py`.

The move changes one file:

- `tests/unit/test_api.py`: 132 lines added; tests of `render`, `option_text`, `to_record` and `to_answers`.

Files to read:
- [`tests/unit/test_api.py`](https://github.com/rahuldave/babykev/blob/f66a7f2c0f27e2ddcb08f3d2b07af694b6d0a767/tests/unit/test_api.py), [its change](https://github.com/rahuldave/babykev/commit/f66a7f2c0f27e2ddcb08f3d2b07af694b6d0a767#diff-3cabff7688a6836f0be39ae71c04a68b09858683669c2bf6d24281910999cb74): one test gives `render` nine values, from `None` to a list of objects, and
  checks the text of each.
  - look at: `def test_render_flattens_json_into_text(value, text):`

The change of `tests/unit/test_api.py`:

```diff
@@ -12,6 +12,9 @@ from babykev.api import (
     Noul,
     Score,
     SystemOneRequest,
+    option_text,
+    render,
+    to_answers,
     to_record,
 )
 
@@ -111,3 +114,132 @@ def test_score_with_one_level_is_rejected():
     """A scale needs at least two levels."""
     with pytest.raises(ValidationError):
         Score(type="score", instructions="How firm?", criteria=["Soft"])
+
+
+# Rendering
+
+
+@pytest.mark.parametrize(
+    ("value", "text"),
+    [
+        (None, ""),
+        ("Brie", "Brie"),
+        (3, "3"),
+        (2.5, "2.5"),
+        (True, "True"),
+        (["creamy", "soft"], "- creamy\n- soft"),
+        ({"cheese": "Brie", "age": 4}, "cheese: Brie\nage: 4"),
+        (
+            {"cheese": "Brie", "notes": {"texture": ["creamy", "soft"]}},
+            "cheese: Brie\nnotes:\n  texture:\n    - creamy\n    - soft",
+        ),
+        ([{"role": "customer", "content": "hello"}], "- role: customer\n  content: hello"),
+    ],
+)
+def test_render_flattens_json_into_text(value, text):
+    """Strings, numbers, lists and objects all become the text the model reads."""
+    assert render(value) == text
+
+
+@pytest.mark.parametrize(
+    ("name", "description", "text"),
+    [
+        ("cow", None, "cow"),
+        ("cow", "", "cow"),
+        ("mixed", "More than one kind of milk", "mixed: More than one kind of milk"),
+    ],
+)
+def test_option_text_adds_a_description_only_when_there_is_one(name, description, text):
+    """An option is its name, followed by its description when it has one."""
+    assert option_text(name, description) == text
+
+
+# From a request to a record
+
+
+def test_record_keeps_the_state_and_the_order_of_questions():
+    """The state is rendered once and the questions stay in request order."""
+    record, meta = to_record(cheese_request())
+    assert record["state"] == "cheese: Roquefort\norigin: France"
+    assert [m["id"] for m in meta] == ["blue", "milk", "firmness"]
+    assert [q["instr"] for q in record["questions"]] == [
+        "Is this a blue cheese?",
+        "Which milk?",
+        "How firm?",
+    ]
+
+
+def test_noul_becomes_no_then_yes():
+    """Option 0 is no and option 1 is yes, so the answer is the probability of option 1."""
+    record, meta = to_record(cheese_request())
+    assert record["questions"][0]["options"] == ["no", "yes"]
+    assert meta[0] == {"id": "blue", "type": "noul"}
+
+
+def test_noul_criteria_describe_no_and_yes():
+    """The criteria under `false` and `true` become the descriptions of no and yes."""
+    criteria = {"true": "It has blue veins", "false": "It has none"}
+    question = {"type": "noul", "instructions": "Is it blue?", "criteria": criteria}
+    request = SystemOneRequest.model_validate({"state": "Brie", "questions": {"blue": question}})
+    record, _ = to_record(request)
+    assert record["questions"][0]["options"] == ["no: It has none", "yes: It has blue veins"]
+
+
+def test_choice_becomes_one_option_per_criterion_in_order():
+    """Options keep the order of the criteria, and the metadata remembers their names."""
+    record, meta = to_record(cheese_request())
+    assert record["questions"][1]["options"] == [
+        "cow",
+        "goat",
+        "sheep",
+        "mixed: More than one kind of milk",
+    ]
+    assert meta[1] == {"id": "milk", "type": "choice", "keys": ["cow", "goat", "sheep", "mixed"]}
+
+
+def test_score_becomes_one_option_per_level_with_a_legend():
+    """Options are the levels in order, and the legend maps each index to its level."""
+    record, meta = to_record(cheese_request())
+    assert record["questions"][2]["options"] == FIRMNESS
+    assert meta[2]["legend"] == {"0": "Soft", "1": "Semi-soft", "2": "Semi-hard", "3": "Hard"}
+
+
+# From probabilities to answers
+
+
+def test_noul_answer_is_the_probability_of_yes():
+    """The answer to a yes-or-no question is one number."""
+    answers = to_answers([[0.25, 0.75]], [{"id": "blue", "type": "noul"}])
+    assert answers == {"blue": {"type": "noul", "noul": 0.75}}
+
+
+def test_choice_answer_names_the_most_likely_option():
+    """A choice answer has the winner, a probability for each option, and a confidence."""
+    meta = [{"id": "milk", "type": "choice", "keys": ["cow", "goat", "sheep"]}]
+    answer = to_answers([[0.1, 0.7, 0.2]], meta)["milk"]
+    assert answer["choice"] == "goat"
+    assert answer["probabilities"] == {"cow": 0.1, "goat": 0.7, "sheep": 0.2}
+    assert answer["confidence"] == pytest.approx(0.55)
+
+
+def test_score_answer_is_the_expected_level():
+    """A score answer is the mean level under the probabilities, with the legend to read it by."""
+    legend = {"0": "Soft", "1": "Semi-soft", "2": "Hard"}
+    answer = to_answers([[0.1, 0.2, 0.7]], [{"id": "firmness", "type": "score", "legend": legend}])[
+        "firmness"
+    ]
+    assert answer["score"] == pytest.approx(1.6)
+    assert answer["legend"] == legend
+    assert answer["probabilities"] == {"0": 0.1, "1": 0.2, "2": 0.7}
+
+
+def test_every_question_gets_an_answer_of_its_own_type():
+    """Records and answers line up: one answer per question, under the question's id."""
+    record, meta = to_record(cheese_request())
+    uniform = [[1 / len(q["options"])] * len(q["options"]) for q in record["questions"]]
+    answers = to_answers(uniform, meta)
+    assert {qid: a["type"] for qid, a in answers.items()} == {
+        "blue": "noul",
+        "milk": "choice",
+        "firmness": "score",
+    }
```

```bash
just test
```

`just test` prints `43 passed`, and `api.py` is at 100%. Every line of `api.py` runs in some test. Two lines of
it are still wrong, and the next moves show them. Coverage says which lines ran. It does not say that a test
checked what each line does.

### tut-02.11 A test of rounding, which fails

[The commit of this move](https://github.com/rahuldave/babykev/commit/b2a43589604061ada115a322d3cb487288503d72) shows what the move changes.

Now we test that the probabilities of an answer sum to 1. The test fails on purpose, because it finds a bug of
kev.

Read the change of `tests/unit/test_api.py`.

The test makes a choice of 77 options with the same probability, 1/77 each. `pytest.approx(1, abs=0.02)` accepts
any number from 0.98 to 1.02.

The move changes one file:

- `tests/unit/test_api.py`: 9 lines added; the test of rounding.

Files to read:
- [`tests/unit/test_api.py`](https://github.com/rahuldave/babykev/blob/b2a43589604061ada115a322d3cb487288503d72/tests/unit/test_api.py), [its change](https://github.com/rahuldave/babykev/commit/b2a43589604061ada115a322d3cb487288503d72#diff-3cabff7688a6836f0be39ae71c04a68b09858683669c2bf6d24281910999cb74): the sum of the rounded probabilities.
  - look at: `    assert sum(answer["probabilities"].values()) == pytest.approx(1, abs=0.02)`

The change of `tests/unit/test_api.py`:

```diff
@@ -243,3 +243,12 @@ def test_every_question_gets_an_answer_of_its_own_type():
         "milk": "choice",
         "firmness": "score",
     }
+
+
+def test_rounded_probabilities_still_sum_to_one():
+    """Rounding for output must not lose probability, even with many options."""
+    keys = [f"intent{i}" for i in range(77)]
+    answer = to_answers([[1 / 77] * 77], [{"id": "intent", "type": "choice", "keys": keys}])[
+        "intent"
+    ]
+    assert sum(answer["probabilities"].values()) == pytest.approx(1, abs=0.02)
```

```bash
just test -k sum_to_one
```

pytest prints `F` for the failed test, and then the test with a `>` at the line that failed. Under it, `assert
0.77 == 1 ± 0.02`, then `Obtained: 0.77` and `Expected: 1 ± 0.02`. It ends with `1 failed, 43 deselected`, and
exit code 1.

```bash
sed -n '89,90p' src/babykev/api.py
```

Lines 89 and 90 are `r2`, which rounds to two decimals. 1/77 is about 0.013, and `r2` makes it 0.01. 77 times
0.01 is 0.77. The test is right, and the code is wrong.

### tut-02.12 Probabilities rounded to four decimals

[The commit of this move](https://github.com/rahuldave/babykev/commit/b37359cdcf1a3156efe1d33d70de0299a9e997ef) shows what the move changes.

Now we fix the rounding. `round_prob` takes the place of `r2`, and rounds to four decimals in place of two.

Read the change of `src/babykev/api.py`.

With four decimals, each 1/77 becomes 0.013, and the 77 probabilities sum to 1.001, within 0.02 of 1.

The move changes one file:

- `src/babykev/api.py`: 8 lines added, 6 removed; `round_prob` in place of `r2`, and `to_answers` calls it.

Files to read:
- [`src/babykev/api.py`](https://github.com/rahuldave/babykev/blob/b37359cdcf1a3156efe1d33d70de0299a9e997ef/src/babykev/api.py), [its change](https://github.com/rahuldave/babykev/commit/b37359cdcf1a3156efe1d33d70de0299a9e997ef#diff-a6448e2abf8c1bc7f2825f939f004ea6e229901f0ffda841eb815192e39cc448): four decimals.
  - look at: `    return round(float(x), 4)`

The change of `src/babykev/api.py`:

```diff
@@ -86,19 +86,21 @@ def score_confidence(p: list[float]) -> float:
     return 1.0 - sum(pi * abs(i - mode) for i, pi in enumerate(p)) / (L - 1)
 
 
-def r2(x: float) -> float:
-    return round(float(x), 2)
+def round_prob(x: float) -> float:
+    """Round a number for output. Four decimals keep the sum of a distribution within 0.02 of 1,
+    even with MAX_OPTIONS options. Two decimals did not: 77 equal options summed to 0.77."""
+    return round(float(x), 4)
 
 
 def to_answers(probs: list[list[float]], meta: list[dict]) -> dict[str, Any]:
     out = {}
     for p, m in zip(probs, meta):
         if m["type"] == "noul":
-            out[m["id"]] = {"type": "noul", "noul": r2(p[1])}
+            out[m["id"]] = {"type": "noul", "noul": round_prob(p[1])}
         elif m["type"] == "choice":
-            dist = {k: r2(v) for k, v in zip(m["keys"], p)}
-            out[m["id"]] = {"type": "choice", "choice": m["keys"][max(range(len(p)), key=lambda i: p[i])], "confidence": r2(choice_confidence(p)), "probabilities": dist}
+            dist = {k: round_prob(v) for k, v in zip(m["keys"], p)}
+            out[m["id"]] = {"type": "choice", "choice": m["keys"][max(range(len(p)), key=lambda i: p[i])], "confidence": round_prob(choice_confidence(p)), "probabilities": dist}
         else:
             score = sum(i * pi for i, pi in enumerate(p))
-            out[m["id"]] = {"type": "score", "score": r2(score), "legend": m["legend"], "probabilities": {str(i): r2(v) for i, v in enumerate(p)}, "confidence": r2(score_confidence(p))}
+            out[m["id"]] = {"type": "score", "score": round_prob(score), "legend": m["legend"], "probabilities": {str(i): round_prob(v) for i, v in enumerate(p)}, "confidence": round_prob(score_confidence(p))}
     return out
```

```bash
just test -k sum_to_one
just test
```

`just test -k sum_to_one` prints `1 passed`. The test did not change, and the code did. `just test` prints
`44 passed`, and `api.py` is at 100% again.

### tut-02.13 The tests of confidence, and one fails

[The commit of this move](https://github.com/rahuldave/babykev/commit/41627c6f5fc386bca59198f2b187a3356b067ef5) shows what the move changes.

Now we test the confidence of a choice and of a score. Confidence runs from 1, when the model is sure, to 0, when
it knows nothing. One test fails on purpose, because it finds the second bug of kev.

Read the change of `tests/unit/test_api.py`.

The move changes one file:

- `tests/unit/test_api.py`: 39 lines added; three test functions of the confidence of a choice, and three of a
  score.

Files to read:
- [`tests/unit/test_api.py`](https://github.com/rahuldave/babykev/blob/41627c6f5fc386bca59198f2b187a3356b067ef5/tests/unit/test_api.py), [its change](https://github.com/rahuldave/babykev/commit/41627c6f5fc386bca59198f2b187a3356b067ef5#diff-3cabff7688a6836f0be39ae71c04a68b09858683669c2bf6d24281910999cb74): a guess gives every level the same probability. A model that guesses knows
  nothing, so its confidence must be 0.
  - look at: `    assert score_confidence([1 / 3] * 3) == pytest.approx(0)`

The change of `tests/unit/test_api.py`:

```diff
@@ -12,8 +12,10 @@ from babykev.api import (
     Noul,
     Score,
     SystemOneRequest,
+    choice_confidence,
     option_text,
     render,
+    score_confidence,
     to_answers,
     to_record,
 )
@@ -252,3 +254,40 @@ def test_rounded_probabilities_still_sum_to_one():
         "intent"
     ]
     assert sum(answer["probabilities"].values()) == pytest.approx(1, abs=0.02)
+
+
+# Confidence
+
+
+def test_choice_confidence_is_zero_for_a_guess():
+    """Equal probabilities are a guess, whatever the number of options."""
+    assert choice_confidence([0.25] * 4) == pytest.approx(0)
+
+
+def test_choice_confidence_is_one_when_certain():
+    """All the probability on one option is certainty."""
+    assert choice_confidence([0, 1, 0]) == pytest.approx(1)
+    assert choice_confidence([1.0]) == 1.0
+
+
+def test_choice_confidence_grows_with_the_winner():
+    """Between a guess and certainty, confidence follows the winning probability."""
+    assert choice_confidence([0.5, 0.25, 0.25]) == pytest.approx(0.25)
+
+
+@pytest.mark.parametrize("level", [0, 1, 2])
+def test_score_confidence_is_one_when_certain(level):
+    """All the probability on one level is certainty, wherever the level is."""
+    p = [0.0, 0.0, 0.0]
+    p[level] = 1.0
+    assert score_confidence(p) == pytest.approx(1)
+
+
+def test_score_confidence_is_zero_for_a_guess():
+    """Equal probabilities over the levels are a guess, as they are for a choice."""
+    assert score_confidence([1 / 3] * 3) == pytest.approx(0)
+
+
+def test_score_confidence_prefers_neighbouring_levels():
+    """Doubt between adjacent levels is more confident than doubt between the two ends."""
+    assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])
```

```bash
just test -k confidence
```

`-k confidence` runs the 8 tests of confidence. The six functions make 8 tests, because
`test_score_confidence_is_one_when_certain` runs once for each of three levels. pytest prints
`1 failed, 7 passed, 44 deselected`. The test that failed is `test_score_confidence_is_zero_for_a_guess`,
with `assert 0.5 == 0 ± 1.0e-12`. `pytest.approx(0)` accepts a number within 1e-12 of 0. A guess over three levels has confidence 0.5, so the score says it is half
sure when it knows nothing.

```bash
sed -n '82,86p' src/babykev/api.py
```

Lines 82 to 86 are `score_confidence`. `mode` is the most likely level. The sum is the spread around `mode`,
the expected distance of a level from `mode`. The code divides it by `L - 1`, the length of the scale.

For the guess, all levels are equally likely, and `max` takes the first, level 0, as `mode`. The levels are 0,
1 and 2 steps from it, so the spread is 1/3 × 0 + 1/3 × 1 + 1/3 × 2 = 1 step. The length is 2 steps, so the
confidence is 1 − 1/2 = 0.5.

### tut-02.14 The confidence of a score measures against a guess

[The commit of this move](https://github.com/rahuldave/babykev/commit/7647215f8bded933ee553d604c0dffda1ffe4e84) shows what the move changes.

Now we fix the confidence of a score. The code divides the spread around `mode` by the spread of a guess around
the middle level, in place of the length of the scale.

Read the change of `src/babykev/api.py`.

`guess` is the spread of a guess around the middle level. For three levels, the middle is level 1, and the
levels are 1, 0 and 1 steps from it. So `guess` is 1/3 × 1 + 1/3 × 0 + 1/3 × 1 = 2/3 of a step. For the guess
itself, `spread` around `mode` is 1 step, as before. So 1 − 1 ÷ (2/3) = 1 − 1.5 = −0.5, and `max(0.0, ...)`
counts a value below 0 as 0. A guess has confidence 0.

The answer of a model can also be as spread out as a guess, or more, without being a guess. For example,
`[0.5, 0.25, 0.25]` has `spread` 0.75, and also gets 0. `[0.6, 0.3, 0.1]` gets 0.25, and `[0.8, 0.1, 0.1]` gets
0.55. The command prints the four confidences, of the guess and of the three answers.

```bash
uv run python -c "from babykev.api import score_confidence as s; print([round(s(p), 2) for p in ([1/3]*3, [0.5, 0.25, 0.25], [0.6, 0.3, 0.1], [0.8, 0.1, 0.1])])"
```

The new function divides by `guess`, and `guess` is 0 for a scale of one level. So lines 89 and 90 answer 1 for
one level, before the division.

The move changes one file:

- `src/babykev/api.py`: 12 lines added, 4 removed; `score_confidence`.

Files to read:
- [`src/babykev/api.py`](https://github.com/rahuldave/babykev/blob/7647215f8bded933ee553d604c0dffda1ffe4e84/src/babykev/api.py), [its change](https://github.com/rahuldave/babykev/commit/7647215f8bded933ee553d604c0dffda1ffe4e84#diff-a6448e2abf8c1bc7f2825f939f004ea6e229901f0ffda841eb815192e39cc448): the spread of a guess, as the measure.
  - look at: `    guess = sum(abs(i - (L - 1) / 2) for i in range(L)) / L`

The change of `src/babykev/api.py`:

```diff
@@ -80,10 +80,18 @@ def choice_confidence(p: list[float]) -> float:
 
 
 def score_confidence(p: list[float]) -> float:
-    """Approximation of TypeSafe's 'distance from the modal level' statistic (exact formula unpublished):
-    1 - E|level - mode| / (L - 1)."""
-    L = len(p); mode = max(range(L), key=lambda i: p[i])
-    return 1.0 - sum(pi * abs(i - mode) for i, pi in enumerate(p)) / (L - 1)
+    """How closely the probabilities sit around the most likely level: 1 if certain, 0 for a guess.
+
+    `spread` is the expected distance from the most likely level. `guess` is the spread of a guess,
+    equal probability on every level, around the middle. Anything as spread out as a guess gets 0.
+    """
+    L = len(p)
+    if L == 1:
+        return 1.0
+    mode = max(range(L), key=lambda i: p[i])
+    spread = sum(pi * abs(i - mode) for i, pi in enumerate(p))
+    guess = sum(abs(i - (L - 1) / 2) for i in range(L)) / L
+    return max(0.0, 1.0 - spread / guess)
 
 
 def round_prob(x: float) -> float:
```

```bash
just test -k confidence
just test
```

`just test -k confidence` prints `8 passed`. `just test` prints `52 passed`, and `api.py` is at 99%. `Missing`
gives line 90, `return 1.0`, which no test runs. A request cannot hold a scale of one level, because `Score` asks
for two levels at least. So only a test that calls `score_confidence` itself can reach the line.

### tut-02.15 A test of a scale with one level

[The commit of this move](https://github.com/rahuldave/babykev/commit/8df60e0071415d634b862a159c1277b9b0116c77) shows what the move changes.

Now we test the line that no test ran. A scale of one level leaves nothing to doubt, so its confidence is 1.

Read the change of `tests/unit/test_api.py`.

`choice_confidence` gives the same answer for one option, and `test_choice_confidence_is_one_when_certain` tests
it with `choice_confidence([1.0])`. In `choice_confidence`, the answer for one option is part of line 79. Coverage
counts lines, so it could not have shown that answer untested.

The move changes one file:

- `tests/unit/test_api.py`: 5 lines added; the test of a scale with one level.

Files to read:
- [`tests/unit/test_api.py`](https://github.com/rahuldave/babykev/blob/8df60e0071415d634b862a159c1277b9b0116c77/tests/unit/test_api.py), [its change](https://github.com/rahuldave/babykev/commit/8df60e0071415d634b862a159c1277b9b0116c77#diff-3cabff7688a6836f0be39ae71c04a68b09858683669c2bf6d24281910999cb74): the test calls the function itself.
  - look at: `    assert score_confidence([1.0]) == 1.0`

The change of `tests/unit/test_api.py`:

```diff
@@ -291,3 +291,8 @@ def test_score_confidence_is_zero_for_a_guess():
 def test_score_confidence_prefers_neighbouring_levels():
     """Doubt between adjacent levels is more confident than doubt between the two ends."""
     assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])
+
+
+def test_score_confidence_is_one_for_a_single_level():
+    """One level leaves nothing to doubt. A request cannot have one, but the function answers it."""
+    assert score_confidence([1.0]) == 1.0
```

```bash
just test
```

`just test` prints `53 passed`, and the total is 100%, 79 of 79 statements.

### tut-02.16 The README names the contract, the data and the tests

[The commit of this move](https://github.com/rahuldave/babykev/commit/1b16d1fc764c4df81f12465ae93bb0860242ceb2) shows what the move changes.

Now the README says to run `just test`, and names the new files of the project.

The move is the last move of tut-02, and the commit of the tag `tut-02`. So the subject of its commit starts with
`tut-02:`.

Read the change of `README.md`.

The move changes one file:

- `README.md`: 9 lines added, 5 removed; `just test` in "Start". In "What is here", five rows take the place
  of two, and the row of `.gitignore` names `.coverage`.

Files to read:
- [`README.md`](https://github.com/rahuldave/babykev/blob/1b16d1fc764c4df81f12465ae93bb0860242ceb2/README.md), [its change](https://github.com/rahuldave/babykev/commit/1b16d1fc764c4df81f12465ae93bb0860242ceb2#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5): the new rows of the table.
  - look at: ``| `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |``

The change of `README.md`:

```diff
@@ -54,20 +54,24 @@ Install two tools on your machine, uv and just. The project installs everything
 ## Start
 
 Run `just setup` first. It installs Python and every dependency into `.venv`, exactly as `uv.lock` says.
-Then `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is the help of the
-program itself.
+Then run `just test`. `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is the
+help of the program itself. A recipe gives its extra words to the tool behind it. For example,
+`just test -k render` runs only the tests with `render` in their name.
 
 ## What is here
 
 | Path | What it is |
 |---|---|
-| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, and the exact versions to install |
-| `src/babykev/` | The code. `cli.py` is the command `babykev` |
+| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, the settings of its tools, and the exact versions to install |
+| `src/babykev/api.py` | The contract: the request and its three types of question as pydantic models, the text and options the model reads, and the answers made from its probabilities |
+| `src/babykev/cli.py` | The command `babykev` |
+| `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
+| `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `README.md` | This file |
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
 | `.python-version` | The version of Python that the project uses |
-| `.gitignore` | The files that git does not track, for example `.venv` |
+| `.gitignore` | The files that git does not track, for example `.venv` and `.coverage` |
 
 ## How the history is organised
 
```

```bash
just setup
just test
```

Both commands of "Start" work. `just setup` prints `Resolved 14 packages` and `Checked 13 packages`, and
`just test` prints `53 passed` with 100% coverage.
