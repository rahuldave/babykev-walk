<!-- Made by the walk skill's render.py from the facts of the walk. Do not edit it by hand: run just walk-update again. -->

# uv and the groups of dependencies of babykev

**Build it yourself.** Every command to run and every change to make by hand, to make the project yourself. [Read the tutorial](read.md) is the other way to read it.

Each part ends with a section called **What changed**. It lists every file that the part changes, with a link to the file, and then the whole diff of each file, folded. A lockfile and a binary file have a link alone. The text above it explains the change. What changed is what you check your files against.

In Build it yourself, a file that a command makes says which command. A diff that is open is a patch. Apply it with the command in the text, or make the same change in your editor.

We follow the dependencies of babykev, a small decision model. It reads a text and a set of questions about it,
and gives a probability for every answer.

uv installs Python and the packages of the project, and writes their exact versions into one lockfile, `uv.lock`.
The packages come in groups. babykev needs some of them to run. The tests and the checks need the others. This
tutorial takes these parts out of the whole tutorial of babykev, and ends with the two Docker images, which install
different groups.

We make the project in moves. A move is one small change, made by one patch or by one command. A command such as
`uv add` changes the files of the project itself, so its move needs no patch.

Some changes of the whole tutorial are not in this one. After such a gap, the next section says what those changes
did, and begins from the code that they left. It first runs `just setup`, which installs the packages of that code.

## Get the project

You build the project in a clone of your own, on a branch `mine` that starts where this walk starts. Run the commands of these pages in its top folder.

```bash
git clone https://github.com/rahuldave/babykev
cd babykev
git switch -c mine 70ac5b0a0a1d
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

<a id="tut-01.1-to-tut-01.2"></a>

## 1.1 to 1.2 The project, and its lockfile

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-00`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-00)

The folder has a README, a licence and `.gitignore`, and nothing that Python can build or run. `uv init` makes the
project, and `uv lock` writes its lockfile. There is no justfile yet, so these two sections run no `just`.

<a id="tut-01.1"></a>

### 1.1 uv makes the project

The folder has words and a licence, but nothing that Python can build or run. `uv init` makes the files of a Python
project. `--package` makes a package in `src/babykev/`, with a command that runs its function `main`.
`--name babykev` names the project, and `--python 3.13` sets the version of Python.

```bash
uv init --package --name babykev --python 3.13
```

`uv init` leaves the README alone, because the project has one.

```bash
cat pyproject.toml
```

`[project.scripts]` makes a command, `babykev`, and names the function that it runs, `main` of the package
`babykev`. `[build-system]` names `uv_build`, the tool that builds the package. `dependencies` is an empty list.

`uv init` also writes your version of uv into the line `requires` of `[build-system]`. So your `pyproject.toml` can
differ there. The check compares `pyproject.toml` by the names of its packages, without the versions, so your files
still match.

```bash
git status --short
```

`git status --short` lists `.python-version`, `pyproject.toml` and `src/` with `??`, because git does not track them
yet.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check eac75e0becc7
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-00 --staged -- :/ && git restore --source eac75e0becc7 --staged --worktree -- :/
```

#### What changed

- <a id="tut-01.1-.python-version-7696e9"></a>`.python-version`: `3.13`, the version of Python that uv installs for the project. New, 1 line. It comes from `uv init --package --name babykev --python 3.13`. [The file](https://github.com/rahuldave/babykev/blob/eac75e0becc78c9a872e734ea715ac3903947844/.python-version).
- <a id="tut-01.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: `[project.scripts]` makes a command `babykev` that runs `main` of the package `babykev`. `[build-system]` names `uv_build`, the tool that builds the package. New, 14 lines. It comes from `uv init --package --name babykev --python 3.13`. [The file](https://github.com/rahuldave/babykev/blob/eac75e0becc78c9a872e734ea715ac3903947844/pyproject.toml).
  - look at `babykev = "babykev:main"`
- <a id="tut-01.1-src-babykev-__init__.py-a40393"></a>`src/babykev/__init__.py`: the function that the command runs. It prints a greeting. New, 2 lines. It comes from `uv init --package --name babykev --python 3.13`. [The file](https://github.com/rahuldave/babykev/blob/eac75e0becc78c9a872e734ea715ac3903947844/src/babykev/__init__.py).
  - look at `print("Hello from babykev!")`

<details><summary>The diff that <code>uv init --package --name babykev --python 3.13</code> makes in <code>.python-version</code></summary>

```diff
@@ -0,0 +1 @@
+3.13
```

</details>

<details><summary>The diff that <code>uv init --package --name babykev --python 3.13</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -0,0 +1,14 @@
+[project]
+name = "babykev"
+version = "0.1.0"
+description = "Add your description here"
+readme = "README.md"
+requires-python = ">=3.13"
+dependencies = []
+
+[project.scripts]
+babykev = "babykev:main"
+
+[build-system]
+requires = ["uv_build>=0.12.13,<0.13.0"]
+build-backend = "uv_build"
```

</details>

<details><summary>The diff that <code>uv init --package --name babykev --python 3.13</code> makes in <code>src/babykev/__init__.py</code></summary>

```diff
@@ -0,0 +1,2 @@
+def main() -> None:
+    print("Hello from babykev!")
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/eac75e0becc78c9a872e734ea715ac3903947844). [The code after it](https://github.com/rahuldave/babykev/tree/eac75e0becc78c9a872e734ea715ac3903947844).

<a id="tut-01.2"></a>

### 1.2 uv lock writes the lockfile

Two machines can install different versions of the same package, and the project then behaves differently on each.
`uv lock` writes `uv.lock`, the exact versions of every package that the project needs. The project needs no package
yet, so `uv.lock` lists babykev alone. `uv lock` prints the Python that it found, and `Resolved 1 package`.

```bash
uv lock
```

```bash
uv run babykev
```

`uv run` makes `.venv`, the environment of the project. It builds babykev, installs it into `.venv`, and runs the
command. It prints `Using CPython 3.13.3`, `Creating virtual environment at: .venv`, `Building babykev`,
`Built babykev` and `Installed 1 package`. Then comes the greeting, `Hello from babykev!`.

The version of Python on your machine can differ. If you ran a later part before, `.venv` is there already. `uv run`
then changes the packages of `.venv` to match, and does not print `Creating virtual environment`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 489f27fad816
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source eac75e0becc7 --staged -- :/ && git restore --source 489f27fad816 --staged --worktree -- :/
```

#### What changed

- <a id="tut-01.2-uv.lock-8356d8"></a>`uv.lock`: babykev itself, installed from this folder. `editable` means that a change to the code shows at the next run, with no new install. New, 8 lines. It comes from `uv lock`. [The file](https://github.com/rahuldave/babykev/blob/489f27fad816149652a8d608b162fa98c37563f5/uv.lock).
  - look at `source = { editable = "." }`

[This change on GitHub](https://github.com/rahuldave/babykev/commit/489f27fad816149652a8d608b162fa98c37563f5).

This part ends at the code at `489f27fad816`, partway through `tut-01`. [The code after this part](https://github.com/rahuldave/babykev/tree/489f27fad816149652a8d608b162fa98c37563f5)

<a id="tut-01.3-to-tut-01.5"></a>

## 1.3 to 1.5 The settings of the project

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `489f27fad816`, partway through `tut-01`. [The code before this part](https://github.com/rahuldave/babykev/tree/489f27fad816149652a8d608b162fa98c37563f5)

`pyproject.toml` still has the words of uv. Three settings say what babykev is, under which licence others may use
it, and who wrote it. None of them is a dependency, so the lockfile stays as it was.

<a id="tut-01.3"></a>

### 1.3 The description of babykev

`pyproject.toml` still has the words of uv. Its description is a placeholder, `Add your description here`. The patch
puts in what babykev is.

Set the values that this change sets in [`pyproject.toml`](#tut-01.3-pyproject.toml-5d07e7). Run this command from the top of the project. It reads your file with tomlkit, a library for TOML files. It copies each of these tables and values from the project's file after this change, with their comments, and keeps the rest of your file:

```bash
uv run --quiet --no-config --no-project --with tomlkit python - <<'PY'
import copy, pathlib, subprocess, tomlkit
from tomlkit.items import Comment, Table, Whitespace
path = pathlib.Path('pyproject.toml')
doc = tomlkit.parse(path.read_text(encoding='utf-8')) if path.exists() else tomlkit.document()
# The project's file after this change, from your clone
project = tomlkit.parse(subprocess.run(['git', 'show', '0497c0dc9d37:pyproject.toml'], capture_output=True, text=True,
                                        check=True).stdout)
# Each table and value that the change sets, by its keys: each comes from the project's file with its comments
COPY = [
    ('project', 'description'),
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

The patch changes one line of `pyproject.toml`, the line `description`.

```bash
grep -n description pyproject.toml
```

`grep` prints the new description, with its line number.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 0497c0dc9d37
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 489f27fad816 --staged -- :/ && git restore --source 0497c0dc9d37 --staged --worktree -- :/
```

#### What changed

- <a id="tut-01.3-pyproject.toml-5d07e7"></a>`pyproject.toml`: the description. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/0497c0dc9d3772df47e79361aa4165e5de8e227d/pyproject.toml).
  - look at `description = "A small decision model: one state, typed questions, a probability for every answer"`

<details open><summary>The patch to <code>pyproject.toml</code></summary>

```diff
@@ -1,7 +1,7 @@
 [project]
 name = "babykev"
 version = "0.1.0"
-description = "Add your description here"
+description = "A small decision model: one state, typed questions, a probability for every answer"
 readme = "README.md"
 requires-python = ">=3.13"
 dependencies = []
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0497c0dc9d3772df47e79361aa4165e5de8e227d). [The code after it](https://github.com/rahuldave/babykev/tree/0497c0dc9d3772df47e79361aa4165e5de8e227d).

<a id="tut-01.4"></a>

### 1.4 The licence of babykev

A package says under which licence others may use it. babykev's licence is kev's, the Apache License 2.0.
`license` names it, and `license-files` names the two files that a package of babykev carries with it.

Set the values that this change sets in [`pyproject.toml`](#tut-01.4-pyproject.toml-5d07e7). Run this command from the top of the project. It reads your file with tomlkit, a library for TOML files. It copies each of these tables and values from the project's file after this change, with their comments, and keeps the rest of your file:

```bash
uv run --quiet --no-config --no-project --with tomlkit python - <<'PY'
import copy, pathlib, subprocess, tomlkit
from tomlkit.items import Comment, Table, Whitespace
path = pathlib.Path('pyproject.toml')
doc = tomlkit.parse(path.read_text(encoding='utf-8')) if path.exists() else tomlkit.document()
# The project's file after this change, from your clone
project = tomlkit.parse(subprocess.run(['git', 'show', '414874463b88:pyproject.toml'], capture_output=True, text=True,
                                        check=True).stdout)
# Each table and value that the change sets, by its keys: each comes from the project's file with its comments
COPY = [
    ('project', 'license'),
    ('project', 'license-files'),
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

The patch adds the lines `license` and `license-files` to the table `[project]`.

```bash
grep -n license pyproject.toml
```

`grep` prints the two lines, with their numbers. The Build it yourself page sets them with a command, which can put
them at the end of `[project]`, so the numbers can differ.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 414874463b88
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 0497c0dc9d37 --staged -- :/ && git restore --source 414874463b88 --staged --worktree -- :/
```

#### What changed

- <a id="tut-01.4-pyproject.toml-5d07e7"></a>`pyproject.toml`: the licence, and the files a package carries. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/414874463b887dedf65c5c74caeac8a064b0e876/pyproject.toml).
  - look at `license-files = ["LICENSE", "NOTICE"]`

<details open><summary>The patch to <code>pyproject.toml</code></summary>

```diff
@@ -3,6 +3,8 @@ name = "babykev"
 version = "0.1.0"
 description = "A small decision model: one state, typed questions, a probability for every answer"
 readme = "README.md"
+license = "Apache-2.0"
+license-files = ["LICENSE", "NOTICE"]
 requires-python = ">=3.13"
 dependencies = []
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/414874463b887dedf65c5c74caeac8a064b0e876). [The code after it](https://github.com/rahuldave/babykev/tree/414874463b887dedf65c5c74caeac8a064b0e876).

<a id="tut-01.5"></a>

### 1.5 The author of babykev

A package names who wrote it. `authors` names Rahul Dave.

Set the values that this change sets in [`pyproject.toml`](#tut-01.5-pyproject.toml-5d07e7). Run this command from the top of the project. It reads your file with tomlkit, a library for TOML files. It copies each of these tables and values from the project's file after this change, with their comments, and keeps the rest of your file:

```bash
uv run --quiet --no-config --no-project --with tomlkit python - <<'PY'
import copy, pathlib, subprocess, tomlkit
from tomlkit.items import Comment, Table, Whitespace
path = pathlib.Path('pyproject.toml')
doc = tomlkit.parse(path.read_text(encoding='utf-8')) if path.exists() else tomlkit.document()
# The project's file after this change, from your clone
project = tomlkit.parse(subprocess.run(['git', 'show', '7f38877e597f:pyproject.toml'], capture_output=True, text=True,
                                        check=True).stdout)
# Each table and value that the change sets, by its keys: each comes from the project's file with its comments
COPY = [
    ('project', 'authors'),
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

The patch adds the line `authors` to the table `[project]`.

```bash
uv lock --check
```

`uv lock --check` says whether `uv.lock` still matches `pyproject.toml`. It prints `Resolved 1 package`, and ends with
exit code 0. The words of the three moves change no dependency, so `uv.lock` stays as it was.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 7f38877e597f
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 414874463b88 --staged -- :/ && git restore --source 7f38877e597f --staged --worktree -- :/
```

#### What changed

- <a id="tut-01.5-pyproject.toml-5d07e7"></a>`pyproject.toml`: the author. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/7f38877e597f5404208fdca2eabb176077d95a8e/pyproject.toml).
  - look at `authors = [{ name = "Rahul Dave" }]`

<details open><summary>The patch to <code>pyproject.toml</code></summary>

```diff
@@ -5,6 +5,7 @@ description = "A small decision model: one state, typed questions, a probability
 readme = "README.md"
 license = "Apache-2.0"
 license-files = ["LICENSE", "NOTICE"]
+authors = [{ name = "Rahul Dave" }]
 requires-python = ">=3.13"
 dependencies = []
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7f38877e597f5404208fdca2eabb176077d95a8e).

This part ends at the code at `7f38877e597f`, partway through `tut-01`. [The code after this part](https://github.com/rahuldave/babykev/tree/7f38877e597f5404208fdca2eabb176077d95a8e)

<a id="tut-02.1-to-tut-02.3"></a>

## 2.1 to 2.3 Every group, and the group test

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-01`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-01)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source 7f38877e597f --staged -- :/ && git restore --source tut-01 --staged --worktree -- :/
```

```bash
just setup
```

The whole tutorial then writes the command `babykev`, in `src/babykev/cli.py`, and a justfile with the recipe
`setup`. `just setup` runs `uv sync --locked`. The tests of the command need pytest, and a user of babykev does not.
So pytest goes into a dependency group, `test`, and a recipe runs it.

<a id="tut-02.1"></a>

### 2.1 uv installs every dependency group

The tests need pytest, and a package of babykev does not. A person who installs babykev should not get pytest. So the
tools of the project go in dependency groups. A dependency group is a list of packages in `pyproject.toml` that the
project needs while we work on it. A user of the package never gets them. The test tools go in a group `test`, and
later the linters and the docs tools get groups of their own.

uv installs only the group `dev` by default. The setting `default-groups = "all"` makes `uv sync` and `uv run`
install every group. So each later `uv add --group` needs no other change to `pyproject.toml`. A patch adds the
table `[tool.uv]` with this setting.

Set the values that this change sets in [`pyproject.toml`](#tut-02.1-pyproject.toml-5d07e7). Run this command from the top of the project. It reads your file with tomlkit, a library for TOML files. It copies each of these tables and values from the project's file after this change, with their comments, and keeps the rest of your file:

```bash
uv run --quiet --no-config --no-project --with tomlkit python - <<'PY'
import copy, pathlib, subprocess, tomlkit
from tomlkit.items import Comment, Table, Whitespace
path = pathlib.Path('pyproject.toml')
doc = tomlkit.parse(path.read_text(encoding='utf-8')) if path.exists() else tomlkit.document()
# The project's file after this change, from your clone
project = tomlkit.parse(subprocess.run(['git', 'show', 'ad616a5cc1fc:pyproject.toml'], capture_output=True, text=True,
                                        check=True).stdout)
# Each table and value that the change sets, by its keys: each comes from the project's file with its comments
COPY = [
    ('tool', 'uv'),
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

The patch adds the table `[tool.uv]` at the end of `pyproject.toml`, after the table `[build-system]`. It has a
comment and one setting.

The setting changes which groups uv installs, and not which versions. So `uv.lock` still matches `pyproject.toml`.

```bash
uv lock --check
```

uv prints `Resolved 1 package`, and no error. The project has no groups yet, so the setting changes nothing until a
later move adds one.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check ad616a5cc1fc
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-01 --staged -- :/ && git restore --source ad616a5cc1fc --staged --worktree -- :/
```

#### What changed

- <a id="tut-02.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the table `[tool.uv]`, so uv installs every dependency group. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/ad616a5cc1fcdf5b7c1672b79d0d2b267b72bd59/pyproject.toml).
  - look at `default-groups = "all"`

<details open><summary>The patch to <code>pyproject.toml</code></summary>

```diff
@@ -15,3 +15,7 @@ babykev = "babykev.cli:main"
 [build-system]
 requires = ["uv_build>=0.12.13,<0.13.0"]
 build-backend = "uv_build"
+
+[tool.uv]
+# uv sync and uv run install every dependency group, not only dev
+default-groups = "all"
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ad616a5cc1fcdf5b7c1672b79d0d2b267b72bd59). [The code after it](https://github.com/rahuldave/babykev/tree/ad616a5cc1fcdf5b7c1672b79d0d2b267b72bd59).

<a id="tut-02.2"></a>

### 2.2 Pytest, in the group test

Nothing runs tests yet. pytest finds the tests and runs them. It goes into the group `test`.

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

<a id="tut-03.1"></a>

## 3.1 The first dependency, pydantic

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-02`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-02)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source b0840709e371 --staged -- :/ && git restore --source tut-02 --staged --worktree -- :/
```

```bash
just setup
```

The whole tutorial then adds five tests of the command. pytest-cov, which measures which
lines the tests run, joins pytest in the group `test`. babykev itself needs pydantic to run, so it goes into the
dependencies of the project, and into no group.

### 3.1 Pydantic, the first dependency

The contract is written with pydantic, and babykev does not have it yet. pydantic checks that data has the shape that
a class describes. `uv add` writes the package into `dependencies`, because a package of babykev needs it to run.

```bash
uv add pydantic
```

`uv add pydantic` prints `Resolved 14 packages`, and lists what it installed. It installed pydantic and the four
packages that pydantic needs, `annotated-types`, `pydantic-core`, `typing-extensions` and `typing-inspection`.

If a newer pydantic is out, `uv add` writes its version as the lower bound. Only the versions differ from the ones
here.

```bash
uv tree --depth 1
```

`uv tree` prints the dependencies as a tree. `--depth 1` keeps the packages that babykev names itself. It prints
pydantic and its version, and the group `test` with pytest and pytest-cov.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 96502df0a92f
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-02 --staged -- :/ && git restore --source 96502df0a92f --staged --worktree -- :/
```

#### What changed

- <a id="tut-03.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the first dependency. `>=2.14.1` is the version that `uv add` found, as the lowest version to accept. 3 lines added, 1 removed. It comes from `uv add pydantic`. [The file](https://github.com/rahuldave/babykev/blob/96502df0a92f6f7090d6f624cda901a271dac9a7/pyproject.toml).
  - look at `"pydantic>=2.14.1",`
- <a id="tut-03.1-uv.lock-8356d8"></a>`uv.lock`: pydantic and the four packages it needs, each with its exact version. 136 lines added. It comes from `uv add pydantic`. [The file](https://github.com/rahuldave/babykev/blob/96502df0a92f6f7090d6f624cda901a271dac9a7/uv.lock).

<details><summary>The diff that <code>uv add pydantic</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -7,7 +7,9 @@ license = "Apache-2.0"
 license-files = ["LICENSE", "NOTICE"]
 authors = [{ name = "Rahul Dave" }]
 requires-python = ">=3.13"
-dependencies = []
+dependencies = [
+    "pydantic>=2.14.1",
+]
 
 [project.scripts]
 babykev = "babykev.cli:main"
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/96502df0a92f6f7090d6f624cda901a271dac9a7).

This part ends at the code at `96502df0a92f`, partway through `tut-03`. [The code after this part](https://github.com/rahuldave/babykev/tree/96502df0a92f6f7090d6f624cda901a271dac9a7)

<a id="tut-07.1"></a>

## 7.1 A second group, for the checks

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-06`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-06)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source 96502df0a92f --staged -- :/ && git restore --source tut-06 --staged --worktree -- :/
```

```bash
just setup
```

The whole tutorial then brings in the contract, `api.py`, which says what a request and an answer are. Then come its
tests, the code that turns the probabilities of the model into answers, and the fixes of two bugs in it. ruff
formats the code and checks it, and a user of babykev does not need it. So ruff starts a second group, `lint`.

### 7.1 Ruff, in the group lint

Nothing formats the code yet. ruff is a formatter and a linter in one program. The formatter changes how the code
looks, and never what it does. The linter comes in the next part of the tutorial. ruff is for working on babykev,
and a user of the package does not need it. So it goes in a second dependency group, `lint`, next to the group
`test`.

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5085d2a6ae47a58d6259dfa06679bb2a9be692e1).

This part ends at the code at `5085d2a6ae47`, partway through `tut-07`. [The code after this part](https://github.com/rahuldave/babykev/tree/5085d2a6ae47a58d6259dfa06679bb2a9be692e1)

<a id="tut-15.1-to-tut-15.7"></a>

## 15.1 to 15.7 The packages of the model

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-14`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-14)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source 5085d2a6ae47 --staged -- :/ && git restore --source tut-14 --staged --worktree -- :/
```

```bash
just setup
```

The whole tutorial then sets up ruff, fixes the code with it, and adds types and docstrings. pre-commit,
validate-pyproject and yamllint, more tools for the checks, join the group `lint`. smalldocs, which builds the site
of the docs, starts a third group, `docs`. `default-groups = "all"` makes `just setup` install each of them, with no
other change.

The model needs four packages, and they are dependencies of the project. torch comes first, from an index of its
own.

<a id="tut-15.1"></a>

### 15.1 The index of PyTorch's builds for the CPU

torch has several builds of each version. On Linux, the build on PyPI brings the libraries of CUDA, for the GPUs of
NVIDIA. PyTorch keeps a build for the CPU alone on an index of its own, `https://download.pytorch.org/whl/cpu`. An
index is a server of packages, as PyPI is. The patch names the index in `pyproject.toml`.

Set the values that this change sets in [`pyproject.toml`](#tut-15.1-pyproject.toml-5d07e7). Run this command from the top of the project. It reads your file with tomlkit, a library for TOML files. It copies each of these tables and values from the project's file after this change, with their comments, and keeps the rest of your file:

```bash
uv run --quiet --no-config --no-project --with tomlkit python - <<'PY'
import copy, pathlib, subprocess, tomlkit
from tomlkit.items import Comment, Table, Whitespace
path = pathlib.Path('pyproject.toml')
doc = tomlkit.parse(path.read_text(encoding='utf-8')) if path.exists() else tomlkit.document()
# The project's file after this change, from your clone
project = tomlkit.parse(subprocess.run(['git', 'show', 'b44da7cc2f35:pyproject.toml'], capture_output=True, text=True,
                                        check=True).stdout)
# Each table and value that the change sets, by its keys: each comes from the project's file with its comments
COPY = [
    ('tool', 'uv', 'index'),
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

The patch adds the table `[[tool.uv.index]]` under `[tool.uv]`, with a comment above it.

`explicit = true` means that uv takes from the index only the packages that `[tool.uv.sources]` sends there. That
table does not exist yet.

```bash
uv lock --check
```

`uv lock --check` prints `Resolved 34 packages`, and ends with exit code 0. No package uses the index yet, so the
lockfile does not change.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check b44da7cc2f35
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-14 --staged -- :/ && git restore --source b44da7cc2f35 --staged --worktree -- :/
```

#### What changed

- <a id="tut-15.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the index of PyTorch. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/b44da7cc2f35c24f23c9f056eb9ec6681a3111e0/pyproject.toml).
  - look at `url = "https://download.pytorch.org/whl/cpu"`

<details open><summary>The patch to <code>pyproject.toml</code></summary>

```diff
@@ -22,6 +22,13 @@ build-backend = "uv_build"
 # uv sync and uv run install every dependency group, not only dev
 default-groups = "all"
 
+# torch comes in several builds, and this project installs the build for the CPU, from the index
+# of PyTorch. explicit = true: uv takes from it only what [tool.uv.sources] sends there
+[[tool.uv.index]]
+name = "pytorch-cpu"
+url = "https://download.pytorch.org/whl/cpu"
+explicit = true
+
 [dependency-groups]
 docs = [
     "smalldocs>=0.1.5",
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b44da7cc2f35c24f23c9f056eb9ec6681a3111e0). [The code after it](https://github.com/rahuldave/babykev/tree/b44da7cc2f35c24f23c9f056eb9ec6681a3111e0).

<a id="tut-15.2"></a>

### 15.2 torch, from the index of PyTorch

`uv add torch --index pytorch-cpu` names the index for torch, and uv writes the source of torch in
`[tool.uv.sources]` itself. `uv add` then resolves, and for that one run `--index` puts the index of PyTorch first,
for every package. It would take other packages from there, older than on PyPI. `--frozen` writes `pyproject.toml`
and leaves `uv.lock` alone, so uv resolves nothing yet.

```bash
uv add torch --index pytorch-cpu --frozen
```

`uv add` prints one warning, `Referencing an index by name is experimental`, and ends with exit code 0. It installs
nothing.

```bash
uv lock --check
```

`uv lock --check` prints `Resolved 43 packages`, then `The lockfile at uv.lock needs to be updated`, and ends with
exit code 1. `pyproject.toml` names torch, and `uv.lock` does not have it. `just lint-config` runs the same command, so
`just check` fails too. The next move writes the lockfile.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check a263314ef270
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source b44da7cc2f35 --staged -- :/ && git restore --source a263314ef270 --staged --worktree -- :/
```

#### What changed

- <a id="tut-15.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: torch, in the dependencies, and its source. 4 lines added. It comes from `uv add torch --index pytorch-cpu --frozen`. [The file](https://github.com/rahuldave/babykev/blob/a263314ef270d756122972876e80270ed4cde130/pyproject.toml).
  - look at `torch = { index = "pytorch-cpu" }`

<details><summary>The diff that <code>uv add torch --index pytorch-cpu --frozen</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -9,6 +9,7 @@ authors = [{ name = "Rahul Dave" }]
 requires-python = ">=3.13"
 dependencies = [
     "pydantic>=2.14.1",
+    "torch",
 ]
 
 [project.scripts]
@@ -29,6 +30,9 @@ name = "pytorch-cpu"
 url = "https://download.pytorch.org/whl/cpu"
 explicit = true
 
+[tool.uv.sources]
+torch = { index = "pytorch-cpu" }
+
 [dependency-groups]
 docs = [
     "smalldocs>=0.1.5",
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a263314ef270d756122972876e80270ed4cde130). [The code after it](https://github.com/rahuldave/babykev/tree/a263314ef270d756122972876e80270ed4cde130).

<a id="tut-15.3"></a>

### 15.3 uv lock takes torch from its index

`uv lock` resolves with no `--index` on the command line. The source sends torch to the index of PyTorch, and
`explicit = true` keeps every other package on PyPI.

```bash
uv lock
```

`uv lock` prints `Resolved 43 packages`, and eight lines `Added`. The line of torch,
`Added torch`, names two versions, one of them with `+cpu`. They are two
builds of torch. The seven packages that it needs, among them `sympy` and `networkx`, are the other seven. `uv lock` writes
`uv.lock` and installs nothing.

```bash
uv lock --check
grep -n -A5 '^name = "torch"' uv.lock
grep -B2 'registry = "https://download.pytorch.org/whl/cpu" }$' uv.lock | grep '^name'
```

`uv lock --check` prints `Resolved 43 packages`, and ends with exit code 0. The first `grep` prints the two entries
of torch, on lines 701 and 725. Both come from `https://download.pytorch.org/whl/cpu`. The first is for
`sys_platform == 'darwin'`, a Mac. The second, whose version ends in `+cpu`, is for every other system. The
second `grep` prints the name of every package from the index of PyTorch, and it prints `name = "torch"` twice and
nothing more.

```bash
uv run python -c "import torch; print(torch.__version__, torch.backends.mps.is_available())"
```

`uv run` first installs what `uv.lock` now has, 9 packages. torch then prints a warning, `UserWarning: Failed to
initialize NumPy: No module named 'numpy'`. torch works without numpy, and says so. The last line is
the version of torch and `True`. `True` means that torch finds MPS, the GPU of Apple, so on a Mac the build for the CPU runs on the GPU
too.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 92e81476ed9c
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source a263314ef270 --staged -- :/ && git restore --source 92e81476ed9c --staged --worktree -- :/
```

#### What changed

- <a id="tut-15.3-uv.lock-8356d8"></a>`uv.lock`: torch, from the index of PyTorch, and the seven packages that it needs, from PyPI. 230 lines added, 1 removed. It comes from `uv lock`. [The file](https://github.com/rahuldave/babykev/blob/92e81476ed9ccd19ab2da210dfacb5886dac1712/uv.lock).

[This change on GitHub](https://github.com/rahuldave/babykev/commit/92e81476ed9ccd19ab2da210dfacb5886dac1712). [The code after it](https://github.com/rahuldave/babykev/tree/92e81476ed9ccd19ab2da210dfacb5886dac1712).

<a id="tut-15.4"></a>

### 15.4 transformers

The base model of kev, and its tokenizer, are on the Hugging Face Hub. transformers loads them.

```bash
uv add transformers
```

`uv add` prints `Resolved 63 packages`, and installs transformers and 18 packages that it needs, among
them `huggingface-hub`, `tokenizers`, `numpy` and `safetensors`.

```bash
uv run python -c "import torch, transformers; print(transformers.__version__)"
```

It prints the version of transformers, and no warning. numpy came with transformers, so torch no longer warns.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 92f659c4e742
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 92e81476ed9c --staged -- :/ && git restore --source 92f659c4e742 --staged --worktree -- :/
```

#### What changed

- <a id="tut-15.4-pyproject.toml-5d07e7"></a>`pyproject.toml`: transformers, in the dependencies. 1 line added. It comes from `uv add transformers`. [The file](https://github.com/rahuldave/babykev/blob/92f659c4e74206cfb776c114d474c2be2501be81/pyproject.toml).
  - look at `"transformers>=5.20.0",`
- <a id="tut-15.4-uv.lock-8356d8"></a>`uv.lock`: the exact version of transformers, and of the packages that it needs. 419 lines added. It comes from `uv add transformers`. [The file](https://github.com/rahuldave/babykev/blob/92f659c4e74206cfb776c114d474c2be2501be81/uv.lock).

<details><summary>The diff that <code>uv add transformers</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -10,6 +10,7 @@ requires-python = ">=3.13"
 dependencies = [
     "pydantic>=2.14.1",
     "torch",
+    "transformers>=5.20.0",
 ]
 
 [project.scripts]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/92f659c4e74206cfb776c114d474c2be2501be81). [The code after it](https://github.com/rahuldave/babykev/tree/92f659c4e74206cfb776c114d474c2be2501be81).

<a id="tut-15.5"></a>

### 15.5 peft

The base model stays as it is, and a small adapter, LoRA, learns the task. peft adds the adapter.

```bash
uv add peft
```

`uv add` prints `Resolved 66 packages`, and installs peft, `accelerate` and `psutil`.

```bash
uv tree --invert --package torch --depth 1
```

`uv tree --invert` prints the packages that need torch, in place of the packages that torch needs. The first line is
`Resolved 66 packages`. Under torch come `accelerate`, `babykev` and `peft`. peft needs torch, and
torch was already here, from the index of PyTorch.

Had peft come first, uv would have taken torch from PyPI, with the libraries of CUDA for Linux. So torch comes first,
from its index.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 4b43f5a9f99a
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 92f659c4e742 --staged -- :/ && git restore --source 4b43f5a9f99a --staged --worktree -- :/
```

#### What changed

- <a id="tut-15.5-pyproject.toml-5d07e7"></a>`pyproject.toml`: peft, in the dependencies. 1 line added. It comes from `uv add peft`. [The file](https://github.com/rahuldave/babykev/blob/4b43f5a9f99a891891ac42cb03e3927957e9116c/pyproject.toml).
  - look at `"peft>=0.21.2",`
- <a id="tut-15.5-uv.lock-8356d8"></a>`uv.lock`: the exact version of peft, and of the packages that it needs. 71 lines added. It comes from `uv add peft`. [The file](https://github.com/rahuldave/babykev/blob/4b43f5a9f99a891891ac42cb03e3927957e9116c/uv.lock).

<details><summary>The diff that <code>uv add peft</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -8,6 +8,7 @@ license-files = ["LICENSE", "NOTICE"]
 authors = [{ name = "Rahul Dave" }]
 requires-python = ">=3.13"
 dependencies = [
+    "peft>=0.21.2",
     "pydantic>=2.14.1",
     "torch",
     "transformers>=5.20.0",
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4b43f5a9f99a891891ac42cb03e3927957e9116c). [The code after it](https://github.com/rahuldave/babykev/tree/4b43f5a9f99a891891ac42cb03e3927957e9116c).

<a id="tut-15.6"></a>

### 15.6 safetensors

safetensors is the format of the weights on the Hub. transformers installed it already. babykev names it too,
because babykev saves the weights that it trains to the Hub in this format. A package that only comes with another
can go when that package stops needing it.

```bash
uv add safetensors
```

`uv add` prints `Resolved 66 packages`, the same count as before, and installs no new package. It installs babykev
again, with its new list of dependencies.

```bash
uv tree --invert --package safetensors --depth 1
```

Under safetensors come `accelerate`, `babykev`, `peft` and `transformers`. Before the move, the list had
no `babykev`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 8176ced71579
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 4b43f5a9f99a --staged -- :/ && git restore --source 8176ced71579 --staged --worktree -- :/
```

#### What changed

- <a id="tut-15.6-pyproject.toml-5d07e7"></a>`pyproject.toml`: safetensors, in the dependencies. 1 line added. It comes from `uv add safetensors`. [The file](https://github.com/rahuldave/babykev/blob/8176ced7157929f551e3722149016dbc31d42601/pyproject.toml).
  - look at `"safetensors>=0.8.0",`
- <a id="tut-15.6-uv.lock-8356d8"></a>`uv.lock`: safetensors, as a dependency of babykev. 2 lines added. It comes from `uv add safetensors`. [The file](https://github.com/rahuldave/babykev/blob/8176ced7157929f551e3722149016dbc31d42601/uv.lock).

<details><summary>The diff that <code>uv add safetensors</code> makes in <code>pyproject.toml</code></summary>

```diff
@@ -10,6 +10,7 @@ requires-python = ">=3.13"
 dependencies = [
     "peft>=0.21.2",
     "pydantic>=2.14.1",
+    "safetensors>=0.8.0",
     "torch",
     "transformers>=5.20.0",
 ]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/8176ced7157929f551e3722149016dbc31d42601). [The code after it](https://github.com/rahuldave/babykev/tree/8176ced7157929f551e3722149016dbc31d42601).

<a id="tut-15.7"></a>

### 15.7 The README names the packages of the model

The README says what the project installs. A paragraph under "Start" names the four packages of the model, and
what they cost on disk.

Apply the patch to [`README.md`](#tut-15.7-README.md-8ec9a0), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/c7037ec460963acd41edf1f63a6a03d2e52e5bae.diff | git apply --include=README.md
```

The patch adds a paragraph under the first paragraph of the section "Start".

```bash
just setup
du -sh .venv .venv/lib/python3.13/site-packages/torch
```

`just setup` prints `Resolved 66 packages`. `du -sh` prints the size of the environment, `765M`, and of torch alone,
`542M`. The sizes can differ a little on another machine.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check c7037ec46096
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source 8176ced71579 --staged -- :/ && git restore --source tut-15 --staged --worktree -- :/
```

#### What changed

- <a id="tut-15.7-README.md-8ec9a0"></a>`README.md`: a paragraph on the packages of the model. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/c7037ec460963acd41edf1f63a6a03d2e52e5bae/README.md).
  - look at `The model needs four packages, torch, transformers, peft and safetensors. torch is the build for the CPU,`

<details open><summary>The patch to <code>README.md</code></summary>

```diff
@@ -58,6 +58,10 @@ Then run `just test`. `just` lists the tasks, `just help VERB` explains one, and
 help of the program itself. A recipe gives its extra words to the tool behind it. For example,
 `just test -k help` runs only the tests with `help` in their name.
 
+The model needs four packages, torch, transformers, peft and safetensors. torch is the build for the CPU,
+from the index of PyTorch that `pyproject.toml` names. On a Mac, the same build runs on the GPU of Apple
+too. With them, `.venv` takes about 750 MB, and torch is most of it.
+
 Run `just hook` once in each clone. It installs a git hook, which runs `just check` before each commit.
 `just check` runs every check of the project, and if one fails, git makes no commit. You can run `just check`
 yourself at any time.
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c7037ec460963acd41edf1f63a6a03d2e52e5bae).

This part ends at the code at `tut-15`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-15)

<a id="tut-25.1"></a>

## 25.1 The run image installs no group

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-24`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-24)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-15 --staged -- :/ && git restore --source tut-24 --staged --worktree -- :/
```

```bash
just setup
```

The whole tutorial then writes the model, and its tests. ty, which checks the types, joins the group `lint`.
hypothesis, which draws many inputs for one test, joins the group `test`. The run image is babykev as a user runs
it. It needs the dependencies of the project, and no group.

### 25.1 The Dockerfile, with the run image

A `Dockerfile` builds an image in stages, and each `FROM` starts one. The stage `uv` is the image of uv itself. The
stage `build` installs the environment into `/opt/venv`, with no group of the developers. The packages of `uv.lock`
come first, and the code after. Docker keeps each instruction of a build in its cache, so a change to the code installs one
package again, and not torch.

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

The stage `build` runs `uv sync --locked --no-default-groups`. `--no-default-groups` overrides
`default-groups = "all"`, so `/opt/venv` gets the dependencies of the project, and no group.

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/570bb2134f032a64a34d14852c82fa1a199f69f6).

This part ends at the code at `570bb2134f03`, partway through `tut-25`. [The code after this part](https://github.com/rahuldave/babykev/tree/570bb2134f032a64a34d14852c82fa1a199f69f6)

<a id="tut-25.2-to-tut-25.3"></a>

## 25.2 to 25.3 The dev image installs every group

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `570bb2134f03`, partway through `tut-25`. [The code before this part](https://github.com/rahuldave/babykev/tree/570bb2134f032a64a34d14852c82fa1a199f69f6)

```bash
just setup
```

The dev image is for working on the project, so it installs every group. Its build runs `uv sync --locked`, with no
`--no-default-groups`, and `default-groups = "all"` holds.

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f0862402733db839738f0b350a049b2ee5e2a2aa).

This part ends at the code at `f0862402733d`, partway through `tut-25`. [The code after this part](https://github.com/rahuldave/babykev/tree/f0862402733db839738f0b350a049b2ee5e2a2aa)

<a id="tut-25.9"></a>

## 25.9 An image holds the lockfile of its build

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `fd4dc5172346`, partway through `tut-25`. [The code before this part](https://github.com/rahuldave/babykev/tree/fd4dc51723462cdeaf072a4f2a18472a0cf6a645)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git restore --source f0862402733d --staged -- :/ && git restore --source fd4dc5172346 --staged --worktree -- :/
```

```bash
just setup
```

The whole tutorial then turns off the time limit of hypothesis, and adds the recipe `just image`. `just image build
dev` builds the dev image, and `just image shell` runs a command in it, with this folder at `/work`. hadolint, a
linter for the `Dockerfile`, joins the group `lint`. Its one finding stays
out, with the reason in a comment. Docker built the dev image before hadolint came in.

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
