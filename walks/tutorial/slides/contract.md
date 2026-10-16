## The contract, and its tests

- **The contract** says what a request is and what an answer is. It comes from kev, in one file, `api.py`
- **pydantic** checks that the data of a request has the shape that the contract says
- **pytest** runs the tests, and **pytest-cov** measures which lines of the code they run
- Later, two tests find two bugs of kev, and we fix both

---

## `api.py` is the contract

The contract says what a request is, as pydantic models, and what an answer is.

- `SystemOneRequest`: a state, and questions by name. A later move removes kev's field `model`
- `render`: turn any JSON value into the text the model reads
- `to_record`: turn a request into the record the model is given
- `to_answers`: turn the probabilities of the model back into answers

---

## Three kinds of question, one mechanism

| Kind | You give | You get back |
|---|---|---|
| `noul` | a yes-or-no question | the probability of yes |
| `choice` | named options, each with a description if you want one | the most probable option, a confidence, every probability |
| `score` | ordered levels | the expected level, a confidence, every probability |

Each question becomes a list of options. The model points at one option in the list.

---

## pydantic: types checked when the data arrives

```python
class Score(BaseModel):
    type: Literal["score"]
    instructions: JSONContent
    criteria: list[JSONContent] = Field(min_length=2, max_length=MAX_OPTIONS)
```

- A class says what the data must look like, and pydantic checks the data against it
- The check happens when the data arrives, before any other code reads it

---

## pytest: a test is a function that asserts

**Kind: unit.** A unit test checks a small part of the code alone, with no model, no network and no other
program. Every test of this step is a unit test.

```python
def test_an_unknown_command_is_refused_with_exit_code_2(monkeypatch, capsys):
    with pytest.raises(SystemExit) as exit_info:
        run(monkeypatch, "train")
    assert exit_info.value.code == 2
```

*Without its docstring and its last three lines.*

- pytest runs every function named `test_*` in the files `tests/**/test_*.py`
- `just test` runs them all, and `just test -k NAME` runs the tests with NAME in their name
- Test normal inputs, edge cases and invalid inputs

---

## Testing the command: fixtures and parametrize

```python
def run(monkeypatch, *words):
    monkeypatch.setattr("sys.argv", ["babykev", *words])
    main()


@pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])
def test_help_is_printed_for_help_and_for_no_words(monkeypatch, capsys, words):
    run(monkeypatch, *words)
    assert capsys.readouterr().out == HELP
```

*Without the docstrings.*

- **Fixtures.** `monkeypatch` and `capsys` are fixtures that pytest has. A test names a fixture as an argument, and pytest passes it in
- `monkeypatch` sets `sys.argv` as if a person had typed `babykev help`, and puts it back after the test
- `capsys` catches what the program printed, so the test can compare it with `HELP`
- **`@pytest.mark.parametrize`** runs the function once for each value of `words`. One function makes four tests

---

## Coverage: which lines the tests run

```
Name                      Stmts   Miss  Cover   Missing
-------------------------------------------------------
src/babykev/__init__.py       0      0   100%
src/babykev/api.py           66     66     0%   7-104
src/babykev/cli.py            8      0   100%
-------------------------------------------------------
TOTAL                        74     66    11%
```

- pytest-cov measures the lines of `src/babykev` that the tests run, on every run of `just test`
- `Missing` lists the lines that no test ran. No test imports `api.py` yet
- Coverage says which lines ran. It does not say that a test checked what they did

---

## Check what comes in

<img src="pictures/memes/xkcd-327-exploits-of-a-mom.png" alt="xkcd 327, Exploits of a Mom" style="max-height: 480px; max-width: 100%">

xkcd.com/327, *Exploits of a Mom*. CC BY-NC 2.5

The tests check every request of `data/cheese/sample.jsonl` against the contract.

---

## A test of rounding fails, and the test is right

```python
def test_rounded_probabilities_still_sum_to_one():
    keys = [f"intent{i}" for i in range(77)]
    answer = to_answers([[1 / 77] * 77], [{"id": "intent", "type": "choice", "keys": keys}])[
        "intent"
    ]
    assert sum(answer["probabilities"].values()) == pytest.approx(1, abs=0.02)
```

*Without its docstring.*

**After rounding, 77 options with the same probability sum to 0.77.** kev rounds each probability to two decimals, so each
1/77, about 0.013, becomes 0.01. pytest prints `assert 0.77 == 1 ± 0.02`.

---

## The fix of rounding

```python
def round_prob(x: float) -> float:
    return round(float(x), 4)
```

*Without its docstring.*

- `round_prob` rounds to four decimals. It takes the place of kev's function `r2`, which rounded to two
- Each 1/77 becomes 0.013, and the 77 probabilities sum to 1.001
- The test did not change. The code did

---

## A test of confidence fails, and the test is right

```python
def test_score_confidence_is_zero_for_a_guess():
    assert score_confidence([1 / 3] * 3) == pytest.approx(0)
```

*Without its docstring.*

**A guess over three levels has confidence 0.5.** A guess gives every level the same probability. Confidence
runs from 1, when the model is sure, to 0, when it knows nothing. So a guess must have confidence 0. pytest
prints `assert 0.5 == 0 ± 1.0e-12`.

---

## The fix of confidence

The confidence of a score is 1 minus a fraction. The fraction divides `spread` by a measure. For `spread`, take
the distance of each level from the most likely level, and multiply it by the probability of that level. Then add
the results. The fix changes the measure. For a guess over three levels, each level has the probability 1/3:

- **`spread`.** All levels are equally likely, so `max` takes level 0 as the most likely. The levels are 0, 1
  and 2 steps from it, so `spread` is 1/3 × 0 + 1/3 × 1 + 1/3 × 2 = **1 step**
- **The old measure** is the length of the scale, **2 steps**. So the confidence is 1 − 1/2 = **0.5**
- **The new measure, `guess`,** is the spread of a guess around the middle level, 1/3 × 1 + 1/3 × 0 + 1/3 × 1 =
  **2/3 of a step**. So the confidence is 1 − 1 ÷ (2/3) = **−0.5**, and the code counts a value below 0 as **0**

Over three levels, any answer with a `spread` of 2/3 of a step or more also gets 0. For example, `[0.5, 0.25, 0.25]` has a `spread`
of 0.75 and gets 0. `[0.8, 0.1, 0.1]` has a `spread` of 0.3 and gets 0.55.

---

## One line that no test runs

```
src/babykev/api.py           71      1    99%   90
```

```python
    L = len(p)
    if L == 1:
        return 1.0
```

- The fix added line 90, the answer for a scale of one level. No test runs it
- A request cannot have such a scale, because a `Score` needs two levels at least
- So only a test that calls `score_confidence` itself can run the line. The next move adds that test

---

## From a request to the model, and back

```
request ──to_record──▶ record: the state as text, and the options of each question
                                       │
                                     model
                                       │
answers ◀──to_answers── probabilities: one list for each question
```

- `render` writes the JSON of the state as text, and `option_text` writes each option
- A noul is two options, `no` then `yes`. A choice is one option per criterion, and a score one per level
- `to_answers` gives a noul the probability of yes, a choice its winner, and a score its expected level
