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

## tut-01 Where we start

Two tools run everything in this lecture. [uv](https://docs.astral.sh/uv/) manages the project. It installs Python and the packages, keeps them in `.venv`, and pins their versions in `uv.lock`. [just](https://just.systems/) runs the tasks of the project by name, from the recipes of its `justfile`.

**Init.** uv makes the environment, before any recipe exists. `uv sync --locked` reads `pyproject.toml` and `uv.lock`, and makes `.venv` with exactly what the lockfile names. In a new clone it prints `Using CPython 3.13.3`, `Creating virtual environment at: .venv` and `Resolved 1 package`. Then it installs one package, babykev itself, as `+ babykev==0.1.0`. `--locked` makes uv refuse a lockfile that no longer matches `pyproject.toml`, so uv never writes a new lockfile on the quiet.

$ uv sync --locked

**The recipe.** `just --show setup` prints the recipe behind the word `setup`. Its comment is the first line, `[group('setup')]` puts it under a heading, and its body runs `uv sync --locked`. The `if` in the body answers the word `help`. `just setup` then prints `Resolved 1 package` and `Checked 1 package`, because `.venv` is already right. From here on, every stop starts with `just setup`.

$ just --show setup
$ just setup

**What is here.** The project has a README, the licence and its notice, `pyproject.toml` with no dependencies, `uv.lock`, a justfile with two recipes, and the command `babykev`. `ls -a` lists them, with `.git` and `.venv`. `.gitignore` is GitHub's template for Python, 220 lines long, and `grep` finds `.venv` on line 155. So git ignores the environment before it exists. No code of kev's is here yet, and each file of kev comes in at the stop that needs it.

$ ls -a
$ grep -n -x '.venv' .gitignore

**The justfile is the interface.** `just` alone lists the recipes, `help` and `setup`, each with the comment above it. `just help setup` prints the line of one recipe, `Install Python and every dependency into .venv, exactly as the lockfile says`. `just setup help` prints the same line, the other way round.

$ just
$ just help setup
$ just setup help

**How a recipe gets its words.** In `just help setup`, the word `setup` goes to the recipe `help`. Line 6 of the justfile, `set positional-arguments`, makes just give each word to the commands of the recipe whole. The first word is `"$1"`, the second `"$2"`, and all of them together are `"$@"`. So a space, a quote or a `*` inside a word stays part of the word.

$ sed -n '5,6p' justfile

**The command.** `uv run babykev help` prints the help, which says that there are no commands yet. `uv run babykev train` prints ``babykev: no command named 'train'. Run `babykev help`.``, and line 20 of `src/babykev/cli.py` exits with code 2. Lines 12 and 13 of `pyproject.toml` make `babykev` a command. The name is on the left, and the function `babykev.cli:main` is on the right.

$ uv run babykev help
$ uv run babykev train
$ sed -n '12,13p' pyproject.toml

## tut-05 The contract, and its tests

**Init.** `just setup` installs 12 packages and builds babykev again. They are pydantic and pydantic-core, pytest, pytest-cov and coverage, and the packages that they need.

$ just setup

**What is new.** `src/babykev/api.py` is the contract of kev, from his first version, without the parts of his server. `data/cheese/sample.jsonl` holds five requests about cheese, each with a `label` on every question. `tests/unit/test_cli.py` tests the command, and `tests/unit/test_api.py` tests the contract. pytest and pytest-cov are in a dependency group, `test`, on lines 25 to 29 of `pyproject.toml`. The justfile has a third recipe, `test`.

**Start from the data.** One line is a request about one cheese, Coquetdale. Its `state` is the context, the text that the questions are about. It asks three questions, a `noul`, a `score` and a `choice`, and each question has its `label`. The five lines are data for the tests, kept in the repository so that the tests can read them.

$ head -n 1 data/cheese/sample.jsonl | uv run python -m json.tool

**The tests.** `uv run pytest` runs them inside `.venv`. pytest reads `[tool.pytest.ini_options]` in `pyproject.toml`, looks under `tests/`, and runs every function whose name starts with `test_`. The first lines say so, with `configfile: pyproject.toml`, `testpaths: tests` and `plugins: cov-7.1.0`. All 43 tests pass, and the table under them says that the tests run every statement of `api.py` and `cli.py`. Line 34 of `pyproject.toml`, which the `grep` line prints, adds `--cov=babykev --cov-report=term-missing` to every run.

$ uv run pytest
$ grep -n -B1 addopts pyproject.toml

**The recipe.** `just --show test` prints the recipe. Its body is one line, `uv run pytest "$@"`, inside an `if` that answers `help`. `"$@"` is every word after `just test`, each one whole. So `just test -k "sample_line or without_questions"` gives pytest two words, `-k` and the whole pattern. It selects 11 tests, all of them pass, and the table says 73%, because it counts only the lines that these tests ran.

$ just --show test
$ just test -k "sample_line or without_questions"

**The tests of the command.** `tests/unit/test_cli.py`, lines 8 to 18, holds a helper and a test. `run` sets `sys.argv`, the words that a program starts with, and calls `main()`, as if a person had typed `babykev` in a terminal. `monkeypatch` and `capsys` are two fixtures of pytest, and pytest passes them in because the test names them as arguments. `monkeypatch.setattr` changes `sys.argv` for this test only, and `capsys` catches what the program printed. `@pytest.mark.parametrize` on line 14 runs the function once for each value in its list, so one function makes four tests, `[words0]` to `[words3]`.

$ sed -n '8,18p' tests/unit/test_cli.py
$ just test -k help_is_printed -v

**Four tests of the contract.** Every test here is a unit test, which runs one function alone. Each test in `test_api.py` has a name that reads as a sentence, and a docstring that states the rule. The file is in sections, from `# The sample data` to `# From probabilities to answers`. For each test below, the `sed` line prints it and the `just test -k` line runs it alone.

**Test 1, small: a request must ask at least one question.** Lines 79 to 82 hold it. `pytest.raises` says that the code must refuse the input. The contract refuses bad input, and the test pins the rule, so that nobody loosens it by mistake. One test passes.

$ sed -n '79,82p' tests/unit/test_api.py
$ just test -k without_questions

**Test 2, small: the limit on options is exact.** Lines 103 to 110 hold it. A choice of 255 options passes, and a choice of 256 is refused. A bug of one too many or one too few lives at a limit, so the test stands at the limit. One test passes.

$ sed -n '103,110p' tests/unit/test_api.py
$ just test -k largest_number

**Test 3, weighty: every line of the sample data fits the contract.** Lines 45 to 52 hold it. `@pytest.mark.parametrize` runs it over the data, one test for each line, so five tests pass. Every line passes the contract, every question becomes one question of the record, and every question has two options at least.

$ sed -n '45,52p' tests/unit/test_api.py
$ just test -k sample_line_fits

**Test 4, weighty: a choice names the most likely option.** Lines 216 to 222 hold it. `to_answers` turns three probabilities into an answer. The answer names `goat`, keeps a probability for each option, and has a confidence of 0.55. `pytest.approx` is how a test compares two floats. One test passes.

$ sed -n '216,222p' tests/unit/test_api.py
$ just test -k choice_answer

**A subset.** `just test -k render` runs 9 tests, and the table says 50%. The table counts the lines that the selected tests ran, so the number to watch is the one for the whole run.

$ just test -k render

**A break.** The `sed` line writes `"NO"` in place of `"no"` on line 65 of `api.py`, where a `noul` becomes two options. `just test` then fails 2 tests, `test_noul_becomes_no_then_yes` and `test_noul_criteria_describe_no_and_yes`, and 41 pass. The tests name the rule that broke.

$ sed -i '' 's/option_text("no", c.get("false"))/option_text("NO", c.get("false"))/' src/babykev/api.py && just test

## tut-08 Fix the two bugs, format and lint

**Init.** `just setup` installs one package, ruff 0.17.1, from a second dependency group, `lint`, on lines 26 to 28 of `pyproject.toml`.

$ just setup

**What is new.** Nine tests of the confidences and of rounding, on lines 250 to 298 of `tests/unit/test_api.py`. Two of them failed on the code of kev, and the code is fixed so that they pass. ruff came in as the formatter and the linter, with its settings in `pyproject.toml` and two recipes, `fmt` and `lint`. `api.py` is formatted and linted. Every check passes here, and the commands below show the work in between on the files as they were.

**Two tests, and the code of kev.** The first `sed` line prints the test of rounding, lines 250 to 256. Its 77 options have the same probability, and they must still sum to 1, within 0.02. The second prints the test of a guess, lines 291 to 293. Three levels with the same probability are a guess, and a guess must have confidence 0. The third prints the two functions of kev that these tests call, from `api.py` as it was at `tut-05`.

$ sed -n '250,256p' tests/unit/test_api.py
$ sed -n '291,293p' tests/unit/test_api.py
$ git show tut-05:src/babykev/api.py | sed -n '82,90p'

**The tests find the bugs.** The `git restore` line puts the file of kev back, from `tut-05`, under the tests of today. `just test -k` then runs the seven tests of the confidences and of rounding, and 3 fail. pytest prints `assert 0.77 == 1 ± 0.02` for the sum of the 77 probabilities, and prints `assert 0.5 == 0 ± 1.0e-12` for the confidence of a guess. A scale of one level stops with `ZeroDivisionError` at line 86, and the last line puts today's file back.

$ git restore --source tut-05 src/babykev/api.py
$ just test -k "rounded_probabilities or score_confidence"
$ git restore src/babykev/api.py

**The fix of rounding.** kev rounded each probability to two decimals, in a function `r2`. With 77 options, each 0.013 became 0.01, and the total came to 0.77. `round_prob`, on lines 114 to 117 of `api.py`, rounds to four decimals, and the total stays close to 1.

$ sed -n '114,117p' src/babykev/api.py

**The fix of confidence.** The confidence of a score is 1 minus a fraction, `spread` divided by a measure. In a guess over three levels, each level has the probability 1/3, so `max` takes level 0 as the most likely. The levels are 0, 1 and 2 away from it, so `spread` is 1/3 × 0 + 1/3 × 1 + 1/3 × 2 = 1. kev divided by the length of the scale, 2, so the confidence was 1 − 1/2 = 0.5.

The fix measures against `guess`, the spread of a guess around the middle level, 1/3 × 1 + 1/3 × 0 + 1/3 × 1 = 2/3. So the confidence is 1 − 1 ÷ (2/3) = −0.5, and line 111 counts a value below 0 as 0.

$ sed -n '99,111p' src/babykev/api.py
$ just test -k "rounded_probabilities or score_confidence"

The seven tests pass now. The tests did not change, and the code did.

**One line that only a test can reach.** The fix added lines 106 and 107, the answer for a scale of one level. A request cannot have such a scale, because a `Score` needs two levels at least. So no test of a request runs line 107. The first command leaves out the one test that calls `score_confidence([1.0])` itself, and the table names line 107 under `Missing`, with `api.py` at 99%.

$ just test --deselect tests/unit/test_api.py::test_score_confidence_is_one_for_a_single_level
$ sed -n '105,107p' src/babykev/api.py

The function is public, and a list of one probability is a legal input. Without lines 106 and 107 it divides by zero. So the test on lines 296 to 298 states the answer, "one level leaves nothing to doubt". The coverage is 100% again, because the test asks the question that the table raised. A test written only to move the number would hide the question.

$ sed -n '296,298p' tests/unit/test_api.py
$ just test -k single_level

**The formatter, on the file before it.** The `git restore` line takes `api.py` as it was at the end of the fixes, before the formatter and the linter, from `tut-06`. `uv run ruff check --statistics` runs the linter on it first, so that we can count again after the formatter. It prints one line for each code with its count, and then `Found 17 errors.`, which is the total. The codes are `E501`, a line over 100 characters, 6 of them, and `E701`, two statements on one line, 4 of them. The others are `N806`, `UP007` and `B905`, 2 each, and `I001`, 1.

$ git restore --source tut-06 src/babykev/api.py
$ uv run ruff check --statistics

`uv run ruff format --check` asks the formatter what it would change, and changes nothing. It prints `1 file would be reformatted, 5 files already formatted`, and above it the changes to `api.py`. The formatter puts a blank line after the docstring of the module, before line 7. It splits the four lines with two statements, at lines 27, 48, 49 and 50. It spreads the long lines 51, 72, 110 and 113 over several lines, one item to a line. Its settings are on lines 43 to 49 of `pyproject.toml`, each with a comment.

$ uv run ruff format --check
$ sed -n '43,49p' pyproject.toml

`just --show fmt` prints the recipe, `uv run ruff format "$@"`. So `just fmt --check` is the command above, and `just fmt` alone rewrites the files. `just fmt` prints `1 file reformatted, 5 files left unchanged`, and `wc -l` then counts 141 lines in place of 114. `just fmt --check` prints `6 files already formatted`, and `just test` says 53 passed, so the formatter changed how the code looks, and never what it does.

$ just --show fmt
$ wc -l src/babykev/api.py
$ just fmt
$ wc -l src/babykev/api.py
$ just fmt --check
$ just test -q

**The linter.** The linter reads the code against the families of rules on lines 51 to 63 of `pyproject.toml`, each with a comment. `just --show lint` prints the recipe, `uv run ruff check "$@"`. `just lint --statistics` now finds 8 problems, where it found 17. The four `E701` went with the formatter, and so did five of the six `E501`. The `E501` that is left is line 5, in the docstring, because the formatter never rewraps text.

$ sed -n '51,63p' pyproject.toml
$ just --show lint
$ just lint --statistics

`just lint` without `--statistics` prints each finding, with its line, a mark under the place and a help text. `B905` is a `zip` without `strict=`, which stops silently at the end of the shorter list. `uv run ruff rule B905` explains any code. Line 67 of `pyproject.toml` lets the tests use `assert`, which rule `S101` refuses in the package.

$ just lint
$ uv run ruff rule B905
$ sed -n '65,67p' pyproject.toml

**Fixes by ruff, and fixes by a person.** `just lint --fix` makes the one safe fix, `I001`, a blank line between the import of the standard library and the import of pydantic. It prints `Found 8 errors (1 fixed, 7 remaining).` The 7 that are left need a person. The `git diff` line shows what the person wrote, against the file that the tools left, in 14 lines.

- **`E501`:** the line of the docstring, written shorter.
- **`UP007`:** `Union[...]` written with `|`, for `JSONContent` and `Question`.
- **`N806`:** `K` and `L` written `k` and `n`.
- **`B905`:** `strict=True` on both calls of `zip`, because the two lists must be of the same length. ruff's own fix would write `strict=False`, and it calls that fix unsafe.

$ just lint --fix
$ git diff -R src/babykev/api.py

The `git restore` line puts the file of `tut-08` back. `just lint` then prints `All checks passed!`, and `just fmt --check` prints `6 files already formatted`.

$ git restore src/babykev/api.py
$ just lint
$ just fmt --check

## tut-12 Clean, and kept clean

**Init.** `just setup` installs 14 packages, among them pre-commit, validate-pyproject and yamllint, and the packages that they need. All three are in the group `lint`, on lines 26 to 31 of `pyproject.toml`.

$ just setup

**What is new.** The linter asks for a type in every signature and a docstring on every public name, and the code has them. A recipe `check` runs every check, and a git hook runs `check`. A recipe `lint-config` checks the files that are not Python.

**Types and docstrings.** Line 66 of `pyproject.toml` turns on `ANN`, a type on every parameter and every return value. Line 67 turns on `D1`, a docstring on every public module, class and function. The `git restore` line takes the code and the tests as they were at `tut-08`, and `just lint --statistics` then finds 57 problems. There are 33 of `ANN201`, a public function with no return type. There are 14 of `ANN001`, a parameter with no type, all in the tests.

$ sed -n '66,67p' pyproject.toml
$ git restore --source tut-08 src tests
$ just lint --statistics

`just lint --fix --unsafe-fixes` prints `Found 57 errors (31 fixed, 26 remaining).` The 31 are `-> None` on the functions that return nothing, because ruff can be sure of `None` and of no other type. `just lint --statistics` shows the 26 that need a person. They are 14 types of parameters in the tests, eight docstrings, two return types that ruff cannot guess, `-> Self` on `_check`, and `*words: str`.

$ just lint --fix --unsafe-fixes
$ just lint --statistics

The `git diff` line counts what a person wrote for the 26, against the files that ruff left, 32 lines in 4 files. Each fixture of pytest gets its type, such as `pytest.MonkeyPatch`. Each of the four classes, three functions and the package gets a docstring of one line. The `git restore` line puts the files of `tut-12` back. The two return types are `to_record` on line 78 of `api.py`, a tuple of two parts, and `cheese_request` in the tests. `just lint` prints `All checks passed!`.

$ git diff -R --stat
$ git restore src tests
$ sed -n '78p' src/babykev/api.py
$ just lint

The types are in the tests too. `run`, on lines 8 to 11 of `tests/unit/test_cli.py`, takes `monkeypatch: pytest.MonkeyPatch` and `*words: str`, and returns `None`. `just test -k unknown_command` runs the test that calls it with the word `train`, and it passes.

$ sed -n '8,11p' tests/unit/test_cli.py
$ just test -k unknown_command

**`just check`.** `just --show check` prints the recipe, a small shell script. After the line for `help`, it runs `just fmt --check`, `just lint`, `just test -q` and `just lint-config`. `set -e` stops it at the first that fails. `just check` runs the four and prints `6 files already formatted`, `All checks passed!`, `53 passed` with the table at 100%, `Valid file: pyproject.toml` and `Resolved 29 packages`. `check` has no floor on the coverage yet, because the model comes in later with no tests at first.

$ just --show check
$ just check

**The hook.** `uv run pre-commit install` is pre-commit, a tool that runs the hooks that `.pre-commit-config.yaml` lists before each `git commit`. `install` writes the script that git runs, and prints `pre-commit installed at .git/hooks/pre-commit`. `just --show hook` prints the recipe around that command, and `just hook` runs it again. `just setup` never runs it, because a hook changes how git behaves, and each clone asks for it once.

$ uv run pre-commit install
$ just --show hook
$ just hook

**What `install` wrote.** Before each `git commit`, git looks in its folder of hooks for a file named `pre-commit`, and runs it. `git rev-parse --git-path hooks` prints where that folder is. `ls` shows `pre-commit` among the `.sample` files that git puts there. `cat` shows the 20 lines that pre-commit wrote, which start pre-commit from the `.venv` of this clone, with `.pre-commit-config.yaml`. The path is of this machine, so git does not track the file, and each clone runs `just hook` to write its own.

$ ls "$(git rev-parse --git-path hooks)"
$ cat "$(git rev-parse --git-path hooks)/pre-commit"

**The hooks it runs.** `.pre-commit-config.yaml` lists four. Lines 10 and 11 refuse a file over 1000 KB, such as a checkpoint of a model. Line 12 refuses the markers that a merge conflict leaves. Lines 15 to 19 refuse a file named `.env`, and lines 20 to 25 run `just check`.

$ cat .pre-commit-config.yaml

**A careless change.** The `perl` line adds `import os` to `api.py`, and nothing uses it. `git commit -am "try"` runs the hooks, and pre-commit prints each with its result. Three say `Passed` or `Skipped`, and then `just check` says `Failed`. Under it is the finding of the linter, `F401 [*] os imported but unused`, with its line and `help: Remove unused import`. `git status` shows `api.py` still changed, and the log still ends at `tut-12`.

$ perl -pi -e 's/^(from typing)/import os\n$1/' src/babykev/api.py
$ git commit -am "try"
$ git status --short
$ git log --oneline -1

The next line puts the file back, because the next try needs `just check` to pass.

$ git restore src/babykev/api.py

**A secret.** The `echo` line writes a `.env` file and adds it with `-f`, because `.gitignore` names `.env`. The try prints `no .env file...Failed`, then the sentence of line 17 of the config, `A .env file holds the settings and secrets of one machine. It is never committed`, and the name of the file. `just check` passes, and git still makes nothing, because one hook failed. The last line takes the file out of git's index, and deletes it.

$ echo X=1 > .env && git add -f .env
$ git commit -m "try"
$ git rm --cached -q .env && rm .env

**The config files are code too.** `just lint-config` runs four checks, one for each kind of file that is not Python. Each runs by hand first, once on the file as it is and once with one change that breaks it. The `git restore` line after each puts the file back, because the next checks read it.

**validate-pyproject.** `pyproject.toml` has a format that a standard writes down, with the sections, the keys of each and the kind of value of each key. `uv run validate-pyproject pyproject.toml` prints `Valid file: pyproject.toml`. The `sed` line writes `requires_python` in place of `requires-python`. The check then prints 32 lines. uv warns that it found no `requires-python` and builds babykev again, and validate-pyproject prints ``[ERROR] `project` must not contain {'requires_python'} properties`` and `Invalid file: pyproject.toml`.

$ uv run validate-pyproject pyproject.toml
$ sed -i '' 's/^requires-python = /requires_python = /' pyproject.toml
$ uv run validate-pyproject pyproject.toml
$ git restore pyproject.toml

**`uv lock --check`.** uv has this check, so it needs no new package. It compares `uv.lock` with `pyproject.toml`, and changes nothing. When they agree it prints `Resolved 29 packages`. The `sed` line writes `"pydantic>=2.14"` in place of `"pydantic>=2.14.1"`, and nobody runs `uv lock`. The check then fails with an error, which says that the lockfile at `uv.lock` needs to be updated, but `--check` was provided.

$ uv lock --check
$ sed -i '' 's/"pydantic>=2.14.1"/"pydantic>=2.14"/' pyproject.toml
$ uv lock --check

The recipes refuse such a lockfile too. Line 9 of the justfile exports `UV_LOCKED`, so `just test -q` fails with the same error, with `UV_LOCKED=1` in place of `--check`, and runs no test.

$ sed -n '8,9p' justfile
$ just test -q
$ git restore pyproject.toml

**`just --fmt --check --unstable`.** just has its own formatter, and needs `--unstable` because just still calls the formatter unstable. It prints nothing when the justfile is formatted. The `sed` line writes `program:="babykev"`, with no spaces. The check then prints the justfile as a diff of 78 lines. Two of them carry the change, `-program:="babykev"` and `+program := "babykev"`, and the last says `error: Formatted justfile differs from original.`

$ just --fmt --check --unstable
$ sed -i '' 's/^program := "babykev"/program:="babykev"/' justfile
$ just --fmt --check --unstable
$ git restore justfile

**yamllint.** `uv run yamllint --strict .` checks every YAML file, and prints nothing when all is well, and `--strict` makes a warning fail too. Here uv first builds babykev again, because `pyproject.toml` changed above. Each setting in `.yamllint` answers a finding of the defaults of yamllint, and the second command runs the defaults on the two YAML files. They find lines over 80 characters, and a missing `---` at the start of each file. Line 3 of `.yamllint` makes yamllint skip what git ignores, such as `.venv`.

$ uv run yamllint --strict .
$ uv run yamllint --strict -d default .pre-commit-config.yaml .yamllint
$ cat .yamllint

The `sed` line indents the `args:` line of `.pre-commit-config.yaml` two spaces too far. yamllint then names the file, and prints `11:15 error syntax error: mapping values are not allowed here (syntax)`, line 11 and column 15. A broken config of the hook would break every `git commit`, and yamllint sees it first.

$ sed -i '' 's/^        args: \[--maxkb=1000\]$/          args: [--maxkb=1000]/' .pre-commit-config.yaml
$ uv run yamllint --strict .
$ git restore .pre-commit-config.yaml

**The recipe.** `just --show lint-config` prints the four checks in one script, where `set -e` stops at the first that fails. `just lint-config` prints `Valid file: pyproject.toml` and `Resolved 29 packages`, and nothing from the other two. The last line of `check` runs it, so the hook runs it too.

$ just --show lint-config
$ just lint-config

## tut-13 Documentation from the code

**Init.** `just setup` installs 5 packages, smalldocs 0.1.5 and fastcore, markdown-it-py, mdit-py-plugins and mdurl, which smalldocs needs. smalldocs is in a third dependency group, `docs`.

$ just setup

**What is new.** `docs/_smalldocs.yml` names the package to document, and the tests to hold to the same rule. The recipe `docs` runs smalldocs. Every parameter, return value and field of the package and of the tests has a description beside it. `just check` runs `just docs check`.

**The recipe.** `just` shows a new group, `docs`, with one recipe. `just help docs` prints its line, `The reference of the code, by smalldocs. Words go to smalldocs api: just docs check, just docs module api`.

$ just
$ just help docs

**What the code says about itself.** `uv run smalldocs api list --dir docs` is the command behind the recipe, and `--dir docs` names the folder of the settings. It prints 14 lines, each module, class and function of the package, with its kind, its full name and the first line of its docstring. `babykev.api` has 4 classes and 7 functions, and `babykev.cli` has `main`.

$ uv run smalldocs api list --dir docs

`just --show docs` prints the recipe, `uv run smalldocs api "$@" --dir docs`. So `just docs list` is the command above.

$ just --show docs
$ just docs list

**One module, as Markdown.** `just docs module api` prints `api.py` as Markdown, 144 lines. Each name has a heading, its signature as a line of Python and its docstring. A table gives each parameter with its type, its default and its description. Under `## render`, the table says that `indent` is `How deeply the value is nested. Each level indents by two spaces`.

$ just docs module api

**Where a description comes from.** The first `sed` line prints `render`, lines 68 to 72 of `api.py`. Each parameter is on its own line, with a comment two spaces after it, and the comment after `-> str:` describes the return. Such a comment is a docment, and smalldocs reads it. The second `sed` line prints `Noul`, lines 16 to 24. A field of a pydantic model has no signature to put a comment on, so it carries `Field(description=...)`, and smalldocs reads that the same way.

$ sed -n '68,72p' src/babykev/api.py
$ sed -n '16,24p' src/babykev/api.py

The tests carry docments too. `run`, on lines 8 to 14 of `tests/unit/test_cli.py`, says what `monkeypatch` and `words` are. `just test -k help_is_printed` runs the four tests that call it, and they pass.

$ sed -n '8,14p' tests/unit/test_cli.py
$ just test -k help_is_printed

**The gaps, as they were.** `just docs check` holds every function, method and class to one rule. A parameter and a return value need a type and a docment, a function needs a docstring, and a field needs a description. A return of `None` needs no docment. The `git restore` line takes the code and the tests of `tut-12`, and `just docs check` then prints `24 of 45 functions, methods and classes are typed and documented`, with exit code 1. Above that line it prints the count for each file, `babykev.api 0 of 12` to `tests/unit/test_cli.py 0 of 3`, and 46 gaps, one to a line.

$ git restore --source tut-12 src tests
$ just docs check

The linter already asked for every type and every public docstring, so 45 of the 46 gaps are docments and descriptions. The other is the docstring of `_check`, a private method, which the linter does not ask for. The `git restore` line puts the files of `tut-13` back, and `just docs check` prints `45 of 45`.

$ git restore src tests
$ just docs check

**Docments and the formatter.** The formatter keeps a comment on its line, as long as the line fits in 100 characters. The `perl` line makes the docment of the return of `to_record`, on line 98, longer, and the line grows to 119 characters. `just lint` reports `E501 Line too long (119 > 100)` at line 98. `just fmt` prints `1 file reformatted`, and the `sed` line shows what it did. The return type is now over three lines, and the comment sits after `]:`, two lines below the arrow.

$ perl -pi -e 's/# The record, and the metadata of each question$/# The record that the model reads, and the metadata of each question/' src/babykev/api.py
$ just lint
$ just fmt
$ sed -n '96,101p' src/babykev/api.py

`just lint` now prints `All checks passed!`, because every line fits. But `just docs check` prints `babykev.api:to_record: no return docment` and `44 of 45`, with exit code 1. smalldocs reads the comment on the line of the return type, and the return type moved. So a docment is one short line, and the docstring holds the rest.

$ just lint
$ just docs check
$ git restore src/babykev/api.py

**`check` has five lines now.** `just --show check` prints `just docs check` between the tests and `just lint-config`. `just check` runs all five, and every one passes.

$ just --show check
$ just check

**The hook refuses a lost docment.** `just hook` installs the hook, if this clone does not have it yet. The `sed` line removes the docment of `indent` in `render`, on line 70. `just docs check` prints `babykev.api:render(indent): no docment`, with the name of the file, the function and the parameter. `git commit -am "try"` then runs `just check` through the hook, and it fails at the docs check with `44 of 45`. `git status --short` shows the file still changed.

$ just hook
$ sed -i '' 's|,  # How deeply the value is nested.*|,|' src/babykev/api.py
$ just docs check
$ git commit -am "try"
$ git status --short
$ git restore src/babykev/api.py

## tut-14 The docs site

**Init.** `just setup` prints `Checked 33 packages`. No package came in, because smalldocs also builds the site.

$ just setup

**What is new.** The settings of the site in `docs/_smalldocs.yml`, a front page, `docs/index.qmd`, and three lines of `.gitignore` for what a build makes. The recipe `docs` builds the site when it gets no words.

**The site, in one command.** `uv run smalldocs render docs` writes the reference pages from the code first, then builds the site into `docs/_site`. It prints `wrote 3 page(s) to docs/_site`, the front page and one page for each module. `git status --short --ignored docs` lists what the build made, `docs/_site/`, `docs/api/` and `docs/_symbols.json`. Each is marked `!!`, because lines 222 to 225 of `.gitignore` name them. The build makes them again each time, so git does not track them.

$ uv run smalldocs render docs
$ git status --short --ignored docs
$ sed -n '222,225p' .gitignore

**How the links are made.** `docs/_symbols.json` maps each name, short and full, to its page and its place on the page, 24 names in all. A name in backticks on any page of the site, such as `to_answers`, becomes a link to its entry. The `sed` line shows the start of `docs/api/api.qmd`, the page that smalldocs wrote for `babykev.api`. Each heading has an id, such as `{#Noul}`, and each entry has a link to its line of source on GitHub.

$ head -n 6 docs/_symbols.json
$ sed -n '1,14p' docs/api/api.qmd

**The recipe.** `just --show docs` prints a script with three branches. The word `help` explains the recipe, no words at all run `uv run smalldocs render docs`, and any other words go to `smalldocs api`. So `just docs` builds the site, and `just docs check` still checks. The `open` line shows the site in the browser.

$ just --show docs
$ just docs
$ open docs/_site/index.html

**The settings and the front page.** Lines 1 to 15 of `docs/_smalldocs.yml` set up the site. They give a title, a sidebar with the front page and a section `Reference`, and a theme. Lines 17 to 21 are the settings of the reference, as before. `docs/index.qmd` is the front page, written by hand, and its last line says that a name in backticks links to its entry. `grep` finds the link that the build made for `to_answers` on the built front page.

$ cat docs/_smalldocs.yml
$ grep -o 'href="api/api.html#to_answers"' docs/_site/index.html

**Still clean.** `just check` passes as at the last stop. The site is for people, and the docs check keeps what it shows complete.

$ just check

## tut-21 A second file: model.py

**Init.** `just setup` brings the stack of the model, 31 packages in all. They are torch, transformers, peft and safetensors, and the packages that they need, and ty, the type checker. From the cache of uv it takes about a second, and the first time on a machine it downloads a few hundred megabytes.

$ just setup

**What is new.** `src/babykev/model.py`, the model of kev, comes in whole from his first version, and `src/babykev/smoke.py` runs it on the real model. `babykev smoke` and `just smoke` run the smoke, and `just types` runs ty, the type checker. A tiny model stands in for the real one in the tests, in `tests/tiny.py` and `tests/conftest.py`. `tests/unit/test_model.py` and `tests/unit/test_smoke.py` hold the tests of the model and of the smoke. `just check` has a floor on the coverage, 90%.

**torch, from its own index.** torch comes in several builds. On Linux, the build on PyPI brings the libraries of CUDA, which a laptop and the tests do not need. Lines 31 to 37 of `pyproject.toml` name the index of PyTorch's builds for the CPU, and send torch there and nothing else. `uv tree --invert --package torch` shows why torch came in first. peft needs torch, through accelerate, and peft added first would have taken torch from PyPI.

$ sed -n '29,37p' pyproject.toml
$ uv tree --invert --package torch

**The four ideas.** The `sed` line prints the docstring of `model.py`, lines 1 to 18, which names them. Packing writes the state and every question into one sequence, marked off by five delimiter tokens. The mask lets each token see the state and its own question, and never another question. The positions restart after the state, so a question looks the same wherever it comes. Pointing scores the closing token of each option against the decide token of the question, and no text is generated.

$ sed -n '1,18p' src/babykev/model.py

**Packing, in the signature.** `encode`, lines 100 to 113, takes a tokenizer, a record as `to_record` returns it, and two limits, and returns an `Encoded`. Each docment says what the parameter is. The docstring says that a record that is too long is refused by name, and nothing is cut to fit.

$ sed -n '100,113p' src/babykev/model.py

**The mask, as designed.** The docstring of `branch_mask`, lines 150 to 155, states the rule. Token i may attend to token j when j is not after i, and j is in the state or in the question of i. The slide draws the rule as a grid. In the cell to watch, a token of question 2 looks at question 1, which a plain causal mask allows and the rule forbids. That one cell is why question 2 gets the same answer whether question 1 was asked or not.

$ sed -n '150,155p' src/babykev/model.py

**Pointing.** `PointerHead`, lines 165 to 186, holds two linear layers and a scaled dot product. The docments carry the shapes, `[d]`, `[K, d]` and `[K]`.

$ sed -n '165,186p' src/babykev/model.py

**What is trained.** The `python` line loads the real model, Qwen2.5-0.5B, with an adapter of rank 16, and counts its parameters. It prints `503290240 494032768 8798208 459264 9257472`, and the first two numbers say that 494,032,768 of the 503,290,240 parameters are the frozen language model. Two parts train, the LoRA adapter, 8,798,208 parameters, and the pointer head, 459,264. So 9,257,472 parameters train, and the smoke prints them as `503M parameters, 9.3M of them trainable`.

$ uv run python -c "from babykev.model import DecisionModel; m = DecisionModel('Qwen/Qwen2.5-0.5B', 'cpu', lora=16); n = lambda ps: sum(p.numel() for p in ps); lora = n(p for k, p in m.named_parameters() if 'lora_' in k); head = n(m.head.parameters()); print(n(m.parameters()), n(m.parameters()) - lora - head, lora, head, n(m.trainable_parameters()))"

**The smoke, as a command.** The name comes from electronics, where a new circuit is switched on to see whether it smokes. A smoke test asks whether the whole program starts and gives an answer at all, and not whether the answer is right. `uv run babykev smoke` loads the real model on the best device of this machine, `mps` here, the GPU of the Mac. It prints the seconds to load and `503M parameters, 9.3M of them trainable`, and then each answer to the five sample requests beside its label. At the end it prints `6 of 15 right`, with the milliseconds of a request, which change from run to run.

$ uv run babykev smoke

`just --show smoke` prints the recipe, which runs `uv run babykev smoke` with the words after `just smoke`. `just smoke` gives the same report, 6 of 15 right. The times change from run to run, and the answers do not. From here on, `just smoke`.

$ just --show smoke
$ just smoke

**The type checker.** A type says what kind of value something is, a whole number, a list of numbers or a tokenizer. Every function of babykev gives the types that it takes and the type that it returns. `uv run ty check` is ty, which compares every call and every `return` with those types, by reading the code and without running it. It prints `All checks passed!`. `just --show types` prints the recipe, `uv run ty check "$@"`, and `just types` gives the same answer.

$ uv run ty check
$ just --show types
$ just types

**Two comments, and what they answer.** The `sed` line prints lines 178 to 180 of `model.py`, a comment of two lines and a `def forward` that ends with `# ty: ignore[invalid-mutable-override]`. With both such comments taken out by the second `sed` line, `just types` prints `Found 2 diagnostics`, both `invalid-mutable-override`, at lines 180 and 260. `nn.Module` declares `forward` as an attribute that may hold any function, and a method of two tensors takes fewer calls. torch only calls `forward`, and never sets it, so the rule is right in general and wrong here. The comment turns off one rule on one line, with its reason above it, and `git restore` puts the comments back.

$ sed -n '178,180p' src/babykev/model.py
$ sed -i '' 's/  # ty: ignore\[invalid-mutable-override\]//' src/babykev/model.py
$ just types
$ git restore src/babykev/model.py

**Fixtures.** A fixture makes a stand-in that tests need, such as a request, a tokenizer or a model, in one place for every test. It is a function marked `@pytest.fixture`, and a test names it as an argument. The `sed` line prints the three fixtures of `tests/conftest.py`, lines 16 to 40. pytest builds `tok` once for the whole run, because of `scope="session"`. It builds `record` and `model` again for each test, so no test can spoil them for the next.

$ sed -n '16,40p' tests/conftest.py

**Writing a fixture.** The tests of the contract build a request with a helper, `cheese_request`, on lines 32 to 43 of `test_api.py`. Six tests call it themselves, as on line 81. The fixture `record` does the same job the other way round, because a test asks for it by name, and pytest calls it. A fixture goes in `conftest.py` when more than one file needs it. If the test leaves something to clean up, the fixture can `yield` its value, and the code after `yield` runs when the test is done.

$ sed -n '32,43p' tests/unit/test_api.py
$ sed -n '81p' tests/unit/test_api.py

**`conftest.py`.** pytest reads `tests/conftest.py` before it runs a test, and every test file under `tests/` can use its fixtures, with no import. `just test --fixtures` lists every fixture that pytest can see, in 124 lines. The fixtures of pytest and of its plugins come first. Ours come at the end, under `fixtures defined from conftest`, each with the line of its `def`, 17, 23 and 31, and its docstring.

$ just test --fixtures

**Fixtures in use.** `test_positions_restart_after_the_state`, lines 48 to 57 of `test_model.py`, takes `tok` and `record`. `test_probabilities_sum_to_one_for_every_question`, lines 21 to 30, takes all three. It expects `[2, 3, 3]`, because the three questions of `record` have 2, 3 and 3 options. The data of a fixture is known, so a test can expect exact numbers. `just test --fixtures-per-test` names the fixtures of each selected test, with the line where each is defined, such as `model -- tests/conftest.py:23`.

$ sed -n '48,57p' tests/unit/test_model.py
$ sed -n '21,30p' tests/unit/test_model.py
$ just test --fixtures-per-test -k "probabilities_sum or positions_restart"

**The tiny model.** `tests/tiny.py` has two ordinary functions with no `@pytest.fixture`, `tiny_tokenizer` on line 12 and `tiny_backbone` on line 27. The fixtures `tok` and `model` call them, and so does line 117 of `test_model.py`, for a model with an adapter. The tokenizer has 106 tokens, one for each of the 100 printable characters and the five delimiters, and `[UNK]` for any other character. The first `python` line splits "Roquefort" into nine tokens.

The backbone is the code of Qwen, `Qwen2Model`, with 2 layers of 32 numbers, where the real model has 24 layers of 896. The second `python` line counts its 24,224 parameters.

$ sed -n '12,24p;27,42p' tests/tiny.py
$ uv run python -c "from tests.tiny import tiny_tokenizer; t = tiny_tokenizer(); print(len(t), t.tokenize('Roquefort'))"
$ uv run python -c "from tests.tiny import tiny_backbone; print(sum(p.numel() for p in tiny_backbone(106).parameters()))"

**Why the tiny model is enough.** The tests check exact facts, such as which token may see which, and which parameters get a gradient, and those hold for any weights. The tiny model cannot tell whether the answers are any good, or how fast the real model runs on a GPU. It needs no download and no GPU, so only our code can make these tests fail. Such tests are hermetic, and they can run before every `git commit`.

**Kinds of tests.** The names say how much of the program a test runs.

- **Unit:** one function alone, such as `test_pointer_head_gives_one_logit_per_option`.
- **Integration:** several of our parts together, with stand-ins for what comes from outside. `test_probabilities_sum_to_one_for_every_question` packs a request, and runs the model and the head, on the tiny model.
- **End-to-end, or system:** the whole program with its real parts, as a user runs it. A smoke test is a quick end-to-end run, and ours is `just smoke`.
- **Acceptance:** a promise to the users, such as an answer within 50 ms. We have none.

**The tests.** `just test` runs 75 tests, and all pass. The first run after `just setup` can take half a minute, while Python compiles the modules of torch. The table has two new rows, `model.py` at 94% and `smoke.py` at 79%, and the total is 92%. The lines left are those that need the Hub or a GPU of NVIDIA, and the `main` of the smoke, lines 105 to 119.

$ just test

**The danger, then the defence.** `just test -k forge` runs 6 tests, the unit tests of a forged delimiter. The `sed` line prints them, lines 78 to 93. The first proves that the danger is real, because a tokenizer turns the text `<|fim_suffix|>` into the decide token. The second runs once for each of the five delimiters, and proves that `user_tokens` closes the door.

$ just test -k forge
$ sed -n '78,93p' tests/unit/test_model.py

**What trains.** `test_with_an_adapter_only_the_adapter_and_the_head_train`, lines 112 to 130, is an integration test. It runs one backward pass on a tiny model with an adapter. Every parameter that gets a gradient belongs to the adapter or to the head, and `trainable_parameters` lists exactly those. The backbone never moves; only the adapter and the head train. One test passes.

$ sed -n '112,130p' tests/unit/test_model.py
$ just test -k only_the_adapter

**The whole smoke, on the tiny model.** `test_smoke_reports_on_every_question_of_the_sample`, lines 32 to 42 of `test_smoke.py`, calls our function `smoke` on the five sample requests. The report must have fifteen verdicts and a closing count. It is an integration test, and no model is downloaded for it. Its name says what it calls, and not what kind of test it is.

$ sed -n '32,42p' tests/unit/test_smoke.py
$ just test -k smoke_reports

**The floor.** `just --show check` prints six lines now. `just types` runs after the linter, and `just test -q --cov-fail-under=90` fails when the tests run less than 90% of the code. The model came in with no test, and passed the formatter, the linter and the docs check, because tidy is not tested. The next command runs only the tests of the contract and the command under the floor. `model.py` is at 33%, the lines that run when the module is imported, and pytest prints `FAIL Required test coverage of 90% not reached. Total coverage: 55.43%`.

$ just --show check
$ just test -q --cov-fail-under=90 tests/unit/test_api.py tests/unit/test_cli.py

**All of it, together.** `just check` passes. The format, the linter, ty, 75 tests at 91.76% over the floor, `88 of 88` in the docs check, and the config files.

$ just check

**The problem with the mask as written.** Take a small request of six tokens, two for the state, two for question 1 and two for question 2. The slide draws the mask as a grid, with a row for each token, `#` for may look and `.` for may not. Rows 5 and 6 are question 2, and their columns 3 and 4 must say may not. The `python` line asks `branch_mask` for this mask, and rows 5 and 6 are `#####.` and `######`, so question 2 may look at question 1. The `sed` line prints the cause, line 159, where `torch.ones_like(causal)` makes every pair of tokens the same question.

$ uv run python -c "from babykev.model import branch_mask; m = branch_mask([0, 0, 1, 1, 2, 2], 'cpu')[0, 0] == 0; print('\n'.join(''.join('#' if x else '.' for x in r) for r in m))"
$ sed -n '159p' src/babykev/model.py

**A check that sees it.** A few lines of Python compare the right grid with the one that `branch_mask` builds, row by row. The shell runs them as a here document, where `python -` reads the lines up to `EOF`. Rows 1 to 4 print `ok`. Row 5 prints `##..#. #####. WRONG`, and row 6 prints `##..## ###### WRONG`. Nothing in `just check` runs these lines, so nothing in `just check` sees the mask.

$ uv run python - <<'EOF'
$ from babykev.model import branch_mask
$ picture = ["#.....", "##....", "###...", "####..", "##..#.", "##..##"]
$ mask = branch_mask([0, 0, 1, 1, 2, 2], "cpu")[0, 0] == 0
$ rows = ["".join("#" if ok else "." for ok in row) for row in mask]
$ for want, got in zip(picture, rows, strict=True): print(want, got, "ok" if want == got else "WRONG")
$ EOF

**Right as software, wrong for its domain.** The mask came in this way with the model, and every check passes. The code is formatted, linted and typed, every function is documented, and 75 tests pass at 92%. Coverage counts `branch_mask` as tested, because its lines ran, and no test looked at what the mask allows. The code is right as software and wrong for its domain, and the tests of the next stop look at the domain.

## tut-22 The tests that could tell

**Init.** `just setup` installs 2 packages, hypothesis 6.170.0, in the group `test`, and sortedcontainers, which hypothesis needs.

$ just setup

**What is new.** `tests/unit/test_mask.py` holds four tests of the mask, a picture of one small request and three rules for a request of any shape. `tests/unit/test_model.py` has three more tests, of questions kept apart on the tiny model. Line 159 of `model.py`, the mask, is fixed. Every check passes again.

**Test properties, not examples.** The new tests state what must hold for any request. A question must keep its answer when another question changes, and three questions in one pass must give the numbers of three passes. The order of the questions must not matter, and no token may see a later token or another question. These rules hold for any weights, so the tiny model is enough. `just test` runs 82 tests, the 75 of the last stop and 7 new, and all pass.

$ just test

**The mask of the last stop, under the new tests.** The `git restore` line takes `model.py` from `tut-21`, with line 159 as it came in. `just test` then fails 6 tests and passes 76. Three are tests of the mask, the picture and two rules. Three are the tests on the tiny model that keep questions apart.

The rule that no token sees a later token still passes, because the old mask was causal. The hook runs `just check`, and `just check` runs these tests, so git would refuse this code now.

$ git restore --source tut-21 src/babykev/model.py
$ just test
$ git restore src/babykev/model.py

**A picture checks one size.** At the last stop, a few lines of Python drew the right mask of a request of six tokens beside the mask that `branch_mask` built. The same comparison is the test `test_mask_of_a_small_request`, lines 28 to 39 of `test_mask.py`.

$ sed -n '28,39p' tests/unit/test_mask.py

Suppose someone fixed the mask in another way, so that a question cannot see the question just before it, and sees the others. The `git restore` line takes such a fix from the history, two changes before `tut-22`, and `git diff` shows its line 159. The here document of the last stop then prints `ok` six times. Its picture has only two questions, so it cannot tell the fix from the right one.

$ git restore --source tut-22~2 src/babykev/model.py
$ git diff src/babykev/model.py
$ uv run python - <<'EOF'
$ from babykev.model import branch_mask
$ picture = ["#.....", "##....", "###...", "####..", "##..#.", "##..##"]
$ mask = branch_mask([0, 0, 1, 1, 2, 2], "cpu")[0, 0] == 0
$ rows = ["".join("#" if ok else "." for ok in row) for row in mask]
$ for want, got in zip(picture, rows, strict=True): print(want, got, "ok" if want == got else "WRONG")
$ EOF

**hypothesis: state the rule, and let the computer try the shapes.** hypothesis is a Python library for tests. Line 10 of `test_mask.py`, `shapes`, says what a request may look like. It has a state of 1 to 6 tokens, and up to 4 questions of 1 to 5 tokens each. `@given(shapes)` on line 42 runs the test below it on up to 100 shapes, drawn at random. When a shape breaks the rule, hypothesis reports the smallest shape that still breaks it.

The test on lines 42 to 49 says that no question sees another.

$ sed -n '10p;42,49p' tests/unit/test_mask.py

**hypothesis finds the size for us.** `just test -k "small_request or no_question_sees"` runs the picture and the rule on the fix that is still in the file. The picture passes, and the rule fails. hypothesis shrinks the failure to a shape of `1` and `[1, 1, 1]`, one state token and three questions of one token each. Its output prints the two grids as tensors of `True` and `False`. In row 4, column 2 is `True` in both, so token 4, in question 3, sees token 2, in question 1.

$ just test -k "small_request or no_question_sees"

A picture of that size, drawn by hand, sees it too. The second here document compares four tokens, `[0, 1, 2, 3]`, and row 4 prints `#..# ##.# WRONG`. Every size of request needs its own picture, and the rule needs none. `just test` on the fix fails 4 tests, two rules of the mask and two tests on the tiny model. The `git restore` line puts the right line back.

$ uv run python - <<'EOF'
$ from babykev.model import branch_mask
$ picture = ["#...", "##..", "#.#.", "#..#"]
$ mask = branch_mask([0, 1, 2, 3], "cpu")[0, 0] == 0
$ rows = ["".join("#" if ok else "." for ok in row) for row in mask]
$ for want, got in zip(picture, rows, strict=True): print(want, got, "ok" if want == got else "WRONG")
$ EOF
$ just test
$ git restore src/babykev/model.py

**How we tested isolation.** `test_a_question_cannot_see_its_sibling`, lines 149 to 160 of `test_model.py`, is an integration test on the tiny model. It takes the fixtures `model`, `tok` and `record`. It answers the request, rewrites question 2, and answers again. Questions 1 and 3 must get exactly the same probabilities, by `torch.equal`. With the mask of `tut-21`, the line for question 3 fails, `tensor([0.3341, 0.3331, 0.3328])` before and `tensor([0.3343, 0.3330, 0.3327])` after.

$ sed -n '149,160p' tests/unit/test_model.py
$ git restore --source tut-21 src/babykev/model.py
$ just test -k a_question_cannot_see_its_sibling
$ git restore src/babykev/model.py

**The fix, one line.** Line 159 says that a token may look at the state, or at its own question. `tut-21` had `torch.ones_like(causal)` in place of the first part.

$ sed -n '159p' src/babykev/model.py

**The smoke on Qwen, again.** `just smoke` on the right mask says `4 of 15 right`, where it said 6 at the last stop. The first question of each request keeps its answer, because it saw only the state with either mask. With the old mask, questions 2 and 3 read the questions before them, and some answers were right for the wrong reason. A pure guess on these fifteen questions expects 4.75 right, as the `python` line prints. Five are yes or no, five are choices of 5 options, and five are scores of 4 levels.

$ just smoke
$ uv run python -c "import json; print(sum(1 / (2 if q['type'] == 'noul' else len(q['criteria'])) for line in open('data/cheese/sample.jsonl') for q in json.loads(line)['questions'].values()))"

## tut-26 Two images from one lockfile

**Init.** `just setup` installs 2 packages, hadolint-bin 2.15.1, a linter of Dockerfiles, and actionlint-py, a linter of the workflows of GitHub. Both are wheels on PyPI, in the group `lint`.

$ just setup

**What is new.** The smoke on the real model is a test now, `tests/system/test_real_model.py`, and a marker keeps it out of `just test`. Two pages of the docs site explain the model. A `Dockerfile` builds two images from `uv.lock`, `.dockerignore` keeps the files of this machine out of them, and the recipe `image` builds and runs them. Two workflows run on GitHub, the checks after every push and the docs on GitHub Pages. hadolint and actionlint run in `just lint-config`.

**The run image, in the file.** The `sed` line prints lines 11 to 39 of the `Dockerfile`.

- **Line 12** takes uv from its own image.
- **Lines 16 to 28** are a stage of the build. The packages of the lockfile come in on line 25, and the code on lines 27 and 28. A change to the code does not install torch again.
- **Lines 31 to 39** are the run image, with Python, the environment of the build, the sample data and `babykev`. It has no uv and no tool of the developers.

$ sed -n '11,39p' Dockerfile

**Build it, run it.** `docker build --target run` builds that image, and names it `babykev-run`. With the cache warm it takes about a second. `docker run --rm babykev-run` starts it with no words, so line 39 runs `babykev help`, and `--rm` removes the container when it ends. `docker image ls` prints the name and the size, 1.14 GB, nearly all of it torch.

$ docker build --target run --tag babykev-run .
$ docker run --rm babykev-run
$ docker image ls babykev-run:latest --format '{{.Repository}}:{{.Tag}}  {{.Size}}'

**The smoke on Linux.** The same smoke runs in the image. `-v` mounts the cache of the Hugging Face Hub of this Mac at `/hf`, where line 36 looks, so the model needs no download. It says `on cpu`, because a container on a Mac is Linux in a virtual machine, and sees no GPU of Apple. It says `4 of 15 right`, at several seconds a request. The fifteen answers are those of `mps`, line for line, to the two decimals that it prints.

$ docker run --rm -v ~/.cache/huggingface:/hf babykev-run smoke

**The dev image.** Lines 41 to 70 are the image to work in. It has git from Debian on lines 48 to 50, uv on line 51 and just on line 63. Lines 66 to 69 install the whole project, with every group. The environment is in `/opt/venv`, on line 52, outside the folder of the project, and the image starts a shell. `docker build --target dev` builds it.

$ sed -n '41,70p' Dockerfile
$ docker build --target dev --tag babykev-dev .

**What a build never copies.** `.dockerignore` lists the files that `docker build` leaves out, and it is to Docker what `.gitignore` is to git. It keeps out `.git`, `.venv` and `.env`, the caches of the tools, and what a build of the docs makes. The `.venv` of this Mac holds packages for macOS, and an image makes its own environment.

$ cat .dockerignore

**The recipe.** `just --show image` prints one recipe with three words, and `build dev` or `build run` runs `docker build` with the target and the name. `shell` runs the dev image with this folder at `/work` and the cache of the Hub at `/hf`. `run` runs the run image with the words after it. `just image build dev` and `just image build run` come from the cache.

$ just --show image
$ just image build dev
$ just image build run

**Working inside it.** `just image shell -- COMMAND` runs a command in a new container of the dev image, and `--rm` removes the container after it. `which` shows where each tool is. Python comes from `/opt/venv/bin`, and just and uv from `/usr/local/bin`. `just image shell` with no command gives a shell, and `exit` ends it.

$ just image shell -- which python just uv

**hadolint.** hadolint is a linter of Dockerfiles. `uv run hadolint Dockerfile` prints nothing, so the file is clean. Lines 44 to 47 decline its rule `DL3008`, which asks for the version of each package of Debian. Debian replaces a package at each fix of its security, and the old version leaves the archive, so a pinned version stops building within weeks.

The `perl` line deletes the line that declines the rule. hadolint then prints `Dockerfile:47 DL3008 warning: Pin versions in apt get install.`, and the `git restore` line puts the file back.

$ uv run hadolint Dockerfile
$ sed -n '44,47p' Dockerfile
$ perl -ni -e 'print unless /^# hadolint ignore=DL3008$/' Dockerfile
$ uv run hadolint Dockerfile
$ git restore Dockerfile

**What should not go in the hook?** Along the way, almost every stop added a check, `just check` runs them all, and the hook runs `just check`. A check that needs the network, a download, a GPU or a lot of time can fail for reasons outside our code. People learn to skip a hook that fails for such reasons. So the question for every check is whether anything but our code can make it fail.

**A marker keeps the system test out.** pytest has no kinds of its own. A marker is a name that we declare in `pyproject.toml`, put on a test, and choose with `-m`. Line 64 leaves out every test marked `system` from a run, and line 66 declares the marker. `tests/system/test_real_model.py` is the smoke on the real model, as a test. Line 14 marks every test of the file, and the test asserts what holds on any device, fifteen verdicts and a count.

$ sed -n '62,66p' pyproject.toml
$ sed -n '1,27p' tests/system/test_real_model.py

`just test` prints `82 passed, 1 deselected`. `just test -m system` runs the one test, `1 passed, 82 deselected`, and its table shows `smoke.py` at 94%, because the test runs the `main` of the smoke.

$ just test
$ just test -m system

**Hermetic, by experiment.** `--network none` goes to `docker run`, so the container has no network at all, and `just check` runs inside it and passes. `HF_HUB_OFFLINE=1` makes no request to the Hub, and `HF_HOME` chooses the cache. With the cache of this machine, the system test passes, because the model is in the cache. With an empty cache it fails, with `OSError: We couldn't connect to 'https://huggingface.co' to load the files, and couldn't find them in the cached files.`

$ just image shell --network none -- just check
$ HF_HUB_OFFLINE=1 just test -m system
$ HF_HUB_OFFLINE=1 HF_HOME="$(mktemp -d)" just test -m system

**A deadline, turned off.** hypothesis gives each example of a test 200 ms. In a container, the first example that runs torch can take longer, and the test then fails by chance. Lines 16 to 20 of `tests/conftest.py` turn the deadline off, with the reason in a comment. The tests that hypothesis feeds check a rule, and not a speed.

$ sed -n '16,20p' tests/conftest.py

**A test is anything that can fail and stop you.** The table on the slide lists what is checked, by which tool and which recipe. The functions, the mask and the model run in `just test`, the types in `just types`, and the docs in `just docs check`. The format and the linter run in `just fmt --check` and `just lint`, and the config files, the Dockerfile and the workflows in `just lint-config`. All of these run before every `git commit`, and the real model runs in `just test -m system`, by hand, because it is not hermetic. A check that runs before every `git commit` is also called a gate.

**The model, explained.** `just docs` builds the site again, and prints `wrote 7 page(s) to docs/_site`. A section `Guide` has two pages, written by hand, on lines 11 to 14 of `docs/_smalldocs.yml`. `docs/guide/model.qmd` gives the four ideas, and `docs/guide/mask.qmd` draws the mask as a grid, beside the grid of a plain causal mask. The grid on lines 13 to 21 of `mask.qmd` is the picture of `test_mask_of_a_small_request`, so `just test -k small_request` keeps the page true.

$ just docs
$ sed -n '11,14p' docs/_smalldocs.yml
$ sed -n '13,21p' docs/guide/mask.qmd
$ just test -k small_request
$ open docs/_site/guide/model.html

**The gate, on GitHub.** The hook runs on the machine that makes a `git commit`, and a clone with no hook makes changes that never met it. GitHub runs a workflow on its own machines, after the events that its key `on` names. `.github/workflows/check.yaml` runs `just setup` and `just check` after every push to a branch, and on every pull request. `.github/workflows/docs.yaml` builds the docs site after a push to `main`, and publishes it on GitHub Pages. Line 26 installs the package and the group `docs`, and no other group.

$ cat .github/workflows/check.yaml
$ sed -n '20,30p' .github/workflows/docs.yaml

**The workflows are checked too.** YAML 1.1 reads the key `on` as the value true, and yamllint warns of it. Line 7 of `.yamllint` lets a key be such a word. The `sed` line deletes that line, and `uv run yamllint --strict .` then prints `truthy value should be one of [false, true]` for line 5 of `check.yaml` and line 6 of `docs.yaml`. `uv run actionlint` checks the workflows themselves, and prints nothing when they are right. The second `sed` line names a job that does not exist, and actionlint prints `job "deploy" needs job "biuld" which does not exist in this workflow`.

$ sed -n '7p' .yamllint
$ sed -i '' '/truthy/d' .yamllint
$ uv run yamllint --strict .
$ git restore .yamllint
$ uv run actionlint
$ sed -i '' 's/^    needs: build$/    needs: biuld/' .github/workflows/docs.yaml
$ uv run actionlint
$ git restore .github/workflows/docs.yaml

**`lint-config` has six lines now.** `just --show lint-config` prints hadolint and actionlint after yamllint, and `just lint-config` passes. So the hook runs both before every `git commit`, and GitHub runs them after every push.

$ just --show lint-config
$ just lint-config
