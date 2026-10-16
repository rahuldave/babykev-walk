<!-- Made by the walk skill's render.py from the facts of the walk. Do not edit it by hand: run just walk-update again. -->

# The model of babykev, explained

**Read the tutorial.** Each change explained, with the code to look at. [Build it yourself](build.md) is the other way to read it.

Each part ends with a section called **What changed**. It lists every file that the part changes, with a link to the file, and then the whole diff of each file, folded. A lockfile and a binary file have a link alone. The text above it explains the change.

This walk explains the model of babykev to a reader who knows what a transformer decoder looks like. It reads the
architecture first, and then the code that builds it, with the tests that check each part. The model reads a
request about one cheese, and answers several questions about it in one pass. It points at one option for each
question, and it generates no text.

We take the code in moves. A move is one small change, made by one patch or by one command. You make each move, and
the page checks your files against it. Most moves of this walk add one test. The text around them explains the part
of the model that the test checks.

The walk takes some moves of the whole tutorial of babykev, and leaves out the rest. When it opens, babykev already
has a command line, the contract of a request, and the packages of the model, torch, transformers and peft. Some
moves between the parts of this walk are left out too. After such a gap, the next part says what those moves did. It
first runs `just setup`, which installs the packages of the code at that place.

A decoder, such as the base model Qwen2.5-0.5B, reads a sequence of tokens. Each token attends only to the tokens
before it, by a causal mask. Token n has position n. At the end, a vocabulary head gives one logit for every token of
the vocabulary, and the decoder generates the next token from them. The model of babykev keeps the layers of the
decoder, and changes four things around them:

| Idea | In a plain decoder | In the model of babykev | Code |
|---|---|---|---|
| Packing | One text | The state and every question in one sequence, marked by five delimiter tokens | `encode`, `user_tokens` |
| The mask | Causal | Block-causal: a token sees the state and its own question | `branch_mask` |
| Positions | 0, 1, 2, and on | Each question starts again right after the state | `encode` |
| The head | One logit for each token of the vocabulary | One logit for each option of a question | `PointerHead` |

`DecisionModel` puts the four together around the backbone. The tests run it on a tiny model, built in memory, with
the same code as the real one. The walk uses one small request all along, a state `ab` and a question `x?` with the
options `n` and `y`. It packs the question twice, so that the two copies can be compared.

<a id="tut-16.1"></a>

## 16.1 The model, and the decoder under it

```bash
just setup
```

`just setup` prints `Resolved 66 packages`. The model is one file, `src/babykev/model.py`. It comes in whole, and we
read its docstring first.

[The code before this part](https://github.com/rahuldave/babykev/tree/c7037ec460963acd41edf1f63a6a03d2e52e5bae). [The code after it](https://github.com/rahuldave/babykev/tree/c4c288ccc7e47190fd3d3340cbbbb7cf63b77d93).

### 16.1 model.py, the model

`model.py` turns a language model into a model that decides. It has 274 lines, and four ideas, which its docstring
names. The file comes in whole, as a patch.

A patch to [`src/babykev/model.py`](#tut-16.1-src-babykev-model.py-a86a0b).

`src/babykev/model.py` is new, with 274 lines. The docstring of the module is on lines 1 to 18. The functions that
pack a record are on lines 78 to 142, and the mask is on lines 145 to 162. The head is on lines 165 to 184, and
`DecisionModel` on lines 187 to 274.

```bash
sed -n '1,18p' src/babykev/model.py
```

The four ideas are packing, the mask, the restarted positions and pointing. Packing writes the state and every
question into one sequence of tokens. The mask lets each token see the state and its own question, and never another
question. The positions of each question start right after the state. The head points at an option, and the model
generates no text.

```bash
sed -n '34,54p' src/babykev/model.py
```

Line 37, `SPECIAL`, lists the five delimiters, special tokens that the base model already has. Line 38 sets the
longest state, 384 tokens, and the longest state and question together, 1024. The `TypedDict` `Encoded`, on lines 45
to 53, is a packed record. Each key has a type and a docment.

```bash
sed -n '145,162p' src/babykev/model.py
```

The docstring of `branch_mask`, on lines 150 to 155, gives the rule. Token i may look at token j when j is not after
i, and j is in the state or in the question of i. The mask is added to the scores of the attention, so a blocked pair
gets the most negative number of its type.

```bash
sed -n '187,219p' src/babykev/model.py
```

`DecisionModel` loads a backbone from the Hub, on lines 200 to 205, if the caller gives none. The parameter
`backbone`, on line 195, is there for the tests. With `lora`, peft wraps the backbone in an adapter, on lines 208 to
216. The head comes last, on line 217.

The file is formatted, typed and documented, so the gate has nothing to say about it.

```bash
just fmt --check
just lint
just docs check
```

`just fmt --check` prints `7 files already formatted`, and `just lint` prints `All checks passed!`. `just docs check`
prints a note of torch, `NOTE: Redirects are currently not supported in MacOs.` smalldocs imports `model.py` to
read it. On a Mac, the import of peft makes torch print the note, and it is not an error. The note goes to the
standard error, so where it shows among the other lines can vary. `just docs check` also prints
`babykev.model 15 of 15`, and `60 of 60 functions, methods and classes are typed and documented`.

```bash
just test
```

`just test` prints `53 passed`, and the coverage falls. `model.py` has 109 statements at 0%, and the column Missing
says `20-274`. No test imports `model.py`, and `--cov=babykev` still counts every file of the package. The total is
43%, 83 of 192 statements, where it was 100%, 83 of 83. `just check` has no floor on the coverage, so it passes. The
tests of the model come later, and bring the coverage back.

The backbone is the decoder of Qwen2.5-0.5B. Its configuration says how large it is.

```bash
uv run python -c "from transformers import AutoConfig; c = AutoConfig.from_pretrained('Qwen/Qwen2.5-0.5B'); print(c.num_hidden_layers, c.hidden_size, c.vocab_size)"
```

It prints `24 896 151936`. The decoder has 24 layers, and each token is a vector of 896 numbers between them. The
vocabulary has 151936 tokens, so a vocabulary head gives 151936 logits at each place. `transformers` fetches the
configuration from the Hugging Face Hub the first time, and keeps it.

`DecisionModel` keeps the layers and drops the vocabulary head. Line 205, in the output of `sed -n '187,219p'` above,
is `backbone = lm.model`. `lm` is the whole decoder, and `lm.model` is the decoder without its head. The method
`hidden` runs the layers.

```bash
sed -n '231,241p' src/babykev/model.py
```

Line 241 calls the backbone with three arguments, and a decoder of transformers takes all three. `input_ids` are the
tokens, `position_ids` are their positions, and `attention_mask` says which token may attend to which. Packing gives
the tokens and the positions, and `branch_mask` gives the mask. So three of the four ideas change only what goes into
the decoder, and the layers stay as they are. The fourth idea reads `last_hidden_state`, the vectors that come out.

#### What changed

- <a id="tut-16.1-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: the model. It packs a request into tokens, masks it, and points at the options. New, 274 lines. [The file](https://github.com/rahuldave/babykev/blob/c4c288ccc7e47190fd3d3340cbbbb7cf63b77d93/src/babykev/model.py).
  - look at `class DecisionModel(nn.Module):`

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

```diff
@@ -0,0 +1,274 @@
+"""The model: a language model that reads a packed request, and a head that points at options.
+
+Four ideas make a language model into a decision model.
+
+1. **Packing.** `encode` writes the state and every question into one sequence of tokens. Five
+   delimiter tokens mark the parts: the state, a question, the start and the end of an option, and
+   the place where the question is decided.
+2. **The mask.** `branch_mask` lets each token see the state and its own question, and never another
+   question. The questions share one reading of the state and cannot influence each other.
+3. **Positions restart.** Each question's positions begin right after the state, so a question looks
+   the same to the model wherever it comes in the request.
+4. **Pointing.** `PointerHead` scores each option's closing token against the question's decide
+   token. The model has no vocabulary head and generates nothing.
+
+`DecisionModel` puts them together around a backbone, with a LoRA adapter if asked for. It reads
+several records in one pass: they are padded to the same length, and the padding is given a segment
+of its own, so the mask that keeps questions apart keeps every real token away from it too.
+"""
+
+import math
+import re
+from typing import Any, TypedDict
+
+import torch
+from peft import LoraConfig, get_peft_model
+from torch import nn
+from transformers import (
+    AutoModelForCausalLM,
+    AutoTokenizer,
+    PreTrainedModel,
+    PreTrainedTokenizerBase,
+)
+
+# The delimiters are special tokens the base model already has and rarely uses, in this order:
+# state, question, option start, option end, decide. No embedding has to be added or trained for
+# them; the adapter learns their new meaning.
+SPECIAL = ["<|fim_prefix|>", "<|fim_middle|>", "<|box_start|>", "<|box_end|>", "<|fim_suffix|>"]
+MAX_STATE, MAX_BRANCH = 384, 1024
+LORA_TARGETS = ["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"]
+PAD_SEGMENT = -1  # The segment of padding. No real token is in it, so none can attend to it
+
+_SPECIAL_RE = re.compile(r"<\|([A-Za-z0-9_]+)\|>")
+
+
+class Encoded(TypedDict):
+    """One packed record, ready for the model."""
+
+    ids: list[int]  # The token ids of the whole sequence
+    seg: list[int]  # The segment of each token: 0 for the state, k for question k
+    pos: list[int]  # The position of each token; every question restarts right after the state
+    decide_idx: list[int]  # For each question, where its decide token is
+    opt_idx: list[list[int]]  # For each question, where the closing token of each option is
+    labels: list[int]  # For each question, the index of the right option
+
+
+def pick_device(
+    override: str | None = None,  # A device name to use whatever the machine has
+) -> str:  # `cuda`, `mps` or `cpu`
+    """Choose where the model runs: a CUDA GPU if there is one, then Apple's GPU, then the CPU."""
+    if override:
+        return override
+    if torch.cuda.is_available():
+        return "cuda"
+    return "mps" if torch.backends.mps.is_available() else "cpu"
+
+
+def load_tokenizer(
+    name: str,  # A model name on the Hugging Face Hub, or a local folder
+    revision: str | None = None,  # The commit of the model to use; `None` for the latest
+) -> PreTrainedTokenizerBase:  # Its tokenizer
+    """Load the tokenizer that belongs to a base model."""
+    tok = AutoTokenizer.from_pretrained(name, revision=revision)
+    if not isinstance(tok, PreTrainedTokenizerBase):
+        raise TypeError(f"{name} has no tokenizer this model can use")
+    return tok
+
+
+def delimiter_ids(
+    tok: PreTrainedTokenizerBase,  # The base model's tokenizer
+) -> list[int]:  # The ids of the five delimiters, in the order of `SPECIAL`
+    """Look up the token ids of the delimiters."""
+    ids = tok.convert_tokens_to_ids(SPECIAL)
+    return ids if isinstance(ids, list) else [ids]
+
+
+def user_tokens(
+    tok: PreTrainedTokenizerBase,  # The base model's tokenizer
+    text: str,  # Text that came from a caller: a state, an instruction or an option
+) -> list[int]:  # Its token ids, none of which is a delimiter or any other special token
+    """Tokenize a caller's text so that it can never forge a delimiter.
+
+    A tokenizer turns the string `<|box_end|>` into the special token of that name, wherever the
+    string appears. Text that contained it could close an option early. So `<|name|>` is rewritten
+    to `<¦name¦>` before tokenizing, which reads the same to a person and is ordinary text to the
+    tokenizer.
+    """
+    return tok(_SPECIAL_RE.sub(r"<¦\1¦>", text), add_special_tokens=False).input_ids
+
+
+def encode(
+    tok: PreTrainedTokenizerBase,  # The base model's tokenizer
+    rec: dict[str, Any],  # A record, as `to_record` returns it: a state and its questions
+    max_state: int = MAX_STATE,  # The longest state allowed, in tokens
+    max_branch: int = MAX_BRANCH,  # The longest state and question together, in tokens
+) -> Encoded:  # The packed record
+    """Pack a record into one sequence: the state, then one branch for each question.
+
+    The state is the state delimiter and its text. A branch is the question delimiter, the
+    instruction, each option between its two delimiters, and the decide delimiter.
+
+    Raises `ValueError` when the state is longer than `max_state` or a branch does not fit in
+    `max_branch`. Nothing is cut to fit: a record that is too long is refused, by name.
+    """
+    s_id, q_id, o_id, c_id, d_id = delimiter_ids(tok)
+    state = [s_id] + user_tokens(tok, rec["state"])
+    if len(state) > max_state:
+        raise ValueError(f"state too long: {len(state)} tokens, the limit is {max_state}")
+    ids, seg, pos = list(state), [0] * len(state), list(range(len(state)))
+    decide_idx, opt_idx = [], []
+    for k, q in enumerate(rec["questions"], start=1):
+        br = [q_id] + user_tokens(tok, q["instr"])
+        oi = []
+        for o in q["options"]:
+            br += [o_id] + user_tokens(tok, o) + [c_id]
+            oi.append(len(br) - 1)
+        br.append(d_id)
+        if len(br) > max_branch - len(state):
+            raise ValueError(f"branch too long: {len(br)}")
+        base = len(ids)
+        ids += br
+        seg += [k] * len(br)
+        pos += list(range(len(state), len(state) + len(br)))
+        decide_idx.append(base + len(br) - 1)
+        opt_idx.append([base + i for i in oi])
+    return {
+        "ids": ids,
+        "seg": seg,
+        "pos": pos,
+        "decide_idx": decide_idx,
+        "opt_idx": opt_idx,
+        "labels": [q["label"] for q in rec["questions"]],
+    }
+
+
+def branch_mask(
+    seg: list[int],  # The segment of each token: 0 for the state, k for question k
+    device: str,  # Where to build the mask
+    dtype: torch.dtype = torch.float32,  # The number type of the model's attention scores
+) -> torch.Tensor:  # Shape [1, 1, n, n]: 0 where i may attend to j, very negative elsewhere
+    """Build the block-causal mask: a token sees the state and its own question, never a sibling.
+
+    Token i may attend to token j when j is not after i, and j is in the state or in the same
+    question as i. The mask is added to the attention scores, so a blocked pair gets the most
+    negative number the type can hold.
+    """
+    s = torch.tensor(seg, device=device)
+    n = len(seg)
+    causal = torch.tril(torch.ones(n, n, dtype=torch.bool, device=device))
+    same = torch.ones_like(causal) | (s[None, :] == 0)
+    allow = causal & same
+    blocked = torch.finfo(dtype).min
+    return torch.zeros(n, n, dtype=dtype, device=device).masked_fill(~allow, blocked)[None, None]
+
+
+class PointerHead(nn.Module):
+    """Scores the options of one question against its decide token."""
+
+    def __init__(
+        self,
+        d: int,  # The width of the backbone's hidden states
+        dp: int = 256,  # The width of the space in which options and decide tokens are compared
+    ) -> None:
+        """Make the two projections, one for decide tokens and one for options."""
+        super().__init__()
+        self.q, self.k = nn.Linear(d, dp), nn.Linear(d, dp)
+        self.scale = 1 / math.sqrt(dp)
+
+    def forward(
+        self,
+        h_decide: torch.Tensor,  # The hidden state at the decide token, shape [d]
+        h_opts: torch.Tensor,  # The hidden states at the K options' closing tokens, shape [K, d]
+    ) -> torch.Tensor:  # One logit per option, shape [K]
+        """Project both sides and take their scaled dot products."""
+        return (self.k(h_opts) @ self.q(h_decide)) * self.scale
+
+
+class DecisionModel(nn.Module):
+    """A language model without its vocabulary head, read through a mask, with a `PointerHead`."""
+
+    def __init__(
+        self,
+        name: str,  # The base model to load from the Hugging Face Hub, when no backbone is given
+        device: str,  # Where the model runs: `cuda`, `mps` or `cpu`
+        lora: int | None = None,  # The rank of a LoRA adapter to add, or `None` for no adapter
+        backbone: PreTrainedModel | None = None,  # A ready backbone, such as a small one in tests
+        revision: str | None = None,  # The commit of the base model to load; `None` for the latest
+    ) -> None:
+        """Load or take the backbone, wrap it in an adapter if asked, and add the head."""
+        super().__init__()
+        if backbone is None:
+            # Only the transformer is kept. The vocabulary head is dropped: nothing is generated.
+            lm = AutoModelForCausalLM.from_pretrained(
+                name, revision=revision, dtype=torch.float32, attn_implementation="eager"
+            )
+            backbone = lm.model
+        width: int = backbone.config.hidden_size
+        self.lm: nn.Module = backbone
+        if lora:
+            cfg = LoraConfig(
+                task_type="FEATURE_EXTRACTION",
+                r=lora,
+                lora_alpha=2 * lora,
+                lora_dropout=0.05,
+                target_modules=LORA_TARGETS,
+            )
+            self.lm = get_peft_model(self.lm, cfg)
+        self.head = PointerHead(width)
+        self.device = device
+        self.to(device)
+
+    def hidden(
+        self,
+        encs: list[Encoded],  # Packed records
+    ) -> torch.Tensor:  # The hidden state of every token of every record, shape [B, n, d]
+        """Run the backbone over packed records in one pass, each with its positions and its mask.
+
+        The records are padded to the length of the longest. Padding is in `PAD_SEGMENT`, which
+        `branch_mask` treats as one more question: no real token attends to it, and what the
+        model computes at a padded place is never read.
+        """
+        longest = max(len(enc["ids"]) for enc in encs)
+        ids = torch.zeros(len(encs), longest, dtype=torch.long, device=self.device)
+        pos = torch.zeros_like(ids)
+        masks = []
+        for b, enc in enumerate(encs):
+            n = len(enc["ids"])
+            ids[b, :n] = torch.tensor(enc["ids"], device=self.device)
+            pos[b, :n] = torch.tensor(enc["pos"], device=self.device)
+            masks.append(branch_mask(enc["seg"] + [PAD_SEGMENT] * (longest - n), self.device)[0])
+        mask = torch.stack(masks)
+        return self.lm(input_ids=ids, position_ids=pos, attention_mask=mask).last_hidden_state
+
+    def forward_batch(
+        self,
+        encs: list[Encoded],  # Packed records
+    ) -> list[list[torch.Tensor]]:  # For each record, for each question, one logit per option
+        """Score every option of every question of several records in one pass."""
+        h = self.hidden(encs)
+        return [
+            [
+                self.head(h[b, d], h[b, torch.tensor(oi, device=self.device)])
+                for d, oi in zip(enc["decide_idx"], enc["opt_idx"], strict=True)
+            ]
+            for b, enc in enumerate(encs)
+        ]
+
+    def forward(
+        self,
+        enc: Encoded,  # A packed record
+    ) -> list[torch.Tensor]:  # For each question, one logit per option
+        """Score every option of every question of one record."""
+        return self.forward_batch([enc])[0]
+
+    @torch.no_grad()
+    def probs(
+        self,
+        enc: Encoded,  # A packed record
+    ) -> list[torch.Tensor]:  # For each question, the probability of each option, on the CPU
+        """Answer without tracking gradients: the logits of `forward` turned into probabilities."""
+        return [torch.softmax(z, -1).cpu() for z in self.forward(enc)]
+
+    def trainable_parameters(self) -> list[nn.Parameter]:  # The adapter's and the head's
+        """List the parameters that training changes."""
+        return [p for p in self.parameters() if p.requires_grad]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c4c288ccc7e47190fd3d3340cbbbb7cf63b77d93). [The code after it](https://github.com/rahuldave/babykev/tree/c4c288ccc7e47190fd3d3340cbbbb7cf63b77d93).

<a id="tut-19.8"></a>

## 19.8 A tiny model for the tests

```bash
just setup
```

`just setup` prints `Resolved 67 packages`. Since the last part, the walk leaves out three groups of moves. ty, a
checker of types, came in, and two comments in `model.py` answer it. The smoke run came in. It loads the real
model, asks it the questions of a sample file, and prints how many it got right. Then the tests got a tiny tokenizer
and a tiny backbone, in `tests/tiny.py`, and three fixtures, in `tests/conftest.py`.

A test of the model checks something exact, such as which token is where, or which weights get a gradient. That holds
for any weights. So the tests need no trained model, and no download. The tiny backbone is the same class as the
real one, with small sizes.

```bash
sed -n '27,42p' tests/tiny.py
```

`tiny_backbone` builds `Qwen2Model`, the class of the real backbone, with 2 layers of 32 numbers, on lines 35 and 37.
The real one has 24 layers of 896. The weights are random, from the seed on line 32, so they are the same at every
run.

```bash
uv run python -c "from tests.tiny import tiny_tokenizer; t = tiny_tokenizer(); print(len(t), t.tokenize('ab<|fim_suffix|>'))"
```

The tiny tokenizer has `106` tokens, one for each printable character, the five delimiters, and `[UNK]` for any
other character. It splits `ab<|fim_suffix|>` into `['a', 'b', '<|fim_suffix|>']`. Like the real tokenizer, it turns
the text of a delimiter into the delimiter. A later part shows why that is a danger.

```bash
sed -n '22,27p' tests/conftest.py
```

The fixture `model` is a `DecisionModel` on the tiny backbone, on the CPU. The code that runs is the real
`DecisionModel`. Only the backbone and the tokenizer under it are small.

[The code before this part](https://github.com/rahuldave/babykev/tree/b4bf2491e8505697eaa015738f93178c6bd7f3fc). [The code after it](https://github.com/rahuldave/babykev/tree/321a8df2c597e0c46d06c9b36c711f0fe270900a).

### 19.8 The first test of the model

The first test asks for the three fixtures. It packs the record with the tiny tokenizer, and runs the tiny model and
the head. Each question gets one probability per option, and they sum to 1. Nothing is trained, so the probabilities
mean nothing. The test checks what is true of any probabilities.

A patch to [`tests/unit/test_model.py`](#tut-19.8-tests-unit-test_model.py-583145).

The new file `tests/unit/test_model.py` has one test, on lines 11 to 20.

```bash
sed -n '11,20p' tests/unit/test_model.py
just test -k probabilities_sum
```

The test never says "tiny". It names `model`, `tok` and `record`, and pytest passes them in. The code that runs is our
`DecisionModel`. Only the backbone and the tokenizer under it are small. `[2, 3, 3]` on line 18 is known in advance,
because the record of the fixture has questions of 2, 3 and 3 options. `just test -k probabilities_sum` prints
`1 passed, 53 deselected`.

```bash
just test --fixtures-per-test -k probabilities_sum
```

`--fixtures-per-test` names the fixtures of each test, and where each is defined. The test gets `model`, `record` and
`tok`, each with its line in `conftest.py`.

```bash
just test
```

`just test` prints `54 passed`. `model.py` is at 85%, and the total at 67%, 178 of 267. One test runs the
packing, the mask, the backbone and the head.

In tut-19.5, before this test, `model.py` was at 33%, and the total at 45%.

Every test in the rest of this walk asks for these fixtures, and runs on the tiny model.

#### What changed

- <a id="tut-19.8-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the first test of the model, on the tiny model. New, 20 lines. [The file](https://github.com/rahuldave/babykev/blob/321a8df2c597e0c46d06c9b36c711f0fe270900a/tests/unit/test_model.py).
  - look at `def test_probabilities_sum_to_one_for_every_question(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -0,0 +1,20 @@
+"""Tests of the model, on the tiny model."""
+
+from typing import Any
+
+import pytest
+from transformers import PreTrainedTokenizerFast
+
+from babykev.model import DecisionModel, encode
+
+
+def test_probabilities_sum_to_one_for_every_question(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Each question gets one probability per option, and they sum to 1."""
+    probs = model.probs(encode(tok, record))
+    assert [len(p) for p in probs] == [2, 3, 3]
+    for p in probs:
+        assert p.sum().item() == pytest.approx(1)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/321a8df2c597e0c46d06c9b36c711f0fe270900a). [The code after it](https://github.com/rahuldave/babykev/tree/321a8df2c597e0c46d06c9b36c711f0fe270900a).

<a id="tut-20.1"></a>

## 20.1 Packing a request into one sequence

```bash
just setup
```

`just setup` prints `Resolved 67 packages`. Since the last part, the walk leaves out one row of the README.

A request has a state, which says what is known about the cheese, and several questions. Each question has an
instruction and its options. The model reads the state once, and answers every question in the same pass. So
`encode` writes the state and every question into one sequence, and five delimiter tokens mark the parts.

```bash
sed -n '34,38p' src/babykev/model.py
```

`SPECIAL`, on line 37, lists the five delimiters. In their order, they mark the state, a question, the start of an
option, the end of an option, and the place of the decision. They are special tokens that the base model already has and
rarely uses. So no embedding has to be added. Line 38 sets the longest state, 384 tokens, and the longest state and
question together, 1024.

```bash
uv run python -c "from tests.tiny import tiny_tokenizer; from babykev.model import encode; t = tiny_tokenizer(); q = {'instr': 'x?', 'options': ['n', 'y'], 'label': 1}; e = encode(t, {'state': 'ab', 'questions': [q, q]}); print(*enumerate(zip(t.convert_ids_to_tokens(e['ids']), e['seg'], e['pos'])), sep='\n'); print(e['decide_idx'], e['opt_idx'])"
```

The command packs the small request, with the question twice, and prints a line for each token. Each line has the
place of the token, the token, its segment and its position. The first 13 lines are the state and question 1:

| Place | Token | Segment | Position |
|---|---|---|---|
| 0 | the state delimiter | 0 | 0 |
| 1, 2 | `a`, `b` | 0 | 1, 2 |
| 3 | the question delimiter | 1 | 3 |
| 4, 5 | `x`, `?` | 1 | 4, 5 |
| 6 to 8 | the start of an option, `n`, the end of an option | 1 | 6 to 8 |
| 9 to 11 | the start of an option, `y`, the end of an option | 1 | 9 to 11 |
| 12 | the decide delimiter | 1 | 12 |

Lines 13 to 22 are question 2, with the same tokens, in segment 2. The segment says which part a token belongs to, 0
for the state and k for question k. The last line prints `[12, 22]`, the place of each decide token, and
`[[8, 11], [18, 21]]`, the place of the closing token of each option. The head reads the vectors at these places.

```bash
sed -n '114,134p' src/babykev/model.py
```

`encode` builds the state on line 115, and each branch in the loop of lines 120 to 134. A branch is a question with
its delimiters. Line 124 puts each option between its two delimiters, and line 125 notes the place of its closing
token. Line 126 adds the decide token. Line 131 gives the branch its segment, and line 132 its positions. The tests
check the whole sequence, token by token.

[The code before this part](https://github.com/rahuldave/babykev/tree/88b3a9e08db851ce891ecfcfcf26d18892beea90). [The code after it](https://github.com/rahuldave/babykev/tree/6d2401817f1bc2d56de4f3021cfceaa80d5b80f9).

### 20.1 Packing marks every part with its delimiter

The test packs a small record, the state `ab` and one question `x?` with the options `n` and `y`. With one token per
character, it can write down every token that it expects.

A patch to [`tests/unit/test_model.py`](#tut-20.1-tests-unit-test_model.py-583145).

In `tests/unit/test_model.py`, the new test is on lines 23 to 35.

```bash
sed -n '23,35p' tests/unit/test_model.py
just test -k packing_marks
```

The list on line 31 is the whole sequence. It has the state delimiter and `a`, `b`, then the question delimiter and
`x`, `?`. Each option is between its two delimiters, and the decide delimiter comes last. Line 32 gives the segment of each token, 0 for the state
and 1 for the question. `just test -k packing_marks` prints `1 passed`.

With `-k`, the table of coverage counts only the tests that ran. This test alone runs 54% of `model.py`.

```bash
just test
```

`just test` prints `55 passed`. The total stays at 67%, and `model.py` at 85%, with the same 16 lines missing. The
test of the probabilities ran `encode` already, and checked none of its tokens. The coverage counts the lines that
run, and not what a test checks.

#### What changed

- <a id="tut-20.1-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the tokens of a packed record. 16 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/6d2401817f1bc2d56de4f3021cfceaa80d5b80f9/tests/unit/test_model.py).
  - look at `def test_packing_marks_every_part_with_its_delimiter(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -5,7 +5,7 @@ from typing import Any
 import pytest
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import DecisionModel, encode
+from babykev.model import DecisionModel, delimiter_ids, encode
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -18,3 +18,18 @@ def test_probabilities_sum_to_one_for_every_question(
     assert [len(p) for p in probs] == [2, 3, 3]
     for p in probs:
         assert p.sum().item() == pytest.approx(1)
+
+
+def test_packing_marks_every_part_with_its_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+) -> None:
+    """A packed record is the state, then each question with its options and its decide token."""
+    s, q, o, c, d = delimiter_ids(tok)
+    record = {"state": "ab", "questions": [{"instr": "x?", "options": ["n", "y"], "label": 1}]}
+    enc = encode(tok, record)
+    a, b, x, mark, n, y = (tok.convert_tokens_to_ids(ch) for ch in "abx?ny")
+    assert enc["ids"] == [s, a, b, q, x, mark, o, n, c, o, y, c, d]
+    assert enc["seg"] == [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
+    assert enc["decide_idx"] == [12]
+    assert enc["opt_idx"] == [[8, 11]]
+    assert enc["labels"] == [1]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/6d2401817f1bc2d56de4f3021cfceaa80d5b80f9). [The code after it](https://github.com/rahuldave/babykev/tree/6d2401817f1bc2d56de4f3021cfceaa80d5b80f9).

<a id="tut-20.2"></a>

## 20.2 Positions that start again after the state

```bash
just setup
```

`just setup` prints `Resolved 67 packages`. A plain decoder gives token n the position n. `encode` gives each question
the positions right after the state, on line 132.

```bash
uv run python -c "from tests.tiny import tiny_tokenizer; from babykev.model import encode; t = tiny_tokenizer(); q = {'instr': 'x?', 'options': ['n', 'y'], 'label': 1}; e = encode(t, {'state': 'ab', 'questions': [q, q]}); print(e['seg']); print(e['pos'])"
```

The first list is the segment of each token, and the second is its position. The state has the positions 0 to 2.
Question 1 has 3 to 12, and question 2 has 3 to 12 again, where a plain decoder would give it 13 to 22.

So question 2 has the same tokens and the same positions as question 1. If it also sees the same tokens, the state
and itself, the decoder computes the same numbers for it. A question then gets the same answer wherever it sits in
the request, and the same answer as in a request of its own. The positions do half of that work, and the mask does
the other half, in the last part of this walk.

[The code before this part](https://github.com/rahuldave/babykev/tree/6d2401817f1bc2d56de4f3021cfceaa80d5b80f9). [The code after it](https://github.com/rahuldave/babykev/tree/e947449de17438d3aa5ee006bfc98db3944d4457).

### 20.2 Positions restart after the state

The positions of each question begin right after the state, so a question looks the same wherever it comes.

A patch to [`tests/unit/test_model.py`](#tut-20.2-tests-unit-test_model.py-583145).

In `tests/unit/test_model.py`, the new test is on lines 38 to 47.

```bash
just test -k positions_restart
```

pytest prints `1 passed, 55 deselected`.

```bash
sed -n '38,47p' tests/unit/test_model.py
```

The test packs the record of the fixture, which has three questions. Line 44 counts the tokens of the state. Lines 45
to 47 check that the positions of each question run from that count upward.

#### What changed

- <a id="tut-20.2-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the positions of each question. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/e947449de17438d3aa5ee006bfc98db3944d4457/tests/unit/test_model.py).
  - look at `def test_positions_restart_after_the_state(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -33,3 +33,15 @@ def test_packing_marks_every_part_with_its_delimiter(
     assert enc["decide_idx"] == [12]
     assert enc["opt_idx"] == [[8, 11]]
     assert enc["labels"] == [1]
+
+
+def test_positions_restart_after_the_state(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Every question starts at the position right after the state, wherever it comes."""
+    enc = encode(tok, record)
+    state_length = enc["seg"].count(0)
+    for k in (1, 2, 3):
+        positions = [p for p, s in zip(enc["pos"], enc["seg"], strict=True) if s == k]
+        assert positions == list(range(state_length, state_length + len(positions)))
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e947449de17438d3aa5ee006bfc98db3944d4457). [The code after it](https://github.com/rahuldave/babykev/tree/e947449de17438d3aa5ee006bfc98db3944d4457).

<a id="tut-20.5-to-tut-20.6"></a>

## 20.5 to 20.6 A caller's text cannot forge a delimiter

```bash
just setup
```

`just setup` prints `Resolved 67 packages`. Since the last part, the walk leaves out two tests. `encode` refuses a
state longer than its limit, and a branch that does not fit with the state, and names the length. It cuts nothing to
make a request fit.

The delimiters are special tokens. A tokenizer turns the text of a special token into the token, wherever the text
is. The state, the instructions and the options come from a caller. So an option with the text `<|fim_suffix|>` in it
would put a decide token in the middle of the question. `user_tokens` tokenizes a caller's text, and stops that.

```bash
sed -n '86,97p' src/babykev/model.py
```

Line 97 rewrites `<|name|>` to `<¦name¦>` before it tokenizes. The broken bar `¦` reads like `|` to a person, and it
is ordinary text to the tokenizer.

```bash
uv run python -c "from tests.tiny import tiny_tokenizer; from babykev.model import user_tokens; t = tiny_tokenizer(); print(t.tokenize('no<|fim_suffix|>')); print(t.convert_ids_to_tokens(user_tokens(t, 'no<|fim_suffix|>')))"
```

The tokenizer alone gives three tokens, `n`, `o` and the decide delimiter. `user_tokens` gives 16 ordinary tokens. The
tiny tokenizer has no token for `¦`, so it gives `[UNK]` there. The tokenizer of the base model has tokens for it.

[The code before this part](https://github.com/rahuldave/babykev/tree/e3b3ab01357c19f3325d481c80e67ad1f13c1522). [The code after it](https://github.com/rahuldave/babykev/tree/e30ea2eb52ae23815152f60b09d07d9d0dd1fd3a).

<a id="tut-20.5"></a>

### 20.5 A tokenizer alone would let text forge a delimiter

A caller writes the state, the instructions and the options. A tokenizer turns the text `<|fim_suffix|>` into the
decide token, wherever it is. So text could close an option early, or make a question of its own. This test shows the
danger, before the next test shows the defence.

A patch to [`tests/unit/test_model.py`](#tut-20.5-tests-unit-test_model.py-583145).

In `tests/unit/test_model.py`, the new test is on lines 68 to 73.

```bash
sed -n '68,73p' tests/unit/test_model.py
just test -k tokenizer_alone
```

The test tokenizes `yes<|fim_suffix|>` with the tokenizer alone, and finds the id of the decide delimiter among the
tokens. pytest prints `1 passed`. The danger is real.

#### What changed

- <a id="tut-20.5-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the danger, a forged delimiter. 9 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/1782e1e6803efd49be04e682f3453e39c1c2fc23/tests/unit/test_model.py).
  - look at `def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -5,7 +5,7 @@ from typing import Any
 import pytest
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import DecisionModel, delimiter_ids, encode
+from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -63,3 +63,11 @@ def test_a_state_that_does_not_fit_is_refused(
     """A state longer than the limit raises, and names its length and the limit."""
     with pytest.raises(ValueError, match="state too long: 62 tokens, the limit is 50"):
         encode(tok, record, max_state=50)
+
+
+def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+) -> None:
+    """The danger is real: tokenized directly, the text of a delimiter becomes that delimiter."""
+    decide = delimiter_ids(tok)[4]
+    assert decide in tok(f"yes{SPECIAL[4]}", add_special_tokens=False).input_ids
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1782e1e6803efd49be04e682f3453e39c1c2fc23). [The code after it](https://github.com/rahuldave/babykev/tree/1782e1e6803efd49be04e682f3453e39c1c2fc23).

<a id="tut-20.6"></a>

### 20.6 User text cannot forge a delimiter

`user_tokens` rewrites `<|name|>` to `<¦name¦>` before it tokenizes, so the text of a delimiter is ordinary text. The
test runs once for each of the five delimiters.

A patch to [`tests/unit/test_model.py`](#tut-20.6-tests-unit-test_model.py-583145).

In `tests/unit/test_model.py`, the new test is on lines 76 to 83.

```bash
just test -k forge
```

`-k forge` takes both tests, the danger and the defence. pytest prints `6 passed`, the danger once and the defence
five times.

```bash
just test
```

`just test` prints `64 passed`. `model.py` is at 87%, with 14 lines missing. The test of the
probabilities had run `user_tokens` already, and checked nothing about it.

The 14 lines are the same as at the end of tut-20.4, so the two new tests add no line to the coverage.

```bash
sed -n '76,83p' tests/unit/test_model.py
```

`@pytest.mark.parametrize`, on line 76, runs the test once for each of the five delimiters. Line 83 checks that no
token of the text is a delimiter.

#### What changed

- <a id="tut-20.6-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the defence, for each of the five delimiters. 11 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/e30ea2eb52ae23815152f60b09d07d9d0dd1fd3a/tests/unit/test_model.py).
  - look at `def test_user_text_cannot_forge_a_delimiter(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -5,7 +5,7 @@ from typing import Any
 import pytest
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode
+from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode, user_tokens
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -71,3 +71,13 @@ def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(
     """The danger is real: tokenized directly, the text of a delimiter becomes that delimiter."""
     decide = delimiter_ids(tok)[4]
     assert decide in tok(f"yes{SPECIAL[4]}", add_special_tokens=False).input_ids
+
+
+@pytest.mark.parametrize("delimiter", SPECIAL)
+def test_user_text_cannot_forge_a_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    delimiter: str,  # The text of one of the five delimiters
+) -> None:
+    """Through `user_tokens`, the text of a delimiter is only ever ordinary tokens."""
+    ids = user_tokens(tok, f"before {delimiter} after")
+    assert not set(ids) & set(delimiter_ids(tok))
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e30ea2eb52ae23815152f60b09d07d9d0dd1fd3a). [The code after it](https://github.com/rahuldave/babykev/tree/e30ea2eb52ae23815152f60b09d07d9d0dd1fd3a).

<a id="tut-20.7"></a>

## 20.7 A pointer head in place of the vocabulary head

```bash
just setup
```

`just setup` prints `Resolved 67 packages`. A decoder answers a question by generating the text of the answer, one
token at a time, from 151936 logits at each place. Here the options are already in the sequence. So the head only
has to point at one of them, and it gives one logit for each option, whatever the length of its text.

The head reads two kinds of place. In the small request, question 1 has its decide token at place 12, and its options
close at places 8 and 11. The closing token of option `y` has read the state, the instruction, both options and
itself, because the mask is causal. The decide token comes last, so it has read the whole question.

```bash
sed -n '165,186p' src/babykev/model.py
```

`PointerHead` has two linear maps, on line 175, from the width of the backbone to `dp`, 256 by default. `q` maps the
vector of the decide token, and `k` maps the vector of each option. Line 186 takes the dot product of each option with
the decide token, and scales it by one over the square root of 256. The head computes one row of attention. The
query comes from the decide token, a key comes from each option, and the scores are the logits. `probs` turns them
into probabilities with a softmax.

[The code before this part](https://github.com/rahuldave/babykev/tree/e30ea2eb52ae23815152f60b09d07d9d0dd1fd3a). [The code after it](https://github.com/rahuldave/babykev/tree/455b6a8ae64dae7e79fea6dd6b8434d11eb8f542).

### 20.7 The pointer head gives one logit per option

The head takes the hidden state of a decide token and those of the options, and gives one logit for each option. The
test builds a head alone, with no model, and gives it five options.

A patch to [`tests/unit/test_model.py`](#tut-20.7-tests-unit-test_model.py-583145).

In `tests/unit/test_model.py`, the new test is on lines 87 to 90.

```bash
just test -k pointer_head
```

pytest prints `1 passed`.

```bash
sed -n '87,90p' tests/unit/test_model.py
```

The test builds a head alone, of width 32 and `dp` 8, and gives it the vector of a decide token and five options. Line
90 checks that it gives five logits.

#### What changed

- <a id="tut-20.7-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: five options in, five logits out. 8 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/455b6a8ae64dae7e79fea6dd6b8434d11eb8f542/tests/unit/test_model.py).
  - look at `def test_pointer_head_gives_one_logit_per_option() -> None:`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -3,9 +3,10 @@
 from typing import Any
 
 import pytest
+import torch
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode, user_tokens
+from babykev.model import SPECIAL, DecisionModel, PointerHead, delimiter_ids, encode, user_tokens
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -81,3 +82,9 @@ def test_user_text_cannot_forge_a_delimiter(
     """Through `user_tokens`, the text of a delimiter is only ever ordinary tokens."""
     ids = user_tokens(tok, f"before {delimiter} after")
     assert not set(ids) & set(delimiter_ids(tok))
+
+
+def test_pointer_head_gives_one_logit_per_option() -> None:
+    """Five options in, five logits out."""
+    head = PointerHead(d=32, dp=8)
+    assert head(torch.randn(32), torch.randn(5, 32)).shape == (5,)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/455b6a8ae64dae7e79fea6dd6b8434d11eb8f542). [The code after it](https://github.com/rahuldave/babykev/tree/455b6a8ae64dae7e79fea6dd6b8434d11eb8f542).

<a id="tut-21.1-to-tut-21.2"></a>

## 21.1 to 21.2 DecisionModel, with an adapter, over several records

```bash
just setup
```

`just setup` prints `Resolved 67 packages`. Since the last part, the walk leaves out the tests of `pick_device`, which
chooses the GPU or the CPU. It also leaves out the tests of the smoke run and its command.

`DecisionModel` puts the backbone, the mask, the positions and the head together. With `lora`, it also wraps the
backbone in an adapter.

```bash
sed -n '39p;208,219p' src/babykev/model.py
```

LoRA, low-rank adaptation, leaves each weight of the backbone as it is. Beside a weight of shape out by in, it puts
two small matrices, `A` of r by in and `B` of out by r. Their product goes into the output. Lines 210 to
218 do it with peft, on the seven projections of `LORA_TARGETS`, line 39. r is the rank, the argument `lora`. peft freezes the
backbone, so training changes the adapter and the head, and nothing else.

[The code before this part](https://github.com/rahuldave/babykev/tree/ebfa2a8cee251782b3709a379c35af77c80c6170). [The code after it](https://github.com/rahuldave/babykev/tree/e6248c7e2cf3b6b45f11e0ecfdd7f25a23745aac).

<a id="tut-21.1"></a>

### 21.1 With an adapter, only the adapter and the head train

Training changes the adapter and the head, and the backbone stays as it is. The test makes a tiny model with an
adapter of rank 4, and takes one backward pass. Then it names every parameter that got a gradient. The fixture
`model` has no adapter, so the test calls `tiny_backbone` itself.

A patch to [`tests/unit/test_model.py`](#tut-21.1-tests-unit-test_model.py-583145).

In `tests/unit/test_model.py`, the import is on line 18, and the new test is on lines 112 to 130.

```bash
sed -n '112,130p' tests/unit/test_model.py
just test -k only_the_adapter
```

Line 127 checks that every parameter with a gradient is in the adapter, `lora_`, or in the head, `head.`. Lines 128 to
130 check that `trainable_parameters` lists exactly those. pytest prints `1 passed`.

```bash
just test --cov-fail-under=90
```

`--cov-fail-under=90` makes pytest fail when the total is under 90%. It prints `73 passed`, then `FAIL Required test
coverage of 90% not reached. Total coverage: 83.52%`, and ends with exit code 1. `model.py` is at 94%, and lines 211 to
218 and 277 have run. `smoke.py` is at 48%, and misses lines `35-36, 45-49, 78-92, 105-119`.

```bash
uv run python -c "from tests.tiny import tiny_tokenizer, tiny_backbone; from babykev.model import DecisionModel; m = DecisionModel('tiny', 'cpu', lora=4, backbone=tiny_backbone(len(tiny_tokenizer()))); print(sum(p.numel() for p in m.parameters()), sum(p.numel() for p in m.trainable_parameters()), sum(p.numel() for p in m.head.parameters()))"
```

It prints `45472 21248 16896`. The tiny model with an adapter of rank 4 has 45472 parameters, and 21248 of them
train. The head has 16896, two maps of 32 to 256 with their biases. The other 4352 are the adapter. For a weight
of 32 by 32, an adapter of rank 4 has 4 by 32 and 32 by 4. It has 256 numbers, where the weight has 1024.

`hidden` reads several records in one pass. The records have different lengths, so it pads each to the longest.

```bash
sed -n '233,243p' src/babykev/model.py
```

Line 234 makes a tensor of zeros, as long as the longest record, and line 239 writes the tokens of each record into
it. The positions of the padding stay 0. Line 241 gives the padding the segment `PAD_SEGMENT`, which is -1, on line
40. So the mask treats the padding as one more question. The padding comes after every real token, and the causal
part of the mask already keeps the real tokens from it. Nothing reads the vectors at the padding, because the head
reads only the places of `decide_idx` and `opt_idx`.

#### What changed

- <a id="tut-21.1-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: one backward pass with an adapter. 22 lines added. [The file](https://github.com/rahuldave/babykev/blob/0be44c1de17b8acb4e18a964a782584eb26fee97/tests/unit/test_model.py).
  - look at `def test_with_an_adapter_only_the_adapter_and_the_head_train(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -15,6 +15,7 @@ from babykev.model import (
     pick_device,
     user_tokens,
 )
+from tests.tiny import tiny_backbone
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -106,3 +107,24 @@ def test_pick_device_takes_an_override() -> None:
 def test_pick_device_finds_something_to_run_on() -> None:
     """With no override, the choice is one of the three kinds of device."""
     assert pick_device() in {"cuda", "mps", "cpu"}
+
+
+def test_with_an_adapter_only_the_adapter_and_the_head_train(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """The backbone is frozen: gradients reach the adapter and the pointer head, nothing else."""
+    model = DecisionModel("tiny", "cpu", lora=4, backbone=tiny_backbone(len(tok)))
+    enc = encode(tok, record)
+    labels = torch.tensor(enc["labels"])
+    losses = [
+        torch.nn.functional.cross_entropy(z[None], y[None])
+        for z, y in zip(model(enc), labels, strict=True)
+    ]
+    torch.stack(losses).sum().backward()
+    with_gradient = {name for name, p in model.named_parameters() if p.grad is not None}
+    assert with_gradient
+    assert all("lora_" in name or name.startswith("head.") for name in with_gradient)
+    assert {id(p) for p in model.trainable_parameters()} == {
+        id(p) for name, p in model.named_parameters() if name in with_gradient
+    }
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0be44c1de17b8acb4e18a964a782584eb26fee97). [The code after it](https://github.com/rahuldave/babykev/tree/0be44c1de17b8acb4e18a964a782584eb26fee97).

<a id="tut-21.2"></a>

### 21.2 Records of different lengths answer in one pass as alone

`forward_batch` reads several records in one pass. They are padded to the length of the longest. The test packs the
record of the fixture and a shorter record, and runs them in one pass. It compares each with a pass of its own.

A patch to [`tests/unit/test_model.py`](#tut-21.2-tests-unit-test_model.py-583145).

In `tests/unit/test_model.py`, the new test is on lines 133 to 146.

```bash
just test -k different_lengths
```

pytest prints `1 passed`. Line 241 builds the mask of each record, with its padding, and every test of the model has
run it. Only this test runs it with padding to build.

```bash
just test --cov-fail-under=90
```

pytest prints `74 passed`, and `Total coverage: 83.52%` again. The test adds no line to the coverage, and the floor
still fails.

The test compares to within `1e-5`, and not exactly. A padded pass multiplies larger matrices, and adds the same
numbers in another order. So the last bits of a float can differ.

#### What changed

- <a id="tut-21.2-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: a padded pass. 16 lines added. [The file](https://github.com/rahuldave/babykev/blob/e6248c7e2cf3b6b45f11e0ecfdd7f25a23745aac/tests/unit/test_model.py).
  - look at `def test_records_of_different_lengths_answer_in_one_pass_as_alone(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -128,3 +128,19 @@ def test_with_an_adapter_only_the_adapter_and_the_head_train(
     assert {id(p) for p in model.trainable_parameters()} == {
         id(p) for name, p in model.named_parameters() if name in with_gradient
     }
+
+
+def test_records_of_different_lengths_answer_in_one_pass_as_alone(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Padded to the longest, each record gets the logits that it gets in a pass of its own."""
+    short = {"state": "Brie.", "questions": record["questions"][:1]}
+    encs = [encode(tok, record), encode(tok, short)]
+    with torch.no_grad():
+        together = model.forward_batch(encs)
+        alone = [model(enc) for enc in encs]
+    for batch, single in zip(together, alone, strict=True):
+        for a, b in zip(batch, single, strict=True):
+            assert torch.allclose(a, b, atol=1e-5)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e6248c7e2cf3b6b45f11e0ecfdd7f25a23745aac). [The code after it](https://github.com/rahuldave/babykev/tree/e6248c7e2cf3b6b45f11e0ecfdd7f25a23745aac).

<a id="tut-22.1-to-tut-22.10"></a>

## 22.1 to 22.10 The mask, found and fixed

```bash
just setup
```

`just setup` prints `Resolved 67 packages`. Since the last part, the walk leaves out a test of the whole smoke run on
the tiny model. It also leaves out a floor of 90% on the coverage in `just check`.

A plain decoder has a causal mask. Token i may attend to token j when j is not after i. The model of babykev needs
more. The questions must share one reading of the state, and no question may see another. The docstring of
`branch_mask` states the rule.

```bash
sed -n '150,155p' src/babykev/model.py
```

With that rule, the two copies of the question in the small request must get the same answer. Each has the same
tokens, the same positions, and the same tokens to see, the state and itself.

```bash
uv run python -c "import torch; from tests.tiny import tiny_tokenizer, tiny_backbone; from babykev.model import DecisionModel, encode; t = tiny_tokenizer(); m = DecisionModel('tiny', 'cpu', backbone=tiny_backbone(len(t))).eval(); q = {'instr': 'x?', 'options': ['n', 'y'], 'label': 1}; p = m.probs(encode(t, {'state': 'ab', 'questions': [q, q]})); print(p, torch.equal(*p))"
```

The command runs the tiny model on the small request, and prints the probabilities of each question. Question 1 gets
`[0.5089, 0.4911]`, and question 2 gets `[0.5031, 0.4969]`. `torch.equal` prints `False`. Question 2 sees something
that question 1 does not. Every check has passed since `model.py` came in, and no test has looked at what the mask
lets through. The tests that follow look.

[The code before this part](https://github.com/rahuldave/babykev/tree/922d6ba2495756622ad215301da7c48f2ec33fa9). [The code after it](https://github.com/rahuldave/babykev/tree/5f63fb463f94ae6c82a647db8a4b86d4a3d6caa1).

<a id="tut-22.1"></a>

### 22.1 The picture of the mask of a small request

The first test draws the mask of one small request by hand. The request has a state of two tokens and two questions
of two tokens each, so its segments are `[0, 0, 1, 1, 2, 2]`. Row i of the picture is token i, and column j is token
j. `#` means that token i may attend to token j, and `.` means that it may not.

A patch to [`tests/unit/test_mask.py`](#tut-22.1-tests-unit-test_mask.py-aeb55a).

The new file `tests/unit/test_mask.py` has `allowed` on lines 8 to 12, and the test on lines 15 to 26.

```bash
sed -n '15,26p' tests/unit/test_mask.py
just test -k small_request -vv
```

`allowed` reads the mask back as yes or no. `branch_mask` gives 0 where a token may attend, and a very negative
number where it may not. Rows 5 and 6 of the picture are the tokens of question 2. They see the state, columns 1 and
2, and their own question, columns 5 and 6, and not question 1, columns 3 and 4.

The test fails. `-vv` makes pytest print both lists whole. Rows 5 and 6 of the mask are `#####.` and `######`, where
the picture has `##..#.` and `##..##`. Question 2 sees question 1.

The rows of the mask that the test printed are the rows of a plain causal mask. Line 159 is the reason.

```bash
sed -n '158,160p' src/babykev/model.py
```

`torch.ones_like(causal)` is true for every pair, so `same` is true everywhere, and `allow` on line 160 is `causal`
alone. The model came in with the mask of a plain decoder. The code runs, its types are right, and its lines are
covered. It does the wrong thing for its task.

#### What changed

- <a id="tut-22.1-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the picture of a small request. New, 26 lines. [The file](https://github.com/rahuldave/babykev/blob/e7db07241985b2cc80908d108e4229cfb512646b/tests/unit/test_mask.py).
  - look at `def test_mask_of_a_small_request() -> None:`

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -0,0 +1,26 @@
+"""Tests of the mask: which token of a packed record may attend to which."""
+
+import torch
+
+from babykev.model import branch_mask
+
+
+def allowed(
+    seg: list[int],  # The segment of each token: 0 for the state, k for question k
+) -> torch.Tensor:  # Shape [n, n]: True where token i may attend to token j
+    """Read the mask back as yes or no."""
+    return branch_mask(seg, "cpu")[0, 0] == 0
+
+
+def test_mask_of_a_small_request() -> None:
+    """A state of two tokens, and two questions of two tokens: the picture, drawn by hand."""
+    picture = [
+        "#.....",
+        "##....",
+        "###...",
+        "####..",
+        "##..#.",
+        "##..##",
+    ]
+    rows = ["".join("#" if ok else "." for ok in row) for row in allowed([0, 0, 1, 1, 2, 2])]
+    assert rows == picture
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e7db07241985b2cc80908d108e4229cfb512646b). [The code after it](https://github.com/rahuldave/babykev/tree/e7db07241985b2cc80908d108e4229cfb512646b).

<a id="tut-22.2"></a>

### 22.2 hypothesis, in the group test

A picture checks one size of request. The mask must hold for every size, and nobody can draw them all. hypothesis is
a library for tests. A test states a rule, and hypothesis draws many inputs and runs the test on each.

This change came from running `uv add --group test hypothesis`.

`uv add` prints `Resolved 69 packages`, and installs hypothesis and sortedcontainers, which
hypothesis needs.

In `pyproject.toml`, the group `test` has `"hypothesis>=6.170.0",` on line 51. `uv.lock` has the exact versions.

```bash
uv run python -c "import hypothesis; print(hypothesis.__version__)"
```

It prints the version of hypothesis that uv installed.

#### What changed

- <a id="tut-22.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: hypothesis, in the group `test`. 1 line added. It comes from `uv add --group test hypothesis`. [The file](https://github.com/rahuldave/babykev/blob/aa4f870deb9ec19ee18484e187f5d850399fa554/pyproject.toml).
  - look at `"hypothesis>=6.170.0",`
- <a id="tut-22.2-uv.lock-8356d8"></a>`uv.lock`: the exact versions of hypothesis and sortedcontainers. 80 lines added. It comes from `uv add --group test hypothesis`. [The file](https://github.com/rahuldave/babykev/blob/aa4f870deb9ec19ee18484e187f5d850399fa554/uv.lock).

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -48,6 +48,7 @@ lint = [
     "yamllint>=1.38.0",
 ]
 test = [
+    "hypothesis>=6.170.0",
     "pytest>=9.1.1",
     "pytest-cov>=7.1.0",
 ]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/aa4f870deb9ec19ee18484e187f5d850399fa554). [The code after it](https://github.com/rahuldave/babykev/tree/aa4f870deb9ec19ee18484e187f5d850399fa554).

<a id="tut-22.3"></a>

### 22.3 No question sees another, for any shape of request

The shape of a request is the length of its state and of each question. A strategy of hypothesis says what an input
may be. `shapes` draws a state of 1 to 6 tokens, then up to 4 questions of 1 to 5 tokens each. `segments` lays out a
shape as `encode` does. The test states the rule that no token of a question attends to a token of another question.
`@given(shapes)` runs it on up to 100 shapes.

A patch to [`tests/unit/test_mask.py`](#tut-22.3-tests-unit-test_mask.py-aeb55a).

In `tests/unit/test_mask.py`, `shapes` is on line 10, `segments` on lines 13 to 18, and the new test on lines 42 to
49.

```bash
sed -n '42,49p' tests/unit/test_mask.py
just test -k no_question_sees_another
```

`siblings`, on line 48, is true for two tokens of two different questions. The assert on line 49 says that no pair
is both allowed and siblings.

The test fails. When a shape breaks the rule, hypothesis tries smaller shapes, and reports the smallest that still
breaks it. It reports `shape=(1, [1, 1])`, a state of one token and two questions of one token. `allowed([0, 1, 2])`
has `True` in row 3, column 2. So the token of question 2 sees the token of question 1.

Under the shape, hypothesis lists lines of torch that only the failing examples ran, and they say nothing about the
mask. hypothesis keeps the failing shape in the folder `.hypothesis`, and tries it first at the next run. The
`.gitignore` of GitHub names the folder already.

#### What changed

- <a id="tut-22.3-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the shapes, and the first rule. 23 lines added. [The file](https://github.com/rahuldave/babykev/blob/857445da99027d423543017a9face7f2cd41ea19/tests/unit/test_mask.py).
  - look at `def test_no_question_sees_another_question(`

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -1,9 +1,22 @@
 """Tests of the mask: which token of a packed record may attend to which."""
 
 import torch
+from hypothesis import given
+from hypothesis import strategies as st
 
 from babykev.model import branch_mask
 
+# A request of any shape: a state of 1 to 6 tokens, then up to 4 questions of 1 to 5 tokens each
+shapes = st.tuples(st.integers(1, 6), st.lists(st.integers(1, 5), max_size=4))
+
+
+def segments(
+    state: int,  # How many tokens the state has
+    questions: list[int],  # How many tokens each question has
+) -> list[int]:  # The segment of each token: 0 for the state, k for question k
+    """Lay out a request as `encode` does: the state, then each question in turn."""
+    return [0] * state + [k for k, n in enumerate(questions, start=1) for _ in range(n)]
+
 
 def allowed(
     seg: list[int],  # The segment of each token: 0 for the state, k for question k
@@ -24,3 +37,13 @@ def test_mask_of_a_small_request() -> None:
     ]
     rows = ["".join("#" if ok else "." for ok in row) for row in allowed([0, 0, 1, 1, 2, 2])]
     assert rows == picture
+
+
+@given(shapes)
+def test_no_question_sees_another_question(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """A token of one question never attends to a token of another question."""
+    seg = torch.tensor(segments(*shape))
+    siblings = (seg[:, None] != seg[None, :]) & (seg[:, None] > 0) & (seg[None, :] > 0)
+    assert not (allowed(seg.tolist()) & siblings).any()
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/857445da99027d423543017a9face7f2cd41ea19). [The code after it](https://github.com/rahuldave/babykev/tree/857445da99027d423543017a9face7f2cd41ea19).

<a id="tut-22.4"></a>

### 22.4 No token sees a later token, for any shape of request

The second rule is the causal part of the mask. Nothing above the diagonal is allowed, so a token never attends to a
token after it.

A patch to [`tests/unit/test_mask.py`](#tut-22.4-tests-unit-test_mask.py-aeb55a).

In `tests/unit/test_mask.py`, the new test is on lines 52 to 57.

```bash
just test -k later_token
```

pytest prints `1 passed`. The causal part of the mask was never wrong. Only the part about the questions is.

#### What changed

- <a id="tut-22.4-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the causal rule. 8 lines added. [The file](https://github.com/rahuldave/babykev/blob/55034fc9085b7ba3a5ac86f3cd40b955a698b642/tests/unit/test_mask.py).
  - look at `def test_no_token_sees_a_later_token(`

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -47,3 +47,11 @@ def test_no_question_sees_another_question(
     seg = torch.tensor(segments(*shape))
     siblings = (seg[:, None] != seg[None, :]) & (seg[:, None] > 0) & (seg[None, :] > 0)
     assert not (allowed(seg.tolist()) & siblings).any()
+
+
+@given(shapes)
+def test_no_token_sees_a_later_token(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """Nothing above the diagonal is allowed: a token never attends to a token after it."""
+    assert not torch.triu(allowed(segments(*shape)), diagonal=1).any()
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/55034fc9085b7ba3a5ac86f3cd40b955a698b642). [The code after it](https://github.com/rahuldave/babykev/tree/55034fc9085b7ba3a5ac86f3cd40b955a698b642).

<a id="tut-22.5"></a>

### 22.5 What the mask allows is exactly the rule

The last rule says the whole of it, in plain Python. Token i may attend to token j when j is not after i, and j is
in the state or in the question of i. The test builds that table for every pair of tokens, and compares it with the
mask.

A patch to [`tests/unit/test_mask.py`](#tut-22.5-tests-unit-test_mask.py-aeb55a).

In `tests/unit/test_mask.py`, the new test is on lines 60 to 70.

```bash
sed -n '60,70p' tests/unit/test_mask.py
just test -k exactly_the_rule
```

The test fails, and hypothesis shrinks the shape to `(1, [1, 1])` again. The three tests of the rules check the mask
alone, so they are unit tests.

#### What changed

- <a id="tut-22.5-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the whole rule. 13 lines added. [The file](https://github.com/rahuldave/babykev/blob/41b4f5f236a25a9e8438ba2a00682b5125868a50/tests/unit/test_mask.py).
  - look at `def test_what_is_allowed_is_exactly_the_rule(`

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -55,3 +55,16 @@ def test_no_token_sees_a_later_token(
 ) -> None:
     """Nothing above the diagonal is allowed: a token never attends to a token after it."""
     assert not torch.triu(allowed(segments(*shape)), diagonal=1).any()
+
+
+@given(shapes)
+def test_what_is_allowed_is_exactly_the_rule(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """Token i sees token j when j is not after i, and j is in the state or in i's question."""
+    seg = segments(*shape)
+    rule = [
+        [j <= i and (seg[j] == 0 or seg[j] == seg[i]) for j in range(len(seg))]
+        for i in range(len(seg))
+    ]
+    assert allowed(seg).tolist() == rule
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/41b4f5f236a25a9e8438ba2a00682b5125868a50). [The code after it](https://github.com/rahuldave/babykev/tree/41b4f5f236a25a9e8438ba2a00682b5125868a50).

<a id="tut-22.6"></a>

### 22.6 A question cannot see its sibling

The rules check the mask alone. The next three tests check what the mask is for, on the tiny model. Each question
must get the answer that it would get if it were the only question. The first test rewrites question 2 of the record,
and the answers to questions 1 and 3 must not move, to the last bit.

A patch to [`tests/unit/test_model.py`](#tut-22.6-tests-unit-test_model.py-583145).

In `tests/unit/test_model.py`, the new test is on lines 149 to 160.

```bash
sed -n '149,160p' tests/unit/test_model.py
just test -k sibling
```

The test fails on line 160, question 3. Its probabilities were `[0.3341, 0.3331, 0.3328]`, and are
`[0.3343, 0.3330, 0.3327]` after question 2 changed. Question 3 sees question 2. Line 159, question 1, passes, because
question 1 comes first and sees only the state. The tiny model is untrained, so the probabilities are close to equal.
`torch.equal` asks for the same numbers, and any change is a failure.

#### What changed

- <a id="tut-22.6-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: rewrite question 2, and questions 1 and 3 keep their answers. 14 lines added. [The file](https://github.com/rahuldave/babykev/blob/12e9fb18c4c86cbd1291da858fd6ad39af01929b/tests/unit/test_model.py).
  - look at `def test_a_question_cannot_see_its_sibling(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -144,3 +144,17 @@ def test_records_of_different_lengths_answer_in_one_pass_as_alone(
     for batch, single in zip(together, alone, strict=True):
         for a, b in zip(batch, single, strict=True):
             assert torch.allclose(a, b, atol=1e-5)
+
+
+def test_a_question_cannot_see_its_sibling(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Rewriting question 2 leaves the answers to questions 1 and 3 exactly as they were."""
+    before = model.probs(encode(tok, record))
+    changed = {**record, "questions": list(record["questions"])}
+    changed["questions"][1] = {"instr": "Where from?", "options": ["Spain", "Italy"], "label": 0}
+    after = model.probs(encode(tok, changed))
+    assert torch.equal(before[0], after[0])
+    assert torch.equal(before[2], after[2])
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/12e9fb18c4c86cbd1291da858fd6ad39af01929b). [The code after it](https://github.com/rahuldave/babykev/tree/12e9fb18c4c86cbd1291da858fd6ad39af01929b).

<a id="tut-22.7"></a>

### 22.7 Packed questions answer as they would alone

The second test of isolation packs the three questions of the record in one pass. Then it asks each question in a
record of its own, with the same state. The answers must be the same, to within `1e-6`.

A patch to [`tests/unit/test_model.py`](#tut-22.7-tests-unit-test_model.py-583145).

In `tests/unit/test_model.py`, the new test is on lines 163 to 172.

```bash
just test -k packed_questions
```

The test fails on question 2. Packed, it gets `[0.3321, 0.3346, 0.3333]`, and alone it gets
`[0.3317, 0.3351, 0.3332]`. Question 1 passed the loop before it, for the reason of the last test.

#### What changed

- <a id="tut-22.7-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: three questions in one pass, and each alone. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/d3e4a6a067cd7f481a1bd327af08cb2358429e9c/tests/unit/test_model.py).
  - look at `def test_packed_questions_answer_as_they_would_alone(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -158,3 +158,15 @@ def test_a_question_cannot_see_its_sibling(
     after = model.probs(encode(tok, changed))
     assert torch.equal(before[0], after[0])
     assert torch.equal(before[2], after[2])
+
+
+def test_packed_questions_answer_as_they_would_alone(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """One pass over three questions gives what three passes, of one question each, give."""
+    packed = model.probs(encode(tok, record))
+    for together, question in zip(packed, record["questions"], strict=True):
+        alone = model.probs(encode(tok, {"state": record["state"], "questions": [question]}))[0]
+        assert torch.allclose(together, alone, atol=1e-6)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/d3e4a6a067cd7f481a1bd327af08cb2358429e9c). [The code after it](https://github.com/rahuldave/babykev/tree/d3e4a6a067cd7f481a1bd327af08cb2358429e9c).

<a id="tut-22.8"></a>

### 22.8 The order of questions does not matter

The positions of every question restart after the state. So a question must get the same answer first or last. The
third test of isolation asks the questions in the reverse order.

A patch to [`tests/unit/test_model.py`](#tut-22.8-tests-unit-test_model.py-583145).

In `tests/unit/test_model.py`, the new test is on lines 175 to 184.

```bash
just test -k questions_does_not_matter
```

The test fails on question 1. In the reverse order it comes last, and sees the two other questions. Its
probabilities go from `[0.5016, 0.4984]` to `[0.5007, 0.4993]`. `-k order_of_questions` would also choose a test of
`test_api.py`, so the command names the end of the test.

The tests of the rule are in, and line 159 still has the old mask. The smoke runs the real model on the sample with
it, one last time. The recipe `smoke` runs `uv run babykev smoke`.

```bash
just --show smoke
just smoke
```

`just --show smoke` prints the recipe. The smoke prints `6 of 15 right`. The next two moves fix the mask, and the
smoke runs again after them.

#### What changed

- <a id="tut-22.8-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the questions in the reverse order. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/c3e2706e2b1fbc58bda631e173e26145256bc47e/tests/unit/test_model.py).
  - look at `def test_the_order_of_questions_does_not_matter(`

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -170,3 +170,15 @@ def test_packed_questions_answer_as_they_would_alone(
     for together, question in zip(packed, record["questions"], strict=True):
         alone = model.probs(encode(tok, {"state": record["state"], "questions": [question]}))[0]
         assert torch.allclose(together, alone, atol=1e-6)
+
+
+def test_the_order_of_questions_does_not_matter(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Positions restart after the state, so a question gets the same answer first or last."""
+    forward = model.probs(encode(tok, record))
+    backward = model.probs(encode(tok, {**record, "questions": record["questions"][::-1]}))
+    for a, b in zip(forward, backward[::-1], strict=True):
+        assert torch.allclose(a, b, atol=1e-6)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c3e2706e2b1fbc58bda631e173e26145256bc47e). [The code after it](https://github.com/rahuldave/babykev/tree/c3e2706e2b1fbc58bda631e173e26145256bc47e).

<a id="tut-22.9"></a>

### 22.9 A fix for the picture, wrong on purpose

The mistake of this move is on purpose. The picture failed on rows 5 and 6, where question 2 sees question 1. A quick
fix blocks only the question just before a question. A token sees its own question, the state, and any question two
or more before it. The fix makes the picture right.

A patch to [`src/babykev/model.py`](#tut-22.9-src-babykev-model.py-a86a0b).

In `src/babykev/model.py`, line 159 now ends with `| (s[None, :] < s[:, None] - 1)`. A token may see a question
whose number is less than its own minus one.

```bash
just test
```

The picture passes, and so does the test of the siblings. 4 tests fail, 78 pass. The two rules that failed before
fail again, and hypothesis shrinks each to `shape=(1, [1, 1, 1])`, three questions of one token. The token of
question 3 sees the token of question 1. The stored shape `(1, [1, 1])` passes now, so hypothesis looks for a new one.
The test of the packed questions and the test of the order fail too, on a question that sees a question two before
it.

The picture has two questions, so it cannot tell. The test of the siblings rewrites question 2, which question 3 no
longer sees. A rule for every shape found the size with three questions.

#### What changed

- <a id="tut-22.9-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: a mask that blocks only the question just before, on purpose. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/18bdfee89d950245956448ab8377cfc8b90e8595/src/babykev/model.py).
  - look at `    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)`

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

```diff
@@ -156,7 +156,7 @@ def branch_mask(
     s = torch.tensor(seg, device=device)
     n = len(seg)
     causal = torch.tril(torch.ones(n, n, dtype=torch.bool, device=device))
-    same = torch.ones_like(causal) | (s[None, :] == 0)
+    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)
     allow = causal & same
     blocked = torch.finfo(dtype).min
     return torch.zeros(n, n, dtype=dtype, device=device).masked_fill(~allow, blocked)[None, None]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/18bdfee89d950245956448ab8377cfc8b90e8595). [The code after it](https://github.com/rahuldave/babykev/tree/18bdfee89d950245956448ab8377cfc8b90e8595).

<a id="tut-22.10"></a>

### 22.10 A token sees the state and its own question

The line of the mask becomes kev's line. A token may attend to a token of the state, `s[None, :] == 0`, or to a token
of its own question, `s[None, :] == s[:, None]`. `causal`, on line 158, keeps out every token after it, and line 160
joins the two. The docstring of `branch_mask`, lines 150 to 154, has stated this rule from the start.

A patch to [`src/babykev/model.py`](#tut-22.10-src-babykev-model.py-a86a0b).

In `src/babykev/model.py`, line 159 is `same = (s[None, :] == s[:, None]) | (s[None, :] == 0)`.

```bash
just test
```

`just test` prints `82 passed`, and the total of 92%. A test of what the mask allows adds no line
to the coverage. `branch_mask` was covered all along.

The smoke runs the real model on the sample again, with the right mask.

```bash
just smoke
```

The smoke prints `4 of 15 right`. Questions 2 and 3 of each request now read only the state and themselves, and not
the questions before them. The model is untrained, so the count is a guess, and a right answer is chance.

In tut-18, with the old mask, the smoke printed `6 of 15 right`. The first question of each request keeps its answer,
with the same two decimals. It comes first, so it saw only the state with either mask. Nine of the ten other answers
changed. Both counts are guesses.

The small request shows the fix too.

```bash
uv run python -c "import torch; from tests.tiny import tiny_tokenizer, tiny_backbone; from babykev.model import DecisionModel, encode; t = tiny_tokenizer(); m = DecisionModel('tiny', 'cpu', backbone=tiny_backbone(len(t))).eval(); q = {'instr': 'x?', 'options': ['n', 'y'], 'label': 1}; p = m.probs(encode(t, {'state': 'ab', 'questions': [q, q]})); print(p, torch.equal(*p))"
```

Both questions now get `[0.5089, 0.4911]`, and `torch.equal` prints `True`. Question 1 kept its numbers, because it
comes first and saw only the state with either mask. Question 2 now gets exactly what question 1 gets.

The smoke went from `6 of 15 right` with the old mask to `4 of 15 right` with the fix, and every test says that the
fix is right. The first question of each request kept its answer, with the same two decimals. It comes first, so it
saw only the state with either mask. Nine of the ten other answers changed.

The milk of Coquetdale went from `buffalo` to `cow`, which is right. The milk and the firmness of Amou, and the
intensity of Loma Alta, were right with the old mask, and are wrong now. The count fell, and the fix is still right.

Nothing is trained, so each answer is a guess. The next command counts the right answers that a guess gets on average,
with one chance in K for a question of K options.

```bash
uv run python -c "import json; qs = [q for line in open('data/cheese/sample.jsonl') for q in json.loads(line)['questions'].values()]; print(len(qs), round(sum(1 / (2 if q['type'] == 'noul' else len(q['criteria'])) for q in qs), 2))"
```

It prints `15 4.75`. The sample has 15 questions, and a guess gets 4.75 of them right on average. Both 6 and 4 are
guesses near 4.75, and their difference says nothing about the mask. A count of right answers from an untrained model
cannot judge a mask, and the tests of the rule can.

After training, a model with the old mask could learn to use the questions before a question. Its answer to a
question would then change with the questions that came along. Asked alone, the same question could get another
answer.

The smoke also printed `503M parameters, 9.3M of them trainable`. On the real model, the adapter and the head are a
small part of the whole.

Padding is one more segment for the mask, -1. The last command draws the mask of one record with padding, as
`hidden` builds it. The record has a state of two tokens and one question of two tokens, and two tokens of padding
follow.

```bash
uv run python -c "from babykev.model import branch_mask; m = branch_mask([0, 0, 1, 1, -1, -1], 'cpu')[0, 0] == 0; print(*(''.join('#' if ok else '.' for ok in row) for row in m), sep='\n')"
```

`#` means that the token of the row may attend to the token of the column. The first four rows are the real tokens.
They see nothing in the last two columns, the padding. The last two rows are the padding. They see the state and
each other, as a question would, and nothing reads them.

The whole tutorial goes on from here. It runs the smoke on the real model as a test of its own. It writes a page of
the guide on the model and one on the mask. Then it builds the images and the workflows of GitHub.

#### What changed

- <a id="tut-22.10-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: the state, or the same question. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/5f63fb463f94ae6c82a647db8a4b86d4a3d6caa1/src/babykev/model.py).
  - look at `    same = (s[None, :] == s[:, None]) | (s[None, :] == 0)`

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

```diff
@@ -156,7 +156,7 @@ def branch_mask(
     s = torch.tensor(seg, device=device)
     n = len(seg)
     causal = torch.tril(torch.ones(n, n, dtype=torch.bool, device=device))
-    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)
+    same = (s[None, :] == s[:, None]) | (s[None, :] == 0)
     allow = causal & same
     blocked = torch.finfo(dtype).min
     return torch.zeros(n, n, dtype=dtype, device=device).masked_fill(~allow, blocked)[None, None]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5f63fb463f94ae6c82a647db8a4b86d4a3d6caa1). [The code after it](https://github.com/rahuldave/babykev/tree/5f63fb463f94ae6c82a647db8a4b86d4a3d6caa1).
