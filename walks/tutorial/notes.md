# The walk through babykev, step by step

This file holds the notes of every step of a walk. timewalk shows the notes of the current step in the column on the
right of the page.

- **A command** is a line that starts with `$ `. A click on it types the command into the terminal of the
  step, and you press Enter to run it. With **run on click** on, a click also runs it.
- **Other tabs:** a line that starts with `runs$ ` goes to the **Runs** tab, for a command that takes a
  while. A line that starts with `main$ ` goes to the **Main** tab, in `repo/`.
- **A cue** is a line that starts with `> `. The notes column shows it shaded.
- **Edit** at the top of the column changes the notes of the step, and **Save** writes them into
  this file. Commit it to your fork to keep your notes.
- **`$ just setup` starts every step.** It is the project's own recipe, at the step. It makes the environment
  of the step, and what the step needs.
- **A move keeps your work.** Before a move, timewalk keeps your edits and commits in `worktree/` on a branch
  `timewalk/saved/<step>`, and the page says how to get them back. In a `worktree/` that an older timewalk made, a
  move with edits asks first, and stashes them.

## tut-00 Where we start

babykev starts as words, before any code. The README says what babykev is, and what request it reads. The licence is
kev's, the Apache License 2.0, and the notice gives kev the credit. `.gitignore` is GitHub's template for Python. It
names the files that Python, its tools and its environments write, and that git must not track.

There is no justfile yet, so `just setup` cannot run here. The first commands only look around.

$ ls -a
$ grep -n -x -E '__pycache__/|\.coverage|\.pytest_cache/|\.venv' .gitignore

`ls -a` lists `.` and `..`, the folder itself and the folder above it. Then it lists `.git`, the folder of the
repository, and the four files. If you ran a later part of the tutorial before, `ls -a` also lists `.venv`. Git
ignores `.venv`, so coming back here leaves it where it is.

`grep` prints four of the 220 lines of `.gitignore`, with their numbers. `__pycache__/` is on line 2, `.coverage` on
line 43, `.pytest_cache/` on line 52 and `.venv` on line 155. Python, the tools of the tests and uv write these, and
git ignores each of them before it exists.

files:
- file `README.md`: what babykev is, and the request it reads. The table gives the three types of question.
  show: ``| `noul` | Yes or no | The probability of yes |``
- file `LICENSE`: the Apache License, Version 2.0, the licence of kev.
- file `NOTICE`: the credit to kev.
- file `.gitignore`: GitHub's template for Python, from github/gitignore.
  show: `.venv`

## tut-01 The project

babykev must be a Python project before it can hold code. uv makes the project. Then babykev gets its words, its
command, and a justfile that names the tasks of the project.

There is no justfile until the ninth move, so do not run `just` in the project before then. `just` looks for a
justfile in the folder, and then in the folders above it. In the walk repository, the folder above the project has a
justfile of its own. So an early `just setup` runs that recipe, and not one of babykev.

### tut-01.1 uv makes the project

The folder has words and a licence, but nothing that Python can build or run. `uv init` makes the files of a Python
project. `--package` makes a package in `src/babykev/`, with a command that runs its function `main`.
`--name babykev` names the project, and `--python 3.13` sets the version of Python.

do$ uv init --package --name babykev --python 3.13

`uv init` leaves the README alone, because the project has one.

::: watch
The command made three files. `pyproject.toml` names the project, its Python and its command.
`src/babykev/__init__.py` holds `main`, which prints a greeting. `.python-version` says `3.13`.
:::

$ cat pyproject.toml

`[project.scripts]` makes a command, `babykev`, and names the function that it runs, `main` of the package
`babykev`. `[build-system]` names `uv_build`, the tool that builds the package. `dependencies` is an empty list.

`uv init` also writes your version of uv into the line `requires` of `[build-system]`. So your `pyproject.toml` can
differ there. The check compares `pyproject.toml` by the names of its packages, without the versions, so your files
still match.

$ git status --short

::: do
`git status --short` lists `.python-version`, `pyproject.toml` and `src/` with `??`, because git does not track them
yet.
:::

::: watch
`git status --short` prints nothing, because git already holds the new files.
:::

files:
- file `pyproject.toml`: `[project.scripts]` makes a command `babykev` that runs `main` of the package `babykev`.
  `[build-system]` names `uv_build`, the tool that builds the package.
  show: `babykev = "babykev:main"`
- file `src/babykev/__init__.py`: the function that the command runs. It prints a greeting.
  show: `print("Hello from babykev!")`
- file `.python-version`: `3.13`, the version of Python that uv installs for the project.

### tut-01.2 uv lock writes the lockfile

Two machines can install different versions of the same package, and the project then behaves differently on each.
`uv lock` writes `uv.lock`, the exact versions of every package that the project needs. The project needs no package
yet, so `uv.lock` lists babykev alone. `uv lock` prints the Python that it found, and `Resolved 1 package`.

do$ uv lock

::: watch
The new file `uv.lock` has one package, babykev, from this folder.
:::

$ uv run babykev

`uv run` makes `.venv`, the environment of the project. It builds babykev, installs it into `.venv`, and runs the
command. It prints `Using CPython 3.13.3`, `Creating virtual environment at: .venv`, `Building babykev`,
`Built babykev` and `Installed 1 package`. Then comes the greeting, `Hello from babykev!`.

The version of Python on your machine can differ. If you ran a later part before, `.venv` is there already. `uv run`
then changes the packages of `.venv` to match, and does not print `Creating virtual environment`.

files:
- file `uv.lock`: babykev itself, installed from this folder. `editable` means that a change to the code shows at the
  next run, with no new install.
  show: `source = { editable = "." }`

### tut-01.3 The description of babykev

`pyproject.toml` still has the words of uv. Its description is a placeholder, `Add your description here`. The patch
puts in what babykev is.

patch$ pyproject.toml

::: do
The patch changes one line of `pyproject.toml`, the line `description`.
:::

::: watch
In `pyproject.toml`, the line `description` now says what babykev is.
:::

$ grep -n description pyproject.toml

`grep` prints the new description, with its line number.

files:
- diff `pyproject.toml`: the description.
  show: `description = "A small decision model: one state, typed questions, a probability for every answer"`

### tut-01.4 The licence of babykev

A package says under which licence others may use it. babykev's licence is kev's, the Apache License 2.0.
`license` names it, and `license-files` names the two files that a package of babykev carries with it.

patch$ pyproject.toml

::: do
The patch adds the lines `license` and `license-files` to the table `[project]`.
:::

::: watch
In `pyproject.toml`, `license` and `license-files` now stand under `readme`.
:::

$ grep -n license pyproject.toml

`grep` prints the two lines, with their numbers. The Build it yourself page sets them with a command, which can put
them at the end of `[project]`, so the numbers can differ.

files:
- diff `pyproject.toml`: the licence, and the files a package carries.
  show: `license-files = ["LICENSE", "NOTICE"]`

### tut-01.5 The author of babykev

A package names who wrote it. `authors` names Rahul Dave.

patch$ pyproject.toml

::: do
The patch adds the line `authors` to the table `[project]`.
:::

::: watch
In `pyproject.toml`, `authors` now stands under `license-files`.
:::

$ uv lock --check

`uv lock --check` says whether `uv.lock` still matches `pyproject.toml`. It prints `Resolved 1 package`, and ends with
exit code 0. The words of the three moves change no dependency, so `uv.lock` stays as it was.

files:
- diff `pyproject.toml`: the author.
  show: `authors = [{ name = "Rahul Dave" }]`

### tut-01.6 cli.py, the command with help

`babykev` only prints the greeting of uv. A command should say what it can do, and refuse a word it does not know. The
command gets a file of its own, `src/babykev/cli.py`. `main` there reads the words after `babykev`. With no word, or
with `help`, `--help` or `-h`, it prints `HELP`. Any other word ends with a message and exit code 2.

patch$ src/babykev/cli.py

::: do
The patch makes the file. Read `main` at the end of it.
:::

::: watch
The new file `src/babykev/cli.py` holds `HELP`, the text of the help, and `main` under it. The line
`raise SystemExit(2)` ends the command on a word it does not know.
:::

Nothing runs the new `main` yet. Python can call it.

$ uv run python -c "from babykev.cli import main; main()"
$ uv run babykev

The first command prints the help. The second still prints `Hello from babykev!`, because the command still runs
the `main` of `__init__.py`.

files:
- file `src/babykev/cli.py`: `main` reads the words after `babykev`. A word other than `help`, `--help` or `-h` ends
  the command with exit code 2.
  show: `raise SystemExit(2)`

### tut-01.7 The command babykev runs cli.py

The command still runs the greeting. One line of `pyproject.toml` points it at the new `main`.

patch$ pyproject.toml

::: do
The patch changes one line, under `[project.scripts]`.
:::

::: watch
In `pyproject.toml`, the command now runs `babykev.cli:main`.
:::

$ uv run babykev help
$ uv run babykev train

`pyproject.toml` changed, so `uv run` builds babykev again, and prints `Building babykev`. Then it prints the help.
`babykev train` prints ``babykev: no command named 'train'. Run `babykev help`.`` and ends with exit code 2.

files:
- diff `pyproject.toml`: the command now runs `main` of the module `cli`.
  show: `babykev = "babykev.cli:main"`

### tut-01.8 The greeting of uv goes

Nothing runs the `main` of `src/babykev/__init__.py` any more. Code that nothing runs only misleads a reader. The
patch takes its two lines out, and leaves the file empty, with not even a blank line.

patch$ src/babykev/__init__.py

::: do
The patch deletes both lines of the file.
:::

::: watch
`src/babykev/__init__.py` is empty. Python still needs the file, because it makes `src/babykev` a package.
:::

$ wc -c src/babykev/__init__.py
$ uv run babykev

`wc -c` counts 0 bytes. `uv run babykev` prints the help, as before.

files:
- diff `src/babykev/__init__.py`: the greeting goes, and the file is empty.

### tut-01.9 A justfile with the recipe setup

The command that sets up the project is `uv sync --locked`, and nobody should have to remember it. A `justfile` names
each task of the project once. `just` reads the file. Each task is a recipe, a name and then the commands to run,
indented. Before the justfile comes in, we run the command of the recipe `setup` by hand.

$ uv sync --locked

`uv sync` makes `.venv` exactly as `uv.lock` says. `--locked` makes it refuse a `uv.lock` that no longer matches
`pyproject.toml`. It prints `Resolved 1 package`. When `.venv` is already right, it then prints `Checked 1 package`, and changes
nothing. In a new clone, it first prints `Creating virtual environment at: .venv`, and then installs babykev.

patch$ justfile

::: do
Read the recipe `setup` at the end of the file, and the comment above it.
:::

::: watch
`justfile` is new, with two recipes. `default` lists the others, and `setup` runs `uv sync --locked`.
:::

`just` alone runs the first recipe, `default`, which lists the others. `[private]` keeps `default` out of the list.
The comment above a recipe is its line in the list. `[group('setup')]` puts the recipe under a heading.

$ just --show setup
$ just setup
$ just

`just --show setup` prints the recipe. `just setup` prints the command, `uv sync --locked`, then runs it. `just` lists
the one recipe, under `[setup]`.

files:
- file `justfile`: the recipe `setup` and its line.
  show: `setup:`

### tut-01.10 The recipe help

`just` lists the recipes, but nothing explains one of them. A recipe `help` does. `just help setup` prints the line of
the recipe `setup`, and `just help` alone prints the list.

`help` needs the word after its name, for example `setup` in `just help setup`. The line
`set positional-arguments` passes such words to the commands of a recipe. The first word becomes `"$1"` and the
second `"$2"`, and a word with spaces in it stays one word. So `help` finds the name `setup` in `"$1"`.

patch$ justfile

::: do
Read the recipe `help`, after `default`, and the line `set positional-arguments` near the top.
:::

::: watch
In `justfile`, `set positional-arguments` now stands near the top, and the recipe `help` comes after `default`. The
first line of the file now names `just help VERB`.
:::

`help` runs `just --show` for the recipe, and prints its first line without the `# `. For a recipe with a comment,
that line is the comment.

$ just --show help
$ just help setup
$ just help

`just --show help` prints the recipe. `just help setup` prints
`Install Python and every dependency into .venv, exactly as the lockfile says`. `just help` prints the list, now with
`help` first.

files:
- diff `justfile`: the recipe `help`.
  show: `help *verb:`

### tut-01.11 setup answers help

A person who types `just setup help` gets `uv sync --locked`, and no help. The recipe `setup` now takes words, and
answers the word `help` with `just help setup`. The `@` at the start of its line stops `just` from printing the
command before it runs it.

patch$ justfile

::: do
The patch writes the recipe `setup` again, with `*args` and one line.
:::

::: watch
In `justfile`, `setup` takes `*args`. Its one line runs `just help setup` for the word `help`, and
`uv sync --locked` for anything else.
:::

$ just setup help
$ just setup

`just setup help` prints the line of `setup`. `just setup` prints `Resolved 1 package` and `Checked 1 package`. It no
longer prints `uv sync --locked` first, because of the `@`.

files:
- diff `justfile`: `setup` answers `help`.
  show: `@{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}`

### tut-01.12 help gives the help of the program too

Later recipes run the program, as `uv run babykev VERB`. Their help should also show the help of the program. A
variable, `program`, names the command once. `help` looks for `uv run {{ program }} VERB` in a recipe, and then runs
the program's own help too.

patch$ justfile

::: do
The patch adds `program := "babykev"` above `set positional-arguments`, and two lines at the end of `help`.
:::

::: watch
In `justfile`, `program := "babykev"` stands near the top. `help` now ends with an `if` that runs
`uv run {{ program }} "$1" help`.
:::

`just` replaces each `{{ ... }}` in a recipe with its value. So the text `{{ program }}` cannot stand in a recipe as it
is. `{{ "{{ program }}" }}` is a value in quotes, and `just` writes it as the text `{{ program }}`. No recipe runs the
program yet, so the new branch waits for one.

$ just --evaluate program
$ just help setup

`just --evaluate program` prints `babykev`. `just help setup` prints the line of `setup`, as before.

files:
- diff `justfile`: the variable `program`, and the branch of `help` that runs the program's help.
  show: `program := "babykev"`

### tut-01.13 The README says how to start

A reader of the README cannot yet tell how to start. A section, "Start", says to run `just setup` first, and names
`just`, `just help VERB` and the help of the program.

patch$ README.md

::: do
The patch adds the section "Start" above the heading `## How the history is organised`.
:::

::: watch
In `README.md`, "Start" says to run `just setup` first, and then names `just`, `just help VERB` and
`uv run babykev help`.
:::

$ grep -n '^## ' README.md

`grep` prints the headings of the README, with "Start" among them.

files:
- diff `README.md`: how to start.
  show: ``Run `just setup` first. It installs Python and every dependency into `.venv`, exactly as `uv.lock` says.``

### tut-01.14 The README says what each file is

A reader still cannot tell what each file of the project is. A section, "What is here", has a table, with a row for
each file.

patch$ README.md

::: do
The patch adds the section "What is here" after "Start".
:::

::: watch
In `README.md`, "What is here" is a table of the files of the project, from `pyproject.toml` to `.gitignore`.
:::

$ just setup
$ uv run babykev help

Both commands of "Start" work. `just setup` prints `Resolved 1 package` and `Checked 1 package`, and
`uv run babykev help` prints the help.

files:
- diff `README.md`: a table of the files.
  show: ``| `justfile` | Every task of the project, one recipe each. `just help` explains them |``

## tut-02 Tests of the command

$ just setup

`just setup` prints `Resolved 1 package`, and `Checked 1 package` when `.venv` already matches `uv.lock`. In a new
clone, it first makes `.venv`, and installs babykev.

We cannot tell whether `babykev` still works after a change, unless we run it by hand and read what it prints. Tests
run it for us. pytest finds the tests and runs them, and a recipe `just test` runs pytest. The first tests are of the
command, the only code that babykev has. Last, coverage shows which lines the tests run.

### tut-02.1 uv installs every dependency group

The tests need pytest, and a package of babykev does not. A person who installs babykev should not get pytest. So the
tools of the project go in dependency groups. A dependency group is a list of packages in `pyproject.toml` that the
project needs while we work on it. A user of the package never gets them. The test tools go in a group `test`, and
later the linters and the docs tools get groups of their own.

uv installs only the group `dev` by default. The setting `default-groups = "all"` makes `uv sync` and `uv run`
install every group. So each later `uv add --group` needs no other change to `pyproject.toml`. A patch adds the
table `[tool.uv]` with this setting.

patch$ pyproject.toml

::: do
The patch adds the table `[tool.uv]` at the end of `pyproject.toml`, after the table `[build-system]`. It has a
comment and one setting.
:::

::: watch
At the end of `pyproject.toml`, the new table `[tool.uv]` has the line `default-groups = "all"`, with a comment above
it.
:::

The setting changes which groups uv installs, and not which versions. So `uv.lock` still matches `pyproject.toml`.

$ uv lock --check

uv prints `Resolved 1 package`, and no error. The project has no groups yet, so the setting changes nothing until a
later move adds one.

files:
- diff `pyproject.toml`: the table `[tool.uv]`, so uv installs every dependency group.
  show: `default-groups = "all"`

### tut-02.2 Pytest, in the group test

Nothing runs tests yet. pytest finds the tests and runs them. It goes into the group `test`.

do$ uv add --group test pytest

`uv add --group test` writes the group `test` in `pyproject.toml`, under `[dependency-groups]`. It prints
`Resolved 7 packages`, and lists pytest and the four packages it needs.

::: do
If a newer pytest is out, `uv add` writes its version as the lower bound. That line then differs from the one here,
and so does `uv.lock`. Only the versions differ.
:::

::: watch
At the end of `pyproject.toml`, the new table `[dependency-groups]` has the group `test`, with the line
`"pytest>=9.1.1",`. `uv.lock` has pytest and the five packages it needs. One of them, colorama, is only for Windows,
so on a Mac or on Linux uv installs the other four.
:::

$ uv run pytest

`uv run pytest` looks for tests and finds none. It prints `collected 0 items` and `no tests ran`, and ends with exit
code 5. pytest uses exit code 5 to say that it found no test.

files:
- diff `pyproject.toml`: the group `test`, with pytest.
  show: `"pytest>=9.1.1",`
- diff `uv.lock`: pytest and the five packages it needs.

### tut-02.3 The recipe test

The command that runs the tests is `uv run pytest`, and every task of the project has a recipe. A recipe `test` gives
the command a short name.

patch$ justfile

::: do
The patch adds the recipe `test` at the end of `justfile`, after one blank line.
:::

::: watch
At the end of `justfile`, the recipe `test` runs `uv run pytest "$@"`. It sits under a new heading, `quality`.
:::

`test` gives every word after its name to pytest, as `"$@"`. So `just test -k help` runs `uv run pytest -k help`. The
word `help` alone prints the line of the recipe. pytest prints what failed, so `[no-exit-message]` stops `just` from
adding a line of its own when pytest ends with an error.

$ just --show test
$ just test
$ just help test

`just --show test` prints the recipe. `just test` runs pytest, which finds no test, prints `no tests ran` and ends with
exit code 5. `just` prints no line of its own about the error. `just help test` prints the line of the recipe.

files:
- diff `justfile`: the recipe `test`.
  show: `test *args:`

### tut-02.4 A test of the help

pytest runs, but there is nothing to run. The command is the only code of babykev, so its tests come first. A test is
a function whose name starts with `test_`, in a file whose name starts with `test_`. A test passes when none of its
`assert` lines fails.

The first test runs `babykev` with no word, then with `help`, `--help` and `-h`, and checks that each prints the help.

patch$ tests/unit/test_cli.py

::: do
The patch makes the file. Read the helper `run`, then the test under it.
:::

::: watch
The new file `tests/unit/test_cli.py` has the helper `run`, and the test `test_help_is_printed_for_help_and_for_no_words`.
:::

`run` sets `sys.argv`, the words of the command line, and calls `main`, as if `babykev` had been typed at a terminal.
`monkeypatch` and `capsys` are fixtures of pytest. A test names a fixture as an argument, and pytest passes it in.
`monkeypatch.setattr` changes `sys.argv` for this test alone, and puts it back after the test. `capsys` catches what
the program prints. `@pytest.mark.parametrize` runs the test once for each of its four values.

$ just test

`just test` prints `collected 4 items`, then `4 passed`. One function makes four tests.

files:
- file `tests/unit/test_cli.py`: one test, for four ways of asking for help.
  show: `@pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])`

### tut-02.5 A test of an unknown command

The tests check the help, and nothing checks what `babykev` does with a word it does not know. A second test runs
`babykev train`. It checks that the command ends with exit code 2, and that the message names the word and points to
the help.

patch$ tests/unit/test_cli.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_cli.py`, the new test runs `train` inside `pytest.raises(SystemExit)`.
:::

`pytest.raises(SystemExit)` passes only when the code inside it ends the program. The test then checks the exit code,
2, and the two parts of the message.

$ just test -k unknown_command

`-k unknown` runs the tests with `unknown` in their name. pytest prints `5 items / 4 deselected / 1 selected` and
`1 passed`.

files:
- diff `tests/unit/test_cli.py`: the test of a word that is not a command.
  show: `assert exit_info.value.code == 2`

### tut-02.6 pytest looks for tests in tests/

pytest looks for tests in every folder of the project. The tests are all in `tests/`, and a setting says so.
`testpaths` in the table `[tool.pytest.ini_options]` names the folder.

patch$ pyproject.toml

::: do
The patch adds the table `[tool.pytest.ini_options]` at the end of `pyproject.toml`.
:::

::: watch
At the end of `pyproject.toml`, the new table `[tool.pytest.ini_options]` has `testpaths = ["tests"]`.
:::

$ just test

`just test` prints `testpaths: tests` and `5 passed`.

files:
- diff `pyproject.toml`: the settings of pytest. pytest looks for tests in `tests/` alone.
  show: `testpaths = ["tests"]`

### tut-02.7 Pytest-cov, in the group test

The tests pass, but nothing says which lines of babykev they run. Coverage measures that. pytest-cov is a plugin of
pytest that measures it, when pytest gets the option `--cov`. It goes in the group `test`.

do$ uv add --group test pytest-cov

`uv add` puts pytest-cov in the group `test`. It prints `Resolved 9 packages`, and installs `coverage` and
`pytest-cov`.

::: watch
In `pyproject.toml`, the group `test` now has `"pytest-cov>=7.1.0",` under pytest. `uv.lock` has pytest-cov 7.1.0, and
coverage 7.16.2, which it needs.
:::

$ just test --cov=babykev

`just test` prints `5 passed`, and a table under the tests. `cli.py` has 8 statements, and the tests run all of them,
100%. pytest-cov writes its data into `.coverage`, and `.gitignore` already names it.

files:
- diff `pyproject.toml`: pytest-cov in the group `test`.
  show: `"pytest-cov>=7.1.0",`
- diff `uv.lock`: coverage and pytest-cov.

### tut-02.8 Coverage on every run of the tests

A person can forget to type `--cov=babykev`. `addopts` gives pytest options on every run. `--cov=babykev` measures
the package babykev, and `--cov-report=term-missing` adds a column of the lines that no test ran.

patch$ pyproject.toml

::: do
The patch adds a comment and the line `addopts` at the end of `pyproject.toml`, under `testpaths`.
:::

::: watch
At the end of `pyproject.toml`, `addopts` stands under `testpaths`, with a comment above it.
:::

$ just test

`just test` prints the table with a column `Missing`, empty, because the tests run every line of `cli.py`.

files:
- diff `pyproject.toml`: the options of every run.
  show: `addopts = "--cov=babykev --cov-report=term-missing"`

### tut-02.9 The README says to run just test

"Start" in the README does not name `just test`. Its paragraph now says to run it, and that a recipe gives its extra
words to the tool behind it.

patch$ README.md

::: do
The patch writes the paragraph under `## Start` again.
:::

::: watch
In `README.md`, "Start" now says to run `just test`, and gives `just test -k help` as an example.
:::

$ just test -k help

pytest runs the 4 tests with `help` in their name, and prints `4 passed, 1 deselected`.

files:
- diff `README.md`: `just test` in "Start".
  show: ``help of the program itself. A recipe gives its extra words to the tool behind it. For example,``

### tut-02.10 The README names the tests

The table of "What is here" has no row for the tests. A row for `tests/unit/` comes in. The row of `pyproject.toml`
now says that it has the settings of the tools too.

patch$ README.md

::: do
The patch changes the row of `pyproject.toml`, and adds the row of `tests/unit/` after the row of `src/babykev/`.
:::

::: watch
In the table of `README.md`, the new row names `tests/unit/` and `test_cli.py`.
:::

$ just setup
$ just test

`just setup` prints `Resolved 9 packages` and `Checked 8 packages`. One of the 9, colorama, is for Windows alone, so
uv installs 8 here. `just test` prints `5 passed`.

files:
- diff `README.md`: the row of the tests.
  show: ``| `tests/unit/` | The unit tests. `test_cli.py` tests the command `babykev` |``

## tut-03 The contract

$ just setup

babykev will answer typed questions about a text, and its model comes later. First we fix what a request is and what
an answer is. The agreement is a file from kev, `api.py`, and we call it the contract. It comes in whole.

Then three parts that belong to kev's server go, one at a time. Five sample requests come last. No test reaches the
contract yet, so coverage falls.

### tut-03.1 Pydantic, the first dependency

The contract is written with pydantic, and babykev does not have it yet. pydantic checks that data has the shape that
a class describes. `uv add` writes the package into `dependencies`, because a package of babykev needs it to run.

do$ uv add pydantic

`uv add pydantic` prints `Resolved 14 packages`, and lists what it installed. It installed pydantic and the four
packages that pydantic needs, `annotated-types`, `pydantic-core`, `typing-extensions` and `typing-inspection`.

::: do
If a newer pydantic is out, `uv add` writes its version as the lower bound. Only the versions differ from the ones
here.
:::

::: watch
In `pyproject.toml`, `dependencies` now names pydantic. `uv.lock` has pydantic and the four packages it needs, each at
one exact version.
:::

$ uv tree --depth 1

`uv tree` prints the dependencies as a tree. `--depth 1` keeps the packages that babykev names itself. It prints
pydantic and its version, and the group `test` with pytest and pytest-cov.

files:
- diff `pyproject.toml`: the first dependency. `>=2.14.1` is the version that `uv add` found, as the lowest version to
  accept.
  show: `"pydantic>=2.14.1",`
- diff `uv.lock`: pydantic and the four packages it needs, each with its exact version.

### tut-03.2 api.py, the contract

babykev has no contract yet. `api.py`, from kev, says what a request is and what an answer is. It comes in whole,
all 111 lines, and we read it before we change it.

patch$ src/babykev/api.py

::: do
Read lines 14 to 43 first. They are the classes of a request and its questions.
:::

::: watch
`src/babykev/api.py` is new. Lines 14 to 43 are the classes of a request. The functions after them turn a request into
options, and probabilities into answers.
:::

$ sed -n '14,43p' src/babykev/api.py

Each class says what its data must look like. `Literal["score"]` accepts only the text `score`.
`Field(min_length=2, max_length=MAX_OPTIONS)` asks a score for 2 to 255 levels. A `Choice` checks its number of options
in its own validator, `_check`, on lines 25 to 28.

$ just test

The 5 tests pass, and coverage falls. `api.py` has 70 statements, and no test runs any of them. The total is 10%, 8 of
78 statements. A file that no test reaches counts against the total.

files:
- file `src/babykev/api.py`: a request has a state and its questions by name. Each question is a `Noul`, a `Choice` or
  a `Score`, and its field `type` says which.
  show: `class SystemOneRequest(BaseModel):`

### tut-03.3 The docstring of api.py names no server

kev served the model over HTTP, and babykev has no server. The first line of `api.py` names the address of kev's
server, `POST /v1/systemone`.

patch$ src/babykev/api.py

::: do
The patch changes the first line of the file.
:::

::: watch
In `src/babykev/api.py`, the docstring no longer names `POST /v1/systemone`.
:::

$ head -n 1 src/babykev/api.py

It prints the new first line.

files:
- diff `src/babykev/api.py`: the docstring.
  show: `"""The contract: request and answer shapes, mapped onto the single pointer primitive.`

### tut-03.4 A request names no model

The field `model` named the model for kev's server to run. babykev has one model, so a request names none.

patch$ src/babykev/api.py

::: do
The patch deletes the line `model: str = "kev-latest"`, the last line of `SystemOneRequest`.
:::

::: watch
In `src/babykev/api.py`, `SystemOneRequest` ends with the line `questions`.
:::

$ uv run python -c "from babykev.api import SystemOneRequest; print(sorted(SystemOneRequest.model_fields))"

`model_fields` lists the fields of a pydantic model. The command prints `['questions', 'state']`.

files:
- diff `src/babykev/api.py`: a request has two fields, `state` and `questions`.
  show: `    questions: dict[str, Question] = Field(min_length=1)`

### tut-03.5 output_tokens goes

`output_tokens` counted the tokens of an answer for a bill, and needs the tokenizer of a model. babykev bills nothing.

patch$ src/babykev/api.py

::: do
The patch deletes the function `output_tokens` at the end of the file, and the two blank lines before it.
:::

::: watch
`src/babykev/api.py` now ends with `to_answers`.
:::

$ wc -l src/babykev/api.py
$ just test

`wc -l` counts 104 lines. `just test` prints `5 passed`, and the total is 11%, 8 of 74 statements.

files:
- diff `src/babykev/api.py`: the function goes.

### tut-03.6 Five requests about cheese, as sample data

The tests of the contract need requests to check, and the project has none. Five requests about cheese come in a file
of their own. Each line of the file is one request, in JSON. Each question has a `label`, the right answer.

patch$ data/cheese/sample.jsonl

::: do
The patch makes the file, five lines of JSON.
:::

::: watch
`data/cheese/sample.jsonl` is new, with one request on each line.
:::

$ head -n 1 data/cheese/sample.jsonl | python3 -m json.tool

`python3 -m json.tool` prints JSON with one key on each line. The first request is about the cheese Coquetdale, and
asks three questions. `vegetarian` is a `noul` with the label `true`. `intensity` is a `score` of four levels with the
label `1`, the second level. `milk` is a `choice` of five options with the label `cow`.

files:
- file `data/cheese/sample.jsonl`: each line is a request with a `state` and its `questions`.

### tut-03.7 The README names the contract and the data

The table of the README names neither the contract nor the data. Rows for `api.py`, `cli.py` and the sample data take
the place of the row of `src/babykev/`.

patch$ README.md

::: do
The patch puts three rows in place of the row of `src/babykev/`.
:::

::: watch
In the table of `README.md`, the rows of `src/babykev/api.py`, `src/babykev/cli.py` and `data/cheese/sample.jsonl`
stand above the row of the tests.
:::

$ grep -n -E 'api.py|sample.jsonl' README.md

`grep` prints the two new rows.

files:
- diff `README.md`: the rows of the contract and the data.
  show: ``| `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |``

## tut-04 What a request is

$ just setup

The contract says what a request is, and no test checks it. The tests of this part check the five sample requests
against the contract. Then they check what the contract accepts and refuses, one rule at a time. They go in
`tests/unit/test_api.py`, one test in each move.

### tut-04.1 Every line of the sample data fits the contract

The first test of `api.py` checks each of the five sample requests against the contract. `SAMPLE_LINES` reads the
file. `parametrize` gives the test each line in turn. `model_validate` checks the line, and raises an error if it does
not fit.

patch$ tests/unit/test_api.py

::: do
The patch makes the file. Read `SAMPLE_LINES`, then the test.
:::

::: watch
The new file `tests/unit/test_api.py` reads the sample data into `SAMPLE_LINES`, and has one test,
`test_sample_line_fits_the_contract`.
:::

$ just test

`just test` prints `10 passed`, the 5 of the command and one for each sample line. `api.py` is at 77%. The missing
lines are the functions that turn probabilities into answers.

files:
- file `tests/unit/test_api.py`: the sample data, and the test that checks each line.
  show: `def test_sample_line_fits_the_contract(line):`

### tut-04.2 Every question of the sample data has a label

The tests will compare answers with labels, so each label must have the right kind. A label is a boolean for a noul,
the name of an option for a choice, and the number of a level for a score.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the new test checks the label of every question of each line.
:::

$ just test -k label

pytest runs the new test once for each line, and prints `5 passed`.

files:
- diff `tests/unit/test_api.py`: the labels of the sample data.
  show: `def test_sample_line_has_a_usable_label_on_every_question(line):`

### tut-04.3 A request holds one model for each type of question

The field `type` of a question decides which class of the contract it becomes. A helper, `cheese_request`, makes one
request with a question of each type, for the tests to share. The test checks that the noul is a `Noul`, the choice a
`Choice` and the score a `Score`.

patch$ tests/unit/test_api.py

::: do
The patch adds `MILKS`, `FIRMNESS` and `cheese_request` under `SAMPLE_LINES`. It adds the section `# Validation` and
its first test at the end.
:::

::: watch
In `tests/unit/test_api.py`, `cheese_request` stands under the constants. The new test at the end checks the class of
each of its three questions.
:::

$ just test -k one_model

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: the helper, and the test of the three types.
  show: `def test_request_holds_one_model_per_question_type():`

### tut-04.4 A request without questions is refused

A request must ask at least one question. `Field(min_length=1)` on `questions` says so. The test checks that pydantic
refuses a request with none.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file, and `ValidationError` to the imports.
:::

::: watch
At the end of `tests/unit/test_api.py`, the new test expects a `ValidationError` for `"questions": {}`.
:::

$ just test -k without_questions

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: a request with no questions.
  show: `def test_request_without_questions_is_rejected():`

### tut-04.5 An unknown type of question is refused

Only noul, choice and score exist. The test gives a question the type `essay`, and expects a refusal.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the new test makes a question of type `essay`.
:::

$ just test -k unknown_question

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: a type that does not exist.
  show: `question = {"type": "essay", "instructions": "Describe this cheese."}`

### tut-04.6 A noul needs no criteria

A question of yes or no may leave out what yes and no mean. The test makes a `Noul` with no criteria, and checks that
its criteria are `None`.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the new test makes a `Noul` with an instruction alone.
:::

$ just test -k noul_needs

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: a noul without criteria.
  show: `assert Noul(type="noul", instructions="Is it blue?").criteria is None`

### tut-04.7 A choice without options is refused

A choice needs at least one option. The test gives a `Choice` empty criteria, and expects a refusal.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the new test makes a `Choice` with `criteria={}`.
:::

$ just test -k choice_without

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: a choice of nothing.
  show: `def test_choice_without_options_is_rejected():`

### tut-04.8 A choice has at most MAX_OPTIONS options

`MAX_OPTIONS` is 255. The test makes a choice of exactly 255 options, which is valid, and one of 256, which is
refused. A limit is tested on both of its sides.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file, and `MAX_OPTIONS` to the import from `babykev.api`.
:::

::: watch
At the end of `tests/unit/test_api.py`, the new test makes `at_limit`, 255 options, and then adds `one_more`.
:::

$ just test -k largest

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: the limit, from both sides.
  show: `at_limit = {f"option{i}": None for i in range(MAX_OPTIONS)}`

### tut-04.9 A score of one level is refused

A scale needs two levels at least, or it measures nothing. The test gives a `Score` one level, and expects a refusal.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the new test makes a `Score` with the one level `Soft`.
:::

$ just test

`just test` prints `22 passed`. `api.py` is still at 77%. The tests of validation run lines that the sample data ran
already.

files:
- diff `tests/unit/test_api.py`: a scale of one level.
  show: `Score(type="score", instructions="How firm?", criteria=["Soft"])`

### tut-04.10 The README names the tests of the contract

The row of `tests/unit/` names only the tests of the command. It now names the tests of the contract too.

patch$ README.md

::: do
The patch changes the row of `tests/unit/`.
:::

::: watch
In the table of `README.md`, the row of `tests/unit/` names the tests of the contract and the sample data.
:::

$ grep -n 'tests/unit' README.md

`grep` prints the new row.

files:
- diff `README.md`: the row of the tests.
  show: ``| `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |``

## tut-05 From a request to the model, and back

$ just setup

The contract also maps a request to what the model reads, and the model's probabilities back to answers. `render`
turns JSON into text, `option_text` writes an option, `to_record` turns a request into a record, and `to_answers`
turns probabilities into answers. Each test checks one of their rules.

### tut-05.1 render turns JSON into text

The model reads text, and the state of a request is JSON. `render` writes JSON as text. One test gives `render` nine
values, from `None` to a list of objects, and checks the text of each.

patch$ tests/unit/test_api.py

::: do
The patch adds the section `# Rendering` and its test at the end of the file, and `render` to the import.
:::

::: watch
At the end of `tests/unit/test_api.py`, the parametrized test lists nine pairs, each a value and its text.
:::

$ just test -k render

pytest prints `9 passed`, one for each value.

files:
- diff `tests/unit/test_api.py`: nine values, and their text.
  show: `def test_render_flattens_json_into_text(value, text):`

### tut-05.2 An option has a description only when it has one

An option is its name, followed by its description when it has one. `option_text` writes it. The test gives it no
description, an empty one, and a real one.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file, and `option_text` to the import.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test gives `option_text` three cases.
:::

$ just test -k option_text

pytest prints `3 passed`.

files:
- diff `tests/unit/test_api.py`: three cases of an option.
  show: `def test_option_text_adds_a_description_only_when_there_is_one(name, description, text):`

### tut-05.3 A record keeps the state and the order of questions

`to_record` turns a request into a record, the text and options that the model reads, and the metadata that maps
them back. The test checks that the state is rendered once, and that the questions keep their order.

patch$ tests/unit/test_api.py

::: do
The patch adds the section `# From a request to a record` and its test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test reads `record["state"]` and the order of the questions.
:::

$ just test -k keeps_the_state

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: the state, and the order.
  show: `assert [m["id"] for m in meta] == ["blue", "milk", "firmness"]`

### tut-05.4 A noul becomes no, then yes

A noul has two options, `no` first and `yes` second. The code counts the options from 0, so `yes` is option 1. The
answer to a noul is the probability of option 1.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test checks the options `["no", "yes"]`.
:::

$ just test -k no_then_yes

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: the two options of a noul.
  show: `assert record["questions"][0]["options"] == ["no", "yes"]`

### tut-05.5 The criteria of a noul describe no and yes

A noul can say what yes and no mean, under `true` and `false`. They become the descriptions of the two options.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test expects `"no: It has none"` and `"yes: It has blue veins"`.
:::

$ just test -k describe_no

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: the descriptions of no and yes.
  show: `def test_noul_criteria_describe_no_and_yes():`

### tut-05.6 A choice becomes one option per criterion

A choice has one option for each criterion, in order, and the metadata keeps their names.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test expects four options, the last with its description.
:::

$ just test -k one_option_per_criterion

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: the options of a choice.
  show: `def test_choice_becomes_one_option_per_criterion_in_order():`

### tut-05.7 A score becomes one option per level

A score has one option for each level, in order. Its legend maps the number of each level to its name.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test checks the options and the legend of `firmness`.
:::

$ just test -k one_option_per_level

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: the levels, and the legend.
  show: `def test_score_becomes_one_option_per_level_with_a_legend():`

### tut-05.8 The answer of a noul is the probability of yes

`to_answers` turns the probabilities of the model into answers. The answer to a noul is one number, the probability of
yes.

patch$ tests/unit/test_api.py

::: do
The patch adds the section `# From probabilities to answers` and its test at the end of the file, and `to_answers` to
the import.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test gives `to_answers` the probabilities `[0.25, 0.75]`, and expects
`0.75`.
:::

$ just test

`just test` prints `40 passed`, and `api.py` is at 86%.

files:
- diff `tests/unit/test_api.py`: the answer of a noul.
  show: `assert answers == {"blue": {"type": "noul", "noul": 0.75}}`

### tut-05.9 A choice names the most likely option

The answer to a choice has its most likely option, a probability for each option, and a confidence.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test gives `[0.1, 0.7, 0.2]`, and expects `goat`.
:::

$ just test

`just test` prints `41 passed`, and `api.py` is at 94%.

files:
- diff `tests/unit/test_api.py`: the answer of a choice.
  show: `assert answer["choice"] == "goat"`

### tut-05.10 A score answers with the expected level

The answer to a score is the expected level, the mean of the levels weighted by their probabilities. For
`[0.1, 0.2, 0.7]` it is 0 × 0.1 + 1 × 0.2 + 2 × 0.7 = 1.6.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test expects the score `1.6`.
:::

$ just test

`just test` prints `42 passed`, and `api.py` is at 100%.

files:
- diff `tests/unit/test_api.py`: the answer of a score.
  show: `assert answer["score"] == pytest.approx(1.6)`

### tut-05.11 Every question gets an answer of its own type

A request of three questions must get three answers, each under the id of its question, each of its type. The test
runs `to_record` and `to_answers` one after the other.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test checks the type of the answer to each of the three questions.
:::

$ just test

`just test` prints `43 passed`, and every line of `api.py` runs, 100%. Two lines are still wrong, and the next part
shows them. Coverage says which lines ran. It does not say that a test checked what each line does.

files:
- diff `tests/unit/test_api.py`: one answer for each question.
  show: `def test_every_question_gets_an_answer_of_its_own_type():`

## tut-06 Kev's two bugs

$ just setup

Every line of the contract runs in a test, and two of them are wrong. A test of rounding finds the first. The tests of
confidence find the second. Each test fails, and the move after it fixes the code.

### tut-06.1 A test of rounding, which fails

The probabilities of an answer must sum to 1. The test makes a choice of 77 options with the same probability, 1/77
each. `pytest.approx(1, abs=0.02)` accepts any number from 0.98 to 1.02. The test fails on purpose, because it finds
a bug of kev.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the new test sums the probabilities of 77 equal options.
:::

$ just test -k sum_to_one

pytest prints `F` for the failed test, and `assert 0.77 == 1 ± 0.02`. It ends with `1 failed, 43 deselected`, and exit
code 1.

$ sed -n '89,90p' src/babykev/api.py

Lines 89 and 90 are `r2`, which rounds to two decimals. 1/77 is about 0.013, and `r2` makes it 0.01. 77 times 0.01 is
0.77. The test is right, and the code is wrong.

files:
- diff `tests/unit/test_api.py`: the sum of the rounded probabilities.
  show: `    assert sum(answer["probabilities"].values()) == pytest.approx(1, abs=0.02)`

### tut-06.2 Probabilities rounded to four decimals

Two decimals lose too much, and 77 equal options sum to 0.77. `round_prob` takes the place of `r2`, and rounds to four
decimals. Each 1/77 becomes 0.013, and the 77 probabilities sum to 1.001, within 0.02 of 1.

patch$ src/babykev/api.py

::: do
The patch puts `round_prob` in place of the function `r2`. In `to_answers`, each `r2(` becomes `round_prob(`, six
times on four lines.
:::

::: watch
In `src/babykev/api.py`, `round_prob` stands where `r2` was, and `to_answers` calls it.
:::

$ just test -k sum_to_one
$ just test

`just test -k sum_to_one` prints `1 passed`. The test did not change, and the code did. `just test` prints `44 passed`.

files:
- diff `src/babykev/api.py`: four decimals.
  show: `    return round(float(x), 4)`

### tut-06.3 A guess between options has confidence 0

Confidence runs from 1, when the model is sure, to 0, when it knows nothing. A choice that gives every option the same
probability is a guess.

patch$ tests/unit/test_api.py

::: do
The patch adds the section `# Confidence` and its test at the end of the file, and `choice_confidence` to the import.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test gives `choice_confidence` four equal probabilities.
:::

$ just test -k confidence

pytest prints `1 passed`.

files:
- diff `tests/unit/test_api.py`: a guess between four options.
  show: `assert choice_confidence([0.25] * 4) == pytest.approx(0)`

### tut-06.4 A certain choice has confidence 1

All the probability on one option is certainty, with three options or with one.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test checks `[0, 1, 0]` and `[1.0]`.
:::

$ just test -k confidence

pytest prints `2 passed`.

files:
- diff `tests/unit/test_api.py`: certainty.
  show: `assert choice_confidence([0, 1, 0]) == pytest.approx(1)`

### tut-06.5 The confidence of a choice grows with its winner

Between a guess and certainty, confidence follows the probability of the most likely option. `[0.5, 0.25, 0.25]` gets
0.25.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test expects 0.25 for `[0.5, 0.25, 0.25]`.
:::

$ just test -k confidence

pytest prints `3 passed`.

files:
- diff `tests/unit/test_api.py`: a confidence between 0 and 1.
  show: `assert choice_confidence([0.5, 0.25, 0.25]) == pytest.approx(0.25)`

### tut-06.6 A certain score has confidence 1

A score has its own confidence, which measures how close the probabilities sit to the most likely level. All the
probability on one level is certainty, wherever the level is. The test runs for each of three levels.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file, and `score_confidence` to the import.
:::

::: watch
At the end of `tests/unit/test_api.py`, the parametrized test puts 1.0 on level 0, 1 and 2 in turn.
:::

$ just test -k confidence

pytest prints `6 passed`.

files:
- diff `tests/unit/test_api.py`: certainty, on each level.
  show: `def test_score_confidence_is_one_when_certain(level):`

### tut-06.7 A score prefers neighbouring levels

Doubt between two neighbouring levels is closer to certain than doubt between the two ends of the scale.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test compares `[0.5, 0.5, 0, 0]` with `[0.5, 0, 0, 0.5]`.
:::

$ just test -k confidence

pytest prints `7 passed`.

files:
- diff `tests/unit/test_api.py`: near is better than far.
  show: `assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])`

### tut-06.8 A guess between levels has confidence 0, and the test fails

A score that gives every level the same probability is a guess, as it is for a choice, and its confidence must be 0.
The test fails on purpose, because it finds the second bug of kev.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the test gives `score_confidence` three equal probabilities.
:::

$ just test -k confidence

pytest prints `1 failed, 7 passed`. The test that failed is `test_score_confidence_is_zero_for_a_guess`, with
`assert 0.5 == 0 ± 1.0e-12`. A guess over three levels has confidence 0.5. So the score says it is half sure when it
knows nothing.

$ sed -n '82,86p' src/babykev/api.py

Lines 82 to 86 are `score_confidence`. `mode` is the most likely level. The sum is the spread around `mode`, the
expected distance of a level from `mode`. The code divides it by `L - 1`, the length of the scale.

For the guess, all levels are equally likely, and `max` takes the first, level 0, as `mode`. The levels are 0, 1 and 2
places from it, so the spread is 1/3 × 0 + 1/3 × 1 + 1/3 × 2 = 1 place. The length is 2 places, so the confidence is
1 − 1/2 = 0.5.

files:
- diff `tests/unit/test_api.py`: a guess between three levels.
  show: `assert score_confidence([1 / 3] * 3) == pytest.approx(0)`

### tut-06.9 The confidence of a score measures against a guess

A guess gets confidence 0.5, because the code measures the spread against the length of the scale. The fix measures it
against the spread of a guess around the middle level.

patch$ src/babykev/api.py

::: do
The patch writes `score_confidence` again, in place of the old one. Read its docstring first.
:::

::: watch
In `src/babykev/api.py`, `score_confidence` now computes `spread` and `guess`, and divides one by the other.
:::

`guess` is the spread of a guess around the middle level. For three levels, the middle is level 1, and the levels are
1, 0 and 1 places from it. So `guess` is 1/3 × 1 + 1/3 × 0 + 1/3 × 1 = 2/3 of a place. For the guess itself, `spread`
around `mode` is 1 place, as before. So 1 − 1 ÷ (2/3) = 1 − 1.5 = −0.5, and `max(0.0, ...)` counts a value below 0 as
0. A guess has confidence 0.

$ uv run python -c "from babykev.api import score_confidence as s; print([round(s(p), 2) for p in ([1/3]*3, [0.5, 0.25, 0.25], [0.6, 0.3, 0.1], [0.8, 0.1, 0.1])])"

The command prints the confidences of the guess and of three answers, `[0.0, 0.0, 0.25, 0.55]`. `[0.5, 0.25, 0.25]`
is as spread out as a guess, and also gets 0.

$ just test

`just test` prints `52 passed`, and `api.py` is at 99%. `Missing` gives line 90, `return 1.0`. The new function
divides by `guess`, which is 0 for a scale of one level, so line 90 answers 1 before the division. A request cannot
hold a scale of one level, so no test reaches it.

files:
- diff `src/babykev/api.py`: the spread of a guess, as the measure.
  show: `    guess = sum(abs(i - (L - 1) / 2) for i in range(L)) / L`

### tut-06.10 A test of a scale with one level

Line 90 runs in no test. A scale of one level leaves nothing to doubt, so its confidence is 1, and a test that calls
`score_confidence` itself can say so.

patch$ tests/unit/test_api.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
At the end of `tests/unit/test_api.py`, the new test calls `score_confidence([1.0])`.
:::

$ just test

`just test` prints `53 passed`, and the total is 100%, 79 of 79 statements.

files:
- diff `tests/unit/test_api.py`: the test calls the function itself.
  show: `    assert score_confidence([1.0]) == 1.0`

## tut-07 Format

$ just setup

`just setup` prints `Resolved 14 packages`.

kev wrote `api.py` in a style of his own. Some lines hold an `if` and its `return` together, and some lines run past
200 characters. The tests check what the code does, and nothing checks how it looks. A formatter writes every file
in one style, so that a later change shows only what changed, and no fight over spaces and line breaks. ruff comes
first into the project, then its settings and a recipe. Then the check fails on `api.py`, and the formatter
rewrites the file.

### tut-07.1 Ruff, in the group lint

Nothing formats the code yet. ruff is a formatter and a linter in one program. The formatter changes how the code
looks, and never what it does. The linter comes in the next part of the tutorial. ruff is for working on babykev,
and a user of the package does not need it. So it goes in a second dependency group, `lint`, next to the group
`test`.

do$ uv add --group lint ruff

`uv add` prints `Resolved 15 packages`, and installs ruff. ruff is one program, and needs no other
package.

::: do
If a newer ruff is out, `uv add` writes its version as the lower bound. That line then differs from the one here,
and so does `uv.lock`. Only the versions differ.
:::

::: watch
In `pyproject.toml`, the new group `lint` is on lines 26 to 28, above the group `test`, with the line
`"ruff>=0.17.1",`. `uv.lock` has ruff 0.17.1.
:::

$ uv run ruff --version
$ uv run ruff format --check

`uv run ruff --version` prints the version of ruff that uv installed. `ruff format --check` changes nothing. It prints what it would
change in each file, and ends with `3 files would be reformatted, 3 files already formatted`, and exit code 1. The
three files are `src/babykev/api.py`, `src/babykev/cli.py` and `tests/unit/test_api.py`. By default, ruff lets a
line run to 88 characters. Line 19 of `cli.py` has 94 characters, so ruff would split it.

files:
- diff `pyproject.toml`: the group `lint`, with ruff.
  show: `"ruff>=0.17.1",`
- diff `uv.lock`: ruff, at its exact version.

### tut-07.2 Lines of up to 100 characters

At 88 characters, the formatter would split lines of `cli.py` and of the tests that read well as they are. The
setting `line-length` in the table `[tool.ruff]` lets a line run to 100 characters. The formatter and the linter
both read the table.

patch$ pyproject.toml

::: do
The patch adds the table `[tool.ruff]` at the end of `pyproject.toml`, with a comment and `line-length = 100`.
:::

::: watch
At the end of `pyproject.toml`, the new table `[tool.ruff]` is on lines 39 to 41, with `line-length = 100`.
:::

$ uv run ruff format --check

The check now ends with `1 file would be reformatted, 5 files already formatted`, and exit code 1. `cli.py` and the
tests have no line over 100 characters, so they pass, and `api.py` still fails. ruff prints each change it would
make, with the old lines marked `-` and the new ones `+`. The one-line `if` of `_check`, at line 27, becomes two
lines, and so do the three of `render`, at lines 48 to 50. The long dictionaries of `to_record` and `to_answers`
are split, one key on each line.

files:
- diff `pyproject.toml`: the table `[tool.ruff]`.
  show: `line-length = 100`

### tut-07.3 The settings of the formatter, written out

The formatter has almost no options, and its defaults are its style. A reader of `pyproject.toml` cannot see them.
The table `[tool.ruff.format]` writes out five of them, each with a comment. They are the defaults, so the output of
the formatter does not change.

patch$ pyproject.toml

::: do
The patch adds the table `[tool.ruff.format]` at the end of `pyproject.toml`. Read the comment beside each setting.
:::

::: watch
At the end of `pyproject.toml`, the new table `[tool.ruff.format]` is on lines 43 to 49. It sets double quotes, four
spaces, and three more defaults, each with a comment.
:::

`skip-magic-trailing-comma = false` is the one that a reader meets most. A list that ends with a comma keeps one item
on each line, even when it would fit on one line. The group `lint`, on lines 26 to 28, is such a list.

$ uv run ruff format --check

The check prints the same as before, `1 file would be reformatted, 5 files already formatted`. The settings are the
defaults, so nothing changes.

files:
- diff `pyproject.toml`: the five settings of the formatter.
  show: `quote-style = "double"            # "text", not 'text'`

### tut-07.4 The recipe fmt, and the check fails

The command that formats the code is `uv run ruff format`, and every task of the project has a recipe. The recipe
`fmt` runs it, and gives it every word after `fmt`. The check fails, because `api.py` is not formatted yet. The
next part formats it.

patch$ justfile

::: do
The patch adds the recipe `fmt` above the recipe `test`, under the comment that explains it.
:::

::: watch
In `justfile`, the recipe `fmt` is on lines 28 to 32, above `test`, in the group `quality`. It runs
`uv run ruff format "$@"`.
:::

$ uv run ruff format --check
$ just --show fmt
$ just fmt --check
$ just help fmt

`uv run ruff format --check` lists the changes to `api.py` and ends with exit code 1, as before. `just --show fmt`
prints the recipe. `just fmt --check` runs the same command, and prints the same,
`1 file would be reformatted, 5 files already formatted`. It ends with exit code 1, and `just` adds no message of
its own. `just help fmt` prints the line of the recipe.

files:
- diff `justfile`: the recipe `fmt`.
  show: `fmt *args:`

### tut-07.5 The code, formatted

`just fmt --check` found one file that does not follow the style, `api.py`. `just fmt` rewrites it.

do$ just fmt

`just fmt` prints `1 file reformatted, 5 files left unchanged`.

::: watch
`src/babykev/api.py` grows from 114 lines to 141. A blank line now comes after the docstring, on line 7. Each `if`
of `_check` and of `render` has its statement on a line of its own, on lines 28 to 29 and 50 to 55. The long lines
of `render`, `to_record` and `to_answers` are split, one part or one key on each line. They are now lines 56 to 61,
82 to 88, 126 to 131 and 134 to 140.
:::

$ just fmt --check
$ just test

`just fmt --check` prints `6 files already formatted`, and ends with exit code 0. `just test` prints `53 passed`, and
a total of 100%, of 83 statements. `api.py` has 75 of them. Coverage counts each line with a statement, and each of
the four one-line `if` statements of `_check` and `render` is now two lines.

::: watch
At tut-06, before `just fmt`, `just test` counted 79 statements, and 71 in `api.py`. The four new lines are the four
new statements.
:::

files:
- diff `src/babykev/api.py`: the same code, in the style of the formatter.
  show: `        if not 1 <= len(self.criteria) <= MAX_OPTIONS:`

## tut-08 Lint

$ just setup

`just setup` prints `Resolved 15 packages`.

The formatter changes how the code looks, and leaves a wrong line wrong. A linter reads the code against rules,
and reports what breaks them, from an import that nobody uses to a `zip` that drops items silently. ruff is the
linter too, and the families of rules come first. The linter finds 8 problems in `api.py`, and each rule then gets
a fix of its own. ruff makes the last fix itself.

### tut-08.1 The rules of the linter

ruff has more than 900 rules. The table `[tool.ruff.lint]` chooses which to check, with `select`. Each family of
rules has a prefix, such as `E` or `B`. The list has one family on each line, with a comment that says what it
finds.

patch$ pyproject.toml

::: do
The patch adds the table `[tool.ruff.lint]` at the end of `pyproject.toml`. Read the comment beside each family.
:::

::: watch
At the end of `pyproject.toml`, the new table `[tool.ruff.lint]` starts at line 51. `select = [` on line 53 lists
nine families of rules, from `E` to `N`.
:::

$ uv run ruff check --statistics

`ruff check` is the linter. `--statistics` prints one line for each code, with the number of problems. ruff finds 52
problems, and ends with exit code 1. 44 of them are `S101`, an `assert`. Python skips every `assert` when it runs with
`python -O`, so a check in the package must not rely on one. Each of the 44 is in the tests, where pytest checks
with `assert`. The other 8 are in `api.py`.

files:
- diff `pyproject.toml`: a family of rules on each line.
  show: `    "B",   # bugbear: code that is likely a bug, such as a zip that drops items silently`

### tut-08.2 The tests may use assert

The 44 `S101` hide the 8 problems of `api.py`. A test is written with `assert`, and the tests never run with
`python -O`. The table `[tool.ruff.lint.per-file-ignores]` lets the files under `tests/` break `S101`. The package
still may not use `assert`.

patch$ pyproject.toml

::: do
The patch adds the table `[tool.ruff.lint.per-file-ignores]` at the end of `pyproject.toml`.
:::

::: watch
At the end of `pyproject.toml`, the new table `[tool.ruff.lint.per-file-ignores]` is on lines 65 to 67. It names
`S101` for `"tests/**"`.
:::

$ uv run ruff check --statistics

ruff finds 8 problems, and ends with exit code 1. `N806`, `UP007` and `B905` come twice each, and `E501` and `I001`
once each. The last line says that `--fix` can fix one, and that 2 unsafe fixes are available.

files:
- diff `pyproject.toml`: the tests may use `assert`.
  show: `"tests/**" = ["S101"]`

### tut-08.3 The recipe lint

The command that runs the linter is `uv run ruff check`. The recipe `lint` runs it, and gives it every word after
`lint`, as `fmt` does.

patch$ justfile

::: do
The patch adds the recipe `lint` under the recipe `fmt`, above `test`.
:::

::: watch
In `justfile`, the recipe `lint` is on lines 34 to 38, between `fmt` and `test`. It runs `uv run ruff check "$@"`.
:::

$ just --show lint
$ just lint
$ just help lint

`just --show lint` prints the recipe. `just lint`, with no words, prints each problem with the lines around it, and
ends with `Found 8 errors.` and exit code 1. All 8 are in `src/babykev/api.py`. Each one starts with its code. Under
I001, UP007 and B905, a `help:` line says what would fix it.

- `E501` is line 5, of 103 characters, in the docstring. The formatter does not split the text of a docstring.
- `I001` is on line 8. The imports need a blank line between the standard library and pydantic. Its `[*]` says
  that ruff can fix it.
- `UP007` is on lines 11 and 39, `Union[...]`, where Python 3.10 and later write `X | Y`.
- `N806` is on lines 94 and 104, `K` and `L`, variables in capitals.
- `B905` is on lines 121 and 125, a `zip` with no `strict=`. ruff shows a fix, `strict=False`, with the note
  `This is an unsafe fix and may change runtime behavior`.

`uv run ruff rule CODE` explains any code, for example `uv run ruff rule B905`. `just help lint` prints the line of
the recipe. The next parts fix the problems one code at a time, by hand. ruff fixes the last two.

files:
- diff `justfile`: the recipe `lint`.
  show: `lint *args:`

### tut-08.4 The docstring of api.py fits in 100 characters

`E501`: line 5 of `api.py` has 103 characters. The docstring is a small table, with the three types of question in
lines 3 to 5, and `answer =` lined up in one column. Line 5 is the longest, and sets the column. "The levels, in
order" takes the place of "ordered level descriptions", and says the same in fewer characters. The three lines
line up again, at column 43.

patch$ src/babykev/api.py

::: do
The patch writes lines 3 to 5 of the docstring again. Only the words of line 5 change, and the spaces before
`answer =` on lines 3 and 4.
:::

::: watch
In `src/babykev/api.py`, lines 3 to 5 now have `answer =` at column 43. Line 5 has 97 characters.
:::

$ just lint --statistics
$ just fmt --check

`just lint --statistics` prints 7 problems, and no `E501`. `just fmt --check` prints `6 files already formatted`.
The formatter leaves the text of a docstring as it is.

files:
- diff `src/babykev/api.py`: the table of the docstring, in 97 characters.
  show: `Score  -> options = the levels, in order; answer = expected level, legend, probabilities by index`

### tut-08.5 X | Y in place of Union

`UP007`: since Python 3.10, `str | None` is a union of two types, and `Union[str, None]` is the old way to write it.
babykev needs Python 3.13. `JSONContent` on line 11 and `Question` on line 39 become `X | Y`. ruff has no fix for
these two lines, so a person writes them.

patch$ src/babykev/api.py

::: do
In `src/babykev/api.py`, the patch writes line 11 and line 39 again, with `|` between the types in place of
`Union[...]`.
:::

::: watch
In `src/babykev/api.py`, line 11 is now `JSONContent = str | dict | list | int | float | bool | None`, and line 39
is `Question = Noul | Choice | Score`.
:::

`Union` is no longer used, and its import on line 8 is now a problem of its own.

$ just lint --statistics
$ just test

`just lint --statistics` prints 6 problems. `UP007` is gone, and `F401`, `unused-import`, is new, with a `[*]`.
ruff can remove the import itself, and the last part of this section lets it. `just test` prints `53 passed`.
pydantic reads `X | Y` as it read `Union`.

files:
- diff `src/babykev/api.py`: two unions, written with `|`.
  show: `JSONContent = str | dict | list | int | float | bool | None`

### tut-08.6 K and n, in lower case

`N806`: a variable inside a function is in lower case, and a capital marks a constant, such as `MAX_OPTIONS`. `K` in
`choice_confidence` is the number of options, and becomes `k`. `L` in `score_confidence` is the number of levels.
`l` would break another rule, `E741`, because `l` looks like `1` and `I` in many fonts. So `L` becomes `n`.

patch$ src/babykev/api.py

::: do
In `choice_confidence`, the patch renames `K` to `k`, on lines 94 and 95. In `score_confidence`, it renames `L` to
`n`, on lines 104 to 109.
:::

::: watch
In `src/babykev/api.py`, `k = len(p)` is on line 94, and `n = len(p)` on line 104. Each use of the two names
changes with them.
:::

$ just lint --statistics
$ just test -k confidence

`just lint --statistics` prints 4 problems, and no `N806`. `just test -k confidence` runs the 9 tests of the two
functions, and prints `9 passed, 44 deselected`. A new name changes nothing that runs.

files:
- diff `src/babykev/api.py`: two names, in lower case.
  show: `    n = len(p)`

### tut-08.7 Zip with strict=True

`B905`: `zip` pairs the items of two lists, and stops at the end of the shorter one. The rest is dropped, and
nothing says so. `to_answers` pairs the probabilities with the questions on line 121, and the keys of a choice with
its probabilities on line 125. Each pair of lists must have the same length. A difference is a bug, and it should
stop the program.

ruff's own fix writes `strict=False`, which keeps the silent drop and says so. ruff calls it unsafe, and leaves the
choice to a person. `strict=True` makes `zip` raise a `ValueError` when the lengths differ.

patch$ src/babykev/api.py

::: do
In `to_answers`, the patch adds `strict=True` to each of the two calls of `zip`, on lines 121 and 125.
:::

::: watch
In `src/babykev/api.py`, line 121 is now `for p, m in zip(probs, meta, strict=True):`, and line 125 ends with
`zip(m["keys"], p, strict=True)}`.
:::

$ just lint --statistics
$ just test -k answer

`just lint --statistics` prints 2 problems, `I001` and `F401`, each with a `[*]`. `just test -k answer` runs the 4
tests of the answers, which call `to_answers`, and prints `4 passed, 49 deselected`. Their lists have the same
lengths, so nothing raises.

files:
- diff `src/babykev/api.py`: two calls of `zip`, with `strict=True`.
  show: `    for p, m in zip(probs, meta, strict=True):`

### tut-08.8 Just lint --fix sorts the imports

The last two problems are on lines 8 and 9 of `api.py`, in the imports, and ruff can fix both safely. `--fix` makes
only the fixes that ruff counts as safe.

do$ just lint --fix

`just lint --fix` prints `Found 2 errors (2 fixed, 0 remaining).`, and ends with exit code 0. It removed `Union`
from the import of `typing` (`F401`). It put a blank line between the standard library and pydantic, which is
installed (`I001`).

::: watch
At the top of `src/babykev/api.py`, line 8 is now `from typing import Any, Literal`, and a blank line comes before
`from pydantic import BaseModel, Field, model_validator`, on line 10.
:::

$ just lint
$ just fmt --check
$ just test

`just lint` prints `All checks passed!`. `just fmt --check` prints `6 files already formatted`, and `just test`
prints `53 passed`.

files:
- diff `src/babykev/api.py`: the imports, sorted.
  show: `from typing import Any, Literal`

## tut-09 Types in every signature

$ just setup

`just setup` prints `Resolved 15 packages`.

A reader of `def to_record(req: SystemOneRequest):` knows what the function takes, and not what it returns. A type
annotation says it, in the signature. Python does not check annotations when it runs, but a reader does, and a type
checker can, later. The family `ANN` of ruff asks for the type of every parameter and of every return value. A
person writes each type that ruff cannot guess, and ruff writes the rest.

### tut-09.1 The rule that every function has types

Nothing asks for types yet. The family `ANN` joins the list `select`, on a line of its own, with its comment.

patch$ pyproject.toml

::: do
The patch adds the line of `"ANN"` at the end of the list `select`, under the line of `"N"`.
:::

::: watch
In `pyproject.toml`, the line `"ANN", # annotations: every parameter and every return value has a type` is now line
63, the last of the list `select`.
:::

$ just lint --statistics

`just lint --statistics` prints 49 problems in four codes, and ends with exit code 1.

- `ANN201`, 33 times: a public function with no return type.
- `ANN001`, 14 times: a parameter with no type.
- `ANN202`, once: a private function with no return type. Its name starts with `_`.
- `ANN002`, once: `*args` with no type.

The last line says `31 unsafe fixes available with --fix --unsafe-fixes`. ruff can write 31 of the return types
itself, and the other 18 problems need a person. The person goes first, so that ruff's fix comes last and leaves
nothing.

files:
- diff `pyproject.toml`: the family `ANN`.
  show: `    "ANN", # annotations: every parameter and every return value has a type`

### tut-09.2 _check returns Self

`ANN202`: `_check` is the validator of `Choice`, and returns the choice itself, `self`. `Self`, from `typing`, is
the type of the class that the method belongs to.

patch$ src/babykev/api.py

::: do
In `src/babykev/api.py`, the patch adds `Self` to the import of `typing` on line 8, and `-> Self` to the line of
`def _check(self)`.
:::

::: watch
In `src/babykev/api.py`, line 8 imports `Self` from `typing`, and line 28 is now `def _check(self) -> Self:`.
:::

$ just lint --statistics
$ just test -k choice

`just lint --statistics` prints 48 problems, and no `ANN202`. `just test -k choice` runs the 7 tests with `choice` in
their name, and prints `7 passed, 46 deselected`. Two of them check the limits that `_check` sets on the options.

files:
- diff `src/babykev/api.py`: the return type of `_check`.
  show: `    def _check(self) -> Self:`

### tut-09.3 The two return types that ruff cannot guess

`ANN201`: of the 33 public functions with no return type, ruff can guess 31. Each of them returns nothing, and its
type is `None`. The other two return something, and a person names the type. `to_record` in `api.py` returns two
things, the record and the metadata of its questions. The record is a dictionary, and the metadata is a list of
dictionaries. `cheese_request` in the tests returns a `SystemOneRequest`.

patch$ src/babykev/api.py

patch$ tests/unit/test_api.py

::: do
In `src/babykev/api.py`, the patch adds the return type at the end of the line `def to_record(...)`. In
`tests/unit/test_api.py`, it adds `-> SystemOneRequest` to the line `def cheese_request()`.
:::

::: watch
In `src/babykev/api.py`, line 69 now ends with `-> tuple[dict[str, Any], list[dict[str, Any]]]:`. In
`tests/unit/test_api.py`, line 30 is now `def cheese_request() -> SystemOneRequest:`.
:::

$ just lint --statistics

`just lint --statistics` prints 46 problems. 31 are `ANN201`, and ruff can fix each of them.

files:
- diff `src/babykev/api.py`: the return type of `to_record`.
  show: `def to_record(req: SystemOneRequest) -> tuple[dict[str, Any], list[dict[str, Any]]]:`
- diff `tests/unit/test_api.py`: the return type of `cheese_request`.
  show: `def cheese_request() -> SystemOneRequest:`

### tut-09.4 The types of the fixtures of pytest

`ANN001`: 14 parameters have no type. Five of them are the fixtures of pytest in `test_cli.py`, which pytest passes
in by their names. `monkeypatch` is a `pytest.MonkeyPatch`, and `capsys` is a `pytest.CaptureFixture[str]`, which
catches text. With the types, the two signatures of the tests pass 100 characters, so each is split over three
lines, as the formatter splits it.

patch$ tests/unit/test_cli.py

::: do
In `tests/unit/test_cli.py`, the patch gives `monkeypatch` its type in `run`, and `monkeypatch` and `capsys` their
types in the two tests. Each signature of a test now has its parameters on a line of their own.
:::

::: watch
In `tests/unit/test_cli.py`, line 8 is now `def run(monkeypatch: pytest.MonkeyPatch, *words):`. The parameters of the two
tests are on lines 16 and 24, each between the line of the name and the line `):`.
:::

The fixtures are what the tests of the command are made of, so we read them again with their types.

$ sed -n '8,30p' tests/unit/test_cli.py
$ just test -k unknown_command

`sed` prints `run` and the two tests. `run` uses `monkeypatch.setattr` to put the words in `sys.argv`, and calls
`main`. Each test reads what `main` printed through `capsys.readouterr()`, `.out` for the help and `.err` for the
message of an unknown command. `just test -k unknown_command` prints `1 passed, 52 deselected`. The test of an unknown
command passes with the types, as it did without them.

files:
- diff `tests/unit/test_cli.py`: the types of the fixtures.
  show: `    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]`

### tut-09.5 The types of the parameters of the tests

The other nine parameters with no type get their values from `@pytest.mark.parametrize`. Each gets the type of the
values in its list.

- `words` in `test_cli.py` is a tuple of strings, `tuple[str, ...]`.
- `line` in `test_api.py` is a line of the sample data, a `dict[str, Any]`, so the file imports `Any` from `typing`.
- `value` and `description` are what `render` and `option_text` take, a `JSONContent`, so the file imports it from
  `babykev.api`.
- `text` and `name` are strings, and `level` is an `int`.

patch$ tests/unit/test_api.py

patch$ tests/unit/test_cli.py

::: do
In `tests/unit/test_api.py`, the patch adds `from typing import Any` under `from pathlib import Path`, and
`JSONContent` to the import from `babykev.api`. Then it gives a type to the parameters of five tests. In
`tests/unit/test_cli.py`, it gives `words` its type, on line 16.
:::

::: watch
In `tests/unit/test_api.py`, `from typing import Any` is on line 5, and `JSONContent` on line 13. The five tests with
parameters now give their types, for example `def test_score_confidence_is_one_when_certain(level: int):` on line
283. The signature of `test_option_text_adds_a_description_only_when_there_is_one` is split over lines 156 to 158.
In `tests/unit/test_cli.py`, line 16 ends with `words: tuple[str, ...]`.
:::

$ just lint --statistics
$ just test

`just lint --statistics` prints 32 problems, 31 `ANN201` and one `ANN002`. `just test` prints `53 passed`.

files:
- diff `tests/unit/test_api.py`: the types of the parameters, and two imports.
  show: `def test_render_flattens_json_into_text(value: JSONContent, text: str):`
- diff `tests/unit/test_cli.py`: the type of `words`.
  show: `    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], words: tuple[str, ...]`

### tut-09.6 The words of run are strings

`ANN002`: `*words` in `run` gathers any number of words into a tuple. Its annotation is the type of each word, `str`,
and not of the tuple.

patch$ tests/unit/test_cli.py

::: do
In `tests/unit/test_cli.py`, the patch adds `: str` after `*words`, on line 8.
:::

::: watch
In `tests/unit/test_cli.py`, line 8 is now `def run(monkeypatch: pytest.MonkeyPatch, *words: str):`.
:::

$ just lint --statistics
$ just lint --statistics --unsafe-fixes

`just lint --statistics` prints 31 problems, all `ANN201`. With `--unsafe-fixes`, it marks each of them `[*]`, and
says `31 fixable with --fix`. Neither command changes a file.

files:
- diff `tests/unit/test_cli.py`: the type of `*words`.
  show: `def run(monkeypatch: pytest.MonkeyPatch, *words: str):`

### tut-09.7 Just lint --fix --unsafe-fixes writes -> None

The last 31 problems are functions of the tests with no `return`, which return `None`. ruff can add `-> None` to
each of them. ruff marks this fix as unsafe, so `--fix` alone does not make it, and `--unsafe-fixes` lets it.

do$ just lint --fix --unsafe-fixes

`just lint --fix --unsafe-fixes` prints `Found 31 errors (31 fixed, 0 remaining).`, and ends with exit code 0.

::: watch
In `tests/unit/test_api.py`, 28 signatures now end with `-> None:`, for example
`def test_sample_line_fits_the_contract(line: dict[str, Any]) -> None:` on line 50. In `tests/unit/test_cli.py`,
`run` and the two tests end with `-> None:`, on lines 8, 17 and 25.
:::

$ just lint
$ just fmt --check
$ just test

`just lint` prints `All checks passed!`. `just fmt --check` prints `6 files already formatted`. No line passed 100
characters with `-> None`. `just test` prints `53 passed`.

files:
- diff `tests/unit/test_api.py`: `-> None` on 28 functions.
  show: `def test_sample_line_fits_the_contract(line: dict[str, Any]) -> None:`
- diff `tests/unit/test_cli.py`: `-> None` on `run` and the two tests.
  show: `def run(monkeypatch: pytest.MonkeyPatch, *words: str) -> None:`

## tut-10 Docstrings

$ just setup

`just setup` prints `Resolved 15 packages`.

A docstring says what a module, a class or a function is for. Python keeps it in `__doc__`, and `help()` and the
editor show it. kev gave a docstring to some functions of `api.py`, and to none of its classes. The rules `D1` of
ruff ask for a docstring on every public module, class and function. ruff cannot write one, so each comes by hand,
one kind at a time.

### tut-10.1 The rule that every public name has a docstring

Nothing asks for docstrings yet. The rules `D1` of the family `D`, pydocstyle, join the list `select`. `D1` is the
part of the family that asks whether a docstring is there. The rest of the family checks how a docstring is written,
and stays off.

patch$ pyproject.toml

::: do
The patch adds the line of `"D1"` at the end of the list `select`, under the line of `"ANN"`.
:::

::: watch
In `pyproject.toml`, the line of `"D1"` is now line 64, the last of the list `select`.
:::

$ just lint --output-format concise

`--output-format concise` prints each problem on one line, with its file, line and column. `just lint` finds 8
problems, and ends with exit code 1. `D104` is the package, `src/babykev/__init__.py`, which is empty. `D101` is
four classes of `api.py`, on lines 16, 22, 34 and 43. `D103` is three functions, on lines 65, 94 and 120. `_check`
is private, so it needs none.

files:
- diff `pyproject.toml`: the rules `D1`.
  show: `    "D1",  # pydocstyle: every public module, class and function has a docstring`

### tut-10.2 The docstring of the package

`D104`: `src/babykev/__init__.py` is the package `babykev` itself, and it is empty. Its docstring says what babykev
is, as the first line of the help of the command does.

patch$ src/babykev/__init__.py

::: do
The patch writes the one line of the file, a docstring.
:::

::: watch
`src/babykev/__init__.py` now has one line, the docstring of the package.
:::

$ uv run python -c "import babykev; print(babykev.__doc__)"
$ just test

`uv run python -c` prints the docstring, `babykev: a small decision model. A state, typed questions, and a probability
for every answer.` `just test` prints `53 passed`. `__init__.py` still has 0 statements, because coverage does not
count a docstring.

files:
- file `src/babykev/__init__.py`: the docstring of the package.
  show: `"""babykev: a small decision model. A state, typed questions, and a probability for every answer."""`

### tut-10.3 The docstrings of the four classes of a request

`D101`: `Noul`, `Choice`, `Score` and `SystemOneRequest` are the classes of a request, and none has a docstring.
Each gets one line, under its `class` line, that says what it is.

patch$ src/babykev/api.py

::: do
In `src/babykev/api.py`, the patch adds a docstring and a blank line under each of the four lines `class ...`.
:::

::: watch
In `src/babykev/api.py`, the docstrings of the classes are on lines 17, 25, 39 and 50, under the lines of `Noul`,
`Choice`, `Score` and `SystemOneRequest`.
:::

$ uv run python -c "from babykev.api import Score; print(Score.__doc__)"
$ just lint --statistics

`uv run python -c` prints the docstring of `Score`, `A question answered by a level of a scale, whose criteria are
the levels in order.` `just lint --statistics` prints 3 problems, all `D103`.

files:
- diff `src/babykev/api.py`: a docstring on each class of a request.
  show: `    """A question answered by a level of a scale, whose criteria are the levels in order."""`

### tut-10.4 The docstrings of three functions

`D103`: `option_text`, `choice_confidence` and `to_answers` have no docstring. Each gets one line, under its `def`
line, that says what it does. The docstring of `choice_confidence` gives the two ends of its scale, as the docstring
of `score_confidence` does.

patch$ src/babykev/api.py

::: do
In `src/babykev/api.py`, the patch adds a docstring under each of the three lines `def ...`.
:::

::: watch
In `src/babykev/api.py`, the docstrings of the functions are on lines 74, 104 and 131, under the lines of
`option_text`, `choice_confidence` and `to_answers`.
:::

$ uv run python -c "from babykev.api import choice_confidence; print(choice_confidence.__doc__)"
$ just lint
$ just fmt --check
$ just test

`uv run python -c` prints `Measure how far the most likely option stands above a guess: 1 if certain, 0 for a
guess.` `just lint` prints `All checks passed!`, and `just fmt --check` prints `6 files already formatted`. `just
test` prints `53 passed`, and the total is 100%, 83 of 83 statements.

files:
- diff `src/babykev/api.py`: a docstring on each of the three functions.
  show: `    """Measure how far the most likely option stands above a guess: 1 if certain, 0 for a guess."""`

## tut-11 The gate and the hook

$ just setup

`just setup` prints `Resolved 15 packages`.

The project has three checks, `just fmt --check`, `just lint` and `just test`. A person must remember to run each
of them before each `git commit`. One recipe, `check`, runs them all, in order. git then runs that recipe itself
before each `git commit`, through a hook that pre-commit installs. A check that git runs before it records a change
is a gate, and a change that fails it does not go in.

Three more hooks keep out a large file, the markers of a merge conflict and a `.env` file. Last, a mistake on purpose
shows the gate at work.

### tut-11.1 The recipe check

The three checks are three commands, and a person can forget one. The recipe `check` runs them one after another.
`set -e` stops it at the first that fails, so the last line that it prints names the check that failed.

patch$ justfile

::: do
The patch adds the recipe `check` at the end of the `justfile`, under the recipe `test`.
:::

::: watch
At the end of the `justfile`, the recipe `check` is on lines 46 to 55, in the group `quality`. Its body is a script
of `sh`. `set -e` is on line 51, and the three checks are on lines 53 to 55.
:::

`just check` has no floor on the coverage yet, such as `--cov-fail-under=90`. Later, the model comes in with no tests
of its own, and the coverage then falls under 90%. The floor joins the gate after the tests of the model.

The commands behind the recipe come first.

$ just fmt --check
$ just lint
$ just test -q

`just fmt --check` prints `6 files already formatted`, and `just lint` prints `All checks passed!`. `just test -q`
prints a dot for each test, the table of coverage, and `53 passed`. The total is 100%, 83 of 83 statements.

$ just --show check
$ just check
$ just help check

`just --show check` prints the recipe. `just check` prints the same lines as the three commands, one after another,
and ends with exit code 0. `just help check` prints the line of the recipe.

files:
- diff `justfile`: the recipe `check`, with three checks.
  show: `    just test -q`

### tut-11.2 Pre-commit, in the group lint

`just check` still waits for a person to run it. git can run a program of its own before it records a change, a
hook. If the program fails, `git commit` records nothing. pre-commit installs such a hook, and runs the checks that a
file of settings names. It is for working on babykev, so it goes in the group `lint`.

do$ uv add --group lint pre-commit

`uv add` prints `Resolved 25 packages`, and installs pre-commit and the 9 packages that it needs, such as
`pyyaml` and `virtualenv`.

::: watch
In `pyproject.toml`, the group `lint` now starts with `"pre-commit>=4.7.0",`, on line 27, above ruff. uv sorts the
names of a group. `uv.lock` has the exact version of pre-commit, and of the packages that it needs.
:::

$ uv run pre-commit --version

It prints the version of pre-commit that uv installed. No hook is installed yet.

files:
- diff `pyproject.toml`: pre-commit, in the group `lint`.
  show: `"pre-commit>=4.7.0",`
- diff `uv.lock`: the exact version of pre-commit, and of the packages that it needs.

### tut-11.3 A hook that runs just check

pre-commit reads its hooks from a file, `.pre-commit-config.yaml`. The first hook is local, which means that it is
a command of the project itself, `just check`. So the hook and the terminal run the same checks. The file is new,
and comes whole, as a patch.

patch$ .pre-commit-config.yaml

::: do
Read the hook under `repo: local`, and the comment at the top of the file.
:::

::: watch
The new file `.pre-commit-config.yaml` has 14 lines. The hook is on lines 9 to 14. `entry: just check`, on line 11,
is the command. `pass_filenames: false` gives `just check` no file names, and `always_run: true` runs it for any
change, whatever its files.
:::

With this hook, `just check` is the gate. The hook is not installed yet, and pre-commit can still run every hook
by hand.

$ uv run pre-commit run --all-files

`pre-commit run --all-files` runs every hook on every file that git tracks, as `git commit` would. It prints one
line for the hook, `just check....Passed`. A hook that passes prints nothing more.

files:
- file `.pre-commit-config.yaml`: one hook, which runs `just check`.
  show: `        entry: just check`

### tut-11.4 The recipe hook

`pre-commit install` writes the hook into the folder of the hooks of the clone, `.git/hooks`. git does not track
that folder, so each clone installs its own hook, once. The recipe `hook` runs the command. It is a recipe of its own,
because `just setup` runs often, and never touches git.

patch$ justfile

::: do
The patch adds the recipe `hook` under the recipe `setup`, in the group `setup`.
:::

::: watch
In the `justfile`, the recipe `hook` is on lines 28 to 31, under `setup`. It runs `uv run pre-commit install`.
:::

$ uv run pre-commit install
$ just --show hook
$ just hook
$ ls "$(git rev-parse --git-path hooks)"

`uv run pre-commit install` prints `pre-commit installed at .git/hooks/pre-commit`. `just --show hook` prints the
recipe, and `just hook` prints the same line as the command. A second install writes the same file again.

`git rev-parse --git-path hooks` names the folder of the hooks of this clone, and `ls` lists it. git puts a file
`NAME.sample` there for each hook, and runs none of them. The new file `pre-commit`, with no `.sample`, is the one
that `git commit` runs first.

files:
- diff `justfile`: the recipe `hook`.
  show: `hook *args:`

### tut-11.5 No file over 1 MB

A model's weights or a large file of data does not belong in git. Once git records it, it stays in the history,
and every clone downloads it. pre-commit-hooks is pre-commit's own collection of hooks, and its hook
`check-added-large-files` refuses a file over a size. `--maxkb=1000` sets the size, 1000 KB.

patch$ .pre-commit-config.yaml

::: do
The patch adds the repository `https://github.com/pre-commit/pre-commit-hooks` above `repo: local`, with its version
and the hook `check-added-large-files`.
:::

::: watch
In `.pre-commit-config.yaml`, the new repository is on lines 7 to 11, above `repo: local`. `rev: v6.0.0` is the tag
of the collection that pre-commit uses.
:::

$ uv run pre-commit run --all-files

The first time on a machine, pre-commit prints lines that start with `[INFO]` while it downloads the collection, into a
folder of its own. Then it prints two lines, `check for added large files....Passed` and `just check....Passed`.

files:
- diff `.pre-commit-config.yaml`: the hook of large files.
  show: `        args: [--maxkb=1000]`

### tut-11.6 No merge-conflict markers

When git cannot merge two changes to the same lines, it writes both into the file, between the markers `<<<<<<<`,
`=======` and `>>>>>>>`. A person must choose, and remove the markers. The hook `check-merge-conflict` refuses a file
that still has them.

patch$ .pre-commit-config.yaml

::: do
The patch adds the line of `check-merge-conflict` under the hook of large files.
:::

::: watch
In `.pre-commit-config.yaml`, line 12 is the new hook, `- id: check-merge-conflict`.
:::

$ uv run pre-commit run --all-files

pre-commit prints three lines, each `Passed`. The new one is `check for merge conflicts`.

files:
- diff `.pre-commit-config.yaml`: the hook of merge conflicts.
  show: `      - id: check-merge-conflict`

### tut-11.7 No .env file

A `.env` file holds the settings and secrets of one machine, such as a token. `.gitignore` ignores it already, but
`git add -f .env` would still add it. A local hook with `language: fail` fails for every file that it is given, and
prints its `entry` as the reason. `files:` gives it only the files named `.env`.

patch$ .pre-commit-config.yaml

::: do
The patch adds the hook `no-env-file` under `repo: local`, above the hook of `just check`.
:::

::: watch
In `.pre-commit-config.yaml`, the hook `no-env-file` is on lines 15 to 19. `files: (^|/)\.env$`, on line 19, matches
a file named `.env` in any folder.
:::

$ uv run pre-commit run --all-files

pre-commit prints four lines. The new one ends `(no files to check)Skipped`, because git tracks no `.env` file. The
other three pass.

files:
- diff `.pre-commit-config.yaml`: the hook that refuses a `.env` file.
  show: `        language: fail`

### tut-11.8 An unused import, on purpose

The hook works only if it fails on a mistake. This move makes one on purpose. `cli.py` imports `os`, and never uses
it. The next move removes it.

patch$ src/babykev/cli.py

::: do
The patch adds the line `import os` above `import sys`.
:::

::: watch
In `src/babykev/cli.py`, line 3 is now `import os`, and nothing in the file uses `os`.
:::

$ uv run pre-commit run --all-files

The first three hooks pass or skip, as before. `just check....Failed` follows, with `- exit code: 1` and the output of
`just check`. `just fmt --check` prints `6 files already formatted`, because the import is in its place. Then
`just lint` finds `F401`, `` `os` imported but unused ``, at line 3, column 8 of `src/babykev/cli.py`.

`set -e` stops `just check` there, so the tests do not run. pre-commit ends with exit code 1. A `git commit` would
stop here, and record nothing.

files:
- diff `src/babykev/cli.py`: an import that nothing uses, on purpose.
  show: `import os`

### tut-11.9 The import goes

The linter said what is wrong, and that `--fix` can remove the line. The move removes it by hand.

patch$ src/babykev/cli.py

::: do
The patch removes the line `import os`.
:::

::: watch
In `src/babykev/cli.py`, `import sys` is on line 3 again.
:::

$ uv run pre-commit run --all-files

The four hooks pass or skip, and pre-commit ends with exit code 0. A `git commit` would now record the change.

files:
- diff `src/babykev/cli.py`: the import of `os` goes.
  show: `import os`

### tut-11.10 The README names the hook

A new clone has no hook until someone runs `just hook`. The README says so, under "Start", and its table names the
file of the hooks.

patch$ README.md

::: do
The patch adds a paragraph at the end of the section "Start", and a row for `.pre-commit-config.yaml` at the end of the
table of files.
:::

::: watch
In `README.md`, the new paragraph is on lines 61 to 63, and the row of `.pre-commit-config.yaml` is on line 79.
:::

$ grep -n 'just hook' README.md

`grep` prints line 61, the first line of the paragraph, and line 79, the row of the table.

files:
- diff `README.md`: a paragraph on `just hook`, and a row of the table.
  show: ``Run `just hook` once in each clone. It installs a git hook, which runs `just check` before each commit.``

## tut-12 The config files are checked

$ just setup

`just setup` prints `Resolved 25 packages`.

The gate checks the Python of the project. The files that are not Python, the config files, have no check. A
misspelt key in `pyproject.toml`, a lockfile that no longer matches it, or a YAML file that pre-commit cannot read
passes the gate. A recipe `lint-config` checks each kind of config file, with one checker per move. One checker
fails on its defaults, for real, and its settings fix it. Then the gate runs `lint-config` too.

### tut-12.1 Validate-pyproject, in the group lint

`pyproject.toml` has a standard, which says which tables it has, which keys each table may hold, and what each value
is. validate-pyproject checks the file against the standard. It goes in the group `lint`.

do$ uv add --group lint validate-pyproject

`uv add` prints `Resolved 27 packages`, and installs validate-pyproject and `fastjsonschema`, which it needs.

::: watch
In `pyproject.toml`, the group `lint` now ends with `"validate-pyproject>=0.26",`, on line 29. `uv.lock` has its
exact version, and that of `fastjsonschema`.
:::

$ uv run validate-pyproject --version

It prints the version of validate-pyproject that uv installed. Nothing runs it yet.

files:
- diff `pyproject.toml`: validate-pyproject, in the group `lint`.
  show: `"validate-pyproject>=0.26",`
- diff `uv.lock`: the exact version of validate-pyproject, and of `fastjsonschema`.

### tut-12.2 The recipe lint-config, with validate-pyproject

A recipe `lint-config` will run a check for each kind of config file. Its first check is validate-pyproject on
`pyproject.toml`. Its body is a script, with `set -e`, as in `check`, so that the next checks can come one line at a
time.

patch$ justfile

::: do
The patch adds the recipe `lint-config` under the recipe `lint`, above `test`.
:::

::: watch
In the `justfile`, the recipe `lint-config` is on lines 45 to 52, between `lint` and `test`. Line 52 runs
`uv run validate-pyproject pyproject.toml`.
:::

$ uv run validate-pyproject pyproject.toml
$ just --show lint-config
$ just lint-config
$ just help lint-config

`validate-pyproject` prints `Valid file: pyproject.toml`, and ends with exit code 0.

`just --show lint-config` prints the recipe, and `just lint-config` prints the same line as the command.
`just help lint-config` prints the line of the recipe.

files:
- diff `justfile`: the recipe `lint-config`, with its first check.
  show: `lint-config *args:`

### tut-12.3 Lint-config checks the lockfile

`uv.lock` must match `pyproject.toml`. When a person changes a dependency in `pyproject.toml` and does not run
`uv lock`, they disagree. `uv lock --check` resolves the dependencies again, compares the result with `uv.lock`, and
fails if they differ. It changes no file.

patch$ justfile

::: do
In the recipe `lint-config`, the patch adds `uv lock --check` under the line of validate-pyproject, and names the
lockfile in the comment above the recipe.
:::

::: watch
In the `justfile`, `uv lock --check` is line 53, the second check of `lint-config`. The comment on line 45 now names
the lockfile too.
:::

$ uv lock --check
$ just lint-config

`uv lock --check` prints `Resolved 27 packages`, and ends with exit code 0. `just lint-config` prints
`Valid file: pyproject.toml`, then the same line.

files:
- diff `justfile`: the check of the lockfile.
  show: `    uv lock --check`

### tut-12.4 Recipes refuse an old lockfile

When `pyproject.toml` changes and `uv.lock` does not, `uv run` writes a new `uv.lock` itself, and says nothing. Any
recipe can then change the lockfile, and the person who ran it does not see the change. The variable `UV_LOCKED` makes
every `uv run` refuse a lockfile that is out of date, in place of writing it. The `justfile` exports it to every
recipe.

patch$ justfile

::: do
The patch adds `export UV_LOCKED := "1"` under the line `set positional-arguments`, with a comment above it.
:::

::: watch
Near the top of the `justfile`, `export UV_LOCKED := "1"` is on line 9, under its comment.
:::

$ just --evaluate UV_LOCKED

It prints `1`. `just` puts the variable in the environment of each command of each recipe, so every `uv run` of a
recipe sees it.

files:
- diff `justfile`: one line, which exports `UV_LOCKED` to every recipe.
  show: `export UV_LOCKED := "1"`

### tut-12.5 Lint-config checks the justfile

The `justfile` is a config file too. just has a formatter of its own, `just --fmt`. With `--check`, it writes nothing,
and fails if the file is not in its format. just still calls the formatter unstable, so it needs `--unstable`.

patch$ justfile

::: do
In the recipe `lint-config`, the patch adds `just --fmt --check --unstable` under `uv lock --check`, and names the
`justfile` in the comment above the recipe.
:::

::: watch
In the `justfile`, `just --fmt --check --unstable` is line 57, the third check of `lint-config`. The comment on line
48 names the `justfile`.
:::

$ just --fmt --check --unstable
$ just lint-config

`just --fmt --check --unstable` prints nothing, and ends with exit code 0. We wrote the recipes of this tutorial
in the format of just. `just lint-config` prints the same two lines as before.

files:
- diff `justfile`: the check of the `justfile`.
  show: `    just --fmt --check --unstable`

### tut-12.6 Yamllint, in the group lint

`.pre-commit-config.yaml` is YAML. A mistake of indentation there breaks the hook, and with it every `git commit`. yamllint
checks YAML files, for their syntax and for their style. It goes in the group `lint`.

do$ uv add --group lint yamllint

`uv add` prints `Resolved 29 packages`, and installs yamllint and `pathspec`, which it needs.

::: watch
In `pyproject.toml`, the group `lint` now ends with `"yamllint>=1.38.0",`, on line 30. `uv.lock` has its exact
version, and that of `pathspec`.
:::

$ uv run yamllint --version

It prints the version of yamllint that uv installed.

files:
- diff `pyproject.toml`: yamllint, in the group `lint`.
  show: `"yamllint>=1.38.0",`
- diff `uv.lock`: the exact version of yamllint, and of `pathspec`.

### tut-12.7 Lint-config runs yamllint, and fails

`yamllint --strict .` checks every YAML file under the folder. `--strict` makes a warning fail, as an error does. It is the fourth check of `lint-config`. yamllint has no settings yet, and it fails on its defaults. The next
moves give it settings.

patch$ justfile

::: do
In the recipe `lint-config`, the patch adds `uv run yamllint --strict .` under the line of `just --fmt`, and the
comment above the recipe names every YAML file.
:::

::: watch
In the `justfile`, `uv run yamllint --strict .` is line 58, the last check of `lint-config`.
:::

$ uv run yamllint --strict .
$ just lint-config

yamllint finds problems in three files, and ends with exit code 1. In `.pre-commit-config.yaml`, lines 1, 4 and 17
are errors, `line too long`, of 98, 100 and 95 characters. By default, a line of YAML has at most 80 characters. Line
6 is a warning, `missing document start "---"`.

The other two files are in `.venv`, inside the package pre-commit, `empty_template_pubspec.yaml` and
`empty_template_environment.yml`. Each has the same warning. yamllint reads every folder, `.venv` too, and those
files are not ours.

`just lint-config` passes its first three checks, and then fails with the same findings. `just check` does not run
`lint-config` yet, so the gate still passes.

files:
- diff `justfile`: yamllint, the fourth check.
  show: `    uv run yamllint --strict .`

### tut-12.8 Yamllint skips what git ignores

yamllint reads its settings from a file `.yamllint`. `extends: default` keeps its default rules.
`ignore-from-file: .gitignore` skips each file that git ignores, `.venv` among them. The file is new, and comes
whole, as a patch.

patch$ .yamllint

::: do
Read the two settings under the comment.
:::

::: watch
The new file `.yamllint` has 3 lines. Line 3 is `ignore-from-file: .gitignore`, with a comment.
:::

$ uv run yamllint --strict .

yamllint now finds problems in two files, and ends with exit code 1. The two files in `.venv` are gone. The four
findings of `.pre-commit-config.yaml` stay. `.yamllint` is YAML too, and yamllint checks it. Line 2 has the warning
`missing document start "---"`, and line 3 has 87 characters.

files:
- file `.yamllint`: the settings of yamllint.
  show: `ignore-from-file: .gitignore  # the files that git ignores, such as everything in .venv`

### tut-12.9 A YAML file need not start with three dashes

A line `---` marks the start of a document, in a YAML file that holds several. Our files hold one each, and pre-commit
does not ask for the line. The rule `document-start` goes off.

patch$ .yamllint

::: do
The patch adds the table `rules:` at the end of `.yamllint`, with the line of `document-start`.
:::

::: watch
In `.yamllint`, `rules:` is on line 4, and line 5 is `document-start: disable`, with a comment.
:::

$ uv run yamllint --strict .

yamllint finds four problems, and ends with exit code 1. The four are the lines too long, lines 1, 4 and 17 of
`.pre-commit-config.yaml`, and line 3 of `.yamllint`. The warnings are gone.

files:
- diff `.yamllint`: the rule `document-start`, off.
  show: `  document-start: disable  # a file need not start with a line of three dashes`

### tut-12.10 Lines of up to 100 characters in YAML

The Python of the project has lines of up to 100 characters, and the comments of the YAML files follow it. The rule
`line-length` lets a line have 100 characters, as `line-length = 100` in `[tool.ruff]` does for ruff.

patch$ .yamllint

::: do
The patch adds the line of `line-length` under the line of `document-start`.
:::

::: watch
In `.yamllint`, line 6 is `line-length: {max: 100}`, with a comment.
:::

$ just lint-config

yamllint prints nothing, and `just lint-config` passes. It prints `Valid file: pyproject.toml` and
`Resolved 29 packages`, and ends with exit code 0.

files:
- diff `.yamllint`: lines of up to 100 characters.
  show: `  line-length: {max: 100}  # as long as a line of the Python code`

### tut-12.11 The gate checks the config files

`just lint-config` passes, but only when a person runs it. As the last line of `check`, it runs before each
`git commit`, through the hook.

patch$ justfile

::: do
In the recipe `check`, the patch adds `just lint-config` under `just test -q`, and names the config files in the comment
above the recipe.
:::

::: watch
In the `justfile`, `just lint-config` is line 76, the last line of `check`. The comment on line 66 names the config
files.
:::

$ just --show check
$ just check

`just --show check` prints the recipe, with four checks. `just check` prints the output of the format, the linter and
the tests, as before, then `Valid file: pyproject.toml` and `Resolved 29 packages`. It ends with exit code 0.

files:
- diff `justfile`: `lint-config`, the last check of the gate.
  show: `    just lint-config`

### tut-12.12 The README names .yamllint

The table of the README names every config file of the project. `.yamllint` gets a row.

patch$ README.md

::: do
The patch adds a row for `.yamllint` at the end of the table of files.
:::

::: watch
In `README.md`, the row of `.yamllint` is on line 80, the last row of the table.
:::

$ grep -n yamllint README.md

`grep` prints line 80, the new row.

files:
- diff `README.md`: a row for `.yamllint`.
  show: ``| `.yamllint` | The settings of yamllint, which `just lint-config` runs on every YAML file |``

## tut-13 Documentation in the code

$ just setup

`just setup` prints `Resolved 29 packages`.

The signature of `render` gives the types of its parameters, and its docstring says what it does. Neither says what
`indent` means, or what the text that `render` returns is for. A docment says it. A docment is a comment beside a
parameter, a return type or a field, on the same line.

smalldocs reads the signature, the docstring and the docments, and writes the reference of the code from them. It
also lists what has no documentation, as coverage lists the lines that no test runs. The gaps close one part at a
time. A long docment then shows what the formatter can do to one, and the gate runs the check.

### tut-13.1 Smalldocs, in the group docs

Nothing reads the documentation of the code yet. smalldocs is a Python package, so uv installs it like any other. It
is for the documentation, so it goes in a third dependency group, `docs`.

do$ uv add --group docs smalldocs

`uv add` prints `Resolved 34 packages`, and installs smalldocs and four packages that it needs, among them
fastcore and markdown-it-py.

::: watch
In `pyproject.toml`, the new group `docs` is on lines 26 to 28, above the group `lint`. uv sorts the groups by name.
`uv.lock` has the exact version of smalldocs, and of the packages that it needs.
:::

`default-groups = "all"`, on line 23 of `pyproject.toml`, makes uv install every group. So `just setup` installs
smalldocs, with no other change.

$ uv run smalldocs --version
$ uv tree --only-group docs

`uv run smalldocs --version` prints the version of smalldocs that uv installed. `uv tree` prints smalldocs `(group: docs)`,
and under it fastcore, markdown-it-py, mdit-py-plugins, pygments and pyyaml. mdurl is under markdown-it-py.

files:
- diff `pyproject.toml`: the group `docs`, with smalldocs.
  show: `"smalldocs>=0.1.5",`
- diff `uv.lock`: the exact version of smalldocs, and of the packages that it needs.

### tut-13.2 The settings of smalldocs

smalldocs needs to know which package to document. It reads its settings from `docs/_smalldocs.yml`. For now the file
has one section, `api`, the reference. It names the package and the address of its source on GitHub. It also names
the files of the tests, which smalldocs holds to the same rule as the package. The file is new, and comes whole, as a
patch.

patch$ docs/_smalldocs.yml

::: do
Read the three keys under `api`, which are `packages`, `source` and `check`.
:::

::: watch
The new file `docs/_smalldocs.yml` has 5 lines. Line 3 names the package, `babykev`, and line 5 names the tests,
`tests/**/*.py`.
:::

$ uv run smalldocs api check --dir docs

`smalldocs api check` lists the gaps, and `--dir docs` names the folder of the settings. It holds every function,
method and class to one rule, with four parts.

- a type and a docment on every parameter
- a type and a docment on the return, unless it is `None`
- a docstring
- a description on every field of a pydantic model

The first lines of the output count the complete ones in each module and each file of tests.

- `babykev.api`, 0 of 12
- `babykev.cli`, 1 of 1
- `tests/unit/test_api.py`, 23 of 29
- `tests/unit/test_cli.py`, 0 of 3

Then come 46 lines, one for each gap, and the last line, `24 of 45 functions, methods and classes are typed and
documented`. The command ends with exit code 1. The linter asks already for every type and for every docstring of a
public name, so 45 of the 46 gaps are docments and descriptions. The other one is the docstring of `_check`, a private
method, which the linter does not ask for.

files:
- file `docs/_smalldocs.yml`: the package to document, and the tests to check.
  show: `  packages: [babykev]`

### tut-13.3 The recipe docs

The command that lists the gaps is long. The recipe `docs` gives its words to `smalldocs api`, and adds `--dir docs`.

patch$ justfile

::: do
The patch adds the recipe `docs` at the end of the `justfile`, in a group of its own, `docs`.
:::

::: watch
At the end of the `justfile`, the recipe `docs` is on lines 78 to 82. Line 82 runs `uv run smalldocs api "$@" --dir
docs`.
:::

$ just --show docs
$ just docs check
$ just help docs

`just --show docs` prints the recipe. `just docs check` prints the same as `smalldocs api check` above, and ends with
`24 of 45` and exit code 1. `just help docs` prints the line of the recipe.

files:
- diff `justfile`: the recipe `docs`.
  show: `docs *args:`

### tut-13.4 Docments on the functions of api.py

`babykev.api` has seven functions, from `render` to `to_answers`, and none has a docment. Each function now has one
parameter on a line, with its docment beside it, and a docment on its return type, after `-> TYPE:`. The type says
`int`, and the docment says what the number means.

patch$ src/babykev/api.py

::: do
In `src/babykev/api.py`, the patch writes the line `def ...` of each of the seven functions again, over several
lines. Read the docments of `render`, the first of them.
:::

::: watch
In `src/babykev/api.py`, the signature of `render` is on lines 56 to 59. `indent: int = 0,  # How deeply the value is
nested. Each level indents by two spaces` is line 58, and `) -> str:  # The text that the model sees` is line 59. The
six other functions follow the same pattern, down to `to_answers` on lines 144 to 147.
:::

`just docs module api` prints the reference of the module, as Markdown. `sed` keeps the part of `render`.

$ just docs module api | sed -n '/^## render$/,/^## option_text$/p'
$ just docs check

The reference of `render` has its signature, its docstring, and a table with a row for `v`, for `indent` and for
`returns`. The column Description holds the docments. `just docs check` prints `babykev.api 7 of 12`, and
`31 of 45`, with exit code 1. The 7 are the seven functions. The five left in `babykev.api` are the four classes and
`_check`.

files:
- diff `src/babykev/api.py`: a docment on each parameter and each return of seven functions.
  show: `) -> str:  # The text that the model sees`

### tut-13.5 _check says what it checks

`_check` is the validator of `Choice`. Its name starts with `_`, so the linter asks for no docstring, and the
reference leaves it out. smalldocs checks it still, because a reader of the code needs to know what it does. It gets
a docstring, and a docment on its return, the choice itself.

patch$ src/babykev/api.py

::: do
In `src/babykev/api.py`, the patch adds a docment at the end of the line `def _check(self) -> Self:`, and a docstring
under it.
:::

::: watch
In `src/babykev/api.py`, line 32 is now `def _check(self) -> Self:  # The choice itself, unchanged`, and line 33 is its
docstring.
:::

$ just docs check

`just docs check` prints `babykev.api 8 of 12`, and `32 of 45`. The gaps of `_check` are gone.

files:
- diff `src/babykev/api.py`: a docstring and a docment for `_check`.
  show: `    def _check(self) -> Self:  # The choice itself, unchanged`

### tut-13.6 A description on every field of a request

The four classes of a request have no signature to put a docment on. Each field is a line of the class, such as
`type: Literal["noul"]`. pydantic takes a description of a field in `Field(description="...")`. It keeps the
description in the schema of the model, which other programs read, and smalldocs puts it in the reference.

patch$ src/babykev/api.py

::: do
In `src/babykev/api.py`, the patch gives each field of `Noul`, `Choice`, `Score` and `SystemOneRequest` a
`Field(description=...)`. A field with a default or a limit already keeps it, in the same `Field`.
:::

::: watch
In `src/babykev/api.py`, the fields of `Noul` are on lines 19 to 24, and the fields of `SystemOneRequest` on lines 62
to 65. The `criteria` of `Score`, on lines 49 to 53, keep their limits, `min_length=2` and `max_length=MAX_OPTIONS`,
beside the new description.
:::

$ uv run python -c "from babykev.api import Score; print(Score.model_json_schema()['properties']['criteria']['description'])"
$ just docs check
$ just test

`model_json_schema()` is the schema of the model, as JSON, and `uv run python -c` prints the description of the
field `criteria` of `Score`, `The levels of the scale, the lowest first`. `just docs check` prints `babykev.api 12 of
12`, and `36 of 45`. Every gap left is in the tests. `just test` prints `53 passed`. A description changes no rule of
the contract.

files:
- diff `src/babykev/api.py`: a description on every field of the four classes.
  show: `    type: Literal["noul"] = Field(description="Marks the question as one of yes or no")`

### tut-13.7 Docments on the tests of the command

The tests are documentation too. A reader learns from them what the code must do. `smalldocs api check` holds the
tests to the same rule as the package. In `test_cli.py`, `run` and the two tests have parameters with no docment.
Each now has one parameter on a line, with its docment.

patch$ tests/unit/test_cli.py

::: do
In `tests/unit/test_cli.py`, the patch writes the signatures of `run` and of the two tests again, with a docment
beside each parameter.
:::

::: watch
In `tests/unit/test_cli.py`, the signature of `run` is on lines 8 to 11. The parameters of the two tests are on lines
19 to 21 and 29 to 30.
:::

We read the tests of the command again, with their docments.

$ sed -n '8,40p' tests/unit/test_cli.py
$ just test -k unknown_command
$ just docs check

`sed` prints `run` and the two tests. Each docment says what pytest gives the test. `monkeypatch` sets the command
line, and `capsys` catches what the test prints. The test of an unknown command runs `babykev train`, and checks the
exit code 2 and the message. `just test -k unknown_command` prints `1 passed, 52 deselected`. `just docs check`
prints `tests/unit/test_cli.py 3 of 3`, and `39 of 45`.

files:
- diff `tests/unit/test_cli.py`: a docment on each parameter.
  show: `    capsys: pytest.CaptureFixture[str],  # Catches the message of the refusal`

### tut-13.8 Docments on the tests of the contract

In `test_api.py`, the helper `cheese_request` has no docment on its return. Five tests take parameters from
`@pytest.mark.parametrize`, with no docment. Each gets its docments.

patch$ tests/unit/test_api.py

::: do
In `tests/unit/test_api.py`, the patch adds a docment at the end of the line `def cheese_request()`. It writes the
signatures of five tests again, one parameter on a line, with its docment.
:::

::: watch
In `tests/unit/test_api.py`, line 32 is `def cheese_request() -> SystemOneRequest:  # A noul, a choice and a score about
one cheese`. The test of `option_text` is on lines 155 to 169, with its three parameters on lines 164 to 166.
:::

$ sed -n '155,169p' tests/unit/test_api.py
$ just test -k option_text
$ just docs check

`sed` prints the test of `option_text`. `@pytest.mark.parametrize` gives it three cases. The docments say what each
value is, the name, the description, and the text that `option_text` must make of them. `just test -k option_text`
prints `3 passed, 50 deselected`, one for each case. `just docs check` prints a count for each file, all
complete, and `45 of 45 functions, methods and classes are typed and documented`. It ends with exit code 0.

files:
- diff `tests/unit/test_api.py`: a docment on each parameter, and on the return of `cheese_request`.
  show: `    description: JSONContent,  # Its description, or None or "" for none`

### tut-13.9 A docment too long for its line, on purpose

A docment is on the line of its parameter or of its return type, and a line has at most 100 characters. This move
makes a mistake on purpose. The docment of the return of `to_record` says more, and its line grows to 119
characters. The next moves show what the formatter makes of it.

patch$ src/babykev/api.py

::: do
In `src/babykev/api.py`, the patch writes the docment of the return of `to_record` again, on line 98.
:::

::: watch
In `src/babykev/api.py`, line 98 now ends with `# The record that the model reads, and the metadata of each question`.
:::

$ just lint
$ just fmt --check
$ just docs check

`just lint` finds `E501`, `Line too long (119 > 100)`, at line 98, and ends with exit code 1. `just fmt --check`
would rewrite the line. It shows the return type split over three lines, with the comment after `]:`, and ends with
exit code 1. `just docs check` still prints `45 of 45`, because the docment is on its line.

files:
- diff `src/babykev/api.py`: a docment longer than its line, on purpose.
  show: `) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record that the model reads, and the metadata of each question`

### tut-13.10 Just fmt wraps the return type

The formatter fixes a line that is too long, and a person runs it without a second thought.

do$ just fmt

`just fmt` prints `1 file reformatted, 5 files left unchanged`.

::: watch
In `src/babykev/api.py`, the return type of `to_record` is now on lines 98 to 100. `) -> tuple[` is line 98, the
types are line 99, and `]:  # The record that the model reads, and the metadata of each question` is line 100.
:::

The comment is now two lines below the arrow `->`. smalldocs reads it as a comment on the line `]:`, and not as the
docment of the return.

$ just lint
$ just check
$ just docs check

`just lint` prints `All checks passed!`, and `just check` passes, with exit code 0. `just docs check` prints
`babykev.api 11 of 12`, `babykev.api:to_record: no return docment`, and `44 of 45`, with exit code 1. The linter and
the formatter are happy, and only the docs check sees the lost docment. `just check` does not run it yet.

files:
- diff `src/babykev/api.py`: the return type of `to_record`, over three lines.
  show: `]:  # The record that the model reads, and the metadata of each question`

### tut-13.11 The docment, short enough

The fix is a docment that fits on the line of the return type, with the type on one line again. The docment of
before, `The record, and the metadata of each question`, fits, at 98 characters.

patch$ src/babykev/api.py

::: do
In `src/babykev/api.py`, the patch puts the return type of `to_record` on one line again, line 98, with the short
docment.
:::

::: watch
In `src/babykev/api.py`, line 98 is `) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record, and the metadata of
each question`, as it was before the mistake.
:::

$ just fmt --check
$ just docs check

`just fmt --check` prints `6 files already formatted`, and `just docs check` prints `45 of 45`, with exit code 0.

files:
- diff `src/babykev/api.py`: the return type on one line, with its short docment.
  show: `) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record, and the metadata of each question`

### tut-13.12 The gate checks the docs

`just check` passed with a docment lost. As a line of `check`, `just docs check` runs before each `git commit`,
through the hook. It goes after the tests, and before the config files.

patch$ justfile

::: do
In the recipe `check`, the patch adds `just docs check` under `just test -q`, and names the docs in the comment above
the recipe.
:::

::: watch
In the `justfile`, `just docs check` is line 76, between `just test -q` and `just lint-config`. The comment on line 66
names the docs.
:::

$ just --show check
$ just check

`just --show check` prints the recipe, with five checks. `just check` prints the output of each, with `45 of 45`
after the tests, and ends with exit code 0. A function, a parameter or a field with no documentation now stops
`git commit`.

files:
- diff `justfile`: the docs check, in the gate.
  show: `    just docs check`

## tut-14 The docs site

$ just setup

`just setup` prints `Resolved 34 packages`.

The reference exists only as Markdown that `just docs module` prints in a terminal. A reader wants a site, with a
front page that says what babykev is, and a page of reference for each module. smalldocs builds that site from the
same docstrings and docments. Git first learns to ignore the files that a build writes into `docs/`. Then the recipe
`docs` builds the site, the site gets its settings and its front page, and the README names it.

### tut-14.1 Git ignores what a build of the docs makes

smalldocs builds the site, and the build writes three things into `docs/`. `docs/_site/` is the site, as HTML.
`docs/api/` holds the reference pages, as Markdown, and `docs/_symbols.json` holds the names that a link can point
to. A build makes all three again from the code, so they do not belong in git. `.gitignore` names the files that git
does not track, and three lines at its end name these, before the first build. A `/` at the start of a line means
the root of the repository, so `/docs/api/` is only that folder.

patch$ .gitignore

::: do
The patch adds a comment and three lines at the end of `.gitignore`.
:::

::: watch
At the end of `.gitignore`, the comment is on line 222, and `/docs/_site/`, `/docs/api/` and `/docs/_symbols.json` on
lines 223 to 225.
:::

$ tail -n 4 .gitignore

`tail -n 4 .gitignore` prints the comment and the three lines.

files:
- diff `.gitignore`: the files that a build of the docs makes.
  show: `/docs/_site/`

### tut-14.2 Just docs, alone, builds the site

`smalldocs render docs` builds the site from the folder `docs`. It writes the reference pages from the code, then
the HTML of every page into `docs/_site`. With no words, the recipe `docs` now runs it. With words, it runs
`smalldocs api` as before. So the body of the recipe is a script of `sh`.

patch$ justfile

::: do
The patch writes the recipe `docs` again, from its comment to its last line. Its body is now a script, with one line
for `help`, one for no words, and one for words.
:::

::: watch
In the `justfile`, the recipe `docs` starts at line 79, with its comment. Line 85,
`if [ "$#" -eq 0 ]; then exec uv run smalldocs render docs; fi`, is the case with no words.
:::

$ uv run smalldocs render docs
$ just --show docs
$ just docs
$ git status --short --ignored docs

`smalldocs render docs` prints `wrote 2 page(s) to docs/_site`. The two pages are the reference of `api.py` and of
`cli.py`, because `docs/` has no page of its own yet. `just --show docs` prints the recipe, and `just docs` prints the
same line as the command.

`git status --short --ignored docs` lists the three paths that the build made, each marked `!!`, ignored. The lines
of `.gitignore` from the move before keep them out of git.

files:
- diff `justfile`: with no words, `docs` builds the site.
  show: `    if [ "$#" -eq 0 ]; then exec uv run smalldocs render docs; fi`

### tut-14.3 The settings of the site

The site has no title, no sidebar and no links between its pages. Its settings go in `docs/_smalldocs.yml`, above the
section `api`, which stays as it is. They are the type of the project, its output folder, the title, the sidebar, the
theme and a table of contents on each page. With them, a name in backticks, such as `Score`, becomes a link to its
entry in the reference.

patch$ docs/_smalldocs.yml

::: do
The patch writes the comment at the top again, to say what `just docs` builds. Under it come the sections `project`
and `website`, and the keys `theme` and `toc`. A new comment above `api:` says what the reference is.
:::

::: watch
In `docs/_smalldocs.yml`, the sidebar is on lines 8 to 12. It lists the front page, `index.qmd`, then the reference
pages, `contents: api/*`, under the title Reference. The section `api` is on lines 18 to 21, as before.
:::

$ just docs
$ open docs/_site/api/api.html

`just docs` prints `wrote 2 page(s) to docs/_site`, then two warnings, `api/api.qmd: broken link /index.qmd` and the
same for `api/cli.qmd`. The sidebar names the front page, which does not exist yet. The next move writes it. The
reference of `api.py` opens in the browser, with the sidebar on the left.

files:
- diff `docs/_smalldocs.yml`: the settings of the site, above the reference.
  show: `        contents: api/*  # the reference pages, which each build makes from the code`

### tut-14.4 A front page

The front page, `docs/index.qmd`, says what babykev is, what a request holds, and what each module does. A `.qmd`
file is Markdown, with a header between two lines `---` that gives the title of the page. The file is new, and comes
whole, as a patch.

patch$ docs/index.qmd

::: do
Read the page. Each name in backticks, such as `to_answers`, will be a link.
:::

::: watch
The new file `docs/index.qmd` has 29 lines. Lines 1 to 3 are the header, with `title: babykev`. The list of modules is
on lines 17 to 19.
:::

$ just docs
$ grep -o 'href="api/api.html#[^"]*"' docs/_site/index.html
$ open docs/_site/index.html

`just docs` prints `wrote 3 page(s) to docs/_site`, and no warning. `grep -o` prints each link of the front page into
the reference of `api.py`, seven of them. `SystemOneRequest`, `Noul`, `Choice` and `Score` link to their classes, and
`to_record` and `to_answers` to their functions. `to_answers` is named twice. The front page opens in the browser.

files:
- file `docs/index.qmd`: the front page, written by hand.
  show: ``A name in backticks, such as `to_answers`, links to its entry.``

### tut-14.5 The README names the docs

The table of the README says where each part of the project is, and it does not list the docs. `docs/` gets a row,
under the tests.

patch$ README.md

::: do
The patch adds a row for `docs/` under the row of `tests/unit/`.
:::

::: watch
In `README.md`, the row of `docs/` is on line 74.
:::

$ grep -n 'docs/' README.md

`grep` prints line 74, the new row.

files:
- diff `README.md`: a row for `docs/`.
  show: ``| `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |``

## tut-15 The packages of the model

$ just setup

`just setup` prints `Resolved 34 packages`.

The model of kev is a language model with an adapter and a head of its own, and it needs four packages.

torch computes with tensors, on the CPU or on a GPU. transformers loads a base model and its tokenizer
from the Hugging Face Hub. peft adds a LoRA adapter to the base model. safetensors is the format of the weights on the
Hub. Each package comes in by its own `uv add`, and torch comes first, from an index of its own.

### tut-15.1 The index of PyTorch's builds for the CPU

torch has several builds of each version. On Linux, the build on PyPI brings the libraries of CUDA, for the GPUs of
NVIDIA. PyTorch keeps a build for the CPU alone on an index of its own, `https://download.pytorch.org/whl/cpu`. An
index is a server of packages, as PyPI is. The patch names the index in `pyproject.toml`.

patch$ pyproject.toml

::: do
The patch adds the table `[[tool.uv.index]]` under `[tool.uv]`, with a comment above it.
:::

::: watch
In `pyproject.toml`, the comment is on lines 25 and 26. The index is on lines 27 to 30, with its name `pytorch-cpu`,
its address and `explicit = true`.
:::

`explicit = true` means that uv takes from the index only the packages that `[tool.uv.sources]` sends there. That
table does not exist yet.

$ uv lock --check

`uv lock --check` prints `Resolved 34 packages`, and ends with exit code 0. No package uses the index yet, so the
lockfile does not change.

files:
- diff `pyproject.toml`: the index of PyTorch.
  show: `url = "https://download.pytorch.org/whl/cpu"`

### tut-15.2 torch, from the index of PyTorch

`uv add torch --index pytorch-cpu` names the index for torch, and uv writes the source of torch in
`[tool.uv.sources]` itself. `uv add` then resolves, and for that one run `--index` puts the index of PyTorch first,
for every package. It would take other packages from there, older than on PyPI. `--frozen` writes `pyproject.toml`
and leaves `uv.lock` alone, so uv resolves nothing yet.

do$ uv add torch --index pytorch-cpu --frozen

`uv add` prints one warning, `Referencing an index by name is experimental`, and ends with exit code 0. It installs
nothing.

::: watch
In `pyproject.toml`, line 12 is now `"torch",`, under pydantic. `--frozen` resolves nothing, so uv writes no lowest
version. `[tool.uv.sources]` is on lines 33 and 34, with `torch = { index = "pytorch-cpu" }`. `uv.lock` has not
changed.
:::

$ uv lock --check

`uv lock --check` prints `Resolved 43 packages`, then `The lockfile at uv.lock needs to be updated`, and ends with
exit code 1. `pyproject.toml` names torch, and `uv.lock` does not have it. `just lint-config` runs the same command, so
`just check` fails too. The next move writes the lockfile.

files:
- diff `pyproject.toml`: torch, in the dependencies, and its source.
  show: `torch = { index = "pytorch-cpu" }`

### tut-15.3 uv lock takes torch from its index

`uv lock` resolves with no `--index` on the command line. The source sends torch to the index of PyTorch, and
`explicit = true` keeps every other package on PyPI.

do$ uv lock

`uv lock` prints `Resolved 43 packages`, and eight lines `Added`. The line of torch,
`Added torch`, names two versions, one of them with `+cpu`. They are two
builds of torch. The seven packages that it needs, among them `sympy` and `networkx`, are the other seven. `uv lock` writes
`uv.lock` and installs nothing.

::: watch
`uv.lock` has 230 new lines, with torch and the seven packages that it needs.
:::

$ uv lock --check
$ grep -n -A5 '^name = "torch"' uv.lock
$ grep -B2 'registry = "https://download.pytorch.org/whl/cpu" }$' uv.lock | grep '^name'

`uv lock --check` prints `Resolved 43 packages`, and ends with exit code 0. The first `grep` prints the two entries
of torch, on lines 701 and 725. Both come from `https://download.pytorch.org/whl/cpu`. The first is for
`sys_platform == 'darwin'`, a Mac. The second, whose version ends in `+cpu`, is for every other system. The
second `grep` prints the name of every package from the index of PyTorch, and it prints `name = "torch"` twice and
nothing more.

$ uv run python -c "import torch; print(torch.__version__, torch.backends.mps.is_available())"

`uv run` first installs what `uv.lock` now has, 9 packages. torch then prints a warning, `UserWarning: Failed to
initialize NumPy: No module named 'numpy'`. torch works without numpy, and says so. The last line is
the version of torch and `True`. `True` means that torch finds MPS, the GPU of Apple, so on a Mac the build for the CPU runs on the GPU
too.

files:
- diff `uv.lock`: torch, from the index of PyTorch, and the seven packages that it needs, from PyPI.

### tut-15.4 transformers

The base model of kev, and its tokenizer, are on the Hugging Face Hub. transformers loads them.

do$ uv add transformers

`uv add` prints `Resolved 63 packages`, and installs transformers and 18 packages that it needs, among
them `huggingface-hub`, `tokenizers`, `numpy` and `safetensors`.

::: watch
In `pyproject.toml`, line 13 is now `"transformers>=5.20.0",`, under torch. `uv.lock` has transformers, and the
packages that it needs.
:::

$ uv run python -c "import torch, transformers; print(transformers.__version__)"

It prints the version of transformers, and no warning. numpy came with transformers, so torch no longer warns.

files:
- diff `pyproject.toml`: transformers, in the dependencies.
  show: `"transformers>=5.20.0",`
- diff `uv.lock`: the exact version of transformers, and of the packages that it needs.

### tut-15.5 peft

The base model stays as it is, and a small adapter, LoRA, learns the task. peft adds the adapter.

do$ uv add peft

`uv add` prints `Resolved 66 packages`, and installs peft, `accelerate` and `psutil`.

::: watch
In `pyproject.toml`, line 11 is now `"peft>=0.21.2",`, above pydantic. uv sorts the names. `uv.lock` has peft, and
the two packages that it needs.
:::

$ uv tree --invert --package torch --depth 1

`uv tree --invert` prints the packages that need torch, in place of the packages that torch needs. The first line is
`Resolved 66 packages`. Under torch come `accelerate`, `babykev` and `peft`. peft needs torch, and
torch was already here, from the index of PyTorch.

Had peft come first, uv would have taken torch from PyPI, with the libraries of CUDA for Linux. So torch comes first,
from its index.

files:
- diff `pyproject.toml`: peft, in the dependencies.
  show: `"peft>=0.21.2",`
- diff `uv.lock`: the exact version of peft, and of the packages that it needs.

### tut-15.6 safetensors

safetensors is the format of the weights on the Hub. transformers installed it already. babykev names it too,
because babykev saves the weights that it trains to the Hub in this format. A package that only comes with another
can go when that package stops needing it.

do$ uv add safetensors

`uv add` prints `Resolved 66 packages`, the same count as before, and installs no new package. It installs babykev
again, with its new list of dependencies.

::: watch
In `pyproject.toml`, line 13 is now `"safetensors>=0.8.0",`. `uv.lock` changes on two lines, which name safetensors
among the dependencies of babykev.
:::

$ uv tree --invert --package safetensors --depth 1

Under safetensors come `accelerate`, `babykev`, `peft` and `transformers`. Before the move, the list had
no `babykev`.

files:
- diff `pyproject.toml`: safetensors, in the dependencies.
  show: `"safetensors>=0.8.0",`
- diff `uv.lock`: safetensors, as a dependency of babykev.

### tut-15.7 The README names the packages of the model

The README says what the project installs. A paragraph under "Start" names the four packages of the model, and
what they cost on disk.

patch$ README.md

::: do
The patch adds a paragraph under the first paragraph of the section "Start".
:::

::: watch
In `README.md`, the new paragraph is on lines 61 to 63.
:::

$ just setup
$ du -sh .venv .venv/lib/python3.13/site-packages/torch

`just setup` prints `Resolved 66 packages`. `du -sh` prints the size of the environment, `765M`, and of torch alone,
`542M`. The sizes can differ a little on another machine.

files:
- diff `README.md`: a paragraph on the packages of the model.
  show: `The model needs four packages, torch, transformers, peft and safetensors. torch is the build for the CPU,`

## tut-16 The model

$ just setup

`just setup` prints `Resolved 66 packages`.

babykev has a contract and no model. `model.py` is the model. It comes in whole, from kev's first version, and we
read it before anything else. It meets the gate as it is. No test calls it yet, and the coverage shows it. Then the
front page of the docs and the README name it.

### tut-16.1 model.py, the model

`model.py` turns a language model into a model that decides. It has 274 lines, and four ideas, which its docstring
names. The file comes in whole, as a patch.

patch$ src/babykev/model.py

::: do
Read the docstring of the module first, lines 1 to 18.
:::

::: watch
`src/babykev/model.py` is new, with 274 lines. The docstring of the module is on lines 1 to 18. The functions that
pack a record are on lines 78 to 142, and the mask is on lines 145 to 162. The head is on lines 165 to 184, and
`DecisionModel` on lines 187 to 274.
:::

$ sed -n '1,18p' src/babykev/model.py

The four ideas are packing, the mask, the restarted positions and pointing. Packing writes the state and every
question into one sequence of tokens. The mask lets each token see the state and its own question, and never another
question. The positions of each question start right after the state. The head points at an option, and the model
generates no text.

$ sed -n '34,54p' src/babykev/model.py

Line 37, `SPECIAL`, lists the five delimiters, special tokens that the base model already has. Line 38 sets the
longest state, 384 tokens, and the longest state and question together, 1024. The `TypedDict` `Encoded`, on lines 45
to 53, is a packed record. Each key has a type and a docment.

$ sed -n '145,162p' src/babykev/model.py

The docstring of `branch_mask`, on lines 150 to 155, gives the rule. Token i may look at token j when j is not after
i, and j is in the state or in the question of i. The mask is added to the scores of the attention, so a blocked pair
gets the most negative number of its type.

$ sed -n '187,219p' src/babykev/model.py

`DecisionModel` loads a backbone from the Hub, on lines 200 to 205, if the caller gives none. The parameter
`backbone`, on line 195, is there for the tests. With `lora`, peft wraps the backbone in an adapter, on lines 208 to
216. The head comes last, on line 217.

The file is formatted, typed and documented, so the gate has nothing to say about it.

$ just fmt --check
$ just lint
$ just docs check

`just fmt --check` prints `7 files already formatted`, and `just lint` prints `All checks passed!`. `just docs check`
prints a note of torch, `NOTE: Redirects are currently not supported in MacOs.` smalldocs imports `model.py` to
read it. On a Mac, the import of peft makes torch print the note, and it is not an error. The note goes to the
standard error, so where it shows among the other lines can vary. `just docs check` also prints
`babykev.model 15 of 15`, and `60 of 60 functions, methods and classes are typed and documented`.

$ just test

`just test` prints `53 passed`, and the coverage falls. `model.py` has 109 statements at 0%, and the column Missing
says `20-274`. No test imports `model.py`, and `--cov=babykev` still counts every file of the package. The total is
43%, 83 of 192 statements, where it was 100%, 83 of 83. `just check` has no floor on the coverage, so it passes. The
tests of the model come later, and bring the coverage back.

files:
- file `src/babykev/model.py`: the model. It packs a request into tokens, masks it, and points at the options.
  show: `class DecisionModel(nn.Module):`

### tut-16.2 The front page names the model

The front page of the docs says that the code is in two modules. Now it is in three.

patch$ docs/index.qmd

::: do
The patch changes `two modules` to `three modules`, and adds an item for `babykev.model` at the end of the list.
:::

::: watch
In `docs/index.qmd`, line 15 says `three modules`, and the item of `babykev.model` is on lines 20 and 21.
:::

`encode()` has its brackets on line 20. smalldocs does not link the plain word `encode`, and it links `encode()` to
the function.

$ just docs
$ grep -o 'href="api/model.html#[^"]*"' docs/_site/index.html

`just docs` prints `wrote 4 page(s) to docs/_site`, and the note of torch. The fourth page is the reference of
`model.py`. `grep -o` prints the two links of the front page into it, `#encode` and `#DecisionModel`.

files:
- diff `docs/index.qmd`: the module `babykev.model`, in the list.
  show: ``- `babykev.model` is the model. `encode()` packs a record into one sequence of tokens, and a``

### tut-16.3 The README names model.py

The table of the README lists each file of the code. `model.py` gets a row, under `cli.py`.

patch$ README.md

::: do
The patch adds a row for `src/babykev/model.py` under the row of `src/babykev/cli.py`.
:::

::: watch
In `README.md`, the row of `src/babykev/model.py` is on line 76.
:::

$ grep -n 'model.py' README.md

`grep` prints line 76, the new row.

files:
- diff `README.md`: a row for `src/babykev/model.py`.
  show: ``| `src/babykev/model.py` | The model, a language model with a head that points at the options |``

## tut-17 Types

$ just setup

`just setup` prints `Resolved 66 packages`.

`model.py` has a type on every parameter and every return. Nothing checks them. Python runs the code without
reading the types, and the linter asks only that they be there. A type checker reads the code, and compares each
call and each value with the types that the code and its libraries declare. ty is a type checker. It finds two
places in `model.py`, and both have one cause, in torch.

### tut-17.1 ty, in the group lint

ty is for working on babykev, so it goes in the group `lint`.

do$ uv add --group lint ty

`uv add` prints `Resolved 67 packages`, and installs ty, which needs no other package.

::: watch
In `pyproject.toml`, the group `lint` has `"ty>=0.0.88",` on line 46, under ruff. `uv.lock` has its exact version.
:::

$ uv run ty --version

It prints the version of ty that uv installed. A newer ty can find more, or less, than these notes show.

files:
- diff `pyproject.toml`: ty, in the group `lint`.
  show: `"ty>=0.0.88",`
- diff `uv.lock`: the exact version of ty.

### tut-17.2 The recipe types

`ty check` checks every Python file of the project. The recipe `types` runs it, and gives it any extra words.

patch$ justfile

::: do
The patch adds the recipe `types` in the group `quality`, between `lint-config` and `test`.
:::

::: watch
In the `justfile`, the recipe `types` is on lines 60 to 64. Line 64 runs `uv run ty check "$@"`.
:::

The command behind the recipe comes first.

$ uv run ty check

`ty check` prints two diagnostics, and ends with exit code 1. Both are `error[invalid-mutable-override]`, `Invalid
override of attribute forward`, at `src/babykev/model.py:178:9` and at `src/babykev/model.py:257:9`. The two lines
are the methods `forward` of `PointerHead` and of `DecisionModel`. Under each, ty says `Override does not accept writes of type
(...) -> Any`. The last line is `Found 2 diagnostics`.

$ just --show types
$ just types
$ just help types

`just --show types` prints the recipe. `just types` prints the same two diagnostics, and ends with exit code 1. `just
help types` prints the line of the recipe.

$ uv run ty explain rule invalid-mutable-override

`ty explain rule` prints what a rule checks. A subclass must accept every value that its base class lets code write
into an attribute. Its example has a `value: int` in a base class and a `value: bool` in a subclass. Code that writes
`42` through the base class breaks the subclass. The next move reads what torch declares.

files:
- diff `justfile`: the recipe `types`.
  show: `types *args:`

### tut-17.3 PointerHead.forward, past ty

torch declares `forward` in its base class of every model, `nn.Module`.

$ grep -n '= _forward_unimplemented' .venv/lib/python3.13/site-packages/torch/nn/modules/module.py

`grep` prints line 526 of `module.py`, `forward: Callable[..., Any] = _forward_unimplemented`. `forward` is an
attribute that may hold any function, with any arguments. `PointerHead` puts a method there that takes two tensors.
Code could write any function into `forward` of an `nn.Module`, and the method accepts fewer calls. The rule refuses
this narrowing.

Every model of torch defines `forward` as a method. torch only calls it, from `__call__`, and never writes it. So the
rule is right in general, and does not fit here.

A comment `# ty: ignore[invalid-mutable-override]` on the line of a diagnostic turns off that one rule on that one
line. Each other rule still checks the line. A comment above the method says why.

patch$ src/babykev/model.py

::: do
In `src/babykev/model.py`, the patch adds the comment at the end of the line `def forward(` of `PointerHead`, and two
lines of reason above it.
:::

::: watch
In `src/babykev/model.py`, the reason is on lines 178 and 179, and line 180 is
`def forward(  # ty: ignore[invalid-mutable-override]`.
:::

$ just types
$ just docs check

`just types` prints one diagnostic, at `src/babykev/model.py:259:9`, the `forward` of `DecisionModel`, two lines lower
than before. It ends with `Found 1 diagnostic`, and exit code 1. `just docs check` prints the note of torch and
`60 of 60`. The comment on the line `def forward(` is not a docment, because a docment is on the line of a parameter
or of the return type.

files:
- diff `src/babykev/model.py`: the rule off on the `forward` of `PointerHead`, with the reason.
  show: `    # tensors accepts fewer calls, so ty refuses it. torch only calls forward, and never sets it`

### tut-17.4 DecisionModel.forward, past ty

The `forward` of `DecisionModel` is the same case. It gets the same comment, and one line of reason that points to
the first.

patch$ src/babykev/model.py

::: do
In `src/babykev/model.py`, the patch adds the comment at the end of the line `def forward(` of `DecisionModel`, and
one line of reason above it.
:::

::: watch
In `src/babykev/model.py`, the reason is on line 259, and line 260 is
`def forward(  # ty: ignore[invalid-mutable-override]`.
:::

$ just types

`just types` prints `All checks passed!`, and ends with exit code 0.

files:
- diff `src/babykev/model.py`: the rule off on the `forward` of `DecisionModel`, with the reason.
  show: `    # As in PointerHead, nn.Module declares forward as an attribute, and torch never sets it`

### tut-17.5 The gate checks the types

`just types` passes, and nothing runs it before `git commit`. As a line of `check`, it runs before each `git commit`,
through the hook. It goes after the linter, and before the tests.

patch$ justfile

::: do
In the recipe `check`, the patch adds `just types` under `just lint`, and names the types in the comment above the
recipe.
:::

::: watch
In the `justfile`, `just types` is line 81, between `just lint` and `just test -q`. The comment on line 72 names the
types.
:::

$ just --show check
$ just check

`just --show check` prints the recipe, with six checks. `just check` prints `All checks passed!` twice, once for the
linter and once for ty. Then come `53 passed`, the total of 43%, `60 of 60` and the config files, and it ends with
exit code 0. A call that does not match the types now stops `git commit`.

files:
- diff `justfile`: ty, in the gate.
  show: `    just types`

## tut-18 The smoke run

$ just setup

`just setup` prints `Resolved 67 packages`.

`model.py` passes every check, and nothing has run it. A smoke run is the first thing to try. It loads the real model
on this machine, asks it the questions of the sample data, and prints each answer beside its label. Nothing is trained,
so the answers are guesses. The run shows that the contract, the packing, the model and the answers fit together.

`smoke.py` is ours, and it comes one function at a time. The command `babykev smoke` and the recipe `just smoke` run
it, on this machine only.

### tut-18.1 smoke.py, which reads the sample

The smoke reads the five labelled requests of `data/cheese/sample.jsonl`. `read_lines` reads one request from each
line of the file.

patch$ src/babykev/smoke.py

::: do
The patch makes the file. Read the docstring, then `read_lines`.
:::

::: watch
The new file `src/babykev/smoke.py` has 22 lines. The docstring of the module, on lines 1 to 8, says what the smoke
does. `SAMPLE` is on line 14, and `read_lines` on lines 17 to 22.
:::

$ uv run python -c "from babykev.smoke import read_lines; lines = read_lines(); print(len(lines), list(lines[0]))"

It prints `5 ['state', 'questions']`, five requests, each with a state and its questions.

$ just test

`just test` prints `53 passed`. `smoke.py` has 7 statements at 0%, and the total falls from 43% to 42%, 83 of 199.
The coverage counts every file of the package, and no test imports `smoke.py`.

files:
- file `src/babykev/smoke.py`: the docstring, and the function that reads the sample.
  show: `def read_lines(`

### tut-18.2 answer

`answer` takes one request through every part of babykev. The contract checks the request, and `to_record` turns it
into a record. `encode` packs the record into tokens, and `model.probs` gives the probabilities. `to_answers` turns
them into an answer for each question. `answer` also counts the tokens and times the pass of the model.

patch$ src/babykev/smoke.py

::: do
The patch adds the imports that `answer` needs, and `answer` at the end of the file.
:::

::: watch
In `src/babykev/smoke.py`, the new imports are on lines 13, 17, 19 and 20, and `answer` is on lines 31 to 41.
:::

`answer` calls four functions of `api.py` and `model.py`, and no test runs it yet. ty reads each call, and compares it
with the types that those functions declare.

$ just types

`just types` prints `All checks passed!`. Each call gives each function the type of value that it asks for.

files:
- diff `src/babykev/smoke.py`: one request, from the contract to the answers.
  show: `def answer(`

### tut-18.3 verdict

A label is the right answer to a question. `verdict` puts the answer of the model beside its label, for each of the
three types of question. A noul says yes from a probability of 0.5. A choice names its option. A score is judged by
its most likely level.

patch$ src/babykev/smoke.py

::: do
The patch adds `verdict` at the end of the file.
:::

::: watch
In `src/babykev/smoke.py`, `verdict` is on lines 44 to 61.
:::

$ uv run python -c "from babykev.smoke import verdict; print(verdict({'type': 'noul', 'label': True}, {'type': 'noul', 'noul': 0.78}))"

It prints `('yes (0.78)', 'yes', True)`. The three values are what the model said, what the label says, and whether
they agree. `smoke.py` imports `model.py`, so torch prints its note too.

files:
- diff `src/babykev/smoke.py`: one answer beside its label.
  show: `def verdict(`

### tut-18.4 smoke

`smoke` asks the model every question of the sample, and yields the report a line at a time. The first pass on a
device is slow, so it runs once before the timing starts. Each request gets a line with its state, its tokens and its
time. Each question gets a line with `ok` or `--`. The last lines give the count of right answers.

patch$ src/babykev/smoke.py

::: do
The patch adds `Iterator` and `render` to the imports, and `smoke` at the end of the file.
:::

::: watch
In `src/babykev/smoke.py`, `Iterator` is on line 14 and `render` on line 20. `smoke` is on lines 65 to 85.
:::

$ just types

`just types` prints `All checks passed!`. `smoke` declares that it returns an `Iterator[str]`, and each `yield` gives
a string.

files:
- diff `src/babykev/smoke.py`: the report, a line at a time.
  show: `def smoke(`

### tut-18.5 main loads the real model and runs the smoke

`main` loads the tokenizer and the base model, Qwen2.5-0.5B, from the Hugging Face Hub. It adds an adapter of rank
16, `LORA_RANK`, and the head, which has never been trained. `torch.manual_seed(0)` makes the random weights of the head
the same at every run. `main` counts the parameters, and prints the report of `smoke`. It takes the words after
`babykev smoke`, and answers `help` with the usage.

patch$ src/babykev/smoke.py

::: do
The patch adds `sys`, `torch`, `load_tokenizer` and `pick_device` to the imports, `BASE`, `LORA_RANK` and `USAGE`
under `SAMPLE`, and `main` at the end of the file.
:::

::: watch
In `src/babykev/smoke.py`, `BASE`, `LORA_RANK` and `USAGE` are on lines 24 to 28, and `main` is on lines 95 to 119.
:::

$ uv run python -c "import sys; from babykev.smoke import main; sys.exit(main([]))"

The first time on a machine, transformers downloads the base model into `~/.cache/huggingface`, about 1 GB. On this
Mac, the run takes about 10 seconds. It prints `babykev smoke: Qwen/Qwen2.5-0.5B on mps`, where `mps` is the GPU of
Apple. Then it prints the seconds of the load, and `503M parameters, 9.3M of them trainable`.

The report has a line for each of the five requests, with its tokens, 162, 145, 158, 115 and 156, and its time. Under
each are its three questions. The last lines are `6 of 15 right`, with the milliseconds of a typical request, and
`Nothing is trained yet: these are guesses.`. torch prints its
note too.

Some numbers are fixed, and some can vary. The parameters, the tokens and the answers come from the same weights at
every run, because of the seed. On this Mac, a run on the CPU said `6 of 15 right` too. The seconds to load and the
milliseconds of each request change from run to run. On another device, a probability can differ in its last digits.

$ just test

`just test` prints `53 passed`. `smoke.py` has 71 statements at 0%, and the total is 32%, 83 of 263.

files:
- diff `src/babykev/smoke.py`: the real model, loaded, and the report printed.
  show: `def main(`

### tut-18.6 The command babykev smoke

`cli.py` refuses every word but `help`. It now runs `smoke.main` for the word `smoke`, with the words after it. The
help lists the command. `smoke.py` imports torch, which takes about two seconds. So `cli.py` imports `smoke` inside the
branch of the command, and `babykev help` stays fast.

patch$ src/babykev/cli.py

::: do
The patch replaces `There are no commands yet.` in `HELP` with a list of the commands, and adds the branch of `smoke`
to `main`.
:::

::: watch
In `src/babykev/cli.py`, the commands of `HELP` are on lines 11 and 12, and the branch of `smoke` is on lines 22 to
25.
:::

$ uv run babykev help
$ uv run babykev smoke help

`babykev help` prints the help, with `smoke` under `commands:`. `babykev smoke help` prints the usage,
`usage: babykev smoke    load the base model on this machine; answer the sample requests, untrained`, and the note of
torch.

The test of the help compares what the command prints with `HELP` itself, so it holds after the change.

$ sed -n '17,25p' tests/unit/test_cli.py
$ just test -k help_is_printed

The test runs `babykev` with each of four words, and checks that it prints `HELP`. `just test -k help_is_printed`
prints `4 passed, 49 deselected`. Its table of coverage counts only the four tests that ran, so the total is 13%.

files:
- diff `src/babykev/cli.py`: the command `smoke`, in the help and in `main`.
  show: `        raise SystemExit(smoke.main(words[1:]))`

### tut-18.7 The recipe smoke

The recipe `smoke` runs the command. It answers `help` as every recipe does, and gives any other word to `babykev
smoke`. It is in a group of its own, `model`.

patch$ justfile

::: do
The patch adds the recipe `smoke` at the end of the `justfile`.
:::

::: watch
In the `justfile`, the recipe `smoke` is on lines 95 to 101. Line 101 runs `uv run {{ program }} smoke "$@"`.
:::

The command behind the recipe comes first.

$ uv run babykev smoke
$ just --show smoke
$ just smoke

`uv run babykev smoke` prints the same report as the last move, `6 of 15 right`, with other times. `just --show
smoke` prints the recipe. `just smoke` runs it, and prints the same report again.

$ just help smoke

`just help smoke` prints the line of the recipe. Line 101 names `{{ program }} smoke`, so the recipe `help` also prints
the usage of the program.

files:
- diff `justfile`: the recipe `smoke`.
  show: `smoke *args:`

### tut-18.8 The front page names the smoke

The front page of the docs lists the modules of the code. `babykev.smoke` is the fourth.

patch$ docs/index.qmd

::: do
The patch changes `three modules` to `four modules`, and adds an item for `babykev.smoke` at the end of the list.
:::

::: watch
In `docs/index.qmd`, line 15 says `four modules`, and the item of `babykev.smoke` is on lines 22 and 23.
:::

$ just docs
$ grep -o 'href="api/smoke.html#[^"]*"' docs/_site/index.html

`just docs` prints `wrote 5 page(s) to docs/_site`, and the note of torch. The fifth page is the reference of
`smoke.py`. `grep -o` prints the link of `smoke()` into it, `#smoke`.

files:
- diff `docs/index.qmd`: the module `babykev.smoke`, in the list.
  show: ``- `babykev.smoke` is the smoke run. `smoke()` asks the model every question of the sample data, and``

### tut-18.9 The README names the smoke

The README says what `just smoke` does, and what it downloads. The table gets a row for `smoke.py`.

patch$ README.md

::: do
The patch adds a paragraph about `just smoke` above the paragraph about `just hook`, and a row for
`src/babykev/smoke.py` under the row of `model.py`.
:::

::: watch
In `README.md`, the paragraph about `just smoke` is on lines 65 to 67, and the row of `smoke.py` is on line 81.
:::

$ just check

`just check` passes. The tests print `53 passed`, and the total of 32%. `cli.py` is at 83%, because no test runs
lines 23 to 25, the branch of `smoke`. `just docs check` prints `65 of 65`. The coverage has no floor yet, and the
tests of the model come next.

files:
- diff `README.md`: `just smoke`, and the row of `smoke.py`.
  show: ``| `src/babykev/smoke.py` | The smoke run, which asks the real model the sample requests on this machine |``

## tut-19 Fixtures and the tiny model

$ just setup

`just setup` prints `Resolved 67 packages`.

The tests of the model need a model. The real one is a download of about 1 GB, and a pass takes about 200 ms on a
GPU. A test of the model checks something exact, such as which token is where, how many probabilities there are, or
which weights get a gradient. That holds for any weights, trained or random. So the tests get a tiny model, built in memory with random
weights. A fixture of pytest gives it to each test that asks for it.

### tut-19.1 tests/tiny.py, with the tiny tokenizer

The tiny tokenizer has one token for each printable character, and the five delimiters as special tokens. Like the
tokenizer of the base model, it turns the text of a delimiter into the delimiter. `tests/tiny.py` is a helper of the
tests, and not a test, so pytest does not collect it.

patch$ tests/tiny.py

::: do
The patch makes the file. Read `tiny_tokenizer`.
:::

::: watch
The new file `tests/tiny.py` has 23 lines, and `tiny_tokenizer` on lines 11 to 23.
:::

$ uv run python -c "from tests.tiny import tiny_tokenizer; t = tiny_tokenizer(); print(len(t), t.tokenize('Roquefort'))"

It prints `106` and nine tokens, one for each letter of `Roquefort`, and the note of torch. The 106 tokens are the 100
printable characters, the five delimiters and `[UNK]`, the token for any other character. `python -c` runs from the
root of the project, so Python finds the folder `tests`.

$ just lint

`just lint` finds 2 errors, and ends with exit code 1. Both are `S106`, `Possible hardcoded password assigned to
argument: "unk_token"`, on lines 19 and 21.

$ uv run ruff rule S106

`ruff rule` says what a rule checks. `S106` looks for a string written in the code, given to a parameter whose name
sounds like a secret, such as `password` or `token`. The name `unk_token` has `token` in it. `"[UNK]"` is the text of a
token, and no secret. The next move answers it.

files:
- file `tests/tiny.py`: the tiny tokenizer.
  show: `def tiny_tokenizer() -> PreTrainedTokenizerFast:  # A tokenizer with one token per character`

### tut-19.2 The tests may pass a literal to unk_token

`S106` reads the name of a parameter, and not what the value is. The tests already may use `assert`, by a line of
`[tool.ruff.lint.per-file-ignores]`. The same line lets them break `S106`. The package still may not.

patch$ pyproject.toml

::: do
In `[tool.ruff.lint.per-file-ignores]`, the patch adds `"S106"` to the list of `"tests/**"`, and says why in the
comment above it.
:::

::: watch
In `pyproject.toml`, the comment is on lines 89 and 90, and line 91 is `"tests/**" = ["S101", "S106"]`.
:::

$ just lint

`just lint` prints `All checks passed!`.

files:
- diff `pyproject.toml`: the tests may break `S106`.
  show: `"tests/**" = ["S101", "S106"]`

### tut-19.3 The tiny backbone

The backbone is the language model under the head. `tiny_backbone` builds the code of Qwen, `Qwen2Model`, with two
layers of 32 numbers, where the real one has 24 layers of 896. Its weights are random, from a seed, so they are the
same at every run.

patch$ tests/tiny.py

::: do
The patch adds `torch`, `Qwen2Config` and `Qwen2Model` to the imports, and `tiny_backbone` at the end of the file.
:::

::: watch
In `tests/tiny.py`, `tiny_backbone` is on lines 27 to 42.
:::

$ uv run python -c "from tests.tiny import tiny_backbone; print(sum(p.numel() for p in tiny_backbone(106).parameters()))"

It prints `24224`, the parameters of the tiny backbone. The backbone of Qwen2.5-0.5B has 494,032,768.

files:
- diff `tests/tiny.py`: the tiny backbone.
  show: `def tiny_backbone(`

### tut-19.4 conftest.py, with the fixture tok

A fixture is a function marked `@pytest.fixture`. A test names it as a parameter, and pytest calls the fixture and
passes in what it returns. `monkeypatch` and `capsys` are fixtures of pytest. pytest reads `tests/conftest.py` before
any test, and every test file can use the fixtures in it, with no import. The first fixture, `tok`, is the tiny
tokenizer. `scope="session"` builds it once for the whole run.

patch$ tests/conftest.py

::: do
The patch makes the file, with the fixture `tok`.
:::

::: watch
The new file `tests/conftest.py` imports `tiny_tokenizer` from `tests.tiny` on line 10, and has the fixture `tok` on
lines 13 to 16.
:::

$ just test

`just test` fails before any test runs, with exit code 4. It prints `ImportError while loading conftest`, and
`ModuleNotFoundError: No module named 'tests'`. pytest puts the folder of `conftest.py`, `tests`, on the path of
Python, and not the root of the project. So `tests.tiny` cannot be found. The next move answers it.

files:
- file `tests/conftest.py`: the fixture `tok`.
  show: `@pytest.fixture(scope="session")`

### tut-19.5 pytest can import tests.tiny

The setting `pythonpath` of pytest puts folders on the path of Python. `"."` is the root of the project, where the
folder `tests` is.

patch$ pyproject.toml

::: do
In `[tool.pytest.ini_options]`, the patch adds `pythonpath = ["."]` under `testpaths`, with a comment above it.
:::

::: watch
In `pyproject.toml`, the comment is on line 57, and line 58 is `pythonpath = ["."]`.
:::

$ just test

`just test` prints `53 passed`. `model.py` goes from 0% to 33%, and the total from 32% to 45%, 121 of 267. No test
calls the model. `tests/tiny.py` imports `SPECIAL` from `babykev.model`, so Python runs the module. Its imports, its
names and the line of each `def` and `class` count as covered, 36 of its 109 statements.

$ just test --fixtures

`just test --fixtures` lists every fixture that pytest can see. Those of pytest come first, and the last section is
`fixtures defined from conftest`. It has `tok [session scope] -- tests/conftest.py:14`, with its docstring.

files:
- diff `pyproject.toml`: the root of the project, on the path of pytest.
  show: `pythonpath = ["."]`

### tut-19.6 The fixture model

The fixture `model` is a `DecisionModel` on the tiny backbone, on the CPU, with no adapter. It asks for `tok`, because
the backbone needs to know the number of tokens. A fixture can ask for another fixture. `model` has the default scope,
so pytest builds it again for each test, and no test can spoil it for the next.

patch$ tests/conftest.py

::: do
The patch adds the imports of `DecisionModel` and `tiny_backbone`, and the fixture `model` at the end of the file.
:::

::: watch
In `tests/conftest.py`, the fixture `model` is on lines 20 to 25.
:::

$ just test --fixtures

The last section lists `tok` and `model -- tests/conftest.py:21`. `tok` is now on line 15, one line lower, under the
new import.

files:
- diff `tests/conftest.py`: the fixture `model`.
  show: `    return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()`

### tut-19.7 The fixture record

The fixture `record` is one record about Roquefort, in the form that `to_record` returns. It has a state, and three
questions of 2, 3 and 3 options.

patch$ tests/conftest.py

::: do
The patch adds `Any` to the imports, and the fixture `record` at the end of the file.
:::

::: watch
In `tests/conftest.py`, the fixture `record` is on lines 30 to 40.
:::

$ just test --fixtures

The last section lists the three fixtures, `tok`, `model` and `record`, each with its line in `conftest.py` and its
docstring.

files:
- diff `tests/conftest.py`: the fixture `record`.
  show: `        "state": "Roquefort. A blue cheese from France, made from sheep's milk.",`

### tut-19.8 The first test of the model

The first test asks for the three fixtures. It packs the record with the tiny tokenizer, and runs the tiny model and
the head. Each question gets one probability per option, and they sum to 1. Nothing is trained, so the probabilities
mean nothing. The test checks what is true of any probabilities.

patch$ tests/unit/test_model.py

::: do
The patch makes the file. Read the test.
:::

::: watch
The new file `tests/unit/test_model.py` has one test, on lines 11 to 20.
:::

$ sed -n '11,20p' tests/unit/test_model.py
$ just test -k probabilities_sum

The test never says "tiny". It names `model`, `tok` and `record`, and pytest passes them in. The code that runs is our
`DecisionModel`. Only the backbone and the tokenizer under it are small. `[2, 3, 3]` on line 18 is known in advance,
because the record of the fixture has questions of 2, 3 and 3 options. `just test -k probabilities_sum` prints
`1 passed, 53 deselected`.

$ just test --fixtures-per-test -k probabilities_sum

`--fixtures-per-test` names the fixtures of each test, and where each is defined. The test gets `model`, `record` and
`tok`, each with its line in `conftest.py`.

$ just test

`just test` prints `54 passed`. `model.py` is at 85%, and the total at 67%, 178 of 267. One test runs the
packing, the mask, the backbone and the head.

::: watch
In tut-19.5, before this test, `model.py` was at 33%, and the total at 45%.
:::

files:
- file `tests/unit/test_model.py`: the first test of the model, on the tiny model.
  show: `def test_probabilities_sum_to_one_for_every_question(`

### tut-19.9 The README names the fixtures and the tiny model

The table of the README gets a row for each of the two new files. The row of `tests/unit/` names the tests of the
model.

patch$ README.md

::: do
The patch changes the row of `tests/unit/`, and adds the rows of `tests/conftest.py` and `tests/tiny.py` under it.
:::

::: watch
In `README.md`, the row of `tests/unit/` is on line 83, and the two new rows are on lines 84 and 85.
:::

$ just check

`just check` passes. The tests print `54 passed`, and the total of 67%. `just docs check` prints `71 of 71`, with the
helpers and the fixtures in it.

files:
- diff `README.md`: the rows of the fixtures and of the tiny model.
  show: ``| `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |``

## tut-20 Unit tests of the model and the smoke

$ just setup

`just setup` prints `Resolved 67 packages`.

A unit test runs one function alone. The tests here check the packing, the defence against a forged
delimiter, the head and the device. Then they check the verdicts of the smoke, and the command `smoke`. Each move adds one test. The
coverage does not rise with every test. It counts the lines that a test runs, and not what a test checks.

### tut-20.1 Packing marks every part with its delimiter

The test packs a small record, the state `ab` and one question `x?` with the options `n` and `y`. With one token per
character, it can write down every token that it expects.

patch$ tests/unit/test_model.py

::: do
The patch adds `delimiter_ids` to the import from `babykev.model`, and the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 23 to 35.
:::

$ sed -n '23,35p' tests/unit/test_model.py
$ just test -k packing_marks

The list on line 31 is the whole sequence. It has the state delimiter and `a`, `b`, then the question delimiter and
`x`, `?`. Each option is between its two delimiters, and the decide delimiter comes last. Line 32 gives the segment of each token, 0 for the state
and 1 for the question. `just test -k packing_marks` prints `1 passed`.

With `-k`, the table of coverage counts only the tests that ran. This test alone runs 54% of `model.py`.

$ just test

`just test` prints `55 passed`. The total stays at 67%, and `model.py` at 85%, with the same 16 lines missing. The
test of the probabilities ran `encode` already, and checked none of its tokens. The coverage counts the lines that
run, and not what a test checks.

files:
- diff `tests/unit/test_model.py`: the tokens of a packed record.
  show: `def test_packing_marks_every_part_with_its_delimiter(`

### tut-20.2 Positions restart after the state

The positions of each question begin right after the state, so a question looks the same wherever it comes.

patch$ tests/unit/test_model.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 38 to 47.
:::

$ just test -k positions_restart

pytest prints `1 passed, 55 deselected`.

files:
- diff `tests/unit/test_model.py`: the positions of each question.
  show: `def test_positions_restart_after_the_state(`

### tut-20.3 A question that does not fit is refused

`encode` refuses a question that does not fit, and names its length. The record of the fixture has a state of 62
tokens. The test gives a limit of 80 tokens to the state and a question together, and the questions do not fit.

patch$ tests/unit/test_model.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 50 to 56.
:::

$ just test -k question_that_does_not_fit

pytest prints `1 passed`. The column Missing of `model.py` lists `129-135`, and not 128. Line 128, the `raise`, has
run, and it left `encode` before the lines after it.

files:
- diff `tests/unit/test_model.py`: a question longer than the limit.
  show: `def test_a_question_that_does_not_fit_is_refused(`

### tut-20.4 A state that does not fit is refused

`encode` refuses a state that is longer than its limit, and names its length and the limit. The state of the fixture
is the state delimiter and 61 characters, 62 tokens.

patch$ tests/unit/test_model.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 59 to 65.
:::

$ just test -k state_that_does_not_fit

pytest prints `1 passed`. Line 117, the other `raise` of `encode`, has run. In the column Missing of `model.py`, the
range of `encode` starts at 118 again.

$ just test

`just test` prints `58 passed`. `model.py` is at 87%, with 14 lines missing. Lines 117 and 128 are no longer among
them.

files:
- diff `tests/unit/test_model.py`: a state longer than the limit.
  show: `    with pytest.raises(ValueError, match="state too long: 62 tokens, the limit is 50"):`

### tut-20.5 A tokenizer alone would let text forge a delimiter

A caller writes the state, the instructions and the options. A tokenizer turns the text `<|fim_suffix|>` into the
decide token, wherever it is. So text could close an option early, or make a question of its own. This test shows the
danger, before the next test shows the defence.

patch$ tests/unit/test_model.py

::: do
The patch adds `SPECIAL` to the import from `babykev.model`, and the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 68 to 73.
:::

$ sed -n '68,73p' tests/unit/test_model.py
$ just test -k tokenizer_alone

The test tokenizes `yes<|fim_suffix|>` with the tokenizer alone, and finds the id of the decide delimiter among the
tokens. pytest prints `1 passed`. The danger is real.

files:
- diff `tests/unit/test_model.py`: the danger, a forged delimiter.
  show: `def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(`

### tut-20.6 User text cannot forge a delimiter

`user_tokens` rewrites `<|name|>` to `<¦name¦>` before it tokenizes, so the text of a delimiter is ordinary text. The
test runs once for each of the five delimiters.

patch$ tests/unit/test_model.py

::: do
The patch adds `user_tokens` to the import from `babykev.model`, and the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 76 to 83.
:::

$ just test -k forge

`-k forge` takes both tests, the danger and the defence. pytest prints `6 passed`, the danger once and the defence
five times.

$ just test

`just test` prints `64 passed`. `model.py` is at 87%, with 14 lines missing. The test of the
probabilities had run `user_tokens` already, and checked nothing about it.

::: watch
The 14 lines are the same as at the end of tut-20.4, so the two new tests add no line to the coverage.
:::

files:
- diff `tests/unit/test_model.py`: the defence, for each of the five delimiters.
  show: `def test_user_text_cannot_forge_a_delimiter(`

### tut-20.7 The pointer head gives one logit per option

The head takes the hidden state of a decide token and those of the options, and gives one logit for each option. The
test builds a head alone, with no model, and gives it five options.

patch$ tests/unit/test_model.py

::: do
The patch adds `torch` and `PointerHead` to the imports, and the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 87 to 90.
:::

$ just test -k pointer_head

pytest prints `1 passed`.

files:
- diff `tests/unit/test_model.py`: five options in, five logits out.
  show: `def test_pointer_head_gives_one_logit_per_option() -> None:`

### tut-20.8 pick_device takes an override

`pick_device` returns a device that it is given by name, whatever the machine has.

patch$ tests/unit/test_model.py

::: do
The patch adds `pick_device` to the import from `babykev.model`, and the test at the end of the file. The import is
now longer than 100 characters, so it has one name on each line.
:::

::: watch
In `tests/unit/test_model.py`, the import from `babykev.model` is on lines 9 to 17, and the new test is on lines 101 to
103.
:::

$ just test -k takes_an_override

pytest prints `1 passed`. The column Missing of `model.py` starts at `62-64`, so lines 60 and 61 have run.

files:
- diff `tests/unit/test_model.py`: a device asked for by name.
  show: `def test_pick_device_takes_an_override() -> None:`

### tut-20.9 pick_device finds something to run on

With no override, `pick_device` chooses CUDA, then the GPU of Apple, then the CPU.

patch$ tests/unit/test_model.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 106 to 108.
:::

$ just test

`just test` prints `67 passed`. `model.py` is at 91%, and the missing lines are `63, 72-75, 204-207, 211-218, 277`.
Line 63 returns `cuda`, and runs only on a machine with a GPU of NVIDIA. Lines 72 to 75 load the tokenizer from the
Hub, and lines 204 to 207 load the model. Lines 211 to 218 add the adapter, and line 277 lists the parameters that
train. The total is 69%.

files:
- diff `tests/unit/test_model.py`: a device, whatever the machine.
  show: `def test_pick_device_finds_something_to_run_on() -> None:`

### tut-20.10 A verdict agrees when the answer is the label

The tests of the smoke go in a file of their own. `verdict` needs no model, so its tests are unit tests.

patch$ tests/unit/test_smoke.py

::: do
The patch makes the file, with one test.
:::

::: watch
The new file `tests/unit/test_smoke.py` has the test on lines 6 to 10.
:::

$ sed -n '6,10p' tests/unit/test_smoke.py
$ just test -k agrees_when

The answer is `goat`, with a probability of 0.8, and the label is `goat`. `verdict` gives `("goat (0.80)", "goat",
True)`. pytest prints `1 passed`.

$ just test

`just test` prints `68 passed`. `smoke.py` goes from 0% to 34%, and the total from 69% to 78%. The test calls only
`verdict`. The import of `smoke.py` runs its imports, its names and the line of each `def`.

files:
- file `tests/unit/test_smoke.py`: the first test of `verdict`.
  show: `def test_verdict_agrees_when_the_answer_is_the_label() -> None:`

### tut-20.11 A verdict reads a noul as yes from one half

A probability of yes of 0.5 or more is a yes. The test gives `verdict` exactly 0.5, the edge.

patch$ tests/unit/test_smoke.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_smoke.py`, the new test is on lines 13 to 16.
:::

$ just test -k noul_answer_as_yes

pytest prints `1 passed`. The label is no, so the verdict is `("yes (0.50)", "no", False)`.

files:
- diff `tests/unit/test_smoke.py`: a noul at the edge.
  show: `def test_verdict_reads_a_noul_answer_as_yes_from_one_half() -> None:`

### tut-20.12 A verdict reads a score as its most likely level

A score is judged by the level with the highest probability, and not by the expected level. The expected level is
1.1. The probabilities are 0.2, 0.5 and 0.3, and level 1 is the most likely.

patch$ tests/unit/test_smoke.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_smoke.py`, the new test is on lines 19 to 26.
:::

$ just test

`just test` prints `70 passed`. `verdict` is covered, and the missing lines of `smoke.py` are
`35-36, 45-49, 78-92, 99-119`. They are the body of `read_lines`, of `answer`, of `smoke` and of `main`. The total is
79%.

files:
- diff `tests/unit/test_smoke.py`: a score, by its most likely level.
  show: `def test_verdict_reads_a_score_answer_as_its_most_likely_level() -> None:`

### tut-20.13 babykev smoke help prints the usage

`main` of `smoke.py` answers `help` before it loads anything. So a test can run `babykev smoke help` with no model.
It goes in the tests of the command, and uses their helper `run`.

patch$ tests/unit/test_cli.py

::: do
The patch changes the docstring of the module, imports `USAGE` from `babykev.smoke`, and adds the test at the end of
the file.
:::

::: watch
In `tests/unit/test_cli.py`, the docstring on line 1 names `smoke help`, the import is on line 6, and the new test is
on lines 42 to 50.
:::

$ sed -n '42,50p' tests/unit/test_cli.py
$ just test -k smoke_help

`main` of `cli.py` raises `SystemExit` with the code that `smoke.main` returns. The test catches it, and checks the
code, 0, and the usage. pytest prints `1 passed`.

$ just test

`just test` prints `71 passed`. `cli.py` is back at 100%, and the total is 81%.

files:
- diff `tests/unit/test_cli.py`: `babykev smoke help`.
  show: `def test_smoke_help_prints_the_usage(`

### tut-20.14 babykev smoke refuses a word it does not know

A word after `babykev smoke` that is not `help` gets the usage on the error stream, and exit code 2.

patch$ tests/unit/test_cli.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_cli.py`, the new test is on lines 53 to 61.
:::

$ just test

`just test` prints `72 passed`, and the total is 82%. The missing lines of `smoke.py` are
`35-36, 45-49, 78-92, 105-119`. Lines 105 to 119 load the real model. `answer` and the body of `smoke` need a model,
and no unit test has one.

files:
- diff `tests/unit/test_cli.py`: a word that `babykev smoke` refuses.
  show: `def test_smoke_refuses_a_word_it_does_not_know(`

### tut-20.15 The README names the tests of the smoke

The row of `tests/unit/` names the tests of the smoke too.

patch$ README.md

::: do
The patch adds `and of the smoke` to the row of `tests/unit/`.
:::

::: watch
In `README.md`, line 83 is the row of `tests/unit/`.
:::

$ just check

`just check` passes. The tests print `72 passed`, and the total of 82%. `just docs check` prints `85 of 85`.

files:
- diff `README.md`: the tests of the smoke, in the row of `tests/unit/`.
  show: ``| `tests/unit/` | The tests of the contract, of the command, of the model and of the smoke. One test checks every line of the sample data against the contract |``

## tut-21 Integration tests, and the floor

$ just setup

`just setup` prints `Resolved 67 packages`.

An integration test runs several of our parts together. On the tiny model, it needs no download, and only our code can
make it fail, so it is hermetic. The tests here check what trains, a pass over records of different lengths,
and the whole smoke. Then the coverage is over 90%, and `just check` gets a floor.

### tut-21.1 With an adapter, only the adapter and the head train

Training changes the adapter and the head, and the backbone stays as it is. The test makes a tiny model with an
adapter of rank 4, and takes one backward pass. Then it names every parameter that got a gradient. The fixture
`model` has no adapter, so the test calls `tiny_backbone` itself.

patch$ tests/unit/test_model.py

::: do
The patch adds the import of `tiny_backbone`, and the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the import is on line 18, and the new test is on lines 112 to 130.
:::

$ sed -n '112,130p' tests/unit/test_model.py
$ just test -k only_the_adapter

Line 127 checks that every parameter with a gradient is in the adapter, `lora_`, or in the head, `head.`. Lines 128 to
130 check that `trainable_parameters` lists exactly those. pytest prints `1 passed`.

$ just test --cov-fail-under=90

`--cov-fail-under=90` makes pytest fail when the total is under 90%. It prints `73 passed`, then `FAIL Required test
coverage of 90% not reached. Total coverage: 83.52%`, and ends with exit code 1. `model.py` is at 94%, and lines 211 to
218 and 277 have run. `smoke.py` is at 48%, and misses lines `35-36, 45-49, 78-92, 105-119`.

files:
- diff `tests/unit/test_model.py`: one backward pass with an adapter.
  show: `def test_with_an_adapter_only_the_adapter_and_the_head_train(`

### tut-21.2 Records of different lengths answer in one pass as alone

`forward_batch` reads several records in one pass. They are padded to the length of the longest. The test packs the
record of the fixture and a shorter record, and runs them in one pass. It compares each with a pass of its own.

patch$ tests/unit/test_model.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 133 to 146.
:::

$ just test -k different_lengths

pytest prints `1 passed`. Line 241 builds the mask of each record, with its padding, and every test of the model has
run it. Only this test runs it with padding to build.

$ just test --cov-fail-under=90

pytest prints `74 passed`, and `Total coverage: 83.52%` again. The test adds no line to the coverage, and the floor
still fails.

files:
- diff `tests/unit/test_model.py`: a padded pass.
  show: `def test_records_of_different_lengths_answer_in_one_pass_as_alone(`

### tut-21.3 The smoke reports on every question, on the tiny model

`smoke` takes a model and a tokenizer. With the tiny ones, the five sample requests go through the contract, the
packing, the model and the answers, with no download. The answers mean nothing. The report must have a verdict for
each of the fifteen questions, and the count.

patch$ tests/unit/test_smoke.py

::: do
The patch adds the imports that the test needs, and the test at the end of the file.
:::

::: watch
In `tests/unit/test_smoke.py`, the imports are on lines 3 to 6, and the new test is on lines 32 to 42.
:::

$ sed -n '32,42p' tests/unit/test_smoke.py
$ just test -k smoke_reports

pytest prints `1 passed`. The name of the test says `smoke`, and it is an integration test, of our function `smoke` on
the tiny model. A smoke run uses the real model.

$ just test --cov-fail-under=90

pytest prints `75 passed`, then `Required test coverage of 90% reached. Total coverage: 91.76%`. The missing lines
need the Hub or a GPU of NVIDIA. They are `63, 72-75, 204-207` of `model.py`, and `105-119` of `smoke.py`.

files:
- diff `tests/unit/test_smoke.py`: the whole smoke, on the tiny model.
  show: `def test_smoke_reports_on_every_question_of_the_sample(`

### tut-21.4 The gate has a floor of 90%

`just check` runs the tests with `--cov-fail-under=90`. A change that brings the total under 90% then fails the gate, and the hook refuses it.
`just test` alone has no floor, so a run of a few tests, with `-k`, does not fail on the total.

patch$ justfile

::: do
In the recipe `check`, the patch adds `--cov-fail-under=90` to `just test -q`, and names the coverage in the comment
above the recipe.
:::

::: watch
In the `justfile`, line 82 is `just test -q --cov-fail-under=90`, and the comment on line 72 names the coverage.
:::

$ just --show check
$ just check

`just check` prints `Required test coverage of 90% reached. Total coverage: 91.76%` after the tests, and ends with
exit code 0.

files:
- diff `justfile`: the floor, in the gate.
  show: `    just test -q --cov-fail-under=90`

### tut-21.5 The README names the floor

The README says that one of the checks of `just check` is the floor.

patch$ README.md

::: do
The patch changes the last two lines of the paragraph on `just hook`, which say what `just check` does.
:::

::: watch
In `README.md`, the two lines are 70 and 71.
:::

$ grep -n '90%' README.md

`grep` prints line 71, with the floor.

files:
- diff `README.md`: the floor of 90%, in the lines on `just check`.
  show: ``The tests must run at least 90% of the code. You can run `just check` yourself at any time.``

## tut-22 The mask, found and fixed

$ just setup

`just setup` prints `Resolved 67 packages`.

The mask of `model.py` decides which token may attend to which. A token of a question may see the state and the
tokens of its own question before it, and never a token of another question. Every check has passed since `model.py`
came in, and the coverage of `branch_mask` is 100%. But no test has looked at what the mask allows.

The tests here look, and they find that a question sees the questions before it. The code runs, its types are
right, and its lines are covered. It does the wrong thing for its task.

### tut-22.1 The picture of the mask of a small request

The first test draws the mask of one small request by hand. The request has a state of two tokens and two questions
of two tokens each, so its segments are `[0, 0, 1, 1, 2, 2]`. Row i of the picture is token i, and column j is token
j. `#` means that token i may attend to token j, and `.` means that it may not.

patch$ tests/unit/test_mask.py

::: do
The patch makes the file. Read `allowed`, then the picture in the test.
:::

::: watch
The new file `tests/unit/test_mask.py` has `allowed` on lines 8 to 12, and the test on lines 15 to 26.
:::

$ sed -n '15,26p' tests/unit/test_mask.py
$ just test -k small_request -vv

`allowed` reads the mask back as yes or no. `branch_mask` gives 0 where a token may attend, and a very negative
number where it may not. Rows 5 and 6 of the picture are the tokens of question 2. They see the state, columns 1 and
2, and their own question, columns 5 and 6, and not question 1, columns 3 and 4.

The test fails. `-vv` makes pytest print both lists whole. Rows 5 and 6 of the mask are `#####.` and `######`, where
the picture has `##..#.` and `##..##`. Question 2 sees question 1.

files:
- file `tests/unit/test_mask.py`: the picture of a small request.
  show: `def test_mask_of_a_small_request() -> None:`

### tut-22.2 hypothesis, in the group test

A picture checks one size of request. The mask must hold for every size, and nobody can draw them all. hypothesis is
a library for tests. A test states a rule, and hypothesis draws many inputs and runs the test on each.

do$ uv add --group test hypothesis

`uv add` prints `Resolved 69 packages`, and installs hypothesis and sortedcontainers, which
hypothesis needs.

::: watch
In `pyproject.toml`, the group `test` has `"hypothesis>=6.170.0",` on line 51. `uv.lock` has the exact versions.
:::

$ uv run python -c "import hypothesis; print(hypothesis.__version__)"

It prints the version of hypothesis that uv installed.

files:
- diff `pyproject.toml`: hypothesis, in the group `test`.
  show: `"hypothesis>=6.170.0",`
- diff `uv.lock`: the exact versions of hypothesis and sortedcontainers.

### tut-22.3 No question sees another, for any shape of request

The shape of a request is the length of its state and of each question. A strategy of hypothesis says what an input
may be. `shapes` draws a state of 1 to 6 tokens, then up to 4 questions of 1 to 5 tokens each. `segments` lays out a
shape as `encode` does. The test states the rule that no token of a question attends to a token of another question.
`@given(shapes)` runs it on up to 100 shapes.

patch$ tests/unit/test_mask.py

::: do
The patch adds the imports of hypothesis, `shapes` and `segments` above `allowed`, and the test at the end of the
file.
:::

::: watch
In `tests/unit/test_mask.py`, `shapes` is on line 10, `segments` on lines 13 to 18, and the new test on lines 42 to
49.
:::

$ sed -n '42,49p' tests/unit/test_mask.py
$ just test -k no_question_sees_another

`siblings`, on line 48, is true for two tokens of two different questions. The assert on line 49 says that no pair
is both allowed and siblings.

The test fails. When a shape breaks the rule, hypothesis tries smaller shapes, and reports the smallest that still
breaks it. It reports `shape=(1, [1, 1])`, a state of one token and two questions of one token. `allowed([0, 1, 2])`
has `True` in row 3, column 2. So the token of question 2 sees the token of question 1.

Under the shape, hypothesis lists lines of torch that only the failing examples ran, and they say nothing about the
mask. hypothesis keeps the failing shape in the folder `.hypothesis`, and tries it first at the next run. The
`.gitignore` of GitHub names the folder already.

files:
- diff `tests/unit/test_mask.py`: the shapes, and the first rule.
  show: `def test_no_question_sees_another_question(`

### tut-22.4 No token sees a later token, for any shape of request

The second rule is the causal part of the mask. Nothing above the diagonal is allowed, so a token never attends to a
token after it.

patch$ tests/unit/test_mask.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_mask.py`, the new test is on lines 52 to 57.
:::

$ just test -k later_token

pytest prints `1 passed`. The causal part of the mask was never wrong. Only the part about the questions is.

files:
- diff `tests/unit/test_mask.py`: the causal rule.
  show: `def test_no_token_sees_a_later_token(`

### tut-22.5 What the mask allows is exactly the rule

The last rule says the whole of it, in plain Python. Token i may attend to token j when j is not after i, and j is
in the state or in the question of i. The test builds that table for every pair of tokens, and compares it with the
mask.

patch$ tests/unit/test_mask.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_mask.py`, the new test is on lines 60 to 70.
:::

$ sed -n '60,70p' tests/unit/test_mask.py
$ just test -k exactly_the_rule

The test fails, and hypothesis shrinks the shape to `(1, [1, 1])` again. The three tests of the rules check the mask
alone, so they are unit tests.

files:
- diff `tests/unit/test_mask.py`: the whole rule.
  show: `def test_what_is_allowed_is_exactly_the_rule(`

### tut-22.6 A question cannot see its sibling

The rules check the mask alone. The next three tests check what the mask is for, on the tiny model. Each question
must get the answer that it would get if it were the only question. The first test rewrites question 2 of the record,
and the answers to questions 1 and 3 must not move, to the last bit.

patch$ tests/unit/test_model.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 149 to 160.
:::

$ sed -n '149,160p' tests/unit/test_model.py
$ just test -k sibling

The test fails on line 160, question 3. Its probabilities were `[0.3341, 0.3331, 0.3328]`, and are
`[0.3343, 0.3330, 0.3327]` after question 2 changed. Question 3 sees question 2. Line 159, question 1, passes, because
question 1 comes first and sees only the state. The tiny model is untrained, so the probabilities are close to equal.
`torch.equal` asks for the same numbers, and any change is a failure.

files:
- diff `tests/unit/test_model.py`: rewrite question 2, and questions 1 and 3 keep their answers.
  show: `def test_a_question_cannot_see_its_sibling(`

### tut-22.7 Packed questions answer as they would alone

The second test of isolation packs the three questions of the record in one pass. Then it asks each question in a
record of its own, with the same state. The answers must be the same, to within `1e-6`.

patch$ tests/unit/test_model.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 163 to 172.
:::

$ just test -k packed_questions

The test fails on question 2. Packed, it gets `[0.3321, 0.3346, 0.3333]`, and alone it gets
`[0.3317, 0.3351, 0.3332]`. Question 1 passed the loop before it, for the reason of the last test.

files:
- diff `tests/unit/test_model.py`: three questions in one pass, and each alone.
  show: `def test_packed_questions_answer_as_they_would_alone(`

### tut-22.8 The order of questions does not matter

The positions of every question restart after the state. So a question must get the same answer first or last. The
third test of isolation asks the questions in the reverse order.

patch$ tests/unit/test_model.py

::: do
The patch adds the test at the end of the file.
:::

::: watch
In `tests/unit/test_model.py`, the new test is on lines 175 to 184.
:::

$ just test -k questions_does_not_matter

The test fails on question 1. In the reverse order it comes last, and sees the two other questions. Its
probabilities go from `[0.5016, 0.4984]` to `[0.5007, 0.4993]`. `-k order_of_questions` would also choose a test of
`test_api.py`, so the command names the end of the test.

files:
- diff `tests/unit/test_model.py`: the questions in the reverse order.
  show: `def test_the_order_of_questions_does_not_matter(`

### tut-22.9 A fix for the picture, wrong on purpose

The mistake of this move is on purpose. The picture failed on rows 5 and 6, where question 2 sees question 1. A quick
fix blocks only the question just before a question. A token sees its own question, the state, and any question two
or more before it. The fix makes the picture right.

patch$ src/babykev/model.py

::: do
The patch changes line 159 of `src/babykev/model.py`, the line `same = ...` in `branch_mask`.
:::

::: watch
In `src/babykev/model.py`, line 159 now ends with `| (s[None, :] < s[:, None] - 1)`. A token may see a question
whose number is less than its own minus one.
:::

$ just test

The picture passes, and so does the test of the siblings. 4 tests fail, 78 pass. The two rules that failed before
fail again, and hypothesis shrinks each to `shape=(1, [1, 1, 1])`, three questions of one token. The token of
question 3 sees the token of question 1. The stored shape `(1, [1, 1])` passes now, so hypothesis looks for a new one.
The test of the packed questions and the test of the order fail too, on a question that sees a question two before
it.

The picture has two questions, so it cannot tell. The test of the siblings rewrites question 2, which question 3 no
longer sees. A rule for every shape found the size with three questions.

files:
- diff `src/babykev/model.py`: a mask that blocks only the question just before, on purpose.
  show: `    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)`

### tut-22.10 A token sees the state and its own question

The line of the mask becomes kev's line. A token may attend to a token of the state, `s[None, :] == 0`, or to a token
of its own question, `s[None, :] == s[:, None]`. `causal`, on line 158, keeps out every token after it, and line 160
joins the two. The docstring of `branch_mask`, lines 150 to 154, has stated this rule from the start.

patch$ src/babykev/model.py

::: do
The patch changes line 159 of `src/babykev/model.py` again.
:::

::: watch
In `src/babykev/model.py`, line 159 is `same = (s[None, :] == s[:, None]) | (s[None, :] == 0)`.
:::

$ just test

`just test` prints `82 passed`, and the total of 92%. A test of what the mask allows adds no line
to the coverage. `branch_mask` was covered all along.

The smoke runs the real model on the sample again, with the right mask.

$ just smoke

The smoke prints `4 of 15 right`. Questions 2 and 3 of each request now read only the state and themselves, and not
the questions before them. The model is untrained, so the count is a guess, and a right answer is chance.

::: watch
In tut-18, with the old mask, the smoke printed `6 of 15 right`. The first question of each request keeps its answer,
with the same two decimals. It comes first, so it saw only the state with either mask. Nine of the ten other answers
changed. Both counts are guesses.
:::

files:
- diff `src/babykev/model.py`: the state, or the same question.
  show: `    same = (s[None, :] == s[:, None]) | (s[None, :] == 0)`

### tut-22.11 The README names the tests of the mask

The row of the README for `tests/unit/` names the tests of the mask, and hypothesis.

patch$ README.md

::: do
The patch changes the row of `tests/unit/` in the table.
:::

::: watch
In `README.md`, the row of `tests/unit/` is on line 83.
:::

$ just check

`just check` passes. The tests print `82 passed` and `Total coverage: 91.76%`. `just docs check` prints `97 of 97`,
with the six functions of `test_mask.py`.

files:
- diff `README.md`: the tests of the mask, in the row of `tests/unit/`.
  show: `hypothesis tries the rules of the mask on many shapes of request |`

## tut-23 The system test

$ just setup

`just setup` prints `Resolved 69 packages`.

Every test so far needs nothing but our code. The tiny model is built in memory, so no download, no network and no
device can make a test fail. Such a test is hermetic, and the hook can run it before each `git commit`. The smoke on the
real model is a test too, of the whole program with its real parts. It needs the Hub or its cache, and it is the
system test of the table of the kinds of tests. Here it becomes a test, an experiment shows that it is not
hermetic, and keeps it out of `just test` and the gate.

### tut-23.1 The smoke on the real model, as a test

The test runs `main` of `smoke.py`, as `babykev smoke` does. It checks what holds on any device, which is the exit
code 0, fifteen verdicts, and the count of the right ones. It does not check the count itself, because an untrained model
guesses.

patch$ tests/system/test_real_model.py

::: do
The patch makes the file, in a new folder `tests/system`. Read the docstring of the module, then the test.
:::

::: watch
The new file `tests/system/test_real_model.py` has the docstring on lines 1 to 7, and the test on lines 14 to 24.
:::

$ sed -n '14,24p' tests/system/test_real_model.py
$ just test

`capsys`, on line 15, is the fixture of pytest that catches what the test prints. `just test` prints `83 passed`. The
test loads the real model, so the run takes a few seconds more. `smoke.py` goes to 100%, and the total to 99%. Only
lines 63 and 74 of `model.py` are left, the branch of CUDA and the check of a tokenizer.

A test that needs the network fails without it. `HF_HUB_OFFLINE=1` tells the library of the Hub to make no request,
and `HF_HOME` points its cache at an empty folder. The two together are a machine with no network and no download.

$ HF_HUB_OFFLINE=1 HF_HOME="$(mktemp -d)" just test -k real_model

The test fails, with `OSError: We couldn't connect to 'https://huggingface.co' to load the files, and couldn't find
them in the cached files.` Nothing in our code changed. So the test is not hermetic.

$ HF_HUB_OFFLINE=1 just test -k real_model

With the cache of this machine and still no network, the test passes. It passes because the model is in the cache,
and not because it is hermetic.

files:
- file `tests/system/test_real_model.py`: the smoke on the real model, as a test.
  show: `def test_the_real_model_answers_every_sample_question(`

### tut-23.2 The test of the real model is marked system

A marker is a name that a test carries. `pytestmark` puts a marker on every test of a file. This file gets the marker
`system`.

patch$ tests/system/test_real_model.py

::: do
The patch adds a comment and the line `pytestmark = pytest.mark.system` under the imports.
:::

::: watch
In `tests/system/test_real_model.py`, the comment is on line 13, and `pytestmark` on line 14.
:::

$ just test -k real_model

pytest prints `1 passed`, and a warning, `PytestUnknownMarkWarning: Unknown pytest.mark.system - is this a typo?`.
pytest knows only the markers that it is told about. A marker with a typo in its name would choose no test, with no
error.

files:
- diff `tests/system/test_real_model.py`: the marker `system`.
  show: `pytestmark = pytest.mark.system`

### tut-23.3 pytest knows the marker system

`markers` in `pyproject.toml` declares each marker, with what it means.

patch$ pyproject.toml

::: do
In `[tool.pytest.ini_options]`, the patch adds a comment and the line `markers` under `addopts`.
:::

::: watch
In `pyproject.toml`, the comment is on line 62, and `markers` on line 63.
:::

$ just test -k real_model
$ just test --markers

The test passes with no warning. `just test --markers` lists every marker, and the first line is
`@pytest.mark.system: needs the network, the real model or a device`.

files:
- diff `pyproject.toml`: the marker `system`, declared.
  show: `markers = ["system: needs the network, the real model or a device"]`

### tut-23.4 just test leaves out the tests marked system

`-m` chooses the tests by their markers. `-m 'not system'` in `addopts` leaves out every test marked `system` from
every run. A `-m` on the command line comes after `addopts`, and wins.

patch$ pyproject.toml

::: do
The patch adds `-m 'not system'` at the end of `addopts`, and a line to the comment above it.
:::

::: watch
In `pyproject.toml`, the comment is on lines 60 and 61, and line 62 is
`addopts = "--cov=babykev --cov-report=term-missing -m 'not system'"`.
:::

$ just test
$ just test -m system

`just test` prints `82 passed, 1 deselected`, and the total of 92%, as before the test of the real model. `just check` runs
the same tests, so the gate and the hook never need the network. `just test -m system` runs the one test, and prints
`1 passed, 82 deselected`.

files:
- diff `pyproject.toml`: the tests marked `system` stay out of every run that does not ask for them.
  show: `addopts = "--cov=babykev --cov-report=term-missing -m 'not system'"`

### tut-23.5 The README names the test of the real model

The README says what `just test` runs, and how to run the test of the real model. The table gets a row for
`tests/system/`.

patch$ README.md

::: do
The patch adds a paragraph above the paragraph about `just hook`, and a row for `tests/system/` under the row of
`tests/unit/`.
:::

::: watch
In `README.md`, the new paragraph is on lines 69 to 71, and the row of `tests/system/` on line 88.
:::

$ just check

`just check` passes. The tests print `82 passed, 1 deselected`, and `Total coverage: 91.76%`. `just docs check` prints
`98 of 98`, with the test of the real model.

files:
- diff `README.md`: `just test -m system`, and the row of `tests/system/`.
  show: ``| `tests/system/` | The test of the real model, marked `system`. `just test -m system` runs it |``

## tut-24 The model, explained

$ just setup

`just setup` prints `Resolved 69 packages`.

The reference pages of the site give the signature and the docstring of each function of `model.py`. They do not say
why the model is built as it is. Two pages of a guide say it, in prose. The first gives the four ideas of the model,
and the second draws the mask as a grid. smalldocs runs no code, so a page holds its grids as text.

### tut-24.1 A page of the guide on the model

The page explains packing, the mask, the positions that restart, and pointing, and then what trains. A name in
backticks, such as `encode()`, links to its entry in the reference, as on the front page.

patch$ docs/guide/model.qmd

::: do
The patch makes the file, in a new folder `docs/guide`. Read the headings, then the part on the mask.
:::

::: watch
The new file `docs/guide/model.qmd` has five parts. Packing starts on line 9, the mask on line 33, the positions on
line 43, pointing on line 48, and what trains on line 57.
:::

$ just docs
$ grep -o 'href="../api/model.html#[^"]*"' docs/_site/guide/model.html

`just docs` prints `wrote 6 page(s) to docs/_site`. The sixth page is `docs/_site/guide/model.html`. `grep -o` prints
the eight links of the page into the reference of `model.py`, `encode` twice. The sidebar does not list the page yet.

files:
- file `docs/guide/model.qmd`: the four ideas of the model.
  show: `## Packing`

### tut-24.2 A page of the guide on the mask

The page draws the mask of the small request of `test_mask.py`, then the grid of a plain causal mask for the same
request. The first grid is the picture of the test, so `just test` keeps it true.

patch$ docs/guide/mask.qmd

::: do
The patch makes the file. Read the two grids.
:::

::: watch
The new file `docs/guide/mask.qmd` has the grid of the mask on lines 13 to 21. The grid of a plain causal mask is on
lines 33 to 41.
:::

$ just docs

`just docs` prints `wrote 7 page(s) to docs/_site`.

files:
- file `docs/guide/mask.qmd`: the mask, as a grid.
  show: `## A plain causal mask`

### tut-24.3 The guide in the sidebar

The sidebar of the site gets a section, Guide, between the front page and the reference. It names the two pages one
by one, so that the model comes before the mask. A pattern such as `guide/*` would list them in the order of their
names.

patch$ docs/_smalldocs.yml

::: do
The patch adds the section `Guide` under `index.qmd`, in the list `contents` of the sidebar.
:::

::: watch
In `docs/_smalldocs.yml`, the section `Guide` is on lines 11 to 14.
:::

$ just docs
$ grep -o 'href="guide/[^"]*"' docs/_site/index.html

`just docs` prints `wrote 7 page(s) to docs/_site`. `grep -o` prints the two links of the sidebar of the front page,
`guide/model.html` and then `guide/mask.html`.

files:
- diff `docs/_smalldocs.yml`: the section `Guide`.
  show: `      - section: Guide`

### tut-24.4 The front page names the guide

A paragraph of the front page links to the two pages.

patch$ docs/index.qmd

::: do
The patch adds a paragraph under the list of the modules.
:::

::: watch
In `docs/index.qmd`, the new paragraph is on lines 25 and 26.
:::

$ just docs
$ grep -o 'href="guide/[^"]*"' docs/_site/index.html

`grep -o` prints four links to the guide. The first two are in the sidebar, and the last two are in the new
paragraph.

files:
- diff `docs/index.qmd`: the links to the guide.
  show: ``The pages under Guide explain the model. [The model](guide/model.qmd) gives the four ideas of `model.py`, and``

### tut-24.5 The README names the guide

The row of `docs/` in the table of the README names the two pages.

patch$ README.md

::: do
The patch changes the row of `docs/` in the table.
:::

::: watch
In `README.md`, the row of `docs/` is on line 91.
:::

$ just check

`just check` passes. The tests print `82 passed, 1 deselected`, and `Total coverage: 91.76%`. `just docs check` prints
`98 of 98`. It checks the docments of the code, and does not read the pages of the guide.

files:
- diff `README.md`: the guide, in the row of `docs/`.
  show: ``The two pages of `docs/guide/` explain the model and its mask |``

## tut-25 Two images

$ just setup

`just setup` prints `Resolved 69 packages`.

So far everything ran on this Mac. A student may have Windows or Linux, and a platform that trains a model runs Linux
on a machine of someone else. An image of Docker is a Linux machine that one file describes, and Docker runs it on any
of these systems.

The `Dockerfile` of babykev builds two images from `uv.lock`. The run image holds the program and what it needs, and
starts `babykev`. The dev image holds the whole project and the tools to work on it, and starts a shell. The images
are built and run on this machine only, and pushed nowhere.

### tut-25.1 The Dockerfile, with the run image

A `Dockerfile` builds an image in stages, and each `FROM` starts one. The stage `uv` is the image of uv itself. The
stage `build` installs the environment into `/opt/venv`, with no group of the developers. The packages of `uv.lock`
come first, and the code after. Docker keeps each instruction of a build in its cache, so a change to the code installs one
package again, and not torch.

The stage `run` starts from a fresh Python, and takes only the finished environment and the sample data. uv stays in
the stage `build`.

patch$ Dockerfile

::: do
The patch makes the file. Read the three stages, from each `FROM`.
:::

::: watch
In the new file `Dockerfile`, the stage `uv` is on line 9, and the stage `build` on lines 13 to 25. The stage `run`
is on lines 28 to 36.
:::

$ docker build --target run --tag babykev-run .
$ docker run --rm babykev-run

`--target run` builds the stage `run` and the stages that it needs, and `--tag` names the image. `docker run --rm`
starts the image and removes the container when it stops. With no word, the image runs `babykev help`, from
`ENTRYPOINT` and `CMD` on lines 35 and 36, and prints the help.

$ docker image ls babykev-run:latest

The image takes about 1.1 GB, and torch is most of it.

$ docker run --rm -v ~/.cache/huggingface:/hf babykev-run smoke
$ uv run babykev smoke

`-v` mounts the cache of the Hugging Face Hub of this Mac at `/hf`, where `HF_HOME` on line 33 sends the library. So
the base model is not downloaded again.

The smoke in the container says `on cpu`. A container on a Mac runs Linux in a virtual
machine, and sees no GPU of Apple. `uv run babykev smoke` runs the same smoke on this Mac, on `mps`. Both print
`4 of 15 right`, and the same fifteen answers, with the same two decimals. A request takes much longer in the
container than on `mps`, and the milliseconds change from run to run.

files:
- file `Dockerfile`: the stages `uv`, `build` and `run`.
  show: `FROM python:3.13-slim-trixie AS run`

### tut-25.2 The dev image

The stage `dev` builds the image to work in. It installs git with `apt-get`, and copies uv and uvx. It installs just
as a wheel from PyPI. Then it installs the whole project with every group, into `/opt/venv`. The folder of this
machine can then be mounted at `/work`, and the image runs it with its own environment.

patch$ Dockerfile

::: do
The patch adds the dev image to the comment at the top of the file, and the stage `dev` at the end of the file.
:::

::: watch
In `Dockerfile`, the comment names the dev image on lines 5 and 6, and the stage `dev` is on lines 41 to 66. Line 64,
`COPY . .`, copies the folder of the project.
:::

$ docker build --target dev --tag babykev-dev .

The line `transferring context` gives what Docker read from the folder, about 760 to 830 MB. `COPY . .` copies the whole
folder, the `.venv` of this Mac too.

$ docker run --rm babykev-dev du -sh /work/.venv /opt/venv
$ docker image ls babykev-dev:latest

`du` prints about `800M` for `/work/.venv`, the environment of this Mac, built for macOS, which Linux cannot use.
`/opt/venv` is the environment of the image, 1.1G. The image takes about 2.1 GB.

files:
- diff `Dockerfile`: the stage `dev`.
  show: `FROM python:3.13-slim-trixie AS dev`

### tut-25.3 What a build never copies into an image

`.dockerignore` names the files that `docker build` never reads from the folder, as `.gitignore` names the files that
git never tracks. They are the history of git, the environment and the settings of this machine, and what a run or a
tool writes.

patch$ .dockerignore

::: do
The patch makes the file.
:::

::: watch
The new file `.dockerignore` names `.git` on line 3 and `.venv` on line 4, and twelve more paths.
:::

$ docker build --target dev --tag babykev-dev .
$ docker run --rm babykev-dev ls -A /work
$ docker image ls babykev-dev:latest

`ls -A` lists the folder in the image, with no `.git` and no `.venv`. The image takes about 1.4 GB.

The dev image can run every check, with this folder mounted at `/work`.

$ docker run --rm -v "$PWD":/work babykev-dev just check

`just check` passes in the image, on Linux. The tests print `82 passed, 1 deselected`, and the total of 91.76%.

files:
- file `.dockerignore`: what a build never copies.
  show: `.venv`

### tut-25.4 No example of hypothesis has a deadline

hypothesis gives each example of a test 200 ms. In a container, the first example that runs torch can take longer, and
the test then fails, by chance, with `DeadlineExceeded`. A run of the dev image failed so, once in five runs, and the
same test passed at the next run. A test that fails by chance cannot be a reason to refuse a `git commit`. The tests of the mask check a
rule, and not a speed, so a profile of hypothesis turns the deadline off for every test.

patch$ tests/conftest.py

::: do
The patch adds the import of `settings` from hypothesis, and under the imports a comment and two lines that register
the profile and load it.
:::

::: watch
In `tests/conftest.py`, the import is on line 10, the comment on lines 16 to 18, and the profile on lines 19 and 20.
:::

$ sed -n '16,20p' tests/conftest.py
$ docker run --rm -v "$PWD":/work babykev-dev just test -q

pytest reads `conftest.py` before any test, so the profile holds for the whole run. The dev image runs the folder of
this Mac, so the change needs no new build. The tests print `82 passed, 1 deselected`.

files:
- diff `tests/conftest.py`: no deadline, for every test that hypothesis feeds.
  show: `settings.register_profile("babykev", deadline=None)`

### tut-25.5 The recipe image

The recipe `image` runs the commands of the last moves. It has three words:

- `just image build dev` or `run` builds an image, and gives any other word to `docker build`.
- `just image shell` runs the dev image, with this folder at `/work`. The words before `--` go to `docker run`, and
  the words after it are the command to run. With no command, it starts a shell.
- `just image run` runs the program in the run image.

`shell` and `run` mount the cache of the Hub at `/hf`.

patch$ justfile

::: do
The patch adds the recipe `image` under the recipe `hook`, in the group `setup`.
:::

::: watch
In the `justfile`, the recipe `image` is on lines 36 to 67. `build` is on lines 47 to 52, `shell` on lines 53 to 61,
and `run` on lines 62 to 65.
:::

The commands behind the recipe ran in the last moves.

$ just --show image
$ just image build run
$ just image run smoke
$ just image shell -- just test -q

`just image build run` builds the run image. Docker takes each layer that it has built before from its cache, and
builds the others. `just image run smoke` prints
`4 of 15 right` again. `just image shell -- just test -q` prints `82 passed, 1 deselected`. Typed alone, `just image
shell` starts a shell in the image, where `exit` ends it.

files:
- diff `justfile`: the recipe `image`.
  show: `image *args:`

### tut-25.6 hadolint, in the group lint

hadolint is a linter for a `Dockerfile`. The package `hadolint-bin` holds its program, built for each system.

do$ uv add --group lint hadolint-bin

`uv add` prints `Resolved 70 packages`, and installs hadolint-bin.

::: watch
In `pyproject.toml`, the group `lint` has `"hadolint-bin>=2.15.1",` on line 44. `uv.lock` has its exact version.
:::

$ uv run hadolint --version

It prints `Haskell Dockerfile Linter` and its version.

files:
- diff `pyproject.toml`: hadolint, in the group `lint`.
  show: `"hadolint-bin>=2.15.1",`
- diff `uv.lock`: the exact version of hadolint.

### tut-25.7 lint-config runs hadolint

`just lint-config` checks the config files, and the `Dockerfile` is one of them. The command behind the new line comes
first.

patch$ justfile

::: do
In the recipe `lint-config`, the patch adds `uv run hadolint Dockerfile` after yamllint, and names the `Dockerfile`
in the comment above the recipe.
:::

::: watch
In the `justfile`, the comment on line 81 names the `Dockerfile`, and line 92 is `uv run hadolint Dockerfile`.
:::

$ uv run hadolint Dockerfile
$ just lint-config

hadolint prints `Dockerfile:44 DL3008 warning: Pin versions in apt get install.`, and ends with exit code 1.
`just lint-config` stops on the same line. Line 44 is the `apt-get install` of the dev image, which names no version
of git. This finding is real, and nothing was broken to make it.

files:
- diff `justfile`: hadolint, in `lint-config`.
  show: `    uv run hadolint Dockerfile`

### tut-25.8 DL3008, declined with its reason

DL3008 asks for the version of each package of Debian. Debian replaces a package at each fix of its security, and
the old version leaves the archive. So a pinned version stops building within weeks. The tag of the base image,
`python:3.13-slim-trixie`, fixes the release of Debian.

A comment says so, and a line tells hadolint to ignore DL3008 on the next instruction.

patch$ Dockerfile

::: do
The patch adds four comment lines above the `RUN apt-get update` of the dev image.
:::

::: watch
In `Dockerfile`, the reason is on lines 44 to 46, and `# hadolint ignore=DL3008` on line 47.
:::

$ just lint-config

`just lint-config` passes. hadolint prints nothing.

files:
- diff `Dockerfile`: the reason, and the line for hadolint.
  show: `# hadolint ignore=DL3008`

### tut-25.9 The README names the two images

The README gets a section on the images, with a table and the commands of the recipe. The table of the files gets a
row for the `Dockerfile` and `.dockerignore`.

patch$ README.md

::: do
The patch adds the section `The images` above `What is here`, and the row of the `Dockerfile` above the row of
`.python-version`.
:::

::: watch
In `README.md`, the section is on lines 77 to 99, and the row on line 118.
:::

The README says that every check passes in the dev image with no network. `--network none` gives the container no
network at all.

$ just image shell --network none -- just check

It fails before any check runs. uv cannot download hadolint-bin, with `dns error`. The dev image was built
before hadolint came into `uv.lock`, and `UV_LOCKED` makes uv install the packages of the lockfile first. An image
holds the packages of the lockfile at the time of its build.

$ just image build dev
$ just image shell --network none -- just check

`just check` passes in the new image, with no network. Every check of the gate is hermetic.

files:
- diff `README.md`: the section on the images, and the row of the `Dockerfile`.
  show: `## The images`

## tut-26 GitHub

$ just setup

`just setup` prints `Resolved 70 packages`.

The hook runs the gate before each `git commit`, on the machine where it runs. In a clone without the hook, git records
changes that never met the gate. Also, the docs site exists only on the machine that builds it.

GitHub runs workflows on its own machines. A workflow is a file of YAML in `.github/workflows/`, and its key `on` names
the events that start it. The first workflow runs the gate after every push, and the second builds the docs site and
publishes it on GitHub Pages. Nothing is pushed here. GitHub runs the workflows when the branch reaches it.

### tut-26.1 GitHub runs the gate after every push

The workflow `check.yaml` has one job. It takes the code, installs uv and just, and runs `just setup` and `just
check`, as a student does. It runs after a push to any branch and on every pull request. `branches: ["**"]` leaves
out a push of a tag.

patch$ .github/workflows/check.yaml

::: do
The patch makes the file, in a new folder `.github/workflows`. Read the key `on`, then what the job runs.
:::

::: watch
The new file `.github/workflows/check.yaml` has `on` on lines 5 to 8, and what the job `check` runs on lines 16
to 21.
:::

$ just lint-config

yamllint reads every YAML file, and the new file too. It prints `5:1 warning truthy value should be one of [false,
true] (truthy)`. `just lint-config` ends with exit code 2, because `--strict` makes a warning fail. YAML 1.1 reads the
word `on` as true. GitHub reads it as the name `on`, and every workflow has it. The next move answers it.

files:
- file `.github/workflows/check.yaml`: `just check`, after every push.
  show: `      - run: just check`

### tut-26.2 yamllint lets a key be a word such as on

The rule `truthy` of yamllint has the option `check-keys`. With `false`, the rule checks the values and not the keys.
A value of `on` or `yes` is still a warning.

patch$ .yamllint

::: do
The patch adds the rule `truthy` at the end of `.yamllint`.
:::

::: watch
In `.yamllint`, line 7 is `truthy: {check-keys: false}`, with its reason.
:::

$ just lint-config

`just lint-config` passes.

files:
- diff `.yamllint`: the rule `truthy` checks no key.
  show: `  truthy: {check-keys: false}  # a key may be a word such as on, which YAML 1.1 reads as true`

### tut-26.3 actionlint, in the group lint

yamllint checks that a workflow is good YAML, and knows nothing of GitHub. actionlint is a linter for the workflows of
GitHub. It checks the events, the jobs, the actions and their inputs. The package `actionlint-py` holds its program,
built for each system.

do$ uv add --group lint actionlint-py

`uv add` prints `Resolved 71 packages`, and installs actionlint-py.

::: watch
In `pyproject.toml`, the group `lint` has `"actionlint-py>=1.7.12.25",` on line 44. `uv.lock` has its exact version.
:::

$ uv run actionlint --version

The first line is the version of actionlint.

files:
- diff `pyproject.toml`: actionlint, in the group `lint`.
  show: `"actionlint-py>=1.7.12.25",`
- diff `uv.lock`: the exact version of actionlint.

### tut-26.4 lint-config runs actionlint

actionlint finds the workflows of the project itself, in `.github/workflows/`. The command behind the new line comes
first.

patch$ justfile

::: do
In the recipe `lint-config`, the patch adds `uv run actionlint` after hadolint, and names the workflows in the comment
above the recipe.
:::

::: watch
In the `justfile`, the comment on line 81 names the workflows, and line 93 is `uv run actionlint`.
:::

$ uv run actionlint
$ just lint-config

actionlint prints nothing, and ends with exit code 0. It finds no problem in `check.yaml`. `just lint-config` passes.

files:
- diff `justfile`: actionlint, in `lint-config`.
  show: `    uv run actionlint`

### tut-26.5 GitHub Pages publishes the docs

The workflow `docs.yaml` has two jobs. The job `build` installs the package and the group `docs`, and no other group.
It runs `smalldocs render docs`, the command behind `just docs`, and gives the folder `docs/_site` to Pages. The job
`deploy` publishes it. The workflow runs after a push to `main`, and a person can also run it from the tab Actions.

patch$ .github/workflows/docs.yaml

::: do
The patch makes the file. Read the key `on`, the lines under `permissions`, and the line that renders the site.
:::

::: watch
In the new file `.github/workflows/docs.yaml`, `on` is on lines 6 to 9, and `permissions` on lines 11 to 14. Line 26
renders the site with the group `docs` alone.
:::

$ uv run actionlint
$ uv run --isolated --locked --no-default-groups --group docs smalldocs render docs

actionlint prints nothing. `--no-default-groups --group docs` installs the package and the group `docs`, as the job
does. `--isolated` runs the command in a temporary environment, and leaves `.venv` as it is. It prints `wrote 7
page(s) to docs/_site`.

The workflows run only where two settings on GitHub allow them. A fork runs no workflow until its owner turns the
workflows on, on the tab **Actions**. Pages publishes from a workflow when **Settings**, then **Pages**, has the source
**GitHub Actions**. The README says so in the next move.

files:
- file `.github/workflows/docs.yaml`: the docs site, built with the group `docs` alone, then published.
  show: `      - run: uv run --locked --no-default-groups --group docs smalldocs render docs`

### tut-26.6 The README names the workflows

The README gets a section on GitHub, with the two settings that a fork needs. The table gets a row for
`.github/workflows/`.

patch$ README.md

::: do
The patch adds the section `On GitHub` above `What is here`, and the row of `.github/workflows/` above the row of
`.yamllint`.
:::

::: watch
In `README.md`, the section is on lines 100 to 112, and the row on line 135.
:::

$ just check

`just check` passes. The tests print `82 passed, 1 deselected`, and `Total coverage: 91.76%`. The last lines of
`lint-config` print nothing, because yamllint, hadolint and actionlint find nothing.

files:
- diff `README.md`: the section on GitHub, and the row of the workflows.
  show: `## On GitHub`
