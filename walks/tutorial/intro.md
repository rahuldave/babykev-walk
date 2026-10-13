The tutorial builds babykev, a small decision model, and the engineering around it. babykev reads a document
and a set of typed questions, and gives a probability for every answer. Its model comes from the first commit of
[kev](https://github.com/jaredpalmer/kev), by Jared Palmer. The tutorial adds the rest, one move at a time. It adds
packaging with uv, one interface with `just`, tests, format, lint, types, docs, and the tests of the model.

The project is on the branch `tutorial` of [babykev](https://github.com/rahuldave/babykev/tree/tutorial). Each
step is a tag, `tut-00`, `tut-01` and so on. The small commits between two tags are the moves. Each move does one
thing, and ends with a command that shows what it did.

The tutorial has two modes, with the same text:

- **Watch mode** explains what each move changed. The code of each move is already there.
- **Do mode** gives every line to type, and every command that makes the move.
