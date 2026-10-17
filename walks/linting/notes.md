We check the code of babykev, a small decision model. babykev reads a text and a set of questions about it, and
gives a probability for every answer.

The repository [babykev](https://github.com/rahuldave/babykev/tree/tutorial) holds the model and the project around it, on the branch `tutorial`. At the end, `src/babykev/` holds `cli.py`, the command, `api.py`, the contract, `model.py`, the model, and `smoke.py`, a run of the real model. `tests/unit/` holds the unit and integration tests, and `tests/system/` holds the system test. `data/cheese/` holds sample requests, and `docs/` holds the site. `justfile`, `pyproject.toml` and `uv.lock` say how to work on it, and a `Dockerfile` and `.github/workflows/` run it on other machines. The tools are [uv](https://docs.astral.sh/uv/), [just](https://just.systems/), [pytest](https://docs.pytest.org/), [ruff](https://docs.astral.sh/ruff/), [ty](https://docs.astral.sh/ty/), [smalldocs](https://github.com/rahuldave/smalldocs) and [Docker](https://www.docker.com/).

Code that works can still be hard to read, and a reader can miss a bug in it. A formatter writes every file in one
style. A linter checks the code against rules, and a type checker checks the types that the code declares. [ruff](https://docs.astral.sh/ruff/) is
the formatter and the linter, and [ty](https://docs.astral.sh/ty/) is the type checker. [pre-commit](https://pre-commit.com/) then runs every check before each
`git commit`.

This tutorial takes these parts out of the whole tutorial of babykev. It leaves out the parts that build the
project, its tests, its docs and its model. Where it skips changes of the whole tutorial, the next section says what
they did, and begins from their code. It first runs `just setup`, which installs the packages of that code.

We make the project in moves. A move is one small change, made by one patch or by one command. A patch changes a
file, and a command such as `uv add` writes the files it needs. In watch mode, each move is already made, and the
text says what it did and where to look.

This tutorial has eight sections:

1. **Where we start**
2. **Format**
3. **Lint**
4. **Types in every signature**
5. **Docstrings**
6. **The gate and the hook**
7. **The config files, checked**
8. **The type checker**

Two tools run everything here. [uv](https://docs.astral.sh/uv/) manages the project. It installs Python and the packages, keeps them in `.venv`, and pins their versions in `uv.lock`. [just](https://just.systems/) runs the tasks of the project by name, from the recipes of its `justfile`. `just setup`, for example, runs `uv sync`.

## Where we start

The first section shows the folder of babykev before it holds any code.

{{include tut-00}}

## Format

$ just setup

The whole tutorial then makes babykev a Python project with uv. It has a command, `babykev`, in
`src/babykev/cli.py`, and a `justfile` with the recipes `setup`, `help` and `test`. [pytest](https://docs.pytest.org/) runs the tests, from the
dependency group `test`, and measures the coverage.

`src/babykev/api.py` is the contract, the rules for what a request and an answer hold. A request has questions of
three types, and [pydantic](https://docs.pydantic.dev/), a library that checks data, checks each request. Two tests find two bugs in `api.py`, and
two changes fix them. `just test` prints `53 passed`, and the coverage is 100%.

`just setup` prints `Resolved 14 packages`. The tests check what the code does, and nothing checks how it looks.
`api.py` has a style of its own. Some lines hold an `if` and its `return` together, and some lines run past 200
characters. ruff comes in, then its settings and the recipe `fmt`, and the formatter rewrites `api.py`.

{{include tut-07.1..tut-07.5}}

## Lint

{{include tut-08}}

## Types in every signature

{{include tut-09}}

## Docstrings

{{include tut-10}}

## The gate and the hook

{{include tut-11}}

## The config files, checked

{{include tut-12}}

## The type checker

$ just setup

The whole tutorial then documents the code. [smalldocs](https://github.com/rahuldave/smalldocs), in a third dependency group, `docs`, reads the docstrings
and the docments, the comments beside each parameter. `just docs check` lists what has no documentation, and the
gate runs it. `just docs` builds a site from the docs.

Then come the four packages of the model, [torch](https://pytorch.org/), [transformers](https://huggingface.co/docs/transformers), [peft](https://huggingface.co/docs/peft) and [safetensors](https://huggingface.co/docs/safetensors). torch is the build for the CPU,
from PyTorch's own index. Last, `src/babykev/model.py` comes in, the model, 274 lines. It passes the format, the
linter and the docs check. No test runs it yet, so the coverage falls to 43%.

`just setup` prints `Resolved 66 packages`. `model.py` has a type on every parameter and every return, because the
linter asks for them. Nothing checks that the types are right. ty reads the code, and compares each call and each
value with the types that the code and its libraries declare.

{{include tut-17.1..tut-17.5}}

This tutorial ends here. After it, the whole tutorial runs the model and gives it tests, and the gate gets a floor
on the coverage. The [whole tutorial](https://github.com/rahuldave/babykev/tree/tutorial) has every change.
