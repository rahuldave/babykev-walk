<!-- Made by the walk skill's render.py from the facts of the walk. Do not edit it by hand: run just walk-update again. -->

# just, the recipes of babykev

**Build it yourself.** Every command to run and every change to make by hand, to make the project yourself. [Read the tutorial](read.md) is the other way to read it.

Each part ends with a section called **What changed**. It lists every file that the part changes, with a link to the file, and then the whole diff of each file, folded. A lockfile and a binary file have a link alone. The text above it explains the change. What changed is what you check your files against.

In Build it yourself, a file that a command makes says which command. A diff that is open is a patch. Apply it with the command in the text, or make the same change in your editor.

We follow the `justfile` of babykev, a small decision model. The program `just` reads this file. The file gives
each task of the project a short name, a verb, such as `just test`. The commands behind a verb are its recipe.

A person, a git hook, a Docker image and GitHub all run the same tasks. The recipes keep the commands in one place,
so each of them runs the same thing. `just` alone lists the verbs, `just help VERB` explains one, and
`just --show VERB` prints its recipe. This tutorial takes the recipes out of the whole tutorial of babykev, one at a
time, as each one comes in.

Most sections bring in a verb with three commands. First the tool's own command runs, then `just --show VERB` shows
the recipe, and then the verb runs.

We make the project in moves. A move is one small change, made by one patch or by one command. In watch mode, each
change is already made, and the text says what it did. In do mode, you make each move, and the page checks your
files against it.

Some changes of the whole tutorial are not in this one. After such a gap, the next section says what those changes
did, and begins from the code that they left. It first runs `just setup`, which installs the packages of that code.

**What `just check` runs**

`just check` runs every check that a `git commit` must pass, and stops at the first that fails. The table gives each
section that changes what it runs.

| Section | What `just check` runs from there on |
|---|---|
| `just check` and `just hook` | `just fmt --check`, `just lint` and `just test -q` |
| `just lint-config` | `just lint-config` too, last |
| The docs check joins `just check` | `just docs check` too, after the tests |
| `just types` | `just types` too, after the linter |
| The floor on the coverage | `just test -q --cov-fail-under=90` in place of `just test -q` |
| `just image` | `just lint-config` checks the `Dockerfile` too |
| GitHub runs `just check` | `just lint-config` checks the workflows too |

The project is managed by [uv](https://docs.astral.sh/uv/), which installs Python and the packages, keeps them in `.venv`, and pins their versions in `uv.lock`. `just setup` runs `uv sync`.

## Get the project

You build the project in a clone of your own, on a branch `mine` that starts where this walk starts. Run the commands of these pages in its top folder.

```bash
git clone https://github.com/rahuldave/babykev
cd babykev
git switch -c mine e32c7ba9f798
```

Then add the command `git check`, which compares your files with the project's after each move, and leaves what `git add` has staged as it was. It compares `pyproject.toml` and `uv.lock` by the names of their packages, so another version of a package does not count as a difference. A small Python program, `package_names.py`, reads each of these files as data, and uv runs it. These commands write the program into the folder `.git`, and tell git to show each file as the program prints it.

```bash
cat > "$(git rev-parse --git-common-dir)/package_names.py" <<'PY'
"""Print a pyproject.toml or a uv.lock without the versions of its packages, so that git check compares their names.

    python package_names.py pyproject.toml FILE
    python package_names.py uv.lock FILE

A pyproject.toml keeps all it says, with each requirement cut to its name, its extras, its address and its marker. A
uv.lock keeps the names that the project's own packages ask for, and the members of the workspace. The rules are those
of timewalk's package_names. The result is JSON, one item a line. A file that is not TOML is printed as it is.
"""

import json
import re
import sys
import tomllib

# A requirement such as "pytest>=8.3.4", "Uvicorn[standard] ; python_version < '3.12'" or "x @ git+https://...": its name,
# its extras, what comes between (the versions, or "@" and an address), and its marker after the ";".
REQUIREMENT = re.compile(r"^\s*([A-Za-z0-9][A-Za-z0-9._-]*)\s*(\[[^\]]*\])?([^;]*)(?:;(.*))?$", re.S)


def package_names(
    path: str,  # The file's path in the project; its name says how to read it
    data: bytes,  # Its contents
) -> object | None:  # What it says without the versions of packages, to compare; None if it is not a file of packages
    """Read a pyproject.toml or a uv.lock with the versions left out, as timewalk's package_names does."""
    name = path.rsplit("/", 1)[-1]
    if name not in ("pyproject.toml", "uv.lock"):
        return None
    try:
        doc = tomllib.loads(data.decode("utf-8"))
    except (UnicodeDecodeError, tomllib.TOMLDecodeError):
        return None

    def cut(requirement: object) -> object:   # "pytest>=8.3.4" is pytest; a table, such as { include-group = "test" }, stays
        found = REQUIREMENT.match(requirement) if isinstance(requirement, str) else None
        if not found:
            return requirement
        extras = sorted(e.strip().lower() for e in (found.group(2) or "[]")[1:-1].split(",") if e.strip())
        between, marker = found.group(3).strip(), " ".join((found.group(4) or "").split())
        address = between[1:].strip() if between.startswith("@") else ""   # a package from an address: the address counts
        return (re.sub(r"[-_.]+", "-", found.group(1)).lower() + (f"[{','.join(extras)}]" if extras else "")
                + (f" @ {address}" if address else "") + (f"; {marker}" if marker else ""))

    def names(value: object) -> list:   # every name = "..." in a table, at any depth
        if isinstance(value, dict):
            return [*([value["name"]] if isinstance(value.get("name"), str) else []), *(n for v in value.values() for n in names(v))]
        return [n for v in value for n in names(v)] if isinstance(value, list) else []

    if name == "uv.lock":
        own = [p for p in doc.get("package", []) if isinstance(p, dict) and isinstance(p.get("source"), dict)
               and {"editable", "virtual"} & set(p["source"])]
        return {"requires-python": doc.get("requires-python"), "manifest": sorted(set(names(doc.get("manifest", {})))),
                "own": {p.get("name"): sorted(set(names({k: v for k, v in p.items() if k not in ("name", "version", "source")})))
                        for p in own}}
    lists = [("project", "dependencies"), ("build-system", "requires"), ("tool", "uv", "dev-dependencies")]
    groups = [("project", "optional-dependencies"), ("dependency-groups",)]

    def at(keys: tuple) -> object:   # the table or list at a path of keys, or None
        value = doc
        for key in keys:
            value = value.get(key) if isinstance(value, dict) else None
        return value

    for keys in lists:
        if isinstance(at(keys), list):
            at(keys[:-1])[keys[-1]] = sorted(map(cut, at(keys)), key=repr)
    for keys in groups:
        table = at(keys)
        for group, wanted in (table.items() if isinstance(table, dict) else []):
            if isinstance(wanted, list):
                table[group] = sorted(map(cut, wanted), key=repr)
    return doc


def main() -> int:  # The exit code
    """Print a file as package_names reads it, or as it is when it is not TOML."""
    kind, file = sys.argv[1], sys.argv[2]
    with open(file, "rb") as handle:
        data = handle.read()
    found = package_names(kind, data)
    if found is None:
        sys.stdout.buffer.write(data)
    else:
        print(json.dumps(found, indent=1, sort_keys=True, ensure_ascii=False, default=str))
    return 0


if __name__ == "__main__":
    sys.exit(main())
PY
echo '/pyproject.toml diff=pyproject' >> .git/info/attributes
echo '/uv.lock diff=uvlock' >> .git/info/attributes
git config diff.pyproject.textconv 'uv run --quiet --no-config --no-project --python ">=3.11" python "$(git rev-parse --git-common-dir)/package_names.py" pyproject.toml'
git config diff.uvlock.textconv 'uv run --quiet --no-config --no-project --python ">=3.11" python "$(git rev-parse --git-common-dir)/package_names.py" uv.lock'
git config alias.check '!f() { i="$(git rev-parse --git-path check-index)" && { cp -p "$(git rev-parse --git-path index)" "$i" 2>/dev/null || rm -f "$i"; } && export GIT_INDEX_FILE="$i" && git add -A && git diff --cached "$1" -- ":/"; }; f'
```

<a id="tut-01.9-to-tut-01.12"></a>

## 1.9 to 1.12 The project, and its justfile

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `e32c7ba9f798`, partway through `tut-01`. [The code before this part](https://github.com/rahuldave/babykev/tree/e32c7ba9f7983fc03cc8d91411562b1eac1d38e9)

The project already has its words and its command. `uv init` made it a Python package, and `uv lock` wrote its lockfile
`uv.lock`. `src/babykev/cli.py` holds the command `babykev`, which so far prints only its help. There is no
justfile yet, so do not run `just` before the first move of this section.

The first recipe, `setup`, makes the environment of the project. The second, `help`, explains a verb.

<a id="tut-01.9"></a>

### 1.9 A justfile with the recipe setup

The command that sets up the project is `uv sync --locked`, and nobody should have to remember it. A `justfile` names
each task of the project once. `just` reads the file. Each task is a recipe, a name and then the commands to run,
indented. Before the justfile comes in, we run the command of the recipe `setup` by hand.

[just](https://just.systems/) runs commands by name. A file called `justfile` lists recipes. Each has a name, a comment that says what it does, and the commands it runs. `just setup` runs the recipe `setup`, and `just` alone lists every recipe. So the justfile is the one place that says how to work on the project, for a person and for a machine.

```bash
uv sync --locked
```

`uv sync` makes `.venv` exactly as `uv.lock` says. `--locked` makes it refuse a `uv.lock` that no longer matches
`pyproject.toml`. It prints `Resolved 1 package`. When `.venv` is already right, it then prints `Checked 1 package`, and changes
nothing. In a new clone, it first prints `Creating virtual environment at: .venv`, and then installs babykev.

Apply the patch to [`justfile`](#tut-01.9-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/e14dffa877a2d24a53d67d8dd3d54b17204885b1.diff | git apply --include=justfile
```

Read the recipe `setup` at the end of the file, and the comment above it.

`just` alone runs the first recipe, `default`, which lists the others. `[private]` keeps `default` out of the list.
The comment above a recipe is its line in the list. `[group('setup')]` puts the recipe under a heading.

```bash
just --show setup
just setup
just
```

`just --show setup` prints the recipe. `just setup` prints the command, `uv sync --locked`, then runs it. `just` lists
the one recipe, under `[setup]`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check e14dffa877a2
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source e32c7ba9f798 --staged -- :/ && git restore --source e14dffa877a2 --staged --worktree -- :/
```

#### What changed

- <a id="tut-01.9-justfile-424f0b"></a>`justfile`: the recipe `setup` and its line. New, 10 lines. [The file](https://github.com/rahuldave/babykev/blob/e14dffa877a2d24a53d67d8dd3d54b17204885b1/justfile).
  - look at `setup:`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -0,0 +1,10 @@
+# babykev: every task is a recipe here. `just` lists them.
+
+[private]
+default:
+    @just --list --unsorted
+
+# Install Python and every dependency into .venv, exactly as the lockfile says
+[group('setup')]
+setup:
+    uv sync --locked
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e14dffa877a2d24a53d67d8dd3d54b17204885b1). [The code after it](https://github.com/rahuldave/babykev/tree/e14dffa877a2d24a53d67d8dd3d54b17204885b1).

<a id="tut-01.10"></a>

### 1.10 The recipe help

`just` lists the recipes, but nothing explains one of them. A recipe `help` does. `just help setup` prints the line of
the recipe `setup`, and `just help` alone prints the list.

`help` needs the word after its name, for example `setup` in `just help setup`. The line
`set positional-arguments` passes such words to the commands of a recipe. The first word becomes `"$1"` and the
second `"$2"`, and a word with spaces in it stays one word. So `help` finds the name `setup` in `"$1"`.

Apply the patch to [`justfile`](#tut-01.10-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/a55c90355687e4bf94dfad2277262548ba4ea682.diff | git apply --include=justfile
```

Read the recipe `help`, after `default`, and the line `set positional-arguments` near the top.

`help` runs `just --show` for the recipe, and prints its first line without the `# `. For a recipe with a comment,
that line is the comment.

```bash
just --show help
just help setup
just help
```

`just --show help` prints the recipe. `just help setup` prints
`Install Python and every dependency into .venv, exactly as the lockfile says`. `just help` prints the list, now with
`help` first.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check a55c90355687
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source e14dffa877a2 --staged -- :/ && git restore --source a55c90355687 --staged --worktree -- :/
```

#### What changed

- <a id="tut-01.10-justfile-424f0b"></a>`justfile`: the recipe `help`. 12 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/a55c90355687e4bf94dfad2277262548ba4ea682/justfile).
  - look at `help *verb:`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -1,9 +1,20 @@
-# babykev: every task is a recipe here. `just` lists them.
+# babykev: every task is a recipe here. `just` lists them; `just help VERB` explains one.
+
+# Each word after a recipe's name reaches its commands whole, as "$1", "$2" and so on; "$@" is all of them
+set positional-arguments
 
 [private]
 default:
     @just --list --unsorted
 
+# Explain a verb: its line. Alone, the list
+[no-exit-message]
+help *verb:
+    #!/usr/bin/env sh
+    if [ "$#" -eq 0 ]; then just --list --unsorted; exit 0; fi
+    shown=$(just --show "$1") || exit 1
+    printf '%s\n' "$shown" | head -1 | sed 's/^# //'
+
 # Install Python and every dependency into .venv, exactly as the lockfile says
 [group('setup')]
 setup:
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a55c90355687e4bf94dfad2277262548ba4ea682). [The code after it](https://github.com/rahuldave/babykev/tree/a55c90355687e4bf94dfad2277262548ba4ea682).

<a id="tut-01.11"></a>

### 1.11 setup answers help

A person who types `just setup help` gets `uv sync --locked`, and no help. The recipe `setup` now takes words, and
answers the word `help` with `just help setup`. The `@` at the start of its line stops `just` from printing the
command before it runs it.

Apply the patch to [`justfile`](#tut-01.11-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/3016e7ee53854d719456c12a48c8c8e620614bde.diff | git apply --include=justfile
```

The patch writes the recipe `setup` again, with `*args` and one line.

```bash
just setup help
just setup
```

`just setup help` prints the line of `setup`. `just setup` prints `Resolved 1 package` and `Checked 1 package`. It no
longer prints `uv sync --locked` first, because of the `@`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 3016e7ee5385
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source a55c90355687 --staged -- :/ && git restore --source 3016e7ee5385 --staged --worktree -- :/
```

#### What changed

- <a id="tut-01.11-justfile-424f0b"></a>`justfile`: `setup` answers `help`. 2 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/3016e7ee53854d719456c12a48c8c8e620614bde/justfile).
  - look at `@{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -17,5 +17,5 @@ help *verb:
 
 # Install Python and every dependency into .venv, exactly as the lockfile says
 [group('setup')]
-setup:
-    uv sync --locked
+setup *args:
+    @{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3016e7ee53854d719456c12a48c8c8e620614bde). [The code after it](https://github.com/rahuldave/babykev/tree/3016e7ee53854d719456c12a48c8c8e620614bde).

<a id="tut-01.12"></a>

### 1.12 help gives the help of the program too

Later recipes run the program, as `uv run babykev VERB`. Their help should also show the help of the program. A
variable, `program`, names the command once. `help` looks for `uv run {{ program }} VERB` in a recipe, and then runs
the program's own help too.

Apply the patch to [`justfile`](#tut-01.12-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/9218f21a784277593cf6930e10389b04e41bf9d0.diff | git apply --include=justfile
```

The patch adds `program := "babykev"` above `set positional-arguments`, and two lines at the end of `help`.

`just` replaces each `{{ ... }}` in a recipe with its value. So the text `{{ program }}` cannot stand in a recipe as it
is. `{{ "{{ program }}" }}` is a value in quotes, and `just` writes it as the text `{{ program }}`. No recipe runs the
program yet, so the new branch waits for one.

```bash
just --evaluate program
just help setup
```

`just --evaluate program` prints `babykev`. `just help setup` prints the line of `setup`, as before.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 9218f21a7842
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 3016e7ee5385 --staged -- :/ && git restore --source 9218f21a7842 --staged --worktree -- :/
```

#### What changed

- <a id="tut-01.12-justfile-424f0b"></a>`justfile`: the variable `program`, and the branch of `help` that runs the program's help. 6 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/9218f21a784277593cf6930e10389b04e41bf9d0/justfile).
  - look at `program := "babykev"`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -1,5 +1,7 @@
 # babykev: every task is a recipe here. `just` lists them; `just help VERB` explains one.
 
+program := "babykev"
+
 # Each word after a recipe's name reaches its commands whole, as "$1", "$2" and so on; "$@" is all of them
 set positional-arguments
 
@@ -7,13 +9,16 @@ set positional-arguments
 default:
     @just --list --unsorted
 
-# Explain a verb: its line. Alone, the list
+# Explain a verb: its line, and the program's flags where the program has them. Alone, the list
 [no-exit-message]
 help *verb:
     #!/usr/bin/env sh
     if [ "$#" -eq 0 ]; then just --list --unsorted; exit 0; fi
     shown=$(just --show "$1") || exit 1
     printf '%s\n' "$shown" | head -1 | sed 's/^# //'
+    if printf '%s\n' "$shown" | grep -qF '{{ "{{ program }}" }} '"$1"; then
+        uv run {{ program }} "$1" help
+    fi
 
 # Install Python and every dependency into .venv, exactly as the lockfile says
 [group('setup')]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9218f21a784277593cf6930e10389b04e41bf9d0).

This part ends at the code at `9218f21a7842`, partway through `tut-01`. [The code after this part](https://github.com/rahuldave/babykev/tree/9218f21a784277593cf6930e10389b04e41bf9d0)

<a id="tut-02.2-to-tut-02.3"></a>

## 2.2 to 2.3 `just test`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `ad616a5cc1fc`, partway through `tut-02`. [The code before this part](https://github.com/rahuldave/babykev/tree/ad616a5cc1fcdf5b7c1672b79d0d2b267b72bd59)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git restore --source 9218f21a7842 --staged -- :/ && git restore --source ad616a5cc1fc --staged --worktree -- :/
```

```bash
just setup
```

The README now says how to begin, and what each file is. A setting in `pyproject.toml`, `default-groups = "all"`,
makes uv install every dependency group. A dependency group is a named list of packages that only the people who
work on babykev need.

pytest comes into the group `test`, and the command that runs it gets a recipe.

<a id="tut-02.2"></a>

### 2.2 Pytest, in the group test

Nothing runs tests yet. pytest finds the tests and runs them. It goes into the group `test`.

[pytest](https://docs.pytest.org/) is the test runner of most Python projects. It finds every file `test_*.py`, runs each function whose name starts with `test_`, and reports each failure with the values that made it fail. A test is a plain function with `assert` in it.

```bash
uv add --group test pytest
```

`uv add --group test` writes the group `test` in `pyproject.toml`, under `[dependency-groups]`. It prints
`Resolved 7 packages`, and lists pytest and the four packages it needs.

If a newer pytest is out, `uv add` writes its version as the lower bound. That line then differs from the one here,
and so does `uv.lock`. Only the versions differ.

```bash
uv run pytest
```

`uv run pytest` looks for tests and finds none. It prints `collected 0 items` and `no tests ran`, and ends with exit
code 5. pytest uses exit code 5 to say that it found no test.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 966956d738b5
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source ad616a5cc1fc --staged -- :/ && git restore --source 966956d738b5 --staged --worktree -- :/
```

#### What changed

- <a id="tut-02.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: the group `test`, with pytest. 5 lines added. It comes from `uv add --group test pytest`. [The file](https://github.com/rahuldave/babykev/blob/966956d738b58505e23586af60f05cd5daceb12f/pyproject.toml).
  - look at `"pytest>=9.1.1",`
- <a id="tut-02.2-uv.lock-8356d8"></a>`uv.lock`: pytest and the five packages it needs. 71 lines added. It comes from `uv add --group test pytest`. [The file](https://github.com/rahuldave/babykev/blob/966956d738b58505e23586af60f05cd5daceb12f/uv.lock).

<details><summary>The diff that <code>uv add --group test pytest</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -19,3 +19,8 @@ build-backend = "uv_build"
 [tool.uv]
 # uv sync and uv run install every dependency group, not only dev
 default-groups = "all"
+
+[dependency-groups]
+test = [
+    "pytest>=9.1.1",
+]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/966956d738b58505e23586af60f05cd5daceb12f). [The code after it](https://github.com/rahuldave/babykev/tree/966956d738b58505e23586af60f05cd5daceb12f).

<a id="tut-02.3"></a>

### 2.3 The recipe test

The command that runs the tests is `uv run pytest`, and every task of the project has a recipe. A recipe `test` gives
the command a short name.

Apply the patch to [`justfile`](#tut-02.3-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/b0840709e371a548d4b922c57c679ba040dd2c1a.diff | git apply --include=justfile
```

The patch adds the recipe `test` at the end of `justfile`, after one blank line.

`test` gives every word after its name to pytest, as `"$@"`. So `just test -k help` runs `uv run pytest -k help`. The
word `help` alone prints the line of the recipe. pytest prints what failed, so `[no-exit-message]` stops `just` from
adding a line of its own when pytest ends with an error.

```bash
just --show test
just test
just help test
```

`just --show test` prints the recipe. `just test` runs pytest, which finds no test, prints `no tests ran` and ends with
exit code 5. `just` prints no line of its own about the error. `just help test` prints the line of the recipe.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check b0840709e371
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 966956d738b5 --staged -- :/ && git restore --source b0840709e371 --staged --worktree -- :/
```

#### What changed

- <a id="tut-02.3-justfile-424f0b"></a>`justfile`: the recipe `test`. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/b0840709e371a548d4b922c57c679ba040dd2c1a/justfile).
  - look at `test *args:`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -24,3 +24,9 @@ help *verb:
 [group('setup')]
 setup *args:
     @{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
+
+# Run the tests. Extra words go to pytest: just test -k render
+[group('quality')]
+[no-exit-message]
+test *args:
+    @{{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b0840709e371a548d4b922c57c679ba040dd2c1a).

This part ends at the code at `b0840709e371`, partway through `tut-02`. [The code after this part](https://github.com/rahuldave/babykev/tree/b0840709e371a548d4b922c57c679ba040dd2c1a)

<a id="tut-07"></a>

## 7 `just fmt`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-06`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-06)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source b0840709e371 --staged -- :/ && git restore --source tut-06 --staged --worktree -- :/
```

The whole tutorial then writes tests of the command, and measures the coverage on every run. It brings in the
contract of a request, `src/babykev/api.py`, with pydantic, and five requests about cheese as sample data. Then come
the tests of the contract, and the code that turns a request into text for the model. More code turns the answers of
the model back into JSON, and tests find two bugs in it, and the code gets their fixes. `just test` prints `53 passed`.

The code mixes styles. ruff comes in, and `just fmt` formats the code and the tests.

```bash
just setup
```

`just setup` prints `Resolved 14 packages`.

kev wrote `api.py` in a style of his own. Some lines hold an `if` and its `return` together, and some lines run past
200 characters. The tests check what the code does, and nothing checks how it looks. A formatter writes every file
in one style, so that a later change shows only what changed, and no fight over spaces and line breaks. ruff comes
first into the project, then its settings and a recipe. Then the check fails on `api.py`, and the formatter
rewrites the file.

<a id="tut-07.1"></a>

### 7.1 Ruff, in the group lint

Nothing formats the code yet. ruff is a formatter and a linter in one program. The formatter changes how the code
looks, and never what it does. The linter comes in the next part of the tutorial. ruff is for working on babykev,
and a user of the package does not need it. So it goes in a second dependency group, `lint`, next to the group
`test`.

[ruff](https://docs.astral.sh/ruff/) is a formatter and a linter for Python, written in Rust by the makers of uv. As a formatter, it rewrites code into one layout. As a linter, it reads code for mistakes and bad habits, each rule with a code such as `F401`. It takes the place of black, isort, flake8 and many plugins, and it is fast.

```bash
uv add --group lint ruff
```

`uv add` prints `Resolved 15 packages`, and installs ruff. ruff is one program, and needs no other
package.

If a newer ruff is out, `uv add` writes its version as the lower bound. That line then differs from the one here,
and so does `uv.lock`. Only the versions differ.

```bash
uv run ruff --version
uv run ruff format --check
```

`uv run ruff --version` prints the version of ruff that uv installed. `ruff format --check` changes nothing. It prints what it would
change in each file, and ends with `3 files would be reformatted, 3 files already formatted`, and exit code 1. The
three files are `src/babykev/api.py`, `src/babykev/cli.py` and `tests/unit/test_api.py`. By default, ruff lets a
line run to 88 characters. Line 19 of `cli.py` has 94 characters, so ruff would split it.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 5085d2a6ae47
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-06 --staged -- :/ && git restore --source 5085d2a6ae47 --staged --worktree -- :/
```

#### What changed

- <a id="tut-07.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the group `lint`, with ruff. 3 lines added. It comes from `uv add --group lint ruff`. [The file](https://github.com/rahuldave/babykev/blob/5085d2a6ae47a58d6259dfa06679bb2a9be692e1/pyproject.toml).
  - look at `"ruff>=0.17.1",`
- <a id="tut-07.1-uv.lock-8356d8"></a>`uv.lock`: ruff, at its exact version. 29 lines added. It comes from `uv add --group lint ruff`. [The file](https://github.com/rahuldave/babykev/blob/5085d2a6ae47a58d6259dfa06679bb2a9be692e1/uv.lock).

<details><summary>The diff that <code>uv add --group lint ruff</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -23,6 +23,9 @@ build-backend = "uv_build"
 default-groups = "all"
 
 [dependency-groups]
+lint = [
+    "ruff>=0.17.1",
+]
 test = [
     "pytest>=9.1.1",
     "pytest-cov>=7.1.0",
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5085d2a6ae47a58d6259dfa06679bb2a9be692e1). [The code after it](https://github.com/rahuldave/babykev/tree/5085d2a6ae47a58d6259dfa06679bb2a9be692e1).

<a id="tut-07.2"></a>

### 7.2 Lines of up to 100 characters

At 88 characters, the formatter would split lines of `cli.py` and of the tests that read well as they are. The
setting `line-length` in the table `[tool.ruff]` lets a line run to 100 characters. The formatter and the linter
both read the table.

Set the values that this change sets in [`pyproject.toml`](#tut-07.2-pyproject.toml-5d07e7). Run this command from the top of the project. It reads your file with tomlkit, a library for TOML files. It copies each of these tables and values from the project's file after this change, with their comments, and keeps the rest of your file:

```bash
uv run --quiet --no-config --no-project --with tomlkit python - <<'PY'
import copy, pathlib, subprocess, tomlkit
from tomlkit.items import Comment, Table, Whitespace
path = pathlib.Path('pyproject.toml')
doc = tomlkit.parse(path.read_text(encoding='utf-8')) if path.exists() else tomlkit.document()
# The project's file after this change, from your clone
project = tomlkit.parse(subprocess.run(['git', 'show', '58d9bddfeea6:pyproject.toml'], capture_output=True, text=True,
                                        check=True).stdout)
# Each table and value that the change sets, by its keys: each comes from the project's file with its comments
COPY = [
    ('tool', 'ruff'),
]

def body(table):   # the items of a table in their order, with its comment lines
    inner = table if isinstance(table, tomlkit.TOMLDocument) else getattr(table, 'value', None)
    return getattr(inner, 'body', [])

def above(table, key):   # the comment lines just above a key
    found = []
    for name, item in body(table):
        if name is not None and name.key == key:
            return found
        found = found + [item] if isinstance(item, Comment) else found if isinstance(item, Whitespace) else []
    return []

for keys in COPY:
    source, target = project, doc
    for key in keys[:-1]:   # make each table on the way
        source = source[key]
        if key not in target:
            target[key] = tomlkit.table(True)
        target = target[key]
    item = copy.deepcopy(source[keys[-1]])
    if isinstance(item, Table) and not item.as_string().endswith('\n\n'):
        item.add(tomlkit.nl())   # a blank line before the table after it
    if keys[-1] not in target:
        for comment in above(source, keys[-1]):
            target.add(copy.deepcopy(comment))
    target[keys[-1]] = item
path.write_text(tomlkit.dumps(doc), encoding='utf-8')
PY
```

The patch adds the table `[tool.ruff]` to `pyproject.toml`, with a comment and `line-length = 100`.

```bash
uv run ruff format --check
```

The check now ends with `1 file would be reformatted, 5 files already formatted`, and exit code 1. `cli.py` and the
tests have no line over 100 characters, so they pass, and `api.py` still fails. ruff prints each change it would
make, with the old lines marked `-` and the new ones `+`. The one-line `if` of `_check`, at line 27, becomes two
lines, and so do the three of `render`, at lines 48 to 50. The long dictionaries of `to_record` and `to_answers`
are split, one key on each line.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 58d9bddfeea6
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 5085d2a6ae47 --staged -- :/ && git restore --source 58d9bddfeea6 --staged --worktree -- :/
```

#### What changed

- <a id="tut-07.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: the table `[tool.ruff]`. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/58d9bddfeea6344a159569664ac9f9ff489173a6/pyproject.toml).
  - look at `line-length = 100`

<details open><summary>The patch to <code>pyproject.toml</code></summary>

```diff
@@ -35,3 +35,7 @@ test = [
 testpaths = ["tests"]
 # Every run measures how much of src/babykev the tests run, and lists the lines they do not
 addopts = "--cov=babykev --cov-report=term-missing"
+
+[tool.ruff]
+# The formatter and the linter share this setting. ruff's own default is 88, and this project uses 100
+line-length = 100
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/58d9bddfeea6344a159569664ac9f9ff489173a6). [The code after it](https://github.com/rahuldave/babykev/tree/58d9bddfeea6344a159569664ac9f9ff489173a6).

<a id="tut-07.3"></a>

### 7.3 The settings of the formatter, written out

The formatter has almost no options, and its defaults are its style. A reader of `pyproject.toml` cannot see them.
The table `[tool.ruff.format]` writes out five of them, each with a comment. They are the defaults, so the output of
the formatter does not change.

Set the values that this change sets in [`pyproject.toml`](#tut-07.3-pyproject.toml-5d07e7). Run this command from the top of the project. It reads your file with tomlkit, a library for TOML files. It copies each of these tables and values from the project's file after this change, with their comments, and keeps the rest of your file:

```bash
uv run --quiet --no-config --no-project --with tomlkit python - <<'PY'
import copy, pathlib, subprocess, tomlkit
from tomlkit.items import Comment, Table, Whitespace
path = pathlib.Path('pyproject.toml')
doc = tomlkit.parse(path.read_text(encoding='utf-8')) if path.exists() else tomlkit.document()
# The project's file after this change, from your clone
project = tomlkit.parse(subprocess.run(['git', 'show', 'ff4c6545868d:pyproject.toml'], capture_output=True, text=True,
                                        check=True).stdout)
# Each table and value that the change sets, by its keys: each comes from the project's file with its comments
COPY = [
    ('tool', 'ruff', 'format'),
]

def body(table):   # the items of a table in their order, with its comment lines
    inner = table if isinstance(table, tomlkit.TOMLDocument) else getattr(table, 'value', None)
    return getattr(inner, 'body', [])

def above(table, key):   # the comment lines just above a key
    found = []
    for name, item in body(table):
        if name is not None and name.key == key:
            return found
        found = found + [item] if isinstance(item, Comment) else found if isinstance(item, Whitespace) else []
    return []

for keys in COPY:
    source, target = project, doc
    for key in keys[:-1]:   # make each table on the way
        source = source[key]
        if key not in target:
            target[key] = tomlkit.table(True)
        target = target[key]
    item = copy.deepcopy(source[keys[-1]])
    if isinstance(item, Table) and not item.as_string().endswith('\n\n'):
        item.add(tomlkit.nl())   # a blank line before the table after it
    if keys[-1] not in target:
        for comment in above(source, keys[-1]):
            target.add(copy.deepcopy(comment))
    target[keys[-1]] = item
path.write_text(tomlkit.dumps(doc), encoding='utf-8')
PY
```

The patch adds the table `[tool.ruff.format]` to `pyproject.toml`. Read the comment beside each setting.

`skip-magic-trailing-comma = false` is the one that a reader meets most. A list that ends with a comma keeps one item
on each line, even when it would fit on one line. The group `lint`, on lines 26 to 28, is such a list.

```bash
uv run ruff format --check
```

The check prints the same as before, `1 file would be reformatted, 5 files already formatted`. The settings are the
defaults, so nothing changes.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check ff4c6545868d
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 58d9bddfeea6 --staged -- :/ && git restore --source ff4c6545868d --staged --worktree -- :/
```

#### What changed

- <a id="tut-07.3-pyproject.toml-5d07e7"></a>`pyproject.toml`: the five settings of the formatter. 8 lines added. [The file](https://github.com/rahuldave/babykev/blob/ff4c6545868df1f51d5aa04277cd16b868550f14/pyproject.toml).
  - look at `quote-style = "double"            # "text", not 'text'`

<details open><summary>The patch to <code>pyproject.toml</code></summary>

```diff
@@ -39,3 +39,11 @@ addopts = "--cov=babykev --cov-report=term-missing"
 [tool.ruff]
 # The formatter and the linter share this setting. ruff's own default is 88, and this project uses 100
 line-length = 100
+
+[tool.ruff.format]
+# These are ruff's defaults, written out so that a reader sees them
+quote-style = "double"            # "text", not 'text'
+indent-style = "space"            # four spaces, never tabs
+skip-magic-trailing-comma = false # a trailing comma keeps one item on each line
+line-ending = "auto"              # the line endings that the file already has
+docstring-code-format = false     # code in a docstring stays as it was written
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ff4c6545868df1f51d5aa04277cd16b868550f14). [The code after it](https://github.com/rahuldave/babykev/tree/ff4c6545868df1f51d5aa04277cd16b868550f14).

<a id="tut-07.4"></a>

### 7.4 The recipe fmt, and the check fails

The command that formats the code is `uv run ruff format`, and every task of the project has a recipe. The recipe
`fmt` runs it, and gives it every word after `fmt`. The check fails, because `api.py` is not formatted yet. The
next part formats it.

Apply the patch to [`justfile`](#tut-07.4-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/03e6443db4c837a51df4786117a33b1d20040c88.diff | git apply --include=justfile
```

The patch adds the recipe `fmt` above the recipe `test`, under the comment that explains it.

```bash
uv run ruff format --check
just --show fmt
just fmt --check
just help fmt
```

`uv run ruff format --check` lists the changes to `api.py` and ends with exit code 1, as before. `just --show fmt`
prints the recipe. `just fmt --check` runs the same command, and prints the same,
`1 file would be reformatted, 5 files already formatted`. It ends with exit code 1, and `just` adds no message of
its own. `just help fmt` prints the line of the recipe.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 03e6443db4c8
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source ff4c6545868d --staged -- :/ && git restore --source 03e6443db4c8 --staged --worktree -- :/
```

#### What changed

- <a id="tut-07.4-justfile-424f0b"></a>`justfile`: the recipe `fmt`. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/03e6443db4c837a51df4786117a33b1d20040c88/justfile).
  - look at `fmt *args:`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -25,6 +25,12 @@ help *verb:
 setup *args:
     @{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
 
+# Write the Python of the project in one style. Extra words go to ruff: just fmt --check
+[group('quality')]
+[no-exit-message]
+fmt *args:
+    @{{ if args == "help" { "just help fmt" } else { 'uv run ruff format "$@"' } }}
+
 # Run the tests. Extra words go to pytest: just test -k render
 [group('quality')]
 [no-exit-message]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/03e6443db4c837a51df4786117a33b1d20040c88). [The code after it](https://github.com/rahuldave/babykev/tree/03e6443db4c837a51df4786117a33b1d20040c88).

<a id="tut-07.5"></a>

### 7.5 The code, formatted

`just fmt --check` found one file that does not follow the style, `api.py`. `just fmt` rewrites it.

```bash
just fmt
```

`just fmt` prints `1 file reformatted, 5 files left unchanged`.

```bash
just fmt --check
just test
```

`just fmt --check` prints `6 files already formatted`, and ends with exit code 0. `just test` prints `53 passed`, and
a total of 100%, of 83 statements. `api.py` has 75 of them. Coverage counts each line with a statement, and each of
the four one-line `if` statements of `_check` and `render` is now two lines.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 84b3ac0ce858
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source 03e6443db4c8 --staged -- :/ && git restore --source tut-07 --staged --worktree -- :/
```

#### What changed

- <a id="tut-07.5-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the same code, in the style of the formatter. 35 lines added, 8 removed. It comes from `just fmt`. [The file](https://github.com/rahuldave/babykev/blob/84b3ac0ce858d907d8d59ffdc9c9096ab8cb2ac4/src/babykev/api.py).
  - look at `        if not 1 <= len(self.criteria) <= MAX_OPTIONS:`

<details><summary>The diff that <code>just fmt</code> makes in <code>src/babykev/api.py</code></summary>

```diff
@@ -4,6 +4,7 @@ Noul   -> 2 options [false, true];            answer = p(true)
 Choice -> options 'name' or 'name: desc';      answer = argmax, probabilities by name, confidence
 Score  -> options = ordered level descriptions; answer = expected level, legend, probabilities by index
 """
+
 from typing import Any, Literal, Union
 from pydantic import BaseModel, Field, model_validator
 
@@ -24,7 +25,8 @@ class Choice(BaseModel):
 
     @model_validator(mode="after")
     def _check(self):
-        if not 1 <= len(self.criteria) <= MAX_OPTIONS: raise ValueError(f"criteria must have 1..{MAX_OPTIONS} options")
+        if not 1 <= len(self.criteria) <= MAX_OPTIONS:
+            raise ValueError(f"criteria must have 1..{MAX_OPTIONS} options")
         return self
 
 
@@ -45,10 +47,18 @@ class SystemOneRequest(BaseModel):
 def render(v: JSONContent, indent: int = 0) -> str:
     """Flatten str | object | array into text the model sees. Field names are kept as labels."""
     pad = "  " * indent
-    if v is None: return ""
-    if isinstance(v, (str, int, float, bool)): return str(v)
-    if isinstance(v, list): return "\n".join(f"{pad}- {render(x, indent + 1).lstrip()}" for x in v)
-    return "\n".join(f"{pad}{k}:\n{render(x, indent + 1)}" if isinstance(x, (dict, list)) else f"{pad}{k}: {render(x)}" for k, x in v.items())
+    if v is None:
+        return ""
+    if isinstance(v, (str, int, float, bool)):
+        return str(v)
+    if isinstance(v, list):
+        return "\n".join(f"{pad}- {render(x, indent + 1).lstrip()}" for x in v)
+    return "\n".join(
+        f"{pad}{k}:\n{render(x, indent + 1)}"
+        if isinstance(x, (dict, list))
+        else f"{pad}{k}: {render(x)}"
+        for k, x in v.items()
+    )
 
 
 def option_text(name: str, desc: JSONContent) -> str:
@@ -69,7 +79,13 @@ def to_record(req: SystemOneRequest):
             meta.append({"id": qid, "type": "choice", "keys": list(q.criteria.keys())})
         else:
             opts = [render(x) for x in q.criteria]
-            meta.append({"id": qid, "type": "score", "legend": {str(i): render(x) for i, x in enumerate(q.criteria)}})
+            meta.append(
+                {
+                    "id": qid,
+                    "type": "score",
+                    "legend": {str(i): render(x) for i, x in enumerate(q.criteria)},
+                }
+            )
         qs.append({"instr": instr, "options": opts, "label": 0})
     return {"state": render(req.state), "questions": qs}, meta
 
@@ -107,8 +123,19 @@ def to_answers(probs: list[list[float]], meta: list[dict]) -> dict[str, Any]:
             out[m["id"]] = {"type": "noul", "noul": round_prob(p[1])}
         elif m["type"] == "choice":
             dist = {k: round_prob(v) for k, v in zip(m["keys"], p)}
-            out[m["id"]] = {"type": "choice", "choice": m["keys"][max(range(len(p)), key=lambda i: p[i])], "confidence": round_prob(choice_confidence(p)), "probabilities": dist}
+            out[m["id"]] = {
+                "type": "choice",
+                "choice": m["keys"][max(range(len(p)), key=lambda i: p[i])],
+                "confidence": round_prob(choice_confidence(p)),
+                "probabilities": dist,
+            }
         else:
             score = sum(i * pi for i, pi in enumerate(p))
-            out[m["id"]] = {"type": "score", "score": round_prob(score), "legend": m["legend"], "probabilities": {str(i): round_prob(v) for i, v in enumerate(p)}, "confidence": round_prob(score_confidence(p))}
+            out[m["id"]] = {
+                "type": "score",
+                "score": round_prob(score),
+                "legend": m["legend"],
+                "probabilities": {str(i): round_prob(v) for i, v in enumerate(p)},
+                "confidence": round_prob(score_confidence(p)),
+            }
     return out
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/84b3ac0ce858d907d8d59ffdc9c9096ab8cb2ac4).

This part ends at the code at `tut-07`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-07)

<a id="tut-08.1-to-tut-08.3"></a>

## 8.1 to 8.3 `just lint`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-07`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-07)

```bash
just setup
```

A formatter changes how the code looks, and leaves a wrong line wrong. The rules of the linter go in
`pyproject.toml`, and `just lint` runs the linter.

<a id="tut-08.1"></a>

### 8.1 The rules of the linter

ruff has more than 900 rules. The table `[tool.ruff.lint]` chooses which to check, with `select`. Each family of
rules has a prefix, such as `E` or `B`. The list has one family on each line, with a comment that says what it
finds.

Set the values that this change sets in [`pyproject.toml`](#tut-08.1-pyproject.toml-5d07e7). Run this command from the top of the project. It reads your file with tomlkit, a library for TOML files. It copies each of these tables and values from the project's file after this change, with their comments, and keeps the rest of your file:

```bash
uv run --quiet --no-config --no-project --with tomlkit python - <<'PY'
import copy, pathlib, subprocess, tomlkit
from tomlkit.items import Comment, Table, Whitespace
path = pathlib.Path('pyproject.toml')
doc = tomlkit.parse(path.read_text(encoding='utf-8')) if path.exists() else tomlkit.document()
# The project's file after this change, from your clone
project = tomlkit.parse(subprocess.run(['git', 'show', '1a067ec6d902:pyproject.toml'], capture_output=True, text=True,
                                        check=True).stdout)
# Each table and value that the change sets, by its keys: each comes from the project's file with its comments
COPY = [
    ('tool', 'ruff', 'lint'),
]

def body(table):   # the items of a table in their order, with its comment lines
    inner = table if isinstance(table, tomlkit.TOMLDocument) else getattr(table, 'value', None)
    return getattr(inner, 'body', [])

def above(table, key):   # the comment lines just above a key
    found = []
    for name, item in body(table):
        if name is not None and name.key == key:
            return found
        found = found + [item] if isinstance(item, Comment) else found if isinstance(item, Whitespace) else []
    return []

for keys in COPY:
    source, target = project, doc
    for key in keys[:-1]:   # make each table on the way
        source = source[key]
        if key not in target:
            target[key] = tomlkit.table(True)
        target = target[key]
    item = copy.deepcopy(source[keys[-1]])
    if isinstance(item, Table) and not item.as_string().endswith('\n\n'):
        item.add(tomlkit.nl())   # a blank line before the table after it
    if keys[-1] not in target:
        for comment in above(source, keys[-1]):
            target.add(copy.deepcopy(comment))
    target[keys[-1]] = item
path.write_text(tomlkit.dumps(doc), encoding='utf-8')
PY
```

The patch adds the table `[tool.ruff.lint]` to `pyproject.toml`. Read the comment beside each family.

```bash
uv run ruff check --statistics
```

`ruff check` is the linter. `--statistics` prints one line for each code, with the number of problems. ruff finds 52
problems, and ends with exit code 1. 44 of them are `S101`, an `assert`. Python skips every `assert` when it runs with
`python -O`, so a check in the package must not rely on one. Each of the 44 is in the tests, where pytest checks
with `assert`. The other 8 are in `api.py`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 1a067ec6d902
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-07 --staged -- :/ && git restore --source 1a067ec6d902 --staged --worktree -- :/
```

#### What changed

- <a id="tut-08.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: a family of rules on each line. 14 lines added. [The file](https://github.com/rahuldave/babykev/blob/1a067ec6d90256e2f0142390db307c537909c047/pyproject.toml).
  - look at `    "B",   # bugbear: code that is likely a bug, such as a zip that drops items silently`

<details open><summary>The patch to <code>pyproject.toml</code></summary>

```diff
@@ -47,3 +47,17 @@ indent-style = "space"            # four spaces, never tabs
 skip-magic-trailing-comma = false # a trailing comma keeps one item on each line
 line-ending = "auto"              # the line endings that the file already has
 docstring-code-format = false     # code in a docstring stays as it was written
+
+[tool.ruff.lint]
+# What the linter checks: a family of rules on each line, and why it is on
+select = [
+    "E",   # pycodestyle errors: the basics, from indentation to the length of a line
+    "W",   # pycodestyle warnings: stray whitespace and the like
+    "F",   # pyflakes: names that are unused, undefined or defined twice
+    "I",   # isort: imports in one order, the standard library first
+    "B",   # bugbear: code that is likely a bug, such as a zip that drops items silently
+    "UP",  # pyupgrade: older syntax that this Python has a newer form for
+    "SIM", # simplify: code that can be said in fewer words
+    "S",   # bandit: security, from `assert` in the package to `eval`
+    "N",   # pep8-naming: classes in CamelCase, functions and variables in lower_case
+]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1a067ec6d90256e2f0142390db307c537909c047). [The code after it](https://github.com/rahuldave/babykev/tree/1a067ec6d90256e2f0142390db307c537909c047).

<a id="tut-08.2"></a>

### 8.2 The tests may use assert

The 44 `S101` hide the 8 problems of `api.py`. A test is written with `assert`, and the tests never run with
`python -O`. The table `[tool.ruff.lint.per-file-ignores]` lets the files under `tests/` break `S101`. The package
still may not use `assert`.

Set the values that this change sets in [`pyproject.toml`](#tut-08.2-pyproject.toml-5d07e7). Run this command from the top of the project. It reads your file with tomlkit, a library for TOML files. It copies each of these tables and values from the project's file after this change, with their comments, and keeps the rest of your file:

```bash
uv run --quiet --no-config --no-project --with tomlkit python - <<'PY'
import copy, pathlib, subprocess, tomlkit
from tomlkit.items import Comment, Table, Whitespace
path = pathlib.Path('pyproject.toml')
doc = tomlkit.parse(path.read_text(encoding='utf-8')) if path.exists() else tomlkit.document()
# The project's file after this change, from your clone
project = tomlkit.parse(subprocess.run(['git', 'show', 'a6325da466f1:pyproject.toml'], capture_output=True, text=True,
                                        check=True).stdout)
# Each table and value that the change sets, by its keys: each comes from the project's file with its comments
COPY = [
    ('tool', 'ruff', 'lint', 'per-file-ignores'),
]

def body(table):   # the items of a table in their order, with its comment lines
    inner = table if isinstance(table, tomlkit.TOMLDocument) else getattr(table, 'value', None)
    return getattr(inner, 'body', [])

def above(table, key):   # the comment lines just above a key
    found = []
    for name, item in body(table):
        if name is not None and name.key == key:
            return found
        found = found + [item] if isinstance(item, Comment) else found if isinstance(item, Whitespace) else []
    return []

for keys in COPY:
    source, target = project, doc
    for key in keys[:-1]:   # make each table on the way
        source = source[key]
        if key not in target:
            target[key] = tomlkit.table(True)
        target = target[key]
    item = copy.deepcopy(source[keys[-1]])
    if isinstance(item, Table) and not item.as_string().endswith('\n\n'):
        item.add(tomlkit.nl())   # a blank line before the table after it
    if keys[-1] not in target:
        for comment in above(source, keys[-1]):
            target.add(copy.deepcopy(comment))
    target[keys[-1]] = item
path.write_text(tomlkit.dumps(doc), encoding='utf-8')
PY
```

The patch adds the table `[tool.ruff.lint.per-file-ignores]` to `pyproject.toml`.

```bash
uv run ruff check --statistics
```

ruff finds 8 problems, and ends with exit code 1. `N806`, `UP007` and `B905` come twice each, and `E501` and `I001`
once each. The last line says that `--fix` can fix one, and that 2 unsafe fixes are available.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check a6325da466f1
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 1a067ec6d902 --staged -- :/ && git restore --source a6325da466f1 --staged --worktree -- :/
```

#### What changed

- <a id="tut-08.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: the tests may use `assert`. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/a6325da466f16c6379613b62554e1e4cf2144e7e/pyproject.toml).
  - look at `"tests/**" = ["S101"]`

<details open><summary>The patch to <code>pyproject.toml</code></summary>

```diff
@@ -61,3 +61,7 @@ select = [
     "S",   # bandit: security, from `assert` in the package to `eval`
     "N",   # pep8-naming: classes in CamelCase, functions and variables in lower_case
 ]
+
+[tool.ruff.lint.per-file-ignores]
+# A test is written with assert
+"tests/**" = ["S101"]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a6325da466f16c6379613b62554e1e4cf2144e7e). [The code after it](https://github.com/rahuldave/babykev/tree/a6325da466f16c6379613b62554e1e4cf2144e7e).

<a id="tut-08.3"></a>

### 8.3 The recipe lint

The command that runs the linter is `uv run ruff check`. The recipe `lint` runs it, and gives it every word after
`lint`, as `fmt` does.

Apply the patch to [`justfile`](#tut-08.3-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/58d6ece95cf464e01996ad8dbed1d98e92bcc502.diff | git apply --include=justfile
```

The patch adds the recipe `lint` under the recipe `fmt`, above `test`.

```bash
just --show lint
just lint
just help lint
```

`just --show lint` prints the recipe. `just lint`, with no words, prints each problem with the lines around it, and
ends with `Found 8 errors.` and exit code 1. All 8 are in `src/babykev/api.py`. Each one starts with its code. Under
I001, UP007 and B905, a `help:` line says what would fix it.

- `E501` is line 5, of 103 characters, in the docstring. The formatter does not split the text of a docstring.
- `I001` is on line 8. The imports need a blank line between the standard library and pydantic. Its `[*]` says
  that ruff can fix it.
- `UP007` is on lines 11 and 39, `Union[...]`, where Python 3.10 and later write `X | Y`.
- `N806` is on lines 94 and 104, `K` and `L`, variables in capitals.
- `B905` is on lines 121 and 125, a `zip` with no `strict=`. ruff shows a fix, `strict=False`, with the note
  `This is an unsafe fix and may change runtime behavior`.

`uv run ruff rule CODE` explains any code, for example `uv run ruff rule B905`. `just help lint` prints the line of
the recipe. The next parts fix the problems one code at a time, by hand. ruff fixes the last two.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 58d6ece95cf4
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source a6325da466f1 --staged -- :/ && git restore --source 58d6ece95cf4 --staged --worktree -- :/
```

#### What changed

- <a id="tut-08.3-justfile-424f0b"></a>`justfile`: the recipe `lint`. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/58d6ece95cf464e01996ad8dbed1d98e92bcc502/justfile).
  - look at `lint *args:`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -31,6 +31,12 @@ setup *args:
 fmt *args:
     @{{ if args == "help" { "just help fmt" } else { 'uv run ruff format "$@"' } }}
 
+# Check the code against the rules in pyproject.toml. Extra words go to ruff: just lint --statistics
+[group('quality')]
+[no-exit-message]
+lint *args:
+    @{{ if args == "help" { "just help lint" } else { 'uv run ruff check "$@"' } }}
+
 # Run the tests. Extra words go to pytest: just test -k render
 [group('quality')]
 [no-exit-message]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/58d6ece95cf464e01996ad8dbed1d98e92bcc502).

This part ends at the code at `58d6ece95cf4`, partway through `tut-08`. [The code after this part](https://github.com/rahuldave/babykev/tree/58d6ece95cf464e01996ad8dbed1d98e92bcc502)

<a id="tut-08.8"></a>

## 8.8 The words after `just lint`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `ca9cfc3b70b7`, partway through `tut-08`. [The code before this part](https://github.com/rahuldave/babykev/tree/ca9cfc3b70b7a0c926c9407336c217e3f04c73aa)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git restore --source 58d6ece95cf4 --staged -- :/ && git restore --source ca9cfc3b70b7 --staged --worktree -- :/
```

```bash
just setup
```

The code now has the fixes of four of the problems, made by hand. The docstring of `api.py` fits in 100 characters,
and `X | Y` takes the place of `Union`. `k` and `n` are in lower case, and each `zip` has `strict=True`.

Every word after `lint` goes to ruff, so `just lint --fix` runs `uv run ruff check --fix`.

### 8.8 Just lint --fix sorts the imports

The last two problems are on lines 8 and 9 of `api.py`, in the imports, and ruff can fix both safely. `--fix` makes
only the fixes that ruff counts as safe.

```bash
just lint --fix
```

`just lint --fix` prints `Found 2 errors (2 fixed, 0 remaining).`, and ends with exit code 0. It removed `Union`
from the import of `typing` (`F401`). It put a blank line between the standard library and pydantic, which is
installed (`I001`).

```bash
just lint
just fmt --check
just test
```

`just lint` prints `All checks passed!`. `just fmt --check` prints `6 files already formatted`, and `just test`
prints `53 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 7cdb1ba696a3
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source ca9cfc3b70b7 --staged -- :/ && git restore --source tut-08 --staged --worktree -- :/
```

#### What changed

- <a id="tut-08.8-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the imports, sorted. 2 lines added, 1 removed. It comes from `just lint --fix`. [The file](https://github.com/rahuldave/babykev/blob/7cdb1ba696a32050cba1c335892fccb68bb4fd24/src/babykev/api.py).
  - look at `from typing import Any, Literal`

<details><summary>The diff that <code>just lint --fix</code> makes in <code>src/babykev/api.py</code></summary>

```diff
@@ -5,7 +5,8 @@ Choice -> options 'name' or 'name: desc'; answer = argmax, probabilities by name
 Score  -> options = the levels, in order; answer = expected level, legend, probabilities by index
 """
 
-from typing import Any, Literal, Union
+from typing import Any, Literal
+
 from pydantic import BaseModel, Field, model_validator
 
 JSONContent = str | dict | list | int | float | bool | None
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7cdb1ba696a32050cba1c335892fccb68bb4fd24).

This part ends at the code at `tut-08`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-08)

<a id="tut-11"></a>

## 11 `just check` and `just hook`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-10`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-10)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-08 --staged -- :/ && git restore --source tut-10 --staged --worktree -- :/
```

The whole tutorial then turns on the rules `ANN` of ruff, which ask for a type on every parameter and return. A
person wrote the types that ruff cannot guess, and `just lint --fix --unsafe-fixes` wrote `-> None` on the other 31
functions. Then the rules `D1` asked for a docstring on every public name, and each came by hand.

A person must now remember three verbs before each `git commit`. One recipe runs them all, and a git hook runs that
recipe.

```bash
just setup
```

`just setup` prints `Resolved 15 packages`.

The project has three checks, `just fmt --check`, `just lint` and `just test`. A person must remember to run each
of them before each `git commit`. One recipe, `check`, runs them all, in order. git then runs that recipe itself
before each `git commit`, through a hook that pre-commit installs. A check that git runs before it records a change
is a gate, and a change that fails it does not go in.

Three more hooks keep out a large file, the markers of a merge conflict and a `.env` file. Last, a mistake on purpose
shows the gate at work.

<a id="tut-11.1"></a>

### 11.1 The recipe check

The three checks are three commands, and a person can forget one. The recipe `check` runs them one after another.
`set -e` stops it at the first that fails, so the last line that it prints names the check that failed.

Apply the patch to [`justfile`](#tut-11.1-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/dbfc285a2adeb4900fc68c863c4850b84004a04e.diff | git apply --include=justfile
```

The patch adds the recipe `check` at the end of the `justfile`, under the recipe `test`.

`just check` has no floor on the coverage yet, such as `--cov-fail-under=90`. Later, the model comes in with no tests
of its own, and the coverage then falls under 90%. The floor joins the gate after the tests of the model.

The commands behind the recipe come first.

```bash
just fmt --check
just lint
just test -q
```

`just fmt --check` prints `6 files already formatted`, and `just lint` prints `All checks passed!`. `just test -q`
prints a dot for each test, the table of coverage, and `53 passed`. The total is 100%, 83 of 83 statements.

```bash
just --show check
just check
just help check
```

`just --show check` prints the recipe. `just check` prints the same lines as the three commands, one after another,
and ends with exit code 0. `just help check` prints the line of the recipe.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check dbfc285a2ade
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-10 --staged -- :/ && git restore --source dbfc285a2ade --staged --worktree -- :/
```

#### What changed

- <a id="tut-11.1-justfile-424f0b"></a>`justfile`: the recipe `check`, with three checks. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/dbfc285a2adeb4900fc68c863c4850b84004a04e/justfile).
  - look at `    just test -q`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -42,3 +42,14 @@ lint *args:
 [no-exit-message]
 test *args:
     @{{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
+
+# Run the checks one after another, and stop at the first that fails: the format, the linter, the tests
+[group('quality')]
+[no-exit-message]
+check *args:
+    #!/usr/bin/env sh
+    set -e
+    if [ "$*" = help ]; then just help check; exit 0; fi
+    just fmt --check
+    just lint
+    just test -q
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/dbfc285a2adeb4900fc68c863c4850b84004a04e). [The code after it](https://github.com/rahuldave/babykev/tree/dbfc285a2adeb4900fc68c863c4850b84004a04e).

<a id="tut-11.2"></a>

### 11.2 Pre-commit, in the group lint

`just check` still waits for a person to run it. git can run a program of its own before it records a change, a
hook. If the program fails, `git commit` records nothing. pre-commit installs such a hook, and runs the checks that a
file of settings names. It is for working on babykev, so it goes in the group `lint`.

[pre-commit](https://pre-commit.com/) runs checks each time you run `git commit`, before git records the change. The file `.pre-commit-config.yaml` lists hooks. `pre-commit install` puts a script into `.git/hooks`, so `git commit` runs them first, and stops when one fails.

```bash
uv add --group lint pre-commit
```

`uv add` prints `Resolved 25 packages`, and installs pre-commit and the 9 packages that it needs, such as
`pyyaml` and `virtualenv`.

```bash
uv run pre-commit --version
```

It prints the version of pre-commit that uv installed. No hook is installed yet.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 56dee300cda2
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source dbfc285a2ade --staged -- :/ && git restore --source 56dee300cda2 --staged --worktree -- :/
```

#### What changed

- <a id="tut-11.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: pre-commit, in the group `lint`. 1 line added. It comes from `uv add --group lint pre-commit`. [The file](https://github.com/rahuldave/babykev/blob/56dee300cda2e0f34bfb18be026897e83bf6981a/pyproject.toml).
  - look at `"pre-commit>=4.7.0",`
- <a id="tut-11.2-uv.lock-8356d8"></a>`uv.lock`: the exact version of pre-commit, and of the packages that it needs. 139 lines added, 1 removed. It comes from `uv add --group lint pre-commit`. [The file](https://github.com/rahuldave/babykev/blob/56dee300cda2e0f34bfb18be026897e83bf6981a/uv.lock).

<details><summary>The diff that <code>uv add --group lint pre-commit</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -24,6 +24,7 @@ default-groups = "all"
 
 [dependency-groups]
 lint = [
+    "pre-commit>=4.7.0",
     "ruff>=0.17.1",
 ]
 test = [
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/56dee300cda2e0f34bfb18be026897e83bf6981a). [The code after it](https://github.com/rahuldave/babykev/tree/56dee300cda2e0f34bfb18be026897e83bf6981a).

<a id="tut-11.3"></a>

### 11.3 A hook that runs just check

pre-commit reads its hooks from a file, `.pre-commit-config.yaml`. The first hook is local, which means that it is
a command of the project itself, `just check`. So the hook and the terminal run the same checks. The file is new,
and comes whole, as a patch.

Apply the patch to [`.pre-commit-config.yaml`](#tut-11.3-.pre-commit-config.yaml-e7d14d), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/0c645eb0a770a34bf7fe3f055dfc9ab4c19aa6fe.diff | git apply --include=.pre-commit-config.yaml
```

Read the hook under `repo: local`, and the comment at the top of the file.

With this hook, `just check` is the gate. The hook is not installed yet, and pre-commit can still run every hook
by hand.

```bash
uv run pre-commit run --all-files
```

`pre-commit run --all-files` runs every hook on every file that git tracks, as `git commit` would. It prints one
line for the hook, `just check....Passed`. A hook that passes prints nothing more.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 0c645eb0a770
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 56dee300cda2 --staged -- :/ && git restore --source 0c645eb0a770 --staged --worktree -- :/
```

#### What changed

- <a id="tut-11.3-.pre-commit-config.yaml-e7d14d"></a>`.pre-commit-config.yaml`: one hook, which runs `just check`. New, 14 lines. [The file](https://github.com/rahuldave/babykev/blob/0c645eb0a770a34bf7fe3f055dfc9ab4c19aa6fe/.pre-commit-config.yaml).
  - look at `        entry: just check`

<details open><summary>The patch to <code>.pre-commit-config.yaml</code></summary>

```diff
@@ -0,0 +1,14 @@
+# The hooks that git runs before each commit, once pre-commit is installed in the clone. If a hook
+# fails, git makes no commit.
+#
+# The project's own checks are one hook that runs `just check`, so the hook and the terminal run the
+# same thing.
+repos:
+  - repo: local
+    hooks:
+      - id: check
+        name: just check
+        entry: just check
+        language: system
+        pass_filenames: false
+        always_run: true
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0c645eb0a770a34bf7fe3f055dfc9ab4c19aa6fe). [The code after it](https://github.com/rahuldave/babykev/tree/0c645eb0a770a34bf7fe3f055dfc9ab4c19aa6fe).

<a id="tut-11.4"></a>

### 11.4 The recipe hook

`pre-commit install` writes the hook into the folder of the hooks of the clone, `.git/hooks`. git does not track
that folder, so each clone installs its own hook, once. The recipe `hook` runs the command. It is a recipe of its own,
because `just setup` runs often, and never touches git.

Apply the patch to [`justfile`](#tut-11.4-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/fbe4cca80366ec49c7fa9c23a11af8b4e1a2bde3.diff | git apply --include=justfile
```

The patch adds the recipe `hook` under the recipe `setup`, in the group `setup`.

```bash
uv run pre-commit install
just --show hook
just hook
ls "$(git rev-parse --git-path hooks)"
```

`uv run pre-commit install` prints `pre-commit installed at .git/hooks/pre-commit`. `just --show hook` prints the
recipe, and `just hook` prints the same line as the command. A second install writes the same file again.

`git rev-parse --git-path hooks` names the folder of the hooks of this clone, and `ls` lists it. git puts a file
`NAME.sample` there for each hook, and runs none of them. The new file `pre-commit`, with no `.sample`, is the one
that `git commit` runs first.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check fbe4cca80366
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 0c645eb0a770 --staged -- :/ && git restore --source fbe4cca80366 --staged --worktree -- :/
```

#### What changed

- <a id="tut-11.4-justfile-424f0b"></a>`justfile`: the recipe `hook`. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/fbe4cca80366ec49c7fa9c23a11af8b4e1a2bde3/justfile).
  - look at `hook *args:`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -25,6 +25,11 @@ help *verb:
 setup *args:
     @{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
 
+# Install the git hook, which runs just check before each commit. Once in each clone: just setup never touches git
+[group('setup')]
+hook *args:
+    @{{ if args == "help" { "just help hook" } else { "uv run pre-commit install" } }}
+
 # Write the Python of the project in one style. Extra words go to ruff: just fmt --check
 [group('quality')]
 [no-exit-message]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/fbe4cca80366ec49c7fa9c23a11af8b4e1a2bde3). [The code after it](https://github.com/rahuldave/babykev/tree/fbe4cca80366ec49c7fa9c23a11af8b4e1a2bde3).

<a id="tut-11.5"></a>

### 11.5 No file over 1 MB

A model's weights or a large file of data does not belong in git. Once git records it, it stays in the history,
and every clone downloads it. pre-commit-hooks is pre-commit's own collection of hooks, and its hook
`check-added-large-files` refuses a file over a size. `--maxkb=1000` sets the size, 1000 KB.

Apply the patch to [`.pre-commit-config.yaml`](#tut-11.5-.pre-commit-config.yaml-e7d14d), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/352e33d87006028ec33ed46ba0e53d48255b3d66.diff | git apply --include=.pre-commit-config.yaml
```

The patch adds the repository `https://github.com/pre-commit/pre-commit-hooks` above `repo: local`, with its version
and the hook `check-added-large-files`.

```bash
uv run pre-commit run --all-files
```

The first time on a machine, pre-commit prints lines that start with `[INFO]` while it downloads the collection, into a
folder of its own. Then it prints two lines, `check for added large files....Passed` and `just check....Passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 352e33d87006
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source fbe4cca80366 --staged -- :/ && git restore --source 352e33d87006 --staged --worktree -- :/
```

#### What changed

- <a id="tut-11.5-.pre-commit-config.yaml-e7d14d"></a>`.pre-commit-config.yaml`: the hook of large files. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/352e33d87006028ec33ed46ba0e53d48255b3d66/.pre-commit-config.yaml).
  - look at `        args: [--maxkb=1000]`

<details open><summary>The patch to <code>.pre-commit-config.yaml</code></summary>

```diff
@@ -4,6 +4,11 @@
 # The project's own checks are one hook that runs `just check`, so the hook and the terminal run the
 # same thing.
 repos:
+  - repo: https://github.com/pre-commit/pre-commit-hooks
+    rev: v6.0.0
+    hooks:
+      - id: check-added-large-files
+        args: [--maxkb=1000]
   - repo: local
     hooks:
       - id: check
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/352e33d87006028ec33ed46ba0e53d48255b3d66). [The code after it](https://github.com/rahuldave/babykev/tree/352e33d87006028ec33ed46ba0e53d48255b3d66).

<a id="tut-11.6"></a>

### 11.6 No merge-conflict markers

When git cannot merge two changes to the same lines, it writes both into the file, between the markers `<<<<<<<`,
`=======` and `>>>>>>>`. A person must choose, and remove the markers. The hook `check-merge-conflict` refuses a file
that still has them.

Apply the patch to [`.pre-commit-config.yaml`](#tut-11.6-.pre-commit-config.yaml-e7d14d), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/64d0f4f781da1a8520315f899c4231645623280c.diff | git apply --include=.pre-commit-config.yaml
```

The patch adds the line of `check-merge-conflict` under the hook of large files.

```bash
uv run pre-commit run --all-files
```

pre-commit prints three lines, each `Passed`. The new one is `check for merge conflicts`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 64d0f4f781da
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 352e33d87006 --staged -- :/ && git restore --source 64d0f4f781da --staged --worktree -- :/
```

#### What changed

- <a id="tut-11.6-.pre-commit-config.yaml-e7d14d"></a>`.pre-commit-config.yaml`: the hook of merge conflicts. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/64d0f4f781da1a8520315f899c4231645623280c/.pre-commit-config.yaml).
  - look at `      - id: check-merge-conflict`

<details open><summary>The patch to <code>.pre-commit-config.yaml</code></summary>

```diff
@@ -9,6 +9,7 @@ repos:
     hooks:
       - id: check-added-large-files
         args: [--maxkb=1000]
+      - id: check-merge-conflict
   - repo: local
     hooks:
       - id: check
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/64d0f4f781da1a8520315f899c4231645623280c). [The code after it](https://github.com/rahuldave/babykev/tree/64d0f4f781da1a8520315f899c4231645623280c).

<a id="tut-11.7"></a>

### 11.7 No .env file

A `.env` file holds the settings and secrets of one machine, such as a token. `.gitignore` ignores it already, but
`git add -f .env` would still add it. A local hook with `language: fail` fails for every file that it is given, and
prints its `entry` as the reason. `files:` gives it only the files named `.env`.

Apply the patch to [`.pre-commit-config.yaml`](#tut-11.7-.pre-commit-config.yaml-e7d14d), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/2d080c9e228f2f9959f4eeed801726ea402e66a3.diff | git apply --include=.pre-commit-config.yaml
```

The patch adds the hook `no-env-file` under `repo: local`, above the hook of `just check`.

```bash
uv run pre-commit run --all-files
```

pre-commit prints four lines. The new one ends `(no files to check)Skipped`, because git tracks no `.env` file. The
other three pass.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 2d080c9e228f
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 64d0f4f781da --staged -- :/ && git restore --source 2d080c9e228f --staged --worktree -- :/
```

#### What changed

- <a id="tut-11.7-.pre-commit-config.yaml-e7d14d"></a>`.pre-commit-config.yaml`: the hook that refuses a `.env` file. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/2d080c9e228f2f9959f4eeed801726ea402e66a3/.pre-commit-config.yaml).
  - look at `        language: fail`

<details open><summary>The patch to <code>.pre-commit-config.yaml</code></summary>

```diff
@@ -12,6 +12,11 @@ repos:
       - id: check-merge-conflict
   - repo: local
     hooks:
+      - id: no-env-file
+        name: no .env file
+        entry: A .env file holds the settings and secrets of one machine. It is never committed
+        language: fail
+        files: (^|/)\.env$
       - id: check
         name: just check
         entry: just check
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/2d080c9e228f2f9959f4eeed801726ea402e66a3). [The code after it](https://github.com/rahuldave/babykev/tree/2d080c9e228f2f9959f4eeed801726ea402e66a3).

<a id="tut-11.8"></a>

### 11.8 An unused import, on purpose

The hook works only if it fails on a mistake. This move makes one on purpose. `cli.py` imports `os`, and never uses
it. The next move removes it.

Apply the patch to [`src/babykev/cli.py`](#tut-11.8-src-babykev-cli.py-a9e184), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/f4fabd3272713cb5ac1c26021e4c23fa33ab15e6.diff | git apply --include=src/babykev/cli.py
```

The patch adds the line `import os` above `import sys`.

```bash
uv run pre-commit run --all-files
```

The first three hooks pass or skip, as before. `just check....Failed` follows, with `- exit code: 1` and the output of
`just check`. `just fmt --check` prints `6 files already formatted`, because the import is in its place. Then
`just lint` finds `F401`, `` `os` imported but unused ``, at line 3, column 8 of `src/babykev/cli.py`.

`set -e` stops `just check` there, so the tests do not run. pre-commit ends with exit code 1. A `git commit` would
stop here, and record nothing.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check f4fabd327271
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 2d080c9e228f --staged -- :/ && git restore --source f4fabd327271 --staged --worktree -- :/
```

#### What changed

- <a id="tut-11.8-src-babykev-cli.py-a9e184"></a>`src/babykev/cli.py`: an import that nothing uses, on purpose. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/f4fabd3272713cb5ac1c26021e4c23fa33ab15e6/src/babykev/cli.py).
  - look at `import os`

<details open><summary>The patch to <code>src/babykev/cli.py</code></summary>

```diff
@@ -1,5 +1,6 @@
 """The babykev command. `babykev help` says what it can do; every command arrives here."""
 
+import os
 import sys
 
 HELP = """\
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f4fabd3272713cb5ac1c26021e4c23fa33ab15e6). [The code after it](https://github.com/rahuldave/babykev/tree/f4fabd3272713cb5ac1c26021e4c23fa33ab15e6).

<a id="tut-11.9"></a>

### 11.9 The import goes

The linter said what is wrong, and that `--fix` can remove the line. The move removes it by hand.

Apply the patch to [`src/babykev/cli.py`](#tut-11.9-src-babykev-cli.py-a9e184), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/054c40b6cc1839f8b35dfab81f9f2ae7c9f1aaf0.diff | git apply --include=src/babykev/cli.py
```

The patch removes the line `import os`.

```bash
uv run pre-commit run --all-files
```

The four hooks pass or skip, and pre-commit ends with exit code 0. A `git commit` would now record the change.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 054c40b6cc18
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source f4fabd327271 --staged -- :/ && git restore --source 054c40b6cc18 --staged --worktree -- :/
```

#### What changed

- <a id="tut-11.9-src-babykev-cli.py-a9e184"></a>`src/babykev/cli.py`: the import of `os` goes. 0 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/054c40b6cc1839f8b35dfab81f9f2ae7c9f1aaf0/src/babykev/cli.py).
  - look at `import os`

<details open><summary>The patch to <code>src/babykev/cli.py</code></summary>

```diff
@@ -1,6 +1,5 @@
 """The babykev command. `babykev help` says what it can do; every command arrives here."""
 
-import os
 import sys
 
 HELP = """\
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/054c40b6cc1839f8b35dfab81f9f2ae7c9f1aaf0). [The code after it](https://github.com/rahuldave/babykev/tree/054c40b6cc1839f8b35dfab81f9f2ae7c9f1aaf0).

<a id="tut-11.10"></a>

### 11.10 The README names the hook

A new clone has no hook until someone runs `just hook`. The README says so, under "Start", and its table names the
file of the hooks.

Apply the patch to [`README.md`](#tut-11.10-README.md-8ec9a0), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/cab87c139ebd3b72771ed6db08b02dd7646c7d02.diff | git apply --include=README.md
```

The patch adds a paragraph at the end of the section "Start", and a row for `.pre-commit-config.yaml` at the end of the
table of files.

```bash
grep -n 'just hook' README.md
```

`grep` prints line 61, the first line of the paragraph, and line 79, the row of the table.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check cab87c139ebd
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source 054c40b6cc18 --staged -- :/ && git restore --source tut-11 --staged --worktree -- :/
```

#### What changed

- <a id="tut-11.10-README.md-8ec9a0"></a>`README.md`: a paragraph on `just hook`, and a row of the table. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/cab87c139ebd3b72771ed6db08b02dd7646c7d02/README.md).
  - look at ``Run `just hook` once in each clone. It installs a git hook, which runs `just check` before each commit.``

<details open><summary>The patch to <code>README.md</code></summary>

```diff
@@ -58,6 +58,10 @@ Then run `just test`. `just` lists the tasks, `just help VERB` explains one, and
 help of the program itself. A recipe gives its extra words to the tool behind it. For example,
 `just test -k help` runs only the tests with `help` in their name.
 
+Run `just hook` once in each clone. It installs a git hook, which runs `just check` before each commit.
+`just check` runs every check of the project, and if one fails, git makes no commit. You can run `just check`
+yourself at any time.
+
 ## What is here
 
 | Path | What it is |
@@ -72,6 +76,7 @@ help of the program itself. A recipe gives its extra words to the tool behind it
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
 | `.python-version` | The version of Python that the project uses |
 | `.gitignore` | The files that git does not track, for example `.venv` |
+| `.pre-commit-config.yaml` | The hooks that git runs before each commit, once `just hook` installs them. The last runs `just check` |
 
 ## How the history is organised
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/cab87c139ebd3b72771ed6db08b02dd7646c7d02).

This part ends at the code at `tut-11`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-11)

<a id="tut-12"></a>

## 12 `just lint-config`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-11`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-11)

The gate checks the Python of the project, and none of its other files. `just lint-config` checks the config files,
one checker at a time, and then joins `just check`.

```bash
just setup
```

`just setup` prints `Resolved 25 packages`.

The gate checks the Python of the project. The files that are not Python, the config files, have no check. A
misspelt key in `pyproject.toml`, a lockfile that no longer matches it, or a YAML file that pre-commit cannot read
passes the gate. A recipe `lint-config` checks each kind of config file, with one checker per move. One checker
fails on its defaults, for real, and its settings fix it. Then the gate runs `lint-config` too.

<a id="tut-12.1"></a>

### 12.1 Validate-pyproject, in the group lint

`pyproject.toml` has a standard, which says which tables it has, which keys each table may hold, and what each value
is. validate-pyproject checks the file against the standard. It goes in the group `lint`.

[validate-pyproject](https://github.com/abravalheri/validate-pyproject) checks `pyproject.toml` against the published schemas of its tables. It finds a misspelt key or a value of the wrong type, which most tools ignore without a word.

```bash
uv add --group lint validate-pyproject
```

`uv add` prints `Resolved 27 packages`, and installs validate-pyproject and `fastjsonschema`, which it needs.

```bash
uv run validate-pyproject --version
```

It prints the version of validate-pyproject that uv installed. Nothing runs it yet.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 7506fb7a39f8
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-11 --staged -- :/ && git restore --source 7506fb7a39f8 --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: validate-pyproject, in the group `lint`. 1 line added. It comes from `uv add --group lint validate-pyproject`. [The file](https://github.com/rahuldave/babykev/blob/7506fb7a39f80397361a8e97ceb816f4b6931cd1/pyproject.toml).
  - look at `"validate-pyproject>=0.26",`
- <a id="tut-12.1-uv.lock-8356d8"></a>`uv.lock`: the exact version of validate-pyproject, and of `fastjsonschema`. 23 lines added. It comes from `uv add --group lint validate-pyproject`. [The file](https://github.com/rahuldave/babykev/blob/7506fb7a39f80397361a8e97ceb816f4b6931cd1/uv.lock).

<details><summary>The diff that <code>uv add --group lint validate-pyproject</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -26,6 +26,7 @@ default-groups = "all"
 lint = [
     "pre-commit>=4.7.0",
     "ruff>=0.17.1",
+    "validate-pyproject>=0.26",
 ]
 test = [
     "pytest>=9.1.1",
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7506fb7a39f80397361a8e97ceb816f4b6931cd1). [The code after it](https://github.com/rahuldave/babykev/tree/7506fb7a39f80397361a8e97ceb816f4b6931cd1).

<a id="tut-12.2"></a>

### 12.2 The recipe lint-config, with validate-pyproject

A recipe `lint-config` will run a check for each kind of config file. Its first check is validate-pyproject on
`pyproject.toml`. Its body is a script, with `set -e`, as in `check`, so that the next checks can come one line at a
time.

Apply the patch to [`justfile`](#tut-12.2-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/64b71c6c0bdb792769aeef413b2ccead2be00ac4.diff | git apply --include=justfile
```

The patch adds the recipe `lint-config` under the recipe `lint`, above `test`.

```bash
uv run validate-pyproject pyproject.toml
just --show lint-config
just lint-config
just help lint-config
```

`validate-pyproject` prints `Valid file: pyproject.toml`, and ends with exit code 0.

`just --show lint-config` prints the recipe, and `just lint-config` prints the same line as the command.
`just help lint-config` prints the line of the recipe.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 64b71c6c0bdb
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 7506fb7a39f8 --staged -- :/ && git restore --source 64b71c6c0bdb --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.2-justfile-424f0b"></a>`justfile`: the recipe `lint-config`, with its first check. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/64b71c6c0bdb792769aeef413b2ccead2be00ac4/justfile).
  - look at `lint-config *args:`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -42,6 +42,15 @@ fmt *args:
 lint *args:
     @{{ if args == "help" { "just help lint" } else { 'uv run ruff check "$@"' } }}
 
+# Check the config files: pyproject.toml against the standard
+[group('quality')]
+[no-exit-message]
+lint-config *args:
+    #!/usr/bin/env sh
+    set -e
+    if [ "$*" = help ]; then just help lint-config; exit 0; fi
+    uv run validate-pyproject pyproject.toml
+
 # Run the tests. Extra words go to pytest: just test -k render
 [group('quality')]
 [no-exit-message]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/64b71c6c0bdb792769aeef413b2ccead2be00ac4). [The code after it](https://github.com/rahuldave/babykev/tree/64b71c6c0bdb792769aeef413b2ccead2be00ac4).

<a id="tut-12.3"></a>

### 12.3 Lint-config checks the lockfile

`uv.lock` must match `pyproject.toml`. When a person changes a dependency in `pyproject.toml` and does not run
`uv lock`, they disagree. `uv lock --check` resolves the dependencies again, compares the result with `uv.lock`, and
fails if they differ. It changes no file.

Apply the patch to [`justfile`](#tut-12.3-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/4308e46ddc44bbe18fb2ec528e4573e956219a16.diff | git apply --include=justfile
```

In the recipe `lint-config`, the patch adds `uv lock --check` under the line of validate-pyproject, and names the
lockfile in the comment above the recipe.

```bash
uv lock --check
just lint-config
```

`uv lock --check` prints `Resolved 27 packages`, and ends with exit code 0. `just lint-config` prints
`Valid file: pyproject.toml`, then the same line.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 4308e46ddc44
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 64b71c6c0bdb --staged -- :/ && git restore --source 4308e46ddc44 --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.3-justfile-424f0b"></a>`justfile`: the check of the lockfile. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/4308e46ddc44bbe18fb2ec528e4573e956219a16/justfile).
  - look at `    uv lock --check`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -42,7 +42,7 @@ fmt *args:
 lint *args:
     @{{ if args == "help" { "just help lint" } else { 'uv run ruff check "$@"' } }}
 
-# Check the config files: pyproject.toml against the standard
+# Check the config files: pyproject.toml against the standard, and the lockfile against it
 [group('quality')]
 [no-exit-message]
 lint-config *args:
@@ -50,6 +50,7 @@ lint-config *args:
     set -e
     if [ "$*" = help ]; then just help lint-config; exit 0; fi
     uv run validate-pyproject pyproject.toml
+    uv lock --check
 
 # Run the tests. Extra words go to pytest: just test -k render
 [group('quality')]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4308e46ddc44bbe18fb2ec528e4573e956219a16). [The code after it](https://github.com/rahuldave/babykev/tree/4308e46ddc44bbe18fb2ec528e4573e956219a16).

<a id="tut-12.4"></a>

### 12.4 Recipes refuse an old lockfile

When `pyproject.toml` changes and `uv.lock` does not, `uv run` writes a new `uv.lock` itself, and says nothing. Any
recipe can then change the lockfile, and the person who ran it does not see the change. The variable `UV_LOCKED` makes
every `uv run` refuse a lockfile that is out of date, in place of writing it. The `justfile` exports it to every
recipe.

Apply the patch to [`justfile`](#tut-12.4-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/9f70971667e9a2fc6cbc1767fe58061ad9f26e22.diff | git apply --include=justfile
```

The patch adds `export UV_LOCKED := "1"` under the line `set positional-arguments`, with a comment above it.

```bash
just --evaluate UV_LOCKED
```

It prints `1`. `just` puts the variable in the environment of each command of each recipe, so every `uv run` of a
recipe sees it.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 9f70971667e9
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 4308e46ddc44 --staged -- :/ && git restore --source 9f70971667e9 --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.4-justfile-424f0b"></a>`justfile`: one line, which exports `UV_LOCKED` to every recipe. 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/9f70971667e9a2fc6cbc1767fe58061ad9f26e22/justfile).
  - look at `export UV_LOCKED := "1"`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -5,6 +5,9 @@ program := "babykev"
 # Each word after a recipe's name reaches its commands whole, as "$1", "$2" and so on; "$@" is all of them
 set positional-arguments
 
+# Every uv run in a recipe refuses a lockfile that is out of date, in place of writing a new one
+export UV_LOCKED := "1"
+
 [private]
 default:
     @just --list --unsorted
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9f70971667e9a2fc6cbc1767fe58061ad9f26e22). [The code after it](https://github.com/rahuldave/babykev/tree/9f70971667e9a2fc6cbc1767fe58061ad9f26e22).

<a id="tut-12.5"></a>

### 12.5 Lint-config checks the justfile

The `justfile` is a config file too. just has a formatter of its own, `just --fmt`. With `--check`, it writes nothing,
and fails if the file is not in its format. just still calls the formatter unstable, so it needs `--unstable`.

Apply the patch to [`justfile`](#tut-12.5-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/284e4b7e241387e68463cb96fde80f81603f99c3.diff | git apply --include=justfile
```

In the recipe `lint-config`, the patch adds `just --fmt --check --unstable` under `uv lock --check`, and names the
`justfile` in the comment above the recipe.

```bash
just --fmt --check --unstable
just lint-config
```

`just --fmt --check --unstable` prints nothing, and ends with exit code 0. We wrote the recipes of this tutorial
in the format of just. `just lint-config` prints the same two lines as before.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 284e4b7e2413
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 9f70971667e9 --staged -- :/ && git restore --source 284e4b7e2413 --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.5-justfile-424f0b"></a>`justfile`: the check of the `justfile`. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/284e4b7e241387e68463cb96fde80f81603f99c3/justfile).
  - look at `    just --fmt --check --unstable`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -45,7 +45,7 @@ fmt *args:
 lint *args:
     @{{ if args == "help" { "just help lint" } else { 'uv run ruff check "$@"' } }}
 
-# Check the config files: pyproject.toml against the standard, and the lockfile against it
+# Check the config files: pyproject.toml against the standard, the lockfile against it, and this justfile
 [group('quality')]
 [no-exit-message]
 lint-config *args:
@@ -54,6 +54,7 @@ lint-config *args:
     if [ "$*" = help ]; then just help lint-config; exit 0; fi
     uv run validate-pyproject pyproject.toml
     uv lock --check
+    just --fmt --check --unstable
 
 # Run the tests. Extra words go to pytest: just test -k render
 [group('quality')]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/284e4b7e241387e68463cb96fde80f81603f99c3). [The code after it](https://github.com/rahuldave/babykev/tree/284e4b7e241387e68463cb96fde80f81603f99c3).

<a id="tut-12.6"></a>

### 12.6 Yamllint, in the group lint

`.pre-commit-config.yaml` is YAML. A mistake of indentation there breaks the hook, and with it every `git commit`. yamllint
checks YAML files, for their syntax and for their style. It goes in the group `lint`.

[yamllint](https://yamllint.readthedocs.io/) checks YAML files, such as the configuration of pre-commit. It finds syntax errors, keys given twice, and a layout that differs from file to file.

```bash
uv add --group lint yamllint
```

`uv add` prints `Resolved 29 packages`, and installs yamllint and `pathspec`, which it needs.

```bash
uv run yamllint --version
```

It prints the version of yamllint that uv installed.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 304e0a2564dd
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 284e4b7e2413 --staged -- :/ && git restore --source 304e0a2564dd --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.6-pyproject.toml-5d07e7"></a>`pyproject.toml`: yamllint, in the group `lint`. 1 line added. It comes from `uv add --group lint yamllint`. [The file](https://github.com/rahuldave/babykev/blob/304e0a2564ddf8d95a9b3964d6b5b8536032d79d/pyproject.toml).
  - look at `"yamllint>=1.38.0",`
- <a id="tut-12.6-uv.lock-8356d8"></a>`uv.lock`: the exact version of yamllint, and of `pathspec`. 24 lines added. It comes from `uv add --group lint yamllint`. [The file](https://github.com/rahuldave/babykev/blob/304e0a2564ddf8d95a9b3964d6b5b8536032d79d/uv.lock).

<details><summary>The diff that <code>uv add --group lint yamllint</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -27,6 +27,7 @@ lint = [
     "pre-commit>=4.7.0",
     "ruff>=0.17.1",
     "validate-pyproject>=0.26",
+    "yamllint>=1.38.0",
 ]
 test = [
     "pytest>=9.1.1",
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/304e0a2564ddf8d95a9b3964d6b5b8536032d79d). [The code after it](https://github.com/rahuldave/babykev/tree/304e0a2564ddf8d95a9b3964d6b5b8536032d79d).

<a id="tut-12.7"></a>

### 12.7 Lint-config runs yamllint, and fails

`yamllint --strict .` checks every YAML file under the folder. `--strict` makes a warning fail, as an error does. It is the fourth check of `lint-config`. yamllint has no settings yet, and it fails on its defaults. The next
moves give it settings.

Apply the patch to [`justfile`](#tut-12.7-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/8786cb9f3dd685412d3c315e4b25d7023dc0ad15.diff | git apply --include=justfile
```

In the recipe `lint-config`, the patch adds `uv run yamllint --strict .` under the line of `just --fmt`, and the
comment above the recipe names every YAML file.

```bash
uv run yamllint --strict .
just lint-config
```

yamllint finds problems in three files, and ends with exit code 1. In `.pre-commit-config.yaml`, lines 1, 4 and 17
are errors, `line too long`, of 98, 100 and 95 characters. By default, a line of YAML has at most 80 characters. Line
6 is a warning, `missing document start "---"`.

The other two files are in `.venv`, inside the package pre-commit, `empty_template_pubspec.yaml` and
`empty_template_environment.yml`. Each has the same warning. yamllint reads every folder, `.venv` too, and those
files are not ours.

`just lint-config` passes its first three checks, and then fails with the same findings. `just check` does not run
`lint-config` yet, so the gate still passes.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 8786cb9f3dd6
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 304e0a2564dd --staged -- :/ && git restore --source 8786cb9f3dd6 --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.7-justfile-424f0b"></a>`justfile`: yamllint, the fourth check. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/8786cb9f3dd685412d3c315e4b25d7023dc0ad15/justfile).
  - look at `    uv run yamllint --strict .`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -45,7 +45,7 @@ fmt *args:
 lint *args:
     @{{ if args == "help" { "just help lint" } else { 'uv run ruff check "$@"' } }}
 
-# Check the config files: pyproject.toml against the standard, the lockfile against it, and this justfile
+# Check the config files: pyproject.toml, the lockfile, this justfile, and every YAML file
 [group('quality')]
 [no-exit-message]
 lint-config *args:
@@ -55,6 +55,7 @@ lint-config *args:
     uv run validate-pyproject pyproject.toml
     uv lock --check
     just --fmt --check --unstable
+    uv run yamllint --strict .
 
 # Run the tests. Extra words go to pytest: just test -k render
 [group('quality')]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/8786cb9f3dd685412d3c315e4b25d7023dc0ad15). [The code after it](https://github.com/rahuldave/babykev/tree/8786cb9f3dd685412d3c315e4b25d7023dc0ad15).

<a id="tut-12.8"></a>

### 12.8 Yamllint skips what git ignores

yamllint reads its settings from a file `.yamllint`. `extends: default` keeps its default rules.
`ignore-from-file: .gitignore` skips each file that git ignores, `.venv` among them. The file is new, and comes
whole, as a patch.

Apply the patch to [`.yamllint`](#tut-12.8-.yamllint-dfe50a), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/aee8ff779a7d2889f24a61ab979558405a9c3007.diff | git apply --include=.yamllint
```

Read the two settings under the comment.

```bash
uv run yamllint --strict .
```

yamllint now finds problems in two files, and ends with exit code 1. The two files in `.venv` are gone. The four
findings of `.pre-commit-config.yaml` stay. `.yamllint` is YAML too, and yamllint checks it. Line 2 has the warning
`missing document start "---"`, and line 3 has 87 characters.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check aee8ff779a7d
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 8786cb9f3dd6 --staged -- :/ && git restore --source aee8ff779a7d --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.8-.yamllint-dfe50a"></a>`.yamllint`: the settings of yamllint. New, 3 lines. [The file](https://github.com/rahuldave/babykev/blob/aee8ff779a7d2889f24a61ab979558405a9c3007/.yamllint).
  - look at `ignore-from-file: .gitignore  # the files that git ignores, such as everything in .venv`

<details open><summary>The patch to <code>.yamllint</code></summary>

```diff
@@ -0,0 +1,3 @@
+# The settings of yamllint, which checks every YAML file of the project
+extends: default
+ignore-from-file: .gitignore  # the files that git ignores, such as everything in .venv
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/aee8ff779a7d2889f24a61ab979558405a9c3007). [The code after it](https://github.com/rahuldave/babykev/tree/aee8ff779a7d2889f24a61ab979558405a9c3007).

<a id="tut-12.9"></a>

### 12.9 A YAML file need not start with three dashes

A line `---` marks the start of a document, in a YAML file that holds several. Our files hold one each, and pre-commit
does not ask for the line. The rule `document-start` goes off.

Apply the patch to [`.yamllint`](#tut-12.9-.yamllint-dfe50a), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/44f6865153ebeff1c321b4da65ace21285161796.diff | git apply --include=.yamllint
```

The patch adds the table `rules:` at the end of `.yamllint`, with the line of `document-start`.

```bash
uv run yamllint --strict .
```

yamllint finds four problems, and ends with exit code 1. The four are the lines too long, lines 1, 4 and 17 of
`.pre-commit-config.yaml`, and line 3 of `.yamllint`. The warnings are gone.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 44f6865153eb
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source aee8ff779a7d --staged -- :/ && git restore --source 44f6865153eb --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.9-.yamllint-dfe50a"></a>`.yamllint`: the rule `document-start`, off. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/44f6865153ebeff1c321b4da65ace21285161796/.yamllint).
  - look at `  document-start: disable  # a file need not start with a line of three dashes`

<details open><summary>The patch to <code>.yamllint</code></summary>

```diff
@@ -1,3 +1,5 @@
 # The settings of yamllint, which checks every YAML file of the project
 extends: default
 ignore-from-file: .gitignore  # the files that git ignores, such as everything in .venv
+rules:
+  document-start: disable  # a file need not start with a line of three dashes
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/44f6865153ebeff1c321b4da65ace21285161796). [The code after it](https://github.com/rahuldave/babykev/tree/44f6865153ebeff1c321b4da65ace21285161796).

<a id="tut-12.10"></a>

### 12.10 Lines of up to 100 characters in YAML

The Python of the project has lines of up to 100 characters, and the comments of the YAML files follow it. The rule
`line-length` lets a line have 100 characters, as `line-length = 100` in `[tool.ruff]` does for ruff.

Apply the patch to [`.yamllint`](#tut-12.10-.yamllint-dfe50a), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/063c1a9ec17bea160da66c14711bb87eb1f54ddb.diff | git apply --include=.yamllint
```

The patch adds the line of `line-length` under the line of `document-start`.

```bash
just lint-config
```

yamllint prints nothing, and `just lint-config` passes. It prints `Valid file: pyproject.toml` and
`Resolved 29 packages`, and ends with exit code 0.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 063c1a9ec17b
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 44f6865153eb --staged -- :/ && git restore --source 063c1a9ec17b --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.10-.yamllint-dfe50a"></a>`.yamllint`: lines of up to 100 characters. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/063c1a9ec17bea160da66c14711bb87eb1f54ddb/.yamllint).
  - look at `  line-length: {max: 100}  # as long as a line of the Python code`

<details open><summary>The patch to <code>.yamllint</code></summary>

```diff
@@ -3,3 +3,4 @@ extends: default
 ignore-from-file: .gitignore  # the files that git ignores, such as everything in .venv
 rules:
   document-start: disable  # a file need not start with a line of three dashes
+  line-length: {max: 100}  # as long as a line of the Python code
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/063c1a9ec17bea160da66c14711bb87eb1f54ddb). [The code after it](https://github.com/rahuldave/babykev/tree/063c1a9ec17bea160da66c14711bb87eb1f54ddb).

<a id="tut-12.11"></a>

### 12.11 The gate checks the config files

`just lint-config` passes, but only when a person runs it. As the last line of `check`, it runs before each
`git commit`, through the hook.

Apply the patch to [`justfile`](#tut-12.11-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/a7699bdb248aa3ff3816137433e5d4482424f3ed.diff | git apply --include=justfile
```

In the recipe `check`, the patch adds `just lint-config` under `just test -q`, and names the config files in the comment
above the recipe.

```bash
just --show check
just check
```

`just --show check` prints the recipe, with four checks. `just check` prints the output of the format, the linter and
the tests, as before, then `Valid file: pyproject.toml` and `Resolved 29 packages`. It ends with exit code 0.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check a7699bdb248a
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 063c1a9ec17b --staged -- :/ && git restore --source a7699bdb248a --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.11-justfile-424f0b"></a>`justfile`: `lint-config`, the last check of the gate. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/a7699bdb248aa3ff3816137433e5d4482424f3ed/justfile).
  - look at `    just lint-config`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -63,7 +63,7 @@ lint-config *args:
 test *args:
     @{{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
 
-# Run the checks one after another, and stop at the first that fails: the format, the linter, the tests
+# Run the checks one after another, and stop at the first that fails: the format, the linter, the tests, the config files
 [group('quality')]
 [no-exit-message]
 check *args:
@@ -73,3 +73,4 @@ check *args:
     just fmt --check
     just lint
     just test -q
+    just lint-config
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a7699bdb248aa3ff3816137433e5d4482424f3ed). [The code after it](https://github.com/rahuldave/babykev/tree/a7699bdb248aa3ff3816137433e5d4482424f3ed).

<a id="tut-12.12"></a>

### 12.12 The README names .yamllint

The table of the README names every config file of the project. `.yamllint` gets a row.

Apply the patch to [`README.md`](#tut-12.12-README.md-8ec9a0), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/cbbf9bedfc2ba814fc979c43fd2770f5464e3aac.diff | git apply --include=README.md
```

The patch adds a row for `.yamllint` at the end of the table of files.

```bash
grep -n yamllint README.md
```

`grep` prints line 80, the new row.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check cbbf9bedfc2b
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source a7699bdb248a --staged -- :/ && git restore --source tut-12 --staged --worktree -- :/
```

#### What changed

- <a id="tut-12.12-README.md-8ec9a0"></a>`README.md`: a row for `.yamllint`. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/cbbf9bedfc2ba814fc979c43fd2770f5464e3aac/README.md).
  - look at ``| `.yamllint` | The settings of yamllint, which `just lint-config` runs on every YAML file |``

<details open><summary>The patch to <code>README.md</code></summary>

```diff
@@ -77,6 +77,7 @@ yourself at any time.
 | `.python-version` | The version of Python that the project uses |
 | `.gitignore` | The files that git does not track, for example `.venv` |
 | `.pre-commit-config.yaml` | The hooks that git runs before each commit, once `just hook` installs them. The last runs `just check` |
+| `.yamllint` | The settings of yamllint, which `just lint-config` runs on every YAML file |
 
 ## How the history is organised
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/cbbf9bedfc2ba814fc979c43fd2770f5464e3aac).

This part ends at the code at `tut-12`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-12)

<a id="tut-13.1-to-tut-13.3"></a>

## 13.1 to 13.3 `just docs`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-12`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-12)

```bash
just setup
```

Nothing says which parts of the code have documentation. smalldocs comes in, and `just docs check` counts what has
documentation. The words after `docs` go to `smalldocs api`.

<a id="tut-13.1"></a>

### 13.1 Smalldocs, in the group docs

Nothing reads the documentation of the code yet. smalldocs is a Python package, so uv installs it like any other. It
is for the documentation, so it goes in a third dependency group, `docs`.

[smalldocs](https://github.com/rahuldave/smalldocs) makes documentation from the code. It reads docstrings and docments, the comments beside each parameter. It prints them in a terminal, checks that every function has them, and builds a website from them. Its own documentation is at [docs.smallish.dev](https://docs.smallish.dev/).

```bash
uv add --group docs smalldocs
```

`uv add` prints `Resolved 34 packages`, and installs smalldocs and four packages that it needs, among them
fastcore and markdown-it-py.

`default-groups = "all"`, on line 23 of `pyproject.toml`, makes uv install every group. So `just setup` installs
smalldocs, with no other change.

```bash
uv run smalldocs --version
uv tree --only-group docs
```

`uv run smalldocs --version` prints the version of smalldocs that uv installed. `uv tree` prints smalldocs `(group: docs)`,
and under it fastcore, markdown-it-py, mdit-py-plugins, pygments and pyyaml. mdurl is under markdown-it-py.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 609d58ce5f8c
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-12 --staged -- :/ && git restore --source 609d58ce5f8c --staged --worktree -- :/
```

#### What changed

- <a id="tut-13.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the group `docs`, with smalldocs. 3 lines added. It comes from `uv add --group docs smalldocs`. [The file](https://github.com/rahuldave/babykev/blob/609d58ce5f8c0fb8e7b60548c8ee097766446ff5/pyproject.toml).
  - look at `"smalldocs>=0.1.5",`
- <a id="tut-13.1-uv.lock-8356d8"></a>`uv.lock`: the exact version of smalldocs, and of the packages that it needs. 62 lines added. It comes from `uv add --group docs smalldocs`. [The file](https://github.com/rahuldave/babykev/blob/609d58ce5f8c0fb8e7b60548c8ee097766446ff5/uv.lock).

<details><summary>The diff that <code>uv add --group docs smalldocs</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -23,6 +23,9 @@ build-backend = "uv_build"
 default-groups = "all"
 
 [dependency-groups]
+docs = [
+    "smalldocs>=0.1.5",
+]
 lint = [
     "pre-commit>=4.7.0",
     "ruff>=0.17.1",
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/609d58ce5f8c0fb8e7b60548c8ee097766446ff5). [The code after it](https://github.com/rahuldave/babykev/tree/609d58ce5f8c0fb8e7b60548c8ee097766446ff5).

<a id="tut-13.2"></a>

### 13.2 The settings of smalldocs

smalldocs needs to know which package to document. It reads its settings from `docs/_smalldocs.yml`. For now the file
has one section, `api`, the reference. It names the package and the address of its source on GitHub. It also names
the files of the tests, which smalldocs holds to the same rule as the package. The file is new, and comes whole, as a
patch.

Apply the patch to [`docs/_smalldocs.yml`](#tut-13.2-docs-_smalldocs.yml-4b0b48), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/4444b1e809427e92a5dc08a9e9fdbbddab7de830.diff | git apply --include=docs/_smalldocs.yml
```

Read the three keys under `api`, which are `packages`, `source` and `check`.

```bash
uv run smalldocs api check --dir docs
```

`smalldocs api check` lists the gaps, and `--dir docs` names the folder of the settings. It holds every function,
method and class to one rule, with four parts.

- a type and a docment on every parameter
- a type and a docment on the return, unless it is `None`
- a docstring
- a description on every field of a pydantic model

The first lines of the output count the complete ones in each module and each file of tests.

- `babykev.api`, 0 of 12
- `babykev.cli`, 1 of 1
- `tests/unit/test_api.py`, 23 of 29
- `tests/unit/test_cli.py`, 0 of 3

Then come 46 lines, one for each gap, and the last line, `24 of 45 functions, methods and classes are typed and
documented`. The command ends with exit code 1. The linter asks already for every type and for every docstring of a
public name, so 45 of the 46 gaps are docments and descriptions. The other one is the docstring of `_check`, a private
method, which the linter does not ask for.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 4444b1e80942
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 609d58ce5f8c --staged -- :/ && git restore --source 4444b1e80942 --staged --worktree -- :/
```

#### What changed

- <a id="tut-13.2-docs-_smalldocs.yml-4b0b48"></a>`docs/_smalldocs.yml`: the package to document, and the tests to check. New, 5 lines. [The file](https://github.com/rahuldave/babykev/blob/4444b1e809427e92a5dc08a9e9fdbbddab7de830/docs/_smalldocs.yml).
  - look at `  packages: [babykev]`

<details open><summary>The patch to <code>docs/_smalldocs.yml</code></summary>

```diff
@@ -0,0 +1,5 @@
+# The settings of smalldocs. `api` is the reference, made from the code of the package
+api:
+  packages: [babykev]
+  source: https://github.com/rahuldave/babykev/blob/tutorial  # each entry links to its line here
+  check: ["tests/**/*.py"]  # the tests are held to the same rule as the package
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4444b1e809427e92a5dc08a9e9fdbbddab7de830). [The code after it](https://github.com/rahuldave/babykev/tree/4444b1e809427e92a5dc08a9e9fdbbddab7de830).

<a id="tut-13.3"></a>

### 13.3 The recipe docs

The command that lists the gaps is long. The recipe `docs` gives its words to `smalldocs api`, and adds `--dir docs`.

Apply the patch to [`justfile`](#tut-13.3-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/a582ad38e75bb188174b75a5e80405cebcd1259d.diff | git apply --include=justfile
```

The patch adds the recipe `docs` at the end of the `justfile`, in a group of its own, `docs`.

```bash
just --show docs
just docs check
just help docs
```

`just --show docs` prints the recipe. `just docs check` prints the same as `smalldocs api check` above, and ends with
`24 of 45` and exit code 1. `just help docs` prints the line of the recipe.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check a582ad38e75b
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 4444b1e80942 --staged -- :/ && git restore --source a582ad38e75b --staged --worktree -- :/
```

#### What changed

- <a id="tut-13.3-justfile-424f0b"></a>`justfile`: the recipe `docs`. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/a582ad38e75bb188174b75a5e80405cebcd1259d/justfile).
  - look at `docs *args:`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -74,3 +74,9 @@ check *args:
     just lint
     just test -q
     just lint-config
+
+# The reference of the code, by smalldocs. Words go to smalldocs api: just docs check, just docs module api
+[group('docs')]
+[no-exit-message]
+docs *args:
+    @{{ if args == "help" { "just help docs" } else { 'uv run smalldocs api "$@" --dir docs' } }}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a582ad38e75bb188174b75a5e80405cebcd1259d).

This part ends at the code at `a582ad38e75b`, partway through `tut-13`. [The code after this part](https://github.com/rahuldave/babykev/tree/a582ad38e75bb188174b75a5e80405cebcd1259d)

<a id="tut-13.12"></a>

## 13.12 The docs check joins `just check`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `861142a50356`, partway through `tut-13`. [The code before this part](https://github.com/rahuldave/babykev/tree/861142a50356963bb5e371fe8226ba73b87eef93)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git restore --source a582ad38e75b --staged -- :/ && git restore --source 861142a50356 --staged --worktree -- :/
```

```bash
just setup
```

The code now has its documentation. A docment is a comment beside a parameter or a return type. Every function of
`api.py` and of the tests has docments, and every field of a request has a description. One docment was too long on purpose,
`just fmt` wrapped its line, and a shorter docment took its place.

`just check` does not run the docs check yet. One line in `check` runs it.

### 13.12 The gate checks the docs

`just check` passed with a docment lost. As a line of `check`, `just docs check` runs before each `git commit`,
through the hook. It goes after the tests, and before the config files.

Apply the patch to [`justfile`](#tut-13.12-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/005b87bdfa2e70c6ceca52dc07197c69702f00be.diff | git apply --include=justfile
```

In the recipe `check`, the patch adds `just docs check` under `just test -q`, and names the docs in the comment above
the recipe.

```bash
just --show check
just check
```

`just --show check` prints the recipe, with five checks. `just check` prints the output of each, with `45 of 45`
after the tests, and ends with exit code 0. A function, a parameter or a field with no documentation now stops
`git commit`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 005b87bdfa2e
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source 861142a50356 --staged -- :/ && git restore --source tut-13 --staged --worktree -- :/
```

#### What changed

- <a id="tut-13.12-justfile-424f0b"></a>`justfile`: the docs check, in the gate. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/005b87bdfa2e70c6ceca52dc07197c69702f00be/justfile).
  - look at `    just docs check`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -63,7 +63,7 @@ lint-config *args:
 test *args:
     @{{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
 
-# Run the checks one after another, and stop at the first that fails: the format, the linter, the tests, the config files
+# Run the checks one after another, and stop at the first that fails: the format, the linter, the tests, the docs, the config files
 [group('quality')]
 [no-exit-message]
 check *args:
@@ -73,6 +73,7 @@ check *args:
     just fmt --check
     just lint
     just test -q
+    just docs check
     just lint-config
 
 # The reference of the code, by smalldocs. Words go to smalldocs api: just docs check, just docs module api
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/005b87bdfa2e70c6ceca52dc07197c69702f00be).

This part ends at the code at `tut-13`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-13)

<a id="tut-14.1-to-tut-14.2"></a>

## 14.1 to 14.2 `just docs` alone builds the site

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-13`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-13)

```bash
just setup
```

The reference is text in a terminal. The recipe `docs` changes. With no words, it builds a site. With words, it works
as before, so `just docs check` is the same command.

<a id="tut-14.1"></a>

### 14.1 Git ignores what a build of the docs makes

smalldocs builds the site, and the build writes three things into `docs/`. `docs/_site/` is the site, as HTML.
`docs/api/` holds the reference pages, as Markdown, and `docs/_symbols.json` holds the names that a link can point
to. A build makes all three again from the code, so they do not belong in git. `.gitignore` names the files that git
does not track, and three lines at its end name these, before the first build. A `/` at the start of a line means
the root of the repository, so `/docs/api/` is only that folder.

Apply the patch to [`.gitignore`](#tut-14.1-.gitignore-a5cc29), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/3593f61e4e221b04f00f360fe96e6dc4243b02dd.diff | git apply --include=.gitignore
```

The patch adds a comment and three lines at the end of `.gitignore`.

```bash
tail -n 4 .gitignore
```

`tail -n 4 .gitignore` prints the comment and the three lines.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 3593f61e4e22
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-13 --staged -- :/ && git restore --source 3593f61e4e22 --staged --worktree -- :/
```

#### What changed

- <a id="tut-14.1-.gitignore-a5cc29"></a>`.gitignore`: the files that a build of the docs makes. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/3593f61e4e221b04f00f360fe96e6dc4243b02dd/.gitignore).
  - look at `/docs/_site/`

<details open><summary>The patch to <code>.gitignore</code></summary>

```diff
@@ -218,3 +218,8 @@ __marimo__/
 
 # Streamlit
 .streamlit/secrets.toml
+
+# smalldocs: the docs site, and the reference pages that each build makes from the code
+/docs/_site/
+/docs/api/
+/docs/_symbols.json
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3593f61e4e221b04f00f360fe96e6dc4243b02dd). [The code after it](https://github.com/rahuldave/babykev/tree/3593f61e4e221b04f00f360fe96e6dc4243b02dd).

<a id="tut-14.2"></a>

### 14.2 Just docs, alone, builds the site

`smalldocs render docs` builds the site from the folder `docs`. It writes the reference pages from the code, then
the HTML of every page into `docs/_site`. With no words, the recipe `docs` now runs it. With words, it runs
`smalldocs api` as before. So the body of the recipe is a script of `sh`.

Apply the patch to [`justfile`](#tut-14.2-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/64de40516df5aa215bfac1c0198e898ac0960061.diff | git apply --include=justfile
```

The patch writes the recipe `docs` again, from its comment to its last line. Its body is now a script, with one line
for `help`, one for no words, and one for words.

```bash
uv run smalldocs render docs
just --show docs
just docs
git status --short --ignored docs
```

`smalldocs render docs` prints `wrote 2 page(s) to docs/_site`. The two pages are the reference of `api.py` and of
`cli.py`, because `docs/` has no page of its own yet. `just --show docs` prints the recipe, and `just docs` prints the
same line as the command.

`git status --short --ignored docs` lists the three paths that the build made, each marked `!!`, ignored. The lines
of `.gitignore` from the move before keep them out of git.

Your copy also lists `?? docs/` first. git does not know the folder yet, because nothing in it is staged.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 64de40516df5
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 3593f61e4e22 --staged -- :/ && git restore --source 64de40516df5 --staged --worktree -- :/
```

#### What changed

- <a id="tut-14.2-justfile-424f0b"></a>`justfile`: with no words, `docs` builds the site. 5 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/64de40516df5aa215bfac1c0198e898ac0960061/justfile).
  - look at `    if [ "$#" -eq 0 ]; then exec uv run smalldocs render docs; fi`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -76,8 +76,11 @@ check *args:
     just docs check
     just lint-config
 
-# The reference of the code, by smalldocs. Words go to smalldocs api: just docs check, just docs module api
+# The docs, by smalldocs. Alone, the site in docs/_site. Words go to smalldocs api: just docs check
 [group('docs')]
 [no-exit-message]
 docs *args:
-    @{{ if args == "help" { "just help docs" } else { 'uv run smalldocs api "$@" --dir docs' } }}
+    #!/usr/bin/env sh
+    if [ "$*" = help ]; then just help docs; exit 0; fi
+    if [ "$#" -eq 0 ]; then exec uv run smalldocs render docs; fi
+    exec uv run smalldocs api "$@" --dir docs
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/64de40516df5aa215bfac1c0198e898ac0960061).

This part ends at the code at `64de40516df5`, partway through `tut-14`. [The code after this part](https://github.com/rahuldave/babykev/tree/64de40516df5aa215bfac1c0198e898ac0960061)

<a id="tut-17"></a>

## 17 `just types`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-16`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-16)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source 64de40516df5 --staged -- :/ && git restore --source tut-16 --staged --worktree -- :/
```

The whole tutorial then gives the site its settings and a front page. It brings in torch, from the index of PyTorch's
builds for the CPU, and transformers, peft and safetensors. Then `src/babykev/model.py` comes in, the model, with no
tests of its own yet. So the total coverage falls to 43%. `just check` has no floor on the coverage, so it still
passes.

The linter asks only that each type be there. A type checker, ty, comes in, with a recipe `types`. Then the types join
`just check`.

```bash
just setup
```

`just setup` prints `Resolved 66 packages`.

`model.py` has a type on every parameter and every return. Nothing checks them. Python runs the code without
reading the types, and the linter asks only that they be there. A type checker reads the code, and compares each
call and each value with the types that the code and its libraries declare. ty is a type checker. It finds two
places in `model.py`, and both have one cause, in torch.

<a id="tut-17.1"></a>

### 17.1 ty, in the group lint

ty is for working on babykev, so it goes in the group `lint`.

[ty](https://docs.astral.sh/ty/) is a type checker for Python, from the makers of uv and ruff. It reads the type hints and finds the places where a value cannot have the type that the code expects, without running the code.

```bash
uv add --group lint ty
```

`uv add` prints `Resolved 67 packages`, and installs ty, which needs no other package.

```bash
uv run ty --version
```

It prints the version of ty that uv installed. A newer ty can find more, or less, than these notes show.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check aaa8fe6d7d1d
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-16 --staged -- :/ && git restore --source aaa8fe6d7d1d --staged --worktree -- :/
```

#### What changed

- <a id="tut-17.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: ty, in the group `lint`. 1 line added. It comes from `uv add --group lint ty`. [The file](https://github.com/rahuldave/babykev/blob/aaa8fe6d7d1dfbca863fe23dc0d660dd10d36c2b/pyproject.toml).
  - look at `"ty>=0.0.88",`
- <a id="tut-17.1-uv.lock-8356d8"></a>`uv.lock`: the exact version of ty. 27 lines added. It comes from `uv add --group lint ty`. [The file](https://github.com/rahuldave/babykev/blob/aaa8fe6d7d1dfbca863fe23dc0d660dd10d36c2b/uv.lock).

<details><summary>The diff that <code>uv add --group lint ty</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -43,6 +43,7 @@ docs = [
 lint = [
     "pre-commit>=4.7.0",
     "ruff>=0.17.1",
+    "ty>=0.0.88",
     "validate-pyproject>=0.26",
     "yamllint>=1.38.0",
 ]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/aaa8fe6d7d1dfbca863fe23dc0d660dd10d36c2b). [The code after it](https://github.com/rahuldave/babykev/tree/aaa8fe6d7d1dfbca863fe23dc0d660dd10d36c2b).

<a id="tut-17.2"></a>

### 17.2 The recipe types

`ty check` checks every Python file of the project. The recipe `types` runs it, and gives it any extra words.

Apply the patch to [`justfile`](#tut-17.2-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/7866ef7f88d528e2e7ee04d55c68e56ce461cff1.diff | git apply --include=justfile
```

The patch adds the recipe `types` in the group `quality`, between `lint-config` and `test`.

The command behind the recipe comes first.

```bash
uv run ty check
```

`ty check` prints two diagnostics, and ends with exit code 1. Both are `error[invalid-mutable-override]`, `Invalid
override of attribute forward`, at `src/babykev/model.py:178:9` and at `src/babykev/model.py:257:9`. The two lines
are the methods `forward` of `PointerHead` and of `DecisionModel`. Under each, ty says `Override does not accept writes of type
(...) -> Any`. The last line is `Found 2 diagnostics`.

```bash
just --show types
just types
just help types
```

`just --show types` prints the recipe. `just types` prints the same two diagnostics, and ends with exit code 1. `just
help types` prints the line of the recipe.

```bash
uv run ty explain rule invalid-mutable-override
```

`ty explain rule` prints what a rule checks. A subclass must accept every value that its base class lets code write
into an attribute. Its example has a `value: int` in a base class and a `value: bool` in a subclass. Code that writes
`42` through the base class breaks the subclass. The next move reads what torch declares.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 7866ef7f88d5
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source aaa8fe6d7d1d --staged -- :/ && git restore --source 7866ef7f88d5 --staged --worktree -- :/
```

#### What changed

- <a id="tut-17.2-justfile-424f0b"></a>`justfile`: the recipe `types`. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/7866ef7f88d528e2e7ee04d55c68e56ce461cff1/justfile).
  - look at `types *args:`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -57,6 +57,12 @@ lint-config *args:
     just --fmt --check --unstable
     uv run yamllint --strict .
 
+# Check the types, by reading the code and not running it. Extra words go to ty: just types src
+[group('quality')]
+[no-exit-message]
+types *args:
+    @{{ if args == "help" { "just help types" } else { 'uv run ty check "$@"' } }}
+
 # Run the tests. Extra words go to pytest: just test -k render
 [group('quality')]
 [no-exit-message]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7866ef7f88d528e2e7ee04d55c68e56ce461cff1). [The code after it](https://github.com/rahuldave/babykev/tree/7866ef7f88d528e2e7ee04d55c68e56ce461cff1).

<a id="tut-17.3"></a>

### 17.3 PointerHead.forward, past ty

torch declares `forward` in its base class of every model, `nn.Module`.

```bash
grep -n '= _forward_unimplemented' .venv/lib/python3.13/site-packages/torch/nn/modules/module.py
```

`grep` prints line 526 of `module.py`, `forward: Callable[..., Any] = _forward_unimplemented`. `forward` is an
attribute that may hold any function, with any arguments. `PointerHead` puts a method there that takes two tensors.
Code could write any function into `forward` of an `nn.Module`, and the method accepts fewer calls. The rule refuses
this narrowing.

Every model of torch defines `forward` as a method. torch only calls it, from `__call__`, and never writes it. So the
rule is right in general, and does not fit here.

A comment `# ty: ignore[invalid-mutable-override]` on the line of a diagnostic turns off that one rule on that one
line. Each other rule still checks the line. A comment above the method says why.

Apply the patch to [`src/babykev/model.py`](#tut-17.3-src-babykev-model.py-a86a0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/d5312a3ec2ed265ca4dbf5c7dd2492c686024696.diff | git apply --include=src/babykev/model.py
```

In `src/babykev/model.py`, the patch adds the comment at the end of the line `def forward(` of `PointerHead`, and two
lines of reason above it.

```bash
just types
just docs check
```

`just types` prints one diagnostic, at `src/babykev/model.py:259:9`, the `forward` of `DecisionModel`, two lines lower
than before. It ends with `Found 1 diagnostic`, and exit code 1. `just docs check` prints the note of torch and
`60 of 60`. The comment on the line `def forward(` is not a docment, because a docment is on the line of a parameter
or of the return type.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check d5312a3ec2ed
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 7866ef7f88d5 --staged -- :/ && git restore --source d5312a3ec2ed --staged --worktree -- :/
```

#### What changed

- <a id="tut-17.3-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: the rule off on the `forward` of `PointerHead`, with the reason. 3 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/d5312a3ec2ed265ca4dbf5c7dd2492c686024696/src/babykev/model.py).
  - look at `    # tensors accepts fewer calls, so ty refuses it. torch only calls forward, and never sets it`

<details open><summary>The patch to <code>src/babykev/model.py</code></summary>

```diff
@@ -175,7 +175,9 @@ class PointerHead(nn.Module):
         self.q, self.k = nn.Linear(d, dp), nn.Linear(d, dp)
         self.scale = 1 / math.sqrt(dp)
 
-    def forward(
+    # nn.Module declares forward as an attribute that may hold any function. A method with two
+    # tensors accepts fewer calls, so ty refuses it. torch only calls forward, and never sets it
+    def forward(  # ty: ignore[invalid-mutable-override]
         self,
         h_decide: torch.Tensor,  # The hidden state at the decide token, shape [d]
         h_opts: torch.Tensor,  # The hidden states at the K options' closing tokens, shape [K, d]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/d5312a3ec2ed265ca4dbf5c7dd2492c686024696). [The code after it](https://github.com/rahuldave/babykev/tree/d5312a3ec2ed265ca4dbf5c7dd2492c686024696).

<a id="tut-17.4"></a>

### 17.4 DecisionModel.forward, past ty

The `forward` of `DecisionModel` is the same case. It gets the same comment, and one line of reason that points to
the first.

Apply the patch to [`src/babykev/model.py`](#tut-17.4-src-babykev-model.py-a86a0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/f14349138824af0b107742451814b1234e72b34a.diff | git apply --include=src/babykev/model.py
```

In `src/babykev/model.py`, the patch adds the comment at the end of the line `def forward(` of `DecisionModel`, and
one line of reason above it.

```bash
just types
```

`just types` prints `All checks passed!`, and ends with exit code 0.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check f14349138824
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source d5312a3ec2ed --staged -- :/ && git restore --source f14349138824 --staged --worktree -- :/
```

#### What changed

- <a id="tut-17.4-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: the rule off on the `forward` of `DecisionModel`, with the reason. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/f14349138824af0b107742451814b1234e72b34a/src/babykev/model.py).
  - look at `    # As in PointerHead, nn.Module declares forward as an attribute, and torch never sets it`

<details open><summary>The patch to <code>src/babykev/model.py</code></summary>

```diff
@@ -256,7 +256,8 @@ class DecisionModel(nn.Module):
             for b, enc in enumerate(encs)
         ]
 
-    def forward(
+    # As in PointerHead, nn.Module declares forward as an attribute, and torch never sets it
+    def forward(  # ty: ignore[invalid-mutable-override]
         self,
         enc: Encoded,  # A packed record
     ) -> list[torch.Tensor]:  # For each question, one logit per option
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f14349138824af0b107742451814b1234e72b34a). [The code after it](https://github.com/rahuldave/babykev/tree/f14349138824af0b107742451814b1234e72b34a).

<a id="tut-17.5"></a>

### 17.5 The gate checks the types

`just types` passes, and nothing runs it before `git commit`. As a line of `check`, it runs before each `git commit`,
through the hook. It goes after the linter, and before the tests.

Apply the patch to [`justfile`](#tut-17.5-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/d4dd1c8d3d3c94aa391b3baff5c5aab706b149b9.diff | git apply --include=justfile
```

In the recipe `check`, the patch adds `just types` under `just lint`, and names the types in the comment above the
recipe.

```bash
just --show check
just check
```

`just --show check` prints the recipe, with six checks. `just check` prints `All checks passed!` twice, once for the
linter and once for ty. Then come `53 passed`, the total of 43%, `60 of 60` and the config files, and it ends with
exit code 0. A call that does not match the types now stops `git commit`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check d4dd1c8d3d3c
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source f14349138824 --staged -- :/ && git restore --source tut-17 --staged --worktree -- :/
```

#### What changed

- <a id="tut-17.5-justfile-424f0b"></a>`justfile`: ty, in the gate. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/d4dd1c8d3d3c94aa391b3baff5c5aab706b149b9/justfile).
  - look at `    just types`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -69,7 +69,7 @@ types *args:
 test *args:
     @{{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
 
-# Run the checks one after another, and stop at the first that fails: the format, the linter, the tests, the docs, the config files
+# Run the checks one after another, and stop at the first that fails: the format, the linter, the types, the tests, the docs, the config files
 [group('quality')]
 [no-exit-message]
 check *args:
@@ -78,6 +78,7 @@ check *args:
     if [ "$*" = help ]; then just help check; exit 0; fi
     just fmt --check
     just lint
+    just types
     just test -q
     just docs check
     just lint-config
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/d4dd1c8d3d3c94aa391b3baff5c5aab706b149b9).

This part ends at the code at `tut-17`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-17)

<a id="tut-18.7"></a>

## 18.7 `just smoke`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `117a59e9838e`, partway through `tut-18`. [The code before this part](https://github.com/rahuldave/babykev/tree/117a59e9838e0fa2e28ad29d02d5aeba3a8622f9)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-17 --staged -- :/ && git restore --source 117a59e9838e --staged --worktree -- :/
```

```bash
just setup
```

The code now has `src/babykev/smoke.py`, a smoke run. It loads the real model on this machine, asks it the questions
of the sample data, and prints each answer beside its label. The command `babykev smoke` runs it. The first run
downloads the model from the Hugging Face Hub.

The smoke gets a recipe of its own, in a group `model`. `just check` does not run it.

### 18.7 The recipe smoke

The recipe `smoke` runs the command. It answers `help` as every recipe does, and gives any other word to `babykev
smoke`. It is in a group of its own, `model`.

Apply the patch to [`justfile`](#tut-18.7-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/55844b2320b632b40dd3f34f0a6b5bb962551005.diff | git apply --include=justfile
```

The patch adds the recipe `smoke` at the end of the `justfile`.

The command behind the recipe comes first.

```bash
uv run babykev smoke
just --show smoke
just smoke
```

`uv run babykev smoke` prints the same report as the last move, `6 of 15 right`, with other times. `just --show
smoke` prints the recipe. `just smoke` runs it, and prints the same report again.

```bash
just help smoke
```

`just help smoke` prints the line of the recipe. Line 101 names `{{ program }} smoke`, so the recipe `help` also prints
the usage of the program.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 55844b2320b6
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 117a59e9838e --staged -- :/ && git restore --source 55844b2320b6 --staged --worktree -- :/
```

#### What changed

- <a id="tut-18.7-justfile-424f0b"></a>`justfile`: the recipe `smoke`. 8 lines added. [The file](https://github.com/rahuldave/babykev/blob/55844b2320b632b40dd3f34f0a6b5bb962551005/justfile).
  - look at `smoke *args:`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -91,3 +91,11 @@ docs *args:
     if [ "$*" = help ]; then just help docs; exit 0; fi
     if [ "$#" -eq 0 ]; then exec uv run smalldocs render docs; fi
     exec uv run smalldocs api "$@" --dir docs
+
+# Run the smoke on this machine: the real model answers the sample requests, untrained
+[group('model')]
+[no-exit-message]
+smoke *args:
+    #!/usr/bin/env sh
+    if [ "$*" = help ]; then just help smoke; exit 0; fi
+    exec uv run {{ program }} smoke "$@"
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/55844b2320b632b40dd3f34f0a6b5bb962551005).

This part ends at the code at `55844b2320b6`, partway through `tut-18`. [The code after this part](https://github.com/rahuldave/babykev/tree/55844b2320b632b40dd3f34f0a6b5bb962551005)

<a id="tut-21.4"></a>

## 21.4 The floor on the coverage

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `08acf0a3770d`, partway through `tut-21`. [The code before this part](https://github.com/rahuldave/babykev/tree/08acf0a3770d58ab7fc3ac85eebf5cf9ed0bad0e)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git restore --source 55844b2320b6 --staged -- :/ && git restore --source 08acf0a3770d --staged --worktree -- :/
```

```bash
just setup
```

The code now has a tiny model, built in memory, and fixtures of pytest that make it. Unit tests and integration tests
of the model and the smoke run on it. The total coverage is 91.76%.

`just check` gets a floor. `just test` alone keeps none.

### 21.4 The gate has a floor of 90%

`just check` runs the tests with `--cov-fail-under=90`. A change that brings the total under 90% then fails the gate, and the hook refuses it.
`just test` alone has no floor, so a run of a few tests, with `-k`, does not fail on the total.

Apply the patch to [`justfile`](#tut-21.4-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/57604134d9590c16b1c4db0b1d1a11509a65345b.diff | git apply --include=justfile
```

In the recipe `check`, the patch adds `--cov-fail-under=90` to `just test -q`, and names the coverage in the comment
above the recipe.

```bash
just --show check
just check
```

`just check` prints `Required test coverage of 90% reached. Total coverage: 91.76%` after the tests, and ends with
exit code 0.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 57604134d959
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 08acf0a3770d --staged -- :/ && git restore --source 57604134d959 --staged --worktree -- :/
```

#### What changed

- <a id="tut-21.4-justfile-424f0b"></a>`justfile`: the floor, in the gate. 2 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/57604134d9590c16b1c4db0b1d1a11509a65345b/justfile).
  - look at `    just test -q --cov-fail-under=90`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -69,7 +69,7 @@ types *args:
 test *args:
     @{{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
 
-# Run the checks one after another, and stop at the first that fails: the format, the linter, the types, the tests, the docs, the config files
+# Run the checks one after another, and stop at the first that fails: the format, the linter, the types, the tests and their coverage, the docs, the config files
 [group('quality')]
 [no-exit-message]
 check *args:
@@ -79,7 +79,7 @@ check *args:
     just fmt --check
     just lint
     just types
-    just test -q
+    just test -q --cov-fail-under=90
     just docs check
     just lint-config
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/57604134d9590c16b1c4db0b1d1a11509a65345b).

This part ends at the code at `57604134d959`, partway through `tut-21`. [The code after this part](https://github.com/rahuldave/babykev/tree/57604134d9590c16b1c4db0b1d1a11509a65345b)

<a id="tut-25"></a>

## 25 `just image`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-24`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-24)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source 57604134d959 --staged -- :/ && git restore --source tut-24 --staged --worktree -- :/
```

The whole tutorial then finds a bug in the mask of the model with tests of hypothesis, and fixes it. It adds a test of
the real model, marked `system`. `-m 'not system'` in `pyproject.toml` leaves that test out of `just test`, and so out
of `just check` and the hook. `just test -m system` runs it. Then the docs get a guide to the model.

The fix of the mask changes the answers of the smoke. In this section, the smoke prints `4 of 15 right`, where `just
smoke` printed `6 of 15 right` above, with the old mask. The mask changed the answers, and not the device.

A `Dockerfile` comes in, with two images. The commands that build and run them get one recipe, `image`. hadolint
checks the `Dockerfile`, as a line of `just lint-config`. This section needs Docker.

```bash
just setup
```

`just setup` prints `Resolved 69 packages`.

So far everything ran on this Mac. A student may have Windows or Linux, and a platform that trains a model runs Linux
on a machine of someone else. An image of Docker is a Linux machine that one file describes, and Docker runs it on any
of these systems.

The `Dockerfile` of babykev builds two images from `uv.lock`. The run image holds the program and what it needs, and
starts `babykev`. The dev image holds the whole project and the tools to work on it, and starts a shell. The images
are built and run on this machine only, and pushed nowhere.

<a id="tut-25.1"></a>

### 25.1 The Dockerfile, with the run image

A `Dockerfile` builds an image in stages, and each `FROM` starts one. The stage `uv` is the image of uv itself. The
stage `build` installs the environment into `/opt/venv`, with no group of the developers. The packages of `uv.lock`
come first, and the code after. Docker keeps each instruction of a build in its cache, so a change to the code installs one
package again, and not torch.

[Docker](https://www.docker.com/) builds an image, a file system with an operating system, Python and the project in it, from a `Dockerfile`. A container runs the image the same way on any machine, so the project does not depend on what a laptop has installed.

The stage `run` starts from a fresh Python, and takes only the finished environment and the sample data. uv stays in
the stage `build`.

Apply the patch to [`Dockerfile`](#tut-25.1-Dockerfile-6651dd), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/570bb2134f032a64a34d14852c82fa1a199f69f6.diff | git apply --include=Dockerfile
```

The patch makes the file. Read the three stages, from each `FROM`.

```bash
docker build --target run --tag babykev-run .
docker run --rm babykev-run
```

`--target run` builds the stage `run` and the stages that it needs, and `--tag` names the image. `docker run --rm`
starts the image and removes the container when it stops. With no word, the image runs `babykev help`, from
`ENTRYPOINT` and `CMD` on lines 35 and 36, and prints the help.

```bash
docker image ls babykev-run:latest
```

The image takes about 1.1 GB, and torch is most of it.

```bash
docker run --rm -v ~/.cache/huggingface:/hf babykev-run smoke
uv run babykev smoke
```

`-v` mounts the cache of the Hugging Face Hub of this Mac at `/hf`, where `HF_HOME` on line 33 sends the library. So
the base model is not downloaded again.

The smoke in the container says `on cpu`. A container on a Mac runs Linux in a virtual
machine, and sees no GPU of Apple. `uv run babykev smoke` runs the same smoke on this Mac, on `mps`. Both print
`4 of 15 right`, and the same fifteen answers, with the same two decimals. A request takes much longer in the
container than on `mps`, and the milliseconds change from run to run.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 570bb2134f03
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-24 --staged -- :/ && git restore --source 570bb2134f03 --staged --worktree -- :/
```

#### What changed

- <a id="tut-25.1-Dockerfile-6651dd"></a>`Dockerfile`: the stages `uv`, `build` and `run`. New, 36 lines. [The file](https://github.com/rahuldave/babykev/blob/570bb2134f032a64a34d14852c82fa1a199f69f6/Dockerfile).
  - look at `FROM python:3.13-slim-trixie AS run`

<details open><summary>The patch to <code>Dockerfile</code></summary>

```diff
@@ -0,0 +1,36 @@
+# The images of babykev, built from uv.lock, so that they hold the versions that the lockfile names.
+#
+#   docker build --target run --tag babykev-run .
+#       the program and what it needs, and no tool of the developers. It starts babykev
+#
+# The environment is in /opt/venv, and never in the folder of the project.
+
+# uv, copied from its own image, at the version that wrote the lockfile
+FROM ghcr.io/astral-sh/uv:0.12.13 AS uv
+
+# The environment, with no group of the developers. The packages come first and the code after, so a
+# change to the code installs one package again, and not torch
+FROM python:3.13-slim-trixie AS build
+COPY --from=uv /uv /usr/local/bin/uv
+ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
+    UV_PYTHON_DOWNLOADS=never \
+    UV_COMPILE_BYTECODE=1 \
+    UV_LINK_MODE=copy \
+    UV_NO_CACHE=1
+WORKDIR /app
+COPY pyproject.toml uv.lock .python-version ./
+RUN uv sync --locked --no-default-groups --no-install-project
+COPY README.md LICENSE NOTICE ./
+COPY src ./src
+RUN uv sync --locked --no-default-groups --no-editable
+
+# The run image: Python, the environment, the program and its sample data. It has no uv
+FROM python:3.13-slim-trixie AS run
+COPY --from=build /opt/venv /opt/venv
+WORKDIR /app
+COPY data ./data
+ENV PATH=/opt/venv/bin:$PATH \
+    HF_HOME=/hf \
+    PYTHONUNBUFFERED=1
+ENTRYPOINT ["babykev"]
+CMD ["help"]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/570bb2134f032a64a34d14852c82fa1a199f69f6). [The code after it](https://github.com/rahuldave/babykev/tree/570bb2134f032a64a34d14852c82fa1a199f69f6).

<a id="tut-25.2"></a>

### 25.2 The dev image

The stage `dev` builds the image to work in. It installs git with `apt-get`, and copies uv and uvx. It installs just
as a wheel from PyPI. Then it installs the whole project with every group, into `/opt/venv`. The folder of this
machine can then be mounted at `/work`, and the image runs it with its own environment.

Apply the patch to [`Dockerfile`](#tut-25.2-Dockerfile-6651dd), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/40012bdfeb76ad96615227e9772d387ee5e48495.diff | git apply --include=Dockerfile
```

The patch adds the dev image to the comment at the top of the file, and the stage `dev` at the end of the file.

```bash
docker build --target dev --tag babykev-dev .
```

The line `transferring context` gives what Docker read from the folder, about 760 to 830 MB. `COPY . .` copies the whole
folder, the `.venv` of this Mac too.

```bash
docker run --rm babykev-dev du -sh /work/.venv /opt/venv
docker image ls babykev-dev:latest
```

`du` prints about `800M` for `/work/.venv`, the environment of this Mac, built for macOS, which Linux cannot use.
`/opt/venv` is the environment of the image, 1.1G. The image takes about 2.1 GB.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 40012bdfeb76
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 570bb2134f03 --staged -- :/ && git restore --source 40012bdfeb76 --staged --worktree -- :/
```

#### What changed

- <a id="tut-25.2-Dockerfile-6651dd"></a>`Dockerfile`: the stage `dev`. 31 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/40012bdfeb76ad96615227e9772d387ee5e48495/Dockerfile).
  - look at `FROM python:3.13-slim-trixie AS dev`

<details open><summary>The patch to <code>Dockerfile</code></summary>

```diff
@@ -2,8 +2,11 @@
 #
 #   docker build --target run --tag babykev-run .
 #       the program and what it needs, and no tool of the developers. It starts babykev
+#   docker build --target dev --tag babykev-dev .
+#       the whole project, with every group, uv, just and git. It starts a shell
 #
-# The environment is in /opt/venv, and never in the folder of the project.
+# The environment is in /opt/venv, and never in the folder of the project. So the dev image can run
+# the folder of this machine, mounted at /work, and never uses its .venv.
 
 # uv, copied from its own image, at the version that wrote the lockfile
 FROM ghcr.io/astral-sh/uv:0.12.13 AS uv
@@ -34,3 +37,30 @@ ENV PATH=/opt/venv/bin:$PATH \
     PYTHONUNBUFFERED=1
 ENTRYPOINT ["babykev"]
 CMD ["help"]
+
+# The dev image: the whole project with every group, and the tools to work on it
+FROM python:3.13-slim-trixie AS dev
+ARG JUST=1.50.0
+RUN apt-get update \
+    && apt-get install --yes --no-install-recommends git \
+    && rm -rf /var/lib/apt/lists/*
+COPY --from=uv /uv /uvx /usr/local/bin/
+ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
+    UV_PYTHON_DOWNLOADS=never \
+    UV_COMPILE_BYTECODE=1 \
+    UV_LINK_MODE=copy \
+    UV_NO_CACHE=1 \
+    UV_TOOL_BIN_DIR=/usr/local/bin \
+    PATH=/opt/venv/bin:$PATH \
+    HF_HOME=/hf \
+    PYTHONUNBUFFERED=1
+# just, as a wheel from PyPI. git refuses a repository that another user owns, and a mounted folder
+# can belong to the user of this machine, so every folder is declared safe
+RUN uv tool install "rust-just==${JUST}" \
+    && git config --system --add safe.directory '*'
+WORKDIR /work
+COPY pyproject.toml uv.lock .python-version ./
+RUN uv sync --locked --no-install-project
+COPY . .
+RUN uv sync --locked
+CMD ["bash"]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/40012bdfeb76ad96615227e9772d387ee5e48495). [The code after it](https://github.com/rahuldave/babykev/tree/40012bdfeb76ad96615227e9772d387ee5e48495).

<a id="tut-25.3"></a>

### 25.3 What a build never copies into an image

`.dockerignore` names the files that `docker build` never reads from the folder, as `.gitignore` names the files that
git never tracks. They are the history of git, the environment and the settings of this machine, and what a run or a
tool writes.

Apply the patch to [`.dockerignore`](#tut-25.3-.dockerignore-05a721), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/f0862402733db839738f0b350a049b2ee5e2a2aa.diff | git apply --include=.dockerignore
```

The patch makes the file.

```bash
docker build --target dev --tag babykev-dev .
docker run --rm babykev-dev ls -A /work
docker image ls babykev-dev:latest
```

`ls -A` lists the folder in the image, with no `.git` and no `.venv`. The image takes about 1.4 GB.

The dev image can run every check, with this folder mounted at `/work`.

```bash
docker run --rm -v "$PWD":/work babykev-dev just check
```

`just check` passes in the image, on Linux. The tests print `82 passed, 1 deselected`, and the total of 91.76%.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check f0862402733d
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 40012bdfeb76 --staged -- :/ && git restore --source f0862402733d --staged --worktree -- :/
```

#### What changed

- <a id="tut-25.3-.dockerignore-05a721"></a>`.dockerignore`: what a build never copies. New, 16 lines. [The file](https://github.com/rahuldave/babykev/blob/f0862402733db839738f0b350a049b2ee5e2a2aa/.dockerignore).
  - look at `.venv`

<details open><summary>The patch to <code>.dockerignore</code></summary>

```diff
@@ -0,0 +1,16 @@
+# What docker build never copies into an image: the history of git, the environment and the
+# settings of this machine, and what a run or a tool writes. An image makes its own environment.
+.git
+.venv
+.env
+.env.*
+**/__pycache__
+.ruff_cache
+.pytest_cache
+.hypothesis
+.coverage
+.coverage.*
+docs/_site
+docs/api
+docs/_symbols.json
+.DS_Store
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f0862402733db839738f0b350a049b2ee5e2a2aa). [The code after it](https://github.com/rahuldave/babykev/tree/f0862402733db839738f0b350a049b2ee5e2a2aa).

<a id="tut-25.4"></a>

### 25.4 No example of hypothesis has a deadline

hypothesis gives each example of a test 200 ms. In a container, the first example that runs torch can take longer, and
the test then fails, by chance, with `DeadlineExceeded`. A run of the dev image failed so, once in five runs, and the
same test passed at the next run. A test that fails by chance cannot be a reason to refuse a `git commit`. The tests of the mask check a
rule, and not a speed, so a profile of hypothesis turns the deadline off for every test.

Apply the patch to [`tests/conftest.py`](#tut-25.4-tests-conftest.py-626af3), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/3043d160e0d6e424e7178bd6c86dfeb1aa17abb4.diff | git apply --include=tests/conftest.py
```

The patch adds the import of `settings` from hypothesis, and under the imports a comment and two lines that register
the profile and load it.

```bash
sed -n '16,20p' tests/conftest.py
docker run --rm -v "$PWD":/work babykev-dev just test -q
```

pytest reads `conftest.py` before any test, so the profile holds for the whole run. The dev image runs the folder of
this Mac, so the change needs no new build. The tests print `82 passed, 1 deselected`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 3043d160e0d6
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source f0862402733d --staged -- :/ && git restore --source 3043d160e0d6 --staged --worktree -- :/
```

#### What changed

- <a id="tut-25.4-tests-conftest.py-626af3"></a>`tests/conftest.py`: no deadline, for every test that hypothesis feeds. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/3043d160e0d6e424e7178bd6c86dfeb1aa17abb4/tests/conftest.py).
  - look at `settings.register_profile("babykev", deadline=None)`

<details open><summary>The patch to <code>tests/conftest.py</code></summary>

```diff
@@ -7,11 +7,18 @@ trained model, no download and no GPU.
 from typing import Any
 
 import pytest
+from hypothesis import settings
 from transformers import PreTrainedTokenizerFast
 
 from babykev.model import DecisionModel
 from tests.tiny import tiny_backbone, tiny_tokenizer
 
+# hypothesis gives each example of a test 200 ms. The first example that runs torch can take
+# longer on a slow or busy machine, such as a container, and the test then fails by chance. The
+# tests that hypothesis feeds check a rule, and not a speed, so no example has a deadline
+settings.register_profile("babykev", deadline=None)
+settings.load_profile("babykev")
+
 
 @pytest.fixture(scope="session")
 def tok() -> PreTrainedTokenizerFast:  # The tiny tokenizer, built once for the whole test run
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3043d160e0d6e424e7178bd6c86dfeb1aa17abb4). [The code after it](https://github.com/rahuldave/babykev/tree/3043d160e0d6e424e7178bd6c86dfeb1aa17abb4).

<a id="tut-25.5"></a>

### 25.5 The recipe image

The recipe `image` runs the commands of the last moves. It has three words:

- `just image build dev` or `run` builds an image, and gives any other word to `docker build`.
- `just image shell` runs the dev image, with this folder at `/work`. The words before `--` go to `docker run`, and
  the words after it are the command to run. With no command, it starts a shell.
- `just image run` runs the program in the run image.

`shell` and `run` mount the cache of the Hub at `/hf`.

Apply the patch to [`justfile`](#tut-25.5-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/a2cd7c083154e3f1161449592635e04b8f84cebe.diff | git apply --include=justfile
```

The patch adds the recipe `image` under the recipe `hook`, in the group `setup`.

The commands behind the recipe ran in the last moves.

```bash
just --show image
just image build run
just image run smoke
just image shell -- just test -q
```

`just image build run` builds the run image. Docker takes each layer that it has built before from its cache, and
builds the others. `just image run smoke` prints
`4 of 15 right` again. `just image shell -- just test -q` prints `82 passed, 1 deselected`. Typed alone, `just image
shell` starts a shell in the image, where `exit` ends it.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check a2cd7c083154
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 3043d160e0d6 --staged -- :/ && git restore --source a2cd7c083154 --staged --worktree -- :/
```

#### What changed

- <a id="tut-25.5-justfile-424f0b"></a>`justfile`: the recipe `image`. 33 lines added. [The file](https://github.com/rahuldave/babykev/blob/a2cd7c083154e3f1161449592635e04b8f84cebe/justfile).
  - look at `image *args:`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -33,6 +33,39 @@ setup *args:
 hook *args:
     @{{ if args == "help" { "just help hook" } else { "uv run pre-commit install" } }}
 
+# The two images of the Dockerfile: just image build dev|run, just image shell, just image run smoke
+[group('setup')]
+[no-exit-message]
+image *args:
+    #!/usr/bin/env bash
+    set -e
+    if [ "$*" = help ]; then just help image; exit 0; fi
+    command -v docker > /dev/null || { echo "image: there is no docker on this machine" >&2; exit 2; }
+    # The cache of the Hugging Face Hub on this machine, mounted at /hf, so the model is downloaded once
+    cache="${HF_HOME:-$HOME/.cache/huggingface}"
+    case "$1" in
+        build)
+            case "$2" in dev | run) ;; *) echo "image build: say which image, dev or run" >&2; exit 2 ;; esac
+            kind=$2
+            shift 2
+            exec docker build --target "$kind" --tag "{{ program }}-$kind" "$@" .
+            ;;
+        shell)
+            # The words before -- go to docker, and the words after it are the command to run
+            shift
+            options=()
+            while [ $# -gt 0 ] && [ "$1" != -- ]; do options+=("$1"); shift; done
+            if [ "$1" = -- ]; then shift; fi
+            if [ -t 0 ]; then options+=(-it); fi
+            exec docker run --rm -v "$PWD:/work" -v "$cache:/hf" "${options[@]}" {{ program }}-dev "$@"
+            ;;
+        run)
+            shift
+            exec docker run --rm -v "$cache:/hf" {{ program }}-run "$@"
+            ;;
+        *) echo "image: build dev|run, shell [OPTIONS] [-- COMMAND], or run WORDS" >&2; exit 2 ;;
+    esac
+
 # Write the Python of the project in one style. Extra words go to ruff: just fmt --check
 [group('quality')]
 [no-exit-message]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a2cd7c083154e3f1161449592635e04b8f84cebe). [The code after it](https://github.com/rahuldave/babykev/tree/a2cd7c083154e3f1161449592635e04b8f84cebe).

<a id="tut-25.6"></a>

### 25.6 hadolint, in the group lint

hadolint is a linter for a `Dockerfile`. The package `hadolint-bin` holds its program, built for each system.

[hadolint](https://github.com/hadolint/hadolint) is a linter for Dockerfiles. It finds mistakes such as an `apt-get install` with no pinned versions, and it checks the shell commands of each `RUN`.

```bash
uv add --group lint hadolint-bin
```

`uv add` prints `Resolved 70 packages`, and installs hadolint-bin.

```bash
uv run hadolint --version
```

It prints `Haskell Dockerfile Linter` and its version.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check ce3646d2f0cd
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source a2cd7c083154 --staged -- :/ && git restore --source ce3646d2f0cd --staged --worktree -- :/
```

#### What changed

- <a id="tut-25.6-pyproject.toml-5d07e7"></a>`pyproject.toml`: hadolint, in the group `lint`. 1 line added. It comes from `uv add --group lint hadolint-bin`. [The file](https://github.com/rahuldave/babykev/blob/ce3646d2f0cdacf2177d9ba36355dd4ffc1b2f4a/pyproject.toml).
  - look at `"hadolint-bin>=2.15.1",`
- <a id="tut-25.6-uv.lock-8356d8"></a>`uv.lock`: the exact version of hadolint. 13 lines added. It comes from `uv add --group lint hadolint-bin`. [The file](https://github.com/rahuldave/babykev/blob/ce3646d2f0cdacf2177d9ba36355dd4ffc1b2f4a/uv.lock).

<details><summary>The diff that <code>uv add --group lint hadolint-bin</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -41,6 +41,7 @@ docs = [
     "smalldocs>=0.1.5",
 ]
 lint = [
+    "hadolint-bin>=2.15.1",
     "pre-commit>=4.7.0",
     "ruff>=0.17.1",
     "ty>=0.0.88",
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ce3646d2f0cdacf2177d9ba36355dd4ffc1b2f4a). [The code after it](https://github.com/rahuldave/babykev/tree/ce3646d2f0cdacf2177d9ba36355dd4ffc1b2f4a).

<a id="tut-25.7"></a>

### 25.7 lint-config runs hadolint

`just lint-config` checks the config files, and the `Dockerfile` is one of them. The command behind the new line comes
first.

Apply the patch to [`justfile`](#tut-25.7-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/fe092b54847ade1223f40297937fe59259096f68.diff | git apply --include=justfile
```

In the recipe `lint-config`, the patch adds `uv run hadolint Dockerfile` after yamllint, and names the `Dockerfile`
in the comment above the recipe.

```bash
uv run hadolint Dockerfile
just lint-config
```

hadolint prints `Dockerfile:44 DL3008 warning: Pin versions in apt get install.`, and ends with exit code 1.
`just lint-config` stops on the same line. Line 44 is the `apt-get install` of the dev image, which names no version
of git. This finding is real, and nothing was broken to make it.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check fe092b54847a
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source ce3646d2f0cd --staged -- :/ && git restore --source fe092b54847a --staged --worktree -- :/
```

#### What changed

- <a id="tut-25.7-justfile-424f0b"></a>`justfile`: hadolint, in `lint-config`. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/fe092b54847ade1223f40297937fe59259096f68/justfile).
  - look at `    uv run hadolint Dockerfile`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -78,7 +78,7 @@ fmt *args:
 lint *args:
     @{{ if args == "help" { "just help lint" } else { 'uv run ruff check "$@"' } }}
 
-# Check the config files: pyproject.toml, the lockfile, this justfile, and every YAML file
+# Check the config files: pyproject.toml, the lockfile, this justfile, every YAML file, and the Dockerfile
 [group('quality')]
 [no-exit-message]
 lint-config *args:
@@ -89,6 +89,7 @@ lint-config *args:
     uv lock --check
     just --fmt --check --unstable
     uv run yamllint --strict .
+    uv run hadolint Dockerfile
 
 # Check the types, by reading the code and not running it. Extra words go to ty: just types src
 [group('quality')]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/fe092b54847ade1223f40297937fe59259096f68). [The code after it](https://github.com/rahuldave/babykev/tree/fe092b54847ade1223f40297937fe59259096f68).

<a id="tut-25.8"></a>

### 25.8 DL3008, declined with its reason

DL3008 asks for the version of each package of Debian. Debian replaces a package at each fix of its security, and
the old version leaves the archive. So a pinned version stops building within weeks. The tag of the base image,
`python:3.13-slim-trixie`, fixes the release of Debian.

A comment says so, and a line tells hadolint to ignore DL3008 on the next instruction.

Apply the patch to [`Dockerfile`](#tut-25.8-Dockerfile-6651dd), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/fd4dc51723462cdeaf072a4f2a18472a0cf6a645.diff | git apply --include=Dockerfile
```

The patch adds four comment lines above the `RUN apt-get update` of the dev image.

```bash
just lint-config
```

`just lint-config` passes. hadolint prints nothing.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check fd4dc5172346
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source fe092b54847a --staged -- :/ && git restore --source fd4dc5172346 --staged --worktree -- :/
```

#### What changed

- <a id="tut-25.8-Dockerfile-6651dd"></a>`Dockerfile`: the reason, and the line for hadolint. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/fd4dc51723462cdeaf072a4f2a18472a0cf6a645/Dockerfile).
  - look at `# hadolint ignore=DL3008`

<details open><summary>The patch to <code>Dockerfile</code></summary>

```diff
@@ -41,6 +41,10 @@ CMD ["help"]
 # The dev image: the whole project with every group, and the tools to work on it
 FROM python:3.13-slim-trixie AS dev
 ARG JUST=1.50.0
+# hadolint asks for the version of each package of Debian (DL3008). Debian replaces a package at
+# each fix of its security, and the old version leaves the archive. So a pinned version stops
+# building within weeks. The tag of the base image is the pin
+# hadolint ignore=DL3008
 RUN apt-get update \
     && apt-get install --yes --no-install-recommends git \
     && rm -rf /var/lib/apt/lists/*
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/fd4dc51723462cdeaf072a4f2a18472a0cf6a645). [The code after it](https://github.com/rahuldave/babykev/tree/fd4dc51723462cdeaf072a4f2a18472a0cf6a645).

<a id="tut-25.9"></a>

### 25.9 The README names the two images

The README gets a section on the images, with a table and the commands of the recipe. The table of the files gets a
row for the `Dockerfile` and `.dockerignore`.

Apply the patch to [`README.md`](#tut-25.9-README.md-8ec9a0), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/6c85dd08f3cd441259b3749ac38cceaf7f2392e0.diff | git apply --include=README.md
```

The patch adds the section `The images` above `What is here`, and the row of the `Dockerfile` above the row of
`.python-version`.

The README says that every check passes in the dev image with no network. `--network none` gives the container no
network at all.

```bash
just image shell --network none -- just check
```

It fails before any check runs. uv cannot download hadolint-bin, with `dns error`. The dev image was built
before hadolint came into `uv.lock`, and `UV_LOCKED` makes uv install the packages of the lockfile first. An image
holds the packages of the lockfile at the time of its build.

```bash
just image build dev
just image shell --network none -- just check
```

`just check` passes in the new image, with no network. Every check of the gate is hermetic.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 6c85dd08f3cd
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source fd4dc5172346 --staged -- :/ && git restore --source tut-25 --staged --worktree -- :/
```

#### What changed

- <a id="tut-25.9-README.md-8ec9a0"></a>`README.md`: the section on the images, and the row of the `Dockerfile`. 24 lines added. [The file](https://github.com/rahuldave/babykev/blob/6c85dd08f3cd441259b3749ac38cceaf7f2392e0/README.md).
  - look at `## The images`

<details open><summary>The patch to <code>README.md</code></summary>

````diff
@@ -74,6 +74,29 @@ Run `just hook` once in each clone. It installs a git hook, which runs `just che
 `just check` runs every check of the project, and if one fails, git makes no commit. One check is a floor.
 The tests must run at least 90% of the code. You can run `just check` yourself at any time.
 
+## The images
+
+The `Dockerfile` builds two images from `uv.lock`, for any machine with Docker. Docker runs Linux, so
+an image runs the same on a Mac, on Linux and on Windows.
+
+| Image | Holds | Starts |
+|---|---|---|
+| dev | the whole project with every group, uv, just and git | a shell |
+| run | the program and the packages that it needs, with no tool of the developers | `babykev` |
+
+```
+just image build dev                          # docker build --target dev, named babykev-dev
+just image shell                              # a shell in the dev image, with this folder at /work
+just image shell --network none -- just check # every check, in the dev image, with no network
+just image build run
+just image run smoke                          # the smoke in the run image, on the CPU
+```
+
+The environment of an image is in `/opt/venv`, so the image never uses the `.venv` of a mounted folder.
+Both images mount the cache of the Hugging Face Hub of this machine at `/hf`, so the base model is
+downloaded once. An image holds the packages of the lockfile at the time of its build, so build it again
+after a change to `uv.lock`.
+
 ## What is here
 
 | Path | What it is |
@@ -92,6 +115,7 @@ The tests must run at least 90% of the code. You can run `just check` yourself a
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `README.md` | This file |
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
+| `Dockerfile`, `.dockerignore` | The two images, dev and run, and what a build never copies into them |
 | `.python-version` | The version of Python that the project uses |
 | `.gitignore` | The files that git does not track, for example `.venv` |
 | `.pre-commit-config.yaml` | The hooks that git runs before each commit, once `just hook` installs them. The last runs `just check` |
````

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/6c85dd08f3cd441259b3749ac38cceaf7f2392e0).

This part ends at the code at `tut-25`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-25)

<a id="tut-26"></a>

## 26 GitHub runs `just check`

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-25`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-25)

The hook runs `just check` only in a clone where `just hook` ran. A workflow of GitHub runs `just setup` and
`just check` after every push, on a fresh machine. actionlint checks the workflows, as a line of `just lint-config`.

```bash
just setup
```

`just setup` prints `Resolved 70 packages`.

The hook runs the gate before each `git commit`, on the machine where it runs. In a clone without the hook, git records
changes that never met the gate. Also, the docs site exists only on the machine that builds it.

GitHub runs workflows on its own machines. A workflow is a file of YAML in `.github/workflows/`, and its key `on` names
the events that start it. The first workflow runs the gate after every push, and the second builds the docs site and
publishes it on GitHub Pages. Nothing is pushed here. GitHub runs the workflows when the branch reaches it.

<a id="tut-26.1"></a>

### 26.1 GitHub runs the gate after every push

The workflow `check.yaml` has one job. It takes the code, installs uv and just, and runs `just setup` and `just
check`, as a student does. It runs after a push to any branch and on every pull request. `branches: ["**"]` leaves
out a push of a tag.

[GitHub Actions](https://docs.github.com/actions) runs commands on GitHub's machines. A workflow, a YAML file in `.github/workflows/`, says when it runs, such as after every push, and which commands its jobs run. Each run shows its log on the page of the repository.

Apply the patch to [`.github/workflows/check.yaml`](#tut-26.1-.github-workflows-check.yaml-6ceb50), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/2f210829183a3c52bb22f1196d50000716a4beec.diff | git apply --include=.github/workflows/check.yaml
```

The patch makes the file, in a new folder `.github/workflows`. Read the key `on`, then what the job runs.

```bash
just lint-config
```

yamllint reads every YAML file, and the new file too. It prints `5:1 warning truthy value should be one of [false,
true] (truthy)`. `just lint-config` ends with exit code 2, because `--strict` makes a warning fail. YAML 1.1 reads the
word `on` as true. GitHub reads it as the name `on`, and every workflow has it. The next move answers it.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 2f210829183a
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-25 --staged -- :/ && git restore --source 2f210829183a --staged --worktree -- :/
```

#### What changed

- <a id="tut-26.1-.github-workflows-check.yaml-6ceb50"></a>`.github/workflows/check.yaml`: `just check`, after every push. New, 21 lines. [The file](https://github.com/rahuldave/babykev/blob/2f210829183a3c52bb22f1196d50000716a4beec/.github/workflows/check.yaml).
  - look at `      - run: just check`

<details open><summary>The patch to <code>.github/workflows/check.yaml</code></summary>

```diff
@@ -0,0 +1,21 @@
+# The gate, on GitHub: just check, after every push to a branch and on every pull request. The hook
+# runs the same recipe before each commit, on the machine that makes it.
+name: Check
+
+on:
+  push:
+    branches: ["**"]  # every branch, and no tag
+  pull_request:
+
+permissions:
+  contents: read  # the job reads the code, and changes nothing on GitHub
+
+jobs:
+  check:
+    runs-on: ubuntu-latest
+    steps:
+      - uses: actions/checkout@v7
+      - uses: astral-sh/setup-uv@v10.2.0
+      - uses: extractions/setup-just@v4
+      - run: just setup
+      - run: just check
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/2f210829183a3c52bb22f1196d50000716a4beec). [The code after it](https://github.com/rahuldave/babykev/tree/2f210829183a3c52bb22f1196d50000716a4beec).

<a id="tut-26.2"></a>

### 26.2 yamllint lets a key be a word such as on

The rule `truthy` of yamllint has the option `check-keys`. With `false`, the rule checks the values and not the keys.
A value of `on` or `yes` is still a warning.

Apply the patch to [`.yamllint`](#tut-26.2-.yamllint-dfe50a), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/7b7e22f04247cefdd2d01adbe6dff64d88a6116c.diff | git apply --include=.yamllint
```

The patch adds the rule `truthy` at the end of `.yamllint`.

```bash
just lint-config
```

`just lint-config` passes.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 7b7e22f04247
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 2f210829183a --staged -- :/ && git restore --source 7b7e22f04247 --staged --worktree -- :/
```

#### What changed

- <a id="tut-26.2-.yamllint-dfe50a"></a>`.yamllint`: the rule `truthy` checks no key. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/7b7e22f04247cefdd2d01adbe6dff64d88a6116c/.yamllint).
  - look at `  truthy: {check-keys: false}  # a key may be a word such as on, which YAML 1.1 reads as true`

<details open><summary>The patch to <code>.yamllint</code></summary>

```diff
@@ -4,3 +4,4 @@ ignore-from-file: .gitignore  # the files that git ignores, such as everything i
 rules:
   document-start: disable  # a file need not start with a line of three dashes
   line-length: {max: 100}  # as long as a line of the Python code
+  truthy: {check-keys: false}  # a key may be a word such as on, which YAML 1.1 reads as true
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7b7e22f04247cefdd2d01adbe6dff64d88a6116c). [The code after it](https://github.com/rahuldave/babykev/tree/7b7e22f04247cefdd2d01adbe6dff64d88a6116c).

<a id="tut-26.3"></a>

### 26.3 actionlint, in the group lint

yamllint checks that a workflow is good YAML, and knows nothing of GitHub. actionlint is a linter for the workflows of
GitHub. It checks the events, the jobs, the actions and their inputs. The package `actionlint-py` holds its program,
built for each system.

[actionlint](https://github.com/rhysd/actionlint) checks the workflows of GitHub Actions. It finds a key that GitHub does not know, a wrong expression, and mistakes in the shell commands of each `run:` line.

```bash
uv add --group lint actionlint-py
```

`uv add` prints `Resolved 71 packages`, and installs actionlint-py.

```bash
uv run actionlint --version
```

The first line is the version of actionlint.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check bb15f17ccbb6
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 7b7e22f04247 --staged -- :/ && git restore --source bb15f17ccbb6 --staged --worktree -- :/
```

#### What changed

- <a id="tut-26.3-pyproject.toml-5d07e7"></a>`pyproject.toml`: actionlint, in the group `lint`. 1 line added. It comes from `uv add --group lint actionlint-py`. [The file](https://github.com/rahuldave/babykev/blob/bb15f17ccbb62cf1f8a61d67d67674bf9d445c86/pyproject.toml).
  - look at `"actionlint-py>=1.7.12.25",`
- <a id="tut-26.3-uv.lock-8356d8"></a>`uv.lock`: the exact version of actionlint. 8 lines added. It comes from `uv add --group lint actionlint-py`. [The file](https://github.com/rahuldave/babykev/blob/bb15f17ccbb62cf1f8a61d67d67674bf9d445c86/uv.lock).

<details><summary>The diff that <code>uv add --group lint actionlint-py</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -41,6 +41,7 @@ docs = [
     "smalldocs>=0.1.5",
 ]
 lint = [
+    "actionlint-py>=1.7.12.25",
     "hadolint-bin>=2.15.1",
     "pre-commit>=4.7.0",
     "ruff>=0.17.1",
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/bb15f17ccbb62cf1f8a61d67d67674bf9d445c86). [The code after it](https://github.com/rahuldave/babykev/tree/bb15f17ccbb62cf1f8a61d67d67674bf9d445c86).

<a id="tut-26.4"></a>

### 26.4 lint-config runs actionlint

actionlint finds the workflows of the project itself, in `.github/workflows/`. The command behind the new line comes
first.

Apply the patch to [`justfile`](#tut-26.4-justfile-424f0b), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/eb0acd148867bdbc6292660b7268b656074fb727.diff | git apply --include=justfile
```

In the recipe `lint-config`, the patch adds `uv run actionlint` after hadolint, and names the workflows in the comment
above the recipe.

```bash
uv run actionlint
just lint-config
```

actionlint prints nothing, and ends with exit code 0. It finds no problem in `check.yaml`. `just lint-config` passes.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check eb0acd148867
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source bb15f17ccbb6 --staged -- :/ && git restore --source eb0acd148867 --staged --worktree -- :/
```

#### What changed

- <a id="tut-26.4-justfile-424f0b"></a>`justfile`: actionlint, in `lint-config`. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/eb0acd148867bdbc6292660b7268b656074fb727/justfile).
  - look at `    uv run actionlint`

<details open><summary>The patch to <code>justfile</code></summary>

```diff
@@ -78,7 +78,7 @@ fmt *args:
 lint *args:
     @{{ if args == "help" { "just help lint" } else { 'uv run ruff check "$@"' } }}
 
-# Check the config files: pyproject.toml, the lockfile, this justfile, every YAML file, and the Dockerfile
+# Check the config files: pyproject.toml, the lockfile, this justfile, every YAML file, the Dockerfile and the workflows
 [group('quality')]
 [no-exit-message]
 lint-config *args:
@@ -90,6 +90,7 @@ lint-config *args:
     just --fmt --check --unstable
     uv run yamllint --strict .
     uv run hadolint Dockerfile
+    uv run actionlint
 
 # Check the types, by reading the code and not running it. Extra words go to ty: just types src
 [group('quality')]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/eb0acd148867bdbc6292660b7268b656074fb727). [The code after it](https://github.com/rahuldave/babykev/tree/eb0acd148867bdbc6292660b7268b656074fb727).

<a id="tut-26.5"></a>

### 26.5 GitHub Pages publishes the docs

The workflow `docs.yaml` has two jobs. The job `build` installs the package and the group `docs`, and no other group.
It runs `smalldocs render docs`, the command behind `just docs`, and gives the folder `docs/_site` to Pages. The job
`deploy` publishes it. The workflow runs after a push to `main`, and a person can also run it from the tab Actions.

Apply the patch to [`.github/workflows/docs.yaml`](#tut-26.5-.github-workflows-docs.yaml-ce7835), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/606da22657c965404206b25f8fbcccffbe3f2756.diff | git apply --include=.github/workflows/docs.yaml
```

The patch makes the file. Read the key `on`, the lines under `permissions`, and the line that renders the site.

```bash
uv run actionlint
uv run --isolated --locked --no-default-groups --group docs smalldocs render docs
```

actionlint prints nothing. `--no-default-groups --group docs` installs the package and the group `docs`, as the job
does. `--isolated` runs the command in a temporary environment, and leaves `.venv` as it is. It prints `wrote 7
page(s) to docs/_site`.

The workflows run only where two settings on GitHub allow them. A fork runs no workflow until its owner turns the
workflows on, on the tab **Actions**. Pages publishes from a workflow when **Settings**, then **Pages**, has the source
**GitHub Actions**. The README says so in the next move.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 606da22657c9
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source eb0acd148867 --staged -- :/ && git restore --source 606da22657c9 --staged --worktree -- :/
```

#### What changed

- <a id="tut-26.5-.github-workflows-docs.yaml-ce7835"></a>`.github/workflows/docs.yaml`: the docs site, built with the group `docs` alone, then published. New, 40 lines. [The file](https://github.com/rahuldave/babykev/blob/606da22657c965404206b25f8fbcccffbe3f2756/.github/workflows/docs.yaml).
  - look at `      - run: uv run --locked --no-default-groups --group docs smalldocs render docs`

<details open><summary>The patch to <code>.github/workflows/docs.yaml</code></summary>

```diff
@@ -0,0 +1,40 @@
+# The docs site, on GitHub Pages. After every push to main, smalldocs builds the site, and GitHub
+# Pages publishes it at https://OWNER.github.io/babykev/, with the name of the owner of the
+# repository. The job installs the package and the group docs, and no other group.
+name: Docs
+
+on:
+  push:
+    branches: [main]
+  workflow_dispatch:  # a person can also run it from the tab Actions
+
+permissions:
+  contents: read
+  pages: write     # to publish the site
+  id-token: write  # to show Pages that this workflow publishes it
+
+concurrency:
+  group: pages
+  cancel-in-progress: true  # a newer push replaces a publish that has not finished
+
+jobs:
+  build:
+    runs-on: ubuntu-latest
+    steps:
+      - uses: actions/checkout@v7
+      - uses: astral-sh/setup-uv@v10.2.0
+      - run: uv run --locked --no-default-groups --group docs smalldocs render docs
+      - uses: actions/configure-pages@v6
+      - uses: actions/upload-pages-artifact@v5
+        with:
+          path: docs/_site
+
+  deploy:
+    needs: build
+    runs-on: ubuntu-latest
+    environment:
+      name: github-pages
+      url: ${{ steps.deployment.outputs.page_url }}
+    steps:
+      - id: deployment
+        uses: actions/deploy-pages@v5
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/606da22657c965404206b25f8fbcccffbe3f2756). [The code after it](https://github.com/rahuldave/babykev/tree/606da22657c965404206b25f8fbcccffbe3f2756).

<a id="tut-26.6"></a>

### 26.6 The README names the workflows

The README gets a section on GitHub, with the two settings that a fork needs. The table gets a row for
`.github/workflows/`.

Apply the patch to [`README.md`](#tut-26.6-README.md-8ec9a0), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/88854e32ebcb4647672742cc4ef709eefc5fde0c.diff | git apply --include=README.md
```

The patch adds the section `On GitHub` above `What is here`, and the row of `.github/workflows/` above the row of
`.yamllint`.

```bash
just check
```

`just check` passes. The tests print `82 passed, 1 deselected`, and `Total coverage: 91.76%`. The last lines of
`lint-config` print nothing, because yamllint, hadolint and actionlint find nothing.

The workflow is the third caller of `just check`, after a person and the git hook. None of the three changed when
`check` changed, and each ran every new check. The workflow of the docs runs `smalldocs render docs` itself, and not
`just docs`. So a change to the recipe `docs` does not reach that workflow.

This tutorial ends here. The whole tutorial of babykev has every change.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 88854e32ebcb
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source 606da22657c9 --staged -- :/ && git restore --source tut-26 --staged --worktree -- :/
```

#### What changed

- <a id="tut-26.6-README.md-8ec9a0"></a>`README.md`: the section on GitHub, and the row of the workflows. 14 lines added. [The file](https://github.com/rahuldave/babykev/blob/88854e32ebcb4647672742cc4ef709eefc5fde0c/README.md).
  - look at `## On GitHub`

<details open><summary>The patch to <code>README.md</code></summary>

```diff
@@ -97,6 +97,19 @@ Both images mount the cache of the Hugging Face Hub of this machine at `/hf`, so
 downloaded once. An image holds the packages of the lockfile at the time of its build, so build it again
 after a change to `uv.lock`.
 
+## On GitHub
+
+Two workflows in `.github/workflows/` run on the machines of GitHub. `check.yaml` runs `just check`
+after every push to a branch and on every pull request. `docs.yaml` builds the docs site after every
+push to `main`, and GitHub Pages publishes it.
+
+A fork runs no workflow until its owner allows it. Make these two settings on the website of GitHub:
+
+1. Open the tab **Actions** of the fork, and turn the workflows on.
+2. Open **Settings**, then **Pages**. Under **Source**, choose **GitHub Actions**.
+
+The site is then at `https://OWNER.github.io/babykev/`, with the name of the account in place of OWNER.
+
 ## What is here
 
 | Path | What it is |
@@ -119,6 +132,7 @@ after a change to `uv.lock`.
 | `.python-version` | The version of Python that the project uses |
 | `.gitignore` | The files that git does not track, for example `.venv` |
 | `.pre-commit-config.yaml` | The hooks that git runs before each commit, once `just hook` installs them. The last runs `just check` |
+| `.github/workflows/` | The two workflows of GitHub: the gate after every push, and the docs site on GitHub Pages |
 | `.yamllint` | The settings of yamllint, which `just lint-config` runs on every YAML file |
 
 ## How the history is organised
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/88854e32ebcb4647672742cc4ef709eefc5fde0c).

This part ends at the code at `tut-26`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-26)
