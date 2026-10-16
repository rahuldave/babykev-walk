## A stand-in for the real model

- The real model is a download of about 1 GB, and a pass takes about 200 ms on a GPU
- A test of the model checks something exact, such as which token is where, how many probabilities there are, or
  which weights get a gradient. That holds for any weights, trained or random
- So the tests run on a tiny model. It has the architecture of the real one, with two small layers and random weights
  from a seed. Its tokenizer has one token per character
- It needs no download and no GPU, and only our code can make its tests fail. The tests are **hermetic**, so they run
  at every commit

---

## The tiny model: what the two functions build

`tests/tiny.py` builds both parts in memory:

```python
chars = sorted(set(string.printable))
vocab = {"[UNK]": 0, **{c: i + 1 for i, c in enumerate(chars)}}
```

```python
config = Qwen2Config(vocab_size=vocab_size, hidden_size=32, intermediate_size=64,
                     num_hidden_layers=2, num_attention_heads=2, num_key_value_heads=2, ...)
return Qwen2Model(config)
```

- **The tokenizer** has 106 tokens. There is one for each of the 100 printable characters and each of the five
  delimiters, and `[UNK]` for any other character. "Roquefort" is 9 tokens
- **The backbone**: the code of Qwen, `Qwen2Model`, with 2 layers of 32 numbers, where the real one has 24 layers of
  896. 24,224 parameters, against 494,032,768

---

## Fixtures: what a test needs, passed to it

```python
@pytest.fixture(scope="session")
def tok() -> PreTrainedTokenizerFast:  # The tiny tokenizer, built once for the whole test run
    """Provide the tiny tokenizer."""
    return tiny_tokenizer()
```

- A **fixture** is a function marked `@pytest.fixture`. It makes one thing that tests need
- A test names the fixture as a parameter. pytest calls the fixture, and passes in what it returns
- `scope="session"`: pytest builds `tok` once for the whole run. The default scope builds a fixture again for each test
- `monkeypatch` and `capsys`, in the tests of the command, are fixtures of pytest. `tok` is ours

---

## `conftest.py`: fixtures for every test file

```python
@pytest.fixture(scope="session")
def tok() -> PreTrainedTokenizerFast: ...      # the tiny tokenizer, built once

@pytest.fixture
def model(tok: PreTrainedTokenizerFast) -> DecisionModel:      # a fixture can ask for a fixture
    return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()

@pytest.fixture
def record() -> dict[str, Any]: ...            # Roquefort: a state, and questions of 2, 3 and 3 options
```

- pytest reads `tests/conftest.py` before any test. Every test file under `tests/` can use its fixtures, with no import
- `model` and `record` are built again for each test, so no test can spoil them for the next
- `just test --fixtures` lists every fixture, and ours at the end

---

## The tiny model: a test that uses it

```python
def test_probabilities_sum_to_one_for_every_question(
    model: DecisionModel,  # The tiny model
    tok: PreTrainedTokenizerFast,  # Its tokenizer
    record: dict[str, Any],  # A record with three questions
) -> None:
    """Each question gets one probability per option, and they sum to 1."""
    probs = model.probs(encode(tok, record))
    assert [len(p) for p in probs] == [2, 3, 3]
    for p in probs:
        assert p.sum().item() == pytest.approx(1)
```

- The test never says "tiny". It names `model`, `tok` and `record`, and pytest passes them in
- The code that runs is our `DecisionModel`. Only the backbone and the tokenizer under it are small
- `[2, 3, 3]`: the data of a fixture is known, so a test can expect exact numbers

---

## Kinds of tests

| Kind | What it runs | Our example | Hermetic? |
|---|---|---|---|
| Unit | one function alone | `test_score_confidence_is_zero_for_a_guess` | yes |
| Integration | several of our parts together, with stand-ins for what comes from outside | `test_probabilities_sum_to_one_for_every_question`: the packing, the model and the head, on the tiny model | yes, because the tiny model stands in for the real one |
| End-to-end, or system | the whole program, with its real parts | none yet | no |
| Smoke | a quick end-to-end run: does it start, and answer at all? | `just smoke` | no. It needs the download and a device |
| Acceptance | a promise to the users, such as an answer within 50 ms | none | |

- A test's name says what it calls, not its kind
- Teams draw these lines in different places. When you name the kind of a test, say what runs in it

---

## The danger, then the defence

```python
def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(tok):
    decide = delimiter_ids(tok)[4]
    assert decide in tok(f"yes{SPECIAL[4]}", add_special_tokens=False).input_ids

@pytest.mark.parametrize("delimiter", SPECIAL)
def test_user_text_cannot_forge_a_delimiter(tok, delimiter):
    ids = user_tokens(tok, f"before {delimiter} after")
    assert not set(ids) & set(delimiter_ids(tok))
```

- The first test proves that the danger is real. A tokenizer turns the text `<|fim_suffix|>` into the decide token
- The second proves the defence, once for each of the five delimiters
- Neither adds a line to the coverage. The test of the probabilities had run `user_tokens` already, and checked
  nothing about it

---

## Integration tests: our parts together

- **What trains**: one backward pass on a tiny model with an adapter. Only the adapter and the head get a gradient
- **One padded pass**: two records of different lengths, in one pass, get the logits that each gets alone
- **The whole smoke**: the five sample requests go through the contract, the packing, the model and the answers, on
  the tiny model. The report has fifteen verdicts and the count

Each runs several of our parts in a row, and the tiny model stands in for the real one. So each is hermetic.

---

## The gate has a floor

```just
    just test -q --cov-fail-under=90
```

- `--cov-fail-under=90` makes pytest fail when the tests run less than 90% of the code
- It joins `just check` now, and not before. The model came in at 0%, and its tests brought the total over 90%
- The lines left are those that need the Hub, a download or a GPU of NVIDIA. A test of those is not hermetic

---

## Writing a fixture

The tests of the contract use a helper, `cheese_request`. Six tests call it themselves.

```python
def cheese_request() -> SystemOneRequest:
    return SystemOneRequest.model_validate({...})

def test_request_holds_one_model_per_question_type() -> None:
    questions = cheese_request().questions
```

A test asks for a fixture by its name, and calls nothing.

```python
@pytest.fixture
def record() -> dict[str, Any]:
    return {"state": "Roquefort. A blue cheese from France, made from sheep's milk.", "questions": [...]}

def test_probabilities_sum_to_one_for_every_question(model, tok, record): ...
```

*Without the docstrings and the docments.*

- A fixture is a function that returns what a test needs, marked `@pytest.fixture`. It goes in `conftest.py` when
  more than one file needs it
- If the test leaves something to clean up, the fixture can `yield` the thing in place of returning it. The code
  after `yield` runs when the test is done

---

## Fixtures in use

Three tests, each with its own mix of fixtures, without the types:

```python
def test_positions_restart_after_the_state(tok, record): ...                   # Kind: unit
def test_probabilities_sum_to_one_for_every_question(model, tok, record): ...  # Kind: integration
def test_user_text_cannot_forge_a_delimiter(tok, delimiter): ...               # Kind: unit
```

- All three share one `tok`. Each test that names `model` or `record` gets a fresh one
- `delimiter` is not a fixture. `@pytest.mark.parametrize` gives it, once for each of the five delimiters
- `just test --fixtures-per-test -k "probabilities_sum or positions_restart"` lists the fixtures of each test, and
  where each is defined, such as `model -- tests/conftest.py:23`

---

## The tiny model: functions, and fixtures

`tests/tiny.py` has two ordinary functions, with no `@pytest.fixture` on them:

```python
def tiny_tokenizer() -> PreTrainedTokenizerFast: ...                  # line 12
def tiny_backbone(vocab_size: int, seed: int = 0) -> Qwen2Model: ...  # line 27
```

`tests/conftest.py`, lines 16 to 27, makes two fixtures from them:

```python
@pytest.fixture(scope="session")
def tok() -> PreTrainedTokenizerFast:
    return tiny_tokenizer()

@pytest.fixture
def model(tok: PreTrainedTokenizerFast) -> DecisionModel:
    return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()
```

- The fixture `model` always returns a model with no adapter
- The test of what trains needs a tiny model with an adapter. So line 117 of `test_model.py` calls the function
  itself, in `DecisionModel("tiny", "cpu", lora=4, backbone=tiny_backbone(len(tok)))`
- Any code can call a function. Only pytest calls a fixture

---

## 2 unit tests, 0 integration tests

<img src="pictures/memes/2-unit-tests-0-integration-tests.gif" alt="Two window handles that each work, and block each other" style="max-height: 480px; max-width: 100%">

Made popular by Randal Olson, January 2016; the clip's author is unknown. giphy.com/gifs/2-unit-tests-0-integration-3o7rbGT9rrEJa4Y5LG
