We follow the `justfile` of babykev, a small decision model. The program `just` reads this file. The file gives
each task of the project a short name, a verb, such as `just test`. The commands behind a verb are its recipe.

A person, a git hook, a Docker image and GitHub all run the same tasks. The recipes keep the commands in one place,
so each of them runs the same thing. `just` alone lists the verbs, `just help VERB` explains one, and
`just --show VERB` prints its recipe. This tutorial takes the recipes out of the whole tutorial of babykev, one at a
time, as each one comes in.

Most sections bring in a verb with three commands. First the tool's own command runs, then `just --show VERB` shows
the recipe, and then the verb runs.

We make the project in moves. A move is one small change, made by one patch or by one command. In watch mode, each
change is already made, and the text says what it did. In do mode, you make each move, and the page checks your
files against it.

Some changes of the whole tutorial are not in this one. After such a gap, the next section says what those changes
did, and begins from the code that they left. It first runs `just setup`, which installs the packages of that code.

**What `just check` runs**

`just check` runs every check that a `git commit` must pass, and stops at the first that fails. The table gives each
section that changes what it runs.

| Section | What `just check` runs from there on |
|---|---|
| `just check` and `just hook` | `just fmt --check`, `just lint` and `just test -q` |
| `just lint-config` | `just lint-config` too, last |
| The docs check joins `just check` | `just docs check` too, after the tests |
| `just types` | `just types` too, after the linter |
| The floor on the coverage | `just test -q --cov-fail-under=90` in place of `just test -q` |
| `just image` | `just lint-config` checks the `Dockerfile` too |
| GitHub runs `just check` | `just lint-config` checks the workflows too |

The project is managed by [uv](https://docs.astral.sh/uv/), which installs Python and the packages, keeps them in `.venv`, and pins their versions in `uv.lock`. `just setup` runs `uv sync`.

## The project, and its justfile

The project already has its words and its command. `uv init` made it a Python package, and `uv lock` wrote its lockfile
`uv.lock`. `src/babykev/cli.py` holds the command `babykev`, which so far prints only its help. There is no
justfile yet, so do not run `just` before the first move of this section.

The first recipe, `setup`, makes the environment of the project. The second, `help`, explains a verb.

{{include tut-01.9..tut-01.12}}

## `just test`

$ just setup

The README now says how to begin, and what each file is. A setting in `pyproject.toml`, `default-groups = "all"`,
makes uv install every dependency group. A dependency group is a named list of packages that only the people who
work on babykev need.

pytest comes into the group `test`, and the command that runs it gets a recipe.

{{include tut-02.2..tut-02.3}}

## `just fmt`

The whole tutorial then writes tests of the command, and measures the coverage on every run. It brings in the
contract of a request, `src/babykev/api.py`, with pydantic, and five requests about cheese as sample data. Then come
the tests of the contract, and the code that turns a request into text for the model. More code turns the answers of
the model back into JSON, and tests find two bugs in it, and the code gets their fixes. `just test` prints `53 passed`.

The code mixes styles. ruff comes in, and `just fmt` formats the code and the tests.

{{include tut-07}}

## `just lint`

$ just setup

A formatter changes how the code looks, and leaves a wrong line wrong. The rules of the linter go in
`pyproject.toml`, and `just lint` runs the linter.

{{include tut-08.1..tut-08.3}}

## The words after `just lint`

$ just setup

The code now has the fixes of four of the problems, made by hand. The docstring of `api.py` fits in 100 characters,
and `X | Y` takes the place of `Union`. `k` and `n` are in lower case, and each `zip` has `strict=True`.

Every word after `lint` goes to ruff, so `just lint --fix` runs `uv run ruff check --fix`.

{{include tut-08.8}}

## `just check` and `just hook`

The whole tutorial then turns on the rules `ANN` of ruff, which ask for a type on every parameter and return. A
person wrote the types that ruff cannot guess, and `just lint --fix --unsafe-fixes` wrote `-> None` on the other 31
functions. Then the rules `D1` asked for a docstring on every public name, and each came by hand.

A person must now remember three verbs before each `git commit`. One recipe runs them all, and a git hook runs that
recipe.

{{include tut-11}}

## `just lint-config`

The gate checks the Python of the project, and none of its other files. `just lint-config` checks the config files,
one checker at a time, and then joins `just check`.

{{include tut-12}}

## `just docs`

$ just setup

Nothing says which parts of the code have documentation. smalldocs comes in, and `just docs check` counts what has
documentation. The words after `docs` go to `smalldocs api`.

{{include tut-13.1..tut-13.3}}

## The docs check joins `just check`

$ just setup

The code now has its documentation. A docment is a comment beside a parameter or a return type. Every function of
`api.py` and of the tests has docments, and every field of a request has a description. One docment was too long on purpose,
`just fmt` wrapped its line, and a shorter docment took its place.

`just check` does not run the docs check yet. One line in `check` runs it.

{{include tut-13.12}}

## `just docs` alone builds the site

$ just setup

The reference is text in a terminal. The recipe `docs` changes. With no words, it builds a site. With words, it works
as before, so `just docs check` is the same command.

{{include tut-14.1..tut-14.2}}

## `just types`

The whole tutorial then gives the site its settings and a front page. It brings in torch, from the index of PyTorch's
builds for the CPU, and transformers, peft and safetensors. Then `src/babykev/model.py` comes in, the model, with no
tests of its own yet. So the total coverage falls to 43%. `just check` has no floor on the coverage, so it still
passes.

The linter asks only that each type be there. A type checker, ty, comes in, with a recipe `types`. Then the types join
`just check`.

{{include tut-17}}

## `just smoke`

$ just setup

The code now has `src/babykev/smoke.py`, a smoke run. It loads the real model on this machine, asks it the questions
of the sample data, and prints each answer beside its label. The command `babykev smoke` runs it. The first run
downloads the model from the Hugging Face Hub.

The smoke gets a recipe of its own, in a group `model`. `just check` does not run it.

{{include tut-18.7}}

## The floor on the coverage

$ just setup

The code now has a tiny model, built in memory, and fixtures of pytest that make it. Unit tests and integration tests
of the model and the smoke run on it. The total coverage is 91.76%.

`just check` gets a floor. `just test` alone keeps none.

{{include tut-21.4}}

## `just image`

The whole tutorial then finds a bug in the mask of the model with tests of hypothesis, and fixes it. It adds a test of
the real model, marked `system`. `-m 'not system'` in `pyproject.toml` leaves that test out of `just test`, and so out
of `just check` and the hook. `just test -m system` runs it. Then the docs get a guide to the model.

The fix of the mask changes the answers of the smoke. In this section, the smoke prints `4 of 15 right`, where `just
smoke` printed `6 of 15 right` above, with the old mask. The mask changed the answers, and not the device.

A `Dockerfile` comes in, with two images. The commands that build and run them get one recipe, `image`. hadolint
checks the `Dockerfile`, as a line of `just lint-config`. This section needs Docker.

{{include tut-25}}

## GitHub runs `just check`

The hook runs `just check` only in a clone where `just hook` ran. A workflow of GitHub runs `just setup` and
`just check` after every push, on a fresh machine. actionlint checks the workflows, as a line of `just lint-config`.

{{include tut-26}}

The workflow is the third caller of `just check`, after a person and the git hook. None of the three changed when
`check` changed, and each ran every new check. The workflow of the docs runs `smalldocs render docs` itself, and not
`just docs`. So a change to the recipe `docs` does not reach that workflow.

This tutorial ends here. The whole tutorial of babykev has every change.
