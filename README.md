# The walk through babykev

babykev was built in steps, one commit and one tag each. This kit replays the class: at every step, the
files as they were, what the step changed, a terminal in the repository at that step, and the script of
the step, with one-click commands.

You need three folders side by side:

```
git clone https://github.com/rahuldave/babykev
git clone https://github.com/rahuldave/timewalk
git clone https://github.com/rahuldave/babykev-walk     # this kit
```

and on the machine: [uv](https://docs.astral.sh/uv/), [just](https://just.systems/) and
[Quarto](https://quarto.org/). Then

```
cd babykev-walk
just present
```

prints two addresses. Open the second one, ending in `/presenter`: it is the one with the script beside
the code. Clicking a command in the script types it into the terminal at that step. The browser works
in a copy of the repository, `babykev-replay`, which it makes itself; your clone is never moved.

The commands are written for macOS: on Linux, `sed -i ''` is `sed -i` and `open` is `xdg-open`.
Two downloads happen once: at step 05, `just setup` fetches torch and the other libraries, a few hundred
megabytes, and the first `just smoke local` fetches the base model, about 1 GB, into the Hugging Face
cache. The steps that run on Modal need an account there and a `.env` of your own; `.env.example` says
what goes in it. Everything else runs on this machine.
