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
- **A move throws away edits.** The kit starts timewalk with `--discard-edits`, so a move to another step
  throws away your edits in `worktree/`.

## The environment at each step

The step browser moves the files from tag to tag. It does not move `.venv`: there is one environment in the
replay copy, and it holds whatever the last sync put there. So **`just setup` is the first command of every
step.** It brings `.venv` to the step's lockfile exactly, adding what the step added and removing what it
removed, and prints the difference, which is itself part of the story ("this step brought pytest"). Each
step's section below starts with an **Init** line saying what `just setup` changes there.

Two things to know. First, `uv run`, behind every recipe that runs the program or a tool, syncs the
environment by itself before running, so a forgotten `just setup` breaks nothing; it only hides the change
inside the first command's output. Second, the limitation: the environment cannot be in two states. Going
back to an earlier step without `just setup` leaves the later packages in place. They do no harm, but they
are not what that step had. There is no rewinding this; `just setup` at the step is the only remedy, and it
is instant from the cache. Before class, run `just setup` once at every tag, so every package is in uv's
cache and no step waits on a download (the model step brings torch).

## step-00 Where we start

**Init.** The environment is made by uv, before any recipe. `uv sync --locked` reads `pyproject.toml` and `uv.lock` and makes `.venv` with exactly what the lockfile says: Python 3.13 from `.python-version`, and babykev alone, editable. It prints `Resolved 1 package` and what it installed (or `Checked 1 package` when the venv already matches). `--locked` means: refuse if the lockfile is out of date with `pyproject.toml`, never re-lock on the quiet.

$ uv sync --locked

**The recipe.** `just --show setup` prints the recipe behind the word: one line, `uv sync --locked`, inside an `if` that answers `help`. That is the whole trick of the justfile: a verb on the left, the command on the right, and `just` lists the verbs. `just setup` runs it again and prints `Checked 1 package`: nothing to do, because it was just done. From now on, `just setup`.

$ just --show setup
$ just setup

**What is here.** A README, the licence and its notice, `pyproject.toml` with no dependencies, a justfile with `setup` and `help`, and a `babykev` command whose only word is `help`. No code of kev's yet. kev's code comes in one file at a time, at the step that needs it, and we rebuild each file as it arrives.

**The justfile is the interface.** `just` lists every task; `just help VERB` or `just VERB help` explains one; a recipe wraps one command.

$ just
$ just help setup

**The command.** `babykev help` prints the help; any other word is refused with exit code 2. The two lines under `[project.scripts]` in `pyproject.toml` are what make `babykev` a command: a name on the left, a function on the right.

$ uv run babykev help
$ uv run babykev train
$ cat pyproject.toml

**`.gitignore`** is complete from the first commit: nothing a run writes will ever show up as a stray file.

## step-01 The contract, and its tests

**Init.** `just setup` adds 13 packages: pydantic and pydantic-core, pytest, pytest-cov and coverage, and their dependencies. `.venv` goes from 1 package to 14.

$ just setup

**What arrives:** `src/babykev/api.py`, kev's file as it was, less its serving parts (the request's `model` field, `output_tokens`); five labelled requests in `data/cheese/sample.jsonl`; `tests/unit/test_api.py` and `test_cli.py`; pydantic, pytest and pytest-cov; the `test` recipe.

**Start from the data.** One line is a request about a cheese, with a `label` on every question. The five lines are a fixture, not the students' data; that comes with training.

$ head -n 1 data/cheese/sample.jsonl | python3 -m json.tool

**The contract.** `api.py` is what that line must fit. Pydantic models, not a server. Three question types; each becomes a list of options; the probabilities become an answer of the question's type. It is a first draft, as kev wrote it: lines 185 characters long, one-line `if`s, three docstrings, no types. It arrived like this on purpose; the next steps make it good. The `awk` line prints the length of the longest line.

$ awk '{ if (length > m) m = length } END { print m }' src/babykev/api.py
$ just
$ just help test

**The tests.** `uv run pytest` runs them. `uv run` runs a command inside `.venv`, syncing it first if it has to; `pytest` reads `[tool.pytest.ini_options]` in `pyproject.toml`, looks under `tests/`, and runs every function whose name starts with `test_`. The first lines say so: `configfile: pyproject.toml`, `testpaths: tests`, `plugins: cov-7.1.0`. 52 runs, two fail, and the tests are right. A guess over three score levels gets confidence 0.5, not 0. Rounding to two decimals makes 77 equal options sum to 0.77. Two real bugs in code that works (`sundry/the-two-bugs.md`). Under the summary, the coverage table: every statement of `api.py` and `cli.py` is touched. From now on the table says which lines are not. The `grep` line shows where the table comes from: `addopts` in `pyproject.toml` adds `--cov=babykev --cov-report=term-missing` to every run, so nobody has to remember the flags.

$ uv run pytest
$ grep -n -B1 addopts pyproject.toml

**The recipe.** `just --show test` prints the recipe: `uv run pytest` plus whatever words follow `just test`. So `just test` is the command above, and `just test -k name` is `uv run pytest -k name`.

$ just --show test

**Four tests to read with the students.** The file is worth a sentence first: every test has a name that reads as a sentence and a docstring that states the rule, and the file is in sections, `# Validation`, `# Rendering`, `# From a request to a record`, `# From probabilities to answers`, `# Confidence`. Then four tests, two small and two with weight. For each, the `sed` line prints it and the `just test -k` line runs it alone.

**Test 1, small: a request must ask at least one question** (lines 81 to 86). Three lines. `pytest.raises` says "this must fail". The contract refuses bad input, and the test pins the rule so nobody loosens it by accident. One passed.

$ sed -n '81,86p' tests/unit/test_api.py
$ just test -k without_questions

**Test 2, small: the limit on options is exact** (lines 105 to 114). 255 options are accepted, 256 are refused. The classic boundary test: the bug that is off by one lives exactly here, so the test stands exactly here. One passed.

$ sed -n '105,114p' tests/unit/test_api.py
$ just test -k largest_number

**Test 3, weighty: every line of the sample data fits the contract** (lines 47 to 56). `@pytest.mark.parametrize` turns one function into five tests, one per line of the data. It is a test of the data against the code: every line validates, every question becomes one record question, every question has at least two options. When the real data arrives at training, this is the test that grows. Five passed.

$ sed -n '47,56p' tests/unit/test_api.py
$ just test -k sample_line_fits

**Test 4, weighty: rounded probabilities still sum to one** (lines 250 to 258). A property, not a value: whatever the probabilities are, they must sum to 1. And the extreme case: 77 options, not three. `pytest.approx(1, abs=0.02)` is how a float is compared. This one fails here, 0.77, and it is the proof that code that "works" had a bug. One failed.

$ sed -n '250,258p' tests/unit/test_api.py
$ just test -k rounded_probabilities

**A subset.** Eight tests run; the coverage drops to 49%, because the table is about the tests that ran. The number that matters is the whole suite's.

$ just test -k confidence

**Optional live break.** The `sed` line changes the noul option `"no"` to `"NO"` in `api.py`, and `just test` then fails four. Nothing to put back: the move to the next step drops the edit. (Changing `MAX_OPTIONS` breaks nothing: the test imports the constant.)

$ sed -i '' 's/option_text("no", c.get("false"))/option_text("NO", c.get("false"))/' src/babykev/api.py && just test

## step-02 Format and lint arrive

**Init.** `just setup` adds one package, ruff. `.venv`: 15 packages. (Coming from step-00 instead of step-01, it adds 14.)

$ just setup

**What arrives:** ruff; `[tool.ruff]` in `pyproject.toml` with the formatter's settings and the lint rules, a comment on each; the `fmt` and `lint` recipes; the two fixes (`score_confidence` is 0 for a guess, `round_prob` rounds to four decimals; `sundry/the-two-bugs.md` explains both); `UV_LOCKED` exported from the justfile. `api.py` is still as it arrived. This step brings the tools and we run them here; the next commit holds what they leave behind.

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

`just --show fmt` prints the recipe: `uv run ruff format` plus whatever words follow `just fmt`. So `just fmt --check` is the command above, and `just fmt` alone is `uv run ruff format`, which rewrites the files.

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

`just --show lint` prints the recipe: `uv run ruff check` plus the words after `just lint`. From now on, `just lint`. Without `--statistics` it prints each finding with its line, a caret under the place, and a help text. Every code we have met, what it means, why it matters and what fixed it: `sundry/lint-codes.md`.

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

**The new line.** That last line came from a second command in the recipe. `uv run pre-commit install` is pre-commit, a tool that runs the hooks listed in `.pre-commit-config.yaml` at every commit; `install` writes the script `.git/hooks/pre-commit` that git runs, and prints where it put it. `just --show setup` shows the recipe grew from one command to two, joined by `&&`.

$ uv run pre-commit install
$ just --show setup

**What arrives:** the result of step 02's live run (`api.py` formatted, the import order, `strict=False` on the two `zip`s, `-> None` on thirty tests) and everything a person had to do after it: a one-line docstring on each of the four classes, the three functions and the package; the two missing return types (`to_record`, `_check -> Self`); `Union` written `|`; `K` and `L` renamed `k` and `n`; types on every test argument; the test for the one-level score. Then `just lint-config`, `just check`, and the git hook.

**A. What a person did.** Files tab, `api.py`, "Changes in this step". Point at a class docstring ("A yes-or-no question."), at `-> Self`, at `k`. Then the tests: `monkeypatch: pytest.MonkeyPatch`, `capsys: pytest.CaptureFixture[str]`, and the new test `test_score_confidence_of_a_single_level_is_one`.

**B. Green.** `just lint`: "All checks passed!". 79 findings at step 02's commit, 36 after the live fixes, 0 now. `just test`: 53 passed, and the `Missing` column is empty.

$ just lint
$ just test

One test is new, and it is the answer to step 02's uncovered line. The `sed` line prints it, lines 282 to 284: three lines, a name that states the rule and a docstring that says why. `just test -k single_level`: 1 passed.

$ sed -n '282,284p' tests/unit/test_api.py
$ just test -k single_level

**C. `just check`.** `just --show check` prints the recipe: a small shell script, four lines after the `help` line, each a recipe already seen: `just fmt --check`, `just lint`, `just test -q --cov-fail-under=90`, `just lint-config`. The two flags are pytest's: `-q` for a short report, `--cov-fail-under=90` for a floor on the coverage.

$ just --show check

`just check` runs the four, one after another: `ruff format --check` ("6 files already formatted"), `ruff check` ("All checks passed!"), the tests with the floor ("Required test coverage of 90% reached. Total coverage: 100.00%"), and `lint-config` ("Valid file: pyproject.toml"; the lockfile and the justfile say nothing when they pass). 1.9 seconds.

$ just check

**D. The floor, failing.** With only the nine confidence tests selected: "FAIL Required test coverage of 90% not reached. Total coverage: 49.40%".

$ just test -k confidence --cov-fail-under=90

**E. Config files are checked too.** Four tools, one per kind of file, each run by hand first. `uv run yamllint --strict .` checks every YAML file in the repository against `.yamllint` (its settings: lines of at most 100, no need for the `---` line) and prints nothing when all is well. `uv run validate-pyproject pyproject.toml` checks the project file against its schema and prints `Valid file: pyproject.toml`.

$ uv run yamllint --strict .
$ uv run validate-pyproject pyproject.toml

`uv lock --check` says whether the lockfile still matches `pyproject.toml`; it prints `Resolved 29 packages` and nothing more when it does. `just --fmt --check --unstable` is just's own formatter checking the justfile; silent when it is clean.

$ uv lock --check
$ just --fmt --check --unstable

`just --show lint-config` shows the four in one recipe, a script like `check`. From now on, `just lint-config`.

$ just --show lint-config

Now a break. The `sed` line indents the `args:` line of `.pre-commit-config.yaml` two spaces too far. `just lint-config` then fails, and yamllint says `10:15 error syntax error: mapping values are not allowed here (syntax)`, line and column. The `git restore` line puts the file back.

$ sed -i '' 's/^        args: \[--maxkb=1000\]$/          args: [--maxkb=1000]/' .pre-commit-config.yaml
$ just lint-config
$ git restore .pre-commit-config.yaml

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

**What arrives:** a command, `babykev docs`, in `src/babykev/docs.py`, that reads the code and prints plain Markdown; `docs/` with the Quarto site (`_quarto.yml`, `index.qmd`, `apidocs.py`, `linkify.lua`); one recipe, `docs`; tests of the command. This commit is dirty on purpose: `docs.py` is documented with docments, nothing else is, and `docs check` is red. Step 04b fills the gaps.

**A. The recipe.** `just` shows a new group, `docs`, with one recipe. `just help docs` prints the recipe's line and then the program's usage: three words, `list`, `module NAME`, `check`.

$ just
$ just help docs

**B. What the code says about itself.** `uv run babykev docs list` is the program's own command, run the way any command in the venv is run. It prints 41 lines: every module, class and function of the package, its kind, its full name, and the first line of its docstring. `babykev.api` has 4 classes and 7 functions; `babykev.docs` has 1 class and 25 functions. 0.4 s.

$ uv run babykev docs list

`just --show docs` prints the recipe, a script with three branches: `help` explains; no words at all runs `uv run quarto render docs`, the site; any other words go to the program, `uv run babykev docs ...`. So `just docs list` is the command above.

$ just --show docs

**C. One module, as Markdown.** `just docs module api` prints `api.py` as Markdown: a heading per symbol, the signature as a line of Python, the docstring, and a table of the parameters with type, default and description. Every Description cell is empty, because nothing in `api.py` carries a docment yet. The types are written as the source writes them, `JSONContent` and not the seven-way union it stands for. Then `just docs module docs`: the same for `docs.py`, and every Description cell is filled. Scroll to `class Symbol`: five fields, five descriptions, each from the comment beside the field.

$ just docs module api
$ just docs module docs

**D. Where a description comes from.** The first `sed` line prints `line_of`, lines 108 to 112 of `docs.py`: one parameter per line, a comment two spaces after it, and the return's comment after the colon of the `def` line. That comment is a docment, and fastcore reads it. The second `sed` line prints the `Symbol` dataclass, lines 46 to 54: the same for a field.

$ sed -n '108,112p' src/babykev/docs.py
$ sed -n '46,54p' src/babykev/docs.py

**E. The gaps.** `just docs check` prints one line per module and per test file: `babykev.api 0 of 12`, `babykev.cli 1 of 1`, `babykev.docs 26 of 26`, `test_api.py 23 of 29`, `test_cli.py 0 of 4`, `test_docs.py 0 of 16`; then every gap, one per line, 84 of them: 62 parameters with no docment, 10 returns with no docment, 11 pydantic fields with no description, 1 method with no docstring (`Choice._check`); then `50 of 88 functions, methods and classes are typed and documented`, and exit 1. 0.6 s.

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

The `sed` line shows what `apidocs.py` added to the program's Markdown for `api`: the front matter, `{#Noul}` on the heading, the `[source]` link.

$ sed -n '1,12p' docs/api/api.qmd

**H. Do docments hurt the formatter and the linter?** No, with one rule: the line must fit in 100 characters. The `perl` line makes the return docment of `line_of` 102 characters long. `just lint` then reports `E501 Line too long (102 > 100)` on line 110, and exits 1.

$ perl -pi -e 's/^\) -> int:  # The line its definition starts on$/) -> int:  # The line its definition starts on, counted from one as every editor does, never from zero/' src/babykev/docs.py
$ just lint

`just fmt --diff` shows what the formatter would do: wrap the return type, `) -> (` then `int` then `):  # The line its...`, so the comment lands two lines below the annotation. `just fmt` does it: `1 file reformatted`.

$ just fmt --diff
$ just fmt

`just lint` is now green: every line fits.

$ just lint

But `just docs check` says `babykev.docs 25 of 26` and `babykev.docs:line_of: no return docment`: fastcore reads the comment on the line of the annotation, and the annotation moved.

$ just docs check

**I. Still green.** `just check` passes: 9 files formatted, lint clean, 69 tests, coverage 97.78%, the config files valid. 2.3 s. Seven lines of `docs.py` are reached by no test, and the coverage table names them (75, 192, 201, 205, 208, 221, 248): the `ImportError` of `file_modules`; in `type_text`, a forward reference written as a string, a generic such as `list[float]` (the real package has them, the test package does not), `...`, and the fallback `repr`; in `signature`, the keyword-only star; in `table`, the empty table of a function with nothing to list.

$ just check

**What the next step does.** The move to 04b drops the edit of section H. Step 04b fills the 84 gaps: the docments on `api.py`, `cli.py` and the tests, the descriptions on the model fields, and `docs check` into `check`.

## step-04b Every function documented

**Init.** `just setup` changes nothing in `.venv`: no dependency arrived. It prints `Checked 29 packages` and reinstalls the hook. 0.4 s.

$ just setup

**What arrives:** the 84 gaps of step 04, filled. A docment beside each of the 17 parameters and returns of `api.py`, a description on each of its 11 model fields, a docstring on the validator; a docment on each of the 54 parameters and returns of the tests. And one line in the justfile: `just docs check` inside `just check`. This commit is clean. Everything is green, and the live part deletes one docment to show the check, and then the hook, catching it.

**A. Green.** `just docs check` prints `12 of 12` for `api`, then `1 of 1`, `26 of 26`, `29 of 29`, `4 of 4`, `16 of 16`, no gap, and `88 of 88 functions, methods and classes are typed and documented`, exit 0. 0.6 s, or 1.5 s the first time after a move, while Python compiles the files.

$ just docs check

**B. What a documented function looks like.** The `sed` line prints `render`, lines 68 to 72 of `api.py`: each parameter on its own line with its docment, the return's docment after the colon, the docstring below.

$ sed -n '68,72p' src/babykev/api.py

**C. A model field's description.** The `sed` line prints `Noul`, lines 16 to 24. A pydantic model has no signature to put a comment on, so each field carries `Field(description=...)`, and `docs check` reads that the way it reads a docment. The `state` field of `SystemOneRequest` says "The context: the document the questions are about".

$ sed -n '16,24p' src/babykev/api.py

**D. The Markdown, filled.** `just docs module api` prints the same table as at step 04, every Description cell now filled. Scroll to `render`: "Text, a number, a list or an object, from a request", "How deeply nested this value is; each level indents by two spaces", "The text the model sees".

$ just docs module api

**E. The site, filled.** `just docs` builds the site again, 5 s. The `open` line shows `api`'s page with every description in place.

$ just docs
$ open docs/_site/index.html

**F. Delete one docment.** The `sed` line removes the comment beside `indent` in `render`. `just docs check` then prints `babykev.api 11 of 12`, one gap, `babykev.api:render(indent): no docment`, `87 of 88`, exit 1. 0.6 s.

$ sed -i '' 's|,  # How deeply nested.*|,|' src/babykev/api.py
$ just docs check
$ git restore src/babykev/api.py

**G. The hook refuses it.** The same `sed` line again, then a commit. The hook prints its four hooks: three `Passed` or `Skipped`, then `just check...Failed`, and under it everything `check` ran: the formatter (9 files), the linter (All checks passed!), the tests (69 passed, 97.78%), and then `docs check`'s table ending `babykev.api:render(indent): no docment`, `87 of 88`. 3.3 s. No commit was made: `git status` shows the file still modified, and the log still ends at this step.

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

**What arrives:** `src/babykev/model.py`, kev's model, typed, with a docment on every parameter and return and a docstring on everything; `src/babykev/smoke.py` and `babykev smoke`; a tiny model for the tests (`tests/tiny.py`, `tests/conftest.py`); `test_model.py` and `test_smoke.py`; two recipes, `smoke` and `types`. This commit is dirty on purpose, and nothing in it can tell: the mask lets a question see the questions before it (pretend it came that way from upstream), and two lines are written the way kev wrote them, which ty refuses. Every check we have is green. Step 05a brings what can see it.

**A. The four ideas.** The `sed` line prints the top of `model.py`, the module docstring, which names them. Packing: the context and every question into one sequence, marked off by five delimiter tokens. The mask: each token sees the context and its own question, never another. Positions restart after the context, so a question looks the same wherever it comes. Pointing: a head scores each option's closing token against the question's decide token; no text is generated.

$ sed -n '1,20p' src/babykev/model.py

**B. Packing, in the signature.** `encode`, lines 85 to 97: a tokenizer, a record as `to_record` returns it, two limits, and an `Encoded` back, each docment saying what the thing is. The last line printed looks up the five delimiter ids.

$ sed -n '85,97p' src/babykev/model.py

**C. Pointing.** `PointerHead`, lines 146 to 166: two linear layers and a scaled dot product. The docments carry the shapes: `[d]`, `[K, d]`, `[K]`.

$ sed -n '146,166p' src/babykev/model.py

**D. A model to test with.** `tests/tiny.py`: a tokenizer with one token per character, and a backbone of the base model's architecture with two layers and 32 dimensions, random weights, built in memory. `tests/conftest.py` hands them to every test as fixtures.

$ sed -n '1,8p' tests/tiny.py
$ sed -n '31,46p' tests/tiny.py

`tests/conftest.py` is where pytest looks for fixtures shared by every test file: the tiny tokenizer once for the whole run, a fresh tiny model for each test, and one record with three questions.

$ sed -n '1,12p' tests/conftest.py

**E. The tests.** `just test`: 92 passed, 23 of them new. The coverage table has two new rows: `model.py` 96% (the CUDA branch and the real-model loading path are not reached by a tiny model), `smoke.py` 71% (its `main` loads the real model). Total 94%, over the floor. The first run after a move takes about 30 seconds while Python compiles torch's modules; after that, about 7.

$ just test

`just test -k forge` runs the forgery tests alone: 6 passed. The `sed` line prints two of them: the first proves the danger is real (the text of a delimiter, tokenized plainly, becomes that delimiter), the second that `user_tokens` closes the door, for each of the five.

$ just test -k forge
$ sed -n '93,112p' tests/unit/test_model.py

Two more to read. `test_smoke.py`, lines 9 to 21: the smoke on the tiny model must report on every question of the sample, fifteen verdicts and a closing count. `just test -k smoke_reports`: 1 passed, and no model was downloaded for it.

$ sed -n '9,21p' tests/unit/test_smoke.py
$ just test -k smoke_reports

And the weighty one, `test_model.py` lines 155 to 178, what trains: one backward pass on the tiny model with an adapter, then every parameter that received a gradient is named, and all of them are the adapter's or the head's, and `trainable_parameters` lists exactly those. `just test -k only_the_adapter`: 1 passed.

$ sed -n '155,178p' tests/unit/test_model.py
$ just test -k only_the_adapter

**F. Documented, and checked.** `just docs check`: 139 of 139, every function, method and class in the package, the tests and `docs/apidocs.py`. `just check`: green, 15 seconds now that the model tests are in it.

$ just docs check
$ just check

**G. The smoke, as a command.** `uv run babykev smoke` is the program's new word. It loads the base model, Qwen2.5-0.5B, with a fresh adapter and an untrained pointer head, on the best device this machine has (`mps` here, Apple's GPU), and asks it the five sample requests. It prints the device, the load time (4 s), the parameter counts (503M, 9.3M of them trainable: the adapter and the head), then each answer beside its label, and the count: 6 of 15 right, 198 ms a request. 10 seconds in all. The first time on a machine, the download of the base model, about 1 GB.

$ uv run babykev smoke

`just --show smoke` prints the recipe: a script with three branches, `help`, `local` (the command above), and anything else refused with a message, because no other platform exists yet. From now on, `just smoke local`.

$ just --show smoke

**H. The type checker.** `uv run ty check` is ty. It reads every call in the project against what the called function declares, and prints what does not fit: 6 diagnostics, 3 seconds. Two are in `model.py`, and they are kev's lines. `load_tokenizer` promises a `PreTrainedTokenizerBase` and returns what `AutoTokenizer.from_pretrained` gives, which the library declares may be one of two backends or `None`. `encode` unpacks five ids from `tok.convert_tokens_to_ids`, which is declared to return an int or a list. The other four are the same unpacking, in the tests. The code runs, and every test passes.

$ uv run ty check

`just --show types` prints the recipe, `uv run ty check` plus any words after `just types`. From now on, `just types`.

$ just --show types
$ just types

`just --show check` shows what is not there: no `types` line. ty is not a gate yet; the hook let this commit in.

$ just --show check

**I. The question nobody asked.** The `git show` line brings one file forward from the next step's commit: `tests/unit/test_mask.py`, five tests of the mask's rule, three of them properties checked for hundreds of request shapes with hypothesis. `just test -k mask`: 3 failed, 2 passed. The two that pass check causality. The three that fail say what is wrong: `test_no_question_sees_another_question`, `test_every_token_sees_the_state_before_it_and_its_own_question`, and the picture test.

$ git show step-05a:tests/unit/test_mask.py > tests/unit/test_mask.py
$ just test -k mask

The `sed` line prints the first failing test, seven lines: for any shape of request, no token of one question may attend to a token of another.

$ sed -n '59,68p' tests/unit/test_mask.py

**What the next step does.** Step 05a brings the seven tests that see the mask, the one-line fix, the two guards ty asked for, `just types` into `check`, and two pages on the model.

## step-05a The tests that could tell

**Init.** `just setup` changes nothing in `.venv`: nothing new arrived. 0.5 s.

$ just setup

**What arrives:** seven tests: `tests/unit/test_mask.py`, the mask's rule as five properties, and four isolation tests in `test_model.py`; the fix, one line of `branch_mask`; the two guards ty asked for, `delimiter_ids` and a check in `load_tokenizer`; `just types` as a line of `check`; two pages of the docs site, `docs/guide/00_model.qmd` (the four ideas) and `docs/guide/01_mask.ipynb` (the mask as a grid, with the mask of step 05 beside it), and a test that re-runs the notebook. Clean: 103 tests, 154 of 154, green.

**A. The new tests.** `just test`: 103 passed. The `sed` line prints the first isolation test: rewrite one question, and the other two get exactly the logits they got before.

$ just test
$ sed -n '142,158p' tests/unit/test_model.py

And the smallest of the five mask tests, `test_mask.py` lines 28 to 40: two context tokens and two questions of two tokens each, and the mask drawn as six rows of `#` and `.`. The last two rows are the second question: it sees the two context tokens and itself, and the two columns of the first question are empty. `just test -k small_request`: 1 passed.

$ sed -n '28,40p' tests/unit/test_mask.py
$ just test -k small_request

**B. The mask as it was.** The `perl` line writes step 05's mask line back into `branch_mask`: a plain causal mask, every token sees everything before it. `just test`: 8 failed, 95 passed. Three of `test_mask.py` (the two about causality still pass), the four isolation tests, and the notebook test, because the grid the notebook stored no longer matches what the code prints. 23 seconds, because hypothesis shrinks each failing case to its smallest.

$ perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = torch.ones_like(causal) | (s[None, :] == 0)/' src/babykev/model.py
$ just test

**C. The hook refuses it.** `git commit -am "try"`: the four hooks; `just check` fails after `fmt --check`, `lint` and `types` pass, at the tests, with the same eight names. 12 seconds. No commit. The `git restore` line puts the fix back, because everything after this needs it.

$ git commit -am "try"
$ git restore src/babykev/model.py

**D. The fix, and the guards.** The first `sed` line prints the mask's body, lines 146 to 152, with the line as it should be: a token may attend to the context, or to its own question. The second prints lines 64 to 80: `load_tokenizer` checks what came back, and `delimiter_ids` turns an int into a list of one.

$ sed -n '146,152p' src/babykev/model.py
$ sed -n '64,80p' src/babykev/model.py

`just types`: All checks passed!

$ just types

**E. Types in the gate.** `just --show check`: six lines now, `types` between `lint` and the tests. `just check`: green, 17 seconds.

$ just --show check
$ just check

**F. The smoke again.** `just smoke local` on the right mask: 4 of 15 right, 242 ms a request. It was 6 at step 05, and several answers changed: the first cheese's milk went from buffalo to cow.

$ just smoke local

**G. The model, explained.** `just docs` renders eight pages now, with a Guide section. 11 seconds.

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

**What arrives:** a `Dockerfile` that builds two images from `uv.lock`, and a `.dockerignore`; the `image` recipe; hadolint as a line of `lint-config`; `tests/integration/test_real_model.py`, the smoke on the real model, marked `integration` and left out of `just test`; a section of the README on Docker. Clean: 103 tests and 1 deselected, 155 of 155 documented, green.

**A. The run image, in the file.** The `sed` line prints lines 11 to 39 of the `Dockerfile`. Line 12 takes uv from its own image. Lines 16 to 28 are a build stage: the packages from the lockfile first (line 25), then the code (lines 27 and 28), so a change to the code reinstalls one package and not torch. Lines 31 to 39 are the run image: a fresh Python, the finished environment copied over from the build stage (line 32), the sample data, and `babykev` as the command it starts. No uv, no just, no dev tools.

$ sed -n '11,39p' Dockerfile

**B. Build it, run it.** `docker build --target run` builds that image and names it `babykev-run`: 20 s with the cache warm. `docker run --rm babykev-run` starts it with no words, which runs line 39's default, `babykev help`, and removes the container when it exits.

$ docker build --target run --tag babykev-run .
$ docker run --rm babykev-run

`docker image ls` with a format prints the name and the size: 1.15 GB, nearly all of it torch.

$ docker image ls babykev-run --format '{{.Repository}}:{{.Tag}}  {{.Size}}'

**C. The smoke on Linux.** The same smoke, in the image. The `-v` mounts this Mac's Hugging Face cache at `/hf`, where line 36 tells the image to look, so the 953 MB model is not downloaded again. It says `on cpu`: a container on a Mac is Linux in a virtual machine, and sees no Apple GPU. 4 of 15 right, 2.9 s a request, 33 s in all. On the Mac (05a) it was 362 ms a request on `mps`, and the fifteen answers are identical, line for line, to the two decimals printed.

$ docker run --rm -v ~/.cache/huggingface:/hf babykev-run smoke

**D. The dev image.** Lines 41 to 77: the image to work in. Debian packages for git and curl (lines 49 to 51), Quarto from its release (lines 53 to 56), uv (line 57), just from PyPI (line 68), and then the whole project with its dev group (lines 71 to 74). The environment is in `/opt/venv` (line 58), outside the project folder. Line 76 declares the port the step browser uses. It starts a shell.

$ sed -n '41,77p' Dockerfile

`docker build --target dev`: 2 s with the cache warm; 61 s cold. 1.84 GB: the dev tools, Quarto and git on top of the run image's 1.15.

$ docker build --target dev --tag babykev-dev .

**E. Working inside it.** `docker run -it` gives a terminal in the container; `-v "$PWD":/work` mounts this folder as the project, so an edit here is seen in there at once. The prompt changes: we are in Linux, in `/work`.

$ docker run --rm -it -v "$PWD":/work babykev-dev

`which` shows where each tool is: Python from `/opt/venv`, just, Quarto and uv from `/usr/local/bin`. This folder's own `.venv` is the Mac's, and nothing in the container looks at it.

$ which python just quarto uv

`just check`, inside: the same lines as on the Mac, and green. 103 passed, 1 deselected, 155 of 155. 24 s.

$ just check
$ exit

**F. The recipe.** `just --show image`: one recipe, three words. `build dev|run` runs the `docker build` of B or D and names the image by the commit, so the image always says which code it holds; `shell` is E's `docker run`; `run WORDS` is C's. On a machine with no Docker, and inside the image, it says so instead of failing.

$ just --show image

From now on `just image`. Both builds are instant from the cache, and `docker image ls` shows each image under two names: `latest`, from B and D, and the commit's short hash.

$ just image build dev
$ just image build run

$ docker image ls 'babykev-*' --format '{{.Repository}}:{{.Tag}}  {{.Size}}'

`just image shell` starts a new container every time, and `exit` deletes it: whatever was installed or run in there is gone, and only the mounted folder keeps what changed. To keep one, `just image start` leaves a container named `babykev-dev` running in the background; `just image shell` then goes into that one (`docker exec`), and a second `just image start` refuses. Both publish the dev image's port 8765, the step browser's, on the first free port here from 8765 up, and print the address: in the rehearsal `http://localhost:8766`, because the step browser on this Mac holds 8765. `docker ps` shows it running, with the port. `just test` inside: 103 passed, 1 deselected. `just image stop` removes it.

$ just image start
$ docker ps --filter name=babykev-dev --format '{{.Names}}  {{.Image}}  {{.Status}}  {{.Ports}}'

$ just image shell
$ just test
$ exit

$ just image stop

**G. hadolint.** A linter for Dockerfiles. `uv run hadolint Dockerfile` says nothing: clean.

$ uv run hadolint Dockerfile

Lines 46 to 48 say why: hadolint's rule DL3008 asks for a pinned version of every Debian package, and we declined it, with the reason beside the line. The `perl` line deletes the ignore, line 48; hadolint then names the rule at the `RUN` line. A pinned Debian version is removed from the archive at its next security fix, and the build breaks within weeks; the base image's tag is the pin. The `git restore` line puts the ignore back, because the next command checks the file.

$ sed -n '46,48p' Dockerfile
$ perl -ni -e 'print unless /^# hadolint ignore=DL3008$/' Dockerfile
$ uv run hadolint Dockerfile
$ git restore Dockerfile

`just --show lint-config`: hadolint is the second line. `just lint-config`: green, 1.5 s. So the hook runs it on every commit.

$ just --show lint-config
$ just lint-config

**H. The test that is not hermetic.** `pyproject.toml` lines 53 to 57: pytest now leaves out every test marked `integration` (line 56), and line 57 declares the marker.

$ sed -n '53,57p' pyproject.toml

The test, `tests/integration/test_real_model.py`: the docstring says why it is apart, line 14 marks every test in the file, and the test runs the smoke's `main` and asserts what holds on any device: exit code 0, fifteen verdicts, and a count of them. Not the score: an untrained model guesses.

$ sed -n '1,27p' tests/integration/test_real_model.py

`just test`: 103 passed, 1 deselected. `just test -m integration`: 1 passed, 103 deselected, 19 s on the Mac's GPU. Its coverage table shows `smoke.py` at 94%: `main`, lines 102 to 122, which no unit test reaches.

$ just test
$ just test -m integration

**I. Hermetic, by experiment.** `just image shell` with `--network none`: extra words go to docker, and this container has no network at all.

$ just image shell --network none

`just check`: green, 25 s, as with the network. Everything the hook runs is hermetic.

$ just check

The integration test passes too, 29 s on the CPU: not because it is hermetic, but because the model is in the mounted cache.

$ just test -m integration

Point the cache at an empty folder and it fails, in 48 s: "We couldn't connect to 'https://huggingface.co' to load the files, and couldn't find them in the cached files."

$ HF_HOME=/tmp/empty just test -m integration
$ exit

**J. If there is time: amd64.** This Mac is arm64; most platforms and CI runners are amd64. `--platform linux/amd64` goes through to `docker build`: 33 s, under Rosetta. `docker image inspect` says `linux/amd64`. The smoke runs, with a warning that the image's platform is not the host's: 4 of 15 again, 10.4 s a request, three and a half times slower than native.

$ just image build run --platform linux/amd64
$ docker image inspect babykev-run:$(git rev-parse --short HEAD) --format '{{.Os}}/{{.Architecture}}'
$ just image run smoke

**K. The site, published.** So far the site was a folder on this machine, `docs/_site/`. `just --show docs`: one more word, `publish`. It checks that the remote `origin` exists and is on GitHub, and says so and stops if not; then `quarto publish gh-pages docs` renders the site and pushes it to the `gh-pages` branch, which GitHub Pages serves. Once, in the repository's settings, Pages is set to deploy from that branch.

$ just --show docs
$ just docs publish

**What the next step does.** This is the end of the first lecture. Running on the platforms is a different class.
