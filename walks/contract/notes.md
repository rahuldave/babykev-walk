We build the contract of babykev, a small decision model. babykev reads a text and some questions about it, and gives
a probability for every answer. A contract is the set of rules that both sides of an exchange agree on. Here the two
sides are the person who sends a request and the code that answers it. The contract says what a request must hold, and
what an answer holds.

Here is a small request. Its `state` says what the questions are about, here one cheese. The state can be plain text,
or named fields as here, and babykev turns it into text for the model. Three questions ask about it, each under a name
of its own.

```json
{
  "state": {"cheese": "Coquetdale", "style": "soft-ripened"},
  "questions": {
    "vegetarian": {"type": "noul", "instructions": "Would you offer this cheese to a vegetarian?"},
    "milk": {"type": "choice", "instructions": "Choose the milk.", "criteria": {"cow": null, "goat": null}},
    "intensity": {"type": "score", "instructions": "How strong is the flavour?", "criteria": ["Mild", "Medium", "Strong"]}
  }
}
```

Each question has a `type`, and there are three:

| Type | What it asks | What the answer holds |
|---|---|---|
| `noul` | Yes or no | The probability of yes |
| `choice` | One of the named options in `criteria` | The most likely option, a probability for each option, and a confidence |
| `score` | A level on the scale in `criteria`, from the first level to the last | The expected level, a probability for each level, and a confidence |

The expected level is a mean. Level 0 is `Mild`, level 1 is `Medium` and level 2 is `Strong`. If the model gives them
the probabilities 0.1, 0.2 and 0.7, the expected level is 0 × 0.1 + 1 × 0.2 + 2 × 0.7 = 1.6. The confidence is a
number from 0 to 1. It is 1 when the model is certain, and 0 when it only guesses.

The contract also says what a request must not be. A request with no questions is refused. So is a choice with no
options, or a scale with one level, or a question of a type that does not exist.

In babykev, the contract is the file `src/babykev/api.py`. It is written with pydantic, a Python package. In pydantic,
each kind of data is a class, a piece of code that lists the fields the data must have. pydantic checks data against
its class. This tutorial takes the parts about the contract out of the whole tutorial of babykev.

We make the project in moves. A move is one small change, made by one patch or by one command. A patch changes a file.
In watch mode, each move is already made, and the text says what it did and where to look. In do mode, you make each
move, and the page checks your files against it.

Some moves of the whole tutorial are not in this one. After such a gap, the next section says what those moves did,
and begins from their code. Each section after the first runs `just setup` before its moves. It installs the packages
that the code of the section needs.

## Where we start

babykev starts as a README, before any code. Its table already gives the three types of question.

{{include tut-00}}

## The contract, in pydantic

$ just setup

The whole tutorial first made babykev a Python project with uv. It gave babykev a command, `babykev`, in
`src/babykev/cli.py`. It also added a justfile, a file of short named commands called recipes, with the recipes
`setup` and `help`. Then it added pytest, a tool that runs tests, and coverage, which shows the lines of code that the
tests run. The recipe `just test` runs them both, and five tests check the command. The project has no contract yet.

{{include tut-03.1..tut-03.2}}

## What babykev leaves out of the contract

$ just setup

`api.py` came from kev, a larger project. kev answered requests on a server. Each request named the model for the
server to run. kev also counted the tokens of each answer, to bill for it. Tokens are the small pieces of text that a
model reads.

babykev has no server and no bill. A docstring is the text at the top of a file, or under a class or a function, that
says what it is for. The moves take the server out of the docstring of `api.py`. They also take the name of the model
out of a request, and remove the count of tokens.

{{include tut-03.3..tut-03.5}}

## Sample data

$ just setup

A file holds five requests about cheese, one on each line. Each line must fit the contract.

{{include tut-03.6..tut-03.7}}

## What the contract accepts and refuses

No test reaches the contract yet. The first tests check each line of the sample data against it. The others check one
rule each. A contract must refuse bad data as well as accept good data. When data does not fit, pydantic refuses it
with an error called `ValidationError`. So most of these tests expect that error.

{{include tut-04}}

## From a request to text for the model

$ just setup

The model reads text, and picks between options. So each question becomes a list of options. A noul becomes `no` and
`yes`. A choice becomes one option for each name in its `criteria`, and a score becomes one option for each of its
levels. `api.py` already does this, because the whole file came in one move, in the section on the contract in
pydantic. The moves of this section add the tests that show it.

{{include tut-05.1..tut-05.7}}

## From probabilities back to answers

$ just setup

The model gives a probability for each option. The function `to_answers`, in `api.py`, turns them into an answer of
the type of each question. The moves of this section add a test for each type.

{{include tut-05.8..tut-05.11}}

## The classes of a request say what they are

$ just setup

The whole tutorial then fixed two bugs in the answers, one in the rounding of the probabilities and one in the
confidence of a score.

It brought in ruff, a tool that formats the code and checks it against rules. Then it wrote down, for every function,
the kind of value that each input and the result hold. The tests grew to 53.

Then the whole tutorial turned on the rules `D1` of ruff. They ask for a docstring on every public file, class and
function. A name is public when it does not start with `_`. The package, the folder `src/babykev` that holds the code,
got its docstring first.

{{include tut-10.3}}

The four classes of a request now say what they are. There is one class for the request, and one for each of the three
types of question. Their docstrings stand in the code, and Python's own function `help()` prints them. The contract is
now whole. It says what a request holds, what it refuses, and how the model's probabilities become an answer for each
question.
