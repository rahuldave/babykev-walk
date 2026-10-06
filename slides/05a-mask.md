## We had two problems left over from step 05

1. **A type problem.** `just types` finds six problems. Five come from one line, `model.py` line 97: `tok.convert_tokens_to_ids(SPECIAL)`, which gives back a list of five numbers that the line splits into five names. ty reads only that the library may give back one number, and one number cannot be split. The sixth is `load_tokenizer`, which may give back `None`
2. **A mask problem.** `branch_mask` lets question 2 look at question 1 (`model.py` line 140). Every check passes, because there is no test of the function that builds the mask

Step 05a deals with both.

---

## The tiny model again: how a test gets it

Step 05 built a tiny tokenizer and a tiny model in memory, in `tests/tiny.py`: 106 tokens, 2 layers of 32 numbers, 24,224 parameters. A test gets them as fixtures. `tests/conftest.py`, lines 16 to 27:

```python
@pytest.fixture(scope="session")
def tok() -> PreTrainedTokenizerFast:
    return tiny_tokenizer()

@pytest.fixture
def model(tok: PreTrainedTokenizerFast) -> DecisionModel:
    return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()
```

- A test builds nothing. It names `model` and `tok` as arguments, and pytest passes in what these two functions return. The tests below do that
- `tok` is built once for the whole run. `model` is built fresh for each test
- A third fixture, `record`, lines 30 to 40, is one request about Roquefort with three questions: is it a blue cheese, which milk, how firm

$ sed -n '16,27p' tests/conftest.py

---

## Test properties, not examples

- **Isolation**: change question 2, and question 1's answer must not move
- **Packed equals separate**: three questions in one pass give the numbers of three passes
- **Order does not matter**
- **The mask's rule**, for any request: no token sees a later one, no question sees another

They are true for any weights, so the tiny model is enough.

$ just test

---

## A picture checks one size

At the end of step 05, five lines of Python drew the right mask for six tokens, and rows 5 and 6 were WRONG. Suppose someone fixes the mask like this instead, so that only the question right before is blocked:

```python
same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)
```

The same five lines, run again, print `ok` six times. The picture has only two questions, so it cannot tell.

A request of a different size: one state token, then three questions of one token each, parts `[0, 1, 2, 3]`. It needs its own picture, drawn by hand. On the left the picture, on the right what the wrong fix builds:

```
#...   #...   ok
##..   ##..   ok
#.#.   #.#.   ok
#..#   ##.#   WRONG
```

Row 4: question 3 looks at question 1.

- We have no function that draws the right mask for any size. A request can have 1 to 6 state tokens, then 0 to 4 questions of 1 to 5 tokens each: 4,686 shapes, and each would need its own picture
- So we do not test with pictures. We state the rule once, and let the computer try shapes

---

## hypothesis: state the rule, the computer tries the shapes

`hypothesis` is a Python library for tests. We say what a request may look like, and it draws requests for us. `test_mask.py`, line 10:

```python
shapes = st.tuples(st.integers(1, 6), st.lists(st.integers(1, 5), max_size=4))
```

That says: a state of 1 to 6 tokens, then a list of up to 4 questions of 1 to 5 tokens each.

```python
@given(shapes)
def test_no_question_sees_another_question(shape): ...
```

- `@given(shapes)` runs the test again and again, each time with a shape drawn at random from the 4,686. By default, up to 100 times
- If a shape breaks the rule, hypothesis shrinks it: it tries smaller shapes until none smaller breaks, and shows that one
- We write the rule once. hypothesis looks for the shape we did not think of
- hypothesis allows each run 200 ms. The first run that uses torch can take longer on a slow or busy machine, and the test would then fail by chance. `tests/conftest.py` turns the deadline off, and says why in a comment

$ sed -n '10p;58,59p' tests/unit/test_mask.py
$ sed -n '43,51p' tests/conftest.py

---

## hypothesis finds the size for us

**Kind: unit**: `branch_mask` alone. We write the wrong fix of the last slide into `branch_mask`, and read the rule, written as a test:

$ perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)/' src/babykev/model.py
$ sed -n '58,65p' tests/unit/test_mask.py
$ just test -k no_question_sees_another

```python
@given(shapes)
def test_no_question_sees_another_question(shape):
    """A token of one question never attends to a token of another."""
    seg = torch.tensor(segments(*shape))
    siblings = (seg[:, None] != seg[None, :]) & (seg[:, None] > 0) & (seg[None, :] > 0)
    assert not (allowed(seg.tolist()) & siblings).any()
```

`segments` gives the part of each token: 0 for the state, k for question k. `siblings` is yes for two tokens in two different questions. `allowed` is the mask read as yes or no. The rule: no pair is both.

hypothesis tries shapes until the rule breaks, then shrinks the failure to `shape = (1, [1, 1, 1])`: one state token, three questions of one token each, parts `[0, 1, 2, 3]`. It is the request we drew by hand. We chose that size. hypothesis found it on its own:

```
allowed        siblings
# . . .        . . . .
# # . .        . . # #
# . # .        . # . #
# # . #        . # # .
```

Row 4, column 2 is yes in both: token 4, in question 3, may look at token 2, in question 1. The assert fails.

$ git restore src/babykev/model.py

---

## How we tested isolation

**Kind: integration**: packing, the model and the head, on the tiny model. We put step 05's mask line back first. `test_model.py`, lines 145 to 157:

$ perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = torch.ones_like(causal) | (s[None, :] == 0)/' src/babykev/model.py
$ sed -n '145,157p' tests/unit/test_model.py
$ just test -k a_question_cannot_see_its_sibling
$ git restore src/babykev/model.py

```python
def test_a_question_cannot_see_its_sibling(model, tok, record):
    before = logits_of(model, tok, record)
    changed = {**record, "questions": list(record["questions"])}
    changed["questions"][1] = {"instr": "Where from?", "options": ["Spain", "Italy"], "label": 0}
    after = logits_of(model, tok, changed)
    assert torch.equal(before[0], after[0])
    assert torch.equal(before[2], after[2])
    assert before[1].shape != after[1].shape
```

- `model`, `tok` and `record` are the fixtures of `conftest.py`: the tiny model, its tokenizer, and a request with three questions
- `logits_of` packs the request and gives, for each question, one score for each of its options
- We score the request, rewrite question 2, and score again. Questions 1 and 3 must get exactly the same scores. Question 2 must get a different number of scores: 3 options became 2
- With step 05's mask, the line for question 3 fails: before `[-0.2301, -0.2331, -0.2340]`, after `[-0.2266, -0.2302, -0.2312]`. Question 3 could look at question 2, so rewriting question 2 moved its scores. The line for question 1 passes: question 1 comes first and cannot look at what follows

---

## The tests see it, and the one-line fix

We put step 05's mask line back, and run all the tests:

$ perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = torch.ones_like(causal) | (s[None, :] == 0)/' src/babykev/model.py
$ just test

8 failed, 95 passed.

- The commit hook, from step 03, runs `just check`, and `just check` runs the tests. So this commit would now be refused
- At step 05 the same commit went through, because no test looked at the mask. `just check` refuses only what its tests can see

$ git restore src/babykev/model.py
$ sed -n '151p' src/babykev/model.py

```python
    same = (s[None, :] == s[:, None]) | (s[None, :] == 0)
```

A token may look at the state, or at its own question. Step 05 had `torch.ones_like(causal)` where the first part is.

---

## The smoke run on Qwen, again: 4 of 15

`just smoke local`, on the real model, Qwen2.5-0.5B, with the right mask:

$ just smoke local

- 6 of 15 with the wrong mask, 4 with the right one
- A pure guess on these fifteen questions expects 4.75 right: five yes-or-no, five of five options, five of four levels
- Untrained, the model guesses. With the wrong mask, some guesses were right for the wrong reason

---

## The type problem: two guards

$ sed -n '64,80p' src/babykev/model.py

```python
tok = AutoTokenizer.from_pretrained(name)
if not isinstance(tok, PreTrainedTokenizerBase):
    raise TypeError(f"{name} has no tokenizer this model can use")
return tok
...
ids = tok.convert_tokens_to_ids(SPECIAL)
return ids if isinstance(ids, list) else [ids]
```

- `load_tokenizer` checks what came back. If it is not a tokenizer, it stops with an error. So it never gives back `None`
- `delimiter_ids` is the one place that calls `convert_tokens_to_ids`. If the library gives one number, it makes a list of one. So it always gives back a list. `encode` and the tests call it, in place of the five calls ty complained about

$ just types

`just types` prints: All checks passed!

---

## ty joins `just check`

$ just --show check
$ just check

- `just check` now runs `just types` between `lint` and the tests
- The commit hook runs `just check`. So a commit with a type problem is refused, at ty, before the tests run
- At step 05 we could commit with six ty findings. From now on we cannot
