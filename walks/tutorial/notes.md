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
`pyproject.toml`. Here it prints `Resolved 1 package` and `Checked 1 package`, because `.venv` is already right.

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

`just setup` prints `Resolved 1 package` and `Checked 1 package`, because `.venv` already matches `uv.lock`.

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

$ just test -k unknown

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
an answer is. kev wrote this agreement in a file, `api.py`, and we call it the contract. It comes in as kev wrote it.

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
`pydantic v2.14.1`, and the group `test` with pytest and pytest-cov.

files:
- diff `pyproject.toml`: the first dependency. `>=2.14.1` is the version that `uv add` found, as the lowest version to
  accept.
  show: `"pydantic>=2.14.1",`
- diff `uv.lock`: pydantic and the four packages it needs, each with its exact version.

### tut-03.2 api.py of kev, as he wrote it

babykev has no contract yet. kev's `api.py` says what a request is and what an answer is. It comes in as kev wrote it,
all 111 lines, so that we read his code before we change it.

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
