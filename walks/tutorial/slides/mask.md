## Every check passes, and the mask is wrong

```python
def branch_mask(seg, device, dtype=torch.float32):
    """Build the block-causal mask: a token sees the state and its own question, never a sibling."""
    ...
    causal = torch.tril(torch.ones(n, n, dtype=torch.bool, device=device))
    same = torch.ones_like(causal) | (s[None, :] == 0)
```

- The docstring states the rule. A token sees the state and its own question, and never another question
- The format, the linter, ty, the docs check and the tests all pass. `branch_mask` is covered at 100%
- No test has looked at what the mask allows
- Code can be right as software and wrong for its domain

---

## A picture of the mask of a small request

A state of two tokens, and two questions of two tokens. Row i is token i, column j is token j. `#` is allowed.

```
picture    the mask
#.....     #.....
##....     ##....
###...     ###...
####..     ####..
##..#.     #####.
##..##     ######
```

- Rows 5 and 6 are the tokens of question 2. They must not see columns 3 and 4, the tokens of question 1
- The mask lets them. Question 2 sees question 1

---

## hypothesis: state the rule, and let it try the shapes

```python
shapes = st.tuples(st.integers(1, 6), st.lists(st.integers(1, 5), max_size=4))

@given(shapes)
def test_no_question_sees_another_question(shape): ...
```

- `shapes` draws a request, with a state of 1 to 6 tokens, then up to 4 questions of 1 to 5 tokens
- `@given(shapes)` runs the test on up to 100 shapes
- When a shape breaks the rule, hypothesis tries smaller ones, and reports the smallest, `(1, [1, 1])`
- The rules are that no question sees another, that no token sees a later token, and that the mask is exactly the rule

---

## Isolation, on the tiny model

| Test | What it checks | With the old mask |
|---|---|---|
| a question cannot see its sibling | rewrite question 2, and questions 1 and 3 keep their answers | question 3 moves |
| packed questions answer as alone | three questions in one pass, against three passes | question 2 differs |
| the order does not matter | the questions in the reverse order | question 1 differs |

- Each runs the packing, the mask, the backbone and the head together. They are integration tests
- The tiny model stands in for the real one, so they are hermetic

---

## A fix for one size

```python
same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)
```

- It blocks only the question just before. The picture passes, and so does the test of the siblings
- hypothesis shrinks the failure to `(1, [1, 1, 1])`. With three questions, question 3 sees question 1

```
allowed    siblings
#...       ....
##..       ..##
#.#.       .#.#
##.#       .##.
```

- The picture had two questions, so it could not tell. The rule holds for every shape

---

## The fix, and the smoke again

```python
same = (s[None, :] == s[:, None]) | (s[None, :] == 0)
```

- A token sees the state, or its own question. Every test passes
- `just smoke`: `4 of 15 right`, where it said `6 of 15` with the old mask
- The first question of each request keeps its answer. It saw only the state with either mask
- With the old mask, questions 2 and 3 read the questions before them. An untrained model guesses, so neither count is
  better
