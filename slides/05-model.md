## `model.py`: four ideas

- **Pack** the state and every question into one sequence
- **Mask** it, so each question sees the state and itself, never another question
- **Restart the positions**, so every question sits right after the state
- **Point**: score each option against the question's decide token

One forward pass answers every question, as if each had been asked alone.

---

## Packing: one sequence for everything

![The state, then one branch per question, with delimiter tokens](pictures/packing.svg)

Five delimiter tokens mark the parts. A caller's text can never produce one.

---

## The mask, as designed: questions cannot see each other

![A grid of which segment may look at which](pictures/mask.svg)

```python
attend(i, j)  if  j <= i  and  (seg[j] == 0  or  seg[j] == seg[i])
```

---

## The pointer head: compare, do not classify

![The decide token and each option's closing token are projected and compared](pictures/pointer-head.svg)

---

## What is trained

| Part | Parameters | Trained? |
|---|---|---|
| Qwen2.5-0.5B, the language model | about 494 million | No. Frozen |
| The LoRA adapter, rank 16 | about 8.8 million | Yes |
| The pointer head | about 0.5 million | Yes |

The smoke test we will soon see prints it: 503M parameters, 9.3M of them trainable.

---

## Fixtures: what a test needs, passed to it

A test needs things to work on before it can check anything: a sample request, a tokenizer, a model. Not the real ones: small stand-ins, made up for the tests. A **fixture** makes one of them, in one place, for every test that asks.

```python
@pytest.fixture
def record() -> dict[str, Any]:          # stand-in data: one request, three questions
    return {"state": "Roquefort. A blue cheese from France, ...", "questions": [...]}

@pytest.fixture(scope="session")
def tok() -> PreTrainedTokenizerFast:     # a stand-in tokenizer, one token per character
    return tiny_tokenizer()

@pytest.fixture
def model(tok: PreTrainedTokenizerFast) -> DecisionModel:   # a stand-in model, built on tok
    return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()
```

- A test names the fixture as an argument; pytest calls it and passes in what it returns
- `tok` is built once for the whole run, `scope="session"`. `record` and `model` are built fresh for every test, so no test can spoil them for the next
- A fixture can ask for another: `model` takes `tok`
- `capsys` and `monkeypatch` at step 01 were pytest's own fixtures. These are ours

---

## Writing a fixture

At the beginning we used a helper. Six tests call it by hand:

```python
def cheese_request():
    return SystemOneRequest.model_validate({...})

def test_request_holds_one_model_per_question_type():
    questions = cheese_request().questions
```

Now, a fixture. A test asks for it by name:

```python
@pytest.fixture
def record() -> dict[str, Any]:
    return {"state": "Roquefort. A blue cheese from France, made from sheep's milk.", "questions": [...]}

def test_positions_restart_after_the_state(tok, record): ...
```

- To write one: a function that returns what the test needs, marked `@pytest.fixture`, in `conftest.py` if more than one file needs it
- If the test leaves something to clean up, `yield` it instead of returning it. The code after `yield` runs when the test is done

---

## `conftest.py`: fixtures for every test file

- pytest reads `tests/conftest.py` before any test. Every test file under `tests/` can use its fixtures without importing anything
- Ours contains three fixtures: `tok`, the tiny tokenizer; `model`, a tiny model; `record`, one request with a state and three questions
- 8 test functions ask for them: all 8 for `tok`, 4 for `record`, 2 for `model`. pytest runs them as 12 tests: one of the 8 runs once for each of the five delimiters
- `just test --fixtures` lists every fixture pytest can see: its own first, then ours, under `fixtures defined from conftest`, each with its docstring

---

## Fixtures in use

Three tests, each asking for its own mix of the three fixtures (types left out):

```python
def test_positions_restart_after_the_state(tok, record):                  # Kind: unit
    enc = encode(tok, record)
    ...

def test_probabilities_sum_to_one_for_every_question(model, tok, record):  # Kind: integration
    probs = model.probs(encode(tok, record))
    assert [len(p) for p in probs] == [2, 3, 3]

def test_smoke_reports_on_every_question_of_the_sample(model, tok):        # Kind: integration
    report = list(smoke(model, tok, read_lines()))
    ...
```

- `[2, 3, 3]`: the `record` fixture's three questions have 2, 3 and 3 options. A fixture's data is known in advance, so a test can expect exact numbers
- Each test gets its own fresh `model` and `record`; all of them share one `tok`
- `just test --fixtures-per-test -k "probabilities_sum or positions_restart"` shows which fixtures each of the two tests uses, and where each is defined

---

## The tiny model: a test that uses it

**Kind: integration**: packing, the model and the head together, on the tiny model. `tests/unit/test_model.py`, lines 137 to 146:

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

- The test never says "tiny". It names `model` and `tok` as arguments, and pytest passes it the tiny model and the tiny tokenizer
- `encode(tok, record)` turns the record into tokens with the tiny tokenizer. `model.probs(...)` runs those tokens through the tiny model and the pointer head
- The code that runs is our real `DecisionModel`, from `model.py`. Only the backbone and the tokenizer under it are small
- Nothing is trained, so the probabilities mean nothing. The test checks what is true of any probabilities: one per option, and they add up to 1

---

## The tiny model: where `model` and `tok` come from

`tests/conftest.py`, lines 16 to 27, contains two fixtures:

```python
@pytest.fixture(scope="session")
def tok() -> PreTrainedTokenizerFast:
    return tiny_tokenizer()

@pytest.fixture
def model(tok: PreTrainedTokenizerFast) -> DecisionModel:
    return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()
```

`tests/tiny.py` contains two ordinary functions, with no `@pytest.fixture` on them:

```python
def tiny_tokenizer() -> PreTrainedTokenizerFast: ...                  # line 16
def tiny_backbone(vocab_size: int, seed: int = 0) -> Qwen2Model: ...  # line 31
```

- **The fixtures**, `tok` and `model`: pytest calls them and passes what they return to every test that names them. `tok` is built once for the whole run (`scope="session"`). `model` is built again for each test (the default scope)
- **The ordinary functions**, `tiny_tokenizer` and `tiny_backbone`: they build the two small parts. Any code can call them, as the two fixtures do
- **Why the builders are not fixtures**: our `model` fixture takes no arguments and always returns one model, without an adapter. The adapter test needs a tiny model with an adapter, so it calls the function itself, at line 163: `DecisionModel("tiny", "cpu", lora=4, backbone=tiny_backbone(len(tok)))`
- `test_model.py` also calls `tiny_tokenizer()` at line 14, `TOK = tiny_tokenizer()`, for two tests further down (lines 82 and 115)

---

## The tiny model: what the two functions build

Both are built in memory, with no download:

```python
chars = sorted(set(string.printable))
vocab = {"[UNK]": 0, **{c: i + 1 for i, c in enumerate(chars)}}
```

```python
config = Qwen2Config(vocab_size=vocab_size, hidden_size=32, intermediate_size=64,
                     num_hidden_layers=2, num_attention_heads=2, num_key_value_heads=2, ...)
return Qwen2Model(config)
```

- **The tokenizer**: one token for each of the 100 printable characters, one for each of the five delimiters, and `[UNK]`, the token for any other character. 106 tokens in all. "Roquefort" is 9 tokens, one per letter
- **The backbone**: Qwen's own code, `Qwen2Model`, built smaller: 2 layers of 32 numbers, where the real model has 24 layers of 896
- Its weights are random, drawn from a fixed seed, so they are the same at every run. 24,224 parameters, against the real backbone's 494 million

---

## The tiny model: why it is enough

- What we test is exact: which token may see which, where the positions start, which parameters get a gradient. That is true for any weights, trained or random
- What it cannot tell: whether the answers are any good, how the real tokenizer splits words, how fast it runs on a GPU
- What it buys: no download, no GPU, a few seconds
- It is a working, simplified stand-in for the real model. Testers call such a stand-in a fake

**Hermetic**: only our code can make these tests fail. No network and no download, and they run on the CPU, which every machine has. So they run on every commit.

---

## Kinds of tests

| Kind | What it runs | Our example | Is our example hermetic? |
|---|---|---|---|
| Unit | one function, alone | `test_score_confidence_is_zero_for_a_guess`: one function, given three numbers | yes |
| Integration | several of our parts together, with stand-ins for what comes from outside | `test_probabilities_sum_to_one_for_every_question`: packing, the model and the head. `test_smoke_reports_on_every_question_of_the_sample`: each request of the sample file through the contract, the packing, the model and the answers. Both on the tiny model | yes: the tiny model stands in for the real one |
| End-to-end, or system | the whole program with its real parts, the way a user runs it | `just smoke local`: the whole smoke, on the real model | no: it needs the download and a device |
| Smoke | a quick end-to-end run: does it start, and answer at all? | `just smoke local` again: our end-to-end run is a smoke | no |
| Acceptance | does it meet a promise to its users, such as an answer within 50 ms? | none yet | |

- An end-to-end test uses the real parts, so something outside our code can make it fail: it is never hermetic
- An integration test is hermetic only when what comes from outside is replaced. Ours replace the real model with the tiny one; one that talks to a real database is not hermetic
- The tiny model is not a kind of test. It is the stand-in for the real model, and the `model` fixture returns it to the tests that name it
- A test's name says what it calls, not what kind of test it is: `test_smoke_reports_on_every_question_of_the_sample` calls our function `smoke`, but it is an integration test, not a smoke test
- Teams draw the lines between these names differently. When you call a test an integration test, say what runs in it
- From here on, each test we read names its kind first

---

## What a smoke test is

- The name comes from electronics: switch a new circuit on, and see whether it smokes
- It asks: does the whole thing start, and give an answer at all? Not: is the answer right
- Fast and shallow. Run it first, before the slow and deep tests
- Ours: load the model, ask the 15 sample questions, print each answer beside its label

---

## The smoke: everything, on the real model

**Kind: smoke**, which is end-to-end: the real model. Run by hand, not in `just test`.

`just smoke local` loads Qwen2.5-0.5B with a fresh adapter and an untrained head, asks the 15 sample questions, and prints each answer beside its label.

- On this Mac's GPU: 6 of 15 right
- Nothing is trained, so these are guesses. What the run proves is that the pieces fit
- Every check is green

---

## ty: a type checker

- A type says what kind of value something is: a whole number, a list of numbers, a tokenizer
- Since step 03, every function of ours says the types it takes and the type it returns, we use this in docments
- ty compares every call and every `return` with what the function says. It does this by reading the code, without running it
- `ty check` runs it on the whole project. The recipe is `just types`
- Here we will we run ty by hand and read what it finds. `just check` does not include it yet, so a commit with negative ty findings still goes through
- At the next step `just check` runs ty too. From then on, a commit with a negative ty finding is refused

---

## currently we get six findings

`just types` prints six findings, each with a file, a line and a code:

| Where | Code | What ty says |
|---|---|---|
| `model.py:68` | `invalid-return-type` | `load_tokenizer` says it returns a tokenizer. `AutoTokenizer.from_pretrained`, which it returns, says it may return `None` |
| `model.py:97` | `not-iterable` | the result of `convert_tokens_to_ids` may be a single number, which cannot be split into five names |
| `test_model.py:49` | `not-iterable` | the same |
| `test_model.py:100` | `not-subscriptable` | the same result, followed by `[4]`: a single number has no item 4 |
| `test_model.py:111` | `invalid-argument-type` | the same result, given to `set(...)`, which needs a list or something like it |
| `test_model.py:120` | `not-iterable` | the same as line 49 |

The first comes from one call. The other five come from one other call, `convert_tokens_to_ids`.

---

## The five findings from one call

`model.py`, line 97:

```python
s_id, q_id, o_id, c_id, d_id = tok.convert_tokens_to_ids(SPECIAL)
```

- `SPECIAL` is the list of the five delimiters. `convert_tokens_to_ids` turns tokens into their numbers
- The library says it returns `int | list[int]`: one number when given one token, a list of numbers when given a list
- We give it a list of five, so it returns a list of five numbers, and the line de-structures them into five names. The code runs, and the tests pass
- ty reads only what the library says, not what happens at run time. "It may be one number" is enough: one number cannot be split into five names
- In the next step we will call this once, in a new function `delimiter_ids`, which always returns a list. It also makes `load_tokenizer` stop with an error when it gets no tokenizer. Then ty finds nothing, and `just types` joins `just check`

---

## The problem with the mask as written.

This is what the mask should be, token by token: say we have a small request of six tokens: two for the state, two for question 1, two for question 2. They are numbered 1 to 6, in the order they are packed:

| Token | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| Part | state | state | question 1 | question 1 | question 2 | question 2 |

The mask says, for each token, which tokens it may look at. Each row below is one token. Along its row, `#` means "may look at this token", `.` means "may not":

```
                   may look at token:  1 2 3 4 5 6
token 1, state                         # . . . . .
token 2, state                         # # . . . .
token 3, question 1                    # # # . . .
token 4, question 1                    # # # # . .
token 5, question 2                    # # . . # .
token 6, question 2                    # # . . # #
```

- No token may look at a token after it: everything right of the diagonal is `.`
- The tokens of question 2, rows 5 and 6, may not look at question 1, tokens 3 and 4. This is the red cell of the earlier picture, token by token
- So question 2 gets the same answer whether or not question 1 was asked

---

## All green, and the mask is wrong

**Here there is no test that checks the mask**. Every check in `just check` passes: 92 tests, 94% coverage, 139 of 139 documented. Coverage counts `branch_mask` as tested, because its lines ran. No test looks at the mask the code here builds.

The code at step 05 builds a different mask from the last slide. For the same six tokens:

```
                       should be      step 05 builds
token 1, state         # . . . . .    # . . . . .
token 2, state         # # . . . .    # # . . . .
token 3, question 1    # # # . . .    # # # . . .
token 4, question 1    # # # # . .    # # # # . .
token 5, question 2    # # . . # .    # # # # # .
token 6, question 2    # # . . # #    # # # # # #
```

Rows 5 and 6 differ: at step 05, question 2 may look at question 1's tokens, 3 and 4.

$ sed -n '140p' src/babykev/model.py

```python
same = torch.ones_like(causal) | (s[None, :] == 0)
```

`same` should be yes only when two tokens are in the same question, or the other one is in the state. `torch.ones_like(causal)` makes it yes for every pair, so every token may look at every token before it.

---

## A check that sees it

At step 05 there is no test of the mask. A plain Python function can still check it. It draws the right mask for the six tokens of the grid next to the mask `branch_mask` builds, and marks each row:

```python
from babykev.model import branch_mask

def check_small_request():
    picture = ["#.....", "##....", "###...", "####..", "##..#.", "##..##"]
    mask = branch_mask([0, 0, 1, 1, 2, 2], "cpu")[0, 0] == 0
    rows = ["".join("#" if ok else "." for ok in row) for row in mask]
    for want, got in zip(picture, rows, strict=True):
        print(want, got, "ok" if want == got else "WRONG")
```

```
#..... #..... ok
##.... ##.... ok
###... ###... ok
####.. ####.. ok
##..#. #####. WRONG
##..## ###### WRONG
```

Rows 5 and 6 are WRONG: question 2 looks at question 1. This is not a test: nothing in `just check` runs it.

---

Normally we would fix before we commit.

But say Pavlos distracted us, so we comitted and went to his class :-)

<img src="pictures/pavlos-worried.png" alt="Pavlos, the cartoon, worried, with a hand raised" style="max-height: 220px">
