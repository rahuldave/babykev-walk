We build babykev, a small decision model, and the engineering around it. babykev reads a text and a set of typed
questions about it, and gives a probability for every answer. Its contract and its model come from the first
version of [kev](https://github.com/jaredpalmer/kev), by Jared Palmer. We add packaging with uv, one list of tasks
in `just`, tests, format, lint, types, docs, and the tests of the model. The project is on the branch `tutorial`
of [babykev](https://github.com/rahuldave/babykev/tree/tutorial).

We make babykev in moves. A move is one small change, made by one patch or by one command. A patch changes a file,
and a command such as `uv add` writes the files it needs.

There are two ways to follow. In do mode, you make each move, and the page checks your files against it. When they
match, the move is made, and the next one starts. In watch mode, each change is already made, and the text says
what it did and where to look.

Each move first says what problem it solves. Then it gives the change, piece by piece. Last, a command checks the
result, and a list names each file that changed, with what to look for in it.
