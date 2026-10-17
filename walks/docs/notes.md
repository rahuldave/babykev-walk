We document babykev, a small decision model. babykev reads a text and a set of questions about it, and gives a
probability for every answer. A person who reads the project on GitHub needs to know what it is, and where each part
is. A person who calls the code needs to know what each function does, and what each parameter means. A person who
wants to know why the model is built as it is needs a page of prose.

This tutorial takes the parts about documentation out of the
[whole tutorial](https://rahuldave.com/babykev-walk/) of babykev. It starts from the README, before any code. The
docstrings come when the code has tests and a linter. The rest of the documentation comes after them.

We make the project in moves. A move is one small change, made by one patch or by one command. A patch changes a
file, and a command such as `uv add` writes the files it needs. You make each move, and the page checks your files
against it.

This tutorial has seven sections:

1. **The README, before any code**
2. **The README says how to begin**
3. **Docstrings**
4. **Documentation in the code**
5. **The docs site**
6. **The guide to the model**
7. **The docs on GitHub Pages**

Some changes of the whole tutorial are not in this one. After such a gap, the next section says what those changes
did, and begins from the code that they left. It first runs `just setup`, which installs the packages of that code.

**Kinds of documentation**

The table gives each kind of documentation, and the sections where it appears.

| Kind | Who reads it, and what it says | Where |
|---|---|---|
| README | A reader on GitHub. What babykev is, how to begin, and where each part is | Sections 1, 2, 5, 6 and 7 |
| Docstring | What a module, a class or a function is for | Section 3 |
| Docment | What each parameter, field and return is | Section 4 |
| Docs check | Counts what is documented, and names each gap. From section 4, each `git commit` must pass it | Section 4 |
| Reference | A person who calls the code. smalldocs makes it from the docstrings and the docments | Sections 4 and 5 |
| A written page | What babykev is, on the front page of the site, and why the model is built as it is, in the guide | Sections 5 and 6 |
| A published site | The site, on GitHub Pages, built again after every push to `main` | Section 7 |

Two tools run everything here. [uv](https://docs.astral.sh/uv/) manages the project. It installs Python and the packages, keeps them in `.venv`, and pins their versions in `uv.lock`. [just](https://just.systems/) runs the tasks of the project by name, from the recipes of its `justfile`. `just setup`, for example, runs `uv sync`.

## The README, before any code

The first documentation of a project is its README. Here babykev is only words. There is the README, the licence, the
notice and `.gitignore`.

{{include tut-00}}

## The README says how to begin

$ just setup

The whole tutorial makes babykev a Python project before the README grows. uv is the tool that installs Python and
the packages that babykev needs. `uv init` makes `pyproject.toml`, the file that describes the project, and the folder
of the code, `src/babykev/`. `uv lock` writes `uv.lock`, the lockfile, which lists the exact version of each package.
`pyproject.toml` gets a description, a licence and an author.

`src/babykev/cli.py` gives the command `babykev` a help text, which says what babykev is and how to use it.
`uv run babykev help` prints it. A `justfile` names the tasks of the project, as recipes. `just setup` installs the project,
and `just help VERB` explains a recipe.

The description and the help are documentation too, for a person who installs babykev or runs it. The README now says
how to begin, and what each file is.

{{include tut-01.13..tut-01.14}}

## Docstrings

The whole tutorial then gives babykev its code and its checks. `src/babykev/api.py` is the contract, the rules for
what a request and an answer hold. Its class `SystemOneRequest` is a request, which holds a state and its questions.
The classes `Noul`, `Choice` and `Score` are the three types of question. A noul has the answer yes or no, a choice
picks one option, and a score picks a level on a scale.

The functions of `api.py`, from `render` to `to_answers`, turn a request into the text that the model reads. They
also turn the probabilities of the model into answers. The tests are in `tests/unit/`, and `just test` runs them with
pytest. Each run also measures coverage, the share of the lines of the code that the tests run.

ruff formats the code, through `just fmt`, and lints it, through `just lint`. To lint is to check the code against a
list of rules. The families of rules are in the list `select` of `pyproject.toml`. The last of them, `ANN`, asks for a
type on every parameter and every return. The README names each new file in its table.

{{include tut-10}}

## Documentation in the code

The whole tutorial then adds a gate. `just check` runs every check, one after another, and stops at the first that
fails. `just hook` installs a git hook, a script that git runs before each `git commit`, and the hook runs
`just check`. `just lint-config` checks the config files, `pyproject.toml`, the lockfile, the `justfile` and every
YAML file, and the gate runs it too.

{{include tut-13}}

## The docs site

So far, `just docs module api` prints the reference of `api.py` as text in the terminal. This section builds a
website from it, with a front page written by hand.

{{include tut-14}}

## The guide to the model

The whole tutorial then builds the model, and tests it. The project adds four packages for the model, torch,
transformers, peft and safetensors. `src/babykev/model.py` holds the model. ty checks the types, through
`just types`. `src/babykev/smoke.py` runs the real model on the sample data, through `just smoke`.

The model reads text as tokens, which are small pieces of words. `encode` packs the state and its questions into one
sequence of tokens. `branch_mask` builds the mask, a table that says which tokens the model may look at while it
reads each token.

The tests of the model run on a tiny model, in `tests/tiny.py`. `tests/conftest.py` holds the fixtures, the objects
that a test gets ready-made, such as the tiny model and a record. The gate asks
the tests to run at least 90% of the code. `tests/unit/test_mask.py` draws the mask of a small request as a picture.
It found a bug in the mask, which is now fixed. A test of the real model is marked `system`, and `just test` leaves
it out.

The site now has a page of reference for each of `api.py`, `cli.py`, `model.py` and `smoke.py`. The front
page and the README name the model and the smoke.

{{include tut-24}}

## The docs on GitHub Pages

$ just setup

The whole tutorial then adds a `Dockerfile`, which builds two images. An image of Docker is a Linux machine that one
file describes. The run image starts `babykev`, and the dev image holds the whole project and the tools to work on
it. The recipe `just image` builds them, and `just lint-config` now runs hadolint, a linter of the `Dockerfile`.

The site is only on the machine that builds it. GitHub runs workflows on its own machines. A workflow is a file of
YAML in `.github/workflows/`, and its key `on` names the events that start it. The first workflow, `check.yaml`, runs
`just setup` and `just check` after every push. yamllint refused the key `on`, because YAML 1.1 reads the word `on`
as the value true. Its settings now let a key be such a word.

The project adds actionlint, a linter of the workflows of GitHub, to its other linters, and `just lint-config` runs
it. The second workflow builds the site and publishes it.

{{include tut-26.5..tut-26.6}}

This tutorial ends here. The [whole tutorial](https://rahuldave.com/babykev-walk/) has every change.
