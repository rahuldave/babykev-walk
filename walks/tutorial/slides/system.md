## What should not go in the hook?

The hook runs `just check` before every commit, and `just check` runs a check of every kind we added.

- A check that needs the network, a download or a GPU can fail for reasons outside our code
- People learn to skip a hook that fails for those reasons
- So the question for every test is whether anything but our code can make it fail. Only a test where the answer is no
  belongs in the hook

---

## Hermetic, by experiment

`HF_HUB_OFFLINE=1` makes no request to the Hub, and `HF_HOME` chooses the cache.

| Run of the test of the real model | Result |
|---|---|
| with the network | passes |
| no network, the cache of this machine | passes, because the model is in the cache |
| no network, an empty cache | fails: `We couldn't connect to 'https://huggingface.co'` |

Take away the network, and see what still passes. What still passes can run before every commit.

---

## 2 unit tests, 0 integration tests

<img src="pictures/memes/2-unit-tests-0-integration-tests.gif" alt="Two window handles that each work, and block each other" style="max-height: 480px; max-width: 100%">

Made popular by Randal Olson, January 2016. The author of the clip is unknown.
giphy.com/gifs/2-unit-tests-0-integration-3o7rbGT9rrEJa4Y5LG

---

## A marker keeps the system test out

```toml
addopts = "--cov=babykev --cov-report=term-missing -m 'not system'"
markers = ["system: needs the network, the real model or a device"]
```

| Kind | Our example | Hermetic? | In `just check`? |
|---|---|---|---|
| Unit | the rules of the mask | yes | yes |
| Integration | a question cannot see its sibling, on the tiny model | yes | yes |
| End-to-end, or system | `test_real_model.py`, the smoke on the real model | no | no. `just test -m system` runs it |
| Smoke | `just smoke` | no | no |
| Acceptance | none | | |

- pytest has no kinds of its own. A marker is a name that we declare, and `-m` chooses by it
- The tests of the mask are integration tests by kind, and have no marker, because they are hermetic
