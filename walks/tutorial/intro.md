babykev is a small decision model. It reads a text and a set of questions about it, and gives a probability for
every answer. A question asks for yes or no, for a choice between named options, or for a level on a scale. This
part of the tutorial builds the project around the model, and not the model itself. babykev's contract and its
model come from the first version of [kev](https://github.com/jaredpalmer/kev), by Jared Palmer. The contract is the
set of rules for what a request and an answer hold.

The repository [babykev](https://github.com/rahuldave/babykev/tree/tutorial) holds the model and the project around it, on the branch `tutorial`. At the end, `src/babykev/` holds `cli.py`, the command, `api.py`, the contract, `model.py`, the model, and `smoke.py`, a run of the real model. `tests/unit/` holds the unit and integration tests, and `tests/system/` holds the system test. `data/cheese/` holds sample requests, and `docs/` holds the site. `justfile`, `pyproject.toml` and `uv.lock` say how to work on it, and a `Dockerfile` and `.github/workflows/` run it on other machines. The tools are [uv](https://docs.astral.sh/uv/), [just](https://just.systems/), [pytest](https://docs.pytest.org/), [ruff](https://docs.astral.sh/ruff/), [ty](https://docs.astral.sh/ty/), [smalldocs](https://github.com/rahuldave/smalldocs) and [Docker](https://www.docker.com/).

First, we use uv, a tool that installs Python and the packages a project needs, to make babykev a package. A
package is a project that can be installed, so that its command `babykev` runs in a terminal. We add one list of
tasks in `just`, a tool that runs each task by its name. Then we add tests. They check the command `babykev`, the
contract, and the code that turns the model's probabilities into answers. The project is on the branch `tutorial` of
[babykev](https://github.com/rahuldave/babykev/tree/tutorial).

We make babykev in moves. A move is one small change, made by one patch or by one command. A patch changes a file.
A command such as `uv add`, which adds a package to the project, changes the project's files itself, so its move
needs no patch.

There are two ways to follow. In do mode, you make each move, and the page checks your files against it. When they
match, the move is made, and the next one starts. In watch mode, each change is already made, and the text says
what it did and where to look.

Each move first says what problem it solves. Then it gives the change, piece by piece. Last, a command checks the
result, and a list names each file that changed, with what to look for in it.
