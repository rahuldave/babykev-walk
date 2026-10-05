## Test properties, not examples

- **Isolation**: change question 2, and question 1's answer must not move
- **Packed equals separate**: three questions in one pass give the numbers of three passes
- **Order does not matter**
- **The mask's rule**, for any request: no token sees a later one, no question sees another

They hold for any weights, so the tiny model is enough.

---

## hypothesis: the computer finds the examples

- You state the rule. hypothesis generates hundreds of inputs and looks for one that breaks it
- When it finds one, it shrinks it to the smallest failing case
- On step 05's mask: 8 tests fail. The mask let a question read the questions before it

---

## The fix, and the gate

- One line of `branch_mask`: a token may see the context, or its own question
- ty's two findings guarded: `delimiter_ids`, and a check in `load_tokenizer`
- `just types` joins `just check`

A gate is only as good as the tests behind it. At step 05 this commit would have gone through.

---

## The smoke again: 4 of 15

- 6 of 15 with the wrong mask, 4 with the right one
- A pure guess on these fifteen questions expects 4.75 right: five yes-or-no, five of five options, five of four levels
- Untrained, the model guesses. With the wrong mask, some guesses were right for the wrong reason
