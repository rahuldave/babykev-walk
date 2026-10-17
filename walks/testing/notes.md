We build the tests of babykev, a small decision model. babykev reads a text and a set of questions about it, and gives
a probability for every answer. A test runs the code and checks what it gives back, so a later change cannot break
babykev without a failure. This tutorial takes the parts about tests out of the whole tutorial of babykev. It starts
from the project that uv made, with the command `babykev` and a justfile. It leaves out the formatter, the linter,
the types, the docs and the images of [Docker](https://www.docker.com/).

The repository [babykev](https://github.com/rahuldave/babykev/tree/tutorial) holds the model and the project around it, on the branch `tutorial`. At the end, `src/babykev/` holds `cli.py`, the command, `api.py`, the contract, `model.py`, the model, and `smoke.py`, a run of the real model. `tests/unit/` holds the unit and integration tests, and `tests/system/` holds the system test. `data/cheese/` holds sample requests, and `docs/` holds the site. `justfile`, `pyproject.toml` and `uv.lock` say how to work on it, and a `Dockerfile` and `.github/workflows/` run it on other machines. The tools are [uv](https://docs.astral.sh/uv/), [just](https://just.systems/), [pytest](https://docs.pytest.org/), [ruff](https://docs.astral.sh/ruff/), [ty](https://docs.astral.sh/ty/), [smalldocs](https://github.com/rahuldave/smalldocs) and [Docker](https://www.docker.com/).

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

## pytest, the first tests and coverage

babykev has one piece of code, the command `babykev`, in `src/babykev/cli.py`. The first tests are of the command.
Then coverage counts the lines of babykev that the tests run.

{{include tut-02}}

## Tests of the contract

The whole tutorial then adds the contract, `src/babykev/api.py`. It says what a request is and what an answer is,
with pydantic. Five sample requests about cheese go in
`data/cheese/sample.jsonl`. No test reaches the contract yet, so the coverage falls.

[pydantic](https://docs.pydantic.dev/) checks data against a description written as Python classes with type hints. A model says which fields a request has and of what type. pydantic then refuses data that does not fit, with a message that names the field. So the rules of a request live in one place, as code.

The tests here check the sample requests against the contract, then each rule of the contract, one at a time.

{{include tut-04}}

## Tests of rounding and confidence

The whole tutorial then adds eleven more tests of `api.py`. They check how a request becomes the text that the model
reads, and how the probabilities of the model become answers. After them, `just test` prints `43 passed`, and every
line of `api.py` runs.

Every line runs, and two of them are wrong. The tests here find them.

{{include tut-06}}

## The tiny model and fixtures

The whole tutorial then makes a long detour. [ruff](https://docs.astral.sh/ruff/) formats the code and checks it against rules. Every function gets
types and a docstring, the tests too. `just check` runs every check, and a git hook runs `just check` before git
records a change. [smalldocs](https://github.com/rahuldave/smalldocs) builds a docs site from the code.

Then the model comes in, with torch and three more packages, as `src/babykev/model.py`. [ty](https://docs.astral.sh/ty/) checks its types.
`src/babykev/smoke.py` runs the real model on the sample requests, and `just smoke` runs it. No test calls the model
or the smoke yet, so most of the new lines have no test.

[PyTorch](https://pytorch.org/), the package `torch`, holds tensors, the arrays of numbers that a model computes with, and the layers of neural networks. It runs on a CPU, on an NVIDIA GPU, and on the GPU of a Mac.

[transformers](https://huggingface.co/docs/transformers), from Hugging Face, loads trained language models and their tokenizers by name, such as `Qwen/Qwen2.5-0.5B`, and downloads their weights once.

The tests of the model need a model, and the real one is a download of about 1 GB. Here the tests get a tiny model,
with random weights, from fixtures.

{{include tut-19}}

## Unit tests of the model and the smoke

Each test here runs one function alone, with the tiny model or with no model at all.

{{include tut-20}}

## Integration tests, and the floor

The tests here run several parts together. When the coverage passes 90%, `just check` gets a floor.

{{include tut-21}}

## The mask, with hypothesis

The mask decides which token of a request may see which other token. Its lines all run in a test, and no test looks
at what it lets through. The tests here look, at first on one small request, and then with hypothesis, on many.

{{include tut-22}}

## The system test

Every test so far needs nothing but our code. The last test runs the smoke on the real model.

{{include tut-23}}

The project now has all four kinds of tests in the table of the intro.

## The tests on GitHub

$ just setup

The whole tutorial then writes two pages of a guide to the model. It builds two images of [Docker](https://www.docker.com/), one to run babykev
and one to work on it. One change there is about the tests. In a container, a test of hypothesis sometimes ran past
its deadline of 200 ms, and failed by chance. A setting in `tests/conftest.py` now turns that deadline off.

The hook runs `just check` only on a machine that has it. A clone without the hook records changes that
never met the checks. GitHub runs `just check` itself, on its own machines, after every push.

{{include tut-26.1..tut-26.2}}

This tutorial ends here. After it, the whole tutorial checks the workflow with [actionlint](https://github.com/rhysd/actionlint), and publishes the docs site
on GitHub Pages. The [whole tutorial](https://rahuldave.com/babykev-walk/) has every change.
