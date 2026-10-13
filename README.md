# babykev, one move at a time

This tutorial builds [babykev](https://github.com/rahuldave/babykev/tree/tutorial), a small decision model, and
the engineering around it. babykev reads a document and a set of typed questions, and gives a probability for
every answer. Its model comes from the first commit of [kev](https://github.com/jaredpalmer/kev), by Jared Palmer.
The tutorial adds the rest:

- packages and dependencies with uv, and one interface for every task with `just`
- tests, a formatter, a linter, types, a git hook and CI
- documentation made from the code, with smalldocs
- the model, and its tests

babykev grows in **steps**, on its branch `tutorial`. Each step is a tag, `tut-00`, `tut-01` and so on. The small
commits between two tags are the **moves**. Each move does one thing, and ends with a command that shows what it
did. The tutorial has three forms, with the same text:

- **[The website](https://rahuldave.com/babykev-walk/)** has a page for each step in each mode, with a list of
  the steps beside it and a search box.
- **To read on GitHub,** [walks/tutorial/TUTORIAL-watch.md](walks/tutorial/TUTORIAL-watch.md) explains each move,
  and [walks/tutorial/TUTORIAL-do.md](walks/tutorial/TUTORIAL-do.md) gives every line to type. Both have the
  commands in code blocks, and a link to the code at every step and to the commit of every move.
- **[walks/tutorial/notes.md](walks/tutorial/notes.md)** has the notes that timewalk reads. timewalk-export makes
  the website and the two Markdown files from these notes.

The slides are in [walks/tutorial/slides/](walks/tutorial/slides/). The notes and the slides of the first lecture are in [walks/narrative/](walks/narrative/).

## The steps and moves

Each link opens its section of TUTORIAL-watch.md.

- [tut-00](walks/tutorial/TUTORIAL-watch.md#tut-00-where-we-start) **Where we start**
- [tut-01](walks/tutorial/TUTORIAL-watch.md#tut-01-the-project) **The project**
  - [tut-01.1](walks/tutorial/TUTORIAL-watch.md#tut-011-uv-makes-the-project) uv makes the project
  - [tut-01.2](walks/tutorial/TUTORIAL-watch.md#tut-012-the-description-the-licence-and-the-author) The description, the licence and the author
  - [tut-01.3](walks/tutorial/TUTORIAL-watch.md#tut-013-the-command-babykev-with-help) The command babykev, with help
  - [tut-01.4](walks/tutorial/TUTORIAL-watch.md#tut-014-a-justfile-with-the-recipe-setup) A justfile with the recipe setup
  - [tut-01.5](walks/tutorial/TUTORIAL-watch.md#tut-015-the-recipe-help) The recipe help
  - [tut-01.6](walks/tutorial/TUTORIAL-watch.md#tut-016-the-readme-says-how-to-start-and-what-each-file-is) The README says how to start, and what each file is

## Two ways to take it

The tutorial runs in [timewalk](https://rahuldave.com/timewalk/), a page in the browser with the files, the
notes, the slides, and terminals in the project at each step.

| Mode | What you do |
|---|---|
| **Do** | You make each move yourself, from its notes. Type the code, run the command in the grey block, run the command at the end of the move, and press **Done**. **Your files match** says when your files are the same as the commit of the move. Use **Apply** or **Catch me up** if you are stuck |
| **Watch** | **Show** checks out the commit of each move, and the notes explain what changed. The teacher shows the class in this mode |

The switch **Do / Watch** beside the name of the walk changes the mode at any time. Every step starts from the code
of the step before. The moves of a step go in order. To go back, press **Restart step**, and then run
`just setup`. Before tut-01.4, the project has no justfile, so `just setup` there runs the recipe of this
repository. The notes of tut-00 and tut-01 say so.

**A move keeps your work.** Before a move, timewalk puts your edits and commits in `worktree/`, on a branch
`timewalk/saved/<place>`, for example `timewalk/saved/tut-01.3`. It does not ask. The page names the branch, and
gives the command that brings a file back.

## What you need

- [uv](https://docs.astral.sh/uv/), which also runs timewalk
- [git](https://git-scm.com/) and [just](https://just.systems/)
- Chrome, Edge or another recent browser

## Start

Fork this repository on GitHub first, so that you can keep your own notes. When you fork it, untick **Copy the
`main` branch only**, because the tutorial is on the branch `tutorial`. You can also clone
`rahuldave/babykev-walk` itself in place of a fork.

```
git clone -b tutorial https://github.com/<you>/babykev-walk
cd babykev-walk
just present tutorial-do   # do mode: you make the moves
just present               # watch mode: the moves are shown
```

`just present` opens the first walk, `tutorial`, and `just present tutorial-do` opens the walk `tutorial-do`.
`just present narrative` opens the first lecture, the steps `step-00` to `step-05b` on the branch `main` of
babykev. `just present` runs `just setup` first. `just setup` clones babykev into `repo/`, or your fork of
babykev if you have one, and fetches the tags of the steps. To clone from another address, run `just setup <address>` before the first
`just present`.

timewalk then puts its replay copy in `worktree/`. The replay copy is a clone of `repo/` on the branch
`timewalk/replay`, and timewalk moves it from step to step and from move to move. timewalk never writes to
`repo/`. Git ignores both folders.

`just check` checks the notes and the slides of every walk against its steps and moves. `just pdf` makes
`build/walk.pdf`, the slides of the tutorial, and `just pdf narrative` makes `build/walk-narrative.pdf`, the
slides of the first lecture.

## The folders

```
babykev-walk/
├── toc.toml                      the walks: tutorial and tutorial-do, over the same commits, and narrative
├── walks/tutorial/notes.md       the notes of every step and move, for timewalk
├── walks/tutorial/TUTORIAL-*.md  the tutorial to read on GitHub, in watch mode and in do mode
├── walks/tutorial/slides/        the slides, and slides.toml, which step or move shows which
├── walks/narrative/              the notes and the slides of the first lecture, on the tags step-*
├── site/                         the website, made from notes.md; GitHub publishes it on every push
├── justfile                      present, setup, check, pdf, site
├── repo/                         ignored: your clone of babykev
└── worktree/                     ignored: the replay copy, at the step on show
```
