## Not everyone has a Mac

- Students run Windows, Linux, WSL, or a VM in the cloud
- The platforms we train on are Linux machines in someone else's building
- An image is a Linux machine described in one file, the `Dockerfile`, and built anywhere Docker runs

---

## Two images from one lockfile

| | dev | run |
|---|---|---|
| Holds | every dependency with the dev tools, uv, just, Quarto, git | Python and what the program needs |
| Starts | a shell, with your folder mounted | `babykev` |
| For | working on the project on any system, and CI | a platform that runs the program |
| Size | 1.84 GB | 1.15 GB |

The packages are installed first and the code after, so a change to the code does not reinstall torch.

---

## `just image`

```
just image build dev        the dev image, named by the commit
just image shell            a new container of it: then just check, as on the Mac
just image start            or one kept running; shell goes into it, stop ends it
just image run smoke        the smoke in the run image
```

- An image is a file on disk. A container is a running copy of it
- In the run image, on the CPU: 4 of 15, the same fifteen answers as on the Mac's GPU, line for line. Eight times slower

---

## hadolint: a linter for Dockerfiles

- It found two things: two `RUN` lines that could be one, and Debian packages without pinned versions
- We fixed the first. We declined the second, and said why beside the line
- A linter's rule is a default, not a law
- It is a line of `just lint-config`, so the hook runs it

---

## Hermetic, by experiment

The smoke on the real model is now a test too, marked `integration`. `just test` leaves it out.

| With `--network none` | Result |
|---|---|
| `just check` | passes |
| `just test -m integration`, the model in the cache | passes |
| the same, with an empty cache | fails: it cannot reach the Hub |

What still passes with the network pulled can run on every commit.

---

## A test is anything that can fail and stop you

| What is checked | How | Recipe | On every commit? |
|---|---|---|---|
| Functions, the mask, the model | pytest, hypothesis, the tiny model | `just test` | yes |
| Types | ty | `just types` | yes |
| Documentation | `babykev docs check` | `just docs check` | yes |
| Format and lint | ruff | `just fmt --check`, `just lint` | yes |
| Config files, the Dockerfile | yamllint, validate-pyproject, uv, hadolint | `just lint-config` | yes |
| The real model, from the Hub | the smoke, marked `integration` | `just test -m integration` | no: not hermetic |

Most of these are not pytest. All of them are `just`.

---

## The docs, published

- `just docs publish` builds the site and pushes it to the `gh-pages` branch
- GitHub Pages serves it: rahuldave.github.io/babykev
- The built site never enters `main`
