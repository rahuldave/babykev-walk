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

## The model, and the decoder under it

$ just setup

`just setup` prints `Resolved 66 packages`. The model is one file, `src/babykev/model.py`. It comes in whole, and we
read its docstring first.

{{include tut-16.1}}

The backbone is the decoder of Qwen2.5-0.5B. Its configuration says how large it is.

$ uv run python -c "from transformers import AutoConfig; c = AutoConfig.from_pretrained('Qwen/Qwen2.5-0.5B'); print(c.num_hidden_layers, c.hidden_size, c.vocab_size)"

It prints `24 896 151936`. The decoder has 24 layers, and each token is a vector of 896 numbers between them. The
vocabulary has 151936 tokens, so a vocabulary head gives 151936 logits at each place. `transformers` fetches the
configuration from the Hugging Face Hub the first time, and keeps it.

`DecisionModel` keeps the layers and drops the vocabulary head. Line 205, in the output of `sed -n '187,219p'` above,
is `backbone = lm.model`. `lm` is the whole decoder, and `lm.model` is the decoder without its head. The method
`hidden` runs the layers.

$ sed -n '231,241p' src/babykev/model.py

Line 241 calls the backbone with three arguments, and a decoder of transformers takes all three. `input_ids` are the
tokens, `position_ids` are their positions, and `attention_mask` says which token may attend to which. Packing gives
the tokens and the positions, and `branch_mask` gives the mask. So three of the four ideas change only what goes into
the decoder, and the layers stay as they are. The fourth idea reads `last_hidden_state`, the vectors that come out.

## A tiny model for the tests

$ just setup

`just setup` prints `Resolved 67 packages`. Since the last part, the walk leaves out three groups of moves. ty, a
checker of types, came in, and two comments in `model.py` answer it. The smoke run came in. It loads the real
model, asks it the questions of a sample file, and prints how many it got right. Then the tests got a tiny tokenizer
and a tiny backbone, in `tests/tiny.py`, and three fixtures, in `tests/conftest.py`.

A test of the model checks something exact, such as which token is where, or which weights get a gradient. That holds
for any weights. So the tests need no trained model, and no download. The tiny backbone is the same class as the
real one, with small sizes.

$ sed -n '27,42p' tests/tiny.py

`tiny_backbone` builds `Qwen2Model`, the class of the real backbone, with 2 layers of 32 numbers, on lines 35 and 37.
The real one has 24 layers of 896. The weights are random, from the seed on line 32, so they are the same at every
run.

$ uv run python -c "from tests.tiny import tiny_tokenizer; t = tiny_tokenizer(); print(len(t), t.tokenize('ab<|fim_suffix|>'))"

The tiny tokenizer has `106` tokens, one for each printable character, the five delimiters, and `[UNK]` for any
other character. It splits `ab<|fim_suffix|>` into `['a', 'b', '<|fim_suffix|>']`. Like the real tokenizer, it turns
the text of a delimiter into the delimiter. A later part shows why that is a danger.

$ sed -n '22,27p' tests/conftest.py

The fixture `model` is a `DecisionModel` on the tiny backbone, on the CPU. The code that runs is the real
`DecisionModel`. Only the backbone and the tokenizer under it are small.

{{include tut-19.8}}

Every test in the rest of this walk asks for these fixtures, and runs on the tiny model.

## Packing a request into one sequence

$ just setup

`just setup` prints `Resolved 67 packages`. Since the last part, the walk leaves out one row of the README.

A request has a state, which says what is known about the cheese, and several questions. Each question has an
instruction and its options. The model reads the state once, and answers every question in the same pass. So
`encode` writes the state and every question into one sequence, and five delimiter tokens mark the parts.

$ sed -n '34,38p' src/babykev/model.py

`SPECIAL`, on line 37, lists the five delimiters. In their order, they mark the state, a question, the start of an
option, the end of an option, and the place of the decision. They are special tokens that the base model already has and
rarely uses. So no embedding has to be added. Line 38 sets the longest state, 384 tokens, and the longest state and
question together, 1024.

$ uv run python -c "from tests.tiny import tiny_tokenizer; from babykev.model import encode; t = tiny_tokenizer(); q = {'instr': 'x?', 'options': ['n', 'y'], 'label': 1}; e = encode(t, {'state': 'ab', 'questions': [q, q]}); print(*enumerate(zip(t.convert_ids_to_tokens(e['ids']), e['seg'], e['pos'])), sep='\n'); print(e['decide_idx'], e['opt_idx'])"

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

$ sed -n '114,134p' src/babykev/model.py

`encode` builds the state on line 115, and each branch in the loop of lines 120 to 134. A branch is a question with
its delimiters. Line 124 puts each option between its two delimiters, and line 125 notes the place of its closing
token. Line 126 adds the decide token. Line 131 gives the branch its segment, and line 132 its positions. The tests
check the whole sequence, token by token.

{{include tut-20.1}}

## Positions that start again after the state

$ just setup

`just setup` prints `Resolved 67 packages`. A plain decoder gives token n the position n. `encode` gives each question
the positions right after the state, on line 132.

$ uv run python -c "from tests.tiny import tiny_tokenizer; from babykev.model import encode; t = tiny_tokenizer(); q = {'instr': 'x?', 'options': ['n', 'y'], 'label': 1}; e = encode(t, {'state': 'ab', 'questions': [q, q]}); print(e['seg']); print(e['pos'])"

The first list is the segment of each token, and the second is its position. The state has the positions 0 to 2.
Question 1 has 3 to 12, and question 2 has 3 to 12 again, where a plain decoder would give it 13 to 22.

So question 2 has the same tokens and the same positions as question 1. If it also sees the same tokens, the state
and itself, the decoder computes the same numbers for it. A question then gets the same answer wherever it sits in
the request, and the same answer as in a request of its own. The positions do half of that work, and the mask does
the other half, in the last part of this walk.

{{include tut-20.2}}

$ sed -n '38,47p' tests/unit/test_model.py

The test packs the record of the fixture, which has three questions. Line 44 counts the tokens of the state. Lines 45
to 47 check that the positions of each question run from that count upward.

## A caller's text cannot forge a delimiter

$ just setup

`just setup` prints `Resolved 67 packages`. Since the last part, the walk leaves out two tests. `encode` refuses a
state longer than its limit, and a branch that does not fit with the state, and names the length. It cuts nothing to
make a request fit.

The delimiters are special tokens. A tokenizer turns the text of a special token into the token, wherever the text
is. The state, the instructions and the options come from a caller. So an option with the text `<|fim_suffix|>` in it
would put a decide token in the middle of the question. `user_tokens` tokenizes a caller's text, and stops that.

$ sed -n '86,97p' src/babykev/model.py

Line 97 rewrites `<|name|>` to `<¦name¦>` before it tokenizes. The broken bar `¦` reads like `|` to a person, and it
is ordinary text to the tokenizer.

$ uv run python -c "from tests.tiny import tiny_tokenizer; from babykev.model import user_tokens; t = tiny_tokenizer(); print(t.tokenize('no<|fim_suffix|>')); print(t.convert_ids_to_tokens(user_tokens(t, 'no<|fim_suffix|>')))"

The tokenizer alone gives three tokens, `n`, `o` and the decide delimiter. `user_tokens` gives 16 ordinary tokens. The
tiny tokenizer has no token for `¦`, so it gives `[UNK]` there. The tokenizer of the base model has tokens for it.

{{include tut-20.5..tut-20.6}}

$ sed -n '76,83p' tests/unit/test_model.py

`@pytest.mark.parametrize`, on line 76, runs the test once for each of the five delimiters. Line 83 checks that no
token of the text is a delimiter.

## A pointer head in place of the vocabulary head

$ just setup

`just setup` prints `Resolved 67 packages`. A decoder answers a question by generating the text of the answer, one
token at a time, from 151936 logits at each place. Here the options are already in the sequence. So the head only
has to point at one of them, and it gives one logit for each option, whatever the length of its text.

The head reads two kinds of place. In the small request, question 1 has its decide token at place 12, and its options
close at places 8 and 11. The closing token of option `y` has read the state, the instruction, both options and
itself, because the mask is causal. The decide token comes last, so it has read the whole question.

$ sed -n '165,186p' src/babykev/model.py

`PointerHead` has two linear maps, on line 175, from the width of the backbone to `dp`, 256 by default. `q` maps the
vector of the decide token, and `k` maps the vector of each option. Line 186 takes the dot product of each option with
the decide token, and scales it by one over the square root of 256. The head computes one row of attention. The
query comes from the decide token, a key comes from each option, and the scores are the logits. `probs` turns them
into probabilities with a softmax.

{{include tut-20.7}}

$ sed -n '87,90p' tests/unit/test_model.py

The test builds a head alone, of width 32 and `dp` 8, and gives it the vector of a decide token and five options. Line
90 checks that it gives five logits.

## DecisionModel, with an adapter, over several records

$ just setup

`just setup` prints `Resolved 67 packages`. Since the last part, the walk leaves out the tests of `pick_device`, which
chooses the GPU or the CPU. It also leaves out the tests of the smoke run and its command.

`DecisionModel` puts the backbone, the mask, the positions and the head together. With `lora`, it also wraps the
backbone in an adapter.

$ sed -n '39p;208,219p' src/babykev/model.py

LoRA, low-rank adaptation, leaves each weight of the backbone as it is. Beside a weight of shape out by in, it puts
two small matrices, `A` of r by in and `B` of out by r. Their product goes into the output. Lines 210 to
218 do it with peft, on the seven projections of `LORA_TARGETS`, line 39. r is the rank, the argument `lora`. peft freezes the
backbone, so training changes the adapter and the head, and nothing else.

{{include tut-21.1}}

$ uv run python -c "from tests.tiny import tiny_tokenizer, tiny_backbone; from babykev.model import DecisionModel; m = DecisionModel('tiny', 'cpu', lora=4, backbone=tiny_backbone(len(tiny_tokenizer()))); print(sum(p.numel() for p in m.parameters()), sum(p.numel() for p in m.trainable_parameters()), sum(p.numel() for p in m.head.parameters()))"

It prints `45472 21248 16896`. The tiny model with an adapter of rank 4 has 45472 parameters, and 21248 of them
train. The head has 16896, two maps of 32 to 256 with their biases. The other 4352 are the adapter. For a weight
of 32 by 32, an adapter of rank 4 has 4 by 32 and 32 by 4. It has 256 numbers, where the weight has 1024.

`hidden` reads several records in one pass. The records have different lengths, so it pads each to the longest.

$ sed -n '233,243p' src/babykev/model.py

Line 234 makes a tensor of zeros, as long as the longest record, and line 239 writes the tokens of each record into
it. The positions of the padding stay 0. Line 241 gives the padding the segment `PAD_SEGMENT`, which is -1, on line
40. So the mask treats the padding as one more question. The padding comes after every real token, and the causal
part of the mask already keeps the real tokens from it. Nothing reads the vectors at the padding, because the head
reads only the places of `decide_idx` and `opt_idx`.

{{include tut-21.2}}

The test compares to within `1e-5`, and not exactly. A padded pass multiplies larger matrices, and adds the same
numbers in another order. So the last bits of a float can differ.

## The mask, found and fixed

$ just setup

`just setup` prints `Resolved 67 packages`. Since the last part, the walk leaves out a test of the whole smoke run on
the tiny model. It also leaves out a floor of 90% on the coverage in `just check`.

A plain decoder has a causal mask. Token i may attend to token j when j is not after i. The model of babykev needs
more. The questions must share one reading of the state, and no question may see another. The docstring of
`branch_mask` states the rule.

$ sed -n '150,155p' src/babykev/model.py

With that rule, the two copies of the question in the small request must get the same answer. Each has the same
tokens, the same positions, and the same tokens to see, the state and itself.

$ uv run python -c "import torch; from tests.tiny import tiny_tokenizer, tiny_backbone; from babykev.model import DecisionModel, encode; t = tiny_tokenizer(); m = DecisionModel('tiny', 'cpu', backbone=tiny_backbone(len(t))).eval(); q = {'instr': 'x?', 'options': ['n', 'y'], 'label': 1}; p = m.probs(encode(t, {'state': 'ab', 'questions': [q, q]})); print(p, torch.equal(*p))"

The command runs the tiny model on the small request, and prints the probabilities of each question. Question 1 gets
`[0.5089, 0.4911]`, and question 2 gets `[0.5031, 0.4969]`. `torch.equal` prints `False`. Question 2 sees something
that question 1 does not. Every check has passed since `model.py` came in, and no test has looked at what the mask
lets through. The tests that follow look.

{{include tut-22.1}}

The rows of the mask that the test printed are the rows of a plain causal mask. Line 159 is the reason.

$ sed -n '158,160p' src/babykev/model.py

`torch.ones_like(causal)` is true for every pair, so `same` is true everywhere, and `allow` on line 160 is `causal`
alone. The model came in with the mask of a plain decoder. The code runs, its types are right, and its lines are
covered. It does the wrong thing for its task.

{{include tut-22.2..tut-22.8}}

The tests of the rule are in, and line 159 still has the old mask. The smoke runs the real model on the sample with
it, one last time. The recipe `smoke` runs `uv run babykev smoke`.

$ just --show smoke
$ just smoke

`just --show smoke` prints the recipe. The smoke prints `6 of 15 right`. The next two moves fix the mask, and the
smoke runs again after them.

{{include tut-22.9..tut-22.10}}

The small request shows the fix too.

$ uv run python -c "import torch; from tests.tiny import tiny_tokenizer, tiny_backbone; from babykev.model import DecisionModel, encode; t = tiny_tokenizer(); m = DecisionModel('tiny', 'cpu', backbone=tiny_backbone(len(t))).eval(); q = {'instr': 'x?', 'options': ['n', 'y'], 'label': 1}; p = m.probs(encode(t, {'state': 'ab', 'questions': [q, q]})); print(p, torch.equal(*p))"

Both questions now get `[0.5089, 0.4911]`, and `torch.equal` prints `True`. Question 1 kept its numbers, because it
comes first and saw only the state with either mask. Question 2 now gets exactly what question 1 gets.

The smoke went from `6 of 15 right` with the old mask to `4 of 15 right` with the fix, and every test says that the
fix is right. The first question of each request kept its answer, with the same two decimals. It comes first, so it
saw only the state with either mask. Nine of the ten other answers changed.

The milk of Coquetdale went from `buffalo` to `cow`, which is right. The milk and the firmness of Amou, and the
intensity of Loma Alta, were right with the old mask, and are wrong now. The count fell, and the fix is still right.

Nothing is trained, so each answer is a guess. The next command counts the right answers that a guess gets on average,
with one chance in K for a question of K options.

$ uv run python -c "import json; qs = [q for line in open('data/cheese/sample.jsonl') for q in json.loads(line)['questions'].values()]; print(len(qs), round(sum(1 / (2 if q['type'] == 'noul' else len(q['criteria'])) for q in qs), 2))"

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

$ uv run python -c "from babykev.model import branch_mask; m = branch_mask([0, 0, 1, 1, -1, -1], 'cpu')[0, 0] == 0; print(*(''.join('#' if ok else '.' for ok in row) for row in m), sep='\n')"

`#` means that the token of the row may attend to the token of the column. The first four rows are the real tokens.
They see nothing in the last two columns, the padding. The last two rows are the padding. They see the state and
each other, as a question would, and nothing reads them.

The whole tutorial goes on from here. It runs the smoke on the real model as a test of its own. It writes a page of
the guide on the model and one on the mask. Then it builds the images and the workflows of GitHub.
