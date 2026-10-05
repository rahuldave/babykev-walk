# The walk through babykev

babykev grew in steps, with one commit and one tag for each step. This kit replays the class with
[timewalk](https://rahuldave.com/timewalk/). At every step, the page shows the files as they were and what
the step changed. It also has terminals in the repository at that step, and the notes of the step with
their commands.

## What you need

- [uv](https://docs.astral.sh/uv/), which also runs timewalk from GitHub
- [git](https://git-scm.com/)
- [just](https://just.systems/), which runs the recipes of this kit
- [Quarto](https://quarto.org/), for the documentation steps of babykev
- Chrome, Edge or another recent browser

## Start

1. Fork this kit on GitHub, so that you can save your own notes. Then clone your fork.
2. In the folder of the kit, run `just present`.
3. Open the address that timewalk prints.

```
git clone https://github.com/<you>/babykev-walk
cd babykev-walk
just present
```

`just present` runs `just setup` first. The first time, `just setup` clones babykev into `repo/`. If you
also forked babykev, it clones your fork, so that you can push your own work. Otherwise it clones
`rahuldave/babykev`. Every time, it fetches the tags of the steps from `rahuldave/babykev`.

timewalk then puts its replay copy in `worktree/`. The replay copy is a second working folder of the
same repository, which timewalk moves from step to step. Git ignores both folders, so they never enter
your fork. To clone from another address, run `just setup url=<address>` before the first `just present`.

## The folders

```
babykev-walk/
├── walk.md        the notes of every step, tracked in your fork
├── justfile       the recipes: present, setup, pdf
├── repo/          ignored: your clone of babykev
└── worktree/      ignored: the replay copy
```

## The page

- **The notes column** on the right shows the notes of the step. A click on a command types it into its
  terminal. Read the command, and then press Enter to run it. To run a command with one click, turn on
  **run on click**.
- **Edit** at the top of the notes column changes the notes of the step in `walk.md`. Commit `walk.md`
  to your fork to keep your notes.
- **At this step** and **Runs** are terminals in `worktree/`, at the step. timewalk starts with
  `--discard-edits`, so a move to another step throws away your edits there.
- **Main** is a terminal in `repo/`, your clone of babykev. A move never touches it. Work there on
  `main`, commit, and push to your own fork.
- **PDF** makes a PDF of the notes of every step. `just pdf` makes the same file, `walk.pdf`.

## Downloads and accounts

The commands are for macOS. On Linux, `sed -i ''` is `sed -i`, and `open` is `xdg-open`.

Two downloads happen once. At step 05, `just setup` in babykev fetches torch and the other libraries, a
few hundred megabytes. The first `just smoke local` fetches the base model, about 1 GB, into the Hugging
Face cache. The steps that run on Modal need a Modal account and a `.env` file of your own.
`.env.example` says what goes in it. Every other step runs on this machine.
