<!-- Made by the walk skill's render.py from the facts of the walk. Do not edit it by hand: run just walk-update again. -->

# The tests of babykev

**Read the tutorial.** Each change explained, with the code to look at. [Build it yourself](build.md) is the other way to read it.

Each part ends with a section called **What changed**. It lists every file that the part changes, with a link to the file, and then the whole diff of each file, folded. A lockfile and a binary file have a link alone. The text above it explains the change.

We build the tests of babykev, a small decision model. babykev reads a text and a set of questions about it, and gives
a probability for every answer. A test runs the code and checks what it gives back, so a later change cannot break
babykev without a failure. This tutorial takes the parts about tests out of the whole tutorial of babykev. It starts
from the project that uv made, with the command `babykev` and a justfile. It leaves out the formatter, the linter,
the types, the docs and the images of Docker.

We make the project in moves. A move is one small change, made by one patch or by one command. A patch changes a
file, and a command such as `uv add` writes the files it needs. You make each move, and the page checks your files
against it.

The tests come in four kinds. Each kind comes in where the table says, and no test comes in for the sake of a kind.

| Kind | What it runs | What it needs | Where |
|---|---|---|---|
| Unit | One function alone, such as a rule of the contract or the packing of a request | Nothing but our code | From the first tests of the command |
| Integration | Several of our parts together, such as the packing, the mask and the head | The tiny model, built in memory | From the first test of the model |
| Property | A rule of the mask, on many shapes of request that hypothesis picks | hypothesis | The tests of the mask |
| System | The whole program, with the real model | The Hugging Face Hub, or its cache | The last test of the model |

Some changes of the whole tutorial are not in this one. After such a gap, the next section says what those changes
did, and starts from the code that they left. It first runs `just setup`, which installs the packages of that code.

Two tools run everything here. [uv](https://docs.astral.sh/uv/) manages the project. It installs Python and the packages, keeps them in `.venv`, and pins their versions in `uv.lock`. [just](https://just.systems/) runs the tasks of the project by name, from the recipes of its `justfile`. `just setup`, for example, runs `uv sync`.

<a id="tut-02"></a>

## 2 pytest, the first tests and coverage

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-01`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-01)

babykev has one piece of code, the command `babykev`, in `src/babykev/cli.py`. The first tests are of the command.
Then coverage counts the lines of babykev that the tests run.

```bash
just setup
```

`just setup` prints `Resolved 1 package`, and `Checked 1 package` when `.venv` already matches `uv.lock`. In a new
clone, it first makes `.venv`, and installs babykev.

We cannot tell whether `babykev` still works after a change, unless we run it by hand and read what it prints. Tests
run it for us. pytest finds the tests and runs them, and a recipe `just test` runs pytest. The first tests are of the
command, the only code that babykev has. Last, coverage shows which lines the tests run.

<a id="tut-02.1"></a>

### 2.1 uv installs every dependency group

The tests need pytest, and a package of babykev does not. A person who installs babykev should not get pytest. So the
tools of the project go in dependency groups. A dependency group is a list of packages in `pyproject.toml` that the
project needs while we work on it. A user of the package never gets them. The test tools go in a group `test`, and
later the linters and the docs tools get groups of their own.

uv installs only the group `dev` by default. The setting `default-groups = "all"` makes `uv sync` and `uv run`
install every group. So each later `uv add --group` needs no other change to `pyproject.toml`. A patch adds the
table `[tool.uv]` with this setting.

[± See the change to `pyproject.toml`](#tut-02.1-pyproject.toml-5d07e7)

At the end of `pyproject.toml`, the new table `[tool.uv]` has the line `default-groups = "all"`, with a comment above
it.

The setting changes which groups uv installs, and not which versions. So `uv.lock` still matches `pyproject.toml`.

```bash
uv lock --check
```

uv prints `Resolved 1 package`, and no error. The project has no groups yet, so the setting changes nothing until a
later move adds one.

#### What changed

- <a id="tut-02.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the table `[tool.uv]`, so uv installs every dependency group. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/ad616a5cc1fcdf5b7c1672b79d0d2b267b72bd59/pyproject.toml).
  - look at `default-groups = "all"`

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -15,3 +15,7 @@ babykev = "babykev.cli:main"
 [build-system]
 requires = ["uv_build>=0.12.13,<0.13.0"]
 build-backend = "uv_build"
+
+[tool.uv]
+# uv sync and uv run install every dependency group, not only dev
+default-groups = "all"
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ad616a5cc1fcdf5b7c1672b79d0d2b267b72bd59). [The code after it](https://github.com/rahuldave/babykev/tree/ad616a5cc1fcdf5b7c1672b79d0d2b267b72bd59).

<a id="tut-02.2"></a>

### 2.2 Pytest, in the group test

Nothing runs tests yet. pytest finds the tests and runs them. It goes into the group `test`.

[pytest](https://docs.pytest.org/) is the test runner of most Python projects. It finds every file `test_*.py`, runs each function whose name starts with `test_`, and reports each failure with the values that made it fail. A test is a plain function with `assert` in it.

This change came from running `uv add --group test pytest`.

`uv add --group test` writes the group `test` in `pyproject.toml`, under `[dependency-groups]`. It prints
`Resolved 7 packages`, and lists pytest and the four packages it needs.

At the end of `pyproject.toml`, the new table `[dependency-groups]` has the group `test`, with the line
`"pytest>=9.1.1",`. `uv.lock` has pytest and the five packages it needs. One of them, colorama, is only for Windows,
so on a Mac or on Linux uv installs the other four.

```bash
uv run pytest
```

`uv run pytest` looks for tests and finds none. It prints `collected 0 items` and `no tests ran`, and ends with exit
code 5. pytest uses exit code 5 to say that it found no test.

#### What changed

- <a id="tut-02.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: the group `test`, with pytest. 5 lines added. It comes from `uv add --group test pytest`. [The file](https://github.com/rahuldave/babykev/blob/966956d738b58505e23586af60f05cd5daceb12f/pyproject.toml).
  - look at `"pytest>=9.1.1",`
- <a id="tut-02.2-uv.lock-8356d8"></a>`uv.lock`: pytest and the five packages it needs. 71 lines added. It comes from `uv add --group test pytest`. [The file](https://github.com/rahuldave/babykev/blob/966956d738b58505e23586af60f05cd5daceb12f/uv.lock).

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -19,3 +19,8 @@ build-backend = "uv_build"
 [tool.uv]
 # uv sync and uv run install every dependency group, not only dev
 default-groups = "all"
+
+[dependency-groups]
+test = [
+    "pytest>=9.1.1",
+]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/966956d738b58505e23586af60f05cd5daceb12f). [The code after it](https://github.com/rahuldave/babykev/tree/966956d738b58505e23586af60f05cd5daceb12f).

<a id="tut-02.3"></a>

### 2.3 The recipe test

The command that runs the tests is `uv run pytest`, and every task of the project has a recipe. A recipe `test` gives
the command a short name.

[± See the change to `justfile`](#tut-02.3-justfile-424f0b)

At the end of `justfile`, the recipe `test` runs `uv run pytest "$@"`. It sits under a new heading, `quality`.

`test` gives every word after its name to pytest, as `"$@"`. So `just test -k help` runs `uv run pytest -k help`. The
word `help` alone prints the line of the recipe. pytest prints what failed, so `[no-exit-message]` stops `just` from
adding a line of its own when pytest ends with an error.

```bash
just --show test
just test
just help test
```

`just --show test` prints the recipe. `just test` runs pytest, which finds no test, prints `no tests ran` and ends with
exit code 5. `just` prints no line of its own about the error. `just help test` prints the line of the recipe.

#### What changed

- <a id="tut-02.3-justfile-424f0b"></a>`justfile`: the recipe `test`. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/b0840709e371a548d4b922c57c679ba040dd2c1a/justfile).
  - look at `test *args:`

<details><summary>The diff of <code>justfile</code></summary>

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

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b0840709e371a548d4b922c57c679ba040dd2c1a). [The code after it](https://github.com/rahuldave/babykev/tree/b0840709e371a548d4b922c57c679ba040dd2c1a).

<a id="tut-02.4"></a>

### 2.4 A test of the help

pytest runs, but there is nothing to run. The command is the only code of babykev, so its tests come first. A test is
a function whose name starts with `test_`, in a file whose name starts with `test_`. A test passes when none of its
`assert` lines fails.

The first test runs `babykev` with no word, then with `help`, `--help` and `-h`, and checks that each prints the help.

[± See the new file `tests/unit/test_cli.py`](#tut-02.4-tests-unit-test_cli.py-44d4a0)

The new file `tests/unit/test_cli.py` has the helper `run`, and the test `test_help_is_printed_for_help_and_for_no_words`.

`run` sets `sys.argv`, the words of the command line, and calls `main`, as if `babykev` had been typed at a terminal.
`monkeypatch` and `capsys` are fixtures of pytest. A test names a fixture as an argument, and pytest passes it in.
`monkeypatch.setattr` changes `sys.argv` for this test alone, and puts it back after the test. `capsys` catches what
the program prints. `@pytest.mark.parametrize` runs the test once for each of its four values.

```bash
just test
```

`just test` prints `collected 4 items`, then `4 passed`. One function makes four tests.

#### What changed

- <a id="tut-02.4-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: one test, for four ways of asking for help. New, 18 lines. [The file](https://github.com/rahuldave/babykev/blob/72678bd1d656f5bc6e44f2d65b44a1e18b024661/tests/unit/test_cli.py).
  - look at `@pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])`

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -0,0 +1,18 @@
+"""Unit tests for the `babykev` command: `help` prints the help, any other word is refused."""
+
+import pytest
+
+from babykev.cli import HELP, main
+
+
+def run(monkeypatch, *words):
+    """Run `babykev` with these words as its command line."""
+    monkeypatch.setattr("sys.argv", ["babykev", *words])
+    main()
+
+
+@pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])
+def test_help_is_printed_for_help_and_for_no_words(monkeypatch, capsys, words):
+    """`babykev`, `babykev help`, `--help` and `-h` all print the help text, and nothing else."""
+    run(monkeypatch, *words)
+    assert capsys.readouterr().out == HELP
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/72678bd1d656f5bc6e44f2d65b44a1e18b024661). [The code after it](https://github.com/rahuldave/babykev/tree/72678bd1d656f5bc6e44f2d65b44a1e18b024661).

<a id="tut-02.5"></a>

### 2.5 A test of an unknown command

The tests check the help, and nothing checks what `babykev` does with a word it does not know. A second test runs
`babykev train`. It checks that the command ends with exit code 2, and that the message names the word and points to
the help.

[± See the change to `tests/unit/test_cli.py`](#tut-02.5-tests-unit-test_cli.py-44d4a0)

At the end of `tests/unit/test_cli.py`, the new test runs `train` inside `pytest.raises(SystemExit)`.

`pytest.raises(SystemExit)` passes only when the code inside it ends the program. The test then checks the exit code,
2, and the two parts of the message.

```bash
just test -k unknown_command
```

`-k unknown` runs the tests with `unknown` in their name. pytest prints `5 items / 4 deselected / 1 selected` and
`1 passed`.

#### What changed

- <a id="tut-02.5-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: the test of a word that is not a command. 10 lines added. [The file](https://github.com/rahuldave/babykev/blob/9a4100fd1962921bc11cf9f4b22c5326c7a51807/tests/unit/test_cli.py).
  - look at `assert exit_info.value.code == 2`

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -16,3 +16,13 @@ def test_help_is_printed_for_help_and_for_no_words(monkeypatch, capsys, words):
     """`babykev`, `babykev help`, `--help` and `-h` all print the help text, and nothing else."""
     run(monkeypatch, *words)
     assert capsys.readouterr().out == HELP
+
+
+def test_an_unknown_command_is_refused_with_exit_code_2(monkeypatch, capsys):
+    """A word that is not a command is named, the help is pointed to, and the exit code is 2."""
+    with pytest.raises(SystemExit) as exit_info:
+        run(monkeypatch, "train")
+    assert exit_info.value.code == 2
+    err = capsys.readouterr().err
+    assert "no command named 'train'" in err
+    assert "babykev help" in err
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9a4100fd1962921bc11cf9f4b22c5326c7a51807). [The code after it](https://github.com/rahuldave/babykev/tree/9a4100fd1962921bc11cf9f4b22c5326c7a51807).

<a id="tut-02.6"></a>

### 2.6 pytest looks for tests in tests/

pytest looks for tests in every folder of the project. The tests are all in `tests/`, and a setting says so.
`testpaths` in the table `[tool.pytest.ini_options]` names the folder.

[± See the change to `pyproject.toml`](#tut-02.6-pyproject.toml-5d07e7)

At the end of `pyproject.toml`, the new table `[tool.pytest.ini_options]` has `testpaths = ["tests"]`.

```bash
just test
```

`just test` prints `testpaths: tests` and `5 passed`.

#### What changed

- <a id="tut-02.6-pyproject.toml-5d07e7"></a>`pyproject.toml`: the settings of pytest. pytest looks for tests in `tests/` alone. 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/348290a934c2bd1da0a38f4c3336f66758f8523c/pyproject.toml).
  - look at `testpaths = ["tests"]`

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -24,3 +24,6 @@ default-groups = "all"
 test = [
     "pytest>=9.1.1",
 ]
+
+[tool.pytest.ini_options]
+testpaths = ["tests"]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/348290a934c2bd1da0a38f4c3336f66758f8523c). [The code after it](https://github.com/rahuldave/babykev/tree/348290a934c2bd1da0a38f4c3336f66758f8523c).

<a id="tut-02.7"></a>

### 2.7 Pytest-cov, in the group test

The tests pass, but nothing says which lines of babykev they run. Coverage measures that. pytest-cov is a plugin of
pytest that measures it, when pytest gets the option `--cov`. It goes in the group `test`.

[pytest-cov](https://pytest-cov.readthedocs.io/) connects pytest to [coverage.py](https://coverage.readthedocs.io/), which records each line of the code that the tests run. The report then names the lines that no test reaches. A line that no test runs can break without any test failing.

This change came from running `uv add --group test pytest-cov`.

`uv add` puts pytest-cov in the group `test`. It prints `Resolved 9 packages`, and installs `coverage` and
`pytest-cov`.

In `pyproject.toml`, the group `test` now has `"pytest-cov>=7.1.0",` under pytest. `uv.lock` has pytest-cov 7.1.0, and
coverage 7.16.2, which it needs.

```bash
just test --cov=babykev
```

`just test` prints `5 passed`, and a table under the tests. `cli.py` has 8 statements, and the tests run all of them,
100%. pytest-cov writes its data into `.coverage`, and `.gitignore` already names it.

#### What changed

- <a id="tut-02.7-pyproject.toml-5d07e7"></a>`pyproject.toml`: pytest-cov in the group `test`. 1 line added. It comes from `uv add --group test pytest-cov`. [The file](https://github.com/rahuldave/babykev/blob/326e444b726a914d5f9d0138ca658ed89a979dcd/pyproject.toml).
  - look at `"pytest-cov>=7.1.0",`
- <a id="tut-02.7-uv.lock-8356d8"></a>`uv.lock`: coverage and pytest-cov. 103 lines added, 1 removed. It comes from `uv add --group test pytest-cov`. [The file](https://github.com/rahuldave/babykev/blob/326e444b726a914d5f9d0138ca658ed89a979dcd/uv.lock).

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -23,6 +23,7 @@ default-groups = "all"
 [dependency-groups]
 test = [
     "pytest>=9.1.1",
+    "pytest-cov>=7.1.0",
 ]
 
 [tool.pytest.ini_options]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/326e444b726a914d5f9d0138ca658ed89a979dcd). [The code after it](https://github.com/rahuldave/babykev/tree/326e444b726a914d5f9d0138ca658ed89a979dcd).

<a id="tut-02.8"></a>

### 2.8 Coverage on every run of the tests

A person can forget to type `--cov=babykev`. `addopts` gives pytest options on every run. `--cov=babykev` measures
the package babykev, and `--cov-report=term-missing` adds a column of the lines that no test ran.

[± See the change to `pyproject.toml`](#tut-02.8-pyproject.toml-5d07e7)

At the end of `pyproject.toml`, `addopts` stands under `testpaths`, with a comment above it.

```bash
just test
```

`just test` prints the table with a column `Missing`, empty, because the tests run every line of `cli.py`.

#### What changed

- <a id="tut-02.8-pyproject.toml-5d07e7"></a>`pyproject.toml`: the options of every run. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/f44cc53a91bc7db84283d6a9ded16d9a7bbedf90/pyproject.toml).
  - look at `addopts = "--cov=babykev --cov-report=term-missing"`

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -28,3 +28,5 @@ test = [
 
 [tool.pytest.ini_options]
 testpaths = ["tests"]
+# Every run measures how much of src/babykev the tests run, and lists the lines they do not
+addopts = "--cov=babykev --cov-report=term-missing"
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f44cc53a91bc7db84283d6a9ded16d9a7bbedf90). [The code after it](https://github.com/rahuldave/babykev/tree/f44cc53a91bc7db84283d6a9ded16d9a7bbedf90).

<a id="tut-02.9"></a>

### 2.9 The README says to run just test

"Start" in the README does not name `just test`. Its paragraph now says to run it, and that a recipe gives its extra
words to the tool behind it.

[± See the change to `README.md`](#tut-02.9-README.md-8ec9a0)

In `README.md`, "Start" now says to run `just test`, and gives `just test -k help` as an example.

```bash
just test -k help
```

pytest runs the 4 tests with `help` in their name, and prints `4 passed, 1 deselected`.

#### What changed

- <a id="tut-02.9-README.md-8ec9a0"></a>`README.md`: `just test` in "Start". 3 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/ab192e5bd8ff3e3b8ad6c0ae5e17be31b7790557/README.md).
  - look at `help of the program itself. A recipe gives its extra words to the tool behind it. For example,`

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -54,8 +54,9 @@ Install two tools on your machine, uv and just. The project installs everything
 ## Start
 
 Run `just setup` first. It installs Python and every dependency into `.venv`, exactly as `uv.lock` says.
-Then `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is the help of the
-program itself.
+Then run `just test`. `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is the
+help of the program itself. A recipe gives its extra words to the tool behind it. For example,
+`just test -k help` runs only the tests with `help` in their name.
 
 ## What is here
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ab192e5bd8ff3e3b8ad6c0ae5e17be31b7790557). [The code after it](https://github.com/rahuldave/babykev/tree/ab192e5bd8ff3e3b8ad6c0ae5e17be31b7790557).

<a id="tut-02.10"></a>

### 2.10 The README names the tests

The table of "What is here" has no row for the tests. A row for `tests/unit/` comes in. The row of `pyproject.toml`
now says that it has the settings of the tools too.

[± See the change to `README.md`](#tut-02.10-README.md-8ec9a0)

In the table of `README.md`, the new row names `tests/unit/` and `test_cli.py`.

```bash
just setup
just test
```

`just setup` prints `Resolved 9 packages` and `Checked 8 packages`. One of the 9, colorama, is for Windows alone, so
uv installs 8 here. `just test` prints `5 passed`.

#### What changed

- <a id="tut-02.10-README.md-8ec9a0"></a>`README.md`: the row of the tests. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/4640589d80e4f224a4b2c1fd9567e952f564f102/README.md).
  - look at ``| `tests/unit/` | The unit tests. `test_cli.py` tests the command `babykev` |``

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -62,8 +62,9 @@ help of the program itself. A recipe gives its extra words to the tool behind it
 
 | Path | What it is |
 |---|---|
-| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, and the exact versions to install |
+| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, the settings of its tools, and the exact versions to install |
 | `src/babykev/` | The code. `cli.py` is the command `babykev` |
+| `tests/unit/` | The unit tests. `test_cli.py` tests the command `babykev` |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `README.md` | This file |
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4640589d80e4f224a4b2c1fd9567e952f564f102).

This part ends at the code at `tut-02`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-02)

<a id="tut-04"></a>

## 4 Tests of the contract

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-03`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-03)

The whole tutorial then adds the contract, `src/babykev/api.py`. It says what a request is and what an answer is,
with pydantic, a library that checks the shape of data. Five sample requests about cheese go in
`data/cheese/sample.jsonl`. No test reaches the contract, so the coverage falls to 11%.

The tests here check the sample requests against the contract, then each rule of the contract, one at a time.

```bash
just setup
```

The contract says what a request is, and no test checks it. The tests of this part check the five sample requests
against the contract. Then they check what the contract accepts and refuses, one rule at a time. They go in
`tests/unit/test_api.py`, one test in each move.

<a id="tut-04.1"></a>

### 4.1 Every line of the sample data fits the contract

The first test of `api.py` checks each of the five sample requests against the contract. `SAMPLE_LINES` reads the
file. `parametrize` gives the test each line in turn. `model_validate` checks the line, and raises an error if it does
not fit.

[± See the new file `tests/unit/test_api.py`](#tut-04.1-tests-unit-test_api.py-58d97c)

The new file `tests/unit/test_api.py` reads the sample data into `SAMPLE_LINES`, and has one test,
`test_sample_line_fits_the_contract`.

```bash
just test
```

`just test` prints `10 passed`, the 5 of the command and one for each sample line. `api.py` is at 77%. The missing
lines are the functions that turn probabilities into answers.

#### What changed

- <a id="tut-04.1-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the sample data, and the test that checks each line. New, 27 lines. [The file](https://github.com/rahuldave/babykev/blob/5e134165b7e1feeded775bcfb2269aec951ad39f/tests/unit/test_api.py).
  - look at `def test_sample_line_fits_the_contract(line):`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -0,0 +1,27 @@
+"""Unit tests of the contract in `babykev.api`: validation, rendering, mappings, confidences."""
+
+import json
+from pathlib import Path
+
+import pytest
+
+from babykev.api import SystemOneRequest, to_record
+
+SAMPLE = Path(__file__).parents[2] / "data" / "cheese" / "sample.jsonl"
+SAMPLE_LINES = [json.loads(line) for line in SAMPLE.read_text(encoding="utf-8").splitlines()]
+
+MILKS = {"cow": None, "goat": None, "sheep": None, "mixed": "More than one kind of milk"}
+FIRMNESS = ["Soft", "Semi-soft", "Semi-hard", "Hard"]
+
+
+# The sample data
+
+
+@pytest.mark.parametrize("line", SAMPLE_LINES)
+def test_sample_line_fits_the_contract(line):
+    """Every line of the sample data is a valid request, with one record question per question."""
+    request = SystemOneRequest.model_validate(line)
+    record, meta = to_record(request)
+    assert record["state"]
+    assert [m["id"] for m in meta] == list(line["questions"])
+    assert all(len(q["options"]) >= 2 for q in record["questions"])
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5e134165b7e1feeded775bcfb2269aec951ad39f). [The code after it](https://github.com/rahuldave/babykev/tree/5e134165b7e1feeded775bcfb2269aec951ad39f).

<a id="tut-04.2"></a>

### 4.2 Every question of the sample data has a label

The tests will compare answers with labels, so each label must have the right kind. A label is a boolean for a noul,
the name of an option for a choice, and the number of a level for a score.

[± See the change to `tests/unit/test_api.py`](#tut-04.2-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the new test checks the label of every question of each line.

```bash
just test -k label
```

pytest runs the new test once for each line, and prints `5 passed`.

#### What changed

- <a id="tut-04.2-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the labels of the sample data. 13 lines added. [The file](https://github.com/rahuldave/babykev/blob/1ca39523b4fdf6c75c244b8c0e0f2371593cfbff/tests/unit/test_api.py).
  - look at `def test_sample_line_has_a_usable_label_on_every_question(line):`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -25,3 +25,16 @@ def test_sample_line_fits_the_contract(line):
     assert record["state"]
     assert [m["id"] for m in meta] == list(line["questions"])
     assert all(len(q["options"]) >= 2 for q in record["questions"])
+
+
+@pytest.mark.parametrize("line", SAMPLE_LINES)
+def test_sample_line_has_a_usable_label_on_every_question(line):
+    """A label is a boolean for noul, an option name for choice, and a level index for score."""
+    for question in line["questions"].values():
+        label = question["label"]
+        if question["type"] == "noul":
+            assert isinstance(label, bool)
+        elif question["type"] == "choice":
+            assert label in question["criteria"]
+        else:
+            assert label in range(len(question["criteria"]))
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1ca39523b4fdf6c75c244b8c0e0f2371593cfbff). [The code after it](https://github.com/rahuldave/babykev/tree/1ca39523b4fdf6c75c244b8c0e0f2371593cfbff).

<a id="tut-04.3"></a>

### 4.3 A request holds one model for each type of question

The field `type` of a question decides which class of the contract it becomes. A helper, `cheese_request`, makes one
request with a question of each type, for the tests to share. The test checks that the noul is a `Noul`, the choice a
`Choice` and the score a `Score`.

[± See the change to `tests/unit/test_api.py`](#tut-04.3-tests-unit-test_api.py-58d97c)

In `tests/unit/test_api.py`, `cheese_request` stands under the constants. The new test at the end checks the class of
each of its three questions.

```bash
just test -k one_model
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.3-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the helper, and the test of the three types. 32 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/847d160f4a2f014bd58eb06030268ce762577cbc/tests/unit/test_api.py).
  - look at `def test_request_holds_one_model_per_question_type():`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -5,7 +5,13 @@ from pathlib import Path
 
 import pytest
 
-from babykev.api import SystemOneRequest, to_record
+from babykev.api import (
+    Choice,
+    Noul,
+    Score,
+    SystemOneRequest,
+    to_record,
+)
 
 SAMPLE = Path(__file__).parents[2] / "data" / "cheese" / "sample.jsonl"
 SAMPLE_LINES = [json.loads(line) for line in SAMPLE.read_text(encoding="utf-8").splitlines()]
@@ -14,6 +20,20 @@ MILKS = {"cow": None, "goat": None, "sheep": None, "mixed": "More than one kind
 FIRMNESS = ["Soft", "Semi-soft", "Semi-hard", "Hard"]
 
 
+def cheese_request():
+    """One request that asks a question of each type."""
+    return SystemOneRequest.model_validate(
+        {
+            "state": {"cheese": "Roquefort", "origin": "France"},
+            "questions": {
+                "blue": {"type": "noul", "instructions": "Is this a blue cheese?"},
+                "milk": {"type": "choice", "instructions": "Which milk?", "criteria": MILKS},
+                "firmness": {"type": "score", "instructions": "How firm?", "criteria": FIRMNESS},
+            },
+        }
+    )
+
+
 # The sample data
 
 
@@ -38,3 +58,14 @@ def test_sample_line_has_a_usable_label_on_every_question(line):
             assert label in question["criteria"]
         else:
             assert label in range(len(question["criteria"]))
+
+
+# Validation
+
+
+def test_request_holds_one_model_per_question_type():
+    """The `type` field decides which model a question becomes."""
+    questions = cheese_request().questions
+    assert isinstance(questions["blue"], Noul)
+    assert isinstance(questions["milk"], Choice)
+    assert isinstance(questions["firmness"], Score)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/847d160f4a2f014bd58eb06030268ce762577cbc). [The code after it](https://github.com/rahuldave/babykev/tree/847d160f4a2f014bd58eb06030268ce762577cbc).

<a id="tut-04.4"></a>

### 4.4 A request without questions is refused

A request must ask at least one question. `Field(min_length=1)` on `questions` says so. The test checks that pydantic
refuses a request with none.

[± See the change to `tests/unit/test_api.py`](#tut-04.4-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the new test expects a `ValidationError` for `"questions": {}`.

```bash
just test -k without_questions
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.4-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a request with no questions. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/c2af99cdd8e0b6f40e33a1ebcf9aa602904a83ba/tests/unit/test_api.py).
  - look at `def test_request_without_questions_is_rejected():`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -4,6 +4,7 @@ import json
 from pathlib import Path
 
 import pytest
+from pydantic import ValidationError
 
 from babykev.api import (
     Choice,
@@ -69,3 +70,9 @@ def test_request_holds_one_model_per_question_type():
     assert isinstance(questions["blue"], Noul)
     assert isinstance(questions["milk"], Choice)
     assert isinstance(questions["firmness"], Score)
+
+
+def test_request_without_questions_is_rejected():
+    """A request must ask at least one question."""
+    with pytest.raises(ValidationError):
+        SystemOneRequest.model_validate({"state": "Brie", "questions": {}})
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c2af99cdd8e0b6f40e33a1ebcf9aa602904a83ba). [The code after it](https://github.com/rahuldave/babykev/tree/c2af99cdd8e0b6f40e33a1ebcf9aa602904a83ba).

<a id="tut-04.5"></a>

### 4.5 An unknown type of question is refused

Only noul, choice and score exist. The test gives a question the type `essay`, and expects a refusal.

[± See the change to `tests/unit/test_api.py`](#tut-04.5-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the new test makes a question of type `essay`.

```bash
just test -k unknown_question
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.5-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a type that does not exist. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/6acc5e7d6f228ce76a9083d915f238c3d6696c85/tests/unit/test_api.py).
  - look at `question = {"type": "essay", "instructions": "Describe this cheese."}`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -76,3 +76,10 @@ def test_request_without_questions_is_rejected():
     """A request must ask at least one question."""
     with pytest.raises(ValidationError):
         SystemOneRequest.model_validate({"state": "Brie", "questions": {}})
+
+
+def test_unknown_question_type_is_rejected():
+    """Only noul, choice and score exist."""
+    question = {"type": "essay", "instructions": "Describe this cheese."}
+    with pytest.raises(ValidationError):
+        SystemOneRequest.model_validate({"state": "Brie", "questions": {"q": question}})
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/6acc5e7d6f228ce76a9083d915f238c3d6696c85). [The code after it](https://github.com/rahuldave/babykev/tree/6acc5e7d6f228ce76a9083d915f238c3d6696c85).

<a id="tut-04.6"></a>

### 4.6 A noul needs no criteria

A question of yes or no may leave out what yes and no mean. The test makes a `Noul` with no criteria, and checks that
its criteria are `None`.

[± See the change to `tests/unit/test_api.py`](#tut-04.6-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the new test makes a `Noul` with an instruction alone.

```bash
just test -k noul_needs
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.6-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a noul without criteria. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/3a99587d325837f9104661b3d06d9630679dc8eb/tests/unit/test_api.py).
  - look at `assert Noul(type="noul", instructions="Is it blue?").criteria is None`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -83,3 +83,8 @@ def test_unknown_question_type_is_rejected():
     question = {"type": "essay", "instructions": "Describe this cheese."}
     with pytest.raises(ValidationError):
         SystemOneRequest.model_validate({"state": "Brie", "questions": {"q": question}})
+
+
+def test_noul_needs_no_criteria():
+    """A yes-or-no question may leave out what yes and no mean."""
+    assert Noul(type="noul", instructions="Is it blue?").criteria is None
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3a99587d325837f9104661b3d06d9630679dc8eb). [The code after it](https://github.com/rahuldave/babykev/tree/3a99587d325837f9104661b3d06d9630679dc8eb).

<a id="tut-04.7"></a>

### 4.7 A choice without options is refused

A choice needs at least one option. The test gives a `Choice` empty criteria, and expects a refusal.

[± See the change to `tests/unit/test_api.py`](#tut-04.7-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the new test makes a `Choice` with `criteria={}`.

```bash
just test -k choice_without
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.7-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a choice of nothing. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/4653d298261d887195e59a2cf00593036151657c/tests/unit/test_api.py).
  - look at `def test_choice_without_options_is_rejected():`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -88,3 +88,9 @@ def test_unknown_question_type_is_rejected():
 def test_noul_needs_no_criteria():
     """A yes-or-no question may leave out what yes and no mean."""
     assert Noul(type="noul", instructions="Is it blue?").criteria is None
+
+
+def test_choice_without_options_is_rejected():
+    """A choice needs at least one option."""
+    with pytest.raises(ValidationError):
+        Choice(type="choice", instructions="Which milk?", criteria={})
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4653d298261d887195e59a2cf00593036151657c). [The code after it](https://github.com/rahuldave/babykev/tree/4653d298261d887195e59a2cf00593036151657c).

<a id="tut-04.8"></a>

### 4.8 A choice has at most MAX_OPTIONS options

`MAX_OPTIONS` is 255. The test makes a choice of exactly 255 options, which is valid, and one of 256, which is
refused. A limit is tested on both of its sides.

[± See the change to `tests/unit/test_api.py`](#tut-04.8-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the new test makes `at_limit`, 255 options, and then adds `one_more`.

```bash
just test -k largest
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.8-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the limit, from both sides. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/3addf0f2bd69e0910ba506a41a240fec5218c77a/tests/unit/test_api.py).
  - look at `at_limit = {f"option{i}": None for i in range(MAX_OPTIONS)}`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -7,6 +7,7 @@ import pytest
 from pydantic import ValidationError
 
 from babykev.api import (
+    MAX_OPTIONS,
     Choice,
     Noul,
     Score,
@@ -94,3 +95,13 @@ def test_choice_without_options_is_rejected():
     """A choice needs at least one option."""
     with pytest.raises(ValidationError):
         Choice(type="choice", instructions="Which milk?", criteria={})
+
+
+def test_choice_accepts_the_largest_number_of_options_and_no_more():
+    """The limit on options is exact."""
+    at_limit = {f"option{i}": None for i in range(MAX_OPTIONS)}
+    assert (
+        len(Choice(type="choice", instructions="Which?", criteria=at_limit).criteria) == MAX_OPTIONS
+    )
+    with pytest.raises(ValidationError):
+        Choice(type="choice", instructions="Which?", criteria={**at_limit, "one_more": None})
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3addf0f2bd69e0910ba506a41a240fec5218c77a). [The code after it](https://github.com/rahuldave/babykev/tree/3addf0f2bd69e0910ba506a41a240fec5218c77a).

<a id="tut-04.9"></a>

### 4.9 A score of one level is refused

A scale needs two levels at least, or it measures nothing. The test gives a `Score` one level, and expects a refusal.

[± See the change to `tests/unit/test_api.py`](#tut-04.9-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the new test makes a `Score` with the one level `Soft`.

```bash
just test
```

`just test` prints `22 passed`. `api.py` is still at 77%. The tests of validation run lines that the sample data ran
already.

#### What changed

- <a id="tut-04.9-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a scale of one level. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/b9a4861a26a74623a6daf8c7c776cebe5f30a626/tests/unit/test_api.py).
  - look at `Score(type="score", instructions="How firm?", criteria=["Soft"])`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -105,3 +105,9 @@ def test_choice_accepts_the_largest_number_of_options_and_no_more():
     )
     with pytest.raises(ValidationError):
         Choice(type="choice", instructions="Which?", criteria={**at_limit, "one_more": None})
+
+
+def test_score_with_one_level_is_rejected():
+    """A scale needs at least two levels."""
+    with pytest.raises(ValidationError):
+        Score(type="score", instructions="How firm?", criteria=["Soft"])
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b9a4861a26a74623a6daf8c7c776cebe5f30a626). [The code after it](https://github.com/rahuldave/babykev/tree/b9a4861a26a74623a6daf8c7c776cebe5f30a626).

<a id="tut-04.10"></a>

### 4.10 The README names the tests of the contract

The row of `tests/unit/` names only the tests of the command. It now names the tests of the contract too.

[± See the change to `README.md`](#tut-04.10-README.md-8ec9a0)

In the table of `README.md`, the row of `tests/unit/` names the tests of the contract and the sample data.

```bash
grep -n 'tests/unit' README.md
```

`grep` prints the new row.

#### What changed

- <a id="tut-04.10-README.md-8ec9a0"></a>`README.md`: the row of the tests. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/1fef13ae49e24d280d05c250289c41d5636feff7/README.md).
  - look at ``| `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |``

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -66,7 +66,7 @@ help of the program itself. A recipe gives its extra words to the tool behind it
 | `src/babykev/api.py` | The contract: the request and its three types of question as pydantic models, the text and options the model reads, and the answers made from its probabilities |
 | `src/babykev/cli.py` | The command `babykev` |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
-| `tests/unit/` | The unit tests. `test_cli.py` tests the command `babykev` |
+| `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `README.md` | This file |
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1fef13ae49e24d280d05c250289c41d5636feff7).

This part ends at the code at `tut-04`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-04)

<a id="tut-06"></a>

## 6 Tests of rounding and confidence

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-05`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-05)

The whole tutorial then adds eleven more tests of `api.py`. They check how a request becomes the text that the model
reads, and how the probabilities of the model become answers. After them, `just test` prints `43 passed`, and every
line of `api.py` runs.

Every line runs, and two of them are wrong. The tests here find them.

```bash
just setup
```

Every line of the contract runs in a test, and two of them are wrong. A test of rounding finds the first. The tests of
confidence find the second. Each test fails, and the move after it fixes the code.

<a id="tut-06.1"></a>

### 6.1 A test of rounding, which fails

The probabilities of an answer must sum to 1. The test makes a choice of 77 options with the same probability, 1/77
each. `pytest.approx(1, abs=0.02)` accepts any number from 0.98 to 1.02. The test fails on purpose, because it finds
a bug of kev.

[± See the change to `tests/unit/test_api.py`](#tut-06.1-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the new test sums the probabilities of 77 equal options.

```bash
just test -k sum_to_one
```

pytest prints `F` for the failed test, and `assert 0.77 == 1 ± 0.02`. It ends with `1 failed, 43 deselected`, and exit
code 1.

```bash
sed -n '89,90p' src/babykev/api.py
```

Lines 89 and 90 are `r2`, which rounds to two decimals. 1/77 is about 0.013, and `r2` makes it 0.01. 77 times 0.01 is
0.77. The test is right, and the code is wrong.

#### What changed

- <a id="tut-06.1-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the sum of the rounded probabilities. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/9012b28ceacd0bcc3971154a5df2f822e551443d/tests/unit/test_api.py).
  - look at `    assert sum(answer["probabilities"].values()) == pytest.approx(1, abs=0.02)`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9012b28ceacd0bcc3971154a5df2f822e551443d). [The code after it](https://github.com/rahuldave/babykev/tree/9012b28ceacd0bcc3971154a5df2f822e551443d).

<a id="tut-06.2"></a>

### 6.2 Probabilities rounded to four decimals

Two decimals lose too much, and 77 equal options sum to 0.77. `round_prob` takes the place of `r2`, and rounds to four
decimals. Each 1/77 becomes 0.013, and the 77 probabilities sum to 1.001, within 0.02 of 1.

[± See the change to `src/babykev/api.py`](#tut-06.2-src-babykev-api.py-2ea65f)

In `src/babykev/api.py`, `round_prob` stands where `r2` was, and `to_answers` calls it.

```bash
just test -k sum_to_one
just test
```

`just test -k sum_to_one` prints `1 passed`. The test did not change, and the code did. `just test` prints `44 passed`.

#### What changed

- <a id="tut-06.2-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: four decimals. 8 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/27e93dd7ee76e609084a1d8a1c1cfbb4f7811da4/src/babykev/api.py).
  - look at `    return round(float(x), 4)`

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

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

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/27e93dd7ee76e609084a1d8a1c1cfbb4f7811da4). [The code after it](https://github.com/rahuldave/babykev/tree/27e93dd7ee76e609084a1d8a1c1cfbb4f7811da4).

<a id="tut-06.3"></a>

### 6.3 A guess between options has confidence 0

Confidence runs from 1, when the model is sure, to 0, when it knows nothing. A choice that gives every option the same
probability is a guess.

[± See the change to `tests/unit/test_api.py`](#tut-06.3-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the test gives `choice_confidence` four equal probabilities.

```bash
just test -k confidence
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-06.3-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a guess between four options. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/27f1f23cc392446dd80918636dfc7a3c52692aae/tests/unit/test_api.py).
  - look at `assert choice_confidence([0.25] * 4) == pytest.approx(0)`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -12,6 +12,7 @@ from babykev.api import (
     Noul,
     Score,
     SystemOneRequest,
+    choice_confidence,
     option_text,
     render,
     to_answers,
@@ -252,3 +253,11 @@ def test_rounded_probabilities_still_sum_to_one():
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
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/27f1f23cc392446dd80918636dfc7a3c52692aae). [The code after it](https://github.com/rahuldave/babykev/tree/27f1f23cc392446dd80918636dfc7a3c52692aae).

<a id="tut-06.4"></a>

### 6.4 A certain choice has confidence 1

All the probability on one option is certainty, with three options or with one.

[± See the change to `tests/unit/test_api.py`](#tut-06.4-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the test checks `[0, 1, 0]` and `[1.0]`.

```bash
just test -k confidence
```

pytest prints `2 passed`.

#### What changed

- <a id="tut-06.4-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: certainty. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/9ded0b3177719bb849eda76972daa2f5368af069/tests/unit/test_api.py).
  - look at `assert choice_confidence([0, 1, 0]) == pytest.approx(1)`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -261,3 +261,9 @@ def test_rounded_probabilities_still_sum_to_one():
 def test_choice_confidence_is_zero_for_a_guess():
     """Equal probabilities are a guess, whatever the number of options."""
     assert choice_confidence([0.25] * 4) == pytest.approx(0)
+
+
+def test_choice_confidence_is_one_when_certain():
+    """All the probability on one option is certainty."""
+    assert choice_confidence([0, 1, 0]) == pytest.approx(1)
+    assert choice_confidence([1.0]) == 1.0
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9ded0b3177719bb849eda76972daa2f5368af069). [The code after it](https://github.com/rahuldave/babykev/tree/9ded0b3177719bb849eda76972daa2f5368af069).

<a id="tut-06.5"></a>

### 6.5 The confidence of a choice grows with its winner

Between a guess and certainty, confidence follows the probability of the most likely option. `[0.5, 0.25, 0.25]` gets
0.25.

[± See the change to `tests/unit/test_api.py`](#tut-06.5-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the test expects 0.25 for `[0.5, 0.25, 0.25]`.

```bash
just test -k confidence
```

pytest prints `3 passed`.

#### What changed

- <a id="tut-06.5-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a confidence between 0 and 1. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/890fbe0900f6a0f59232ca9d94ce4cc439e21dde/tests/unit/test_api.py).
  - look at `assert choice_confidence([0.5, 0.25, 0.25]) == pytest.approx(0.25)`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -267,3 +267,8 @@ def test_choice_confidence_is_one_when_certain():
     """All the probability on one option is certainty."""
     assert choice_confidence([0, 1, 0]) == pytest.approx(1)
     assert choice_confidence([1.0]) == 1.0
+
+
+def test_choice_confidence_grows_with_the_winner():
+    """Between a guess and certainty, confidence follows the winning probability."""
+    assert choice_confidence([0.5, 0.25, 0.25]) == pytest.approx(0.25)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/890fbe0900f6a0f59232ca9d94ce4cc439e21dde). [The code after it](https://github.com/rahuldave/babykev/tree/890fbe0900f6a0f59232ca9d94ce4cc439e21dde).

<a id="tut-06.6"></a>

### 6.6 A certain score has confidence 1

A score has its own confidence, which measures how close the probabilities sit to the most likely level. All the
probability on one level is certainty, wherever the level is. The test runs for each of three levels.

[± See the change to `tests/unit/test_api.py`](#tut-06.6-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the parametrized test puts 1.0 on level 0, 1 and 2 in turn.

```bash
just test -k confidence
```

pytest prints `6 passed`.

#### What changed

- <a id="tut-06.6-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: certainty, on each level. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/d2564e48ae134802f1d48cc079cfe3b92db14639/tests/unit/test_api.py).
  - look at `def test_score_confidence_is_one_when_certain(level):`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -15,6 +15,7 @@ from babykev.api import (
     choice_confidence,
     option_text,
     render,
+    score_confidence,
     to_answers,
     to_record,
 )
@@ -272,3 +273,11 @@ def test_choice_confidence_is_one_when_certain():
 def test_choice_confidence_grows_with_the_winner():
     """Between a guess and certainty, confidence follows the winning probability."""
     assert choice_confidence([0.5, 0.25, 0.25]) == pytest.approx(0.25)
+
+
+@pytest.mark.parametrize("level", [0, 1, 2])
+def test_score_confidence_is_one_when_certain(level):
+    """All the probability on one level is certainty, wherever the level is."""
+    p = [0.0, 0.0, 0.0]
+    p[level] = 1.0
+    assert score_confidence(p) == pytest.approx(1)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/d2564e48ae134802f1d48cc079cfe3b92db14639). [The code after it](https://github.com/rahuldave/babykev/tree/d2564e48ae134802f1d48cc079cfe3b92db14639).

<a id="tut-06.7"></a>

### 6.7 A score prefers neighbouring levels

Doubt between two neighbouring levels is closer to certain than doubt between the two ends of the scale.

[± See the change to `tests/unit/test_api.py`](#tut-06.7-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the test compares `[0.5, 0.5, 0, 0]` with `[0.5, 0, 0, 0.5]`.

```bash
just test -k confidence
```

pytest prints `7 passed`.

#### What changed

- <a id="tut-06.7-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: near is better than far. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/795356b136ab4b1b1c22c8e63b8175a1a6f6d6de/tests/unit/test_api.py).
  - look at `assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -281,3 +281,8 @@ def test_score_confidence_is_one_when_certain(level):
     p = [0.0, 0.0, 0.0]
     p[level] = 1.0
     assert score_confidence(p) == pytest.approx(1)
+
+
+def test_score_confidence_prefers_neighbouring_levels():
+    """Doubt between adjacent levels is more confident than doubt between the two ends."""
+    assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/795356b136ab4b1b1c22c8e63b8175a1a6f6d6de). [The code after it](https://github.com/rahuldave/babykev/tree/795356b136ab4b1b1c22c8e63b8175a1a6f6d6de).

<a id="tut-06.8"></a>

### 6.8 A guess between levels has confidence 0, and the test fails

A score that gives every level the same probability is a guess, as it is for a choice, and its confidence must be 0.
The test fails on purpose, because it finds the second bug of kev.

[± See the change to `tests/unit/test_api.py`](#tut-06.8-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the test gives `score_confidence` three equal probabilities.

```bash
just test -k confidence
```

pytest prints `1 failed, 7 passed`. The test that failed is `test_score_confidence_is_zero_for_a_guess`, with
`assert 0.5 == 0 ± 1.0e-12`. A guess over three levels has confidence 0.5. So the score says it is half sure when it
knows nothing.

```bash
sed -n '82,86p' src/babykev/api.py
```

Lines 82 to 86 are `score_confidence`. `mode` is the most likely level. The sum is the spread around `mode`, the
expected distance of a level from `mode`. The code divides it by `L - 1`, the length of the scale.

For the guess, all levels are equally likely, and `max` takes the first, level 0, as `mode`. The levels are 0, 1 and 2
places from it, so the spread is 1/3 × 0 + 1/3 × 1 + 1/3 × 2 = 1 place. The length is 2 places, so the confidence is
1 − 1/2 = 0.5.

#### What changed

- <a id="tut-06.8-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a guess between three levels. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/72a00ec85ae4b6f3b591cf06fc65903a56f1f7fa/tests/unit/test_api.py).
  - look at `assert score_confidence([1 / 3] * 3) == pytest.approx(0)`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -286,3 +286,8 @@ def test_score_confidence_is_one_when_certain(level):
 def test_score_confidence_prefers_neighbouring_levels():
     """Doubt between adjacent levels is more confident than doubt between the two ends."""
     assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])
+
+
+def test_score_confidence_is_zero_for_a_guess():
+    """Equal probabilities over the levels are a guess, as they are for a choice."""
+    assert score_confidence([1 / 3] * 3) == pytest.approx(0)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/72a00ec85ae4b6f3b591cf06fc65903a56f1f7fa). [The code after it](https://github.com/rahuldave/babykev/tree/72a00ec85ae4b6f3b591cf06fc65903a56f1f7fa).

<a id="tut-06.9"></a>

### 6.9 The confidence of a score measures against a guess

A guess gets confidence 0.5, because the code measures the spread against the length of the scale. The fix measures it
against the spread of a guess around the middle level.

[± See the change to `src/babykev/api.py`](#tut-06.9-src-babykev-api.py-2ea65f)

In `src/babykev/api.py`, `score_confidence` now computes `spread` and `guess`, and divides one by the other.

`guess` is the spread of a guess around the middle level. For three levels, the middle is level 1, and the levels are
1, 0 and 1 places from it. So `guess` is 1/3 × 1 + 1/3 × 0 + 1/3 × 1 = 2/3 of a place. For the guess itself, `spread`
around `mode` is 1 place, as before. So 1 − 1 ÷ (2/3) = 1 − 1.5 = −0.5, and `max(0.0, ...)` counts a value below 0 as
0. A guess has confidence 0.

```bash
uv run python -c "from babykev.api import score_confidence as s; print([round(s(p), 2) for p in ([1/3]*3, [0.5, 0.25, 0.25], [0.6, 0.3, 0.1], [0.8, 0.1, 0.1])])"
```

The command prints the confidences of the guess and of three answers, `[0.0, 0.0, 0.25, 0.55]`. `[0.5, 0.25, 0.25]`
is as spread out as a guess, and also gets 0.

```bash
just test
```

`just test` prints `52 passed`, and `api.py` is at 99%. `Missing` gives line 90, `return 1.0`. The new function
divides by `guess`, which is 0 for a scale of one level, so line 90 answers 1 before the division. A request cannot
hold a scale of one level, so no test reaches it.

#### What changed

- <a id="tut-06.9-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the spread of a guess, as the measure. 12 lines added, 4 removed. [The file](https://github.com/rahuldave/babykev/blob/e97355545c4001a361257c532330f8784aa51b79/src/babykev/api.py).
  - look at `    guess = sum(abs(i - (L - 1) / 2) for i in range(L)) / L`

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

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

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e97355545c4001a361257c532330f8784aa51b79). [The code after it](https://github.com/rahuldave/babykev/tree/e97355545c4001a361257c532330f8784aa51b79).

<a id="tut-06.10"></a>

### 6.10 A test of a scale with one level

Line 90 runs in no test. A scale of one level leaves nothing to doubt, so its confidence is 1, and a test that calls
`score_confidence` itself can say so.

[± See the change to `tests/unit/test_api.py`](#tut-06.10-tests-unit-test_api.py-58d97c)

At the end of `tests/unit/test_api.py`, the new test calls `score_confidence([1.0])`.

```bash
just test
```

`just test` prints `53 passed`, and the total is 100%, 79 of 79 statements.

#### What changed

- <a id="tut-06.10-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the test calls the function itself. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/910716f0cec79c3f31afb34cf3a2593f0cd51315/tests/unit/test_api.py).
  - look at `    assert score_confidence([1.0]) == 1.0`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -291,3 +291,8 @@ def test_score_confidence_prefers_neighbouring_levels():
 def test_score_confidence_is_zero_for_a_guess():
     """Equal probabilities over the levels are a guess, as they are for a choice."""
     assert score_confidence([1 / 3] * 3) == pytest.approx(0)
+
+
+def test_score_confidence_is_one_for_a_single_level():
+    """One level leaves nothing to doubt. A request cannot have one, but the function answers it."""
+    assert score_confidence([1.0]) == 1.0
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/910716f0cec79c3f31afb34cf3a2593f0cd51315).

This part ends at the code at `tut-06`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-06)

<a id="tut-19"></a>

## 19 The tiny model and fixtures

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-18`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-18)

The whole tutorial then makes a long detour. ruff formats the code and checks it against rules. Every function gets
types and a docstring, the tests too. `just check` runs every check, and a git hook runs `just check` before git
records a change. smalldocs builds a docs site from the code.

Then the model comes in, with torch and three more packages, as `src/babykev/model.py`. ty checks its types.
`src/babykev/smoke.py` runs the real model on the sample requests, and `just smoke` runs it. No test calls the model
or the smoke. `just test` prints `53 passed`, and the total coverage is 32%.

The tests of the model need a model, and the real one is a download of about 1 GB. Here the tests get a tiny model,
with random weights, from fixtures.

```bash
just setup
```

`just setup` prints `Resolved 67 packages`.

The tests of the model need a model. The real one is a download of about 1 GB, and a pass takes about 200 ms on a
GPU. A test of the model checks something exact, such as which token is where, how many probabilities there are, or
which weights get a gradient. That holds for any weights, trained or random. So the tests get a tiny model, built in memory with random
weights. A fixture of pytest gives it to each test that asks for it.

<a id="tut-19.1"></a>

### 19.1 tests/tiny.py, with the tiny tokenizer

The tiny tokenizer has one token for each printable character, and the five delimiters as special tokens. Like the
tokenizer of the base model, it turns the text of a delimiter into the delimiter. `tests/tiny.py` is a helper of the
tests, and not a test, so pytest does not collect it.

[± See the new file `tests/tiny.py`](#tut-19.1-tests-tiny.py-70c1c9)

The new file `tests/tiny.py` has 23 lines, and `tiny_tokenizer` on lines 11 to 23.

```bash
uv run python -c "from tests.tiny import tiny_tokenizer; t = tiny_tokenizer(); print(len(t), t.tokenize('Roquefort'))"
```

It prints `106` and nine tokens, one for each letter of `Roquefort`, and the note of torch. The 106 tokens are the 100
printable characters, the five delimiters and `[UNK]`, the token for any other character. `python -c` runs from the
root of the project, so Python finds the folder `tests`.

```bash
just lint
```

`just lint` finds 2 errors, and ends with exit code 1. Both are `S106`, `Possible hardcoded password assigned to
argument: "unk_token"`, on lines 19 and 21.

```bash
uv run ruff rule S106
```

`ruff rule` says what a rule checks. `S106` looks for a string written in the code, given to a parameter whose name
sounds like a secret, such as `password` or `token`. The name `unk_token` has `token` in it. `"[UNK]"` is the text of a
token, and no secret. The next move answers it.

#### What changed

- <a id="tut-19.1-tests-tiny.py-70c1c9"></a>`tests/tiny.py`: the tiny tokenizer. New, 23 lines. [The file](https://github.com/rahuldave/babykev/blob/b57593b2f1c324a6349f0f5b58a75754f7f261dc/tests/tiny.py).
  - look at `def tiny_tokenizer() -> PreTrainedTokenizerFast:  # A tokenizer with one token per character`

<details><summary>The diff of <code>tests/tiny.py</code></summary>

```diff
@@ -0,0 +1,23 @@
+"""Stand-ins for the parts of the real model, built in memory, with no download."""
+
+import string
+
+from tokenizers import Tokenizer, models, pre_tokenizers
+from transformers import PreTrainedTokenizerFast
+
+from babykev.model import SPECIAL
+
+
+def tiny_tokenizer() -> PreTrainedTokenizerFast:  # A tokenizer with one token per character
+    """Build a real fast tokenizer in memory, with the five delimiters as its special tokens.
+
+    Like the base model's tokenizer, it turns the text of a special token into that token wherever
+    it appears, which is the behaviour `user_tokens` has to defend against.
+    """
+    chars = sorted(set(string.printable))
+    vocab = {"[UNK]": 0, **{c: i + 1 for i, c in enumerate(chars)}}
+    core = Tokenizer(models.WordLevel(vocab, unk_token="[UNK]"))
+    core.pre_tokenizer = pre_tokenizers.Split("", "isolated")
+    tok = PreTrainedTokenizerFast(tokenizer_object=core, unk_token="[UNK]")
+    tok.add_special_tokens({"additional_special_tokens": SPECIAL})
+    return tok
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b57593b2f1c324a6349f0f5b58a75754f7f261dc). [The code after it](https://github.com/rahuldave/babykev/tree/b57593b2f1c324a6349f0f5b58a75754f7f261dc).

<a id="tut-19.2"></a>

### 19.2 The tests may pass a literal to unk_token

`S106` reads the name of a parameter, and not what the value is. The tests already may use `assert`, by a line of
`[tool.ruff.lint.per-file-ignores]`. The same line lets them break `S106`. The package still may not.

[± See the change to `pyproject.toml`](#tut-19.2-pyproject.toml-5d07e7)

In `pyproject.toml`, the comment is on lines 89 and 90, and line 91 is `"tests/**" = ["S101", "S106"]`.

```bash
just lint
```

`just lint` prints `All checks passed!`.

#### What changed

- <a id="tut-19.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: the tests may break `S106`. 3 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/2daaf5f257514e391edb5ad5183c2d2288965de3/pyproject.toml).
  - look at `"tests/**" = ["S101", "S106"]`

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -86,5 +86,6 @@ select = [
 ]
 
 [tool.ruff.lint.per-file-ignores]
-# A test is written with assert
-"tests/**" = ["S101"]
+# A test is written with assert, and may pass a literal to a parameter whose name sounds like a
+# secret, such as unk_token
+"tests/**" = ["S101", "S106"]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/2daaf5f257514e391edb5ad5183c2d2288965de3). [The code after it](https://github.com/rahuldave/babykev/tree/2daaf5f257514e391edb5ad5183c2d2288965de3).

<a id="tut-19.3"></a>

### 19.3 The tiny backbone

The backbone is the language model under the head. `tiny_backbone` builds the code of Qwen, `Qwen2Model`, with two
layers of 32 numbers, where the real one has 24 layers of 896. Its weights are random, from a seed, so they are the
same at every run.

[± See the change to `tests/tiny.py`](#tut-19.3-tests-tiny.py-70c1c9)

In `tests/tiny.py`, `tiny_backbone` is on lines 27 to 42.

```bash
uv run python -c "from tests.tiny import tiny_backbone; print(sum(p.numel() for p in tiny_backbone(106).parameters()))"
```

It prints `24224`, the parameters of the tiny backbone. The backbone of Qwen2.5-0.5B has 494,032,768.

#### What changed

- <a id="tut-19.3-tests-tiny.py-70c1c9"></a>`tests/tiny.py`: the tiny backbone. 20 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/a6e3905ee0316fdd0b2e0d3baab9f4a65d0588b5/tests/tiny.py).
  - look at `def tiny_backbone(`

<details><summary>The diff of <code>tests/tiny.py</code></summary>

```diff
@@ -2,8 +2,9 @@
 
 import string
 
+import torch
 from tokenizers import Tokenizer, models, pre_tokenizers
-from transformers import PreTrainedTokenizerFast
+from transformers import PreTrainedTokenizerFast, Qwen2Config, Qwen2Model
 
 from babykev.model import SPECIAL
 
@@ -21,3 +22,21 @@ def tiny_tokenizer() -> PreTrainedTokenizerFast:  # A tokenizer with one token p
     tok = PreTrainedTokenizerFast(tokenizer_object=core, unk_token="[UNK]")
     tok.add_special_tokens({"additional_special_tokens": SPECIAL})
     return tok
+
+
+def tiny_backbone(
+    vocab_size: int,  # How many tokens the tokenizer has
+    seed: int = 0,  # The seed of the random weights
+) -> Qwen2Model:  # A backbone of the base model's architecture, with two small layers
+    """Build a randomly initialised backbone, the same every time for the same seed."""
+    torch.manual_seed(seed)
+    config = Qwen2Config(
+        vocab_size=vocab_size,
+        hidden_size=32,
+        intermediate_size=64,
+        num_hidden_layers=2,
+        num_attention_heads=2,
+        num_key_value_heads=2,
+        max_position_embeddings=2048,
+    )
+    return Qwen2Model(config)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a6e3905ee0316fdd0b2e0d3baab9f4a65d0588b5). [The code after it](https://github.com/rahuldave/babykev/tree/a6e3905ee0316fdd0b2e0d3baab9f4a65d0588b5).

<a id="tut-19.4"></a>

### 19.4 conftest.py, with the fixture tok

A fixture is a function marked `@pytest.fixture`. A test names it as a parameter, and pytest calls the fixture and
passes in what it returns. `monkeypatch` and `capsys` are fixtures of pytest. pytest reads `tests/conftest.py` before
any test, and every test file can use the fixtures in it, with no import. The first fixture, `tok`, is the tiny
tokenizer. `scope="session"` builds it once for the whole run.

[± See the new file `tests/conftest.py`](#tut-19.4-tests-conftest.py-626af3)

The new file `tests/conftest.py` imports `tiny_tokenizer` from `tests.tiny` on line 10, and has the fixture `tok` on
lines 13 to 16.

```bash
just test
```

`just test` fails before any test runs, with exit code 4. It prints `ImportError while loading conftest`, and
`ModuleNotFoundError: No module named 'tests'`. pytest puts the folder of `conftest.py`, `tests`, on the path of
Python, and not the root of the project. So `tests.tiny` cannot be found. The next move answers it.

#### What changed

- <a id="tut-19.4-tests-conftest.py-626af3"></a>`tests/conftest.py`: the fixture `tok`. New, 16 lines. [The file](https://github.com/rahuldave/babykev/blob/14585bbd144a55ac28ff0473f3d3f2c23c03d314/tests/conftest.py).
  - look at `@pytest.fixture(scope="session")`

<details><summary>The diff of <code>tests/conftest.py</code></summary>

```diff
@@ -0,0 +1,16 @@
+"""The fixtures that every test file can ask for.
+
+What the tests of the model check is exact, and holds for any weights. So the fixtures need no
+trained model, no download and no GPU.
+"""
+
+import pytest
+from transformers import PreTrainedTokenizerFast
+
+from tests.tiny import tiny_tokenizer
+
+
+@pytest.fixture(scope="session")
+def tok() -> PreTrainedTokenizerFast:  # The tiny tokenizer, built once for the whole test run
+    """Provide the tiny tokenizer."""
+    return tiny_tokenizer()
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/14585bbd144a55ac28ff0473f3d3f2c23c03d314). [The code after it](https://github.com/rahuldave/babykev/tree/14585bbd144a55ac28ff0473f3d3f2c23c03d314).

<a id="tut-19.5"></a>

### 19.5 pytest can import tests.tiny

The setting `pythonpath` of pytest puts folders on the path of Python. `"."` is the root of the project, where the
folder `tests` is.

[± See the change to `pyproject.toml`](#tut-19.5-pyproject.toml-5d07e7)

In `pyproject.toml`, the comment is on line 57, and line 58 is `pythonpath = ["."]`.

```bash
just test
```

`just test` prints `53 passed`. `model.py` goes from 0% to 33%, and the total from 32% to 45%, 121 of 267. No test
calls the model. `tests/tiny.py` imports `SPECIAL` from `babykev.model`, so Python runs the module. Its imports, its
names and the line of each `def` and `class` count as covered, 36 of its 109 statements.

```bash
just test --fixtures
```

`just test --fixtures` lists every fixture that pytest can see. Those of pytest come first, and the last section is
`fixtures defined from conftest`. It has `tok [session scope] -- tests/conftest.py:14`, with its docstring.

#### What changed

- <a id="tut-19.5-pyproject.toml-5d07e7"></a>`pyproject.toml`: the root of the project, on the path of pytest. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/b458ae1df2239c8645f7a4eb35832fd2dddc1114/pyproject.toml).
  - look at `pythonpath = ["."]`

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -54,6 +54,8 @@ test = [
 
 [tool.pytest.ini_options]
 testpaths = ["tests"]
+# A test can import its helpers from the folder tests, for example tests.tiny
+pythonpath = ["."]
 # Every run measures how much of src/babykev the tests run, and lists the lines they do not
 addopts = "--cov=babykev --cov-report=term-missing"
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b458ae1df2239c8645f7a4eb35832fd2dddc1114). [The code after it](https://github.com/rahuldave/babykev/tree/b458ae1df2239c8645f7a4eb35832fd2dddc1114).

<a id="tut-19.6"></a>

### 19.6 The fixture model

The fixture `model` is a `DecisionModel` on the tiny backbone, on the CPU, with no adapter. It asks for `tok`, because
the backbone needs to know the number of tokens. A fixture can ask for another fixture. `model` has the default scope,
so pytest builds it again for each test, and no test can spoil it for the next.

[± See the change to `tests/conftest.py`](#tut-19.6-tests-conftest.py-626af3)

In `tests/conftest.py`, the fixture `model` is on lines 20 to 25.

```bash
just test --fixtures
```

The last section lists `tok` and `model -- tests/conftest.py:21`. `tok` is now on line 15, one line lower, under the
new import.

#### What changed

- <a id="tut-19.6-tests-conftest.py-626af3"></a>`tests/conftest.py`: the fixture `model`. 10 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/0806a218722ba7438f265928d3cfbc0b5f0e723e/tests/conftest.py).
  - look at `    return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()`

<details><summary>The diff of <code>tests/conftest.py</code></summary>

```diff
@@ -7,10 +7,19 @@ trained model, no download and no GPU.
 import pytest
 from transformers import PreTrainedTokenizerFast
 
-from tests.tiny import tiny_tokenizer
+from babykev.model import DecisionModel
+from tests.tiny import tiny_backbone, tiny_tokenizer
 
 
 @pytest.fixture(scope="session")
 def tok() -> PreTrainedTokenizerFast:  # The tiny tokenizer, built once for the whole test run
     """Provide the tiny tokenizer."""
     return tiny_tokenizer()
+
+
+@pytest.fixture
+def model(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+) -> DecisionModel:  # A decision model on the tiny backbone, with no adapter, ready to answer
+    """Provide a fresh tiny model for each test, on the CPU."""
+    return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0806a218722ba7438f265928d3cfbc0b5f0e723e). [The code after it](https://github.com/rahuldave/babykev/tree/0806a218722ba7438f265928d3cfbc0b5f0e723e).

<a id="tut-19.7"></a>

### 19.7 The fixture record

The fixture `record` is one record about Roquefort, in the form that `to_record` returns. It has a state, and three
questions of 2, 3 and 3 options.

[± See the change to `tests/conftest.py`](#tut-19.7-tests-conftest.py-626af3)

In `tests/conftest.py`, the fixture `record` is on lines 30 to 40.

```bash
just test --fixtures
```

The last section lists the three fixtures, `tok`, `model` and `record`, each with its line in `conftest.py` and its
docstring.

#### What changed

- <a id="tut-19.7-tests-conftest.py-626af3"></a>`tests/conftest.py`: the fixture `record`. 15 lines added. [The file](https://github.com/rahuldave/babykev/blob/b4bf2491e8505697eaa015738f93178c6bd7f3fc/tests/conftest.py).
  - look at `        "state": "Roquefort. A blue cheese from France, made from sheep's milk.",`

<details><summary>The diff of <code>tests/conftest.py</code></summary>

```diff
@@ -4,6 +4,8 @@ What the tests of the model check is exact, and holds for any weights. So the fi
 trained model, no download and no GPU.
 """
 
+from typing import Any
+
 import pytest
 from transformers import PreTrainedTokenizerFast
 
@@ -23,3 +25,16 @@ def model(
 ) -> DecisionModel:  # A decision model on the tiny backbone, with no adapter, ready to answer
     """Provide a fresh tiny model for each test, on the CPU."""
     return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()
+
+
+@pytest.fixture
+def record() -> dict[str, Any]:  # A record with a state and three questions
+    """Provide one record, as `to_record` would return it."""
+    return {
+        "state": "Roquefort. A blue cheese from France, made from sheep's milk.",
+        "questions": [
+            {"instr": "Is this a blue cheese?", "options": ["no", "yes"], "label": 1},
+            {"instr": "Which milk?", "options": ["cow", "goat", "sheep"], "label": 2},
+            {"instr": "How firm?", "options": ["Soft", "Semi-soft", "Hard"], "label": 1},
+        ],
+    }
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b4bf2491e8505697eaa015738f93178c6bd7f3fc). [The code after it](https://github.com/rahuldave/babykev/tree/b4bf2491e8505697eaa015738f93178c6bd7f3fc).

<a id="tut-19.8"></a>

### 19.8 The first test of the model

The first test asks for the three fixtures. It packs the record with the tiny tokenizer, and runs the tiny model and
the head. Each question gets one probability per option, and they sum to 1. Nothing is trained, so the probabilities
mean nothing. The test checks what is true of any probabilities.

[± See the new file `tests/unit/test_model.py`](#tut-19.8-tests-unit-test_model.py-583145)

The new file `tests/unit/test_model.py` has one test, on lines 11 to 20.

```bash
sed -n '11,20p' tests/unit/test_model.py
just test -k probabilities_sum
```

The test never says "tiny". It names `model`, `tok` and `record`, and pytest passes them in. The code that runs is our
`DecisionModel`. Only the backbone and the tokenizer under it are small. `[2, 3, 3]` on line 18 is known in advance,
because the record of the fixture has questions of 2, 3 and 3 options. `just test -k probabilities_sum` prints
`1 passed, 53 deselected`.

```bash
just test --fixtures-per-test -k probabilities_sum
```

`--fixtures-per-test` names the fixtures of each test, and where each is defined. The test gets `model`, `record` and
`tok`, each with its line in `conftest.py`.

```bash
just test
```

`just test` prints `54 passed`. `model.py` is at 85%, and the total at 67%, 178 of 267. One test runs the
packing, the mask, the backbone and the head.

In tut-19.5, before this test, `model.py` was at 33%, and the total at 45%.

#### What changed

- <a id="tut-19.8-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the first test of the model, on the tiny model. New, 20 lines. [The file](https://github.com/rahuldave/babykev/blob/321a8df2c597e0c46d06c9b36c711f0fe270900a/tests/unit/test_model.py).
  - look at `def test_probabilities_sum_to_one_for_every_question(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -0,0 +1,20 @@
+"""Tests of the model, on the tiny model."""
+
+from typing import Any
+
+import pytest
+from transformers import PreTrainedTokenizerFast
+
+from babykev.model import DecisionModel, encode
+
+
+def test_probabilities_sum_to_one_for_every_question(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Each question gets one probability per option, and they sum to 1."""
+    probs = model.probs(encode(tok, record))
+    assert [len(p) for p in probs] == [2, 3, 3]
+    for p in probs:
+        assert p.sum().item() == pytest.approx(1)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/321a8df2c597e0c46d06c9b36c711f0fe270900a). [The code after it](https://github.com/rahuldave/babykev/tree/321a8df2c597e0c46d06c9b36c711f0fe270900a).

<a id="tut-19.9"></a>

### 19.9 The README names the fixtures and the tiny model

The table of the README gets a row for each of the two new files. The row of `tests/unit/` names the tests of the
model.

[± See the change to `README.md`](#tut-19.9-README.md-8ec9a0)

In `README.md`, the row of `tests/unit/` is on line 83, and the two new rows are on lines 84 and 85.

```bash
just check
```

`just check` passes. The tests print `54 passed`, and the total of 67%. `just docs check` prints `71 of 71`, with the
helpers and the fixtures in it.

#### What changed

- <a id="tut-19.9-README.md-8ec9a0"></a>`README.md`: the rows of the fixtures and of the tiny model. 3 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/88b3a9e08db851ce891ecfcfcf26d18892beea90/README.md).
  - look at ``| `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |``

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -80,7 +80,9 @@ yourself at any time.
 | `src/babykev/model.py` | The model, a language model with a head that points at the options |
 | `src/babykev/smoke.py` | The smoke run, which asks the real model the sample requests on this machine |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
-| `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |
+| `tests/unit/` | The tests of the contract, of the command and of the model. One test checks every line of the sample data against the contract |
+| `tests/conftest.py` | The fixtures that every test can ask for: the tiny tokenizer, a tiny model and a record |
+| `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |
 | `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `README.md` | This file |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/88b3a9e08db851ce891ecfcfcf26d18892beea90).

This part ends at the code at `tut-19`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-19)

<a id="tut-20"></a>

## 20 Unit tests of the model and the smoke

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-19`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-19)

Each test here runs one function alone, with the tiny model or with no model at all.

```bash
just setup
```

`just setup` prints `Resolved 67 packages`.

A unit test runs one function alone. The tests here check the packing, the defence against a forged
delimiter, the head and the device. Then they check the verdicts of the smoke, and the command `smoke`. Each move adds one test. The
coverage does not rise with every test. It counts the lines that a test runs, and not what a test checks.

<a id="tut-20.1"></a>

### 20.1 Packing marks every part with its delimiter

The test packs a small record, the state `ab` and one question `x?` with the options `n` and `y`. With one token per
character, it can write down every token that it expects.

[± See the change to `tests/unit/test_model.py`](#tut-20.1-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 23 to 35.

```bash
sed -n '23,35p' tests/unit/test_model.py
just test -k packing_marks
```

The list on line 31 is the whole sequence. It has the state delimiter and `a`, `b`, then the question delimiter and
`x`, `?`. Each option is between its two delimiters, and the decide delimiter comes last. Line 32 gives the segment of each token, 0 for the state
and 1 for the question. `just test -k packing_marks` prints `1 passed`.

With `-k`, the table of coverage counts only the tests that ran. This test alone runs 54% of `model.py`.

```bash
just test
```

`just test` prints `55 passed`. The total stays at 67%, and `model.py` at 85%, with the same 16 lines missing. The
test of the probabilities ran `encode` already, and checked none of its tokens. The coverage counts the lines that
run, and not what a test checks.

#### What changed

- <a id="tut-20.1-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the tokens of a packed record. 16 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/6d2401817f1bc2d56de4f3021cfceaa80d5b80f9/tests/unit/test_model.py).
  - look at `def test_packing_marks_every_part_with_its_delimiter(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -5,7 +5,7 @@ from typing import Any
 import pytest
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import DecisionModel, encode
+from babykev.model import DecisionModel, delimiter_ids, encode
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -18,3 +18,18 @@ def test_probabilities_sum_to_one_for_every_question(
     assert [len(p) for p in probs] == [2, 3, 3]
     for p in probs:
         assert p.sum().item() == pytest.approx(1)
+
+
+def test_packing_marks_every_part_with_its_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+) -> None:
+    """A packed record is the state, then each question with its options and its decide token."""
+    s, q, o, c, d = delimiter_ids(tok)
+    record = {"state": "ab", "questions": [{"instr": "x?", "options": ["n", "y"], "label": 1}]}
+    enc = encode(tok, record)
+    a, b, x, mark, n, y = (tok.convert_tokens_to_ids(ch) for ch in "abx?ny")
+    assert enc["ids"] == [s, a, b, q, x, mark, o, n, c, o, y, c, d]
+    assert enc["seg"] == [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
+    assert enc["decide_idx"] == [12]
+    assert enc["opt_idx"] == [[8, 11]]
+    assert enc["labels"] == [1]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/6d2401817f1bc2d56de4f3021cfceaa80d5b80f9). [The code after it](https://github.com/rahuldave/babykev/tree/6d2401817f1bc2d56de4f3021cfceaa80d5b80f9).

<a id="tut-20.2"></a>

### 20.2 Positions restart after the state

The positions of each question begin right after the state, so a question looks the same wherever it comes.

[± See the change to `tests/unit/test_model.py`](#tut-20.2-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 38 to 47.

```bash
just test -k positions_restart
```

pytest prints `1 passed, 55 deselected`.

#### What changed

- <a id="tut-20.2-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the positions of each question. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/e947449de17438d3aa5ee006bfc98db3944d4457/tests/unit/test_model.py).
  - look at `def test_positions_restart_after_the_state(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -33,3 +33,15 @@ def test_packing_marks_every_part_with_its_delimiter(
     assert enc["decide_idx"] == [12]
     assert enc["opt_idx"] == [[8, 11]]
     assert enc["labels"] == [1]
+
+
+def test_positions_restart_after_the_state(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Every question starts at the position right after the state, wherever it comes."""
+    enc = encode(tok, record)
+    state_length = enc["seg"].count(0)
+    for k in (1, 2, 3):
+        positions = [p for p, s in zip(enc["pos"], enc["seg"], strict=True) if s == k]
+        assert positions == list(range(state_length, state_length + len(positions)))
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e947449de17438d3aa5ee006bfc98db3944d4457). [The code after it](https://github.com/rahuldave/babykev/tree/e947449de17438d3aa5ee006bfc98db3944d4457).

<a id="tut-20.3"></a>

### 20.3 A question that does not fit is refused

`encode` refuses a question that does not fit, and names its length. The record of the fixture has a state of 62
tokens. The test gives a limit of 80 tokens to the state and a question together, and the questions do not fit.

[± See the change to `tests/unit/test_model.py`](#tut-20.3-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 50 to 56.

```bash
just test -k question_that_does_not_fit
```

pytest prints `1 passed`. The column Missing of `model.py` lists `129-135`, and not 128. Line 128, the `raise`, has
run, and it left `encode` before the lines after it.

#### What changed

- <a id="tut-20.3-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: a question longer than the limit. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/ff097836c2f1b752bb4347f8e5ae59aeca648a05/tests/unit/test_model.py).
  - look at `def test_a_question_that_does_not_fit_is_refused(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -45,3 +45,12 @@ def test_positions_restart_after_the_state(
     for k in (1, 2, 3):
         positions = [p for p, s in zip(enc["pos"], enc["seg"], strict=True) if s == k]
         assert positions == list(range(state_length, state_length + len(positions)))
+
+
+def test_a_question_that_does_not_fit_is_refused(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """A branch longer than the limit raises, and names its length."""
+    with pytest.raises(ValueError, match="branch too long"):
+        encode(tok, record, max_branch=80)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ff097836c2f1b752bb4347f8e5ae59aeca648a05). [The code after it](https://github.com/rahuldave/babykev/tree/ff097836c2f1b752bb4347f8e5ae59aeca648a05).

<a id="tut-20.4"></a>

### 20.4 A state that does not fit is refused

`encode` refuses a state that is longer than its limit, and names its length and the limit. The state of the fixture
is the state delimiter and 61 characters, 62 tokens.

[± See the change to `tests/unit/test_model.py`](#tut-20.4-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 59 to 65.

```bash
just test -k state_that_does_not_fit
```

pytest prints `1 passed`. Line 117, the other `raise` of `encode`, has run. In the column Missing of `model.py`, the
range of `encode` starts at 118 again.

```bash
just test
```

`just test` prints `58 passed`. `model.py` is at 87%, with 14 lines missing. Lines 117 and 128 are no longer among
them.

#### What changed

- <a id="tut-20.4-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: a state longer than the limit. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/e3b3ab01357c19f3325d481c80e67ad1f13c1522/tests/unit/test_model.py).
  - look at `    with pytest.raises(ValueError, match="state too long: 62 tokens, the limit is 50"):`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -54,3 +54,12 @@ def test_a_question_that_does_not_fit_is_refused(
     """A branch longer than the limit raises, and names its length."""
     with pytest.raises(ValueError, match="branch too long"):
         encode(tok, record, max_branch=80)
+
+
+def test_a_state_that_does_not_fit_is_refused(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """A state longer than the limit raises, and names its length and the limit."""
+    with pytest.raises(ValueError, match="state too long: 62 tokens, the limit is 50"):
+        encode(tok, record, max_state=50)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e3b3ab01357c19f3325d481c80e67ad1f13c1522). [The code after it](https://github.com/rahuldave/babykev/tree/e3b3ab01357c19f3325d481c80e67ad1f13c1522).

<a id="tut-20.5"></a>

### 20.5 A tokenizer alone would let text forge a delimiter

A caller writes the state, the instructions and the options. A tokenizer turns the text `<|fim_suffix|>` into the
decide token, wherever it is. So text could close an option early, or make a question of its own. This test shows the
danger, before the next test shows the defence.

[± See the change to `tests/unit/test_model.py`](#tut-20.5-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 68 to 73.

```bash
sed -n '68,73p' tests/unit/test_model.py
just test -k tokenizer_alone
```

The test tokenizes `yes<|fim_suffix|>` with the tokenizer alone, and finds the id of the decide delimiter among the
tokens. pytest prints `1 passed`. The danger is real.

#### What changed

- <a id="tut-20.5-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the danger, a forged delimiter. 9 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/1782e1e6803efd49be04e682f3453e39c1c2fc23/tests/unit/test_model.py).
  - look at `def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -5,7 +5,7 @@ from typing import Any
 import pytest
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import DecisionModel, delimiter_ids, encode
+from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -63,3 +63,11 @@ def test_a_state_that_does_not_fit_is_refused(
     """A state longer than the limit raises, and names its length and the limit."""
     with pytest.raises(ValueError, match="state too long: 62 tokens, the limit is 50"):
         encode(tok, record, max_state=50)
+
+
+def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+) -> None:
+    """The danger is real: tokenized directly, the text of a delimiter becomes that delimiter."""
+    decide = delimiter_ids(tok)[4]
+    assert decide in tok(f"yes{SPECIAL[4]}", add_special_tokens=False).input_ids
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1782e1e6803efd49be04e682f3453e39c1c2fc23). [The code after it](https://github.com/rahuldave/babykev/tree/1782e1e6803efd49be04e682f3453e39c1c2fc23).

<a id="tut-20.6"></a>

### 20.6 User text cannot forge a delimiter

`user_tokens` rewrites `<|name|>` to `<¦name¦>` before it tokenizes, so the text of a delimiter is ordinary text. The
test runs once for each of the five delimiters.

[± See the change to `tests/unit/test_model.py`](#tut-20.6-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 76 to 83.

```bash
just test -k forge
```

`-k forge` takes both tests, the danger and the defence. pytest prints `6 passed`, the danger once and the defence
five times.

```bash
just test
```

`just test` prints `64 passed`. `model.py` is at 87%, with 14 lines missing. The test of the
probabilities had run `user_tokens` already, and checked nothing about it.

The 14 lines are the same as at the end of tut-20.4, so the two new tests add no line to the coverage.

#### What changed

- <a id="tut-20.6-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the defence, for each of the five delimiters. 11 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/e30ea2eb52ae23815152f60b09d07d9d0dd1fd3a/tests/unit/test_model.py).
  - look at `def test_user_text_cannot_forge_a_delimiter(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -5,7 +5,7 @@ from typing import Any
 import pytest
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode
+from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode, user_tokens
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -71,3 +71,13 @@ def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(
     """The danger is real: tokenized directly, the text of a delimiter becomes that delimiter."""
     decide = delimiter_ids(tok)[4]
     assert decide in tok(f"yes{SPECIAL[4]}", add_special_tokens=False).input_ids
+
+
+@pytest.mark.parametrize("delimiter", SPECIAL)
+def test_user_text_cannot_forge_a_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    delimiter: str,  # The text of one of the five delimiters
+) -> None:
+    """Through `user_tokens`, the text of a delimiter is only ever ordinary tokens."""
+    ids = user_tokens(tok, f"before {delimiter} after")
+    assert not set(ids) & set(delimiter_ids(tok))
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e30ea2eb52ae23815152f60b09d07d9d0dd1fd3a). [The code after it](https://github.com/rahuldave/babykev/tree/e30ea2eb52ae23815152f60b09d07d9d0dd1fd3a).

<a id="tut-20.7"></a>

### 20.7 The pointer head gives one logit per option

The head takes the hidden state of a decide token and those of the options, and gives one logit for each option. The
test builds a head alone, with no model, and gives it five options.

[± See the change to `tests/unit/test_model.py`](#tut-20.7-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 87 to 90.

```bash
just test -k pointer_head
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-20.7-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: five options in, five logits out. 8 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/455b6a8ae64dae7e79fea6dd6b8434d11eb8f542/tests/unit/test_model.py).
  - look at `def test_pointer_head_gives_one_logit_per_option() -> None:`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -3,9 +3,10 @@
 from typing import Any
 
 import pytest
+import torch
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode, user_tokens
+from babykev.model import SPECIAL, DecisionModel, PointerHead, delimiter_ids, encode, user_tokens
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -81,3 +82,9 @@ def test_user_text_cannot_forge_a_delimiter(
     """Through `user_tokens`, the text of a delimiter is only ever ordinary tokens."""
     ids = user_tokens(tok, f"before {delimiter} after")
     assert not set(ids) & set(delimiter_ids(tok))
+
+
+def test_pointer_head_gives_one_logit_per_option() -> None:
+    """Five options in, five logits out."""
+    head = PointerHead(d=32, dp=8)
+    assert head(torch.randn(32), torch.randn(5, 32)).shape == (5,)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/455b6a8ae64dae7e79fea6dd6b8434d11eb8f542). [The code after it](https://github.com/rahuldave/babykev/tree/455b6a8ae64dae7e79fea6dd6b8434d11eb8f542).

<a id="tut-20.8"></a>

### 20.8 pick_device takes an override

`pick_device` returns a device that it is given by name, whatever the machine has.

[± See the change to `tests/unit/test_model.py`](#tut-20.8-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the import from `babykev.model` is on lines 9 to 17, and the new test is on lines 101 to
103.

```bash
just test -k takes_an_override
```

pytest prints `1 passed`. The column Missing of `model.py` starts at `62-64`, so lines 60 and 61 have run.

#### What changed

- <a id="tut-20.8-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: a device asked for by name. 14 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/4e6dafdd492c6ca8c6ebe4935f7065e8434064da/tests/unit/test_model.py).
  - look at `def test_pick_device_takes_an_override() -> None:`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -6,7 +6,15 @@ import pytest
 import torch
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import SPECIAL, DecisionModel, PointerHead, delimiter_ids, encode, user_tokens
+from babykev.model import (
+    SPECIAL,
+    DecisionModel,
+    PointerHead,
+    delimiter_ids,
+    encode,
+    pick_device,
+    user_tokens,
+)
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -88,3 +96,8 @@ def test_pointer_head_gives_one_logit_per_option() -> None:
     """Five options in, five logits out."""
     head = PointerHead(d=32, dp=8)
     assert head(torch.randn(32), torch.randn(5, 32)).shape == (5,)
+
+
+def test_pick_device_takes_an_override() -> None:
+    """A device asked for by name is used, whatever the machine has."""
+    assert pick_device("cpu") == "cpu"
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4e6dafdd492c6ca8c6ebe4935f7065e8434064da). [The code after it](https://github.com/rahuldave/babykev/tree/4e6dafdd492c6ca8c6ebe4935f7065e8434064da).

<a id="tut-20.9"></a>

### 20.9 pick_device finds something to run on

With no override, `pick_device` chooses CUDA, then the GPU of Apple, then the CPU.

[± See the change to `tests/unit/test_model.py`](#tut-20.9-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 106 to 108.

```bash
just test
```

`just test` prints `67 passed`. `model.py` is at 91%, and the missing lines are `63, 72-75, 204-207, 211-218, 277`.
Line 63 returns `cuda`, and runs only on a machine with a GPU of NVIDIA. Lines 72 to 75 load the tokenizer from the
Hub, and lines 204 to 207 load the model. Lines 211 to 218 add the adapter, and line 277 lists the parameters that
train. The total is 69%.

#### What changed

- <a id="tut-20.9-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: a device, whatever the machine. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/fe15072f571cb54b810bf22b511cce5cc81920fa/tests/unit/test_model.py).
  - look at `def test_pick_device_finds_something_to_run_on() -> None:`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -101,3 +101,8 @@ def test_pointer_head_gives_one_logit_per_option() -> None:
 def test_pick_device_takes_an_override() -> None:
     """A device asked for by name is used, whatever the machine has."""
     assert pick_device("cpu") == "cpu"
+
+
+def test_pick_device_finds_something_to_run_on() -> None:
+    """With no override, the choice is one of the three kinds of device."""
+    assert pick_device() in {"cuda", "mps", "cpu"}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/fe15072f571cb54b810bf22b511cce5cc81920fa). [The code after it](https://github.com/rahuldave/babykev/tree/fe15072f571cb54b810bf22b511cce5cc81920fa).

<a id="tut-20.10"></a>

### 20.10 A verdict agrees when the answer is the label

The tests of the smoke go in a file of their own. `verdict` needs no model, so its tests are unit tests.

[± See the new file `tests/unit/test_smoke.py`](#tut-20.10-tests-unit-test_smoke.py-89db04)

The new file `tests/unit/test_smoke.py` has the test on lines 6 to 10.

```bash
sed -n '6,10p' tests/unit/test_smoke.py
just test -k agrees_when
```

The answer is `goat`, with a probability of 0.8, and the label is `goat`. `verdict` gives `("goat (0.80)", "goat",
True)`. pytest prints `1 passed`.

```bash
just test
```

`just test` prints `68 passed`. `smoke.py` goes from 0% to 34%, and the total from 69% to 78%. The test calls only
`verdict`. The import of `smoke.py` runs its imports, its names and the line of each `def`.

#### What changed

- <a id="tut-20.10-tests-unit-test_smoke.py-89db04"></a>`tests/unit/test_smoke.py`: the first test of `verdict`. New, 10 lines. [The file](https://github.com/rahuldave/babykev/blob/46f7e9637f1653265e237ae9676f543af062afc5/tests/unit/test_smoke.py).
  - look at `def test_verdict_agrees_when_the_answer_is_the_label() -> None:`

<details><summary>The diff of <code>tests/unit/test_smoke.py</code></summary>

```diff
@@ -0,0 +1,10 @@
+"""Tests of the smoke run, without the real model."""
+
+from babykev.smoke import verdict
+
+
+def test_verdict_agrees_when_the_answer_is_the_label() -> None:
+    """A verdict says what the model said, what the label says, and whether they agree."""
+    question = {"type": "choice", "criteria": {"cow": None, "goat": None}, "label": "goat"}
+    given = {"type": "choice", "choice": "goat", "probabilities": {"cow": 0.2, "goat": 0.8}}
+    assert verdict(question, given) == ("goat (0.80)", "goat", True)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/46f7e9637f1653265e237ae9676f543af062afc5). [The code after it](https://github.com/rahuldave/babykev/tree/46f7e9637f1653265e237ae9676f543af062afc5).

<a id="tut-20.11"></a>

### 20.11 A verdict reads a noul as yes from one half

A probability of yes of 0.5 or more is a yes. The test gives `verdict` exactly 0.5, the edge.

[± See the change to `tests/unit/test_smoke.py`](#tut-20.11-tests-unit-test_smoke.py-89db04)

In `tests/unit/test_smoke.py`, the new test is on lines 13 to 16.

```bash
just test -k noul_answer_as_yes
```

pytest prints `1 passed`. The label is no, so the verdict is `("yes (0.50)", "no", False)`.

#### What changed

- <a id="tut-20.11-tests-unit-test_smoke.py-89db04"></a>`tests/unit/test_smoke.py`: a noul at the edge. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/ec3c03dc7b395c22a898f0c25e754daaa9ce1afa/tests/unit/test_smoke.py).
  - look at `def test_verdict_reads_a_noul_answer_as_yes_from_one_half() -> None:`

<details><summary>The diff of <code>tests/unit/test_smoke.py</code></summary>

```diff
@@ -8,3 +8,9 @@ def test_verdict_agrees_when_the_answer_is_the_label() -> None:
     question = {"type": "choice", "criteria": {"cow": None, "goat": None}, "label": "goat"}
     given = {"type": "choice", "choice": "goat", "probabilities": {"cow": 0.2, "goat": 0.8}}
     assert verdict(question, given) == ("goat (0.80)", "goat", True)
+
+
+def test_verdict_reads_a_noul_answer_as_yes_from_one_half() -> None:
+    """A probability of yes at or above 0.5 is a yes."""
+    said, label, agree = verdict({"type": "noul", "label": False}, {"type": "noul", "noul": 0.5})
+    assert (said, label, agree) == ("yes (0.50)", "no", False)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ec3c03dc7b395c22a898f0c25e754daaa9ce1afa). [The code after it](https://github.com/rahuldave/babykev/tree/ec3c03dc7b395c22a898f0c25e754daaa9ce1afa).

<a id="tut-20.12"></a>

### 20.12 A verdict reads a score as its most likely level

A score is judged by the level with the highest probability, and not by the expected level. The expected level is
1.1. The probabilities are 0.2, 0.5 and 0.3, and level 1 is the most likely.

[± See the change to `tests/unit/test_smoke.py`](#tut-20.12-tests-unit-test_smoke.py-89db04)

In `tests/unit/test_smoke.py`, the new test is on lines 19 to 26.

```bash
just test
```

`just test` prints `70 passed`. `verdict` is covered, and the missing lines of `smoke.py` are
`35-36, 45-49, 78-92, 99-119`. They are the body of `read_lines`, of `answer`, of `smoke` and of `main`. The total is
79%.

#### What changed

- <a id="tut-20.12-tests-unit-test_smoke.py-89db04"></a>`tests/unit/test_smoke.py`: a score, by its most likely level. 10 lines added. [The file](https://github.com/rahuldave/babykev/blob/adb57ffc75cd347933a0bebec13312802817faee/tests/unit/test_smoke.py).
  - look at `def test_verdict_reads_a_score_answer_as_its_most_likely_level() -> None:`

<details><summary>The diff of <code>tests/unit/test_smoke.py</code></summary>

```diff
@@ -14,3 +14,13 @@ def test_verdict_reads_a_noul_answer_as_yes_from_one_half() -> None:
     """A probability of yes at or above 0.5 is a yes."""
     said, label, agree = verdict({"type": "noul", "label": False}, {"type": "noul", "noul": 0.5})
     assert (said, label, agree) == ("yes (0.50)", "no", False)
+
+
+def test_verdict_reads_a_score_answer_as_its_most_likely_level() -> None:
+    """A score is judged by the level with the highest probability."""
+    given = {"type": "score", "score": 1.1, "probabilities": {"0": 0.2, "1": 0.5, "2": 0.3}}
+    assert verdict({"type": "score", "label": 1}, given) == (
+        "level 1 (score 1.10)",
+        "level 1",
+        True,
+    )
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/adb57ffc75cd347933a0bebec13312802817faee). [The code after it](https://github.com/rahuldave/babykev/tree/adb57ffc75cd347933a0bebec13312802817faee).

<a id="tut-20.13"></a>

### 20.13 babykev smoke help prints the usage

`main` of `smoke.py` answers `help` before it loads anything. So a test can run `babykev smoke help` with no model.
It goes in the tests of the command, and uses their helper `run`.

[± See the change to `tests/unit/test_cli.py`](#tut-20.13-tests-unit-test_cli.py-44d4a0)

In `tests/unit/test_cli.py`, the docstring on line 1 names `smoke help`, the import is on line 6, and the new test is
on lines 42 to 50.

```bash
sed -n '42,50p' tests/unit/test_cli.py
just test -k smoke_help
```

`main` of `cli.py` raises `SystemExit` with the code that `smoke.main` returns. The test catches it, and checks the
code, 0, and the usage. pytest prints `1 passed`.

```bash
just test
```

`just test` prints `71 passed`. `cli.py` is back at 100%, and the total is 81%.

#### What changed

- <a id="tut-20.13-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: `babykev smoke help`. 13 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/4322906929f4c1b22be716cd4a341d80b8e75e25/tests/unit/test_cli.py).
  - look at `def test_smoke_help_prints_the_usage(`

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -1,8 +1,9 @@
-"""Unit tests for the `babykev` command: `help` prints the help, any other word is refused."""
+"""Unit tests for the `babykev` command: `help`, `smoke help`, and the words that it refuses."""
 
 import pytest
 
 from babykev.cli import HELP, main
+from babykev.smoke import USAGE
 
 
 def run(
@@ -36,3 +37,14 @@ def test_an_unknown_command_is_refused_with_exit_code_2(
     err = capsys.readouterr().err
     assert "no command named 'train'" in err
     assert "babykev help" in err
+
+
+def test_smoke_help_prints_the_usage(
+    monkeypatch: pytest.MonkeyPatch,  # Sets the command line for the test
+    capsys: pytest.CaptureFixture[str],  # Catches the usage
+) -> None:
+    """`babykev smoke help` prints the usage of the smoke, loads no model, and exits with 0."""
+    with pytest.raises(SystemExit) as exit_info:
+        run(monkeypatch, "smoke", "help")
+    assert exit_info.value.code == 0
+    assert capsys.readouterr().out == USAGE
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4322906929f4c1b22be716cd4a341d80b8e75e25). [The code after it](https://github.com/rahuldave/babykev/tree/4322906929f4c1b22be716cd4a341d80b8e75e25).

<a id="tut-20.14"></a>

### 20.14 babykev smoke refuses a word it does not know

A word after `babykev smoke` that is not `help` gets the usage on the error stream, and exit code 2.

[± See the change to `tests/unit/test_cli.py`](#tut-20.14-tests-unit-test_cli.py-44d4a0)

In `tests/unit/test_cli.py`, the new test is on lines 53 to 61.

```bash
just test
```

`just test` prints `72 passed`, and the total is 82%. The missing lines of `smoke.py` are
`35-36, 45-49, 78-92, 105-119`. Lines 105 to 119 load the real model. `answer` and the body of `smoke` need a model,
and no unit test has one.

#### What changed

- <a id="tut-20.14-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: a word that `babykev smoke` refuses. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/13ba53784ecd145301a1413d56e43938365bbf99/tests/unit/test_cli.py).
  - look at `def test_smoke_refuses_a_word_it_does_not_know(`

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -48,3 +48,14 @@ def test_smoke_help_prints_the_usage(
         run(monkeypatch, "smoke", "help")
     assert exit_info.value.code == 0
     assert capsys.readouterr().out == USAGE
+
+
+def test_smoke_refuses_a_word_it_does_not_know(
+    monkeypatch: pytest.MonkeyPatch,  # Sets the command line for the test
+    capsys: pytest.CaptureFixture[str],  # Catches the usage, on the error stream
+) -> None:
+    """A word after `babykev smoke` that is not help gets the usage and exit code 2."""
+    with pytest.raises(SystemExit) as exit_info:
+        run(monkeypatch, "smoke", "local")
+    assert exit_info.value.code == 2
+    assert capsys.readouterr().err == USAGE
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/13ba53784ecd145301a1413d56e43938365bbf99). [The code after it](https://github.com/rahuldave/babykev/tree/13ba53784ecd145301a1413d56e43938365bbf99).

<a id="tut-20.15"></a>

### 20.15 The README names the tests of the smoke

The row of `tests/unit/` names the tests of the smoke too.

[± See the change to `README.md`](#tut-20.15-README.md-8ec9a0)

In `README.md`, line 83 is the row of `tests/unit/`.

```bash
just check
```

`just check` passes. The tests print `72 passed`, and the total of 82%. `just docs check` prints `85 of 85`.

#### What changed

- <a id="tut-20.15-README.md-8ec9a0"></a>`README.md`: the tests of the smoke, in the row of `tests/unit/`. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/ebfa2a8cee251782b3709a379c35af77c80c6170/README.md).
  - look at ``| `tests/unit/` | The tests of the contract, of the command, of the model and of the smoke. One test checks every line of the sample data against the contract |``

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -80,7 +80,7 @@ yourself at any time.
 | `src/babykev/model.py` | The model, a language model with a head that points at the options |
 | `src/babykev/smoke.py` | The smoke run, which asks the real model the sample requests on this machine |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
-| `tests/unit/` | The tests of the contract, of the command and of the model. One test checks every line of the sample data against the contract |
+| `tests/unit/` | The tests of the contract, of the command, of the model and of the smoke. One test checks every line of the sample data against the contract |
 | `tests/conftest.py` | The fixtures that every test can ask for: the tiny tokenizer, a tiny model and a record |
 | `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |
 | `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ebfa2a8cee251782b3709a379c35af77c80c6170).

This part ends at the code at `tut-20`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-20)

<a id="tut-21"></a>

## 21 Integration tests, and the floor

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-20`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-20)

The tests here run several parts together. When the coverage passes 90%, `just check` gets a floor.

```bash
just setup
```

`just setup` prints `Resolved 67 packages`.

An integration test runs several of our parts together. On the tiny model, it needs no download, and only our code can
make it fail, so it is hermetic. The tests here check what trains, a pass over records of different lengths,
and the whole smoke. Then the coverage is over 90%, and `just check` gets a floor.

<a id="tut-21.1"></a>

### 21.1 With an adapter, only the adapter and the head train

Training changes the adapter and the head, and the backbone stays as it is. The test makes a tiny model with an
adapter of rank 4, and takes one backward pass. Then it names every parameter that got a gradient. The fixture
`model` has no adapter, so the test calls `tiny_backbone` itself.

[± See the change to `tests/unit/test_model.py`](#tut-21.1-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the import is on line 18, and the new test is on lines 112 to 130.

```bash
sed -n '112,130p' tests/unit/test_model.py
just test -k only_the_adapter
```

Line 127 checks that every parameter with a gradient is in the adapter, `lora_`, or in the head, `head.`. Lines 128 to
130 check that `trainable_parameters` lists exactly those. pytest prints `1 passed`.

```bash
just test --cov-fail-under=90
```

`--cov-fail-under=90` makes pytest fail when the total is under 90%. It prints `73 passed`, then `FAIL Required test
coverage of 90% not reached. Total coverage: 83.52%`, and ends with exit code 1. `model.py` is at 94%, and lines 211 to
218 and 277 have run. `smoke.py` is at 48%, and misses lines `35-36, 45-49, 78-92, 105-119`.

#### What changed

- <a id="tut-21.1-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: one backward pass with an adapter. 22 lines added. [The file](https://github.com/rahuldave/babykev/blob/0be44c1de17b8acb4e18a964a782584eb26fee97/tests/unit/test_model.py).
  - look at `def test_with_an_adapter_only_the_adapter_and_the_head_train(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -15,6 +15,7 @@ from babykev.model import (
     pick_device,
     user_tokens,
 )
+from tests.tiny import tiny_backbone
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -106,3 +107,24 @@ def test_pick_device_takes_an_override() -> None:
 def test_pick_device_finds_something_to_run_on() -> None:
     """With no override, the choice is one of the three kinds of device."""
     assert pick_device() in {"cuda", "mps", "cpu"}
+
+
+def test_with_an_adapter_only_the_adapter_and_the_head_train(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """The backbone is frozen: gradients reach the adapter and the pointer head, nothing else."""
+    model = DecisionModel("tiny", "cpu", lora=4, backbone=tiny_backbone(len(tok)))
+    enc = encode(tok, record)
+    labels = torch.tensor(enc["labels"])
+    losses = [
+        torch.nn.functional.cross_entropy(z[None], y[None])
+        for z, y in zip(model(enc), labels, strict=True)
+    ]
+    torch.stack(losses).sum().backward()
+    with_gradient = {name for name, p in model.named_parameters() if p.grad is not None}
+    assert with_gradient
+    assert all("lora_" in name or name.startswith("head.") for name in with_gradient)
+    assert {id(p) for p in model.trainable_parameters()} == {
+        id(p) for name, p in model.named_parameters() if name in with_gradient
+    }
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0be44c1de17b8acb4e18a964a782584eb26fee97). [The code after it](https://github.com/rahuldave/babykev/tree/0be44c1de17b8acb4e18a964a782584eb26fee97).

<a id="tut-21.2"></a>

### 21.2 Records of different lengths answer in one pass as alone

`forward_batch` reads several records in one pass. They are padded to the length of the longest. The test packs the
record of the fixture and a shorter record, and runs them in one pass. It compares each with a pass of its own.

[± See the change to `tests/unit/test_model.py`](#tut-21.2-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 133 to 146.

```bash
just test -k different_lengths
```

pytest prints `1 passed`. Line 241 builds the mask of each record, with its padding, and every test of the model has
run it. Only this test runs it with padding to build.

```bash
just test --cov-fail-under=90
```

pytest prints `74 passed`, and `Total coverage: 83.52%` again. The test adds no line to the coverage, and the floor
still fails.

#### What changed

- <a id="tut-21.2-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: a padded pass. 16 lines added. [The file](https://github.com/rahuldave/babykev/blob/e6248c7e2cf3b6b45f11e0ecfdd7f25a23745aac/tests/unit/test_model.py).
  - look at `def test_records_of_different_lengths_answer_in_one_pass_as_alone(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -128,3 +128,19 @@ def test_with_an_adapter_only_the_adapter_and_the_head_train(
     assert {id(p) for p in model.trainable_parameters()} == {
         id(p) for name, p in model.named_parameters() if name in with_gradient
     }
+
+
+def test_records_of_different_lengths_answer_in_one_pass_as_alone(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Padded to the longest, each record gets the logits that it gets in a pass of its own."""
+    short = {"state": "Brie.", "questions": record["questions"][:1]}
+    encs = [encode(tok, record), encode(tok, short)]
+    with torch.no_grad():
+        together = model.forward_batch(encs)
+        alone = [model(enc) for enc in encs]
+    for batch, single in zip(together, alone, strict=True):
+        for a, b in zip(batch, single, strict=True):
+            assert torch.allclose(a, b, atol=1e-5)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e6248c7e2cf3b6b45f11e0ecfdd7f25a23745aac). [The code after it](https://github.com/rahuldave/babykev/tree/e6248c7e2cf3b6b45f11e0ecfdd7f25a23745aac).

<a id="tut-21.3"></a>

### 21.3 The smoke reports on every question, on the tiny model

`smoke` takes a model and a tokenizer. With the tiny ones, the five sample requests go through the contract, the
packing, the model and the answers, with no download. The answers mean nothing. The report must have a verdict for
each of the fifteen questions, and the count.

[± See the change to `tests/unit/test_smoke.py`](#tut-21.3-tests-unit-test_smoke.py-89db04)

In `tests/unit/test_smoke.py`, the imports are on lines 3 to 6, and the new test is on lines 32 to 42.

```bash
sed -n '32,42p' tests/unit/test_smoke.py
just test -k smoke_reports
```

pytest prints `1 passed`. The name of the test says `smoke`, and it is an integration test, of our function `smoke` on
the tiny model. A smoke run uses the real model.

```bash
just test --cov-fail-under=90
```

pytest prints `75 passed`, then `Required test coverage of 90% reached. Total coverage: 91.76%`. The missing lines
need the Hub or a GPU of NVIDIA. They are `63, 72-75, 204-207` of `model.py`, and `105-119` of `smoke.py`.

#### What changed

- <a id="tut-21.3-tests-unit-test_smoke.py-89db04"></a>`tests/unit/test_smoke.py`: the whole smoke, on the tiny model. 17 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/08acf0a3770d58ab7fc3ac85eebf5cf9ed0bad0e/tests/unit/test_smoke.py).
  - look at `def test_smoke_reports_on_every_question_of_the_sample(`

<details><summary>The diff of <code>tests/unit/test_smoke.py</code></summary>

```diff
@@ -1,6 +1,9 @@
 """Tests of the smoke run, without the real model."""
 
-from babykev.smoke import verdict
+from transformers import PreTrainedTokenizerFast
+
+from babykev.model import DecisionModel
+from babykev.smoke import read_lines, smoke, verdict
 
 
 def test_verdict_agrees_when_the_answer_is_the_label() -> None:
@@ -24,3 +27,16 @@ def test_verdict_reads_a_score_answer_as_its_most_likely_level() -> None:
         "level 1",
         True,
     )
+
+
+def test_smoke_reports_on_every_question_of_the_sample(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+) -> None:
+    """Five requests of three questions: fifteen verdicts and a closing count."""
+    lines = read_lines()
+    report = list(smoke(model, tok, lines))
+    verdicts = [text for text in report if text.startswith(("  ok", "  --"))]
+    assert len(verdicts) == sum(len(line["questions"]) for line in lines) == 15
+    right = sum(text.startswith("  ok") for text in verdicts)
+    assert f"\n{right} of 15 right" in report[-2]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/08acf0a3770d58ab7fc3ac85eebf5cf9ed0bad0e). [The code after it](https://github.com/rahuldave/babykev/tree/08acf0a3770d58ab7fc3ac85eebf5cf9ed0bad0e).

<a id="tut-21.4"></a>

### 21.4 The gate has a floor of 90%

`just check` runs the tests with `--cov-fail-under=90`. A change that brings the total under 90% then fails the gate, and the hook refuses it.
`just test` alone has no floor, so a run of a few tests, with `-k`, does not fail on the total.

[± See the change to `justfile`](#tut-21.4-justfile-424f0b)

In the `justfile`, line 82 is `just test -q --cov-fail-under=90`, and the comment on line 72 names the coverage.

```bash
just --show check
just check
```

`just check` prints `Required test coverage of 90% reached. Total coverage: 91.76%` after the tests, and ends with
exit code 0.

#### What changed

- <a id="tut-21.4-justfile-424f0b"></a>`justfile`: the floor, in the gate. 2 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/57604134d9590c16b1c4db0b1d1a11509a65345b/justfile).
  - look at `    just test -q --cov-fail-under=90`

<details><summary>The diff of <code>justfile</code></summary>

```diff
@@ -69,7 +69,7 @@ types *args:
 test *args:
     @{{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
 
-# Run the checks one after another, and stop at the first that fails: the format, the linter, the types, the tests, the docs, the config files
+# Run the checks one after another, and stop at the first that fails: the format, the linter, the types, the tests and their coverage, the docs, the config files
 [group('quality')]
 [no-exit-message]
 check *args:
@@ -79,7 +79,7 @@ check *args:
     just fmt --check
     just lint
     just types
-    just test -q
+    just test -q --cov-fail-under=90
     just docs check
     just lint-config
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/57604134d9590c16b1c4db0b1d1a11509a65345b). [The code after it](https://github.com/rahuldave/babykev/tree/57604134d9590c16b1c4db0b1d1a11509a65345b).

<a id="tut-21.5"></a>

### 21.5 The README names the floor

The README says that one of the checks of `just check` is the floor.

[± See the change to `README.md`](#tut-21.5-README.md-8ec9a0)

In `README.md`, the two lines are 70 and 71.

```bash
grep -n '90%' README.md
```

`grep` prints line 71, with the floor.

#### What changed

- <a id="tut-21.5-README.md-8ec9a0"></a>`README.md`: the floor of 90%, in the lines on `just check`. 2 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/922d6ba2495756622ad215301da7c48f2ec33fa9/README.md).
  - look at ``The tests must run at least 90% of the code. You can run `just check` yourself at any time.``

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -67,8 +67,8 @@ downloads the base model from the Hugging Face Hub, about 1 GB. It answers the f
 untrained, and prints each answer beside its label.
 
 Run `just hook` once in each clone. It installs a git hook, which runs `just check` before each commit.
-`just check` runs every check of the project, and if one fails, git makes no commit. You can run `just check`
-yourself at any time.
+`just check` runs every check of the project, and if one fails, git makes no commit. One check is a floor.
+The tests must run at least 90% of the code. You can run `just check` yourself at any time.
 
 ## What is here
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/922d6ba2495756622ad215301da7c48f2ec33fa9).

This part ends at the code at `tut-21`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-21)

<a id="tut-22"></a>

## 22 The mask, with hypothesis

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-21`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-21)

The mask decides which token of a request may see which other token. Its lines all run in a test, and no test looks
at what it lets through. The tests here look, at first on one small request, and then with hypothesis, on many.

```bash
just setup
```

`just setup` prints `Resolved 67 packages`.

The mask of `model.py` decides which token may attend to which. A token of a question may see the state and the
tokens of its own question before it, and never a token of another question. Every check has passed since `model.py`
came in, and the coverage of `branch_mask` is 100%. But no test has looked at what the mask allows.

The tests here look, and they find that a question sees the questions before it. The code runs, its types are
right, and its lines are covered. It does the wrong thing for its task.

<a id="tut-22.1"></a>

### 22.1 The picture of the mask of a small request

The first test draws the mask of one small request by hand. The request has a state of two tokens and two questions
of two tokens each, so its segments are `[0, 0, 1, 1, 2, 2]`. Row i of the picture is token i, and column j is token
j. `#` means that token i may attend to token j, and `.` means that it may not.

[± See the new file `tests/unit/test_mask.py`](#tut-22.1-tests-unit-test_mask.py-aeb55a)

The new file `tests/unit/test_mask.py` has `allowed` on lines 8 to 12, and the test on lines 15 to 26.

```bash
sed -n '15,26p' tests/unit/test_mask.py
just test -k small_request -vv
```

`allowed` reads the mask back as yes or no. `branch_mask` gives 0 where a token may attend, and a very negative
number where it may not. Rows 5 and 6 of the picture are the tokens of question 2. They see the state, columns 1 and
2, and their own question, columns 5 and 6, and not question 1, columns 3 and 4.

The test fails. `-vv` makes pytest print both lists whole. Rows 5 and 6 of the mask are `#####.` and `######`, where
the picture has `##..#.` and `##..##`. Question 2 sees question 1.

#### What changed

- <a id="tut-22.1-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the picture of a small request. New, 26 lines. [The file](https://github.com/rahuldave/babykev/blob/e7db07241985b2cc80908d108e4229cfb512646b/tests/unit/test_mask.py).
  - look at `def test_mask_of_a_small_request() -> None:`

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -0,0 +1,26 @@
+"""Tests of the mask: which token of a packed record may attend to which."""
+
+import torch
+
+from babykev.model import branch_mask
+
+
+def allowed(
+    seg: list[int],  # The segment of each token: 0 for the state, k for question k
+) -> torch.Tensor:  # Shape [n, n]: True where token i may attend to token j
+    """Read the mask back as yes or no."""
+    return branch_mask(seg, "cpu")[0, 0] == 0
+
+
+def test_mask_of_a_small_request() -> None:
+    """A state of two tokens, and two questions of two tokens: the picture, drawn by hand."""
+    picture = [
+        "#.....",
+        "##....",
+        "###...",
+        "####..",
+        "##..#.",
+        "##..##",
+    ]
+    rows = ["".join("#" if ok else "." for ok in row) for row in allowed([0, 0, 1, 1, 2, 2])]
+    assert rows == picture
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e7db07241985b2cc80908d108e4229cfb512646b). [The code after it](https://github.com/rahuldave/babykev/tree/e7db07241985b2cc80908d108e4229cfb512646b).

<a id="tut-22.2"></a>

### 22.2 hypothesis, in the group test

A picture checks one size of request. The mask must hold for every size, and nobody can draw them all. hypothesis is
a library for tests. A test states a rule, and hypothesis draws many inputs and runs the test on each.

[hypothesis](https://hypothesis.readthedocs.io/) writes test inputs. A test says what kind of input it takes, such as a list of up to five numbers. hypothesis then tries many of them, and when one fails, it shrinks it to the smallest input that still fails.

This change came from running `uv add --group test hypothesis`.

`uv add` prints `Resolved 69 packages`, and installs hypothesis and sortedcontainers, which
hypothesis needs.

In `pyproject.toml`, the group `test` has `"hypothesis>=6.170.0",` on line 51. `uv.lock` has the exact versions.

```bash
uv run python -c "import hypothesis; print(hypothesis.__version__)"
```

It prints the version of hypothesis that uv installed.

#### What changed

- <a id="tut-22.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: hypothesis, in the group `test`. 1 line added. It comes from `uv add --group test hypothesis`. [The file](https://github.com/rahuldave/babykev/blob/aa4f870deb9ec19ee18484e187f5d850399fa554/pyproject.toml).
  - look at `"hypothesis>=6.170.0",`
- <a id="tut-22.2-uv.lock-8356d8"></a>`uv.lock`: the exact versions of hypothesis and sortedcontainers. 80 lines added. It comes from `uv add --group test hypothesis`. [The file](https://github.com/rahuldave/babykev/blob/aa4f870deb9ec19ee18484e187f5d850399fa554/uv.lock).

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -48,6 +48,7 @@ lint = [
     "yamllint>=1.38.0",
 ]
 test = [
+    "hypothesis>=6.170.0",
     "pytest>=9.1.1",
     "pytest-cov>=7.1.0",
 ]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/aa4f870deb9ec19ee18484e187f5d850399fa554). [The code after it](https://github.com/rahuldave/babykev/tree/aa4f870deb9ec19ee18484e187f5d850399fa554).

<a id="tut-22.3"></a>

### 22.3 No question sees another, for any shape of request

The shape of a request is the length of its state and of each question. A strategy of hypothesis says what an input
may be. `shapes` draws a state of 1 to 6 tokens, then up to 4 questions of 1 to 5 tokens each. `segments` lays out a
shape as `encode` does. The test states the rule that no token of a question attends to a token of another question.
`@given(shapes)` runs it on up to 100 shapes.

[± See the change to `tests/unit/test_mask.py`](#tut-22.3-tests-unit-test_mask.py-aeb55a)

In `tests/unit/test_mask.py`, `shapes` is on line 10, `segments` on lines 13 to 18, and the new test on lines 42 to
49.

```bash
sed -n '42,49p' tests/unit/test_mask.py
just test -k no_question_sees_another
```

`siblings`, on line 48, is true for two tokens of two different questions. The assert on line 49 says that no pair
is both allowed and siblings.

The test fails. When a shape breaks the rule, hypothesis tries smaller shapes, and reports the smallest that still
breaks it. It reports `shape=(1, [1, 1])`, a state of one token and two questions of one token. `allowed([0, 1, 2])`
has `True` in row 3, column 2. So the token of question 2 sees the token of question 1.

Under the shape, hypothesis lists lines of torch that only the failing examples ran, and they say nothing about the
mask. hypothesis keeps the failing shape in the folder `.hypothesis`, and tries it first at the next run. The
`.gitignore` of GitHub names the folder already.

#### What changed

- <a id="tut-22.3-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the shapes, and the first rule. 23 lines added. [The file](https://github.com/rahuldave/babykev/blob/857445da99027d423543017a9face7f2cd41ea19/tests/unit/test_mask.py).
  - look at `def test_no_question_sees_another_question(`

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -1,9 +1,22 @@
 """Tests of the mask: which token of a packed record may attend to which."""
 
 import torch
+from hypothesis import given
+from hypothesis import strategies as st
 
 from babykev.model import branch_mask
 
+# A request of any shape: a state of 1 to 6 tokens, then up to 4 questions of 1 to 5 tokens each
+shapes = st.tuples(st.integers(1, 6), st.lists(st.integers(1, 5), max_size=4))
+
+
+def segments(
+    state: int,  # How many tokens the state has
+    questions: list[int],  # How many tokens each question has
+) -> list[int]:  # The segment of each token: 0 for the state, k for question k
+    """Lay out a request as `encode` does: the state, then each question in turn."""
+    return [0] * state + [k for k, n in enumerate(questions, start=1) for _ in range(n)]
+
 
 def allowed(
     seg: list[int],  # The segment of each token: 0 for the state, k for question k
@@ -24,3 +37,13 @@ def test_mask_of_a_small_request() -> None:
     ]
     rows = ["".join("#" if ok else "." for ok in row) for row in allowed([0, 0, 1, 1, 2, 2])]
     assert rows == picture
+
+
+@given(shapes)
+def test_no_question_sees_another_question(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """A token of one question never attends to a token of another question."""
+    seg = torch.tensor(segments(*shape))
+    siblings = (seg[:, None] != seg[None, :]) & (seg[:, None] > 0) & (seg[None, :] > 0)
+    assert not (allowed(seg.tolist()) & siblings).any()
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/857445da99027d423543017a9face7f2cd41ea19). [The code after it](https://github.com/rahuldave/babykev/tree/857445da99027d423543017a9face7f2cd41ea19).

<a id="tut-22.4"></a>

### 22.4 No token sees a later token, for any shape of request

The second rule is the causal part of the mask. Nothing above the diagonal is allowed, so a token never attends to a
token after it.

[± See the change to `tests/unit/test_mask.py`](#tut-22.4-tests-unit-test_mask.py-aeb55a)

In `tests/unit/test_mask.py`, the new test is on lines 52 to 57.

```bash
just test -k later_token
```

pytest prints `1 passed`. The causal part of the mask was never wrong. Only the part about the questions is.

#### What changed

- <a id="tut-22.4-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the causal rule. 8 lines added. [The file](https://github.com/rahuldave/babykev/blob/55034fc9085b7ba3a5ac86f3cd40b955a698b642/tests/unit/test_mask.py).
  - look at `def test_no_token_sees_a_later_token(`

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -47,3 +47,11 @@ def test_no_question_sees_another_question(
     seg = torch.tensor(segments(*shape))
     siblings = (seg[:, None] != seg[None, :]) & (seg[:, None] > 0) & (seg[None, :] > 0)
     assert not (allowed(seg.tolist()) & siblings).any()
+
+
+@given(shapes)
+def test_no_token_sees_a_later_token(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """Nothing above the diagonal is allowed: a token never attends to a token after it."""
+    assert not torch.triu(allowed(segments(*shape)), diagonal=1).any()
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/55034fc9085b7ba3a5ac86f3cd40b955a698b642). [The code after it](https://github.com/rahuldave/babykev/tree/55034fc9085b7ba3a5ac86f3cd40b955a698b642).

<a id="tut-22.5"></a>

### 22.5 What the mask allows is exactly the rule

The last rule says the whole of it, in plain Python. Token i may attend to token j when j is not after i, and j is
in the state or in the question of i. The test builds that table for every pair of tokens, and compares it with the
mask.

[± See the change to `tests/unit/test_mask.py`](#tut-22.5-tests-unit-test_mask.py-aeb55a)

In `tests/unit/test_mask.py`, the new test is on lines 60 to 70.

```bash
sed -n '60,70p' tests/unit/test_mask.py
just test -k exactly_the_rule
```

The test fails, and hypothesis shrinks the shape to `(1, [1, 1])` again. The three tests of the rules check the mask
alone, so they are unit tests.

#### What changed

- <a id="tut-22.5-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the whole rule. 13 lines added. [The file](https://github.com/rahuldave/babykev/blob/41b4f5f236a25a9e8438ba2a00682b5125868a50/tests/unit/test_mask.py).
  - look at `def test_what_is_allowed_is_exactly_the_rule(`

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -55,3 +55,16 @@ def test_no_token_sees_a_later_token(
 ) -> None:
     """Nothing above the diagonal is allowed: a token never attends to a token after it."""
     assert not torch.triu(allowed(segments(*shape)), diagonal=1).any()
+
+
+@given(shapes)
+def test_what_is_allowed_is_exactly_the_rule(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """Token i sees token j when j is not after i, and j is in the state or in i's question."""
+    seg = segments(*shape)
+    rule = [
+        [j <= i and (seg[j] == 0 or seg[j] == seg[i]) for j in range(len(seg))]
+        for i in range(len(seg))
+    ]
+    assert allowed(seg).tolist() == rule
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/41b4f5f236a25a9e8438ba2a00682b5125868a50). [The code after it](https://github.com/rahuldave/babykev/tree/41b4f5f236a25a9e8438ba2a00682b5125868a50).

<a id="tut-22.6"></a>

### 22.6 A question cannot see its sibling

The rules check the mask alone. The next three tests check what the mask is for, on the tiny model. Each question
must get the answer that it would get if it were the only question. The first test rewrites question 2 of the record,
and the answers to questions 1 and 3 must not move, to the last bit.

[± See the change to `tests/unit/test_model.py`](#tut-22.6-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 149 to 160.

```bash
sed -n '149,160p' tests/unit/test_model.py
just test -k sibling
```

The test fails on line 160, question 3. Its probabilities were `[0.3341, 0.3331, 0.3328]`, and are
`[0.3343, 0.3330, 0.3327]` after question 2 changed. Question 3 sees question 2. Line 159, question 1, passes, because
question 1 comes first and sees only the state. The tiny model is untrained, so the probabilities are close to equal.
`torch.equal` asks for the same numbers, and any change is a failure.

#### What changed

- <a id="tut-22.6-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: rewrite question 2, and questions 1 and 3 keep their answers. 14 lines added. [The file](https://github.com/rahuldave/babykev/blob/12e9fb18c4c86cbd1291da858fd6ad39af01929b/tests/unit/test_model.py).
  - look at `def test_a_question_cannot_see_its_sibling(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -144,3 +144,17 @@ def test_records_of_different_lengths_answer_in_one_pass_as_alone(
     for batch, single in zip(together, alone, strict=True):
         for a, b in zip(batch, single, strict=True):
             assert torch.allclose(a, b, atol=1e-5)
+
+
+def test_a_question_cannot_see_its_sibling(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Rewriting question 2 leaves the answers to questions 1 and 3 exactly as they were."""
+    before = model.probs(encode(tok, record))
+    changed = {**record, "questions": list(record["questions"])}
+    changed["questions"][1] = {"instr": "Where from?", "options": ["Spain", "Italy"], "label": 0}
+    after = model.probs(encode(tok, changed))
+    assert torch.equal(before[0], after[0])
+    assert torch.equal(before[2], after[2])
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/12e9fb18c4c86cbd1291da858fd6ad39af01929b). [The code after it](https://github.com/rahuldave/babykev/tree/12e9fb18c4c86cbd1291da858fd6ad39af01929b).

<a id="tut-22.7"></a>

### 22.7 Packed questions answer as they would alone

The second test of isolation packs the three questions of the record in one pass. Then it asks each question in a
record of its own, with the same state. The answers must be the same, to within `1e-6`.

[± See the change to `tests/unit/test_model.py`](#tut-22.7-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 163 to 172.

```bash
just test -k packed_questions
```

The test fails on question 2. Packed, it gets `[0.3321, 0.3346, 0.3333]`, and alone it gets
`[0.3317, 0.3351, 0.3332]`. Question 1 passed the loop before it, for the reason of the last test.

#### What changed

- <a id="tut-22.7-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: three questions in one pass, and each alone. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/d3e4a6a067cd7f481a1bd327af08cb2358429e9c/tests/unit/test_model.py).
  - look at `def test_packed_questions_answer_as_they_would_alone(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -158,3 +158,15 @@ def test_a_question_cannot_see_its_sibling(
     after = model.probs(encode(tok, changed))
     assert torch.equal(before[0], after[0])
     assert torch.equal(before[2], after[2])
+
+
+def test_packed_questions_answer_as_they_would_alone(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """One pass over three questions gives what three passes, of one question each, give."""
+    packed = model.probs(encode(tok, record))
+    for together, question in zip(packed, record["questions"], strict=True):
+        alone = model.probs(encode(tok, {"state": record["state"], "questions": [question]}))[0]
+        assert torch.allclose(together, alone, atol=1e-6)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/d3e4a6a067cd7f481a1bd327af08cb2358429e9c). [The code after it](https://github.com/rahuldave/babykev/tree/d3e4a6a067cd7f481a1bd327af08cb2358429e9c).

<a id="tut-22.8"></a>

### 22.8 The order of questions does not matter

The positions of every question restart after the state. So a question must get the same answer first or last. The
third test of isolation asks the questions in the reverse order.

[± See the change to `tests/unit/test_model.py`](#tut-22.8-tests-unit-test_model.py-583145)

In `tests/unit/test_model.py`, the new test is on lines 175 to 184.

```bash
just test -k questions_does_not_matter
```

The test fails on question 1. In the reverse order it comes last, and sees the two other questions. Its
probabilities go from `[0.5016, 0.4984]` to `[0.5007, 0.4993]`. `-k order_of_questions` would also choose a test of
`test_api.py`, so the command names the end of the test.

#### What changed

- <a id="tut-22.8-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the questions in the reverse order. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/c3e2706e2b1fbc58bda631e173e26145256bc47e/tests/unit/test_model.py).
  - look at `def test_the_order_of_questions_does_not_matter(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -170,3 +170,15 @@ def test_packed_questions_answer_as_they_would_alone(
     for together, question in zip(packed, record["questions"], strict=True):
         alone = model.probs(encode(tok, {"state": record["state"], "questions": [question]}))[0]
         assert torch.allclose(together, alone, atol=1e-6)
+
+
+def test_the_order_of_questions_does_not_matter(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Positions restart after the state, so a question gets the same answer first or last."""
+    forward = model.probs(encode(tok, record))
+    backward = model.probs(encode(tok, {**record, "questions": record["questions"][::-1]}))
+    for a, b in zip(forward, backward[::-1], strict=True):
+        assert torch.allclose(a, b, atol=1e-6)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c3e2706e2b1fbc58bda631e173e26145256bc47e). [The code after it](https://github.com/rahuldave/babykev/tree/c3e2706e2b1fbc58bda631e173e26145256bc47e).

<a id="tut-22.9"></a>

### 22.9 A fix for the picture, wrong on purpose

The mistake of this move is on purpose. The picture failed on rows 5 and 6, where question 2 sees question 1. A quick
fix blocks only the question just before a question. A token sees its own question, the state, and any question two
or more before it. The fix makes the picture right.

[± See the change to `src/babykev/model.py`](#tut-22.9-src-babykev-model.py-a86a0b)

In `src/babykev/model.py`, line 159 now ends with `| (s[None, :] < s[:, None] - 1)`. A token may see a question
whose number is less than its own minus one.

```bash
just test
```

The picture passes, and so does the test of the siblings. 4 tests fail, 78 pass. The two rules that failed before
fail again, and hypothesis shrinks each to `shape=(1, [1, 1, 1])`, three questions of one token. The token of
question 3 sees the token of question 1. The stored shape `(1, [1, 1])` passes now, so hypothesis looks for a new one.
The test of the packed questions and the test of the order fail too, on a question that sees a question two before
it.

The picture has two questions, so it cannot tell. The test of the siblings rewrites question 2, which question 3 no
longer sees. A rule for every shape found the size with three questions.

#### What changed

- <a id="tut-22.9-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: a mask that blocks only the question just before, on purpose. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/18bdfee89d950245956448ab8377cfc8b90e8595/src/babykev/model.py).
  - look at `    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)`

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

```diff
@@ -156,7 +156,7 @@ def branch_mask(
     s = torch.tensor(seg, device=device)
     n = len(seg)
     causal = torch.tril(torch.ones(n, n, dtype=torch.bool, device=device))
-    same = torch.ones_like(causal) | (s[None, :] == 0)
+    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)
     allow = causal & same
     blocked = torch.finfo(dtype).min
     return torch.zeros(n, n, dtype=dtype, device=device).masked_fill(~allow, blocked)[None, None]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/18bdfee89d950245956448ab8377cfc8b90e8595). [The code after it](https://github.com/rahuldave/babykev/tree/18bdfee89d950245956448ab8377cfc8b90e8595).

<a id="tut-22.10"></a>

### 22.10 A token sees the state and its own question

The line of the mask becomes kev's line. A token may attend to a token of the state, `s[None, :] == 0`, or to a token
of its own question, `s[None, :] == s[:, None]`. `causal`, on line 158, keeps out every token after it, and line 160
joins the two. The docstring of `branch_mask`, lines 150 to 154, has stated this rule from the start.

[± See the change to `src/babykev/model.py`](#tut-22.10-src-babykev-model.py-a86a0b)

In `src/babykev/model.py`, line 159 is `same = (s[None, :] == s[:, None]) | (s[None, :] == 0)`.

```bash
just test
```

`just test` prints `82 passed`, and the total of 92%. A test of what the mask allows adds no line
to the coverage. `branch_mask` was covered all along.

The smoke runs the real model on the sample again, with the right mask.

```bash
just smoke
```

The smoke prints `4 of 15 right`. Questions 2 and 3 of each request now read only the state and themselves, and not
the questions before them. The model is untrained, so the count is a guess, and a right answer is chance.

In tut-18, with the old mask, the smoke printed `6 of 15 right`. The first question of each request keeps its answer,
with the same two decimals. It comes first, so it saw only the state with either mask. Nine of the ten other answers
changed. Both counts are guesses.

#### What changed

- <a id="tut-22.10-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: the state, or the same question. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/5f63fb463f94ae6c82a647db8a4b86d4a3d6caa1/src/babykev/model.py).
  - look at `    same = (s[None, :] == s[:, None]) | (s[None, :] == 0)`

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

```diff
@@ -156,7 +156,7 @@ def branch_mask(
     s = torch.tensor(seg, device=device)
     n = len(seg)
     causal = torch.tril(torch.ones(n, n, dtype=torch.bool, device=device))
-    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)
+    same = (s[None, :] == s[:, None]) | (s[None, :] == 0)
     allow = causal & same
     blocked = torch.finfo(dtype).min
     return torch.zeros(n, n, dtype=dtype, device=device).masked_fill(~allow, blocked)[None, None]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5f63fb463f94ae6c82a647db8a4b86d4a3d6caa1). [The code after it](https://github.com/rahuldave/babykev/tree/5f63fb463f94ae6c82a647db8a4b86d4a3d6caa1).

<a id="tut-22.11"></a>

### 22.11 The README names the tests of the mask

The row of the README for `tests/unit/` names the tests of the mask, and hypothesis.

[± See the change to `README.md`](#tut-22.11-README.md-8ec9a0)

In `README.md`, the row of `tests/unit/` is on line 83.

```bash
just check
```

`just check` passes. The tests print `82 passed` and `Total coverage: 91.76%`. `just docs check` prints `97 of 97`,
with the six functions of `test_mask.py`.

#### What changed

- <a id="tut-22.11-README.md-8ec9a0"></a>`README.md`: the tests of the mask, in the row of `tests/unit/`. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/9bfadf5448a5951580b313a781b277f343aa6e30/README.md).
  - look at `hypothesis tries the rules of the mask on many shapes of request |`

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -80,7 +80,7 @@ The tests must run at least 90% of the code. You can run `just check` yourself a
 | `src/babykev/model.py` | The model, a language model with a head that points at the options |
 | `src/babykev/smoke.py` | The smoke run, which asks the real model the sample requests on this machine |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
-| `tests/unit/` | The tests of the contract, of the command, of the model and of the smoke. One test checks every line of the sample data against the contract |
+| `tests/unit/` | The tests of the contract, of the command, of the model, of its mask and of the smoke. One test checks every line of the sample data against the contract. hypothesis tries the rules of the mask on many shapes of request |
 | `tests/conftest.py` | The fixtures that every test can ask for: the tiny tokenizer, a tiny model and a record |
 | `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |
 | `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9bfadf5448a5951580b313a781b277f343aa6e30).

This part ends at the code at `tut-22`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-22)

<a id="tut-23"></a>

## 23 The system test

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-22`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-22)

Every test so far needs nothing but our code. The last test runs the smoke on the real model.

```bash
just setup
```

`just setup` prints `Resolved 69 packages`.

Every test so far needs nothing but our code. The tiny model is built in memory, so no download, no network and no
device can make a test fail. Such a test is hermetic, and the hook can run it before each `git commit`. The smoke on the
real model is a test too, of the whole program with its real parts. It needs the Hub or its cache, and it is the
system test of the table of the kinds of tests. Here it becomes a test, an experiment shows that it is not
hermetic, and keeps it out of `just test` and the gate.

<a id="tut-23.1"></a>

### 23.1 The smoke on the real model, as a test

The test runs `main` of `smoke.py`, as `babykev smoke` does. It checks what holds on any device, which is the exit
code 0, fifteen verdicts, and the count of the right ones. It does not check the count itself, because an untrained model
guesses.

[± See the new file `tests/system/test_real_model.py`](#tut-23.1-tests-system-test_real_model.py-df0b9d)

The new file `tests/system/test_real_model.py` has the docstring on lines 1 to 7, and the test on lines 14 to 24.

```bash
sed -n '14,24p' tests/system/test_real_model.py
just test
```

`capsys`, on line 15, is the fixture of pytest that catches what the test prints. `just test` prints `83 passed`. The
test loads the real model, so the run takes a few seconds more. `smoke.py` goes to 100%, and the total to 99%. Only
lines 63 and 74 of `model.py` are left, the branch of CUDA and the check of a tokenizer.

A test that needs the network fails without it. `HF_HUB_OFFLINE=1` tells the library of the Hub to make no request,
and `HF_HOME` points its cache at an empty folder. The two together are a machine with no network and no download.

```bash
HF_HUB_OFFLINE=1 HF_HOME="$(mktemp -d)" just test -k real_model
```

The test fails, with `OSError: We couldn't connect to 'https://huggingface.co' to load the files, and couldn't find
them in the cached files.` Nothing in our code changed. So the test is not hermetic.

```bash
HF_HUB_OFFLINE=1 just test -k real_model
```

With the cache of this machine and still no network, the test passes. It passes because the model is in the cache,
and not because it is hermetic.

#### What changed

- <a id="tut-23.1-tests-system-test_real_model.py-df0b9d"></a>`tests/system/test_real_model.py`: the smoke on the real model, as a test. New, 24 lines. [The file](https://github.com/rahuldave/babykev/blob/e8d250399661741adb430b0ab9020fb869279074/tests/system/test_real_model.py).
  - look at `def test_the_real_model_answers_every_sample_question(`

<details><summary>The diff of <code>tests/system/test_real_model.py</code></summary>

```diff
@@ -0,0 +1,24 @@
+"""The smoke on the real model, the one test here that is not hermetic.
+
+The tests under `tests/unit/` need nothing but our code: the tiny model is built in memory. This
+test loads Qwen2.5-0.5B from the Hugging Face Hub, about 1 GB the first time and from the cache
+after that, onto the best device of the machine. The network, the download and the device can
+each make it fail.
+"""
+
+import pytest
+
+from babykev.smoke import main
+
+
+def test_the_real_model_answers_every_sample_question(
+    capsys: pytest.CaptureFixture[str],  # What the smoke prints
+) -> None:
+    """Five requests of three questions: fifteen verdicts, the count of those right, exit 0."""
+    assert main([]) == 0
+    printed = capsys.readouterr().out.splitlines()
+    assert printed[0].startswith("babykev smoke: Qwen/Qwen2.5-0.5B on ")
+    verdicts = [line for line in printed if line.startswith(("  ok", "  --"))]
+    assert len(verdicts) == 15
+    right = sum(line.startswith("  ok") for line in verdicts)
+    assert f"{right} of 15 right" in "\n".join(printed)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e8d250399661741adb430b0ab9020fb869279074). [The code after it](https://github.com/rahuldave/babykev/tree/e8d250399661741adb430b0ab9020fb869279074).

<a id="tut-23.2"></a>

### 23.2 The test of the real model is marked system

A marker is a name that a test carries. `pytestmark` puts a marker on every test of a file. This file gets the marker
`system`.

[± See the change to `tests/system/test_real_model.py`](#tut-23.2-tests-system-test_real_model.py-df0b9d)

In `tests/system/test_real_model.py`, the comment is on line 13, and `pytestmark` on line 14.

```bash
just test -k real_model
```

pytest prints `1 passed`, and a warning, `PytestUnknownMarkWarning: Unknown pytest.mark.system - is this a typo?`.
pytest knows only the markers that it is told about. A marker with a typo in its name would choose no test, with no
error.

#### What changed

- <a id="tut-23.2-tests-system-test_real_model.py-df0b9d"></a>`tests/system/test_real_model.py`: the marker `system`. 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/14e3ab70450cd154b85d49f1b9a694de35a18557/tests/system/test_real_model.py).
  - look at `pytestmark = pytest.mark.system`

<details><summary>The diff of <code>tests/system/test_real_model.py</code></summary>

```diff
@@ -10,6 +10,9 @@ import pytest
 
 from babykev.smoke import main
 
+# Every test of this file needs the network, the real weights and a device
+pytestmark = pytest.mark.system
+
 
 def test_the_real_model_answers_every_sample_question(
     capsys: pytest.CaptureFixture[str],  # What the smoke prints
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/14e3ab70450cd154b85d49f1b9a694de35a18557). [The code after it](https://github.com/rahuldave/babykev/tree/14e3ab70450cd154b85d49f1b9a694de35a18557).

<a id="tut-23.3"></a>

### 23.3 pytest knows the marker system

`markers` in `pyproject.toml` declares each marker, with what it means.

[± See the change to `pyproject.toml`](#tut-23.3-pyproject.toml-5d07e7)

In `pyproject.toml`, the comment is on line 62, and `markers` on line 63.

```bash
just test -k real_model
just test --markers
```

The test passes with no warning. `just test --markers` lists every marker, and the first line is
`@pytest.mark.system: needs the network, the real model or a device`.

#### What changed

- <a id="tut-23.3-pyproject.toml-5d07e7"></a>`pyproject.toml`: the marker `system`, declared. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/e194931f1402c90fe5d4d59d5ac3e5c5846b8ac1/pyproject.toml).
  - look at `markers = ["system: needs the network, the real model or a device"]`

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -59,6 +59,8 @@ testpaths = ["tests"]
 pythonpath = ["."]
 # Every run measures how much of src/babykev the tests run, and lists the lines they do not
 addopts = "--cov=babykev --cov-report=term-missing"
+# A marker is a name that a test can carry, and -m chooses the tests by it
+markers = ["system: needs the network, the real model or a device"]
 
 [tool.ruff]
 # The formatter and the linter share this setting. ruff's own default is 88, and this project uses 100
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e194931f1402c90fe5d4d59d5ac3e5c5846b8ac1). [The code after it](https://github.com/rahuldave/babykev/tree/e194931f1402c90fe5d4d59d5ac3e5c5846b8ac1).

<a id="tut-23.4"></a>

### 23.4 just test leaves out the tests marked system

`-m` chooses the tests by their markers. `-m 'not system'` in `addopts` leaves out every test marked `system` from
every run. A `-m` on the command line comes after `addopts`, and wins.

[± See the change to `pyproject.toml`](#tut-23.4-pyproject.toml-5d07e7)

In `pyproject.toml`, the comment is on lines 60 and 61, and line 62 is
`addopts = "--cov=babykev --cov-report=term-missing -m 'not system'"`.

```bash
just test
just test -m system
```

`just test` prints `82 passed, 1 deselected`, and the total of 92%, as before the test of the real model. `just check` runs
the same tests, so the gate and the hook never need the network. `just test -m system` runs the one test, and prints
`1 passed, 82 deselected`.

#### What changed

- <a id="tut-23.4-pyproject.toml-5d07e7"></a>`pyproject.toml`: the tests marked `system` stay out of every run that does not ask for them. 3 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/12e34ad11cf268f667238c3362902c25b462225c/pyproject.toml).
  - look at `addopts = "--cov=babykev --cov-report=term-missing -m 'not system'"`

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -57,8 +57,9 @@ test = [
 testpaths = ["tests"]
 # A test can import its helpers from the folder tests, for example tests.tiny
 pythonpath = ["."]
-# Every run measures how much of src/babykev the tests run, and lists the lines they do not
-addopts = "--cov=babykev --cov-report=term-missing"
+# Every run measures how much of src/babykev the tests run, and lists the lines they do not. A run
+# leaves out the tests marked system, unless it asks for them: just test -m system
+addopts = "--cov=babykev --cov-report=term-missing -m 'not system'"
 # A marker is a name that a test can carry, and -m chooses the tests by it
 markers = ["system: needs the network, the real model or a device"]
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/12e34ad11cf268f667238c3362902c25b462225c). [The code after it](https://github.com/rahuldave/babykev/tree/12e34ad11cf268f667238c3362902c25b462225c).

<a id="tut-23.5"></a>

### 23.5 The README names the test of the real model

The README says what `just test` runs, and how to run the test of the real model. The table gets a row for
`tests/system/`.

[± See the change to `README.md`](#tut-23.5-README.md-8ec9a0)

In `README.md`, the new paragraph is on lines 69 to 71, and the row of `tests/system/` on line 88.

```bash
just check
```

`just check` passes. The tests print `82 passed, 1 deselected`, and `Total coverage: 91.76%`. `just docs check` prints
`98 of 98`, with the test of the real model.

The project now has all four kinds of tests in the table of the intro.

#### What changed

- <a id="tut-23.5-README.md-8ec9a0"></a>`README.md`: `just test -m system`, and the row of `tests/system/`. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/d9df8f2a02ed7a7780325aebf281d6107317f9d9/README.md).
  - look at ``| `tests/system/` | The test of the real model, marked `system`. `just test -m system` runs it |``

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -66,6 +66,10 @@ too. With them, `.venv` takes about 750 MB, and torch is most of it.
 downloads the base model from the Hugging Face Hub, about 1 GB. It answers the five sample requests,
 untrained, and prints each answer beside its label.
 
+`just test` runs every test that needs nothing but our code. The test in `tests/system/` loads the
+real model, as the smoke does, so it needs the Hub or its cache. It has the marker `system`, and only
+`just test -m system` runs it.
+
 Run `just hook` once in each clone. It installs a git hook, which runs `just check` before each commit.
 `just check` runs every check of the project, and if one fails, git makes no commit. One check is a floor.
 The tests must run at least 90% of the code. You can run `just check` yourself at any time.
@@ -81,6 +85,7 @@ The tests must run at least 90% of the code. You can run `just check` yourself a
 | `src/babykev/smoke.py` | The smoke run, which asks the real model the sample requests on this machine |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
 | `tests/unit/` | The tests of the contract, of the command, of the model, of its mask and of the smoke. One test checks every line of the sample data against the contract. hypothesis tries the rules of the mask on many shapes of request |
+| `tests/system/` | The test of the real model, marked `system`. `just test -m system` runs it |
 | `tests/conftest.py` | The fixtures that every test can ask for: the tiny tokenizer, a tiny model and a record |
 | `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |
 | `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/d9df8f2a02ed7a7780325aebf281d6107317f9d9).

This part ends at the code at `tut-23`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-23)

<a id="tut-26.1-to-tut-26.2"></a>

## 26.1 to 26.2 The tests on GitHub

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-25`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-25)

```bash
just setup
```

The whole tutorial then writes two pages of a guide to the model. It builds two images of Docker, one to run babykev
and one to work on it. One change there is about the tests. In a container, a test of hypothesis sometimes ran past
its deadline of 200 ms, and failed by chance. A setting in `tests/conftest.py` now turns that deadline off.

The hook runs `just check` only on a machine that has it. A clone without the hook records changes that
never met the checks. GitHub runs `just check` itself, on its own machines, after every push.

<a id="tut-26.1"></a>

### 26.1 GitHub runs the gate after every push

The workflow `check.yaml` has one job. It takes the code, installs uv and just, and runs `just setup` and `just
check`, as a student does. It runs after a push to any branch and on every pull request. `branches: ["**"]` leaves
out a push of a tag.

[GitHub Actions](https://docs.github.com/actions) runs commands on GitHub's machines. A workflow, a YAML file in `.github/workflows/`, says when it runs, such as after every push, and which commands its jobs run. Each run shows its log on the page of the repository.

[± See the new file `.github/workflows/check.yaml`](#tut-26.1-.github-workflows-check.yaml-6ceb50)

The new file `.github/workflows/check.yaml` has `on` on lines 5 to 8, and what the job `check` runs on lines 16
to 21.

```bash
just lint-config
```

yamllint reads every YAML file, and the new file too. It prints `5:1 warning truthy value should be one of [false,
true] (truthy)`. `just lint-config` ends with exit code 2, because `--strict` makes a warning fail. YAML 1.1 reads the
word `on` as true. GitHub reads it as the name `on`, and every workflow has it. The next move answers it.

#### What changed

- <a id="tut-26.1-.github-workflows-check.yaml-6ceb50"></a>`.github/workflows/check.yaml`: `just check`, after every push. New, 21 lines. [The file](https://github.com/rahuldave/babykev/blob/2f210829183a3c52bb22f1196d50000716a4beec/.github/workflows/check.yaml).
  - look at `      - run: just check`

<details><summary>The diff of <code>.github/workflows/check.yaml</code></summary>

```diff
@@ -0,0 +1,21 @@
+# The gate, on GitHub: just check, after every push to a branch and on every pull request. The hook
+# runs the same recipe before each commit, on the machine that makes it.
+name: Check
+
+on:
+  push:
+    branches: ["**"]  # every branch, and no tag
+  pull_request:
+
+permissions:
+  contents: read  # the job reads the code, and changes nothing on GitHub
+
+jobs:
+  check:
+    runs-on: ubuntu-latest
+    steps:
+      - uses: actions/checkout@v7
+      - uses: astral-sh/setup-uv@v10.2.0
+      - uses: extractions/setup-just@v4
+      - run: just setup
+      - run: just check
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/2f210829183a3c52bb22f1196d50000716a4beec). [The code after it](https://github.com/rahuldave/babykev/tree/2f210829183a3c52bb22f1196d50000716a4beec).

<a id="tut-26.2"></a>

### 26.2 yamllint lets a key be a word such as on

The rule `truthy` of yamllint has the option `check-keys`. With `false`, the rule checks the values and not the keys.
A value of `on` or `yes` is still a warning.

[± See the change to `.yamllint`](#tut-26.2-.yamllint-dfe50a)

In `.yamllint`, line 7 is `truthy: {check-keys: false}`, with its reason.

```bash
just lint-config
```

`just lint-config` passes.

This tutorial ends here. After it, the whole tutorial checks the workflow with actionlint, and publishes the docs site
on GitHub Pages. The [whole tutorial](https://rahuldave.com/babykev-walk/) has every change.

#### What changed

- <a id="tut-26.2-.yamllint-dfe50a"></a>`.yamllint`: the rule `truthy` checks no key. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/7b7e22f04247cefdd2d01adbe6dff64d88a6116c/.yamllint).
  - look at `  truthy: {check-keys: false}  # a key may be a word such as on, which YAML 1.1 reads as true`

<details><summary>The diff of <code>.yamllint</code></summary>

```diff
@@ -4,3 +4,4 @@ ignore-from-file: .gitignore  # the files that git ignores, such as everything i
 rules:
   document-start: disable  # a file need not start with a line of three dashes
   line-length: {max: 100}  # as long as a line of the Python code
+  truthy: {check-keys: false}  # a key may be a word such as on, which YAML 1.1 reads as true
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7b7e22f04247cefdd2d01adbe6dff64d88a6116c).

This part ends at the code at `7b7e22f04247`, partway through `tut-26`. [The code after this part](https://github.com/rahuldave/babykev/tree/7b7e22f04247cefdd2d01adbe6dff64d88a6116c)
