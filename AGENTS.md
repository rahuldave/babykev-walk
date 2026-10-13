# babykev-walk, the tutorial

This repository is a timewalk tutorial through the project babykev, on its branch `tutorial`. `toc.toml` names two
walks over the same commits, the tags `tut-*` of babykev. The walk `tutorial` starts in watch mode, and the walk
`tutorial-do` starts in do mode. In do mode, the learner makes each move. In watch mode, timewalk checks out each
move.

The notes are in `walks/tutorial/notes.md`, with a `## tut-NN` section for each step and a `### tut-NN.k` section
for each move, in the order of the commits. `walks/tutorial/TUTORIAL-watch.md`, `walks/tutorial/TUTORIAL-do.md`
and `site/` are copies that timewalk-export makes from the notes. Do not edit them by hand.

- `just present tutorial-do` or `just present` opens the tutorial. `just check` checks the notes against the
  project.
- `repo/` is the clone of babykev of the learner. `worktree/` is the replay copy of timewalk, a clone of `repo/` on
  the branch `timewalk/replay`. Git tracks neither. timewalk never writes to `repo/`.
- A move keeps the edits and commits of the learner in `worktree/`, on a branch `timewalk/saved/<place>`, and does
  not ask. The moves of a step go in order. To go back, use **Restart step**, and then run `just setup`.
- The class material of the teacher makes these files. Do not change the justfile, `toc.toml` or `.gitignore`
  for the needs of one learner. A learner can edit the notes and commit them to a fork.
