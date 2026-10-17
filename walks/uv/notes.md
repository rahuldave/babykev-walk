We follow the dependencies of babykev, a small decision model. It reads a text and a set of questions about it,
and gives a probability for every answer.

uv installs Python and the packages of the project, and writes their exact versions into one lockfile, `uv.lock`.
The packages come in groups. babykev needs some of them to run. The tests and the checks need the others. This
tutorial takes these parts out of the whole tutorial of babykev, and ends with the two Docker images, which install
different groups.

We make the project in moves. A move is one small change, made by one patch or by one command. A command such as
`uv add` changes the files of the project itself, so its move needs no patch.

Some changes of the whole tutorial are not in this one. After such a gap, the next section says what those changes
did, and begins from the code that they left. It first runs `just setup`, which installs the packages of that code.

The tasks of the project run through [just](https://just.systems/), which runs a command by name from the recipes of the `justfile`. `just setup`, for example, runs `uv sync`.

## The project, and its lockfile

The folder has a README, a licence and `.gitignore`, and nothing that Python can build or run. `uv init` makes the
project, and `uv lock` writes its lockfile. There is no justfile yet, so these two sections run no `just`.

{{include tut-01.1..tut-01.2}}

## The settings of the project

`pyproject.toml` still has the words of uv. Three settings say what babykev is, under which licence others may use
it, and who wrote it. None of them is a dependency, so the lockfile stays as it was.

{{include tut-01.3..tut-01.5}}

## Every group, and the group test

$ just setup

The whole tutorial then writes the command `babykev`, in `src/babykev/cli.py`, and a justfile with the recipe
`setup`. `just setup` runs `uv sync --locked`. The tests of the command need pytest, and a user of babykev does not.
So pytest goes into a dependency group, `test`, and a recipe runs it.

{{include tut-02.1..tut-02.3}}

## The first dependency, pydantic

$ just setup

The whole tutorial then adds five tests of the command. pytest-cov, which measures which
lines the tests run, joins pytest in the group `test`. babykev itself needs pydantic to run, so it goes into the
dependencies of the project, and into no group.

{{include tut-03.1}}

## A second group, for the checks

$ just setup

The whole tutorial then brings in the contract, `api.py`, which says what a request and an answer are. Then come its
tests, the code that turns the probabilities of the model into answers, and the fixes of two bugs in it. ruff
formats the code and checks it, and a user of babykev does not need it. So ruff starts a second group, `lint`.

{{include tut-07.1}}

## The packages of the model

$ just setup

The whole tutorial then sets up ruff, fixes the code with it, and adds types and docstrings. pre-commit,
validate-pyproject and yamllint, more tools for the checks, join the group `lint`. smalldocs, which builds the site
of the docs, starts a third group, `docs`. `default-groups = "all"` makes `just setup` install each of them, with no
other change.

The model needs four packages, and they are dependencies of the project. torch comes first, from an index of its
own.

{{include tut-15.1..tut-15.7}}

## The run image installs no group

$ just setup

The whole tutorial then writes the model, and its tests. ty, which checks the types, joins the group `lint`.
hypothesis, which draws many inputs for one test, joins the group `test`. The run image is babykev as a user runs
it. It needs the dependencies of the project, and no group.

{{include tut-25.1}}

The stage `build` runs `uv sync --locked --no-default-groups`. `--no-default-groups` overrides
`default-groups = "all"`, so `/opt/venv` gets the dependencies of the project, and no group.

## The dev image installs every group

$ just setup

The dev image is for working on the project, so it installs every group. Its build runs `uv sync --locked`, with no
`--no-default-groups`, and `default-groups = "all"` holds.

{{include tut-25.2..tut-25.3}}

## An image holds the lockfile of its build

$ just setup

The whole tutorial then turns off the time limit of hypothesis, and adds the recipe `just image`. `just image build
dev` builds the dev image, and `just image shell` runs a command in it, with this folder at `/work`. hadolint, a
linter for the `Dockerfile`, joins the group `lint`. Its one finding stays
out, with the reason in a comment. Docker built the dev image before hadolint came in.

{{include tut-25.9}}
