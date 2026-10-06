# The walk through babykev, step by step

This file holds the notes of every step. timewalk shows the notes of the current step in the column on the
right of the page.

- **A command** is a line that starts with `$ `. A click on it types the command into the terminal of the
  step, and you press Enter to run it. With **run on click** on, a click also runs it.
- **Other tabs:** a line that starts with `runs$ ` goes to the **Runs** tab, for a command that takes a
  while. A line that starts with `main$ ` goes to the **Main** tab, in `repo/`.
- **A cue** is a line that starts with `> `. The notes column shows it shaded.
- **Edit** at the top of the column changes the notes of the step, and **Save** writes them into
  `walk.md`. Commit `walk.md` to your fork to keep your notes.
- **A move throws away edits.** `just present` starts timewalk with `--discard-edits`, so a move to another step
  throws away your edits in `worktree/`.

## step-01 The contract, and its tests

**Init.** `just setup` adds 13 packages: pydantic and pydantic-core, pytest, pytest-cov and coverage, and their dependencies. `.venv` goes from 1 package to 14.

$ just setup

**What is new:** `src/babykev/api.py`, kev's file as it was, less its serving parts (the request's `model` field, `output_tokens`); five labelled requests in `data/cheese/sample.jsonl`; `tests/unit/test_api.py` and `test_cli.py`; pydantic, pytest and pytest-cov; the `test` recipe.

**Start from the data.** One line is a request about a cheese, with a `label` on every question. The five lines are test data, kept in the repository so the tests can read them; they are not the students' data, which comes with training.

$ head -n 1 data/cheese/sample.jsonl | python3 -m json.tool

$ just
$ just help test

**The tests.** `uv run pytest` runs them. `uv run` runs a command inside `.venv`, syncing it first if it has to; `pytest` reads `[tool.pytest.ini_options]` in `pyproject.toml`, looks under `tests/`, and runs every function whose name starts with `test_`. The first lines say so: `configfile: pyproject.toml`, `testpaths: tests`, `plugins: cov-7.1.0`. 52 runs, two fail, and the tests are right. A guess over three score levels gets confidence 0.5, not 0. Confidence runs from 1, when the model is sure, down to 0, when it knows nothing. A model that gives every level the same chance knows nothing. Rounding to two decimals makes 77 equal options sum to 0.77. Two real bugs in code that works (`sundry/the-two-bugs.md`). Under the summary, the coverage table: every statement of `api.py` and `cli.py` is touched. From now on the table says which lines are not. The `grep` line shows where the table comes from: `addopts` in `pyproject.toml` adds `--cov=babykev --cov-report=term-missing` to every run, so nobody has to remember the flags.

$ uv run pytest
$ grep -n -B1 addopts pyproject.toml

**The recipe.** `just --show test` prints the recipe: its comment, two attributes, its name, and a body of one line, `uv run pytest "$@"`, inside an `if` that answers `help`. `"$@"` is every word after `just test`, each one whole. So `just test -k name` runs `uv run pytest -k name`, and in `just test -k "score_confidence_is_zero or rounded_probabilities"` pytest gets two words, `-k` and the whole pattern: 2 tests selected, both failing. Before it runs, just prints the line as it is written, `uv run pytest "$@"`, not your words. The shell fills them in after.

$ just --show test
$ just test -k "score_confidence_is_zero or rounded_probabilities"

**The command's tests** (`tests/unit/test_cli.py`, lines 8 to 18). `run` sets `sys.argv`, the list of words a program was started with, and calls `main()`, as if `babykev` had been typed at a terminal. `monkeypatch` and `capsys` are two of pytest's built-in fixtures: pytest sees their names among the test's arguments and passes them in. The project's own fixtures arrive with the model. `monkeypatch.setattr` changes `sys.argv` for this test only and puts it back afterwards; `capsys` catches what the program printed, and the test compares it with `HELP`. `@pytest.mark.parametrize` on line 14 runs the function once for each value in its list: one function, four tests, one for each way of asking for help (`babykev`, `babykev help`, `--help`, `-h`). With `-v`, pytest prints each on its own line, `[words0]` to `[words3]`, all passed: `4 passed, 48 deselected`.

$ sed -n '8,18p' tests/unit/test_cli.py
$ just test -k help_is_printed -v

**Four tests of the contract.** Every test at this step is a unit test: it runs one function, alone. The other kinds, where several parts or the whole program run together, come with the model at step 05. Every test in `test_api.py` has a name that reads as a sentence and a docstring that states the rule, and the file is in sections, `# Validation`, `# Rendering`, `# From a request to a record`, `# From probabilities to answers`, `# Confidence`. Two of the four tests are small and two carry weight. For each, the `sed` line prints it and the `just test -k` line runs it alone.

**Test 1, small: a request must ask at least one question** (lines 81 to 86). Three lines. `pytest.raises` says "this must fail". The contract refuses bad input, and the test pins the rule so nobody loosens it by accident. One passed.

$ sed -n '81,86p' tests/unit/test_api.py
$ just test -k without_questions

**Test 2, small: the limit on options is exact** (lines 105 to 114). 255 options are accepted, 256 are refused. The classic boundary test: the bug that is off by one lives exactly here, so the test stands exactly here. One passed.

$ sed -n '105,114p' tests/unit/test_api.py
$ just test -k largest_number

**Test 3, weighty: every line of the sample data fits the contract** (lines 47 to 56). `@pytest.mark.parametrize` again, now over the data: one function, five tests, one per line of the sample. It is a test of the data against the code: every line validates, every question becomes one record question, every question has at least two options. When the real data arrives at training, this is the test that grows. Five passed.

$ sed -n '47,56p' tests/unit/test_api.py
$ just test -k sample_line_fits

**Test 4, weighty: rounded probabilities still sum to one** (lines 250 to 258). A property, not a value: whatever the probabilities are, they must sum to 1. And the extreme case: 77 options, not three. `pytest.approx(1, abs=0.02)` is how a float is compared. This one fails here, 0.77, and it is the proof that code that "works" had a bug. One failed.

$ sed -n '250,258p' tests/unit/test_api.py
$ just test -k rounded_probabilities

**A subset.** Eight tests run; the coverage drops to 49%, because the table is about the tests that ran. The number that matters is the whole suite's.

$ just test -k confidence

**A break.** The `sed` line changes the noul option `"no"` to `"NO"` in `api.py`, and `just test` then fails four. Nothing to put back: the move to the next step drops the edit. (Changing `MAX_OPTIONS` breaks nothing: the test imports the constant.)

$ sed -i '' 's/option_text("no", c.get("false"))/option_text("NO", c.get("false"))/' src/babykev/api.py && just test

## step-02 Format and lint arrive

**Init.** `just setup` adds one package, ruff. `.venv`: 15 packages. (Coming from step-00 instead of step-01, it adds 14.)

$ just setup

**What is new:** ruff; `[tool.ruff]` in `pyproject.toml` with the formatter's settings and the lint rules, a comment on each; the `fmt` and `lint` recipes; the two fixes (`score_confidence` is 0 for a guess, `round_prob` rounds to four decimals; `sundry/the-two-bugs.md` explains both); `UV_LOCKED` exported from the justfile. `api.py` is still as it arrived. This step brings the tools and we run them here; the next commit holds what they leave behind.

**First, the two fixes.** The two tests that failed at step 01 pass here. The tests did not change; the code did. The file view shows what changed in `api.py`.

The first fix: a guess now has confidence 0. When the model cannot tell the levels of a score apart, the answer used to say it was half sure, 0.5. Now it says it is not sure at all. The code measured how spread out the answer was against the wrong yardstick: the whole length of the scale, instead of how spread out a guess is. With numbers: three levels, and the model gives each one a third. How spread out the answer is: all three are equally likely, so the code counts from the first, and the levels are 0, 1 and 2 steps from it, so 1/3 × 0 + 1/3 × 1 + 1/3 × 2 = 1 step. The old yardstick, first level to last, is 2 steps, so the confidence was 1 − 1/2 = 0.5. The new yardstick, how spread out a guess is, around the middle level, is 1/3 × 1 + 1/3 × 0 + 1/3 × 1 = 0.67 steps; 1 − 1/0.67 = −0.5. The formula counts anything below 0 as 0, so an answer as spread out as a guess, or more, has confidence 0. `just test -k score_confidence_is_zero`: 1 passed.

$ just test -k score_confidence_is_zero

The second fix: the probabilities add up to 1 again. Each one was rounded to two decimal places. With 77 options, each 0.013 became 0.01, and the total came to 0.77. Now they are rounded to four places, and the total stays close to 1. `just test -k rounded_probabilities`: 1 passed.

$ just test -k rounded_probabilities

**A. The tests pass, and one line is never reached.** 52 passed. The coverage table: `api.py` 71 statements, 1 missed, column `Missing` says `90`. The `sed` line prints lines 88 to 91:

```
    L = len(p)
    if L == 1:
        return 1.0
    mode = max(range(L), key=lambda i: p[i])
```

The fix added this branch. No test reaches it, because a `Score` needs at least two levels (`criteria` has `min_length=2`), so no request ever makes a one-level score. But `score_confidence` is a public function, and without the branch `score_confidence([1.0])` divides by zero: a guess's spread over one level is 0. The table found an edge no one had thought about. Two honest answers. Cut the branch, on the grounds that the function is only ever called through a request, and accept that calling it with one level then crashes. Or keep the branch and write the one test that reaches it: `score_confidence([1.0]) == 1.0`, "one level is the whole scale, there is nothing to be unsure about". The second is right here: the function is public, its contract is "a list of probabilities", and a crash on a legal input is a bug waiting for a caller. So the next step adds that test, and coverage goes back to 100% honestly, by asking the question the table raised. What never happens: adding a test only to make the number 100. The column is not a score to maximise. It is a list of lines nobody has asked a question about.

$ just test
$ sed -n '88,91p' src/babykev/api.py

**B. The formatter.** ruff is one tool with two jobs, a formatter and a linter, and this step brings both. `uv run ruff format --check` asks the formatter what it would change, without changing anything. It is red: "1 file would be reformatted, 5 files already formatted", and it prints what it would change in `api.py`:

| Where | What kev wrote | What the formatter does |
|---|---|---|
| line 7 | the imports right after the module docstring | a blank line between |
| line 27, `Choice._check` | `if not 1 <= len(...) <= MAX_OPTIONS: raise ValueError(...)`, 119 characters, two statements on one line | two lines |
| lines 48 to 51, `render` | three `if ...: return ...` on one line each, then a 142-character `return "\n".join(...)` | six lines, then the join spread over five |
| line 72, `to_record` | `meta.append({...})`, 118 characters | the dictionary over seven lines, one key per line |
| lines 110 and 113, `to_answers` | two dictionaries of 177 and 209 characters | six lines each |

$ uv run ruff format --check

`just --show fmt` prints the recipe: `uv run ruff format "$@"`, where `"$@"` is the words after `just fmt`. So `just fmt --check` is the command above, and `just fmt` alone is `uv run ruff format`, which rewrites the files.

$ just --show fmt

`just fmt`: "1 file reformatted". 114 lines become 141; the longest line goes from 209 characters to 107. `just fmt --check`: "6 files already formatted". On the presenter page `api.py` now has an **Edits** button; it opens "Edits since the step", the rewrite against this commit, on the projector. `just test`: 52 passed. The formatter changed the look of every long line and the meaning of none.

$ just fmt
$ just fmt --check
$ just test

**C. What formatting did to the lint count.** At the commit `just lint --statistics` says 79 findings; after `just fmt` it says 70. The nine that went: the four E701 (several statements on one line, lines 27, 48, 49, 50) and five of the twelve E501 (lines over 100: the five long code lines). The seven E501 left are all in docstrings: the formatter rewraps code, never text.

**D. Reading the linter.** `uv run ruff check --statistics` is the linter, the other half of ruff: it reads the code against the rule families listed in `[tool.ruff.lint]` in `pyproject.toml` and prints one line per code with its count and name; `[*]` marks a code ruff can fix by itself. "Found 70 errors." After formatting, with what each code means:

| Code | Count | Meaning | Where |
|---|---|---|---|
| ANN201 | 32 | a public function has no return type | 30 tests; `to_record`; `cheese_request` in the tests |
| ANN001 | 14 | an argument has no type | all in the tests: `line`, `level`, `text`, `monkeypatch`, `capsys`, ... |
| E501 | 7 | a line over 100 characters | docstrings: 4 in `api.py`, 3 in the tests |
| D101 | 4 | a class has no docstring | `Noul`, `Choice`, `Score`, `SystemOneRequest` |
| D103 | 3 | a function has no docstring | `option_text`, `choice_confidence`, `to_answers` |
| N806 | 2 | a variable inside a function is not lower case | `K` in `choice_confidence`, `L` in `score_confidence` |
| UP007 | 2 | `Union[X, Y]` where `X \| Y` is the modern form | the aliases `JSONContent` and `Question` |
| B905 | 2 | `zip()` without `strict=`: if the two sequences differ in length, it silently drops the tail | both in `to_answers` |
| ANN202 | 1 | a private function has no return type | `Choice._check` |
| ANN002 | 1 | `*args` has no type | `*words` in `test_cli.run` |
| D104 | 1 | the package has no docstring | `src/babykev/__init__.py` |
| I001 | 1 | imports not in isort's order | `api.py`: the standard library and pydantic imports with no blank line between |

$ uv run ruff check --statistics

`just --show lint` prints the recipe: `uv run ruff check "$@"`, with the words after `just lint` in place of `"$@"`. From now on, `just lint`. Without `--statistics` it prints each finding with its line, a caret under the place, and a help text. Every code we have met, what it means, why it matters and what fixed it: `sundry/lint-codes.md`.

$ just --show lint
$ just lint

**E. Safe fixes.** `just lint --fix`: "70 errors (1 fixed, 69 remaining)". The one is I001: a blank line between `from typing import ...` and `from pydantic import ...`. A safe fix is one that cannot change what the code does.

$ just lint --fix
$ just lint --statistics

**F. Unsafe fixes, read the diff.** `just lint --fix --unsafe-fixes`: "69 errors (32 fixed, 37 remaining)". The 32: `-> None` written on the thirty test functions that return nothing (ruff is sure of `None`, not of other types: `to_record` and `cheese_request` keep their ANN201), and `strict=False` on the two `zip` calls (unsafe because the author might have meant `strict=True`; `False` keeps today's behaviour and makes the choice visible). `just lint --statistics` shows the 37 that remain.

$ just lint --fix --unsafe-fixes
$ just lint --statistics

After 33 automatic edits, `just fmt --check` is still green and `just test` still says 52 passed.

$ just fmt --check
$ just test

**G. What is left for a person, 37.** Fourteen argument types in the tests. Seven long docstring lines to rewrap. Eight docstrings to write (four classes, three functions, the package). Two return types ruff would not guess, `to_record` and `cheese_request`, and `_check`'s. `*words: str`. Two names, `K` and `L`. Two `Union`s. None of these is mechanical: each needs someone who knows what the function means. That is the next step.

**H. One by hand.** The `echo` line writes a one-line docstring into `__init__.py`; `just lint --statistics` goes from 37 to 36: D104 gone.

$ echo '"""babykev: a small decision model."""' > src/babykev/__init__.py
$ just lint --statistics

**What the next step does with all this.** The next commit holds: the formatted `api.py`; the two automatic fixes (the import order, `strict=False` on the `zip`s) and the thirty `-> None`s; and the 36 a person has to do, which is what the next step is: eight docstrings, the fourteen argument types in the tests, the three return types ruff would not guess, `*words: str`, `K` and `L` renamed, the two `Union`s rewritten, seven docstring lines rewrapped. And the test for the one-level edge, so the coverage column is empty again. After that `just fmt --check`, `just lint` and `just test` are all green, which is the moment to make them stay green. Nothing is put back: the move to the next step drops every edit made here, and the next commit holds all of them.

## step-03 Clean, and kept clean

**Init.** `just setup` adds 15 packages (pre-commit, yamllint, validate-pyproject and what they need) and then prints `pre-commit installed at ...git/hooks/pre-commit`.

$ just setup

**A. The rest, fixed by a person.** At step 02 the tools left 36 problems that only a person could fix: docstrings, types, names. This commit holds those fixes, and the file view shows them. `just lint`: "All checks passed!".

$ just lint

**The hook.** The last line `just setup` printed, `pre-commit installed at ...`, came from a second command in the recipe. `uv run pre-commit install` is pre-commit, a tool that runs the hooks listed in `.pre-commit-config.yaml` at every commit; `install` writes the script `.git/hooks/pre-commit` that git runs, and prints where it put it. `just --show setup` shows the recipe grew from one command to two, joined by `&&`.

$ uv run pre-commit install
$ just --show setup

**What `install` wrote.** Before every commit, git looks in its hooks folder for a file named after the moment, `pre-commit`, and runs it. The replay copy is a second working copy of the repository, so its `.git` is a small file that points to the main repository; `git rev-parse --git-path hooks` prints where the hooks folder really is. `ls` shows `pre-commit` among the `.sample` files git puts there. `cat` shows the 20 lines pre-commit wrote: they start pre-commit from this folder's `.venv` and tell it to read `.pre-commit-config.yaml`. The path is this machine's, so the file is never committed, and every clone runs `just setup` to write its own. Any program in that place would do: two lines, `#!/bin/sh` and `just check`, would work. pre-commit adds the config file, the hooks it downloads, and the install.

$ ls "$(git rev-parse --git-path hooks)"
$ cat "$(git rev-parse --git-path hooks)/pre-commit"

**What is new:** the result of step 02's live run (`api.py` formatted, the import order, `strict=False` on the two `zip`s, `-> None` on thirty tests) and everything a person had to do after it: a one-line docstring on each of the four classes, the three functions and the package; the two missing return types (`to_record`, `_check -> Self`); `Union` written `|`; `K` and `L` renamed `k` and `n`; types on every test argument; the test for the one-level score. Then `just lint-config`, `just check`, and the git hook.

**B. Green.** `just test`: 53 passed, and the `Missing` column is empty.

$ just test

One test is new, and it is the answer to step 02's uncovered line. The `sed` line prints it, lines 282 to 284: three lines, a name that states the rule and a docstring that says why. `just test -k single_level`: 1 passed.

$ sed -n '282,284p' tests/unit/test_api.py
$ just test -k single_level

**C. `just check`.** `just --show check` prints the recipe: a small shell script, four lines after the `help` line, each a recipe already seen: `just fmt --check`, `just lint`, `just test -q --cov-fail-under=90`, `just lint-config`. The two flags are pytest's: `-q` for a short report, `--cov-fail-under=90` for a floor on the coverage. The floor lives here, in `check`, and not in `pyproject.toml`, so that `just test -k name` still works on a few tests.

$ just --show check

`just check` runs the four, one after another: `ruff format --check` ("6 files already formatted"), `ruff check` ("All checks passed!"), the tests with the floor ("Required test coverage of 90% reached. Total coverage: 100.00%"), and `lint-config` ("Valid file: pyproject.toml"; the lockfile and the justfile say nothing when they pass). 1.9 seconds.

$ just check

**D. The floor, failing.** With only the nine confidence tests selected: "FAIL Required test coverage of 90% not reached. Total coverage: 49.40%".

$ just test -k confidence --cov-fail-under=90

**E. Config files are checked too.** `just lint-config` runs four checks, one for each kind of file that is not Python. Each is run by hand first: once clean, and once with one break. Each break is put back at once, because the commit attempts in G and H run `just check`, and `just check` runs all four.

**yamllint.** `uv run yamllint --strict .` checks every YAML file in the repository against `.yamllint` (lines of at most 100 characters, no need for the `---` line) and prints nothing when all is well. `--strict` makes a warning fail as well as an error. The `sed` line indents the `args:` line of `.pre-commit-config.yaml` two spaces too far. yamllint then names the file and prints `10:15 error syntax error: mapping values are not allowed here (syntax)`: line 10, column 15. The `git restore` line puts the file back.

$ uv run yamllint --strict .
$ sed -i '' 's/^        args: \[--maxkb=1000\]$/          args: [--maxkb=1000]/' .pre-commit-config.yaml
$ uv run yamllint --strict .
$ git restore .pre-commit-config.yaml

**validate-pyproject.** `pyproject.toml` has an agreed format, written down as a standard: which sections there are, which keys each may hold, and what kind of value each key takes. `uv run validate-pyproject pyproject.toml` checks the file against it and prints `Valid file: pyproject.toml`. The `sed` line misspells one key, `requires_python` for `requires-python`. The output is long, 32 lines: uv first warns that it found no `requires-python` and rebuilds babykev, then validate-pyproject prints `[ERROR] `project` must not contain {'requires_python'} properties`, a traceback, and last `Invalid file: pyproject.toml`. `uv.lock` is not changed. The `git restore` line puts the file back.

$ uv run validate-pyproject pyproject.toml
$ sed -i '' 's/^requires-python = /requires_python = /' pyproject.toml
$ uv run validate-pyproject pyproject.toml
$ git restore pyproject.toml

**`uv lock --check`.** No new package: uv is already here. `--check` compares `uv.lock` with `pyproject.toml` and changes nothing; when they agree it prints `Resolved 29 packages`. The `sed` line raises pydantic's lowest allowed version from 2.11 to 2.12 without running `uv lock`. uv then prints `Resolved 29 packages`, and after it `error: The lockfile at `uv.lock` needs to be updated, but `--check` was provided.` and the hint `To update the lockfile, run `uv lock`.` The `git restore` line puts the file back.

$ uv lock --check
$ sed -i '' 's/"pydantic>=2.11"/"pydantic>=2.12"/' pyproject.toml
$ uv lock --check
$ git restore pyproject.toml

**`just --fmt --check --unstable`.** No new package: just has its own formatter, and `--unstable` is needed because just still marks it as unstable. It prints nothing when the justfile is formatted. The `sed` line writes `program:="babykev"` with no spaces. The check then prints 70 lines: the justfile as a diff, where two lines carry the change, `-program:="babykev"` and `+program := "babykev"`, and the last line says `error: Formatted justfile differs from original.` The `git restore` line puts the file back.

$ just --fmt --check --unstable
$ sed -i '' 's/^program := "babykev"/program:="babykev"/' justfile
$ just --fmt --check --unstable
$ git restore justfile

**The recipe.** `just --show lint-config` prints the four in one recipe, a script like `check`; `set -e` stops it at the first check that fails. `just lint-config` runs them: `Valid file: pyproject.toml` and `Resolved 29 packages`, and nothing from the other two. From now on, `just lint-config`.

$ just --show lint-config
$ just lint-config

**F. The hook.** The config lists four hooks. No file over 1 MB (a checkpoint is not a commit). No merge-conflict markers. No `.env` file, ever. And `just check`.

$ cat .pre-commit-config.yaml

**G. A bad commit.** The `perl` line adds `import os` at the top of `api.py`, unused. The commit attempt prints the four hooks with their results: three `Passed` or `Skipped`, then `just check...Failed`, and under it the linter's finding, `F401 [*] os imported but unused`, with the line, a caret under `os`, and `help: Remove unused import`. 0.8 seconds.

$ perl -pi -e 's/^(from typing)/import os\n$1/' src/babykev/api.py
$ git commit -am "try"

`git status`: the file is still modified; no new commit was made. The `git restore` line puts the file back.

$ git status
$ git restore src/babykev/api.py

**H. A secret.** The `echo` line writes a `.env` and force-adds it (`.env` is in `.gitignore`, so `-f` is needed even to try). The commit attempt prints `no .env file...Failed`, then the sentence from the config: "A .env file holds the settings and secrets of one machine. It is never committed", and the file name.

$ echo X=1 > .env && git add -f .env
$ git commit -m "try"

The last line takes the file out of the index and deletes it, so the next move does not ask.

$ git rm --cached -q .env && rm .env

**What the next step does.** Step 04 is the documentation: docments on the parameters, the generated reference pages, the site.

## step-04 Documentation from the code

**Init.** `just setup` adds one package, fastcore 2.2.32, and rebuilds babykev because `pyproject.toml` changed; then `pre-commit installed at .git/hooks/pre-commit`. The recipe is a script now, like `check`: `uv sync --locked`, `uv run pre-commit install`, and a line that says if Quarto is not on the machine (it is, so nothing is printed). 0.4 s.

$ just setup

**What is new:** a command, `babykev docs`, in `src/babykev/docs.py`, that reads the code and prints plain Markdown; `docs/` with the Quarto site (`_quarto.yml`, `index.qmd`, `apidocs.py`, `linkify.lua`); one recipe, `docs`; tests of the command. This commit is dirty on purpose: `docs.py` is documented with docments, nothing else is, and `docs check` is red. Step 04b fills the gaps.

**A. The recipe.** `just` shows a new group, `docs`, with one recipe. `just help docs` prints the recipe's line and then the program's usage: three words, `list`, `module NAME`, `check`.

$ just
$ just help docs

**B. What the code says about itself.** `uv run babykev docs list` is the program's own command, run the way any command in the venv is run. It prints 41 lines: every module, class and function of the package, its kind, its full name, and the first line of its docstring. `babykev.api` has 4 classes and 7 functions; `babykev.docs` has 1 class and 25 functions. 0.4 s.

$ uv run babykev docs list

`just --show docs` prints the recipe, a script with three branches: `help` explains; no words at all runs `uv run quarto render docs`, the site; any other words go to the program, `uv run babykev docs "$@"` (the recipe writes `{{ program }}` for `babykev`). So `just docs list` is the command above.

$ just --show docs

**C. One module, as Markdown.** `just docs module api` prints `api.py` as Markdown: a heading per symbol, the signature as a line of Python, the docstring, and a table of the parameters with type, default and description. Every Description cell is empty, because nothing in `api.py` carries a docment yet. The types are written as the source writes them, `JSONContent` and not the seven-way union it stands for. Then `just docs module docs`: the same for `docs.py`, and every Description cell is filled. Scroll to `class Symbol`: five fields, five descriptions, each from the comment beside the field.

$ just docs module api
$ just docs module docs

**D. Where a description comes from.** The first `sed` line prints `line_of`, lines 108 to 112 of `docs.py`: one parameter per line, a comment two spaces after it, and the return's comment after the colon of the `def` line. That comment is a docment, and fastcore reads it. The second `sed` line prints the `Symbol` dataclass, lines 46 to 54: the same for a field.

$ sed -n '108,112p' src/babykev/docs.py
$ sed -n '46,54p' src/babykev/docs.py

**E. The gaps.** `just docs check` prints one line per module and per test file: `babykev.api 0 of 12`, `babykev.cli 1 of 1`, `babykev.docs 26 of 26`, `test_api.py 23 of 29`, `test_cli.py 0 of 4`, `test_docs.py 0 of 16`; then every gap, one per line, 84 of them: 62 parameters with no docment, 10 returns with no docment, 11 pydantic fields with no description, 1 method with no docstring (`Choice._check`); then `50 of 88 functions, methods and classes are typed and documented`, and exit 1. 0.6 s. The rule is one sentence: every parameter typed and with a comment, the return typed and with a comment unless it is `None`, a docstring, and a description on every model field. `cli.main` passes with nothing to write: it has no parameters and returns `None`; the 23 of `test_api.py` pass the same way. `just check` is green at this commit because `docs check` is not in it yet. Step 04b adds it, once the gaps are filled.

$ just docs check

How do we know the checker is right? `docs.py` arrived with 16 tests, and they do not test it on babykev, which changes at every step. They write a small package into a temporary folder, with one documented function, one bare one, and a class, and check what the tool says about that. The `sed` line prints the start of that package, inside the test file as a string.

$ sed -n '10,20p' tests/unit/test_docs.py

The gaps test, lines 171 to 196, is the checker's rule written out: the documented symbols have no gaps, and the bare function is missing its docstring, two types, two docments and a return type, each named the way `docs check` names it. `just test -k gaps_names`: 1 passed.

$ sed -n '171,196p' tests/unit/test_docs.py
$ just test -k gaps_names

The Markdown test, lines 105 to 117, pins the shape of one entry: the heading, the signature as a line of Python, the docstring, and three rows of the table, each with its description. `just test -k heading_a_signature`: 1 passed.

$ sed -n '105,117p' tests/unit/test_docs.py
$ just test -k heading_a_signature

**F. The site, in two commands.** `uv run python docs/apidocs.py build` is the dev-side script: it asks the program for each module's Markdown, adds what a site needs, and writes `docs/api/api.qmd`, `cli.qmd`, `docs.qmd` and `docs/_symbols.json`; it prints `wrote 3 page(s) to docs/api/`.

$ uv run python docs/apidocs.py build

`uv run quarto render docs` is Quarto, the one tool this project does not install. Its `_quarto.yml` names the script above as `pre-render`, so Quarto prints `python`, runs it again (`wrote 3 page(s)` once more), then renders four pages and prints `Output created: _site/index.html`. 5 s. The no-words branch of the `docs` recipe is exactly this line, so from now on `just docs`. The `open` line shows the site: the front page, and under Reference one page per module, every heading with a link to its source line, and the empty Description columns of `api`. On the front page, `render` in backticks is a link to its entry.

$ uv run quarto render docs
$ open docs/_site/index.html

**G. How the links are made.** `head -8 docs/_symbols.json` shows the index `apidocs.py` writes: a name, short and full, to a page and an anchor; 75 entries in all.

$ head -8 docs/_symbols.json

`docs/linkify.lua` is 19 lines. At render, a name in backticks that is in the index becomes a link.

$ cat docs/linkify.lua

The `sed` line shows what `apidocs.py` added to the program's Markdown for `api`: the front matter, `{#Noul}` on the heading, the `[source]` link. This is the split: the program knows only its own code and prints plain Markdown; the dev side adds the site layer. The one interface between them is three functions in `docs.py`: the inventory, the Markdown of a module, the gaps.

$ sed -n '1,12p' docs/api/api.qmd

**H. Do docments hurt the formatter and the linter?** No, with one rule: the line must fit in 100 characters. The `perl` line makes the return docment of `line_of` 102 characters long. `just lint` then reports `E501 Line too long (102 > 100)` on line 110, and exits 1.

$ perl -pi -e 's/^\) -> int:  # The line its definition starts on$/) -> int:  # The line its definition starts on, counted from one as every editor does, never from zero/' src/babykev/docs.py
$ just lint

`just fmt --diff` shows what the formatter would do: wrap the return type, `) -> (` then `int` then `):  # The line its...`, so the comment lands two lines below the annotation. `just fmt` does it: `1 file reformatted`.

$ just fmt --diff
$ just fmt

`just lint` is now green: every line fits. Nothing else touches a docment: the formatter never joins a line that carries a comment, so a signature written one parameter per line stays that way, and no lint rule looks inside a comment (ERA001, E261 and E262 were run against the file; all pass).

$ just lint

But `just docs check` says `babykev.docs 25 of 26` and `babykev.docs:line_of: no return docment`: fastcore reads the comment on the line of the annotation, and the annotation moved.

$ just docs check

**I. Still green.** `just check` passes: 9 files formatted, lint clean, 69 tests, coverage 97.78%, the config files valid. 2.3 s. Seven lines of `docs.py` are reached by no test, and the coverage table names them (75, 192, 201, 205, 208, 221, 248): the `ImportError` of `file_modules`; in `type_text`, a forward reference written as a string, a generic such as `list[float]` (the real package has them, the test package does not), `...`, and the fallback `repr`; in `signature`, the keyword-only star; in `table`, the empty table of a function with nothing to list.

$ just check

**What the next step does.** The move to 04b drops the edit of section H. Step 04b fills the 84 gaps: the docments on `api.py`, `cli.py` and the tests, the descriptions on the model fields, and `docs check` into `check`.

## step-04b Every function documented

**Init.** `just setup` changes nothing in `.venv`: no dependency arrived. It prints `Checked 29 packages` and reinstalls the hook. 0.4 s.

$ just setup

**What is new:** the 84 gaps of step 04, filled. A docment beside each of the 18 parameters and returns of `api.py`, a description on each of its 11 model fields, a docstring on the validator; a docment on each of the 54 parameters and returns of the tests. And one line in the justfile: `just docs check` inside `just check`. This commit is clean. Everything is green, and the live part deletes one docment to show the check, and then the hook, catching it.

**A. Green.** `just docs check` prints `12 of 12` for `api`, then `1 of 1`, `26 of 26`, `29 of 29`, `4 of 4`, `16 of 16`, no gap, and `88 of 88 functions, methods and classes are typed and documented`, exit 0. 0.6 s, or 1.5 s the first time after a move, while Python compiles the files.

$ just docs check

**B. What a documented function looks like.** The `sed` line prints `render`, lines 68 to 72 of `api.py`: each parameter on its own line with its docment, the return's docment after the colon, the docstring below. The types of `indent` and the return say `int` and `str`; their comments say what the number means and what the text is for. A docment is for what the type cannot say.

$ sed -n '68,72p' src/babykev/api.py

**C. A model field's description.** The `sed` line prints `Noul`, lines 16 to 24. A pydantic model has no signature to put a comment on, so each field carries `Field(description=...)`, and `docs check` reads that the way it reads a docment. The `state` field of `SystemOneRequest` says "The context: the document the questions are about".

$ sed -n '16,24p' src/babykev/api.py

**D. The Markdown, filled.** `just docs module api` prints the same table as at step 04, every Description cell now filled. Scroll to `render`: "Text, a number, a list or an object, from a request", "How deeply nested this value is; each level indents by two spaces", "The text the model sees". Nothing was written twice: the comment beside the parameter is the cell in the table.

$ just docs module api

**E. The site, filled.** `just docs` builds the site again, 5 s. The `open` line shows `api`'s page with every description in place.

$ just docs
$ open docs/_site/index.html

**F. Delete one docment.** The `sed` line removes the comment beside `indent` in `render`. `just docs check` then prints `babykev.api 11 of 12`, one gap, `babykev.api:render(indent): no docment`, `87 of 88`, exit 1. 0.6 s. The `git restore` line puts the comment back.

$ sed -i '' 's|,  # How deeply nested.*|,|' src/babykev/api.py
$ just docs check
$ git restore src/babykev/api.py

**G. The hook refuses it.** The same `sed` line again, then a commit. The hook prints its four hooks: three `Passed` or `Skipped`, then `just check...Failed`, and under it everything `check` ran: the formatter (9 files), the linter (All checks passed!), the tests (69 passed, 97.78%), and then `docs check`'s table ending `babykev.api:render(indent): no docment`, `87 of 88`. 3.3 s. No commit was made: `git status` shows the file still modified, and the log still ends at this step. The `git restore` line puts the file back.

$ sed -i '' 's|,  # How deeply nested.*|,|' src/babykev/api.py
$ git commit -am "try"
$ git status
$ git restore src/babykev/api.py

**H. `check` has five lines now.** `just --show check` prints the recipe: `fmt --check`, `lint`, `test` over the floor, `docs check`, `lint-config`. `just check` runs all five, green, 2.8 s.

$ just --show check
$ just check

**What the next step does.** Step 05 brings the second file, `model.py`, as kev wrote it, and the cycle runs again: a file arrives bare, then its tests, types and docments, now under checks that exist.

## step-05 A second file: model.py

**Init.** `just setup` brings the model's stack: torch (the CPU build, from PyTorch's own index), transformers, peft, safetensors and what they need, hypothesis for the tests, and ty, the type checker. 64 packages in `.venv`, up from 30. From uv's cache it takes a second; the first time on a machine it is a download of a few hundred megabytes.

$ just setup

**What is new:** `src/babykev/model.py`, kev's model, typed, with a docment on every parameter and return and a docstring on everything; `src/babykev/smoke.py` and `babykev smoke`; a tiny model for the tests (`tests/tiny.py`, `tests/conftest.py`); `test_model.py` and `test_smoke.py`; two recipes, `smoke` and `types`. This commit is dirty on purpose, and nothing in it can tell: the mask lets a question see the questions before it (pretend it came that way from upstream), and two lines are written the way kev wrote them, which ty refuses. Everything `just check` runs is green. Step 05a brings what can see it.

**A. The four ideas.** The `sed` line prints the top of `model.py`, the module docstring, which names them. Packing: the state and every question into one sequence, marked off by five delimiter tokens. The mask: each token sees the state and its own question, never another. Positions restart after the state, so a question looks the same wherever it comes. Pointing: a head scores each option's closing token against the question's decide token; no text is generated.

$ sed -n '1,20p' src/babykev/model.py

**B. Packing, in the signature.** `encode`, lines 85 to 97: a tokenizer, a record as `to_record` returns it, two limits, and an `Encoded` back, each docment saying what the thing is. The last line printed looks up the five delimiter ids.

$ sed -n '85,97p' src/babykev/model.py

**The mask, as designed.** `branch_mask`'s docstring, lines 131 to 135 of `model.py`, states the rule: token i may attend to token j when j is not after i, and j is in the state or in the same question as i. The slide draws it as a grid. The cell that matters is a token of question 2 looking at question 1: an ordinary causal mask would allow it, and this rule forbids it. That one cell is the whole difference: it is why question 2 gets the same answer whether or not question 1 was asked. The slide shows the mask as it was designed; whether the code keeps the rule is a question for the end of this step.

$ sed -n '131,135p' src/babykev/model.py

**C. Pointing.** `PointerHead`, lines 146 to 166: two linear layers and a scaled dot product. The docments carry the shapes: `[d]`, `[K, d]`, `[K]`.

$ sed -n '146,166p' src/babykev/model.py

**What is trained.** The language model, Qwen2.5-0.5B, is frozen: 494,032,768 parameters that never change. Two things train: the LoRA adapter of rank 16, 8,798,208 parameters, and the pointer head, 459,264. That is 503,290,240 in all, 9,257,472 of them trainable, which the smoke prints as `503M parameters, 9.3M of them trainable`. The four counts were measured on step 05's code with the real model from the cache.

**D. Fixtures.** A test needs things to work on before it can check anything: a sample request, a tokenizer, a model. Not the real ones, but small stand-ins made up for the tests: data such as one request with three questions, and objects such as a tokenizer with one token per character. A fixture makes one of them, in one place, for every test that asks. It is a function marked `@pytest.fixture`. A test names it as one of its arguments; pytest finds the fixture of that name, calls it, and passes in what it returns. The `sed` line prints all three of ours, the whole of `tests/conftest.py` below its imports, lines 16 to 40. `tok` is built once for the whole run, because of `scope="session"`. `record` and `model` have the default scope, one per test, so they are built fresh for every test that asks, and no test can spoil them for the next. `model` itself asks for `tok`: a fixture can use another fixture. `capsys` and `monkeypatch` at step 01 were pytest's own fixtures; these are ours.

$ sed -n '16,40p' tests/conftest.py

**Writing a fixture.** At step 01 the tests built a request with a helper, `cheese_request`, lines 32 to 43 of `test_api.py`, and six tests call it by hand, as on line 81. The `record` fixture, lines 30 to 40 of `conftest.py`, does the same job the other way round: it is marked `@pytest.fixture`, and a test asks for it by name. To write one: a function that returns what the test needs, marked `@pytest.fixture`, in `conftest.py` if more than one file needs it. If the test leaves something to clean up, the fixture uses `yield` instead of `return`, and the code after `yield` runs when the test is done; `tmp_path`, which the documentation tests used at step 04, is pytest's own fixture of that kind.

$ sed -n '32,43p' tests/unit/test_api.py
$ sed -n '81p' tests/unit/test_api.py
$ sed -n '30,40p' tests/conftest.py

**`conftest.py`.** pytest reads `tests/conftest.py` before it runs any test, and every test file under `tests/` can use its fixtures without importing anything. Ours contains three fixtures: `tok`, the tiny tokenizer; `model`, a tiny model; `record`, one request with a state and three questions. Eight test functions ask for them: all eight for `tok`, four for `record`, two for `model`. pytest runs them as 12 tests, because one of the eight, the forgery test, runs once for each of the five delimiters. `just test --fixtures` lists every fixture pytest can see, 125 lines on the terminal with just's echo of the command: pytest's own and its plugins' first, then, at the end, under `fixtures defined from conftest`, ours, each with the line of its `def` in `conftest.py` (17, 23 and 31) and its docstring.

$ just test --fixtures

**Fixtures in use.** Eight test functions ask for the fixtures, and each asks for its own mix. `tok`: all eight. `record`: `test_positions_restart_after_the_state`, `test_a_question_that_does_not_fit_is_refused`, `test_probabilities_sum_to_one_for_every_question`, `test_with_an_adapter_only_the_adapter_and_the_head_train`. `model`: `test_probabilities_sum_to_one_for_every_question` and `test_smoke_reports_on_every_question_of_the_sample`. The other three that ask only for `tok` are `test_packing_marks_every_part_with_its_delimiter` and the two forgery tests. The `sed` lines print three of them. `test_positions_restart_after_the_state`, lines 60 to 69 of `test_model.py`, kind: unit, takes `tok` and `record`. `test_probabilities_sum_to_one_for_every_question`, lines 137 to 146, kind: integration, takes all three, and expects `[2, 3, 3]` because the `record` fixture's three questions have 2, 3 and 3 options: a fixture's data is known in advance, so a test can expect exact numbers. `test_smoke_reports_on_every_question_of_the_sample`, lines 9 to 21 of `test_smoke.py`, kind: integration, takes `model` and `tok`. Each test gets its own fresh `model` and `record`; all share one `tok`. `just test --fixtures-per-test` names the fixtures a test uses and where each is defined: for `-k "probabilities_sum or positions_restart"`, the two tests, `record` and `tok` for the first, `model`, `record` and `tok` for the second, each with its line in `conftest.py` and its docstring; for `test_smoke.py`, `model` and `tok`.

$ sed -n '60,69p' tests/unit/test_model.py
$ sed -n '137,146p' tests/unit/test_model.py
$ sed -n '9,21p' tests/unit/test_smoke.py
$ just test --fixtures-per-test -k "probabilities_sum or positions_restart"
$ just test --fixtures-per-test tests/unit/test_smoke.py

**E. The tiny model: a test that uses it.** `test_probabilities_sum_to_one_for_every_question`, lines 137 to 146 of `test_model.py`, kind: integration: packing, the model and the head together. The test never says "tiny". It names `model` and `tok` as arguments, and pytest passes it the tiny model and the tiny tokenizer. `encode(tok, record)` turns the record into tokens with the tiny tokenizer, and `model.probs(...)` runs them through the tiny model and the pointer head. The code that runs is our real `DecisionModel`, from `model.py`; only the backbone and the tokenizer under it are small. Nothing is trained, so the probabilities mean nothing. The test checks what is true of any probabilities: one per option, `[2, 3, 3]`, and they add up to 1. `just test -k probabilities_sum`: 1 passed.

$ sed -n '137,146p' tests/unit/test_model.py
$ just test -k probabilities_sum

**The tiny model: where `model` and `tok` come from.** `tests/conftest.py`, lines 16 to 27, contains two fixtures. `tok`, lines 16 to 19, returns `tiny_tokenizer()`; it is built once for the whole run (`scope="session"`). `model`, lines 22 to 27, returns `DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()`, a decision model on the tiny backbone, without an adapter; it is built again for each test, the default scope. pytest calls the two fixtures and passes what they return to every test that names them. `tests/tiny.py` contains two ordinary functions, `tiny_tokenizer` on line 16 and `tiny_backbone` from line 31. Nothing marks them `@pytest.fixture`: they build the two small parts, and any code can call them, as the two fixtures do. Why the builders are not fixtures: our `model` fixture takes no arguments and always returns one model, without an adapter. The adapter test needs a tiny model with an adapter, so it calls the function itself, at line 163 of `test_model.py`: `DecisionModel("tiny", "cpu", lora=4, backbone=tiny_backbone(len(tok)))`. `test_model.py` also calls `tiny_tokenizer()` at line 14, `TOK = tiny_tokenizer()`, for two tests further down, at lines 82 and 115. Those two are fed by hypothesis, which runs a test many times; hypothesis refuses a test that takes a function-scoped fixture such as `model` (step 05a tries it), so a test that hypothesis feeds builds what it needs itself. The `grep` line finds every call.

$ sed -n '16p;31,34p' tests/tiny.py
$ sed -n '16,27p' tests/conftest.py
$ grep -n "tiny_backbone\|tiny_tokenizer" tests/unit/test_model.py tests/conftest.py

**The tiny model: what the two functions build.** Both halves are built in memory, with no download. The tokenizer has one token for each of the 100 printable characters, one for each of the five delimiters, and `[UNK]`, the token for any other character: 106 tokens in all; the `python` line asks it to split "Roquefort" and gets nine tokens, one per letter. The backbone is Qwen's own code, `Qwen2Model`, built smaller: 2 layers of 32 numbers, where the real model has 24 layers of 896. Its weights are random, from a fixed seed, so they are the same every run. The second `python` line counts them: 24,224 parameters, against the real backbone's 494,032,768.

$ sed -n '22,27p' tests/tiny.py
$ sed -n '37,46p' tests/tiny.py
$ uv run python -c "from tests.tiny import tiny_tokenizer; t = tiny_tokenizer(); print(len(t), t.tokenize('Roquefort'))"
$ uv run python -c "from tests.tiny import tiny_backbone; print(sum(p.numel() for p in tiny_backbone(106).parameters()))"

**F. The tiny model, why it is enough.** What the tests check is exact: which token may see which, where the positions start, which parameters get a gradient. That is true for any weights, trained or random. What the tiny model cannot tell: whether the answers are any good, how the real tokenizer splits words, how fast it runs on a GPU. What it buys: no download, no GPU, a few seconds. It is a working, simplified stand-in for the real model; testers call such a stand-in a fake. Only our code can make these tests fail: no network, no download, and they run on the CPU, which every machine has. They are hermetic, so they run on every commit.

**G. Kinds of tests.** Five names, by how much of the program a test runs. A unit test runs one function alone: `test_score_confidence_is_zero_for_a_guess` gives `score_confidence` three numbers. An integration test runs several of our parts together, with stand-ins for what comes from outside: `test_probabilities_sum_to_one_for_every_question` packs a request and runs the model and the head, and `test_smoke_reports_on_every_question_of_the_sample` takes each request of the sample file through the contract, the packing, the model and the answers, both on the tiny model. An end-to-end, or system, test runs the whole program with its real parts, the way a user does: `just smoke local`, on the real model. A smoke test is a quick end-to-end run, to see whether the program starts and answers at all; our end-to-end run is a smoke. An acceptance test asks whether a promise to the users is kept, such as an answer within 50 ms; we have none. An end-to-end test uses the real parts, so something outside our code can make it fail: it is never hermetic, and our smoke needs the download and a device. An integration test is hermetic only when what comes from outside is replaced: ours are, because the tiny model replaces the real one; one that talks to a real database is not. The tiny model is not a kind of test: it is the stand-in for the real model, and the `model` fixture returns it to the tests that name it. A test's name says what it calls, not what kind of test it is: `test_smoke_reports_on_every_question_of_the_sample` calls our function `smoke`, but it is an integration test, not a smoke test. Teams draw the lines between these names differently, so when you call a test an integration test, say what runs in it.

**H. The tests.** `just test`: 92 passed, 23 of them new. The coverage table has two new rows: `model.py` 96% (the CUDA branch and the real-model loading path are not reached by a tiny model), `smoke.py` 71% (its `main` loads the real model). Total 94%, over the floor. The first run after a move takes about 30 seconds while Python compiles torch's modules; after that, about 7.

$ just test

`just test -k forge` runs the forgery tests alone: 6 passed. Kind: unit, `user_tokens` and a tokenizer. The `sed` line prints two of them: the first proves the danger is real (the text of a delimiter, tokenized plainly, becomes that delimiter), the second that `user_tokens` closes the door, for each of the five.

$ just test -k forge
$ sed -n '96,112p' tests/unit/test_model.py

Two more to read. `test_smoke.py`, lines 9 to 21, kind: integration. It calls our function `smoke` with the tiny model, and the report must have a line for each of the fifteen questions of the sample, and a closing count. `just test -k smoke_reports`: 1 passed, and no model was downloaded for it.

$ sed -n '9,21p' tests/unit/test_smoke.py
$ just test -k smoke_reports

And the weighty one, `test_model.py` lines 158 to 178, kind: integration, what trains: one backward pass on the tiny model with an adapter, then every parameter that received a gradient is named, and all of them are the adapter's or the head's, and `trainable_parameters` lists exactly those. `just test -k only_the_adapter`: 1 passed. This test says what fine-tuning means here: the backbone never moves; nine million parameters do.

$ sed -n '158,178p' tests/unit/test_model.py
$ just test -k only_the_adapter

**I. Documented, and checked.** `just docs check`: 139 of 139, every function, method and class in the package, the tests and `docs/apidocs.py`. `just check`: green, 15 seconds now that the model tests are in it.

$ just docs check
$ just check

**What a smoke test is.** The name comes from electronics: switch a new circuit on, and see whether it smokes. A smoke test asks whether the whole thing starts and gives an answer at all, not whether the answer is right. It is fast and shallow, and runs first, before the slow and deep tests. Ours loads the real model, asks the 15 sample questions, and prints each answer beside its label. Kind: smoke, which is end-to-end; run by hand, not part of `just test`.

**J. The smoke, as a command.** `uv run babykev smoke` is the program's new word. It loads the base model, Qwen2.5-0.5B, with a fresh adapter and an untrained pointer head, on the best device this machine has (`mps` here, Apple's GPU), and asks it the five sample requests. It prints the device, the load time (4 s), the parameter counts (503M, 9.3M of them trainable: the adapter and the head), then each answer beside its label, and the count: 6 of 15 right, about 200 ms a request on this Mac (198 ms at one run, 212 at another). 10 seconds in all. The first time on a machine, the download of the base model, about 1 GB. Nothing is trained, so these are guesses. What the run proves is that the pieces fit: the contract, the packing, the model, the answers.

$ uv run babykev smoke

`just --show smoke` prints the recipe: a script with three branches, `help`, `local` (the command above), and anything else refused with a message, because no other platform exists yet. `just smoke local` runs it: the same report, 6 of 15 right. From now on, `just smoke local`.

$ just --show smoke
$ just smoke local

**K. The type checker.** A type says what kind of value something is: a whole number, a list of numbers, a tokenizer. Since step 03, every function of ours says the types it takes and the type it returns, and we use this in docments. `uv run ty check` is ty: it compares every call and every `return` with what the function says, by reading the code, without running it. It prints 6 diagnostics, in 3 seconds. The code runs, and every test passes; ty finds the places where a caller trusts more than the called function promises.

$ uv run ty check

`just --show types` prints the recipe: its comment, two attributes, its name, and a body of one line, `uv run ty check "$@"`, inside an `if` that answers `help`. The words after `just types` go to ty. From now on, `just types`.

$ just --show types
$ just types

`just --show check` shows what is not there: no `types` line. Here we run ty by hand and read what it finds. `just check` does not include it yet, so a commit with negative ty findings still goes through, and the hook let this commit in with its six findings. At the next step, 05a, `just check` runs ty too. From then on, a commit with a negative ty finding is refused.

$ just --show check

**Currently we get six findings.** Each is printed with a file, a line and a code. `model.py:68`, `invalid-return-type`: `load_tokenizer` says it returns a `PreTrainedTokenizerBase`, and returns what `AutoTokenizer.from_pretrained` gives, which the library says may be one of two backends or `None`. `model.py:97`, `not-iterable`: the result of `convert_tokens_to_ids` may be a single number, which cannot be split into five names. `test_model.py:49` and `:120`, `not-iterable`: the same. `test_model.py:100`, `not-subscriptable`: the same result, followed by `[4]`; a single number has no item 4. `test_model.py:111`, `invalid-argument-type`: the same result, given to `set(...)`, which needs something it can go through item by item. The first comes from one call; the other five from one other call, `convert_tokens_to_ids`. The `sed` line prints the first.

$ sed -n '65,68p' src/babykev/model.py

**The five findings from one call.** `model.py` line 97 splits the result of `tok.convert_tokens_to_ids(SPECIAL)` into five names. `SPECIAL` is the list of the five delimiters, and `convert_tokens_to_ids` turns tokens into their numbers. The library says it returns `int | list[int]`: one number when given one token, a list when given a list. We give it a list of five, so it returns a list of five, and the line de-structures them into five names. The code runs, and the tests pass. ty reads only what the library says, not what happens at run time, and "it may be one number" is enough: one number cannot be split into five names. The `grep` line finds the call in `model.py` and the tests: line 52 of `test_model.py` passes one character at a time and uses each result as one number, so ty has nothing to say about it. In the next step, 05a, we call this once, in a new function `delimiter_ids`, which always returns a list. It also makes `load_tokenizer` stop with an error when it gets no tokenizer. Then ty finds nothing, and `just types` joins `just check`.

$ sed -n '97p' src/babykev/model.py
$ grep -n "convert_tokens_to_ids" src/babykev/model.py tests/unit/test_model.py

**L. The problem with the mask as written.** This is what the mask should be, token by token: say we have a small request of six tokens, numbered 1 to 6 in the order they are packed: two for the state, two for question 1, two for question 2. The mask says, for each token, which tokens it may look at. The slide draws it as a grid, one row per token, `#` for "may look at this token" and `.` for "may not". No token may look at a token after it, so everything right of the diagonal is `.`. The tokens of question 2, rows 5 and 6, may not look at question 1, tokens 3 and 4: rows 5 and 6 read `##..#.` and `##..##`. This is the red cell of the earlier picture, token by token, and it is the rule of `branch_mask`'s docstring, lines 131 to 135.

**All green, and the mask is wrong.** Here there is no test that checks the mask. Every check in `just check` passes: 92 tests, 94% coverage, 139 of 139 documented, a smoke that answers every question. Coverage counts `branch_mask` as tested, because its lines ran; no test looks at the mask the code here builds. The `python` line asks `branch_mask` for the mask of the six tokens of the last slide, parts `[0, 0, 1, 1, 2, 2]`, and prints it as rows of `#` and `.`. Rows 1 to 4 are as they should be. Rows 5 and 6 are `#####.` and `######`: question 2 may look at question 1. The `sed` line prints the cause, line 140. `same` should be yes only when two tokens are in the same question, or the other one is in the state; `torch.ones_like(causal)` makes it yes for every pair, so every token may look at every token before it.

$ uv run python -c "from babykev.model import branch_mask; m = branch_mask([0, 0, 1, 1, 2, 2], 'cpu')[0, 0] == 0; print('\n'.join(''.join('#' if x else '.' for x in r) for r in m))"
$ sed -n '140p' src/babykev/model.py

**A check that sees it.** At step 05 there is no test of the mask, and we bring none forward: a few lines of plain Python do the job. The slide shows them as a function; the shell runs the same comparison as a here document, where `python -` reads the lines up to `EOF`. The lines import `branch_mask`, hold the right mask for six tokens, two of the state and two each of two questions, as six lines of `#` and `.`, build the mask with `branch_mask` for the parts `[0, 0, 1, 1, 2, 2]`, and print each pair of rows, the right one and the built one, with `ok` or `WRONG`. Rows 1 to 4 print `ok`. Row 5 prints `##..#. #####. WRONG`: the state and itself are right, and the built mask also takes question 1's two tokens. Row 6 prints `##..## ###### WRONG`. The same two rows as the grids of the last slide. Nothing to clean up: nothing was written to a file.

$ uv run python - <<'EOF'
$ from babykev.model import branch_mask
$ picture = ["#.....", "##....", "###...", "####..", "##..#.", "##..##"]
$ mask = branch_mask([0, 0, 1, 1, 2, 2], "cpu")[0, 0] == 0
$ rows = ["".join("#" if ok else "." for ok in row) for row in mask]
$ for want, got in zip(picture, rows, strict=True): print(want, got, "ok" if want == got else "WRONG")
$ EOF

**The commit anyway.** The last slide, with Pavlos. Normally we would fix before we commit. This commit went in with the mask wrong, and with six ty findings, on purpose: nothing in `just check` can see either, so the hook let it through. Pavlos distracted us, so we committed and went to his class. The next step is what we do when we come back.

**What the next step does.** Step 05a brings the seven tests that see the mask, the one-line fix, the two guards ty asked for, `just types` into `check`, and two pages on the model.

## step-05a The tests that could tell

**Init.** `just setup` changes nothing in `.venv`: no new package. 0.5 s.

$ just setup

**What is new:** seven tests that see the mask, of nine new tests: `tests/unit/test_mask.py`, five tests of the mask's rule, three of which fail on step 05's mask, and four isolation tests in `test_model.py`, which all fail on it; the fix, one line of `branch_mask`; the two guards ty asked for, `delimiter_ids` and a check in `load_tokenizer`; `just types` as a line of `check`; two pages of the docs site, `docs/guide/00_model.qmd` (the four ideas) and `docs/guide/01_mask.ipynb` (the mask as a grid, with the mask of step 05 beside it), and a test that re-runs the notebook. Clean: 103 tests, 154 of 154, green.

**We had two problems left over from step 05.** The slide names them; both are lines of step 05's `model.py`, which this step changes, so there is nothing to print here. The first is a type problem. `just types` printed six findings at step 05. Five come from one line, line 97, `tok.convert_tokens_to_ids(SPECIAL)`, which gives back a list of five numbers that the line splits into five names; the library says it may give back one number, which ty cannot see past. The sixth is `load_tokenizer`, which may give back `None`. The second is a mask problem. `branch_mask` lets question 2 look at question 1, line 140 of step 05's file, and every check passed, because no test checks the function that builds the mask. Step 05a deals with both: the tests that see the mask, the one-line fix, and the two guards for ty.

**The tiny model, again.** Step 05 built a tiny tokenizer and a tiny model in memory, in `tests/tiny.py`: 106 tokens, 2 layers of 32 numbers, 24,224 parameters, measured at step 05; neither `tiny.py` nor `conftest.py` changed in this step. A test gets them as fixtures. The first `sed` line prints `tests/conftest.py`, lines 16 to 27: `tok`, built once for the whole run (`scope="session"`), returns `tiny_tokenizer()`; `model`, built fresh for each test, returns a decision model on `tiny_backbone(len(tok))`, on the CPU, without an adapter. A test builds nothing. It names `model` and `tok` as arguments, and pytest passes in what the two functions return; the tests of this step do that. The second `sed` line prints lines 30 to 40, the `record` fixture: one request about Roquefort, with a state and three questions, `Is this a blue cheese?` with 2 options, `Which milk?` with 3, `How firm?` with 3.

$ sed -n '16,27p' tests/conftest.py
$ sed -n '30,40p' tests/conftest.py

**A. Test properties, not examples.** Four properties, for any request: change question 2 and question 1's answer must not move; three questions in one pass give the numbers of three passes; the order of the questions does not matter; and the mask's rule, no token sees a later one and no question sees another. They are true for any weights, so the tiny model is enough. `just test`: 103 passed, the 92 of step 05 and 11 new: nine tests of the mask and of isolation, and two notebook tests.

$ just test

**B. A picture checks one size.** At the end of step 05, five lines of plain Python drew the right mask for a request of six tokens next to the one `branch_mask` built, and rows 5 and 6 were WRONG. The mask is fixed in this step, and the same five lines print `ok` six times. In `test_mask.py` the same comparison is the test `test_mask_of_a_small_request`, lines 28 to 39. Suppose someone fixed the mask like this instead: a token may look at the state, at its own question, and at any question more than one before it, so only the question right before is blocked. The first `perl` line writes that wrong fix into line 151 of `branch_mask`. The first here document, the six-token request of the end of step 05, still prints `ok` six times: its picture has only two questions, so it cannot tell. The second here document has a different size: one state token and three questions of one token each, parts `[0, 1, 2, 3]`, four tokens, with a picture drawn by hand. Rows 1 to 3 print `ok`. Row 4 prints `#..# ##.# WRONG`: question 3 looks at question 1. The `git restore` line puts the fix back: every paragraph from here puts in what it needs, and restores it, so each runs on its own. We have no function that draws the right mask for any size, and the hypothesis tests of the next paragraphs do not draw pictures: they state the rule. A request can have 1 to 6 state tokens, then 0 to 4 questions of 1 to 5 tokens each, 6 times 781, which is 4,686 shapes, and each would need its own picture.

$ perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)/' src/babykev/model.py
$ uv run python - <<'EOF'
$ from babykev.model import branch_mask
$ picture = ["#.....", "##....", "###...", "####..", "##..#.", "##..##"]
$ mask = branch_mask([0, 0, 1, 1, 2, 2], "cpu")[0, 0] == 0
$ rows = ["".join("#" if ok else "." for ok in row) for row in mask]
$ for want, got in zip(picture, rows, strict=True): print(want, got, "ok" if want == got else "WRONG")
$ EOF
$ uv run python - <<'EOF'
$ from babykev.model import branch_mask
$ picture = ["#...", "##..", "#.#.", "#..#"]
$ mask = branch_mask([0, 1, 2, 3], "cpu")[0, 0] == 0
$ rows = ["".join("#" if ok else "." for ok in row) for row in mask]
$ for want, got in zip(picture, rows, strict=True): print(want, got, "ok" if want == got else "WRONG")
$ EOF
$ git restore src/babykev/model.py

**C. hypothesis: state the rule, the computer tries the shapes.** `hypothesis` is a Python library for tests; `just setup` installed it with the model's stack at step 05. The `sed` line prints three lines of `test_mask.py`. Line 10, `shapes`, says what a request may look like: a state of 1 to 6 tokens, then a list of up to 4 questions of 1 to 5 tokens each. `@given(shapes)` on line 58 runs the test below it again and again, each time with a shape drawn at random from the 4,686: by default, up to 100 times. When a shape breaks the rule, hypothesis shrinks it, trying smaller shapes until none smaller breaks, and shows that one. hypothesis also allows each run 200 ms by default. The first run that uses torch can take longer than that on a slow or busy machine: in a rehearsal in the dev container, one example of the rule test took 1180 ms, the run failed with `DeadlineExceeded`, and the same test passed on another run. The second `sed` line prints lines 43 to 51 of `tests/conftest.py`, which turn the deadline off for the whole run, with a comment that says why; the import sits below the fixtures so that they keep lines 16 to 40.

$ sed -n '10p;58,59p' tests/unit/test_mask.py
$ sed -n '43,51p' tests/conftest.py

**D. hypothesis finds the size for us.** The `perl` line writes the wrong fix of paragraph B in again, so that this paragraph runs on its own. The `sed` line prints one rule test, lines 58 to 65 of `test_mask.py`, kind: unit: `segments` gives the part of each token, 0 for the state and k for question k; `siblings` is yes for two tokens in two different questions; `allowed` is the mask read as yes or no; the test says no pair is both. `just test -k no_question_sees_another` runs it alone. hypothesis tries shapes until the rule breaks, and shrinks the failure to `shape = (1, [1, 1, 1])`: one state token and three questions of one token each, parts `[0, 1, 2, 3]`, the request we drew by hand in paragraph B. We chose that size; hypothesis found it on its own. The output prints `allowed` and `siblings` as tensors of `True` and `False`; written as `#` and `.`, `allowed` is `# . . .`, `# # . .`, `# . # .`, `# # . #`, and `siblings` is `. . . .`, `. . # #`, `. # . #`, `. # # .`. Row 4, column 2 is yes in both: token 4, in question 3, looks at token 2, in question 1. The `git restore` line puts the fix back.

$ perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)/' src/babykev/model.py
$ sed -n '58,65p' tests/unit/test_mask.py
$ just test -k no_question_sees_another
$ git restore src/babykev/model.py

**E. How we tested isolation.** The `perl` line writes step 05's mask line back into `branch_mask`: a plain causal mask, every token sees everything before it. The isolation test needs that mask: with the wrong fix of paragraph B it passes, because question 3 cannot see question 2, so rewriting question 2 changes nothing. `test_a_question_cannot_see_its_sibling`, lines 145 to 157 of `test_model.py`, kind: integration, on the tiny model. It takes the fixtures `model`, `tok` and `record`, from `conftest.py`. `logits_of` packs a request and gives, for each question, one score for each of its options. The test scores the request, rewrites question 2 (`Where from?`, two options in place of three), and scores again. Questions 1 and 3 must get exactly the same scores, `torch.equal`, and question 2 must get a different number of scores. With step 05's mask the line for question 3 fails: before, `tensor([-0.2301, -0.2331, -0.2340])`; after, `tensor([-0.2266, -0.2302, -0.2312])`. Question 3 could look at question 2, so rewriting question 2 moved its scores. The line for question 1 passes: question 1 comes first and cannot look at what follows. The `git restore` line puts the fix back. The same idea for any request is `test_packed_equals_separate_for_any_record`, lines 184 to 194, which hypothesis feeds: one pass over all the questions must give what one pass for each question alone gives. It builds its own tiny model, at line 190, in place of taking the `model` fixture: hypothesis runs the test body many times, and refuses a test that takes a function-scoped fixture. Tried in a scratch copy, a `@given` test with `model` as an argument fails with `FailedHealthCheck: ... uses a function-scoped fixture 'model'`.

> Ask: is this a unit test or an integration test? It runs four of our parts in a row: `encode` packs the request, the model builds the mask, the tiny backbone runs, and the head scores. A unit test is one function alone, so by our table it is integration, with the tiny model standing in for the real one. The mask test of the last slides is the unit test: `branch_mask` alone, asking whether the mask is right. This one asks whether the answers stay put. Teams draw the line differently: some would call this a unit test of the model, so say what runs in it.

$ perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = torch.ones_like(causal) | (s[None, :] == 0)/' src/babykev/model.py
$ sed -n '145,157p' tests/unit/test_model.py
$ just test -k a_question_cannot_see_its_sibling
$ git restore src/babykev/model.py

**F. The tests see it, and the one-line fix.** The `perl` line writes step 05's mask line back, as in the last paragraph. `just test`: 8 failed, 95 passed, in about 20 seconds, because hypothesis shrinks each failing case to its smallest. Three of the five tests of `test_mask.py` fail: the picture test and two of the three rules. The two that pass check the mask's shape and that no token sees a later token. The four isolation tests fail, and the notebook test, because the grid the notebook stored no longer matches what the code prints. The commit hook, installed at step 03, runs `just check`, and `just check` runs these tests, so this commit would now be refused, at the tests, with the same eight names. ty passes here: the two guards of paragraph H are already in the files, and only the mask line is wrong. We saw a refused commit at steps 03 and 04b, so we do not make one here. The `git restore` line puts the fix back, because everything after this needs it. The last `sed` line prints line 151, the fix: a token may look at the state, or at its own question. Step 05 had `torch.ones_like(causal)` where the first part is.

$ perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = torch.ones_like(causal) | (s[None, :] == 0)/' src/babykev/model.py
$ just test
$ git restore src/babykev/model.py
$ sed -n '151p' src/babykev/model.py

**G. The smoke run on Qwen, again.** `just smoke local` on the right mask: 4 of 15 right, about 300 ms a request (242 ms at one run, 327 at another). It was 6 at step 05, and several answers changed: the first cheese's milk went from buffalo to cow. A pure guess on these fifteen questions expects 4.75 right: the sample has five yes-or-no questions, a guess right once in 2, five choice questions of 5 options, once in 5, and five score questions of 4 levels, once in 4, which is 2.5 + 1 + 1.25.

$ just smoke local

**H. The type problem: two guards.** The `sed` line prints lines 64 to 80: `load_tokenizer` checks what came back, and stops with an error if it is not a tokenizer, so it never gives back `None`; `delimiter_ids` is the one place that calls `convert_tokens_to_ids`, and turns one number into a list of one, so it always gives back a list. `encode`, line 108, and the tests, lines 57, 108, 119 and 128 of `test_model.py`, call it in place of the five calls ty complained about. `just types`: All checks passed!

$ sed -n '64,80p' src/babykev/model.py
$ just types

**I. ty joins `just check`.** `just --show check`: six commands now, `types` between `lint` and the tests. `just check`: green, 20 seconds. The commit hook runs `just check`, so a commit with a type problem is now refused, at ty, before the tests run: a type error added to `model.py` in a scratch copy stopped `just check` there, with `Found 1 diagnostic`. At step 05 we could commit with six ty findings. From now on we cannot.

$ just --show check
$ just check

**J. The model, explained.** `just docs` renders eight pages now, with a Guide section. 11 seconds.

$ just docs

The first guide page is the four ideas, in prose, where every name in backticks links to its reference entry. The second is the mask as a grid, a notebook committed with its outputs, with the mask of step 05 beside the right one.

$ open docs/_site/guide/00_model.html
$ open docs/_site/guide/01_mask.html

`just test -k notebook` re-runs the notebook's cells and checks the stored outputs are still what the code prints: 2 passed.

$ just test -k notebook

**What the next step does.** 05b puts the project in two images, so it runs the same on any system with Docker, and is ready for the platforms.

## step-05b Two images from one lockfile

**Init.** `just setup` brings one package, hadolint 2.15.1, the Dockerfile's linter, as a wheel from PyPI: there are wheels for the Mac and for Linux on both architectures. 0.5 s.

$ just setup

**What is new:** a `Dockerfile` that builds two images from `uv.lock`, and a `.dockerignore`; the `image` recipe; hadolint as a line of `lint-config`; `tests/system/test_real_model.py`, the smoke on the real model, marked `system` and left out of `just test`; a section of the README on Docker. Clean: 103 tests and 1 deselected, 155 of 155 documented, green.

**How Docker was born.** The second slide is the meme: "It works on my machine." "Then we'll ship your machine." And that is how Docker was born. A widely shared meme; its author is unknown (imgflip.com/i/24ac74).

**Two images from one lockfile.** The table of the next two pictures. The dev image has every dependency with the dev tools, uv, just, Quarto and git; it starts a shell with your folder mounted; it is for working on the project on any system, and in CI; 1.84 GB. The run image has Python and what the program needs; it starts `babykev`; it is for a platform that runs the program; 1.15 GB. Both are built from `uv.lock`, the packages first and the code after, so a change to the code does not reinstall torch.

**A. The run image, in the file.** The `sed` line prints lines 11 to 39 of the `Dockerfile`. Line 12 takes uv from its own image. Lines 16 to 28 are a build stage: the packages from the lockfile first (line 25), then the code (lines 27 and 28), so a change to the code reinstalls one package and not torch. Lines 31 to 39 are the run image: a fresh Python, the finished environment copied over from the build stage (line 32), the sample data, and `babykev` as the command it starts. No uv, no just, no dev tools. The first slide of the two shows these lines with the settings (lines 18 to 23 and 35 to 37) left out, and a note on each stage.

$ sed -n '11,39p' Dockerfile

**B. Build it, run it.** `docker build --target run` builds that image and names it `babykev-run`: 20 s with the cache warm. `docker run --rm babykev-run` starts it with no words, which runs line 39's default, `babykev help`, and removes the container when it exits.

$ docker build --target run --tag babykev-run .
$ docker run --rm babykev-run

`docker image ls` with a format prints the name and the size: 1.15 GB, nearly all of it torch.

$ docker image ls babykev-run --format '{{.Repository}}:{{.Tag}}  {{.Size}}'

**C. The smoke on Linux.** The same smoke, in the image. The `-v` mounts this Mac's Hugging Face cache at `/hf`, where line 36 tells the image to look, so the 953 MB model is not downloaded again. It says `on cpu`: a container on a Mac is Linux in a virtual machine, and sees no Apple GPU. 4 of 15 right, 2.9 s a request, 33 s in all. On the Mac (05a) it was 362 ms a request on `mps`, and the fifteen answers are identical, line for line, to the two decimals printed.

$ docker run --rm -v ~/.cache/huggingface:/hf babykev-run smoke

**D. The dev image.** Lines 41 to 77: the image to work in. Debian packages for git and curl (lines 49 to 51), Quarto from its release (lines 53 to 56), uv (line 57), just from PyPI (line 68), and then the whole project with its dev group (lines 71 to 74). The environment is in `/opt/venv` (line 58), outside the project folder. Line 76 declares the port the step browser uses. It starts a shell. The second slide shows these lines with the long ones cut, and a note on each part. `docker build --target dev` needs only the first stage, `uv`, because that is the only stage the dev image copies from.

$ sed -n '41,77p' Dockerfile

`docker build --target dev`: 2 s with the cache warm; 61 s cold. 1.84 GB: the dev tools, Quarto and git on top of the run image's 1.15.

$ docker build --target dev --tag babykev-dev .

**E. Working inside it.** `docker run -it` gives a terminal in the container; `-v "$PWD":/work` mounts this folder as the project, so an edit here is seen in there at once. The prompt changes: we are in Linux, in `/work`.

$ docker run --rm -it -v "$PWD":/work babykev-dev

`which` shows where each tool is: Python from `/opt/venv`, just, Quarto and uv from `/usr/local/bin`. This folder's own `.venv` is the Mac's, and nothing in the container looks at it.

$ which python just quarto uv

`just check`, inside: the same lines as on the Mac, and green. 103 passed, 1 deselected, 155 of 155, 93.12% coverage. 24 s on its own, 65 s in the rehearsal of 2026-10-06 with another container running. `just smoke local`, inside: the same smoke as on the Mac, on the CPU, from the mounted cache: 4 of 15 right, loaded in 10 s, about 8 s a request with another container running. `git status` works in the mounted folder, because line 69 of the `Dockerfile` declares every folder safe. As `root`, in `/work`: Python 3.13, just 1.50.0, uv 0.12.13, Quarto 1.8.26.

$ just check
$ just smoke local
$ exit

**F. The recipe.** `just --show image`: one recipe, three words. `build dev|run` runs the `docker build` of B or D and names the image by the commit, so the image always says which code is in it; `shell` is E's `docker run`; `run WORDS` is C's. On a machine with no Docker, and inside the image, it says so instead of failing.

$ just --show image

From now on `just image`. Both builds are instant from the cache, and `docker image ls` shows each image under two names: `latest`, from B and D, and the commit's short hash.

$ just image build dev
$ just image build run

$ docker image ls 'babykev-*' --format '{{.Repository}}:{{.Tag}}  {{.Size}}'

`just image shell` starts a new container every time, and `exit` deletes it: whatever was installed or run in there is gone, and only the mounted folder keeps what changed. To keep one, `just image start` leaves a container named `babykev-dev` running in the background; `just image shell` then goes into that one (`docker exec`), and a second `just image start` refuses. Both publish the dev image's port 8765, the step browser's, on the first free port here from 8765 up, and print the address: in the rehearsal `http://localhost:8766`, because the step browser on this Mac uses 8765. `docker ps` shows it running, with the port. `just test` inside: 103 passed, 1 deselected. `just image stop` removes it.

$ just image start
$ docker ps --filter name=babykev-dev --format '{{.Names}}  {{.Image}}  {{.Status}}  {{.Ports}}'

$ just image shell
$ just test
$ exit

$ just image stop

**G. hadolint.** A linter for Dockerfiles. `uv run hadolint Dockerfile` says nothing: clean, exit 0. It found two things in the first draft, and the slide shows both.

The first is rule DL3059: two `RUN` lines in a row could be one. Lines 68 and 69 are one `RUN`, the `just` install and the `git` setting joined with `&&`. The first `perl` line splits them into two `RUN` lines, and hadolint then says `Dockerfile:69 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation.`, exit 1. The `git restore` line puts the file back.

$ uv run hadolint Dockerfile
$ perl -pi -e 's/^RUN uv tool install "rust-just==\$\{JUST\}" \\$/RUN uv tool install "rust-just==\${JUST}"/; s/^    && git config /RUN git config /' Dockerfile
$ uv run hadolint Dockerfile
$ git restore Dockerfile

The second is DL3008. Lines 46 to 48 say why: hadolint's rule DL3008 asks for a pinned version of every Debian package, and we declined it, with the reason beside the line. The `perl` line deletes the ignore, line 48; hadolint then says `Dockerfile:48 DL3008 warning: Pin versions in apt get install. Instead of `apt-get install <package>` use `apt-get install <package>=<version>``, exit 1, at the `RUN` line. A pinned Debian version is removed from the archive at its next security fix, and the build breaks within weeks; the base image's tag is the pin. The `git restore` line puts the ignore back, because the next command checks the file.

$ sed -n '46,48p' Dockerfile
$ perl -ni -e 'print unless /^# hadolint ignore=DL3008$/' Dockerfile
$ uv run hadolint Dockerfile
$ git restore Dockerfile

`just --show lint-config`: hadolint is the second line. `just lint-config`: green, 1.5 s. So the hook runs it on every commit.

$ just --show lint-config
$ just lint-config

**What should not go in the hook?** The slide asks it, because the slides so far were about the hook: at almost every step we added a check, `just check` runs them all, and the commit hook runs `just check`. A check that needs the network, a download, a GPU or a lot of time can fail for reasons outside our code, and a hook that fails for those reasons cannot be trusted. The question for every check: can anything but our code make it fail?

**Kinds of tests, and which can run on every commit.** The table of step 05 again, with an example of ours for each kind and whether it is hermetic. Unit: a confidence function on a list of numbers. Integration: the mask, the packing and the model together, and the whole smoke on the tiny model; hermetic, because the tiny model stands in for the real one. End-to-end: the smoke on the real model, `test_real_model.py`; not hermetic. Smoke: the same smoke, by hand, `just smoke local`. Acceptance: none yet. pytest has no built-in kinds: a marker is a name we make up in `pyproject.toml`, put on a test as `@pytest.mark.NAME`, and choose with `-m NAME`. Our one marker is `system`, the end-to-end kind of the table: it is on the one test that needs the Hub, the weights and a device.

**2 unit tests, 0 integration tests.** The meme: two window handles that each work when used alone, and block each other when used together. Made popular by Randal Olson in January 2016; the clip's author is unknown. The file in `slides/pictures/memes/` is the clip from Giphy, cut to 300 pixels wide and 8 frames a second, 2.6 MB; an earlier copy was Giphy's "This content is not available" placeholder.

**H. The test that is not hermetic.** `pyproject.toml` lines 53 to 57: pytest now leaves out every test marked `system` (line 56), and line 57 declares the marker.

> Ask: the mask test of step 05a runs in `just test`. Did we mark it? No. It is an integration test by kind, but it is hermetic, so it has no marker, and it runs at every commit. The marker `system` marks only what is not hermetic: the smoke on the real model, which is a system test.

$ sed -n '53,57p' pyproject.toml

The test, `tests/system/test_real_model.py`: the docstring says why it is apart, line 14 marks every test in the file, and the test runs the smoke's `main` and asserts what is true on any device: exit code 0, fifteen verdicts, and a count of them. Not the score: an untrained model guesses.

$ sed -n '1,27p' tests/system/test_real_model.py

`just test`: 103 passed, 1 deselected. `just test -m system`: 1 passed, 103 deselected, 19 s on the Mac's GPU. Its coverage table shows `smoke.py` at 94%: `main`, lines 102 to 122, which no unit test reaches.

$ just test
$ just test -m system

**I. Hermetic, by experiment.** `just image shell` with `--network none`: extra words go to docker, and this container has no network at all.

$ just image shell --network none

`just check`: green, 25 s, as with the network. Everything the hook runs is hermetic.

$ just check

The system test passes too, 29 s on the CPU: not because it is hermetic, but because the model is in the mounted cache.

$ just test -m system

Point the cache at an empty folder and it fails, in 48 s: "We couldn't connect to 'https://huggingface.co' to load the files, and couldn't find them in the cached files."

$ HF_HOME=/tmp/empty just test -m system
$ exit

**A test is anything that can fail and stop you.** The table lists what is checked, how, with which recipe, and whether it runs on every commit: the functions, the mask and the model with pytest, hypothesis and the tiny model, `just test`; types with ty, `just types`; documentation, `just docs check`; format and lint with ruff; the config files and the Dockerfile with yamllint, validate-pyproject, uv and hadolint, `just lint-config`; all of these on every commit. The real model from the Hub, the smoke marked `system`, `just test -m system`, does not run on every commit: it is not hermetic. More generally, a test is anything that can fail and stop a commit. Most of these are not pytest. All of them are `just`.

**You may even call it a gate.** The distracted girlfriend: the agent looks back at the gate, and the general test, her boyfriend, watches. A widely shared stock photo, labelled by us; the template is on imgflip, imgflip.com/memetemplate/118429510. The file is `slides/pictures/memes/distracted-agent-gate.jpg`.

**J. If there is time: amd64.** This Mac is arm64; most platforms and CI runners are amd64. `--platform linux/amd64` goes through to `docker build`: 33 s, under Rosetta. `docker image inspect` says `linux/amd64`. The smoke runs, with a warning that the image's platform is not the host's: 4 of 15 again, 10.4 s a request, three and a half times slower than native.

$ just image build run --platform linux/amd64
$ docker image inspect babykev-run:$(git rev-parse --short HEAD) --format '{{.Os}}/{{.Architecture}}'
$ just image run smoke

**K. The site, published.** So far the site was a folder on this machine, `docs/_site/`. `just --show docs`: one more word, `publish`. It checks that the remote `origin` exists and is on GitHub, and says so and stops if not; then `quarto publish gh-pages docs` renders the site and pushes it to the `gh-pages` branch, which GitHub Pages serves. Once, in the repository's settings, Pages is set to deploy from that branch.

$ just --show docs
$ just docs publish

**What the next step does.** This is the end of the first lecture. Running on the platforms is a different class.
