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

## One line that only a test can reach

```
src/babykev/api.py           75      1    99%   107
```

```python
    n = len(p)
    if n == 1:
        return 1.0
```

- The fix added lines 106 and 107, the answer for a scale of one level
- A request cannot have such a scale, because a `Score` needs two levels at least
- So only a test that calls `score_confidence` itself runs line 107. The table above leaves that test out
- The test states the answer, that one level leaves nothing to doubt. A test written only to raise the number would hide the question
