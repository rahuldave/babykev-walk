<!-- Made by the walk skill's render.py from the facts of the walk. Do not edit it by hand: run just walk-update again. -->

# The contract of babykev

**Build it yourself.** Every command to run and every change to make by hand, to make the project yourself. [Read the tutorial](read.md) is the other way to read it.

Each part ends with a section called **What changed**. It lists every file that the part changes, with a link to the file, and then the whole diff of each file, folded. A lockfile and a binary file have a link alone. The text above it explains the change. What changed is what you check your files against.

In Build it yourself, a file that a command makes says which command. A diff that is open is a patch. Apply it with the command in the text, or make the same change in your editor.

We build the contract of babykev, a small decision model. babykev reads a text and some questions about it, and gives
a probability for every answer. A contract is the set of rules that both sides of an exchange agree on. Here the two
sides are the person who sends a request and the code that answers it. The contract says what a request must hold, and
what an answer holds.

Here is a small request. Its `state` says what the questions are about, here one cheese. The state can be plain text,
or named fields as here, and babykev turns it into text for the model. Three questions ask about it, each under a name
of its own.

```json
{
  "state": {"cheese": "Coquetdale", "style": "soft-ripened"},
  "questions": {
    "vegetarian": {"type": "noul", "instructions": "Would you offer this cheese to a vegetarian?"},
    "milk": {"type": "choice", "instructions": "Choose the milk.", "criteria": {"cow": null, "goat": null}},
    "intensity": {"type": "score", "instructions": "How strong is the flavour?", "criteria": ["Mild", "Medium", "Strong"]}
  }
}
```

Each question has a `type`, and there are three:

| Type | What it asks | What the answer holds |
|---|---|---|
| `noul` | Yes or no | The probability of yes |
| `choice` | One of the named options in `criteria` | The most likely option, a probability for each option, and a confidence |
| `score` | A level on the scale in `criteria`, from the first level to the last | The expected level, a probability for each level, and a confidence |

The expected level is a mean. Level 0 is `Mild`, level 1 is `Medium` and level 2 is `Strong`. If the model gives them
the probabilities 0.1, 0.2 and 0.7, the expected level is 0 × 0.1 + 1 × 0.2 + 2 × 0.7 = 1.6. The confidence is a
number from 0 to 1. It is 1 when the model is certain, and 0 when it only guesses.

The contract also says what a request must not be. A request with no questions is refused. So is a choice with no
options, or a scale with one level, or a question of a type that does not exist.

In babykev, the contract is the file `src/babykev/api.py`. It is written with pydantic, a Python package. In pydantic,
each kind of data is a class, a piece of code that lists the fields the data must have. pydantic checks data against
its class. This tutorial takes the parts about the contract out of the whole tutorial of babykev.

We make the project in moves. A move is one small change, made by one patch or by one command. A patch changes a file.
In watch mode, each move is already made, and the text says what it did and where to look. In do mode, you make each
move, and the page checks your files against it.

Some moves of the whole tutorial are not in this one. After such a gap, the next section says what those moves did,
and begins from their code. Each section after the first runs `just setup` before its moves. It installs the packages
that the code of the section needs.

Two tools run everything here. [uv](https://docs.astral.sh/uv/) manages the project. It installs Python and the packages, keeps them in `.venv`, and pins their versions in `uv.lock`. [just](https://just.systems/) runs the tasks of the project by name, from the recipes of its `justfile`. `just setup`, for example, runs `uv sync`.

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

<a id="tut-00"></a>

## 0 Where we start

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part is where the project starts, at `tut-00`. [The code of this part](https://github.com/rahuldave/babykev/tree/tut-00)

babykev starts as a README, before any code. Its table already gives the three types of question.

babykev starts as words, before any code. The README says what babykev is, and what request it reads. The licence is
kev's, the Apache License 2.0, and the notice gives kev the credit. `.gitignore` is GitHub's template for Python. It
names the files that Python, its tools and its environments write, and that git must not track.

There is no justfile yet, so `just setup` cannot run here. The first commands only look around.

```bash
ls -a
grep -n -x -E '__pycache__/|\.coverage|\.pytest_cache/|\.venv' .gitignore
```

`ls -a` lists `.` and `..`, the folder itself and the folder above it. Then it lists `.git`, the folder of the
repository, and the four files. If you ran a later part of the tutorial before, `ls -a` also lists `.venv`. Git
ignores `.venv`, so coming back here leaves it where it is.

`grep` prints four of the 220 lines of `.gitignore`, with their numbers. `__pycache__/` is on line 2, `.coverage` on
line 43, `.pytest_cache/` on line 52 and `.venv` on line 155. Python, the tools of the tests and uv write these, and
git ignores each of them before it exists.

Check your files against this part. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 70ac5b0a0a1d
```

If you are stuck, this command puts the files of this part in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git rm -rq --cached --ignore-unmatch -- :/ && git restore --source tut-00 --staged --worktree -- :/
```

### What changed

- <a id="tut-00-.gitignore-a5cc29"></a>`.gitignore`: GitHub's template for Python, from github/gitignore. New, 220 lines. [The file](https://github.com/rahuldave/babykev/blob/70ac5b0a0a1d927dfc4da6f8b7b92344917e4a33/.gitignore).
  - look at `.venv`
- <a id="tut-00-LICENSE-0398cc"></a>`LICENSE`: the Apache License, Version 2.0, the licence of kev. New, 202 lines. [The file](https://github.com/rahuldave/babykev/blob/70ac5b0a0a1d927dfc4da6f8b7b92344917e4a33/LICENSE).
- <a id="tut-00-NOTICE-fe7187"></a>`NOTICE`: the credit to kev. New, 8 lines. [The file](https://github.com/rahuldave/babykev/blob/70ac5b0a0a1d927dfc4da6f8b7b92344917e4a33/NOTICE).
- <a id="tut-00-README.md-8ec9a0"></a>`README.md`: what babykev is, and the request it reads. The table gives the three types of question. New, 74 lines. [The file](https://github.com/rahuldave/babykev/blob/70ac5b0a0a1d927dfc4da6f8b7b92344917e4a33/README.md).
  - look at ``| `noul` | Yes or no | The probability of yes |``

<details><summary>The diff of <code>.gitignore</code></summary>

```diff
@@ -0,0 +1,220 @@
+# Byte-compiled / optimized / DLL files
+__pycache__/
+*.py[codz]
+*$py.class
+
+# C extensions
+*.so
+
+# Distribution / packaging
+.Python
+build/
+develop-eggs/
+dist/
+downloads/
+eggs/
+.eggs/
+lib/
+lib64/
+parts/
+sdist/
+var/
+wheels/
+share/python-wheels/
+*.egg-info/
+.installed.cfg
+*.egg
+MANIFEST
+
+# PyInstaller
+#   Usually these files are written by a python script from a template
+#   before PyInstaller builds the exe, so as to inject date/other infos into it.
+*.manifest
+*.spec
+
+# Installer logs
+pip-log.txt
+pip-delete-this-directory.txt
+
+# Unit test / coverage reports
+htmlcov/
+.tox/
+.nox/
+.coverage
+.coverage.*
+.cache
+nosetests.xml
+coverage.xml
+*.cover
+*.py.cover
+*.lcov
+.hypothesis/
+.pytest_cache/
+cover/
+
+# Translations
+*.mo
+*.pot
+
+# Django stuff:
+*.log
+local_settings.py
+db.sqlite3
+db.sqlite3-journal
+
+# Flask stuff:
+instance/
+.webassets-cache
+
+# Scrapy stuff:
+.scrapy
+
+# Sphinx documentation
+docs/_build/
+
+# PyBuilder
+.pybuilder/
+target/
+
+# Jupyter Notebook
+.ipynb_checkpoints
+
+# IPython
+profile_default/
+ipython_config.py
+
+# pyenv
+#   For a library or package, you might want to ignore these files since the code is
+#   intended to run in multiple environments; otherwise, check them in:
+# .python-version
+
+# pipenv
+#   According to pypa/pipenv#598, it is recommended to include Pipfile.lock in version control.
+#   However, in case of collaboration, if having platform-specific dependencies or dependencies
+#   having no cross-platform support, pipenv may install dependencies that don't work, or not
+#   install all needed dependencies.
+# Pipfile.lock
+
+# uv
+#   Similar to Pipfile.lock, it is generally recommended to include uv.lock in version control.
+#   This is especially recommended for binary packages to ensure reproducibility, and is more
+#   commonly ignored for libraries.
+# uv.lock
+
+# poetry
+#   Similar to Pipfile.lock, it is generally recommended to include poetry.lock in version control.
+#   This is especially recommended for binary packages to ensure reproducibility, and is more
+#   commonly ignored for libraries.
+#   https://python-poetry.org/docs/basic-usage/#commit-your-poetrylock-file-to-version-control
+# poetry.lock
+# poetry.toml
+
+# pdm
+#   Similar to Pipfile.lock, it is generally recommended to include pdm.lock in version control.
+#   pdm recommends including project-wide configuration in pdm.toml, but excluding .pdm-python.
+#   https://pdm-project.org/en/latest/usage/project/#working-with-version-control
+# pdm.lock
+# pdm.toml
+.pdm-python
+.pdm-build/
+
+# pixi
+#   Similar to Pipfile.lock, it is generally recommended to include pixi.lock in version control.
+# pixi.lock
+#   Pixi creates a virtual environment in the .pixi directory, just like venv module creates one
+#   in the .venv directory. It is recommended not to include this directory in version control.
+.pixi/*
+!.pixi/config.toml
+
+# PEP 582; used by e.g. github.com/David-OConnor/pyflow and github.com/pdm-project/pdm
+__pypackages__/
+
+# Celery stuff
+celerybeat-schedule*
+celerybeat.pid
+
+# Redis
+*.rdb
+*.aof
+*.pid
+
+# RabbitMQ
+mnesia/
+rabbitmq/
+rabbitmq-data/
+
+# ActiveMQ
+activemq-data/
+
+# SageMath parsed files
+*.sage.py
+
+# Environments
+.env
+.envrc
+.venv
+env/
+venv/
+ENV/
+env.bak/
+venv.bak/
+
+# Spyder project settings
+.spyderproject
+.spyproject
+
+# Rope project settings
+.ropeproject
+
+# mkdocs/Zensical documentation
+/site
+
+# mypy
+.mypy_cache/
+.dmypy.json
+dmypy.json
+
+# Pyre type checker
+.pyre/
+
+# pytype static type analyzer
+.pytype/
+
+# Cython debug symbols
+cython_debug/
+
+# PyCharm
+#   JetBrains specific template is maintained in a separate JetBrains.gitignore that can
+#   be found at https://github.com/github/gitignore/blob/main/Global/JetBrains.gitignore
+#   and can be added to the global gitignore or merged into this file.  For a more nuclear
+#   option (not recommended) you can uncomment the following to ignore the entire idea folder.
+# .idea/
+
+# Abstra
+#   Abstra is an AI-powered process automation framework.
+#   Ignore directories containing user credentials, local state, and settings.
+#   Learn more at https://abstra.io/docs
+.abstra/
+
+# Visual Studio Code
+#   Visual Studio Code specific template is maintained in a separate VisualStudioCode.gitignore that
+#   can be found at https://github.com/github/gitignore/blob/main/Global/VisualStudioCode.gitignore
+#   and can be added to the global gitignore or merged into this file. However, if you prefer, you
+#   could uncomment the following to ignore the entire vscode folder
+# .vscode/
+# Temporary file for partial code execution
+tempCodeRunnerFile.py
+
+# Ruff stuff:
+.ruff_cache/
+
+# PyPI configuration file
+.pypirc
+
+# Marimo
+marimo/_static/
+marimo/_lsp/
+__marimo__/
+
+# Streamlit
+.streamlit/secrets.toml
```

</details>

<details><summary>The diff of <code>LICENSE</code></summary>

```diff
@@ -0,0 +1,202 @@
+
+                                 Apache License
+                           Version 2.0, January 2004
+                        http://www.apache.org/licenses/
+
+   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
+
+   1. Definitions.
+
+      "License" shall mean the terms and conditions for use, reproduction,
+      and distribution as defined by Sections 1 through 9 of this document.
+
+      "Licensor" shall mean the copyright owner or entity authorized by
+      the copyright owner that is granting the License.
+
+      "Legal Entity" shall mean the union of the acting entity and all
+      other entities that control, are controlled by, or are under common
+      control with that entity. For the purposes of this definition,
+      "control" means (i) the power, direct or indirect, to cause the
+      direction or management of such entity, whether by contract or
+      otherwise, or (ii) ownership of fifty percent (50%) or more of the
+      outstanding shares, or (iii) beneficial ownership of such entity.
+
+      "You" (or "Your") shall mean an individual or Legal Entity
+      exercising permissions granted by this License.
+
+      "Source" form shall mean the preferred form for making modifications,
+      including but not limited to software source code, documentation
+      source, and configuration files.
+
+      "Object" form shall mean any form resulting from mechanical
+      transformation or translation of a Source form, including but
+      not limited to compiled object code, generated documentation,
+      and conversions to other media types.
+
+      "Work" shall mean the work of authorship, whether in Source or
+      Object form, made available under the License, as indicated by a
+      copyright notice that is included in or attached to the work
+      (an example is provided in the Appendix below).
+
+      "Derivative Works" shall mean any work, whether in Source or Object
+      form, that is based on (or derived from) the Work and for which the
+      editorial revisions, annotations, elaborations, or other modifications
+      represent, as a whole, an original work of authorship. For the purposes
+      of this License, Derivative Works shall not include works that remain
+      separable from, or merely link (or bind by name) to the interfaces of,
+      the Work and Derivative Works thereof.
+
+      "Contribution" shall mean any work of authorship, including
+      the original version of the Work and any modifications or additions
+      to that Work or Derivative Works thereof, that is intentionally
+      submitted to Licensor for inclusion in the Work by the copyright owner
+      or by an individual or Legal Entity authorized to submit on behalf of
+      the copyright owner. For the purposes of this definition, "submitted"
+      means any form of electronic, verbal, or written communication sent
+      to the Licensor or its representatives, including but not limited to
+      communication on electronic mailing lists, source code control systems,
+      and issue tracking systems that are managed by, or on behalf of, the
+      Licensor for the purpose of discussing and improving the Work, but
+      excluding communication that is conspicuously marked or otherwise
+      designated in writing by the copyright owner as "Not a Contribution."
+
+      "Contributor" shall mean Licensor and any individual or Legal Entity
+      on behalf of whom a Contribution has been received by Licensor and
+      subsequently incorporated within the Work.
+
+   2. Grant of Copyright License. Subject to the terms and conditions of
+      this License, each Contributor hereby grants to You a perpetual,
+      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
+      copyright license to reproduce, prepare Derivative Works of,
+      publicly display, publicly perform, sublicense, and distribute the
+      Work and such Derivative Works in Source or Object form.
+
+   3. Grant of Patent License. Subject to the terms and conditions of
+      this License, each Contributor hereby grants to You a perpetual,
+      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
+      (except as stated in this section) patent license to make, have made,
+      use, offer to sell, sell, import, and otherwise transfer the Work,
+      where such license applies only to those patent claims licensable
+      by such Contributor that are necessarily infringed by their
+      Contribution(s) alone or by combination of their Contribution(s)
+      with the Work to which such Contribution(s) was submitted. If You
+      institute patent litigation against any entity (including a
+      cross-claim or counterclaim in a lawsuit) alleging that the Work
+      or a Contribution incorporated within the Work constitutes direct
+      or contributory patent infringement, then any patent licenses
+      granted to You under this License for that Work shall terminate
+      as of the date such litigation is filed.
+
+   4. Redistribution. You may reproduce and distribute copies of the
+      Work or Derivative Works thereof in any medium, with or without
+      modifications, and in Source or Object form, provided that You
+      meet the following conditions:
+
+      (a) You must give any other recipients of the Work or
+          Derivative Works a copy of this License; and
+
+      (b) You must cause any modified files to carry prominent notices
+          stating that You changed the files; and
+
+      (c) You must retain, in the Source form of any Derivative Works
+          that You distribute, all copyright, patent, trademark, and
+          attribution notices from the Source form of the Work,
+          excluding those notices that do not pertain to any part of
+          the Derivative Works; and
+
+      (d) If the Work includes a "NOTICE" text file as part of its
+          distribution, then any Derivative Works that You distribute must
+          include a readable copy of the attribution notices contained
+          within such NOTICE file, excluding those notices that do not
+          pertain to any part of the Derivative Works, in at least one
+          of the following places: within a NOTICE text file distributed
+          as part of the Derivative Works; within the Source form or
+          documentation, if provided along with the Derivative Works; or,
+          within a display generated by the Derivative Works, if and
+          wherever such third-party notices normally appear. The contents
+          of the NOTICE file are for informational purposes only and
+          do not modify the License. You may add Your own attribution
+          notices within Derivative Works that You distribute, alongside
+          or as an addendum to the NOTICE text from the Work, provided
+          that such additional attribution notices cannot be construed
+          as modifying the License.
+
+      You may add Your own copyright statement to Your modifications and
+      may provide additional or different license terms and conditions
+      for use, reproduction, or distribution of Your modifications, or
+      for any such Derivative Works as a whole, provided Your use,
+      reproduction, and distribution of the Work otherwise complies with
+      the conditions stated in this License.
+
+   5. Submission of Contributions. Unless You explicitly state otherwise,
+      any Contribution intentionally submitted for inclusion in the Work
+      by You to the Licensor shall be under the terms and conditions of
+      this License, without any additional terms or conditions.
+      Notwithstanding the above, nothing herein shall supersede or modify
+      the terms of any separate license agreement you may have executed
+      with Licensor regarding such Contributions.
+
+   6. Trademarks. This License does not grant permission to use the trade
+      names, trademarks, service marks, or product names of the Licensor,
+      except as required for reasonable and customary use in describing the
+      origin of the Work and reproducing the content of the NOTICE file.
+
+   7. Disclaimer of Warranty. Unless required by applicable law or
+      agreed to in writing, Licensor provides the Work (and each
+      Contributor provides its Contributions) on an "AS IS" BASIS,
+      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
+      implied, including, without limitation, any warranties or conditions
+      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
+      PARTICULAR PURPOSE. You are solely responsible for determining the
+      appropriateness of using or redistributing the Work and assume any
+      risks associated with Your exercise of permissions under this License.
+
+   8. Limitation of Liability. In no event and under no legal theory,
+      whether in tort (including negligence), contract, or otherwise,
+      unless required by applicable law (such as deliberate and grossly
+      negligent acts) or agreed to in writing, shall any Contributor be
+      liable to You for damages, including any direct, indirect, special,
+      incidental, or consequential damages of any character arising as a
+      result of this License or out of the use or inability to use the
+      Work (including but not limited to damages for loss of goodwill,
+      work stoppage, computer failure or malfunction, or any and all
+      other commercial damages or losses), even if such Contributor
+      has been advised of the possibility of such damages.
+
+   9. Accepting Warranty or Additional Liability. While redistributing
+      the Work or Derivative Works thereof, You may choose to offer,
+      and charge a fee for, acceptance of support, warranty, indemnity,
+      or other liability obligations and/or rights consistent with this
+      License. However, in accepting such obligations, You may act only
+      on Your own behalf and on Your sole responsibility, not on behalf
+      of any other Contributor, and only if You agree to indemnify,
+      defend, and hold each Contributor harmless for any liability
+      incurred by, or claims asserted against, such Contributor by reason
+      of your accepting any such warranty or additional liability.
+
+   END OF TERMS AND CONDITIONS
+
+   APPENDIX: How to apply the Apache License to your work.
+
+      To apply the Apache License to your work, attach the following
+      boilerplate notice, with the fields enclosed by brackets "[]"
+      replaced with your own identifying information. (Don't include
+      the brackets!)  The text should be enclosed in the appropriate
+      comment syntax for the file format. We also recommend that a
+      file or class name and description of purpose be included on the
+      same "printed page" as the copyright notice for easier
+      identification within third-party archives.
+
+   Copyright [yyyy] [name of copyright owner]
+
+   Licensed under the Apache License, Version 2.0 (the "License");
+   you may not use this file except in compliance with the License.
+   You may obtain a copy of the License at
+
+       http://www.apache.org/licenses/LICENSE-2.0
+
+   Unless required by applicable law or agreed to in writing, software
+   distributed under the License is distributed on an "AS IS" BASIS,
+   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+   See the License for the specific language governing permissions and
+   limitations under the License.
```

</details>

<details><summary>The diff of <code>NOTICE</code></summary>

```diff
@@ -0,0 +1,8 @@
+babykev
+Copyright 2026 Rahul Dave
+
+This product is derived from kev (https://github.com/jaredpalmer/kev),
+Copyright 2026 Jared Palmer, licensed under the Apache License, Version 2.0.
+
+Code in this repository that is derived from kev's first commit,
+d0e2b1fc4f9e410137b6b4ab7f7153fc52868a16, has been changed from the original.
```

</details>

<details><summary>The diff of <code>README.md</code></summary>

````diff
@@ -0,0 +1,74 @@
+# babykev
+
+babykev is a small decision model. You send it one document, the *context*, and a set of typed questions about it. It returns a probability for every possible answer to every question, in one forward pass. It generates no text.
+
+A request looks like this:
+
+```json
+{
+  "state": "Ardsallagh smoked cheese. Carrigtwohill. Natural rind. Smooth. White. Taste: mild, nutty, smokey and sweet.",
+  "questions": {
+    "has_rind": {"type": "noul", "instructions": "Is there a rind on this cheese?"},
+    "milk": {
+      "type": "choice",
+      "instructions": "What kind of milk goes into this cheese?",
+      "criteria": {"cow": null, "goat": null, "sheep": null, "buffalo": null, "mixed": "More than one kind of milk"}
+    },
+    "firmness": {
+      "type": "score",
+      "instructions": "Where does this cheese sit between soft and hard?",
+      "criteria": ["Soft", "Semi-soft", "Semi-hard", "Hard"]
+    }
+  }
+}
+```
+
+A question has one of these types:
+
+| Type | Asks for | The answer has |
+|---|---|---|
+| `noul` | Yes or no | The probability of yes |
+| `choice` | One of several named options | The chosen option, a probability for each option, and a confidence |
+| `score` | A level on an ordered scale | The expected level, a probability for each level, and a confidence |
+
+## Where it comes from
+
+babykev comes from the first commit of [kev](https://github.com/jaredpalmer/kev/tree/d0e2b1fc4f9e410137b6b4ab7f7153fc52868a16)
+by Jared Palmer. That commit is about 830 lines of Python around one idea. A small language model,
+Qwen2.5-0.5B with a LoRA adapter, reads the state and the questions as one sequence. An attention mask
+keeps each question from seeing the others, and a pointer head scores every option.
+
+babykev is a repository for teaching. It keeps the model of kev. It builds the engineering around the
+model again, from the packaging and the tests to the training and to inference on the command line. The
+aim is to show a student the infrastructure and the software development of training a model.
+
+## What you need
+
+Install two tools on your machine, uv and just. The project installs everything else itself.
+
+| Tool | What it is for |
+|---|---|
+| [uv](https://docs.astral.sh/uv/) | Python itself, the dependencies, and running the program |
+| [just](https://just.systems/) | The tasks of the project. `just` lists them |
+
+## How the history is organised
+
+The project is built in steps, on the branch `tutorial`. Each step has a tag, `tut-00`, `tut-01` and so
+on, and the message of the tag says what the step adds. The commits between two tags are the moves of a
+step. The subject of a move starts with its name, for example `tut-01.1:`. The last move of a step is the
+commit of its tag.
+
+```
+git tag -n1 --list 'tut-*'                   # the steps, one line each
+git log --oneline --reverse tut-01           # every move, up to the step tut-01
+git log --oneline --reverse tut-00..tut-01   # the moves of one step
+git switch --detach tut-00                   # the project as it was at a step
+```
+
+Run `git switch` only in a clone of your own. In timewalk, the buttons of the page move the project from step to
+step.
+
+## Licence
+
+Apache-2.0. See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE). The first commit of kev had no licence file.
+kev became Apache-2.0 three commits later.
````

</details>

<a id="tut-03.1-to-tut-03.2"></a>

## 3.1 to 3.2 The contract, in pydantic

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-02`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-02)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-00 --staged -- :/ && git restore --source tut-02 --staged --worktree -- :/
```

```bash
just setup
```

The whole tutorial first made babykev a Python project with uv. It gave babykev a command, `babykev`, in
`src/babykev/cli.py`. It also added a justfile, a file of short named commands called recipes, with the recipes
`setup` and `help`. Then it added pytest, a tool that runs tests, and coverage, which shows the lines of code that the
tests run. The recipe `just test` runs them both, and five tests check the command. The project has no contract yet.

<a id="tut-03.1"></a>

### 3.1 Pydantic, the first dependency

The contract is written with pydantic, and babykev does not have it yet. pydantic checks that data has the shape that
a class describes. `uv add` writes the package into `dependencies`, because a package of babykev needs it to run.

[pydantic](https://docs.pydantic.dev/) checks data against a description written as Python classes with type hints. A model says which fields a request has and of what type. pydantic then refuses data that does not fit, with a message that names the field. So the rules of a request live in one place, as code.

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/96502df0a92f6f7090d6f624cda901a271dac9a7). [The code after it](https://github.com/rahuldave/babykev/tree/96502df0a92f6f7090d6f624cda901a271dac9a7).

<a id="tut-03.2"></a>

### 3.2 api.py, the contract

babykev has no contract yet. `api.py`, from kev, says what a request is and what an answer is. It comes in whole,
all 111 lines, and we read it before we change it.

Apply the patch to [`src/babykev/api.py`](#tut-03.2-src-babykev-api.py-2ea65f), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/e8e2e72adad9364a58be21dadf6d757e84436b97.diff | git apply --include=src/babykev/api.py
```

Read lines 14 to 43 first. They are the classes of a request and its questions.

```bash
sed -n '14,43p' src/babykev/api.py
```

Each class says what its data must look like. `Literal["score"]` accepts only the text `score`.
`Field(min_length=2, max_length=MAX_OPTIONS)` asks a score for 2 to 255 levels. A `Choice` checks its number of options
in its own validator, `_check`, on lines 25 to 28.

```bash
just test
```

The 5 tests pass, and coverage falls. `api.py` has 70 statements, and no test runs any of them. The total is 10%, 8 of
78 statements. A file that no test reaches counts against the total.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check e8e2e72adad9
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 96502df0a92f --staged -- :/ && git restore --source e8e2e72adad9 --staged --worktree -- :/
```

#### What changed

- <a id="tut-03.2-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a request has a state and its questions by name. Each question is a `Noul`, a `Choice` or a `Score`, and its field `type` says which. New, 111 lines. [The file](https://github.com/rahuldave/babykev/blob/e8e2e72adad9364a58be21dadf6d757e84436b97/src/babykev/api.py).
  - look at `class SystemOneRequest(BaseModel):`

<details open><summary>The patch to <code>src/babykev/api.py</code></summary>

```diff
@@ -0,0 +1,111 @@
+"""TypeSafe-compatible request/response shapes (POST /v1/systemone) mapped onto the single pointer primitive.
+
+Noul   -> 2 options [false, true];            answer = p(true)
+Choice -> options 'name' or 'name: desc';      answer = argmax, probabilities by name, confidence
+Score  -> options = ordered level descriptions; answer = expected level, legend, probabilities by index
+"""
+from typing import Any, Literal, Union
+from pydantic import BaseModel, Field, model_validator
+
+JSONContent = Union[str, dict, list, int, float, bool, None]
+MAX_OPTIONS = 255
+
+
+class Noul(BaseModel):
+    type: Literal["noul"]
+    instructions: JSONContent
+    criteria: dict[str, JSONContent] | None = None
+
+
+class Choice(BaseModel):
+    type: Literal["choice"]
+    instructions: JSONContent
+    criteria: dict[str, JSONContent]
+
+    @model_validator(mode="after")
+    def _check(self):
+        if not 1 <= len(self.criteria) <= MAX_OPTIONS: raise ValueError(f"criteria must have 1..{MAX_OPTIONS} options")
+        return self
+
+
+class Score(BaseModel):
+    type: Literal["score"]
+    instructions: JSONContent
+    criteria: list[JSONContent] = Field(min_length=2, max_length=MAX_OPTIONS)
+
+
+Question = Union[Noul, Choice, Score]
+
+
+class SystemOneRequest(BaseModel):
+    state: JSONContent
+    model: str = "kev-latest"
+    questions: dict[str, Question] = Field(min_length=1)
+
+
+def render(v: JSONContent, indent: int = 0) -> str:
+    """Flatten str | object | array into text the model sees. Field names are kept as labels."""
+    pad = "  " * indent
+    if v is None: return ""
+    if isinstance(v, (str, int, float, bool)): return str(v)
+    if isinstance(v, list): return "\n".join(f"{pad}- {render(x, indent + 1).lstrip()}" for x in v)
+    return "\n".join(f"{pad}{k}:\n{render(x, indent + 1)}" if isinstance(x, (dict, list)) else f"{pad}{k}: {render(x)}" for k, x in v.items())
+
+
+def option_text(name: str, desc: JSONContent) -> str:
+    return name if desc is None or desc == "" else f"{name}: {render(desc)}"
+
+
+def to_record(req: SystemOneRequest):
+    """-> internal record for encode(), plus per-question metadata to map probabilities back."""
+    qs, meta = [], []
+    for qid, q in req.questions.items():
+        instr = render(q.instructions)
+        if q.type == "noul":
+            c = q.criteria or {}
+            opts = [option_text("no", c.get("false")), option_text("yes", c.get("true"))]
+            meta.append({"id": qid, "type": "noul"})
+        elif q.type == "choice":
+            opts = [option_text(k, v) for k, v in q.criteria.items()]
+            meta.append({"id": qid, "type": "choice", "keys": list(q.criteria.keys())})
+        else:
+            opts = [render(x) for x in q.criteria]
+            meta.append({"id": qid, "type": "score", "legend": {str(i): render(x) for i, x in enumerate(q.criteria)}})
+        qs.append({"instr": instr, "options": opts, "label": 0})
+    return {"state": render(req.state), "questions": qs}, meta
+
+
+def choice_confidence(p: list[float]) -> float:
+    K = len(p)
+    return 1.0 if K == 1 else (max(p) - 1 / K) / (1 - 1 / K)
+
+
+def score_confidence(p: list[float]) -> float:
+    """Approximation of TypeSafe's 'distance from the modal level' statistic (exact formula unpublished):
+    1 - E|level - mode| / (L - 1)."""
+    L = len(p); mode = max(range(L), key=lambda i: p[i])
+    return 1.0 - sum(pi * abs(i - mode) for i, pi in enumerate(p)) / (L - 1)
+
+
+def r2(x: float) -> float:
+    return round(float(x), 2)
+
+
+def to_answers(probs: list[list[float]], meta: list[dict]) -> dict[str, Any]:
+    out = {}
+    for p, m in zip(probs, meta):
+        if m["type"] == "noul":
+            out[m["id"]] = {"type": "noul", "noul": r2(p[1])}
+        elif m["type"] == "choice":
+            dist = {k: r2(v) for k, v in zip(m["keys"], p)}
+            out[m["id"]] = {"type": "choice", "choice": m["keys"][max(range(len(p)), key=lambda i: p[i])], "confidence": r2(choice_confidence(p)), "probabilities": dist}
+        else:
+            score = sum(i * pi for i, pi in enumerate(p))
+            out[m["id"]] = {"type": "score", "score": r2(score), "legend": m["legend"], "probabilities": {str(i): r2(v) for i, v in enumerate(p)}, "confidence": r2(score_confidence(p))}
+    return out
+
+
+def output_tokens(tok, answers: dict) -> int:
+    """Billing-style figure: tokens of the serialised answers. Not a measure of generation (there is none)."""
+    import json
+    return len(tok(json.dumps(answers), add_special_tokens=False).input_ids)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e8e2e72adad9364a58be21dadf6d757e84436b97).

This part ends at the code at `e8e2e72adad9`, partway through `tut-03`. [The code after this part](https://github.com/rahuldave/babykev/tree/e8e2e72adad9364a58be21dadf6d757e84436b97)

<a id="tut-03.3-to-tut-03.5"></a>

## 3.3 to 3.5 What babykev leaves out of the contract

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `e8e2e72adad9`, partway through `tut-03`. [The code before this part](https://github.com/rahuldave/babykev/tree/e8e2e72adad9364a58be21dadf6d757e84436b97)

```bash
just setup
```

`api.py` came from kev, a larger project. kev answered requests on a server. Each request named the model for the
server to run. kev also counted the tokens of each answer, to bill for it. Tokens are the small pieces of text that a
model reads.

babykev has no server and no bill. A docstring is the text at the top of a file, or under a class or a function, that
says what it is for. The moves take the server out of the docstring of `api.py`. They also take the name of the model
out of a request, and remove the count of tokens.

<a id="tut-03.3"></a>

### 3.3 The docstring of api.py names no server

kev served the model over HTTP, and babykev has no server. The first line of `api.py` names the address of kev's
server, `POST /v1/systemone`.

Apply the patch to [`src/babykev/api.py`](#tut-03.3-src-babykev-api.py-2ea65f), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/93618951b784e928af3d3547f077bb49bff4d5da.diff | git apply --include=src/babykev/api.py
```

The patch changes the first line of the file.

```bash
head -n 1 src/babykev/api.py
```

It prints the new first line.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 93618951b784
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source e8e2e72adad9 --staged -- :/ && git restore --source 93618951b784 --staged --worktree -- :/
```

#### What changed

- <a id="tut-03.3-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the docstring. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/93618951b784e928af3d3547f077bb49bff4d5da/src/babykev/api.py).
  - look at `"""The contract: request and answer shapes, mapped onto the single pointer primitive.`

<details open><summary>The patch to <code>src/babykev/api.py</code></summary>

```diff
@@ -1,4 +1,4 @@
-"""TypeSafe-compatible request/response shapes (POST /v1/systemone) mapped onto the single pointer primitive.
+"""The contract: request and answer shapes, mapped onto the single pointer primitive.
 
 Noul   -> 2 options [false, true];            answer = p(true)
 Choice -> options 'name' or 'name: desc';      answer = argmax, probabilities by name, confidence
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/93618951b784e928af3d3547f077bb49bff4d5da). [The code after it](https://github.com/rahuldave/babykev/tree/93618951b784e928af3d3547f077bb49bff4d5da).

<a id="tut-03.4"></a>

### 3.4 A request names no model

The field `model` named the model for kev's server to run. babykev has one model, so a request names none.

Apply the patch to [`src/babykev/api.py`](#tut-03.4-src-babykev-api.py-2ea65f), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/5cce9c9e5025336d501298d244389b64c696737c.diff | git apply --include=src/babykev/api.py
```

The patch deletes the line `model: str = "kev-latest"`, the last line of `SystemOneRequest`.

```bash
uv run python -c "from babykev.api import SystemOneRequest; print(sorted(SystemOneRequest.model_fields))"
```

`model_fields` lists the fields of a pydantic model. The command prints `['questions', 'state']`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 5cce9c9e5025
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 93618951b784 --staged -- :/ && git restore --source 5cce9c9e5025 --staged --worktree -- :/
```

#### What changed

- <a id="tut-03.4-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a request has two fields, `state` and `questions`. 0 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/5cce9c9e5025336d501298d244389b64c696737c/src/babykev/api.py).
  - look at `    questions: dict[str, Question] = Field(min_length=1)`

<details open><summary>The patch to <code>src/babykev/api.py</code></summary>

```diff
@@ -39,7 +39,6 @@ Question = Union[Noul, Choice, Score]
 
 class SystemOneRequest(BaseModel):
     state: JSONContent
-    model: str = "kev-latest"
     questions: dict[str, Question] = Field(min_length=1)
 
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5cce9c9e5025336d501298d244389b64c696737c). [The code after it](https://github.com/rahuldave/babykev/tree/5cce9c9e5025336d501298d244389b64c696737c).

<a id="tut-03.5"></a>

### 3.5 output_tokens goes

`output_tokens` counted the tokens of an answer for a bill, and needs the tokenizer of a model. babykev bills nothing.

Apply the patch to [`src/babykev/api.py`](#tut-03.5-src-babykev-api.py-2ea65f), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/43b7ea4eda990f90abd605920e2fb1d9b376378d.diff | git apply --include=src/babykev/api.py
```

The patch deletes the function `output_tokens` at the end of the file, and the two blank lines before it.

```bash
wc -l src/babykev/api.py
just test
```

`wc -l` counts 104 lines. `just test` prints `5 passed`, and the total is 11%, 8 of 74 statements.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 43b7ea4eda99
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 5cce9c9e5025 --staged -- :/ && git restore --source 43b7ea4eda99 --staged --worktree -- :/
```

#### What changed

- <a id="tut-03.5-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the function goes. 0 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/43b7ea4eda990f90abd605920e2fb1d9b376378d/src/babykev/api.py).

<details open><summary>The patch to <code>src/babykev/api.py</code></summary>

```diff
@@ -102,9 +102,3 @@ def to_answers(probs: list[list[float]], meta: list[dict]) -> dict[str, Any]:
             score = sum(i * pi for i, pi in enumerate(p))
             out[m["id"]] = {"type": "score", "score": r2(score), "legend": m["legend"], "probabilities": {str(i): r2(v) for i, v in enumerate(p)}, "confidence": r2(score_confidence(p))}
     return out
-
-
-def output_tokens(tok, answers: dict) -> int:
-    """Billing-style figure: tokens of the serialised answers. Not a measure of generation (there is none)."""
-    import json
-    return len(tok(json.dumps(answers), add_special_tokens=False).input_ids)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/43b7ea4eda990f90abd605920e2fb1d9b376378d).

This part ends at the code at `43b7ea4eda99`, partway through `tut-03`. [The code after this part](https://github.com/rahuldave/babykev/tree/43b7ea4eda990f90abd605920e2fb1d9b376378d)

<a id="tut-03.6-to-tut-03.7"></a>

## 3.6 to 3.7 Sample data

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `43b7ea4eda99`, partway through `tut-03`. [The code before this part](https://github.com/rahuldave/babykev/tree/43b7ea4eda990f90abd605920e2fb1d9b376378d)

```bash
just setup
```

A file holds five requests about cheese, one on each line. Each line must fit the contract.

<a id="tut-03.6"></a>

### 3.6 Five requests about cheese, as sample data

The tests of the contract need requests to check, and the project has none. Five requests about cheese come in a file
of their own. Each line of the file is one request, in JSON. Each question has a `label`, the right answer.

Apply the patch to [`data/cheese/sample.jsonl`](#tut-03.6-data-cheese-sample.jsonl-79f982), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/abb4ece53e114b331e9e32d67309e1f54f9f964e.diff | git apply --include=data/cheese/sample.jsonl
```

The patch makes the file, five lines of JSON.

```bash
head -n 1 data/cheese/sample.jsonl | python3 -m json.tool
```

`python3 -m json.tool` prints JSON with one key on each line. The first request is about the cheese Coquetdale, and
asks three questions. `vegetarian` is a `noul` with the label `true`. `intensity` is a `score` of four levels with the
label `1`, the second level. `milk` is a `choice` of five options with the label `cow`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check abb4ece53e11
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 43b7ea4eda99 --staged -- :/ && git restore --source abb4ece53e11 --staged --worktree -- :/
```

#### What changed

- <a id="tut-03.6-data-cheese-sample.jsonl-79f982"></a>`data/cheese/sample.jsonl`: each line is a request with a `state` and its `questions`. New, 5 lines. [The file](https://github.com/rahuldave/babykev/blob/abb4ece53e114b331e9e32d67309e1f54f9f964e/data/cheese/sample.jsonl).

<details open><summary>The patch to <code>data/cheese/sample.jsonl</code></summary>

```diff
@@ -0,0 +1,5 @@
+{"state":{"cheese":"Coquetdale","origin":"Coquet, England","style":"soft-ripened","notes":{"texture":["creamy"],"flavour":["fruity"],"aroma":["rich"]},"colour":"pale yellow"},"questions":{"vegetarian":{"type":"noul","instructions":"Would you offer this cheese to a vegetarian?","label":true,"src":"cheese/vegetarian/withheld"},"intensity":{"type":"score","instructions":"How strong is the flavour of this cheese?","criteria":["Mild: milky, buttery, gentle","Medium: nutty, fruity, earthy","Pronounced: tangy, sharp, spicy","Strong: pungent, the kind you smell first"],"label":1,"src":"cheese/intensity/stated"},"milk":{"type":"choice","instructions":"Choose the milk this cheese is made from.","criteria":{"buffalo":null,"goat":null,"mixed":"More than one kind of milk","cow":null,"sheep":null},"label":"cow","src":"cheese/milk/withheld"}}}
+{"state":"ARDSALLAGH SMOKED CHEESE. Carrigtwohill. natural rind. smooth. white. taste: mild, nutty, smokey and sweet. vegetarian.","questions":{"has_rind":{"type":"noul","instructions":"Is there a rind on this cheese?","label":true,"src":"cheese/has_rind/stated"},"milk":{"type":"choice","instructions":"What kind of milk goes into this cheese?","criteria":{"buffalo":null,"goat":null,"cow":null,"sheep":null,"mixed":"More than one kind of milk"},"label":"goat","src":"cheese/milk/withheld"},"firmness":{"type":"score","instructions":"Where does this cheese sit between soft and hard?","criteria":["Soft: spreadable or yielding","Semi-soft: supple, bends before it breaks","Semi-hard: slices cleanly","Hard: dense, for grating or breaking"],"label":2,"src":"cheese/firmness/withheld"}}}
+{"state":{"cheese":"Alisia-Victoria","milk":"cow's","notes":{"texture":["smooth"],"flavour":["buttery"],"aroma":["nutty"]},"colour":"golden yellow"},"questions":{"fresh":{"type":"noul","instructions":"Is this a fresh cheese, sold without aging?","label":false,"src":"cheese/fresh/withheld"},"origin":{"type":"choice","instructions":"Where does this cheese come from?","criteria":{"United States or Canada":null,"British Isles":"England, Scotland, Wales or Ireland","rest of the world":null,"elsewhere in Europe":null,"France":null},"label":"elsewhere in Europe","src":"cheese/origin/withheld"},"firmness":{"type":"score","instructions":"Where does this cheese sit between soft and hard?","criteria":["Soft: spreadable or yielding","Semi-soft: supple, bends before it breaks","Semi-hard: slices cleanly","Hard: dense, for grating or breaking"],"label":3,"src":"cheese/firmness/withheld"}}}
+{"state":{"cheese":"Amou","milk":"sheep's"},"questions":{"vegetarian":{"type":"noul","instructions":"Is this cheese suitable for vegetarians?","label":false,"src":"cheese/vegetarian/withheld"},"milk":{"type":"choice","instructions":"Choose the milk this cheese is made from.","criteria":{"mixed":"More than one kind of milk","goat":null,"cow":null,"sheep":null,"buffalo":null},"label":"sheep","src":"cheese/milk/stated"},"firmness":{"type":"score","instructions":"Rate the firmness of this cheese.","criteria":["Soft: spreadable or yielding","Semi-soft: supple, bends before it breaks","Semi-hard: slices cleanly","Hard: dense, for grating or breaking"],"label":3,"src":"cheese/firmness/withheld"}}}
+{"state":"LOMA ALTA. soft-ripened. mould-ripened rind. firm. white. taste: buttery and nutty. smell: rich. not vegetarian.","questions":{"origin":{"type":"choice","instructions":"Choose where this cheese originates.","criteria":{"elsewhere in Europe":null,"United States or Canada":null,"rest of the world":null,"France":null,"British Isles":"England, Scotland, Wales or Ireland"},"label":"United States or Canada","src":"cheese/origin/withheld"},"no_cow":{"type":"noul","instructions":"Is this cheese free of cow's milk?","label":false,"src":"cheese/no_cow/withheld"},"intensity":{"type":"score","instructions":"How strong is the flavour of this cheese?","criteria":["Mild: milky, buttery, gentle","Medium: nutty, fruity, earthy","Pronounced: tangy, sharp, spicy","Strong: pungent, the kind you smell first"],"label":1,"src":"cheese/intensity/stated"}}}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/abb4ece53e114b331e9e32d67309e1f54f9f964e). [The code after it](https://github.com/rahuldave/babykev/tree/abb4ece53e114b331e9e32d67309e1f54f9f964e).

<a id="tut-03.7"></a>

### 3.7 The README names the contract and the data

The table of the README names neither the contract nor the data. Rows for `api.py`, `cli.py` and the sample data take
the place of the row of `src/babykev/`.

Apply the patch to [`README.md`](#tut-03.7-README.md-8ec9a0), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/56606771fb23f7a0a01825f477050d2980a47736.diff | git apply --include=README.md
```

The patch puts three rows in place of the row of `src/babykev/`.

```bash
grep -n -E 'api.py|sample.jsonl' README.md
```

`grep` prints the two new rows.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 56606771fb23
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source abb4ece53e11 --staged -- :/ && git restore --source tut-03 --staged --worktree -- :/
```

#### What changed

- <a id="tut-03.7-README.md-8ec9a0"></a>`README.md`: the rows of the contract and the data. 3 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/56606771fb23f7a0a01825f477050d2980a47736/README.md).
  - look at ``| `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |``

<details open><summary>The patch to <code>README.md</code></summary>

```diff
@@ -63,7 +63,9 @@ help of the program itself. A recipe gives its extra words to the tool behind it
 | Path | What it is |
 |---|---|
 | `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, the settings of its tools, and the exact versions to install |
-| `src/babykev/` | The code. `cli.py` is the command `babykev` |
+| `src/babykev/api.py` | The contract: the request and its three types of question as pydantic models, the text and options the model reads, and the answers made from its probabilities |
+| `src/babykev/cli.py` | The command `babykev` |
+| `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
 | `tests/unit/` | The unit tests. `test_cli.py` tests the command `babykev` |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `README.md` | This file |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/56606771fb23f7a0a01825f477050d2980a47736).

This part ends at the code at `tut-03`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-03)

<a id="tut-04"></a>

## 4 What the contract accepts and refuses

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-03`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-03)

No test reaches the contract yet. The first tests check each line of the sample data against it. The others check one
rule each. A contract must refuse bad data as well as accept good data. When data does not fit, pydantic refuses it
with an error called `ValidationError`. So most of these tests expect that error.

```bash
just setup
```

The contract says what a request is, and no test checks it. The tests of this part check the five sample requests
against the contract. Then they check what the contract accepts and refuses, one rule at a time. They go in
`tests/unit/test_api.py`, one test in each move.

<a id="tut-04.1"></a>

### 4.1 Every line of the sample data fits the contract

The first test of `api.py` checks each of the five sample requests against the contract. `SAMPLE_LINES` reads the
file. `parametrize` gives the test each line in turn. `model_validate` checks the line, and raises an error if it does
not fit.

Apply the patch to [`tests/unit/test_api.py`](#tut-04.1-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/5e134165b7e1feeded775bcfb2269aec951ad39f.diff | git apply --include=tests/unit/test_api.py
```

The patch makes the file. Read `SAMPLE_LINES`, then the test.

```bash
just test
```

`just test` prints `10 passed`, the 5 of the command and one for each sample line. `api.py` is at 77%. The missing
lines are the functions that turn probabilities into answers.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 5e134165b7e1
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-03 --staged -- :/ && git restore --source 5e134165b7e1 --staged --worktree -- :/
```

#### What changed

- <a id="tut-04.1-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the sample data, and the test that checks each line. New, 27 lines. [The file](https://github.com/rahuldave/babykev/blob/5e134165b7e1feeded775bcfb2269aec951ad39f/tests/unit/test_api.py).
  - look at `def test_sample_line_fits_the_contract(line):`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -0,0 +1,27 @@
+"""Unit tests of the contract in `babykev.api`: validation, rendering, mappings, confidences."""
+
+import json
+from pathlib import Path
+
+import pytest
+
+from babykev.api import SystemOneRequest, to_record
+
+SAMPLE = Path(__file__).parents[2] / "data" / "cheese" / "sample.jsonl"
+SAMPLE_LINES = [json.loads(line) for line in SAMPLE.read_text(encoding="utf-8").splitlines()]
+
+MILKS = {"cow": None, "goat": None, "sheep": None, "mixed": "More than one kind of milk"}
+FIRMNESS = ["Soft", "Semi-soft", "Semi-hard", "Hard"]
+
+
+# The sample data
+
+
+@pytest.mark.parametrize("line", SAMPLE_LINES)
+def test_sample_line_fits_the_contract(line):
+    """Every line of the sample data is a valid request, with one record question per question."""
+    request = SystemOneRequest.model_validate(line)
+    record, meta = to_record(request)
+    assert record["state"]
+    assert [m["id"] for m in meta] == list(line["questions"])
+    assert all(len(q["options"]) >= 2 for q in record["questions"])
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5e134165b7e1feeded775bcfb2269aec951ad39f). [The code after it](https://github.com/rahuldave/babykev/tree/5e134165b7e1feeded775bcfb2269aec951ad39f).

<a id="tut-04.2"></a>

### 4.2 Every question of the sample data has a label

The tests will compare answers with labels, so each label must have the right kind. A label is a boolean for a noul,
the name of an option for a choice, and the number of a level for a score.

Apply the patch to [`tests/unit/test_api.py`](#tut-04.2-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/1ca39523b4fdf6c75c244b8c0e0f2371593cfbff.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test -k label
```

pytest runs the new test once for each line, and prints `5 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 1ca39523b4fd
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 5e134165b7e1 --staged -- :/ && git restore --source 1ca39523b4fd --staged --worktree -- :/
```

#### What changed

- <a id="tut-04.2-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the labels of the sample data. 13 lines added. [The file](https://github.com/rahuldave/babykev/blob/1ca39523b4fdf6c75c244b8c0e0f2371593cfbff/tests/unit/test_api.py).
  - look at `def test_sample_line_has_a_usable_label_on_every_question(line):`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -25,3 +25,16 @@ def test_sample_line_fits_the_contract(line):
     assert record["state"]
     assert [m["id"] for m in meta] == list(line["questions"])
     assert all(len(q["options"]) >= 2 for q in record["questions"])
+
+
+@pytest.mark.parametrize("line", SAMPLE_LINES)
+def test_sample_line_has_a_usable_label_on_every_question(line):
+    """A label is a boolean for noul, an option name for choice, and a level index for score."""
+    for question in line["questions"].values():
+        label = question["label"]
+        if question["type"] == "noul":
+            assert isinstance(label, bool)
+        elif question["type"] == "choice":
+            assert label in question["criteria"]
+        else:
+            assert label in range(len(question["criteria"]))
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1ca39523b4fdf6c75c244b8c0e0f2371593cfbff). [The code after it](https://github.com/rahuldave/babykev/tree/1ca39523b4fdf6c75c244b8c0e0f2371593cfbff).

<a id="tut-04.3"></a>

### 4.3 A request holds one model for each type of question

The field `type` of a question decides which class of the contract it becomes. A helper, `cheese_request`, makes one
request with a question of each type, for the tests to share. The test checks that the noul is a `Noul`, the choice a
`Choice` and the score a `Score`.

Apply the patch to [`tests/unit/test_api.py`](#tut-04.3-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/847d160f4a2f014bd58eb06030268ce762577cbc.diff | git apply --include=tests/unit/test_api.py
```

The patch adds `MILKS`, `FIRMNESS` and `cheese_request` under `SAMPLE_LINES`. It adds the section `# Validation` and
its first test at the end.

```bash
just test -k one_model
```

pytest prints `1 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 847d160f4a2f
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 1ca39523b4fd --staged -- :/ && git restore --source 847d160f4a2f --staged --worktree -- :/
```

#### What changed

- <a id="tut-04.3-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the helper, and the test of the three types. 32 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/847d160f4a2f014bd58eb06030268ce762577cbc/tests/unit/test_api.py).
  - look at `def test_request_holds_one_model_per_question_type():`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -5,7 +5,13 @@ from pathlib import Path
 
 import pytest
 
-from babykev.api import SystemOneRequest, to_record
+from babykev.api import (
+    Choice,
+    Noul,
+    Score,
+    SystemOneRequest,
+    to_record,
+)
 
 SAMPLE = Path(__file__).parents[2] / "data" / "cheese" / "sample.jsonl"
 SAMPLE_LINES = [json.loads(line) for line in SAMPLE.read_text(encoding="utf-8").splitlines()]
@@ -14,6 +20,20 @@ MILKS = {"cow": None, "goat": None, "sheep": None, "mixed": "More than one kind
 FIRMNESS = ["Soft", "Semi-soft", "Semi-hard", "Hard"]
 
 
+def cheese_request():
+    """One request that asks a question of each type."""
+    return SystemOneRequest.model_validate(
+        {
+            "state": {"cheese": "Roquefort", "origin": "France"},
+            "questions": {
+                "blue": {"type": "noul", "instructions": "Is this a blue cheese?"},
+                "milk": {"type": "choice", "instructions": "Which milk?", "criteria": MILKS},
+                "firmness": {"type": "score", "instructions": "How firm?", "criteria": FIRMNESS},
+            },
+        }
+    )
+
+
 # The sample data
 
 
@@ -38,3 +58,14 @@ def test_sample_line_has_a_usable_label_on_every_question(line):
             assert label in question["criteria"]
         else:
             assert label in range(len(question["criteria"]))
+
+
+# Validation
+
+
+def test_request_holds_one_model_per_question_type():
+    """The `type` field decides which model a question becomes."""
+    questions = cheese_request().questions
+    assert isinstance(questions["blue"], Noul)
+    assert isinstance(questions["milk"], Choice)
+    assert isinstance(questions["firmness"], Score)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/847d160f4a2f014bd58eb06030268ce762577cbc). [The code after it](https://github.com/rahuldave/babykev/tree/847d160f4a2f014bd58eb06030268ce762577cbc).

<a id="tut-04.4"></a>

### 4.4 A request without questions is refused

A request must ask at least one question. `Field(min_length=1)` on `questions` says so. The test checks that pydantic
refuses a request with none.

Apply the patch to [`tests/unit/test_api.py`](#tut-04.4-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/c2af99cdd8e0b6f40e33a1ebcf9aa602904a83ba.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file, and `ValidationError` to the imports.

```bash
just test -k without_questions
```

pytest prints `1 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check c2af99cdd8e0
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 847d160f4a2f --staged -- :/ && git restore --source c2af99cdd8e0 --staged --worktree -- :/
```

#### What changed

- <a id="tut-04.4-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a request with no questions. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/c2af99cdd8e0b6f40e33a1ebcf9aa602904a83ba/tests/unit/test_api.py).
  - look at `def test_request_without_questions_is_rejected():`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -4,6 +4,7 @@ import json
 from pathlib import Path
 
 import pytest
+from pydantic import ValidationError
 
 from babykev.api import (
     Choice,
@@ -69,3 +70,9 @@ def test_request_holds_one_model_per_question_type():
     assert isinstance(questions["blue"], Noul)
     assert isinstance(questions["milk"], Choice)
     assert isinstance(questions["firmness"], Score)
+
+
+def test_request_without_questions_is_rejected():
+    """A request must ask at least one question."""
+    with pytest.raises(ValidationError):
+        SystemOneRequest.model_validate({"state": "Brie", "questions": {}})
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c2af99cdd8e0b6f40e33a1ebcf9aa602904a83ba). [The code after it](https://github.com/rahuldave/babykev/tree/c2af99cdd8e0b6f40e33a1ebcf9aa602904a83ba).

<a id="tut-04.5"></a>

### 4.5 An unknown type of question is refused

Only noul, choice and score exist. The test gives a question the type `essay`, and expects a refusal.

Apply the patch to [`tests/unit/test_api.py`](#tut-04.5-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/6acc5e7d6f228ce76a9083d915f238c3d6696c85.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test -k unknown_question
```

pytest prints `1 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 6acc5e7d6f22
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source c2af99cdd8e0 --staged -- :/ && git restore --source 6acc5e7d6f22 --staged --worktree -- :/
```

#### What changed

- <a id="tut-04.5-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a type that does not exist. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/6acc5e7d6f228ce76a9083d915f238c3d6696c85/tests/unit/test_api.py).
  - look at `question = {"type": "essay", "instructions": "Describe this cheese."}`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -76,3 +76,10 @@ def test_request_without_questions_is_rejected():
     """A request must ask at least one question."""
     with pytest.raises(ValidationError):
         SystemOneRequest.model_validate({"state": "Brie", "questions": {}})
+
+
+def test_unknown_question_type_is_rejected():
+    """Only noul, choice and score exist."""
+    question = {"type": "essay", "instructions": "Describe this cheese."}
+    with pytest.raises(ValidationError):
+        SystemOneRequest.model_validate({"state": "Brie", "questions": {"q": question}})
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/6acc5e7d6f228ce76a9083d915f238c3d6696c85). [The code after it](https://github.com/rahuldave/babykev/tree/6acc5e7d6f228ce76a9083d915f238c3d6696c85).

<a id="tut-04.6"></a>

### 4.6 A noul needs no criteria

A question of yes or no may leave out what yes and no mean. The test makes a `Noul` with no criteria, and checks that
its criteria are `None`.

Apply the patch to [`tests/unit/test_api.py`](#tut-04.6-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/3a99587d325837f9104661b3d06d9630679dc8eb.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test -k noul_needs
```

pytest prints `1 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 3a99587d3258
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 6acc5e7d6f22 --staged -- :/ && git restore --source 3a99587d3258 --staged --worktree -- :/
```

#### What changed

- <a id="tut-04.6-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a noul without criteria. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/3a99587d325837f9104661b3d06d9630679dc8eb/tests/unit/test_api.py).
  - look at `assert Noul(type="noul", instructions="Is it blue?").criteria is None`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -83,3 +83,8 @@ def test_unknown_question_type_is_rejected():
     question = {"type": "essay", "instructions": "Describe this cheese."}
     with pytest.raises(ValidationError):
         SystemOneRequest.model_validate({"state": "Brie", "questions": {"q": question}})
+
+
+def test_noul_needs_no_criteria():
+    """A yes-or-no question may leave out what yes and no mean."""
+    assert Noul(type="noul", instructions="Is it blue?").criteria is None
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3a99587d325837f9104661b3d06d9630679dc8eb). [The code after it](https://github.com/rahuldave/babykev/tree/3a99587d325837f9104661b3d06d9630679dc8eb).

<a id="tut-04.7"></a>

### 4.7 A choice without options is refused

A choice needs at least one option. The test gives a `Choice` empty criteria, and expects a refusal.

Apply the patch to [`tests/unit/test_api.py`](#tut-04.7-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/4653d298261d887195e59a2cf00593036151657c.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test -k choice_without
```

pytest prints `1 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 4653d298261d
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 3a99587d3258 --staged -- :/ && git restore --source 4653d298261d --staged --worktree -- :/
```

#### What changed

- <a id="tut-04.7-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a choice of nothing. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/4653d298261d887195e59a2cf00593036151657c/tests/unit/test_api.py).
  - look at `def test_choice_without_options_is_rejected():`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -88,3 +88,9 @@ def test_unknown_question_type_is_rejected():
 def test_noul_needs_no_criteria():
     """A yes-or-no question may leave out what yes and no mean."""
     assert Noul(type="noul", instructions="Is it blue?").criteria is None
+
+
+def test_choice_without_options_is_rejected():
+    """A choice needs at least one option."""
+    with pytest.raises(ValidationError):
+        Choice(type="choice", instructions="Which milk?", criteria={})
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4653d298261d887195e59a2cf00593036151657c). [The code after it](https://github.com/rahuldave/babykev/tree/4653d298261d887195e59a2cf00593036151657c).

<a id="tut-04.8"></a>

### 4.8 A choice has at most MAX_OPTIONS options

`MAX_OPTIONS` is 255. The test makes a choice of exactly 255 options, which is valid, and one of 256, which is
refused. A limit is tested on both of its sides.

Apply the patch to [`tests/unit/test_api.py`](#tut-04.8-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/3addf0f2bd69e0910ba506a41a240fec5218c77a.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file, and `MAX_OPTIONS` to the import from `babykev.api`.

```bash
just test -k largest
```

pytest prints `1 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 3addf0f2bd69
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 4653d298261d --staged -- :/ && git restore --source 3addf0f2bd69 --staged --worktree -- :/
```

#### What changed

- <a id="tut-04.8-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the limit, from both sides. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/3addf0f2bd69e0910ba506a41a240fec5218c77a/tests/unit/test_api.py).
  - look at `at_limit = {f"option{i}": None for i in range(MAX_OPTIONS)}`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -7,6 +7,7 @@ import pytest
 from pydantic import ValidationError
 
 from babykev.api import (
+    MAX_OPTIONS,
     Choice,
     Noul,
     Score,
@@ -94,3 +95,13 @@ def test_choice_without_options_is_rejected():
     """A choice needs at least one option."""
     with pytest.raises(ValidationError):
         Choice(type="choice", instructions="Which milk?", criteria={})
+
+
+def test_choice_accepts_the_largest_number_of_options_and_no_more():
+    """The limit on options is exact."""
+    at_limit = {f"option{i}": None for i in range(MAX_OPTIONS)}
+    assert (
+        len(Choice(type="choice", instructions="Which?", criteria=at_limit).criteria) == MAX_OPTIONS
+    )
+    with pytest.raises(ValidationError):
+        Choice(type="choice", instructions="Which?", criteria={**at_limit, "one_more": None})
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3addf0f2bd69e0910ba506a41a240fec5218c77a). [The code after it](https://github.com/rahuldave/babykev/tree/3addf0f2bd69e0910ba506a41a240fec5218c77a).

<a id="tut-04.9"></a>

### 4.9 A score of one level is refused

A scale needs two levels at least, or it measures nothing. The test gives a `Score` one level, and expects a refusal.

Apply the patch to [`tests/unit/test_api.py`](#tut-04.9-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/b9a4861a26a74623a6daf8c7c776cebe5f30a626.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test
```

`just test` prints `22 passed`. `api.py` is still at 77%. The tests of validation run lines that the sample data ran
already.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check b9a4861a26a7
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 3addf0f2bd69 --staged -- :/ && git restore --source b9a4861a26a7 --staged --worktree -- :/
```

#### What changed

- <a id="tut-04.9-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a scale of one level. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/b9a4861a26a74623a6daf8c7c776cebe5f30a626/tests/unit/test_api.py).
  - look at `Score(type="score", instructions="How firm?", criteria=["Soft"])`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -105,3 +105,9 @@ def test_choice_accepts_the_largest_number_of_options_and_no_more():
     )
     with pytest.raises(ValidationError):
         Choice(type="choice", instructions="Which?", criteria={**at_limit, "one_more": None})
+
+
+def test_score_with_one_level_is_rejected():
+    """A scale needs at least two levels."""
+    with pytest.raises(ValidationError):
+        Score(type="score", instructions="How firm?", criteria=["Soft"])
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b9a4861a26a74623a6daf8c7c776cebe5f30a626). [The code after it](https://github.com/rahuldave/babykev/tree/b9a4861a26a74623a6daf8c7c776cebe5f30a626).

<a id="tut-04.10"></a>

### 4.10 The README names the tests of the contract

The row of `tests/unit/` names only the tests of the command. It now names the tests of the contract too.

Apply the patch to [`README.md`](#tut-04.10-README.md-8ec9a0), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/1fef13ae49e24d280d05c250289c41d5636feff7.diff | git apply --include=README.md
```

The patch changes the row of `tests/unit/`.

```bash
grep -n 'tests/unit' README.md
```

`grep` prints the new row.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 1fef13ae49e2
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source b9a4861a26a7 --staged -- :/ && git restore --source tut-04 --staged --worktree -- :/
```

#### What changed

- <a id="tut-04.10-README.md-8ec9a0"></a>`README.md`: the row of the tests. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/1fef13ae49e24d280d05c250289c41d5636feff7/README.md).
  - look at ``| `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |``

<details open><summary>The patch to <code>README.md</code></summary>

```diff
@@ -66,7 +66,7 @@ help of the program itself. A recipe gives its extra words to the tool behind it
 | `src/babykev/api.py` | The contract: the request and its three types of question as pydantic models, the text and options the model reads, and the answers made from its probabilities |
 | `src/babykev/cli.py` | The command `babykev` |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
-| `tests/unit/` | The unit tests. `test_cli.py` tests the command `babykev` |
+| `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `README.md` | This file |
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1fef13ae49e24d280d05c250289c41d5636feff7).

This part ends at the code at `tut-04`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-04)

<a id="tut-05.1-to-tut-05.7"></a>

## 5.1 to 5.7 From a request to text for the model

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-04`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-04)

```bash
just setup
```

The model reads text, and picks between options. So each question becomes a list of options. A noul becomes `no` and
`yes`. A choice becomes one option for each name in its `criteria`, and a score becomes one option for each of its
levels. `api.py` already does this, because the whole file came in one move, in the section on the contract in
pydantic. The moves of this section add the tests that show it.

<a id="tut-05.1"></a>

### 5.1 render turns JSON into text

The model reads text, and the state of a request is JSON. `render` writes JSON as text. One test gives `render` nine
values, from `None` to a list of objects, and checks the text of each.

Apply the patch to [`tests/unit/test_api.py`](#tut-05.1-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/9f861048b50c3705e7e1195ccbd90a7b01e60180.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the section `# Rendering` and its test at the end of the file, and `render` to the import.

```bash
just test -k render
```

pytest prints `9 passed`, one for each value.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 9f861048b50c
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-04 --staged -- :/ && git restore --source 9f861048b50c --staged --worktree -- :/
```

#### What changed

- <a id="tut-05.1-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: nine values, and their text. 26 lines added. [The file](https://github.com/rahuldave/babykev/blob/9f861048b50c3705e7e1195ccbd90a7b01e60180/tests/unit/test_api.py).
  - look at `def test_render_flattens_json_into_text(value, text):`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -12,6 +12,7 @@ from babykev.api import (
     Noul,
     Score,
     SystemOneRequest,
+    render,
     to_record,
 )
 
@@ -111,3 +112,28 @@ def test_score_with_one_level_is_rejected():
     """A scale needs at least two levels."""
     with pytest.raises(ValidationError):
         Score(type="score", instructions="How firm?", criteria=["Soft"])
+
+
+# Rendering
+
+
+@pytest.mark.parametrize(
+    ("value", "text"),
+    [
+        (None, ""),
+        ("Brie", "Brie"),
+        (3, "3"),
+        (2.5, "2.5"),
+        (True, "True"),
+        (["creamy", "soft"], "- creamy\n- soft"),
+        ({"cheese": "Brie", "age": 4}, "cheese: Brie\nage: 4"),
+        (
+            {"cheese": "Brie", "notes": {"texture": ["creamy", "soft"]}},
+            "cheese: Brie\nnotes:\n  texture:\n    - creamy\n    - soft",
+        ),
+        ([{"role": "customer", "content": "hello"}], "- role: customer\n  content: hello"),
+    ],
+)
+def test_render_flattens_json_into_text(value, text):
+    """Strings, numbers, lists and objects all become the text the model reads."""
+    assert render(value) == text
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9f861048b50c3705e7e1195ccbd90a7b01e60180). [The code after it](https://github.com/rahuldave/babykev/tree/9f861048b50c3705e7e1195ccbd90a7b01e60180).

<a id="tut-05.2"></a>

### 5.2 An option has a description only when it has one

An option is its name, followed by its description when it has one. `option_text` writes it. The test gives it no
description, an empty one, and a real one.

Apply the patch to [`tests/unit/test_api.py`](#tut-05.2-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/e6270727deb4467393c6c7b73cfaf0908392387f.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file, and `option_text` to the import.

```bash
just test -k option_text
```

pytest prints `3 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check e6270727deb4
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 9f861048b50c --staged -- :/ && git restore --source e6270727deb4 --staged --worktree -- :/
```

#### What changed

- <a id="tut-05.2-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: three cases of an option. 14 lines added. [The file](https://github.com/rahuldave/babykev/blob/e6270727deb4467393c6c7b73cfaf0908392387f/tests/unit/test_api.py).
  - look at `def test_option_text_adds_a_description_only_when_there_is_one(name, description, text):`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -12,6 +12,7 @@ from babykev.api import (
     Noul,
     Score,
     SystemOneRequest,
+    option_text,
     render,
     to_record,
 )
@@ -137,3 +138,16 @@ def test_score_with_one_level_is_rejected():
 def test_render_flattens_json_into_text(value, text):
     """Strings, numbers, lists and objects all become the text the model reads."""
     assert render(value) == text
+
+
+@pytest.mark.parametrize(
+    ("name", "description", "text"),
+    [
+        ("cow", None, "cow"),
+        ("cow", "", "cow"),
+        ("mixed", "More than one kind of milk", "mixed: More than one kind of milk"),
+    ],
+)
+def test_option_text_adds_a_description_only_when_there_is_one(name, description, text):
+    """An option is its name, followed by its description when it has one."""
+    assert option_text(name, description) == text
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e6270727deb4467393c6c7b73cfaf0908392387f). [The code after it](https://github.com/rahuldave/babykev/tree/e6270727deb4467393c6c7b73cfaf0908392387f).

<a id="tut-05.3"></a>

### 5.3 A record keeps the state and the order of questions

`to_record` turns a request into a record, the text and options that the model reads, and the metadata that maps
them back. The test checks that the state is rendered once, and that the questions keep their order.

Apply the patch to [`tests/unit/test_api.py`](#tut-05.3-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/3d272bd2edaf22b970b8888429dd23940ffd3f17.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the section `# From a request to a record` and its test at the end of the file.

```bash
just test -k keeps_the_state
```

pytest prints `1 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 3d272bd2edaf
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source e6270727deb4 --staged -- :/ && git restore --source 3d272bd2edaf --staged --worktree -- :/
```

#### What changed

- <a id="tut-05.3-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the state, and the order. 15 lines added. [The file](https://github.com/rahuldave/babykev/blob/3d272bd2edaf22b970b8888429dd23940ffd3f17/tests/unit/test_api.py).
  - look at `assert [m["id"] for m in meta] == ["blue", "milk", "firmness"]`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -151,3 +151,18 @@ def test_render_flattens_json_into_text(value, text):
 def test_option_text_adds_a_description_only_when_there_is_one(name, description, text):
     """An option is its name, followed by its description when it has one."""
     assert option_text(name, description) == text
+
+
+# From a request to a record
+
+
+def test_record_keeps_the_state_and_the_order_of_questions():
+    """The state is rendered once and the questions stay in request order."""
+    record, meta = to_record(cheese_request())
+    assert record["state"] == "cheese: Roquefort\norigin: France"
+    assert [m["id"] for m in meta] == ["blue", "milk", "firmness"]
+    assert [q["instr"] for q in record["questions"]] == [
+        "Is this a blue cheese?",
+        "Which milk?",
+        "How firm?",
+    ]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3d272bd2edaf22b970b8888429dd23940ffd3f17). [The code after it](https://github.com/rahuldave/babykev/tree/3d272bd2edaf22b970b8888429dd23940ffd3f17).

<a id="tut-05.4"></a>

### 5.4 A noul becomes no, then yes

A noul has two options, `no` first and `yes` second. The code counts the options from 0, so `yes` is option 1. The
answer to a noul is the probability of option 1.

Apply the patch to [`tests/unit/test_api.py`](#tut-05.4-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/7dee26abd961a5a85d897f82332ae46e556e2f80.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test -k no_then_yes
```

pytest prints `1 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 7dee26abd961
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 3d272bd2edaf --staged -- :/ && git restore --source 7dee26abd961 --staged --worktree -- :/
```

#### What changed

- <a id="tut-05.4-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the two options of a noul. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/7dee26abd961a5a85d897f82332ae46e556e2f80/tests/unit/test_api.py).
  - look at `assert record["questions"][0]["options"] == ["no", "yes"]`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -166,3 +166,10 @@ def test_record_keeps_the_state_and_the_order_of_questions():
         "Which milk?",
         "How firm?",
     ]
+
+
+def test_noul_becomes_no_then_yes():
+    """Option 0 is no and option 1 is yes, so the answer is the probability of option 1."""
+    record, meta = to_record(cheese_request())
+    assert record["questions"][0]["options"] == ["no", "yes"]
+    assert meta[0] == {"id": "blue", "type": "noul"}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7dee26abd961a5a85d897f82332ae46e556e2f80). [The code after it](https://github.com/rahuldave/babykev/tree/7dee26abd961a5a85d897f82332ae46e556e2f80).

<a id="tut-05.5"></a>

### 5.5 The criteria of a noul describe no and yes

A noul can say what yes and no mean, under `true` and `false`. They become the descriptions of the two options.

Apply the patch to [`tests/unit/test_api.py`](#tut-05.5-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/f9b390d64cc717326b28f9c7a6adbb88de59363f.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test -k describe_no
```

pytest prints `1 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check f9b390d64cc7
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 7dee26abd961 --staged -- :/ && git restore --source f9b390d64cc7 --staged --worktree -- :/
```

#### What changed

- <a id="tut-05.5-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the descriptions of no and yes. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/f9b390d64cc717326b28f9c7a6adbb88de59363f/tests/unit/test_api.py).
  - look at `def test_noul_criteria_describe_no_and_yes():`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -173,3 +173,12 @@ def test_noul_becomes_no_then_yes():
     record, meta = to_record(cheese_request())
     assert record["questions"][0]["options"] == ["no", "yes"]
     assert meta[0] == {"id": "blue", "type": "noul"}
+
+
+def test_noul_criteria_describe_no_and_yes():
+    """The criteria under `false` and `true` become the descriptions of no and yes."""
+    criteria = {"true": "It has blue veins", "false": "It has none"}
+    question = {"type": "noul", "instructions": "Is it blue?", "criteria": criteria}
+    request = SystemOneRequest.model_validate({"state": "Brie", "questions": {"blue": question}})
+    record, _ = to_record(request)
+    assert record["questions"][0]["options"] == ["no: It has none", "yes: It has blue veins"]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f9b390d64cc717326b28f9c7a6adbb88de59363f). [The code after it](https://github.com/rahuldave/babykev/tree/f9b390d64cc717326b28f9c7a6adbb88de59363f).

<a id="tut-05.6"></a>

### 5.6 A choice becomes one option per criterion

A choice has one option for each criterion, in order, and the metadata keeps their names.

Apply the patch to [`tests/unit/test_api.py`](#tut-05.6-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/0930c8de69e9710470eb60380b99cae5c3e82558.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test -k one_option_per_criterion
```

pytest prints `1 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 0930c8de69e9
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source f9b390d64cc7 --staged -- :/ && git restore --source 0930c8de69e9 --staged --worktree -- :/
```

#### What changed

- <a id="tut-05.6-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the options of a choice. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/0930c8de69e9710470eb60380b99cae5c3e82558/tests/unit/test_api.py).
  - look at `def test_choice_becomes_one_option_per_criterion_in_order():`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -182,3 +182,15 @@ def test_noul_criteria_describe_no_and_yes():
     request = SystemOneRequest.model_validate({"state": "Brie", "questions": {"blue": question}})
     record, _ = to_record(request)
     assert record["questions"][0]["options"] == ["no: It has none", "yes: It has blue veins"]
+
+
+def test_choice_becomes_one_option_per_criterion_in_order():
+    """Options keep the order of the criteria, and the metadata remembers their names."""
+    record, meta = to_record(cheese_request())
+    assert record["questions"][1]["options"] == [
+        "cow",
+        "goat",
+        "sheep",
+        "mixed: More than one kind of milk",
+    ]
+    assert meta[1] == {"id": "milk", "type": "choice", "keys": ["cow", "goat", "sheep", "mixed"]}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0930c8de69e9710470eb60380b99cae5c3e82558). [The code after it](https://github.com/rahuldave/babykev/tree/0930c8de69e9710470eb60380b99cae5c3e82558).

<a id="tut-05.7"></a>

### 5.7 A score becomes one option per level

A score has one option for each level, in order. Its legend maps the number of each level to its name.

Apply the patch to [`tests/unit/test_api.py`](#tut-05.7-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/8368a8202dab8159f95043310e2bf22a24c1e474.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test -k one_option_per_level
```

pytest prints `1 passed`.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 8368a8202dab
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 0930c8de69e9 --staged -- :/ && git restore --source 8368a8202dab --staged --worktree -- :/
```

#### What changed

- <a id="tut-05.7-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the levels, and the legend. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/8368a8202dab8159f95043310e2bf22a24c1e474/tests/unit/test_api.py).
  - look at `def test_score_becomes_one_option_per_level_with_a_legend():`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -194,3 +194,10 @@ def test_choice_becomes_one_option_per_criterion_in_order():
         "mixed: More than one kind of milk",
     ]
     assert meta[1] == {"id": "milk", "type": "choice", "keys": ["cow", "goat", "sheep", "mixed"]}
+
+
+def test_score_becomes_one_option_per_level_with_a_legend():
+    """Options are the levels in order, and the legend maps each index to its level."""
+    record, meta = to_record(cheese_request())
+    assert record["questions"][2]["options"] == FIRMNESS
+    assert meta[2]["legend"] == {"0": "Soft", "1": "Semi-soft", "2": "Semi-hard", "3": "Hard"}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/8368a8202dab8159f95043310e2bf22a24c1e474).

This part ends at the code at `8368a8202dab`, partway through `tut-05`. [The code after this part](https://github.com/rahuldave/babykev/tree/8368a8202dab8159f95043310e2bf22a24c1e474)

<a id="tut-05.8-to-tut-05.11"></a>

## 5.8 to 5.11 From probabilities back to answers

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `8368a8202dab`, partway through `tut-05`. [The code before this part](https://github.com/rahuldave/babykev/tree/8368a8202dab8159f95043310e2bf22a24c1e474)

```bash
just setup
```

The model gives a probability for each option. The function `to_answers`, in `api.py`, turns them into an answer of
the type of each question. The moves of this section add a test for each type.

<a id="tut-05.8"></a>

### 5.8 The answer of a noul is the probability of yes

`to_answers` turns the probabilities of the model into answers. The answer to a noul is one number, the probability of
yes.

Apply the patch to [`tests/unit/test_api.py`](#tut-05.8-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/0740c2c246273e99e34494512152d5b97ea4f7b9.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the section `# From probabilities to answers` and its test at the end of the file, and `to_answers` to
the import.

```bash
just test
```

`just test` prints `40 passed`, and `api.py` is at 86%.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 0740c2c24627
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 8368a8202dab --staged -- :/ && git restore --source 0740c2c24627 --staged --worktree -- :/
```

#### What changed

- <a id="tut-05.8-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the answer of a noul. 10 lines added. [The file](https://github.com/rahuldave/babykev/blob/0740c2c246273e99e34494512152d5b97ea4f7b9/tests/unit/test_api.py).
  - look at `assert answers == {"blue": {"type": "noul", "noul": 0.75}}`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -14,6 +14,7 @@ from babykev.api import (
     SystemOneRequest,
     option_text,
     render,
+    to_answers,
     to_record,
 )
 
@@ -201,3 +202,12 @@ def test_score_becomes_one_option_per_level_with_a_legend():
     record, meta = to_record(cheese_request())
     assert record["questions"][2]["options"] == FIRMNESS
     assert meta[2]["legend"] == {"0": "Soft", "1": "Semi-soft", "2": "Semi-hard", "3": "Hard"}
+
+
+# From probabilities to answers
+
+
+def test_noul_answer_is_the_probability_of_yes():
+    """The answer to a yes-or-no question is one number."""
+    answers = to_answers([[0.25, 0.75]], [{"id": "blue", "type": "noul"}])
+    assert answers == {"blue": {"type": "noul", "noul": 0.75}}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0740c2c246273e99e34494512152d5b97ea4f7b9). [The code after it](https://github.com/rahuldave/babykev/tree/0740c2c246273e99e34494512152d5b97ea4f7b9).

<a id="tut-05.9"></a>

### 5.9 A choice names the most likely option

The answer to a choice has its most likely option, a probability for each option, and a confidence.

Apply the patch to [`tests/unit/test_api.py`](#tut-05.9-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/a27b71f6a341bb12029a2d3471d6b3bc19d0d94c.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test
```

`just test` prints `41 passed`, and `api.py` is at 94%.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check a27b71f6a341
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 0740c2c24627 --staged -- :/ && git restore --source a27b71f6a341 --staged --worktree -- :/
```

#### What changed

- <a id="tut-05.9-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the answer of a choice. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/a27b71f6a341bb12029a2d3471d6b3bc19d0d94c/tests/unit/test_api.py).
  - look at `assert answer["choice"] == "goat"`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -211,3 +211,12 @@ def test_noul_answer_is_the_probability_of_yes():
     """The answer to a yes-or-no question is one number."""
     answers = to_answers([[0.25, 0.75]], [{"id": "blue", "type": "noul"}])
     assert answers == {"blue": {"type": "noul", "noul": 0.75}}
+
+
+def test_choice_answer_names_the_most_likely_option():
+    """A choice answer has the winner, a probability for each option, and a confidence."""
+    meta = [{"id": "milk", "type": "choice", "keys": ["cow", "goat", "sheep"]}]
+    answer = to_answers([[0.1, 0.7, 0.2]], meta)["milk"]
+    assert answer["choice"] == "goat"
+    assert answer["probabilities"] == {"cow": 0.1, "goat": 0.7, "sheep": 0.2}
+    assert answer["confidence"] == pytest.approx(0.55)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a27b71f6a341bb12029a2d3471d6b3bc19d0d94c). [The code after it](https://github.com/rahuldave/babykev/tree/a27b71f6a341bb12029a2d3471d6b3bc19d0d94c).

<a id="tut-05.10"></a>

### 5.10 A score answers with the expected level

The answer to a score is the expected level, the mean of the levels weighted by their probabilities. For
`[0.1, 0.2, 0.7]` it is 0 × 0.1 + 1 × 0.2 + 2 × 0.7 = 1.6.

Apply the patch to [`tests/unit/test_api.py`](#tut-05.10-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/be8c681092973e7ac1e12bbd1817da81bea45e7e.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test
```

`just test` prints `42 passed`, and `api.py` is at 100%.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check be8c68109297
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source a27b71f6a341 --staged -- :/ && git restore --source be8c68109297 --staged --worktree -- :/
```

#### What changed

- <a id="tut-05.10-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the answer of a score. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/be8c681092973e7ac1e12bbd1817da81bea45e7e/tests/unit/test_api.py).
  - look at `assert answer["score"] == pytest.approx(1.6)`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -220,3 +220,14 @@ def test_choice_answer_names_the_most_likely_option():
     assert answer["choice"] == "goat"
     assert answer["probabilities"] == {"cow": 0.1, "goat": 0.7, "sheep": 0.2}
     assert answer["confidence"] == pytest.approx(0.55)
+
+
+def test_score_answer_is_the_expected_level():
+    """A score answer is the mean level under the probabilities, with the legend to read it by."""
+    legend = {"0": "Soft", "1": "Semi-soft", "2": "Hard"}
+    answer = to_answers([[0.1, 0.2, 0.7]], [{"id": "firmness", "type": "score", "legend": legend}])[
+        "firmness"
+    ]
+    assert answer["score"] == pytest.approx(1.6)
+    assert answer["legend"] == legend
+    assert answer["probabilities"] == {"0": 0.1, "1": 0.2, "2": 0.7}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/be8c681092973e7ac1e12bbd1817da81bea45e7e). [The code after it](https://github.com/rahuldave/babykev/tree/be8c681092973e7ac1e12bbd1817da81bea45e7e).

<a id="tut-05.11"></a>

### 5.11 Every question gets an answer of its own type

A request of three questions must get three answers, each under the id of its question, each of its type. The test
runs `to_record` and `to_answers` one after the other.

Apply the patch to [`tests/unit/test_api.py`](#tut-05.11-tests-unit-test_api.py-58d97c), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/c2f89d37a513382eb2209c2c393e6a4c5a6eb50f.diff | git apply --include=tests/unit/test_api.py
```

The patch adds the test at the end of the file.

```bash
just test
```

`just test` prints `43 passed`, and every line of `api.py` runs, 100%. Two lines are still wrong, and the next part
shows them. Coverage says which lines ran. It does not say that a test checked what each line does.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check c2f89d37a513
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git fetch --quiet --tags --force origin; git restore --source be8c68109297 --staged -- :/ && git restore --source tut-05 --staged --worktree -- :/
```

#### What changed

- <a id="tut-05.11-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: one answer for each question. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/c2f89d37a513382eb2209c2c393e6a4c5a6eb50f/tests/unit/test_api.py).
  - look at `def test_every_question_gets_an_answer_of_its_own_type():`

<details open><summary>The patch to <code>tests/unit/test_api.py</code></summary>

```diff
@@ -231,3 +231,15 @@ def test_score_answer_is_the_expected_level():
     assert answer["score"] == pytest.approx(1.6)
     assert answer["legend"] == legend
     assert answer["probabilities"] == {"0": 0.1, "1": 0.2, "2": 0.7}
+
+
+def test_every_question_gets_an_answer_of_its_own_type():
+    """Records and answers line up: one answer per question, under the question's id."""
+    record, meta = to_record(cheese_request())
+    uniform = [[1 / len(q["options"])] * len(q["options"]) for q in record["questions"]]
+    answers = to_answers(uniform, meta)
+    assert {qid: a["type"] for qid, a in answers.items()} == {
+        "blue": "noul",
+        "milk": "choice",
+        "firmness": "score",
+    }
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c2f89d37a513382eb2209c2c393e6a4c5a6eb50f).

This part ends at the code at `tut-05`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-05)

<a id="tut-10.3"></a>

## 10.3 The classes of a request say what they are

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `7943e585faa8`, partway through `tut-10`. [The code before this part](https://github.com/rahuldave/babykev/tree/7943e585faa81e4c0400f5e2e9ca7b42ce4bf286)

This part does not start where the part before it ends, because the walk skips some changes. This command puts the files that this part starts from in place of yours. Run it, and then go on:

```bash
git fetch --quiet --tags --force origin; git restore --source tut-05 --staged -- :/ && git restore --source 7943e585faa8 --staged --worktree -- :/
```

```bash
just setup
```

The whole tutorial then fixed two bugs in the answers, one in the rounding of the probabilities and one in the
confidence of a score.

It brought in ruff, a tool that formats the code and checks it against rules. Then it wrote down, for every function,
the kind of value that each input and the result hold. The tests grew to 53.

Then the whole tutorial turned on the rules `D1` of ruff. They ask for a docstring on every public file, class and
function. A name is public when it does not start with `_`. The package, the folder `src/babykev` that holds the code,
got its docstring first.

### 10.3 The docstrings of the four classes of a request

`D101`: `Noul`, `Choice`, `Score` and `SystemOneRequest` are the classes of a request, and none has a docstring.
Each gets one line, under its `class` line, that says what it is.

Apply the patch to [`src/babykev/api.py`](#tut-10.3-src-babykev-api.py-2ea65f), from the top of the project:

```bash
curl -fsSL https://github.com/rahuldave/babykev/commit/9a769c7d9551fb181bf7c36d989f94f35f836c2d.diff | git apply --include=src/babykev/api.py
```

In `src/babykev/api.py`, the patch adds a docstring and a blank line under each of the four lines `class ...`.

```bash
uv run python -c "from babykev.api import Score; print(Score.__doc__)"
just lint --statistics
```

`uv run python -c` prints the docstring of `Score`, `A question answered by a level of a scale, whose criteria are
the levels in order.` `just lint --statistics` prints 3 problems, all `D103`.

The four classes of a request now say what they are. There is one class for the request, and one for each of the three
types of question. Their docstrings stand in the code, and Python's own function `help()` prints them. The contract is
now whole. It says what a request holds, what it refuses, and how the model's probabilities become an answer for each
question.

Check your files against this move. The command prints nothing when they match, and otherwise shows what differs:

```bash
git check 9a769c7d9551
```

If you are stuck, this command puts the files of this move in place of yours. A file that you made yourself stays:

```bash
git restore --source 7943e585faa8 --staged -- :/ && git restore --source 9a769c7d9551 --staged --worktree -- :/
```

#### What changed

- <a id="tut-10.3-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a docstring on each class of a request. 8 lines added. [The file](https://github.com/rahuldave/babykev/blob/9a769c7d9551fb181bf7c36d989f94f35f836c2d/src/babykev/api.py).
  - look at `    """A question answered by a level of a scale, whose criteria are the levels in order."""`

<details open><summary>The patch to <code>src/babykev/api.py</code></summary>

```diff
@@ -14,12 +14,16 @@ MAX_OPTIONS = 255
 
 
 class Noul(BaseModel):
+    """A question of yes or no. Its criteria, if it has them, describe false and true."""
+
     type: Literal["noul"]
     instructions: JSONContent
     criteria: dict[str, JSONContent] | None = None
 
 
 class Choice(BaseModel):
+    """A question answered by one of its options, named in its criteria."""
+
     type: Literal["choice"]
     instructions: JSONContent
     criteria: dict[str, JSONContent]
@@ -32,6 +36,8 @@ class Choice(BaseModel):
 
 
 class Score(BaseModel):
+    """A question answered by a level of a scale, whose criteria are the levels in order."""
+
     type: Literal["score"]
     instructions: JSONContent
     criteria: list[JSONContent] = Field(min_length=2, max_length=MAX_OPTIONS)
@@ -41,6 +47,8 @@ Question = Noul | Choice | Score
 
 
 class SystemOneRequest(BaseModel):
+    """One request: a state, and the questions to answer about it, each by its name."""
+
     state: JSONContent
     questions: dict[str, Question] = Field(min_length=1)
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9a769c7d9551fb181bf7c36d989f94f35f836c2d).

This part ends at the code at `9a769c7d9551`, partway through `tut-10`. [The code after this part](https://github.com/rahuldave/babykev/tree/9a769c7d9551fb181bf7c36d989f94f35f836c2d)
