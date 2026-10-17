## The contract, and its tests

- **The contract** says what a request is and what an answer is. It comes from kev, in one file, `api.py`
- **pydantic** checks that the data of a request has the shape that the contract says
- **pytest** runs the tests, and **pytest-cov** measures which lines of the code they run
- At the next stop, two more tests find two bugs of kev, and we fix both

---

## `api.py` is the contract

The contract says what a request is, as pydantic models, and what an answer is.

- `SystemOneRequest`: a state, and questions by name. kev's field `model`, for his server, is left out
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

## Check what comes in

<img src="pictures/memes/xkcd-327-exploits-of-a-mom.png" alt="xkcd 327, Exploits of a Mom" style="max-height: 480px; max-width: 100%">

xkcd.com/327, *Exploits of a Mom*. CC BY-NC 2.5

The tests check every request of `data/cheese/sample.jsonl` against the contract.

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
src/babykev/api.py           66      0   100%
src/babykev/cli.py            8      0   100%
-------------------------------------------------------
TOTAL                        74      0   100%
```

- pytest-cov measures the lines of `src/babykev` that the tests run, on every run of `just test`
- `Missing` lists the lines that no test ran. Here it is empty, because 43 tests run every statement
- With `-k`, the table counts only the tests that ran. `just test -k render` runs 9 tests, and says 50%
- Coverage says which lines ran. It does not say that a test checked what they did

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
