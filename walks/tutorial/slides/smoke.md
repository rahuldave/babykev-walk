## What a smoke test is

- The name comes from electronics. Switch a new circuit on, and see whether it smokes
- It asks if the whole thing starts and gives an answer at all. It does not ask if the answer is right
- It is fast and shallow, and runs before the slow and deep tests
- Ours loads the real model on this machine, asks the 15 questions of the sample data, and prints each answer beside
  its label

---

## What is trained

| Part | Parameters | Trained? |
|---|---|---|
| Qwen2.5-0.5B, the language model | 494,032,768 | No. It is frozen |
| The LoRA adapter, rank 16 | 8,798,208 | Yes |
| The pointer head | 459,264 | Yes |

The smoke prints the sums, `503M parameters, 9.3M of them trainable`. Nothing is trained yet, so its answers are
guesses.

---

## The smoke, on this machine

`just smoke` runs `uv run babykev smoke`. It loads the base model on the best device that it finds. It tries CUDA, then
the GPU of Apple, then the CPU.

| Fixed from run to run | Can vary |
|---|---|
| `503M parameters, 9.3M of them trainable` | the seconds to load, and the milliseconds of each request |
| the tokens of each request: 162, 145, 158, 115, 156 | the device, and so the last digits of a probability |
| the weights of the head and the adapter, from the seed 0 | the first run, which downloads about 1 GB |

- On a Mac, on `mps` and on `cpu`, it says `6 of 15 right`
- A run shows that the contract, the packing, the model and the answers fit together
