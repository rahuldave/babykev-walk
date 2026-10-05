## `api.py` is the contract

It says what a request is and what an answer is, as Pydantic models. kev's file, as it was, less the parts that served a web page.

- `SystemOneRequest`: a state, and questions by name
- `render`: turn any JSON value into the text the model reads
- `to_record`: turn a request into the record the model is given
- `to_answers`: turn the model's probabilities back into answers

---

## Three kinds of question, one mechanism

| Kind | You give | You get back |
|---|---|---|
| `noul` | a yes-or-no question | the probability of yes |
| `choice` | named options, each with a description | the most probable option, a confidence, every probability |
| `score` | ordered levels | the expected level, a confidence, every probability |

Each becomes a list of options. The model only ever points at one option in a list.

---

## Pydantic: types checked when the data arrives

```python
class Score(BaseModel):
    type: Literal["score"]
    instructions: JSONContent
    criteria: list[JSONContent] = Field(min_length=2, max_length=MAX_OPTIONS)
```

- A class says what the data must look like. Pydantic refuses anything else, and names the field
- A type checker works before the code runs. Pydantic works while it runs, on data from outside
- Five lines of sample data in `data/cheese/sample.jsonl`. A test checks each against the contract

---

## pytest: a test is a function that asserts

```python
def test_choice_confidence_is_zero_for_a_guess() -> None:
    assert choice_confidence([0.25, 0.25, 0.25, 0.25]) == 0.0
```

- `tests/unit/test_*.py`. `just test` runs them all, `just test -k confidence` some
- Every run measures coverage: which lines of `src/babykev` the tests reached
- At step 01: 52 runs, 50 pass, **2 fail**. Coverage 100%

---

## Two tests fail, and the tests are right

- **A score question that is a pure guess reported confidence 0.5.** A guess should be 0
- **77 equally likely options, each rounded to two decimals, summed to 0.77.** Probabilities sum to 1

kev found and fixed both, days later. A test written on the first day finds on the first day what a user would have found later.
