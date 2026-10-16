<!-- Made by the walk skill's render.py from the facts of the walk. Do not edit it by hand: run just walk-update again. -->

# babykev, shown one move at a time

**Read the tutorial.** Each change explained, with the code to look at. [Build it yourself](build.md) is the other way to read it.

Each part ends with a section called **What changed**. It lists every file that the part changes, with a link to the file, and then the whole diff of each file, folded. A lockfile and a binary file have a link alone. The text above it explains the change.

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

<a id="tut-00"></a>

## 0 Where we start

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

[The code](https://github.com/rahuldave/babykev/tree/70ac5b0a0a1d927dfc4da6f8b7b92344917e4a33).

<a id="tut-01"></a>

## 1 The project

babykev must be a Python project before it can hold code. uv makes the project. Then babykev gets its words, its
command, and a justfile that names the tasks of the project.

There is no justfile until the ninth move, so do not run `just` in the project before then. `just` looks for a
justfile in the folder, and then in the folders above it. In the walk repository, the folder above the project has a
justfile of its own. So an early `just setup` runs that recipe, and not one of babykev.

[The code before this part](https://github.com/rahuldave/babykev/tree/70ac5b0a0a1d927dfc4da6f8b7b92344917e4a33). [The code after it](https://github.com/rahuldave/babykev/tree/7ad3a06605fadc9f34b5e2d8180145a3e53389a9).

<a id="tut-01.1"></a>

### 1.1 uv makes the project

The folder has words and a licence, but nothing that Python can build or run. `uv init` makes the files of a Python
project. `--package` makes a package in `src/babykev/`, with a command that runs its function `main`.
`--name babykev` names the project, and `--python 3.13` sets the version of Python.

This change came from running `uv init --package --name babykev --python 3.13`.

`uv init` leaves the README alone, because the project has one.

The command made three files. `pyproject.toml` names the project, its Python and its command.
`src/babykev/__init__.py` holds `main`, which prints a greeting. `.python-version` says `3.13`.

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

`git status --short` prints nothing, because git already holds the new files.

#### What changed

- <a id="tut-01.1-.python-version-7696e9"></a>`.python-version`: `3.13`, the version of Python that uv installs for the project. New, 1 line. It comes from `uv init --package --name babykev --python 3.13`. [The file](https://github.com/rahuldave/babykev/blob/eac75e0becc78c9a872e734ea715ac3903947844/.python-version).
- <a id="tut-01.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: `[project.scripts]` makes a command `babykev` that runs `main` of the package `babykev`. `[build-system]` names `uv_build`, the tool that builds the package. New, 14 lines. It comes from `uv init --package --name babykev --python 3.13`. [The file](https://github.com/rahuldave/babykev/blob/eac75e0becc78c9a872e734ea715ac3903947844/pyproject.toml).
  - look at `babykev = "babykev:main"`
- <a id="tut-01.1-src-babykev-__init__.py-a40393"></a>`src/babykev/__init__.py`: the function that the command runs. It prints a greeting. New, 2 lines. It comes from `uv init --package --name babykev --python 3.13`. [The file](https://github.com/rahuldave/babykev/blob/eac75e0becc78c9a872e734ea715ac3903947844/src/babykev/__init__.py).
  - look at `print("Hello from babykev!")`

<details><summary>The diff of <code>.python-version</code></summary>

```diff
@@ -0,0 +1 @@
+3.13
```

</details>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

<details><summary>The diff of <code>src/babykev/__init__.py</code></summary>

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

This change came from running `uv lock`.

The new file `uv.lock` has one package, babykev, from this folder.

```bash
uv run babykev
```

`uv run` makes `.venv`, the environment of the project. It builds babykev, installs it into `.venv`, and runs the
command. It prints `Using CPython 3.13.3`, `Creating virtual environment at: .venv`, `Building babykev`,
`Built babykev` and `Installed 1 package`. Then comes the greeting, `Hello from babykev!`.

The version of Python on your machine can differ. If you ran a later part before, `.venv` is there already. `uv run`
then changes the packages of `.venv` to match, and does not print `Creating virtual environment`.

#### What changed

- <a id="tut-01.2-uv.lock-8356d8"></a>`uv.lock`: babykev itself, installed from this folder. `editable` means that a change to the code shows at the next run, with no new install. New, 8 lines. It comes from `uv lock`. [The file](https://github.com/rahuldave/babykev/blob/489f27fad816149652a8d608b162fa98c37563f5/uv.lock).
  - look at `source = { editable = "." }`

[This change on GitHub](https://github.com/rahuldave/babykev/commit/489f27fad816149652a8d608b162fa98c37563f5). [The code after it](https://github.com/rahuldave/babykev/tree/489f27fad816149652a8d608b162fa98c37563f5).

<a id="tut-01.3"></a>

### 1.3 The description of babykev

`pyproject.toml` still has the words of uv. Its description is a placeholder, `Add your description here`. The patch
puts in what babykev is.

A patch to [`pyproject.toml`](#tut-01.3-pyproject.toml-5d07e7).

In `pyproject.toml`, the line `description` now says what babykev is.

```bash
grep -n description pyproject.toml
```

`grep` prints the new description, with its line number.

#### What changed

- <a id="tut-01.3-pyproject.toml-5d07e7"></a>`pyproject.toml`: the description. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/0497c0dc9d3772df47e79361aa4165e5de8e227d/pyproject.toml).
  - look at `description = "A small decision model: one state, typed questions, a probability for every answer"`

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

A patch to [`pyproject.toml`](#tut-01.4-pyproject.toml-5d07e7).

In `pyproject.toml`, `license` and `license-files` now stand under `readme`.

```bash
grep -n license pyproject.toml
```

`grep` prints the two lines, with their numbers. The Build it yourself page sets them with a command, which can put
them at the end of `[project]`, so the numbers can differ.

#### What changed

- <a id="tut-01.4-pyproject.toml-5d07e7"></a>`pyproject.toml`: the licence, and the files a package carries. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/414874463b887dedf65c5c74caeac8a064b0e876/pyproject.toml).
  - look at `license-files = ["LICENSE", "NOTICE"]`

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

A patch to [`pyproject.toml`](#tut-01.5-pyproject.toml-5d07e7).

In `pyproject.toml`, `authors` now stands under `license-files`.

```bash
uv lock --check
```

`uv lock --check` says whether `uv.lock` still matches `pyproject.toml`. It prints `Resolved 1 package`, and ends with
exit code 0. The words of the three moves change no dependency, so `uv.lock` stays as it was.

#### What changed

- <a id="tut-01.5-pyproject.toml-5d07e7"></a>`pyproject.toml`: the author. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/7f38877e597f5404208fdca2eabb176077d95a8e/pyproject.toml).
  - look at `authors = [{ name = "Rahul Dave" }]`

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7f38877e597f5404208fdca2eabb176077d95a8e). [The code after it](https://github.com/rahuldave/babykev/tree/7f38877e597f5404208fdca2eabb176077d95a8e).

<a id="tut-01.6"></a>

### 1.6 cli.py, the command with help

`babykev` only prints the greeting of uv. A command should say what it can do, and refuse a word it does not know. The
command gets a file of its own, `src/babykev/cli.py`. `main` there reads the words after `babykev`. With no word, or
with `help`, `--help` or `-h`, it prints `HELP`. Any other word ends with a message and exit code 2.

A patch to [`src/babykev/cli.py`](#tut-01.6-src-babykev-cli.py-a9e184).

The new file `src/babykev/cli.py` holds `HELP`, the text of the help, and `main` under it. The line
`raise SystemExit(2)` ends the command on a word it does not know.

Nothing runs the new `main` yet. Python can call it.

```bash
uv run python -c "from babykev.cli import main; main()"
uv run babykev
```

The first command prints the help. The second still prints `Hello from babykev!`, because the command still runs
the `main` of `__init__.py`.

#### What changed

- <a id="tut-01.6-src-babykev-cli.py-a9e184"></a>`src/babykev/cli.py`: `main` reads the words after `babykev`. A word other than `help`, `--help` or `-h` ends the command with exit code 2. New, 21 lines. [The file](https://github.com/rahuldave/babykev/blob/64a78cf48bc1b0f508dfd7b83c3a2b0572fb1912/src/babykev/cli.py).
  - look at `raise SystemExit(2)`

<details><summary>The diff of <code>src/babykev/cli.py</code></summary>

```diff
@@ -0,0 +1,21 @@
+"""The babykev command. `babykev help` says what it can do; every command arrives here."""
+
+import sys
+
+HELP = """\
+babykev: a small decision model. Context, typed questions, and a probability for every answer.
+
+usage: babykev COMMAND [FLAGS]
+       babykev help
+
+There are no commands yet.
+"""
+
+
+def main() -> None:
+    """Print the help, or refuse a command that does not exist yet."""
+    words = sys.argv[1:]
+    if words and words[0] not in ("help", "--help", "-h"):
+        print(f"babykev: no command named {words[0]!r}. Run `babykev help`.", file=sys.stderr)
+        raise SystemExit(2)
+    print(HELP, end="")
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/64a78cf48bc1b0f508dfd7b83c3a2b0572fb1912). [The code after it](https://github.com/rahuldave/babykev/tree/64a78cf48bc1b0f508dfd7b83c3a2b0572fb1912).

<a id="tut-01.7"></a>

### 1.7 The command babykev runs cli.py

The command still runs the greeting. One line of `pyproject.toml` points it at the new `main`.

A patch to [`pyproject.toml`](#tut-01.7-pyproject.toml-5d07e7).

In `pyproject.toml`, the command now runs `babykev.cli:main`.

```bash
uv run babykev help
uv run babykev train
```

`pyproject.toml` changed, so `uv run` builds babykev again, and prints `Building babykev`. Then it prints the help.
`babykev train` prints ``babykev: no command named 'train'. Run `babykev help`.`` and ends with exit code 2.

#### What changed

- <a id="tut-01.7-pyproject.toml-5d07e7"></a>`pyproject.toml`: the command now runs `main` of the module `cli`. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/292ddcc99a287378929f14e2082d40f0947a2880/pyproject.toml).
  - look at `babykev = "babykev.cli:main"`

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -10,7 +10,7 @@ requires-python = ">=3.13"
 dependencies = []
 
 [project.scripts]
-babykev = "babykev:main"
+babykev = "babykev.cli:main"
 
 [build-system]
 requires = ["uv_build>=0.12.13,<0.13.0"]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/292ddcc99a287378929f14e2082d40f0947a2880). [The code after it](https://github.com/rahuldave/babykev/tree/292ddcc99a287378929f14e2082d40f0947a2880).

<a id="tut-01.8"></a>

### 1.8 The greeting of uv goes

Nothing runs the `main` of `src/babykev/__init__.py` any more. Code that nothing runs only misleads a reader. The
patch takes its two lines out, and leaves the file empty, with not even a blank line.

A patch to [`src/babykev/__init__.py`](#tut-01.8-src-babykev-__init__.py-a40393).

`src/babykev/__init__.py` is empty. Python still needs the file, because it makes `src/babykev` a package.

```bash
wc -c src/babykev/__init__.py
uv run babykev
```

`wc -c` counts 0 bytes. `uv run babykev` prints the help, as before.

#### What changed

- <a id="tut-01.8-src-babykev-__init__.py-a40393"></a>`src/babykev/__init__.py`: the greeting goes, and the file is empty. 0 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/e32c7ba9f7983fc03cc8d91411562b1eac1d38e9/src/babykev/__init__.py).

<details><summary>The diff of <code>src/babykev/__init__.py</code></summary>

```diff
@@ -1,2 +0,0 @@
-def main() -> None:
-    print("Hello from babykev!")
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e32c7ba9f7983fc03cc8d91411562b1eac1d38e9). [The code after it](https://github.com/rahuldave/babykev/tree/e32c7ba9f7983fc03cc8d91411562b1eac1d38e9).

<a id="tut-01.9"></a>

### 1.9 A justfile with the recipe setup

The command that sets up the project is `uv sync --locked`, and nobody should have to remember it. A `justfile` names
each task of the project once. `just` reads the file. Each task is a recipe, a name and then the commands to run,
indented. We run the command of the first recipe by hand first.

```bash
uv sync --locked
```

`uv sync` makes `.venv` exactly as `uv.lock` says. `--locked` makes it refuse a `uv.lock` that no longer matches
`pyproject.toml`. Here it prints `Resolved 1 package` and `Checked 1 package`, because `.venv` is already right.

A patch to [`justfile`](#tut-01.9-justfile-424f0b).

`justfile` is new, with two recipes. `default` lists the others, and `setup` runs `uv sync --locked`.

`just` alone runs the first recipe, `default`, which lists the others. `[private]` keeps `default` out of the list.
The comment above a recipe is its line in the list. `[group('setup')]` puts the recipe under a heading.

```bash
just --show setup
just setup
just
```

`just --show setup` prints the recipe. `just setup` prints the command, `uv sync --locked`, then runs it. `just` lists
the one recipe, under `[setup]`.

#### What changed

- <a id="tut-01.9-justfile-424f0b"></a>`justfile`: the recipe `setup` and its line. New, 10 lines. [The file](https://github.com/rahuldave/babykev/blob/e14dffa877a2d24a53d67d8dd3d54b17204885b1/justfile).
  - look at `setup:`

<details><summary>The diff of <code>justfile</code></summary>

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
the recipe `setup`, and `just help` alone prints the list. `help` reads the name of a recipe as `"$1"`. So
`set positional-arguments` gives each word after the name of a recipe to its commands whole.

A patch to [`justfile`](#tut-01.10-justfile-424f0b).

In `justfile`, `set positional-arguments` now stands near the top, and the recipe `help` comes after `default`. The
first line of the file now names `just help VERB`.

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

#### What changed

- <a id="tut-01.10-justfile-424f0b"></a>`justfile`: the recipe `help`. 12 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/a55c90355687e4bf94dfad2277262548ba4ea682/justfile).
  - look at `help *verb:`

<details><summary>The diff of <code>justfile</code></summary>

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

A patch to [`justfile`](#tut-01.11-justfile-424f0b).

In `justfile`, `setup` takes `*args`. Its one line runs `just help setup` for the word `help`, and
`uv sync --locked` for anything else.

```bash
just setup help
just setup
```

`just setup help` prints the line of `setup`. `just setup` prints `Resolved 1 package` and `Checked 1 package`. It no
longer prints `uv sync --locked` first, because of the `@`.

#### What changed

- <a id="tut-01.11-justfile-424f0b"></a>`justfile`: `setup` answers `help`. 2 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/3016e7ee53854d719456c12a48c8c8e620614bde/justfile).
  - look at `@{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}`

<details><summary>The diff of <code>justfile</code></summary>

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

A patch to [`justfile`](#tut-01.12-justfile-424f0b).

In `justfile`, `program := "babykev"` stands near the top. `help` now ends with an `if` that runs
`uv run {{ program }} "$1" help`.

`just` replaces each `{{ ... }}` in a recipe with its value. So the text `{{ program }}` cannot stand in a recipe as it
is. `{{ "{{ program }}" }}` is a value in quotes, and `just` writes it as the text `{{ program }}`. No recipe runs the
program yet, so the new branch waits for one.

```bash
just --evaluate program
just help setup
```

`just --evaluate program` prints `babykev`. `just help setup` prints the line of `setup`, as before.

#### What changed

- <a id="tut-01.12-justfile-424f0b"></a>`justfile`: the variable `program`, and the branch of `help` that runs the program's help. 6 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/9218f21a784277593cf6930e10389b04e41bf9d0/justfile).
  - look at `program := "babykev"`

<details><summary>The diff of <code>justfile</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9218f21a784277593cf6930e10389b04e41bf9d0). [The code after it](https://github.com/rahuldave/babykev/tree/9218f21a784277593cf6930e10389b04e41bf9d0).

<a id="tut-01.13"></a>

### 1.13 The README says how to start

A reader of the README cannot yet tell how to start. A section, "Start", says to run `just setup` first, and names
`just`, `just help VERB` and the help of the program.

A patch to [`README.md`](#tut-01.13-README.md-8ec9a0).

In `README.md`, "Start" says to run `just setup` first, and then names `just`, `just help VERB` and
`uv run babykev help`.

```bash
grep -n '^## ' README.md
```

`grep` prints the headings of the README, with "Start" among them.

#### What changed

- <a id="tut-01.13-README.md-8ec9a0"></a>`README.md`: how to start. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/0d2e163cca5d3eeb9fc8f7223fddd8d7da735fde/README.md).
  - look at ``Run `just setup` first. It installs Python and every dependency into `.venv`, exactly as `uv.lock` says.``

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -51,6 +51,12 @@ Install two tools on your machine, uv and just. The project installs everything
 | [uv](https://docs.astral.sh/uv/) | Python itself, the dependencies, and running the program |
 | [just](https://just.systems/) | The tasks of the project. `just` lists them |
 
+## Start
+
+Run `just setup` first. It installs Python and every dependency into `.venv`, exactly as `uv.lock` says.
+Then `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is the help of the
+program itself.
+
 ## How the history is organised
 
 The project is built in steps, on the branch `tutorial`. Each step has a tag, `tut-00`, `tut-01` and so
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0d2e163cca5d3eeb9fc8f7223fddd8d7da735fde). [The code after it](https://github.com/rahuldave/babykev/tree/0d2e163cca5d3eeb9fc8f7223fddd8d7da735fde).

<a id="tut-01.14"></a>

### 1.14 The README says what each file is

A reader still cannot tell what each file of the project is. A section, "What is here", has a table, with a row for
each file.

A patch to [`README.md`](#tut-01.14-README.md-8ec9a0).

In `README.md`, "What is here" is a table of the files of the project, from `pyproject.toml` to `.gitignore`.

```bash
just setup
uv run babykev help
```

Both commands of "Start" work. `just setup` prints `Resolved 1 package` and `Checked 1 package`, and
`uv run babykev help` prints the help.

#### What changed

- <a id="tut-01.14-README.md-8ec9a0"></a>`README.md`: a table of the files. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/7ad3a06605fadc9f34b5e2d8180145a3e53389a9/README.md).
  - look at ``| `justfile` | Every task of the project, one recipe each. `just help` explains them |``

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -57,6 +57,18 @@ Run `just setup` first. It installs Python and every dependency into `.venv`, ex
 Then `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is the help of the
 program itself.
 
+## What is here
+
+| Path | What it is |
+|---|---|
+| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, and the exact versions to install |
+| `src/babykev/` | The code. `cli.py` is the command `babykev` |
+| `justfile` | Every task of the project, one recipe each. `just help` explains them |
+| `README.md` | This file |
+| `LICENSE`, `NOTICE` | The licence, and the credit to kev |
+| `.python-version` | The version of Python that the project uses |
+| `.gitignore` | The files that git does not track, for example `.venv` |
+
 ## How the history is organised
 
 The project is built in steps, on the branch `tutorial`. Each step has a tag, `tut-00`, `tut-01` and so
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7ad3a06605fadc9f34b5e2d8180145a3e53389a9). [The code after it](https://github.com/rahuldave/babykev/tree/7ad3a06605fadc9f34b5e2d8180145a3e53389a9).

<a id="tut-02"></a>

## 2 Tests of the command

```bash
just setup
```

`just setup` prints `Resolved 1 package` and `Checked 1 package`, because `.venv` already matches `uv.lock`.

We cannot tell whether `babykev` still works after a change, unless we run it by hand and read what it prints. Tests
run it for us. pytest finds the tests and runs them, and a recipe `just test` runs pytest. The first tests are of the
command, the only code that babykev has. Last, coverage shows which lines the tests run.

[The code before this part](https://github.com/rahuldave/babykev/tree/7ad3a06605fadc9f34b5e2d8180145a3e53389a9). [The code after it](https://github.com/rahuldave/babykev/tree/4640589d80e4f224a4b2c1fd9567e952f564f102).

<a id="tut-02.1"></a>

### 2.1 uv installs every dependency group

The tests need pytest, and a package of babykev does not. A person who installs babykev should not get pytest. So the
tools of the project go in dependency groups. A dependency group is a list of packages in `pyproject.toml` that the
project needs while we work on it. A user of the package never gets them. The test tools go in a group `test`, and
later the linters and the docs tools get groups of their own.

uv installs only the group `dev` by default. The setting `default-groups = "all"` makes `uv sync` and `uv run`
install every group. So each later `uv add --group` needs no other change to `pyproject.toml`. A patch adds the
table `[tool.uv]` with this setting.

A patch to [`pyproject.toml`](#tut-02.1-pyproject.toml-5d07e7).

At the end of `pyproject.toml`, the new table `[tool.uv]` has the line `default-groups = "all"`, with a comment above
it.

The setting changes which groups uv installs, and not which versions. So `uv.lock` still matches `pyproject.toml`.

```bash
uv lock --check
```

uv prints `Resolved 1 package`, and no error. The project has no groups yet, so the setting changes nothing until a
later move adds one.

#### What changed

- <a id="tut-02.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the table `[tool.uv]`, so uv installs every dependency group. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/ad616a5cc1fcdf5b7c1672b79d0d2b267b72bd59/pyproject.toml).
  - look at `default-groups = "all"`

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

This change came from running `uv add --group test pytest`.

`uv add --group test` writes the group `test` in `pyproject.toml`, under `[dependency-groups]`. It prints
`Resolved 7 packages`, and lists pytest and the four packages it needs.

At the end of `pyproject.toml`, the new table `[dependency-groups]` has the group `test`, with the line
`"pytest>=9.1.1",`. `uv.lock` has pytest and the four packages it needs.

```bash
uv run pytest
```

`uv run pytest` looks for tests and finds none. It prints `collected 0 items` and `no tests ran`, and ends with exit
code 5. pytest uses exit code 5 to say that it found no test.

#### What changed

- <a id="tut-02.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: the group `test`, with pytest. 5 lines added. It comes from `uv add --group test pytest`. [The file](https://github.com/rahuldave/babykev/blob/966956d738b58505e23586af60f05cd5daceb12f/pyproject.toml).
  - look at `"pytest>=9.1.1",`
- <a id="tut-02.2-uv.lock-8356d8"></a>`uv.lock`: pytest and the four packages it needs. 71 lines added. It comes from `uv add --group test pytest`. [The file](https://github.com/rahuldave/babykev/blob/966956d738b58505e23586af60f05cd5daceb12f/uv.lock).

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

A patch to [`justfile`](#tut-02.3-justfile-424f0b).

At the end of `justfile`, the recipe `test` runs `uv run pytest "$@"`. It sits under a new heading, `quality`.

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

#### What changed

- <a id="tut-02.3-justfile-424f0b"></a>`justfile`: the recipe `test`. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/b0840709e371a548d4b922c57c679ba040dd2c1a/justfile).
  - look at `test *args:`

<details><summary>The diff of <code>justfile</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b0840709e371a548d4b922c57c679ba040dd2c1a). [The code after it](https://github.com/rahuldave/babykev/tree/b0840709e371a548d4b922c57c679ba040dd2c1a).

<a id="tut-02.4"></a>

### 2.4 A test of the help

pytest runs, but there is nothing to run. The command is the only code of babykev, so its tests come first. A test is
a function whose name starts with `test_`, in a file whose name starts with `test_`. A test passes when none of its
`assert` lines fails.

The first test runs `babykev` with no word, then with `help`, `--help` and `-h`, and checks that each prints the help.

A patch to [`tests/unit/test_cli.py`](#tut-02.4-tests-unit-test_cli.py-44d4a0).

The new file `tests/unit/test_cli.py` has the helper `run`, and the test `test_help_is_printed_for_help_and_for_no_words`.

`run` sets `sys.argv`, the words of the command line, and calls `main`, as if `babykev` had been typed at a terminal.
`monkeypatch` and `capsys` are fixtures of pytest. A test names a fixture as an argument, and pytest passes it in.
`monkeypatch.setattr` changes `sys.argv` for this test alone, and puts it back after the test. `capsys` catches what
the program prints. `@pytest.mark.parametrize` runs the test once for each of its four values.

```bash
just test
```

`just test` prints `collected 4 items`, then `4 passed`. One function makes four tests.

#### What changed

- <a id="tut-02.4-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: one test, for four ways of asking for help. New, 18 lines. [The file](https://github.com/rahuldave/babykev/blob/72678bd1d656f5bc6e44f2d65b44a1e18b024661/tests/unit/test_cli.py).
  - look at `@pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])`

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -0,0 +1,18 @@
+"""Unit tests for the `babykev` command: `help` prints the help, any other word is refused."""
+
+import pytest
+
+from babykev.cli import HELP, main
+
+
+def run(monkeypatch, *words):
+    """Run `babykev` with these words as its command line."""
+    monkeypatch.setattr("sys.argv", ["babykev", *words])
+    main()
+
+
+@pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])
+def test_help_is_printed_for_help_and_for_no_words(monkeypatch, capsys, words):
+    """`babykev`, `babykev help`, `--help` and `-h` all print the help text, and nothing else."""
+    run(monkeypatch, *words)
+    assert capsys.readouterr().out == HELP
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/72678bd1d656f5bc6e44f2d65b44a1e18b024661). [The code after it](https://github.com/rahuldave/babykev/tree/72678bd1d656f5bc6e44f2d65b44a1e18b024661).

<a id="tut-02.5"></a>

### 2.5 A test of an unknown command

The tests check the help, and nothing checks what `babykev` does with a word it does not know. A second test runs
`babykev train`. It checks that the command ends with exit code 2, and that the message names the word and points to
the help.

A patch to [`tests/unit/test_cli.py`](#tut-02.5-tests-unit-test_cli.py-44d4a0).

At the end of `tests/unit/test_cli.py`, the new test runs `train` inside `pytest.raises(SystemExit)`.

`pytest.raises(SystemExit)` passes only when the code inside it ends the program. The test then checks the exit code,
2, and the two parts of the message.

```bash
just test -k unknown
```

`-k unknown` runs the tests with `unknown` in their name. pytest prints `5 items / 4 deselected / 1 selected` and
`1 passed`.

#### What changed

- <a id="tut-02.5-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: the test of a word that is not a command. 10 lines added. [The file](https://github.com/rahuldave/babykev/blob/9a4100fd1962921bc11cf9f4b22c5326c7a51807/tests/unit/test_cli.py).
  - look at `assert exit_info.value.code == 2`

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -16,3 +16,13 @@ def test_help_is_printed_for_help_and_for_no_words(monkeypatch, capsys, words):
     """`babykev`, `babykev help`, `--help` and `-h` all print the help text, and nothing else."""
     run(monkeypatch, *words)
     assert capsys.readouterr().out == HELP
+
+
+def test_an_unknown_command_is_refused_with_exit_code_2(monkeypatch, capsys):
+    """A word that is not a command is named, the help is pointed to, and the exit code is 2."""
+    with pytest.raises(SystemExit) as exit_info:
+        run(monkeypatch, "train")
+    assert exit_info.value.code == 2
+    err = capsys.readouterr().err
+    assert "no command named 'train'" in err
+    assert "babykev help" in err
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9a4100fd1962921bc11cf9f4b22c5326c7a51807). [The code after it](https://github.com/rahuldave/babykev/tree/9a4100fd1962921bc11cf9f4b22c5326c7a51807).

<a id="tut-02.6"></a>

### 2.6 pytest looks for tests in tests/

pytest looks for tests in every folder of the project. The tests are all in `tests/`, and a setting says so.
`testpaths` in the table `[tool.pytest.ini_options]` names the folder.

A patch to [`pyproject.toml`](#tut-02.6-pyproject.toml-5d07e7).

At the end of `pyproject.toml`, the new table `[tool.pytest.ini_options]` has `testpaths = ["tests"]`.

```bash
just test
```

`just test` prints `testpaths: tests` and `5 passed`.

#### What changed

- <a id="tut-02.6-pyproject.toml-5d07e7"></a>`pyproject.toml`: the settings of pytest. pytest looks for tests in `tests/` alone. 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/348290a934c2bd1da0a38f4c3336f66758f8523c/pyproject.toml).
  - look at `testpaths = ["tests"]`

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -24,3 +24,6 @@ default-groups = "all"
 test = [
     "pytest>=9.1.1",
 ]
+
+[tool.pytest.ini_options]
+testpaths = ["tests"]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/348290a934c2bd1da0a38f4c3336f66758f8523c). [The code after it](https://github.com/rahuldave/babykev/tree/348290a934c2bd1da0a38f4c3336f66758f8523c).

<a id="tut-02.7"></a>

### 2.7 Pytest-cov, in the group test

The tests pass, but nothing says which lines of babykev they run. Coverage measures that. pytest-cov is a plugin of
pytest that measures it, when pytest gets the option `--cov`. It goes in the group `test`.

This change came from running `uv add --group test pytest-cov`.

`uv add` puts pytest-cov in the group `test`. It prints `Resolved 9 packages`, and installs `coverage` and
`pytest-cov`.

In `pyproject.toml`, the group `test` now has `"pytest-cov>=7.1.0",` under pytest. `uv.lock` has pytest-cov 7.1.0, and
coverage 7.16.2, which it needs.

```bash
just test --cov=babykev
```

`just test` prints `5 passed`, and a table under the tests. `cli.py` has 8 statements, and the tests run all of them,
100%. pytest-cov writes its data into `.coverage`, and `.gitignore` already names it.

#### What changed

- <a id="tut-02.7-pyproject.toml-5d07e7"></a>`pyproject.toml`: pytest-cov in the group `test`. 1 line added. It comes from `uv add --group test pytest-cov`. [The file](https://github.com/rahuldave/babykev/blob/326e444b726a914d5f9d0138ca658ed89a979dcd/pyproject.toml).
  - look at `"pytest-cov>=7.1.0",`
- <a id="tut-02.7-uv.lock-8356d8"></a>`uv.lock`: coverage and pytest-cov. 103 lines added, 1 removed. It comes from `uv add --group test pytest-cov`. [The file](https://github.com/rahuldave/babykev/blob/326e444b726a914d5f9d0138ca658ed89a979dcd/uv.lock).

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -23,6 +23,7 @@ default-groups = "all"
 [dependency-groups]
 test = [
     "pytest>=9.1.1",
+    "pytest-cov>=7.1.0",
 ]
 
 [tool.pytest.ini_options]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/326e444b726a914d5f9d0138ca658ed89a979dcd). [The code after it](https://github.com/rahuldave/babykev/tree/326e444b726a914d5f9d0138ca658ed89a979dcd).

<a id="tut-02.8"></a>

### 2.8 Coverage on every run of the tests

A person can forget to type `--cov=babykev`. `addopts` gives pytest options on every run. `--cov=babykev` measures
the package babykev, and `--cov-report=term-missing` adds a column of the lines that no test ran.

A patch to [`pyproject.toml`](#tut-02.8-pyproject.toml-5d07e7).

At the end of `pyproject.toml`, `addopts` stands under `testpaths`, with a comment above it.

```bash
just test
```

`just test` prints the table with a column `Missing`, empty, because the tests run every line of `cli.py`.

#### What changed

- <a id="tut-02.8-pyproject.toml-5d07e7"></a>`pyproject.toml`: the options of every run. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/f44cc53a91bc7db84283d6a9ded16d9a7bbedf90/pyproject.toml).
  - look at `addopts = "--cov=babykev --cov-report=term-missing"`

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -28,3 +28,5 @@ test = [
 
 [tool.pytest.ini_options]
 testpaths = ["tests"]
+# Every run measures how much of src/babykev the tests run, and lists the lines they do not
+addopts = "--cov=babykev --cov-report=term-missing"
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f44cc53a91bc7db84283d6a9ded16d9a7bbedf90). [The code after it](https://github.com/rahuldave/babykev/tree/f44cc53a91bc7db84283d6a9ded16d9a7bbedf90).

<a id="tut-02.9"></a>

### 2.9 The README says to run just test

"Start" in the README does not name `just test`. Its paragraph now says to run it, and that a recipe gives its extra
words to the tool behind it.

A patch to [`README.md`](#tut-02.9-README.md-8ec9a0).

In `README.md`, "Start" now says to run `just test`, and gives `just test -k help` as an example.

```bash
just test -k help
```

pytest runs the 4 tests with `help` in their name, and prints `4 passed, 1 deselected`.

#### What changed

- <a id="tut-02.9-README.md-8ec9a0"></a>`README.md`: `just test` in "Start". 3 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/ab192e5bd8ff3e3b8ad6c0ae5e17be31b7790557/README.md).
  - look at `help of the program itself. A recipe gives its extra words to the tool behind it. For example,`

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -54,8 +54,9 @@ Install two tools on your machine, uv and just. The project installs everything
 ## Start
 
 Run `just setup` first. It installs Python and every dependency into `.venv`, exactly as `uv.lock` says.
-Then `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is the help of the
-program itself.
+Then run `just test`. `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is the
+help of the program itself. A recipe gives its extra words to the tool behind it. For example,
+`just test -k help` runs only the tests with `help` in their name.
 
 ## What is here
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ab192e5bd8ff3e3b8ad6c0ae5e17be31b7790557). [The code after it](https://github.com/rahuldave/babykev/tree/ab192e5bd8ff3e3b8ad6c0ae5e17be31b7790557).

<a id="tut-02.10"></a>

### 2.10 The README names the tests

The table of "What is here" has no row for the tests. A row for `tests/unit/` comes in. The row of `pyproject.toml`
now says that it has the settings of the tools too.

A patch to [`README.md`](#tut-02.10-README.md-8ec9a0).

In the table of `README.md`, the new row names `tests/unit/` and `test_cli.py`.

```bash
just setup
just test
```

`just setup` prints `Resolved 9 packages` and `Checked 8 packages`. One of the 9, colorama, is for Windows alone, so
uv installs 8 here. `just test` prints `5 passed`.

#### What changed

- <a id="tut-02.10-README.md-8ec9a0"></a>`README.md`: the row of the tests. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/4640589d80e4f224a4b2c1fd9567e952f564f102/README.md).
  - look at ``| `tests/unit/` | The unit tests. `test_cli.py` tests the command `babykev` |``

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -62,8 +62,9 @@ help of the program itself. A recipe gives its extra words to the tool behind it
 
 | Path | What it is |
 |---|---|
-| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, and the exact versions to install |
+| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, the settings of its tools, and the exact versions to install |
 | `src/babykev/` | The code. `cli.py` is the command `babykev` |
+| `tests/unit/` | The unit tests. `test_cli.py` tests the command `babykev` |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `README.md` | This file |
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4640589d80e4f224a4b2c1fd9567e952f564f102). [The code after it](https://github.com/rahuldave/babykev/tree/4640589d80e4f224a4b2c1fd9567e952f564f102).

<a id="tut-03"></a>

## 3 The contract

```bash
just setup
```

babykev will answer typed questions about a text, and its model comes later. First we fix what a request is and what
an answer is. kev wrote this agreement in a file, `api.py`, and we call it the contract. It comes in as kev wrote it.

Then three parts that belong to kev's server go, one at a time. Five sample requests come last. No test reaches the
contract yet, so coverage falls.

[The code before this part](https://github.com/rahuldave/babykev/tree/4640589d80e4f224a4b2c1fd9567e952f564f102). [The code after it](https://github.com/rahuldave/babykev/tree/a3fdba91adc19206debd74d87fa107603433b202).

<a id="tut-03.1"></a>

### 3.1 Pydantic, the first dependency

The contract is written with pydantic, and babykev does not have it yet. pydantic checks that data has the shape that
a class describes. `uv add` writes the package into `dependencies`, because a package of babykev needs it to run.

This change came from running `uv add pydantic`.

`uv add pydantic` prints `Resolved 14 packages`, and lists what it installed. It installed pydantic and the four
packages that pydantic needs, `annotated-types`, `pydantic-core`, `typing-extensions` and `typing-inspection`.

In `pyproject.toml`, `dependencies` now names pydantic. `uv.lock` has pydantic and the four packages it needs, each at
one exact version.

```bash
uv tree --depth 1
```

`uv tree` prints the dependencies as a tree. `--depth 1` keeps the packages that babykev names itself. It prints
`pydantic v2.14.1`, and the group `test` with pytest and pytest-cov.

#### What changed

- <a id="tut-03.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the first dependency. `>=2.14.1` is the version that `uv add` found, as the lowest version to accept. 3 lines added, 1 removed. It comes from `uv add pydantic`. [The file](https://github.com/rahuldave/babykev/blob/96502df0a92f6f7090d6f624cda901a271dac9a7/pyproject.toml).
  - look at `"pydantic>=2.14.1",`
- <a id="tut-03.1-uv.lock-8356d8"></a>`uv.lock`: pydantic and the four packages it needs, each with its exact version. 136 lines added. It comes from `uv add pydantic`. [The file](https://github.com/rahuldave/babykev/blob/96502df0a92f6f7090d6f624cda901a271dac9a7/uv.lock).

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

### 3.2 api.py of kev, as he wrote it

babykev has no contract yet. kev's `api.py` says what a request is and what an answer is. It comes in as kev wrote it,
all 111 lines, so that we read his code before we change it.

A patch to [`src/babykev/api.py`](#tut-03.2-src-babykev-api.py-2ea65f).

`src/babykev/api.py` is new. Lines 14 to 42 are the classes of a request. The functions after them turn a request into
options, and probabilities into answers.

```bash
sed -n '14,42p' src/babykev/api.py
```

Each class says what its data must look like. `Literal["score"]` accepts only the text `score`.
`Field(min_length=2, max_length=MAX_OPTIONS)` asks a score for 2 to 255 levels. A `Choice` checks its number of options
in its own validator, `_check`, on lines 25 to 28.

```bash
just test
```

The 5 tests pass, and coverage falls. `api.py` has 70 statements, and no test runs any of them. The total is 10%, 8 of
78 statements. A file that no test reaches counts against the total.

#### What changed

- <a id="tut-03.2-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a request has a state and its questions by name. Each question is a `Noul`, a `Choice` or a `Score`, and its field `type` says which. New, 111 lines. [The file](https://github.com/rahuldave/babykev/blob/85ac48d80d3f558507cd04add56502a55228fdfb/src/babykev/api.py).
  - look at `class SystemOneRequest(BaseModel):`

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/85ac48d80d3f558507cd04add56502a55228fdfb). [The code after it](https://github.com/rahuldave/babykev/tree/85ac48d80d3f558507cd04add56502a55228fdfb).

<a id="tut-03.3"></a>

### 3.3 The docstring of api.py names no server

kev served the model over HTTP, and babykev has no server. The first line of `api.py` names the address of kev's
server, `POST /v1/systemone`.

A patch to [`src/babykev/api.py`](#tut-03.3-src-babykev-api.py-2ea65f).

In `src/babykev/api.py`, the docstring no longer names `POST /v1/systemone`.

```bash
head -n 1 src/babykev/api.py
```

It prints the new first line.

#### What changed

- <a id="tut-03.3-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the docstring. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/7d02a86b5264734575f0ae987b83749c721c3b8a/src/babykev/api.py).
  - look at `"""The contract: request and answer shapes, mapped onto the single pointer primitive.`

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -1,4 +1,4 @@
-"""TypeSafe-compatible request/response shapes (POST /v1/systemone) mapped onto the single pointer primitive.
+"""The contract: request and answer shapes, mapped onto the single pointer primitive.
 
 Noul   -> 2 options [false, true];            answer = p(true)
 Choice -> options 'name' or 'name: desc';      answer = argmax, probabilities by name, confidence
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7d02a86b5264734575f0ae987b83749c721c3b8a). [The code after it](https://github.com/rahuldave/babykev/tree/7d02a86b5264734575f0ae987b83749c721c3b8a).

<a id="tut-03.4"></a>

### 3.4 A request names no model

The field `model` named the model for kev's server to run. babykev has one model, so a request names none.

A patch to [`src/babykev/api.py`](#tut-03.4-src-babykev-api.py-2ea65f).

In `src/babykev/api.py`, `SystemOneRequest` ends with the line `questions`.

```bash
uv run python -c "from babykev.api import SystemOneRequest; print(sorted(SystemOneRequest.model_fields))"
```

`model_fields` lists the fields of a pydantic model. The command prints `['questions', 'state']`.

#### What changed

- <a id="tut-03.4-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a request has two fields, `state` and `questions`. 0 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/2413a8630c06aea68cbb29ab1600ff55416e21ed/src/babykev/api.py).
  - look at `    questions: dict[str, Question] = Field(min_length=1)`

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -39,7 +39,6 @@ Question = Union[Noul, Choice, Score]
 
 class SystemOneRequest(BaseModel):
     state: JSONContent
-    model: str = "kev-latest"
     questions: dict[str, Question] = Field(min_length=1)
 
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/2413a8630c06aea68cbb29ab1600ff55416e21ed). [The code after it](https://github.com/rahuldave/babykev/tree/2413a8630c06aea68cbb29ab1600ff55416e21ed).

<a id="tut-03.5"></a>

### 3.5 output_tokens goes

`output_tokens` counted the tokens of an answer for a bill, and needs the tokenizer of a model. babykev bills nothing.

A patch to [`src/babykev/api.py`](#tut-03.5-src-babykev-api.py-2ea65f).

`src/babykev/api.py` now ends with `to_answers`.

```bash
wc -l src/babykev/api.py
just test
```

`wc -l` counts 104 lines. `just test` prints `5 passed`, and the total is 11%, 8 of 74 statements.

#### What changed

- <a id="tut-03.5-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the function goes. 0 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/f4639659192ee57606c516584434974f14dbe45b/src/babykev/api.py).

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f4639659192ee57606c516584434974f14dbe45b). [The code after it](https://github.com/rahuldave/babykev/tree/f4639659192ee57606c516584434974f14dbe45b).

<a id="tut-03.6"></a>

### 3.6 Five requests about cheese, as sample data

The tests of the contract need requests to check, and the project has none. Five requests about cheese come in a file
of their own. Each line of the file is one request, in JSON. Each question has a `label`, the right answer.

A patch to [`data/cheese/sample.jsonl`](#tut-03.6-data-cheese-sample.jsonl-79f982).

`data/cheese/sample.jsonl` is new, with one request on each line.

```bash
head -n 1 data/cheese/sample.jsonl | python3 -m json.tool
```

`python3 -m json.tool` prints JSON with one key on each line. The first request is about the cheese Coquetdale, and
asks three questions. `vegetarian` is a `noul` with the label `true`. `intensity` is a `score` of four levels with the
label `1`, the second level. `milk` is a `choice` of five options with the label `cow`.

#### What changed

- <a id="tut-03.6-data-cheese-sample.jsonl-79f982"></a>`data/cheese/sample.jsonl`: each line is a request with a `state` and its `questions`. New, 5 lines. [The file](https://github.com/rahuldave/babykev/blob/a51a2eb1b7d9408614e8b1e61ccec561f12984e0/data/cheese/sample.jsonl).

<details><summary>The diff of <code>data/cheese/sample.jsonl</code></summary>

```diff
@@ -0,0 +1,5 @@
+{"state":{"cheese":"Coquetdale","origin":"Coquet, England","style":"soft-ripened","notes":{"texture":["creamy"],"flavour":["fruity"],"aroma":["rich"]},"colour":"pale yellow"},"questions":{"vegetarian":{"type":"noul","instructions":"Would you offer this cheese to a vegetarian?","label":true,"src":"cheese/vegetarian/withheld"},"intensity":{"type":"score","instructions":"How strong is the flavour of this cheese?","criteria":["Mild: milky, buttery, gentle","Medium: nutty, fruity, earthy","Pronounced: tangy, sharp, spicy","Strong: pungent, the kind you smell first"],"label":1,"src":"cheese/intensity/stated"},"milk":{"type":"choice","instructions":"Choose the milk this cheese is made from.","criteria":{"buffalo":null,"goat":null,"mixed":"More than one kind of milk","cow":null,"sheep":null},"label":"cow","src":"cheese/milk/withheld"}}}
+{"state":"ARDSALLAGH SMOKED CHEESE. Carrigtwohill. natural rind. smooth. white. taste: mild, nutty, smokey and sweet. vegetarian.","questions":{"has_rind":{"type":"noul","instructions":"Is there a rind on this cheese?","label":true,"src":"cheese/has_rind/stated"},"milk":{"type":"choice","instructions":"What kind of milk goes into this cheese?","criteria":{"buffalo":null,"goat":null,"cow":null,"sheep":null,"mixed":"More than one kind of milk"},"label":"goat","src":"cheese/milk/withheld"},"firmness":{"type":"score","instructions":"Where does this cheese sit between soft and hard?","criteria":["Soft: spreadable or yielding","Semi-soft: supple, bends before it breaks","Semi-hard: slices cleanly","Hard: dense, for grating or breaking"],"label":2,"src":"cheese/firmness/withheld"}}}
+{"state":{"cheese":"Alisia-Victoria","milk":"cow's","notes":{"texture":["smooth"],"flavour":["buttery"],"aroma":["nutty"]},"colour":"golden yellow"},"questions":{"fresh":{"type":"noul","instructions":"Is this a fresh cheese, sold without aging?","label":false,"src":"cheese/fresh/withheld"},"origin":{"type":"choice","instructions":"Where does this cheese come from?","criteria":{"United States or Canada":null,"British Isles":"England, Scotland, Wales or Ireland","rest of the world":null,"elsewhere in Europe":null,"France":null},"label":"elsewhere in Europe","src":"cheese/origin/withheld"},"firmness":{"type":"score","instructions":"Where does this cheese sit between soft and hard?","criteria":["Soft: spreadable or yielding","Semi-soft: supple, bends before it breaks","Semi-hard: slices cleanly","Hard: dense, for grating or breaking"],"label":3,"src":"cheese/firmness/withheld"}}}
+{"state":{"cheese":"Amou","milk":"sheep's"},"questions":{"vegetarian":{"type":"noul","instructions":"Is this cheese suitable for vegetarians?","label":false,"src":"cheese/vegetarian/withheld"},"milk":{"type":"choice","instructions":"Choose the milk this cheese is made from.","criteria":{"mixed":"More than one kind of milk","goat":null,"cow":null,"sheep":null,"buffalo":null},"label":"sheep","src":"cheese/milk/stated"},"firmness":{"type":"score","instructions":"Rate the firmness of this cheese.","criteria":["Soft: spreadable or yielding","Semi-soft: supple, bends before it breaks","Semi-hard: slices cleanly","Hard: dense, for grating or breaking"],"label":3,"src":"cheese/firmness/withheld"}}}
+{"state":"LOMA ALTA. soft-ripened. mould-ripened rind. firm. white. taste: buttery and nutty. smell: rich. not vegetarian.","questions":{"origin":{"type":"choice","instructions":"Choose where this cheese originates.","criteria":{"elsewhere in Europe":null,"United States or Canada":null,"rest of the world":null,"France":null,"British Isles":"England, Scotland, Wales or Ireland"},"label":"United States or Canada","src":"cheese/origin/withheld"},"no_cow":{"type":"noul","instructions":"Is this cheese free of cow's milk?","label":false,"src":"cheese/no_cow/withheld"},"intensity":{"type":"score","instructions":"How strong is the flavour of this cheese?","criteria":["Mild: milky, buttery, gentle","Medium: nutty, fruity, earthy","Pronounced: tangy, sharp, spicy","Strong: pungent, the kind you smell first"],"label":1,"src":"cheese/intensity/stated"}}}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a51a2eb1b7d9408614e8b1e61ccec561f12984e0). [The code after it](https://github.com/rahuldave/babykev/tree/a51a2eb1b7d9408614e8b1e61ccec561f12984e0).

<a id="tut-03.7"></a>

### 3.7 The README names the contract and the data

The table of the README names neither the contract nor the data. Rows for `api.py`, `cli.py` and the sample data take
the place of the row of `src/babykev/`.

A patch to [`README.md`](#tut-03.7-README.md-8ec9a0).

In the table of `README.md`, the rows of `src/babykev/api.py`, `src/babykev/cli.py` and `data/cheese/sample.jsonl`
stand above the row of the tests.

```bash
grep -n -E 'api.py|sample.jsonl' README.md
```

`grep` prints the two new rows.

#### What changed

- <a id="tut-03.7-README.md-8ec9a0"></a>`README.md`: the rows of the contract and the data. 3 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/a3fdba91adc19206debd74d87fa107603433b202/README.md).
  - look at ``| `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |``

<details><summary>The diff of <code>README.md</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a3fdba91adc19206debd74d87fa107603433b202). [The code after it](https://github.com/rahuldave/babykev/tree/a3fdba91adc19206debd74d87fa107603433b202).

<a id="tut-04"></a>

## 4 What a request is

```bash
just setup
```

The contract says what a request is, and no test checks it. The tests of this part check the five sample requests
against the contract. Then they check what the contract accepts and refuses, one rule at a time. They go in
`tests/unit/test_api.py`, one test in each move.

[The code before this part](https://github.com/rahuldave/babykev/tree/a3fdba91adc19206debd74d87fa107603433b202). [The code after it](https://github.com/rahuldave/babykev/tree/3fdf16e045d976c4351256b4d9ee60e36634d381).

<a id="tut-04.1"></a>

### 4.1 Every line of the sample data fits the contract

The first test of `api.py` checks each of the five sample requests against the contract. `SAMPLE_LINES` reads the
file. `parametrize` gives the test each line in turn. `model_validate` checks the line, and raises an error if it does
not fit.

A patch to [`tests/unit/test_api.py`](#tut-04.1-tests-unit-test_api.py-58d97c).

The new file `tests/unit/test_api.py` reads the sample data into `SAMPLE_LINES`, and has one test,
`test_sample_line_fits_the_contract`.

```bash
just test
```

`just test` prints `10 passed`, the 5 of the command and one for each sample line. `api.py` is at 77%. The missing
lines are the functions that turn probabilities into answers.

#### What changed

- <a id="tut-04.1-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the sample data, and the test that checks each line. New, 27 lines. [The file](https://github.com/rahuldave/babykev/blob/a4769b1cc4a199776e33def2db2d82ffe728e240/tests/unit/test_api.py).
  - look at `def test_sample_line_fits_the_contract(line):`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a4769b1cc4a199776e33def2db2d82ffe728e240). [The code after it](https://github.com/rahuldave/babykev/tree/a4769b1cc4a199776e33def2db2d82ffe728e240).

<a id="tut-04.2"></a>

### 4.2 Every question of the sample data has a label

The tests will compare answers with labels, so each label must have the right kind. A label is a boolean for a noul,
the name of an option for a choice, and the number of a level for a score.

A patch to [`tests/unit/test_api.py`](#tut-04.2-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the new test checks the label of every question of each line.

```bash
just test -k label
```

pytest runs the new test once for each line, and prints `5 passed`.

#### What changed

- <a id="tut-04.2-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the labels of the sample data. 13 lines added. [The file](https://github.com/rahuldave/babykev/blob/41afeeabb4221287e3ae3f13f88f39a5639b27f5/tests/unit/test_api.py).
  - look at `def test_sample_line_has_a_usable_label_on_every_question(line):`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/41afeeabb4221287e3ae3f13f88f39a5639b27f5). [The code after it](https://github.com/rahuldave/babykev/tree/41afeeabb4221287e3ae3f13f88f39a5639b27f5).

<a id="tut-04.3"></a>

### 4.3 A request holds one model for each type of question

The field `type` of a question decides which class of the contract it becomes. A helper, `cheese_request`, makes one
request with a question of each type, for the tests to share. The test checks that the noul is a `Noul`, the choice a
`Choice` and the score a `Score`.

A patch to [`tests/unit/test_api.py`](#tut-04.3-tests-unit-test_api.py-58d97c).

In `tests/unit/test_api.py`, `cheese_request` stands under the constants. The new test at the end checks the class of
each of its three questions.

```bash
just test -k one_model
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.3-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the helper, and the test of the three types. 32 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/897d387a14f58ae3d2bb67e425e426226b04642f/tests/unit/test_api.py).
  - look at `def test_request_holds_one_model_per_question_type():`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/897d387a14f58ae3d2bb67e425e426226b04642f). [The code after it](https://github.com/rahuldave/babykev/tree/897d387a14f58ae3d2bb67e425e426226b04642f).

<a id="tut-04.4"></a>

### 4.4 A request without questions is refused

A request must ask at least one question. `Field(min_length=1)` on `questions` says so. The test checks that pydantic
refuses a request with none.

A patch to [`tests/unit/test_api.py`](#tut-04.4-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the new test expects a `ValidationError` for `"questions": {}`.

```bash
just test -k without_questions
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.4-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a request with no questions. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/20844ff36037001c1301da15bff6c65446aff65b/tests/unit/test_api.py).
  - look at `def test_request_without_questions_is_rejected():`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/20844ff36037001c1301da15bff6c65446aff65b). [The code after it](https://github.com/rahuldave/babykev/tree/20844ff36037001c1301da15bff6c65446aff65b).

<a id="tut-04.5"></a>

### 4.5 An unknown type of question is refused

Only noul, choice and score exist. The test gives a question the type `essay`, and expects a refusal.

A patch to [`tests/unit/test_api.py`](#tut-04.5-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the new test makes a question of type `essay`.

```bash
just test -k unknown_question
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.5-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a type that does not exist. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/344ca5af25f758538a8ebaca51a0a88dd6ccc333/tests/unit/test_api.py).
  - look at `question = {"type": "essay", "instructions": "Describe this cheese."}`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/344ca5af25f758538a8ebaca51a0a88dd6ccc333). [The code after it](https://github.com/rahuldave/babykev/tree/344ca5af25f758538a8ebaca51a0a88dd6ccc333).

<a id="tut-04.6"></a>

### 4.6 A noul needs no criteria

A question of yes or no may leave out what yes and no mean. The test makes a `Noul` with no criteria, and checks that
its criteria are `None`.

A patch to [`tests/unit/test_api.py`](#tut-04.6-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the new test makes a `Noul` with an instruction alone.

```bash
just test -k noul_needs
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.6-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a noul without criteria. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/5128d9cf9dea8e7c76de31d5d67d27e692cfafc0/tests/unit/test_api.py).
  - look at `assert Noul(type="noul", instructions="Is it blue?").criteria is None`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5128d9cf9dea8e7c76de31d5d67d27e692cfafc0). [The code after it](https://github.com/rahuldave/babykev/tree/5128d9cf9dea8e7c76de31d5d67d27e692cfafc0).

<a id="tut-04.7"></a>

### 4.7 A choice without options is refused

A choice needs at least one option. The test gives a `Choice` empty criteria, and expects a refusal.

A patch to [`tests/unit/test_api.py`](#tut-04.7-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the new test makes a `Choice` with `criteria={}`.

```bash
just test -k choice_without
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.7-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a choice of nothing. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/464e175952882fc67de86b90baaad51caf1a0801/tests/unit/test_api.py).
  - look at `def test_choice_without_options_is_rejected():`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/464e175952882fc67de86b90baaad51caf1a0801). [The code after it](https://github.com/rahuldave/babykev/tree/464e175952882fc67de86b90baaad51caf1a0801).

<a id="tut-04.8"></a>

### 4.8 A choice has at most MAX_OPTIONS options

`MAX_OPTIONS` is 255. The test makes a choice of exactly 255 options, which is valid, and one of 256, which is
refused. A limit is tested on both of its sides.

A patch to [`tests/unit/test_api.py`](#tut-04.8-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the new test makes `at_limit`, 255 options, and then adds `one_more`.

```bash
just test -k largest
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.8-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the limit, from both sides. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/9f07f3752d1e1c2622310d6fa556c40cac43be00/tests/unit/test_api.py).
  - look at `at_limit = {f"option{i}": None for i in range(MAX_OPTIONS)}`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9f07f3752d1e1c2622310d6fa556c40cac43be00). [The code after it](https://github.com/rahuldave/babykev/tree/9f07f3752d1e1c2622310d6fa556c40cac43be00).

<a id="tut-04.9"></a>

### 4.9 A score of one level is refused

A scale needs two levels at least, or it measures nothing. The test gives a `Score` one level, and expects a refusal.

A patch to [`tests/unit/test_api.py`](#tut-04.9-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the new test makes a `Score` with the one level `Soft`.

```bash
just test
```

`just test` prints `22 passed`. `api.py` is still at 77%. The tests of validation run lines that the sample data ran
already.

#### What changed

- <a id="tut-04.9-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a scale of one level. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/5a07b57374e4863dee50efb07cc71a9ed848efc5/tests/unit/test_api.py).
  - look at `Score(type="score", instructions="How firm?", criteria=["Soft"])`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5a07b57374e4863dee50efb07cc71a9ed848efc5). [The code after it](https://github.com/rahuldave/babykev/tree/5a07b57374e4863dee50efb07cc71a9ed848efc5).

<a id="tut-04.10"></a>

### 4.10 The README names the tests of the contract

The row of `tests/unit/` names only the tests of the command. It now names the tests of the contract too.

A patch to [`README.md`](#tut-04.10-README.md-8ec9a0).

In the table of `README.md`, the row of `tests/unit/` names the tests of the contract and the sample data.

```bash
grep -n 'tests/unit' README.md
```

`grep` prints the new row.

#### What changed

- <a id="tut-04.10-README.md-8ec9a0"></a>`README.md`: the row of the tests. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/3fdf16e045d976c4351256b4d9ee60e36634d381/README.md).
  - look at ``| `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |``

<details><summary>The diff of <code>README.md</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3fdf16e045d976c4351256b4d9ee60e36634d381). [The code after it](https://github.com/rahuldave/babykev/tree/3fdf16e045d976c4351256b4d9ee60e36634d381).

<a id="tut-05"></a>

## 5 From a request to the model, and back

```bash
just setup
```

The contract also maps a request to what the model reads, and the model's probabilities back to answers. `render`
turns JSON into text, `option_text` writes an option, `to_record` turns a request into a record, and `to_answers`
turns probabilities into answers. Each test checks one of their rules.

[The code before this part](https://github.com/rahuldave/babykev/tree/3fdf16e045d976c4351256b4d9ee60e36634d381). [The code after it](https://github.com/rahuldave/babykev/tree/c65ddf5484593bfa8c135f4bd5fddc4846cf80c1).

<a id="tut-05.1"></a>

### 5.1 render turns JSON into text

The model reads text, and the state of a request is JSON. `render` writes JSON as text. One test gives `render` nine
values, from `None` to a list of objects, and checks the text of each.

A patch to [`tests/unit/test_api.py`](#tut-05.1-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the parametrized test lists nine pairs, each a value and its text.

```bash
just test -k render
```

pytest prints `9 passed`, one for each value.

#### What changed

- <a id="tut-05.1-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: nine values, and their text. 26 lines added. [The file](https://github.com/rahuldave/babykev/blob/2cb2323b0534d811117562d749046d2085f55da1/tests/unit/test_api.py).
  - look at `def test_render_flattens_json_into_text(value, text):`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/2cb2323b0534d811117562d749046d2085f55da1). [The code after it](https://github.com/rahuldave/babykev/tree/2cb2323b0534d811117562d749046d2085f55da1).

<a id="tut-05.2"></a>

### 5.2 An option has a description only when it has one

An option is its name, followed by its description when it has one. `option_text` writes it. The test gives it no
description, an empty one, and a real one.

A patch to [`tests/unit/test_api.py`](#tut-05.2-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test gives `option_text` three cases.

```bash
just test -k option_text
```

pytest prints `3 passed`.

#### What changed

- <a id="tut-05.2-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: three cases of an option. 14 lines added. [The file](https://github.com/rahuldave/babykev/blob/b0ac52637697336e97f8fc777ffb4c4398436d6b/tests/unit/test_api.py).
  - look at `def test_option_text_adds_a_description_only_when_there_is_one(name, description, text):`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b0ac52637697336e97f8fc777ffb4c4398436d6b). [The code after it](https://github.com/rahuldave/babykev/tree/b0ac52637697336e97f8fc777ffb4c4398436d6b).

<a id="tut-05.3"></a>

### 5.3 A record keeps the state and the order of questions

`to_record` turns a request into a record, the text and options that the model reads, and the metadata that maps
them back. The test checks that the state is rendered once, and that the questions keep their order.

A patch to [`tests/unit/test_api.py`](#tut-05.3-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test reads `record["state"]` and the order of the questions.

```bash
just test -k keeps_the_state
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-05.3-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the state, and the order. 15 lines added. [The file](https://github.com/rahuldave/babykev/blob/ada878e14d24bf0c5831be23e1dd34ed81c2630b/tests/unit/test_api.py).
  - look at `assert [m["id"] for m in meta] == ["blue", "milk", "firmness"]`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ada878e14d24bf0c5831be23e1dd34ed81c2630b). [The code after it](https://github.com/rahuldave/babykev/tree/ada878e14d24bf0c5831be23e1dd34ed81c2630b).

<a id="tut-05.4"></a>

### 5.4 A noul becomes no, then yes

A noul has two options, `no` first. So the answer to a noul is the probability of option 1, yes.

A patch to [`tests/unit/test_api.py`](#tut-05.4-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test checks the options `["no", "yes"]`.

```bash
just test -k no_then_yes
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-05.4-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the two options of a noul. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/1c76e1a38e54bd80383392e8205dd3318a1b17f1/tests/unit/test_api.py).
  - look at `assert record["questions"][0]["options"] == ["no", "yes"]`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1c76e1a38e54bd80383392e8205dd3318a1b17f1). [The code after it](https://github.com/rahuldave/babykev/tree/1c76e1a38e54bd80383392e8205dd3318a1b17f1).

<a id="tut-05.5"></a>

### 5.5 The criteria of a noul describe no and yes

A noul can say what yes and no mean, under `true` and `false`. They become the descriptions of the two options.

A patch to [`tests/unit/test_api.py`](#tut-05.5-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test expects `"no: It has none"` and `"yes: It has blue veins"`.

```bash
just test -k describe_no
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-05.5-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the descriptions of no and yes. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/54d3e0602d9b2d96ba709955cb6672aeab9b1313/tests/unit/test_api.py).
  - look at `def test_noul_criteria_describe_no_and_yes():`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/54d3e0602d9b2d96ba709955cb6672aeab9b1313). [The code after it](https://github.com/rahuldave/babykev/tree/54d3e0602d9b2d96ba709955cb6672aeab9b1313).

<a id="tut-05.6"></a>

### 5.6 A choice becomes one option per criterion

A choice has one option for each criterion, in order, and the metadata keeps their names.

A patch to [`tests/unit/test_api.py`](#tut-05.6-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test expects four options, the last with its description.

```bash
just test -k one_option_per_criterion
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-05.6-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the options of a choice. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/e10cddd3fcea261b3f72ae3b349d826e611bd714/tests/unit/test_api.py).
  - look at `def test_choice_becomes_one_option_per_criterion_in_order():`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e10cddd3fcea261b3f72ae3b349d826e611bd714). [The code after it](https://github.com/rahuldave/babykev/tree/e10cddd3fcea261b3f72ae3b349d826e611bd714).

<a id="tut-05.7"></a>

### 5.7 A score becomes one option per level

A score has one option for each level, in order. Its legend maps the number of each level to its name.

A patch to [`tests/unit/test_api.py`](#tut-05.7-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test checks the options and the legend of `firmness`.

```bash
just test -k one_option_per_level
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-05.7-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the levels, and the legend. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/a445bb427a4611ed18fc8683f2462c448f340cab/tests/unit/test_api.py).
  - look at `def test_score_becomes_one_option_per_level_with_a_legend():`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a445bb427a4611ed18fc8683f2462c448f340cab). [The code after it](https://github.com/rahuldave/babykev/tree/a445bb427a4611ed18fc8683f2462c448f340cab).

<a id="tut-05.8"></a>

### 5.8 The answer of a noul is the probability of yes

`to_answers` turns the probabilities of the model into answers. The answer to a noul is one number, the probability of
yes.

A patch to [`tests/unit/test_api.py`](#tut-05.8-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test gives `to_answers` the probabilities `[0.25, 0.75]`, and expects
`0.75`.

```bash
just test
```

`just test` prints `40 passed`, and `api.py` is at 86%.

#### What changed

- <a id="tut-05.8-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the answer of a noul. 10 lines added. [The file](https://github.com/rahuldave/babykev/blob/17710a377cbe4978af0b17d0e5f275ebea3ebf31/tests/unit/test_api.py).
  - look at `assert answers == {"blue": {"type": "noul", "noul": 0.75}}`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/17710a377cbe4978af0b17d0e5f275ebea3ebf31). [The code after it](https://github.com/rahuldave/babykev/tree/17710a377cbe4978af0b17d0e5f275ebea3ebf31).

<a id="tut-05.9"></a>

### 5.9 A choice names the most likely option

The answer to a choice has its most likely option, a probability for each option, and a confidence.

A patch to [`tests/unit/test_api.py`](#tut-05.9-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test gives `[0.1, 0.7, 0.2]`, and expects `goat`.

```bash
just test
```

`just test` prints `41 passed`, and `api.py` is at 94%.

#### What changed

- <a id="tut-05.9-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the answer of a choice. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/0ff7fb5056bc35a07820f54b2fb8341c45fff2f7/tests/unit/test_api.py).
  - look at `assert answer["choice"] == "goat"`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0ff7fb5056bc35a07820f54b2fb8341c45fff2f7). [The code after it](https://github.com/rahuldave/babykev/tree/0ff7fb5056bc35a07820f54b2fb8341c45fff2f7).

<a id="tut-05.10"></a>

### 5.10 A score answers with the expected level

The answer to a score is the expected level, the mean of the levels weighted by their probabilities. For
`[0.1, 0.2, 0.7]` it is 0 × 0.1 + 1 × 0.2 + 2 × 0.7 = 1.6.

A patch to [`tests/unit/test_api.py`](#tut-05.10-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test expects the score `1.6`.

```bash
just test
```

`just test` prints `42 passed`, and `api.py` is at 100%.

#### What changed

- <a id="tut-05.10-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the answer of a score. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/6f149fe7e2041c277c9f3b775f081e6e74fe8221/tests/unit/test_api.py).
  - look at `assert answer["score"] == pytest.approx(1.6)`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/6f149fe7e2041c277c9f3b775f081e6e74fe8221). [The code after it](https://github.com/rahuldave/babykev/tree/6f149fe7e2041c277c9f3b775f081e6e74fe8221).

<a id="tut-05.11"></a>

### 5.11 Every question gets an answer of its own type

A request of three questions must get three answers, each under the id of its question, each of its type. The test
runs `to_record` and `to_answers` one after the other.

A patch to [`tests/unit/test_api.py`](#tut-05.11-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test checks the type of the answer to each of the three questions.

```bash
just test
```

`just test` prints `43 passed`, and every line of `api.py` runs, 100%. Two lines are still wrong, and the next part
shows them. Coverage says which lines ran. It does not say that a test checked what each line does.

#### What changed

- <a id="tut-05.11-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: one answer for each question. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/c65ddf5484593bfa8c135f4bd5fddc4846cf80c1/tests/unit/test_api.py).
  - look at `def test_every_question_gets_an_answer_of_its_own_type():`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c65ddf5484593bfa8c135f4bd5fddc4846cf80c1). [The code after it](https://github.com/rahuldave/babykev/tree/c65ddf5484593bfa8c135f4bd5fddc4846cf80c1).

<a id="tut-06"></a>

## 6 Kev's two bugs

```bash
just setup
```

Every line of the contract runs in a test, and two of them are wrong. A test of rounding finds the first. The tests of
confidence find the second. Each test fails, and the move after it fixes the code.

[The code before this part](https://github.com/rahuldave/babykev/tree/c65ddf5484593bfa8c135f4bd5fddc4846cf80c1). [The code after it](https://github.com/rahuldave/babykev/tree/bb441c7fdf6f8fcd066dbcdd7f7bc03837a661ac).

<a id="tut-06.1"></a>

### 6.1 A test of rounding, which fails

The probabilities of an answer must sum to 1. The test makes a choice of 77 options with the same probability, 1/77
each. `pytest.approx(1, abs=0.02)` accepts any number from 0.98 to 1.02. The test fails on purpose, because it finds
a bug of kev.

A patch to [`tests/unit/test_api.py`](#tut-06.1-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the new test sums the probabilities of 77 equal options.

```bash
just test -k sum_to_one
```

pytest prints `F` for the failed test, and `assert 0.77 == 1 ± 0.02`. It ends with `1 failed, 43 deselected`, and exit
code 1.

```bash
sed -n '89,90p' src/babykev/api.py
```

Lines 89 and 90 are `r2`, which rounds to two decimals. 1/77 is about 0.013, and `r2` makes it 0.01. 77 times 0.01 is
0.77. The test is right, and the code is wrong.

#### What changed

- <a id="tut-06.1-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the sum of the rounded probabilities. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/1beac4d6e9bca366e9a3411665e72a1ecdafd094/tests/unit/test_api.py).
  - look at `    assert sum(answer["probabilities"].values()) == pytest.approx(1, abs=0.02)`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -243,3 +243,12 @@ def test_every_question_gets_an_answer_of_its_own_type():
         "milk": "choice",
         "firmness": "score",
     }
+
+
+def test_rounded_probabilities_still_sum_to_one():
+    """Rounding for output must not lose probability, even with many options."""
+    keys = [f"intent{i}" for i in range(77)]
+    answer = to_answers([[1 / 77] * 77], [{"id": "intent", "type": "choice", "keys": keys}])[
+        "intent"
+    ]
+    assert sum(answer["probabilities"].values()) == pytest.approx(1, abs=0.02)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1beac4d6e9bca366e9a3411665e72a1ecdafd094). [The code after it](https://github.com/rahuldave/babykev/tree/1beac4d6e9bca366e9a3411665e72a1ecdafd094).

<a id="tut-06.2"></a>

### 6.2 Probabilities rounded to four decimals

Two decimals lose too much, and 77 equal options sum to 0.77. `round_prob` takes the place of `r2`, and rounds to four
decimals. Each 1/77 becomes 0.013, and the 77 probabilities sum to 1.001, within 0.02 of 1.

A patch to [`src/babykev/api.py`](#tut-06.2-src-babykev-api.py-2ea65f).

In `src/babykev/api.py`, `round_prob` stands where `r2` was, and `to_answers` calls it.

```bash
just test -k sum_to_one
just test
```

`just test -k sum_to_one` prints `1 passed`. The test did not change, and the code did. `just test` prints `44 passed`.

#### What changed

- <a id="tut-06.2-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: four decimals. 8 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/cd9e71dff5d72be00b049e50fc15b0db8235b705/src/babykev/api.py).
  - look at `    return round(float(x), 4)`

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -86,19 +86,21 @@ def score_confidence(p: list[float]) -> float:
     return 1.0 - sum(pi * abs(i - mode) for i, pi in enumerate(p)) / (L - 1)
 
 
-def r2(x: float) -> float:
-    return round(float(x), 2)
+def round_prob(x: float) -> float:
+    """Round a number for output. Four decimals keep the sum of a distribution within 0.02 of 1,
+    even with MAX_OPTIONS options. Two decimals did not: 77 equal options summed to 0.77."""
+    return round(float(x), 4)
 
 
 def to_answers(probs: list[list[float]], meta: list[dict]) -> dict[str, Any]:
     out = {}
     for p, m in zip(probs, meta):
         if m["type"] == "noul":
-            out[m["id"]] = {"type": "noul", "noul": r2(p[1])}
+            out[m["id"]] = {"type": "noul", "noul": round_prob(p[1])}
         elif m["type"] == "choice":
-            dist = {k: r2(v) for k, v in zip(m["keys"], p)}
-            out[m["id"]] = {"type": "choice", "choice": m["keys"][max(range(len(p)), key=lambda i: p[i])], "confidence": r2(choice_confidence(p)), "probabilities": dist}
+            dist = {k: round_prob(v) for k, v in zip(m["keys"], p)}
+            out[m["id"]] = {"type": "choice", "choice": m["keys"][max(range(len(p)), key=lambda i: p[i])], "confidence": round_prob(choice_confidence(p)), "probabilities": dist}
         else:
             score = sum(i * pi for i, pi in enumerate(p))
-            out[m["id"]] = {"type": "score", "score": r2(score), "legend": m["legend"], "probabilities": {str(i): r2(v) for i, v in enumerate(p)}, "confidence": r2(score_confidence(p))}
+            out[m["id"]] = {"type": "score", "score": round_prob(score), "legend": m["legend"], "probabilities": {str(i): round_prob(v) for i, v in enumerate(p)}, "confidence": round_prob(score_confidence(p))}
     return out
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/cd9e71dff5d72be00b049e50fc15b0db8235b705). [The code after it](https://github.com/rahuldave/babykev/tree/cd9e71dff5d72be00b049e50fc15b0db8235b705).

<a id="tut-06.3"></a>

### 6.3 A guess between options has confidence 0

Confidence runs from 1, when the model is sure, to 0, when it knows nothing. A choice that gives every option the same
probability is a guess.

A patch to [`tests/unit/test_api.py`](#tut-06.3-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test gives `choice_confidence` four equal probabilities.

```bash
just test -k confidence
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-06.3-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a guess between four options. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/c30775de4338f1f7912dd178574536d0d6ac4d7b/tests/unit/test_api.py).
  - look at `assert choice_confidence([0.25] * 4) == pytest.approx(0)`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -12,6 +12,7 @@ from babykev.api import (
     Noul,
     Score,
     SystemOneRequest,
+    choice_confidence,
     option_text,
     render,
     to_answers,
@@ -252,3 +253,11 @@ def test_rounded_probabilities_still_sum_to_one():
         "intent"
     ]
     assert sum(answer["probabilities"].values()) == pytest.approx(1, abs=0.02)
+
+
+# Confidence
+
+
+def test_choice_confidence_is_zero_for_a_guess():
+    """Equal probabilities are a guess, whatever the number of options."""
+    assert choice_confidence([0.25] * 4) == pytest.approx(0)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c30775de4338f1f7912dd178574536d0d6ac4d7b). [The code after it](https://github.com/rahuldave/babykev/tree/c30775de4338f1f7912dd178574536d0d6ac4d7b).

<a id="tut-06.4"></a>

### 6.4 A certain choice has confidence 1

All the probability on one option is certainty, with three options or with one.

A patch to [`tests/unit/test_api.py`](#tut-06.4-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test checks `[0, 1, 0]` and `[1.0]`.

```bash
just test -k confidence
```

pytest prints `2 passed`.

#### What changed

- <a id="tut-06.4-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: certainty. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/490a244100c0a9ea6d3992ba31c49ca5b234e7f9/tests/unit/test_api.py).
  - look at `assert choice_confidence([0, 1, 0]) == pytest.approx(1)`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -261,3 +261,9 @@ def test_rounded_probabilities_still_sum_to_one():
 def test_choice_confidence_is_zero_for_a_guess():
     """Equal probabilities are a guess, whatever the number of options."""
     assert choice_confidence([0.25] * 4) == pytest.approx(0)
+
+
+def test_choice_confidence_is_one_when_certain():
+    """All the probability on one option is certainty."""
+    assert choice_confidence([0, 1, 0]) == pytest.approx(1)
+    assert choice_confidence([1.0]) == 1.0
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/490a244100c0a9ea6d3992ba31c49ca5b234e7f9). [The code after it](https://github.com/rahuldave/babykev/tree/490a244100c0a9ea6d3992ba31c49ca5b234e7f9).

<a id="tut-06.5"></a>

### 6.5 The confidence of a choice grows with its winner

Between a guess and certainty, confidence follows the probability of the most likely option. `[0.5, 0.25, 0.25]` gets
0.25.

A patch to [`tests/unit/test_api.py`](#tut-06.5-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test expects 0.25 for `[0.5, 0.25, 0.25]`.

```bash
just test -k confidence
```

pytest prints `3 passed`.

#### What changed

- <a id="tut-06.5-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a confidence between 0 and 1. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/2e76bc0655ffb0458d1815154478fb3efae55b4c/tests/unit/test_api.py).
  - look at `assert choice_confidence([0.5, 0.25, 0.25]) == pytest.approx(0.25)`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -267,3 +267,8 @@ def test_choice_confidence_is_one_when_certain():
     """All the probability on one option is certainty."""
     assert choice_confidence([0, 1, 0]) == pytest.approx(1)
     assert choice_confidence([1.0]) == 1.0
+
+
+def test_choice_confidence_grows_with_the_winner():
+    """Between a guess and certainty, confidence follows the winning probability."""
+    assert choice_confidence([0.5, 0.25, 0.25]) == pytest.approx(0.25)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/2e76bc0655ffb0458d1815154478fb3efae55b4c). [The code after it](https://github.com/rahuldave/babykev/tree/2e76bc0655ffb0458d1815154478fb3efae55b4c).

<a id="tut-06.6"></a>

### 6.6 A certain score has confidence 1

A score has its own confidence, which measures how close the probabilities sit to the most likely level. All the
probability on one level is certainty, wherever the level is. The test runs for each of three levels.

A patch to [`tests/unit/test_api.py`](#tut-06.6-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the parametrized test puts 1.0 on level 0, 1 and 2 in turn.

```bash
just test -k confidence
```

pytest prints `6 passed`.

#### What changed

- <a id="tut-06.6-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: certainty, on each level. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/e176a81dda2c6ae99a5095f67d3e909efda6630c/tests/unit/test_api.py).
  - look at `def test_score_confidence_is_one_when_certain(level):`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -15,6 +15,7 @@ from babykev.api import (
     choice_confidence,
     option_text,
     render,
+    score_confidence,
     to_answers,
     to_record,
 )
@@ -272,3 +273,11 @@ def test_choice_confidence_is_one_when_certain():
 def test_choice_confidence_grows_with_the_winner():
     """Between a guess and certainty, confidence follows the winning probability."""
     assert choice_confidence([0.5, 0.25, 0.25]) == pytest.approx(0.25)
+
+
+@pytest.mark.parametrize("level", [0, 1, 2])
+def test_score_confidence_is_one_when_certain(level):
+    """All the probability on one level is certainty, wherever the level is."""
+    p = [0.0, 0.0, 0.0]
+    p[level] = 1.0
+    assert score_confidence(p) == pytest.approx(1)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e176a81dda2c6ae99a5095f67d3e909efda6630c). [The code after it](https://github.com/rahuldave/babykev/tree/e176a81dda2c6ae99a5095f67d3e909efda6630c).

<a id="tut-06.7"></a>

### 6.7 A score prefers neighbouring levels

Doubt between two neighbouring levels is closer to certain than doubt between the two ends of the scale.

A patch to [`tests/unit/test_api.py`](#tut-06.7-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test compares `[0.5, 0.5, 0, 0]` with `[0.5, 0, 0, 0.5]`.

```bash
just test -k confidence
```

pytest prints `7 passed`.

#### What changed

- <a id="tut-06.7-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: near is better than far. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/63911fbe1251ada79de19a6314e43346fe8a30e6/tests/unit/test_api.py).
  - look at `assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -281,3 +281,8 @@ def test_score_confidence_is_one_when_certain(level):
     p = [0.0, 0.0, 0.0]
     p[level] = 1.0
     assert score_confidence(p) == pytest.approx(1)
+
+
+def test_score_confidence_prefers_neighbouring_levels():
+    """Doubt between adjacent levels is more confident than doubt between the two ends."""
+    assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/63911fbe1251ada79de19a6314e43346fe8a30e6). [The code after it](https://github.com/rahuldave/babykev/tree/63911fbe1251ada79de19a6314e43346fe8a30e6).

<a id="tut-06.8"></a>

### 6.8 A guess between levels has confidence 0, and the test fails

A score that gives every level the same probability is a guess, as it is for a choice, and its confidence must be 0.
The test fails on purpose, because it finds the second bug of kev.

A patch to [`tests/unit/test_api.py`](#tut-06.8-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the test gives `score_confidence` three equal probabilities.

```bash
just test -k confidence
```

pytest prints `1 failed, 7 passed`. The test that failed is `test_score_confidence_is_zero_for_a_guess`, with
`assert 0.5 == 0 ± 1.0e-12`. A guess over three levels has confidence 0.5. So the score says it is half sure when it
knows nothing.

```bash
sed -n '82,86p' src/babykev/api.py
```

Lines 82 to 86 are `score_confidence`. `mode` is the most likely level. The sum is the spread around `mode`, the
expected distance of a level from `mode`. The code divides it by `L - 1`, the length of the scale.

For the guess, all levels are equally likely, and `max` takes the first, level 0, as `mode`. The levels are 0, 1 and 2
places from it, so the spread is 1/3 × 0 + 1/3 × 1 + 1/3 × 2 = 1 place. The length is 2 places, so the confidence is
1 − 1/2 = 0.5.

#### What changed

- <a id="tut-06.8-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a guess between three levels. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/f73a45e1526b08ffa60178134d837e21ff0db627/tests/unit/test_api.py).
  - look at `assert score_confidence([1 / 3] * 3) == pytest.approx(0)`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -286,3 +286,8 @@ def test_score_confidence_is_one_when_certain(level):
 def test_score_confidence_prefers_neighbouring_levels():
     """Doubt between adjacent levels is more confident than doubt between the two ends."""
     assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])
+
+
+def test_score_confidence_is_zero_for_a_guess():
+    """Equal probabilities over the levels are a guess, as they are for a choice."""
+    assert score_confidence([1 / 3] * 3) == pytest.approx(0)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f73a45e1526b08ffa60178134d837e21ff0db627). [The code after it](https://github.com/rahuldave/babykev/tree/f73a45e1526b08ffa60178134d837e21ff0db627).

<a id="tut-06.9"></a>

### 6.9 The confidence of a score measures against a guess

A guess gets confidence 0.5, because the code measures the spread against the length of the scale. The fix measures it
against the spread of a guess around the middle level.

A patch to [`src/babykev/api.py`](#tut-06.9-src-babykev-api.py-2ea65f).

In `src/babykev/api.py`, `score_confidence` now computes `spread` and `guess`, and divides one by the other.

`guess` is the spread of a guess around the middle level. For three levels, the middle is level 1, and the levels are
1, 0 and 1 places from it. So `guess` is 1/3 × 1 + 1/3 × 0 + 1/3 × 1 = 2/3 of a place. For the guess itself, `spread`
around `mode` is 1 place, as before. So 1 − 1 ÷ (2/3) = 1 − 1.5 = −0.5, and `max(0.0, ...)` counts a value below 0 as
0. A guess has confidence 0.

```bash
uv run python -c "from babykev.api import score_confidence as s; print([round(s(p), 2) for p in ([1/3]*3, [0.5, 0.25, 0.25], [0.6, 0.3, 0.1], [0.8, 0.1, 0.1])])"
```

The command prints the confidences of the guess and of three answers, `[0.0, 0.0, 0.25, 0.55]`. `[0.5, 0.25, 0.25]`
is as spread out as a guess, and also gets 0.

```bash
just test
```

`just test` prints `52 passed`, and `api.py` is at 99%. `Missing` gives line 90, `return 1.0`. The new function
divides by `guess`, which is 0 for a scale of one level, so line 90 answers 1 before the division. A request cannot
hold a scale of one level, so no test reaches it.

#### What changed

- <a id="tut-06.9-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the spread of a guess, as the measure. 12 lines added, 4 removed. [The file](https://github.com/rahuldave/babykev/blob/0ecccd50f6af3eebae1e00ad7a98f433e17f36e9/src/babykev/api.py).
  - look at `    guess = sum(abs(i - (L - 1) / 2) for i in range(L)) / L`

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -80,10 +80,18 @@ def choice_confidence(p: list[float]) -> float:
 
 
 def score_confidence(p: list[float]) -> float:
-    """Approximation of TypeSafe's 'distance from the modal level' statistic (exact formula unpublished):
-    1 - E|level - mode| / (L - 1)."""
-    L = len(p); mode = max(range(L), key=lambda i: p[i])
-    return 1.0 - sum(pi * abs(i - mode) for i, pi in enumerate(p)) / (L - 1)
+    """How closely the probabilities sit around the most likely level: 1 if certain, 0 for a guess.
+
+    `spread` is the expected distance from the most likely level. `guess` is the spread of a guess,
+    equal probability on every level, around the middle. Anything as spread out as a guess gets 0.
+    """
+    L = len(p)
+    if L == 1:
+        return 1.0
+    mode = max(range(L), key=lambda i: p[i])
+    spread = sum(pi * abs(i - mode) for i, pi in enumerate(p))
+    guess = sum(abs(i - (L - 1) / 2) for i in range(L)) / L
+    return max(0.0, 1.0 - spread / guess)
 
 
 def round_prob(x: float) -> float:
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0ecccd50f6af3eebae1e00ad7a98f433e17f36e9). [The code after it](https://github.com/rahuldave/babykev/tree/0ecccd50f6af3eebae1e00ad7a98f433e17f36e9).

<a id="tut-06.10"></a>

### 6.10 A test of a scale with one level

Line 90 runs in no test. A scale of one level leaves nothing to doubt, so its confidence is 1, and a test that calls
`score_confidence` itself can say so.

A patch to [`tests/unit/test_api.py`](#tut-06.10-tests-unit-test_api.py-58d97c).

At the end of `tests/unit/test_api.py`, the new test calls `score_confidence([1.0])`.

```bash
just test
```

`just test` prints `53 passed`, and the total is 100%, 79 of 79 statements.

#### What changed

- <a id="tut-06.10-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the test calls the function itself. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/bb441c7fdf6f8fcd066dbcdd7f7bc03837a661ac/tests/unit/test_api.py).
  - look at `    assert score_confidence([1.0]) == 1.0`

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -291,3 +291,8 @@ def test_score_confidence_prefers_neighbouring_levels():
 def test_score_confidence_is_zero_for_a_guess():
     """Equal probabilities over the levels are a guess, as they are for a choice."""
     assert score_confidence([1 / 3] * 3) == pytest.approx(0)
+
+
+def test_score_confidence_is_one_for_a_single_level():
+    """One level leaves nothing to doubt. A request cannot have one, but the function answers it."""
+    assert score_confidence([1.0]) == 1.0
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/bb441c7fdf6f8fcd066dbcdd7f7bc03837a661ac). [The code after it](https://github.com/rahuldave/babykev/tree/bb441c7fdf6f8fcd066dbcdd7f7bc03837a661ac).
