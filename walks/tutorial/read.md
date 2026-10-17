<!-- Made by the walk skill's render.py from the facts of the walk. Do not edit it by hand: run just walk-update again. -->

# babykev

**Read the tutorial.** Each change explained, with the code to look at. [Build it yourself](build.md) is the other way to read it.

Each part ends with a section called **What changed**. It lists every file that the part changes, with a link to the file, and then the whole diff of each file, folded. A lockfile and a binary file have a link alone. The text above it explains the change.

babykev is a small decision model. It reads a text and a set of questions about it, and gives a probability for
every answer. A question asks for yes or no, for a choice between named options, or for a level on a scale. This
part of the tutorial builds the project around the model, and not the model itself. babykev's contract and its
model come from the first version of [kev](https://github.com/jaredpalmer/kev), by Jared Palmer. The contract is the
set of rules for what a request and an answer hold.

The repository [babykev](https://github.com/rahuldave/babykev/tree/tutorial) holds the model and the project around it, on the branch `tutorial`. At the end, `src/babykev/` holds `cli.py`, the command, `api.py`, the contract, `model.py`, the model, and `smoke.py`, a run of the real model. `tests/unit/` holds the unit and integration tests, and `tests/system/` holds the system test. `data/cheese/` holds sample requests, and `docs/` holds the site. `justfile`, `pyproject.toml` and `uv.lock` say how to work on it, and a `Dockerfile` and `.github/workflows/` run it on other machines. The tools are [uv](https://docs.astral.sh/uv/), [just](https://just.systems/), [pytest](https://docs.pytest.org/), [ruff](https://docs.astral.sh/ruff/), [ty](https://docs.astral.sh/ty/), [smalldocs](https://github.com/rahuldave/smalldocs) and [Docker](https://www.docker.com/).

First, we use uv, a tool that installs Python and the packages a project needs, to make babykev a package. A
package is a project that can be installed, so that its command `babykev` runs in a terminal. We add one list of
tasks in `just`, a tool that runs each task by its name. Then we add tests. They check the command `babykev`, the
contract, and the code that turns the model's probabilities into answers. The project is on the branch `tutorial` of
[babykev](https://github.com/rahuldave/babykev/tree/tutorial).

We make babykev in moves. A move is one small change, made by one patch or by one command. A patch changes a file.
A command such as `uv add`, which adds a package to the project, changes the project's files itself, so its move
needs no patch.

There are two ways to follow. In do mode, you make each move, and the page checks your files against it. When they
match, the move is made, and the next one starts. In watch mode, each change is already made, and the text says
what it did and where to look.

Each move first says what problem it solves. Then it gives the change, piece by piece. Last, a command checks the
result, and a list names each file that changed, with what to look for in it.

<a id="tut-00"></a>

## 0 Where we start

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part is where the project starts, at `tut-00`. [The code of this part](https://github.com/rahuldave/babykev/tree/tut-00)

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

<a id="tut-00-.gitignore-a5cc29-diff"></a>

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

<a id="tut-00-LICENSE-0398cc-diff"></a>

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

<a id="tut-00-NOTICE-fe7187-diff"></a>

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

<a id="tut-00-README.md-8ec9a0-diff"></a>

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

<a id="tut-01"></a>

## 1 The project

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-00`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-00)

babykev must be a Python project before it can hold code. uv makes the project. Then babykev gets its words, its
command, and a justfile that names the tasks of the project.

There is no justfile until the ninth move, so do not run `just` in the project before then. `just` looks for a
justfile in the folder, and then in the folders above it. In the walk repository, the folder above the project has a
justfile of its own. So an early `just setup` runs that recipe, and not one of babykev.

<a id="tut-01.1"></a>

### 1.1 uv makes the project

The folder has words and a licence, but nothing that Python can build or run. `uv init` makes the files of a Python
project. `--package` makes a package in `src/babykev/`, with a command that runs its function `main`.
`--name babykev` names the project, and `--python 3.13` sets the version of Python.

[uv](https://docs.astral.sh/uv/) is a tool, written in Rust, that manages a Python project. It installs Python itself, makes the project's environment `.venv`, adds packages and pins their exact versions in a lockfile. It takes the place of pip, venv and pip-tools, and it is fast. Every command of this tutorial that installs or runs Python goes through uv.

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

<a id="tut-01.1-.python-version-7696e9-diff"></a>

<details><summary>The diff of <code>.python-version</code></summary>

```diff
@@ -0,0 +1 @@
+3.13
```

</details>

<a id="tut-01.1-pyproject.toml-5d07e7-diff"></a>

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

<a id="tut-01.1-src-babykev-__init__.py-a40393-diff"></a>

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

[± See the change to `pyproject.toml`](#tut-01.3-pyproject.toml-5d07e7-diff)

In `pyproject.toml`, the line `description` now says what babykev is.

```bash
grep -n description pyproject.toml
```

`grep` prints the new description, with its line number.

#### What changed

- <a id="tut-01.3-pyproject.toml-5d07e7"></a>`pyproject.toml`: the description. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/0497c0dc9d3772df47e79361aa4165e5de8e227d/pyproject.toml).
  - look at `description = "A small decision model: one state, typed questions, a probability for every answer"`

<a id="tut-01.3-pyproject.toml-5d07e7-diff"></a>

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

[± See the change to `pyproject.toml`](#tut-01.4-pyproject.toml-5d07e7-diff)

In `pyproject.toml`, `license` and `license-files` now stand under `readme`.

```bash
grep -n license pyproject.toml
```

`grep` prints the two lines, with their numbers. The Build it yourself page sets them with a command, which can put
them at the end of `[project]`, so the numbers can differ.

#### What changed

- <a id="tut-01.4-pyproject.toml-5d07e7"></a>`pyproject.toml`: the licence, and the files a package carries. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/414874463b887dedf65c5c74caeac8a064b0e876/pyproject.toml).
  - look at `license-files = ["LICENSE", "NOTICE"]`

<a id="tut-01.4-pyproject.toml-5d07e7-diff"></a>

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

[± See the change to `pyproject.toml`](#tut-01.5-pyproject.toml-5d07e7-diff)

In `pyproject.toml`, `authors` now stands under `license-files`.

```bash
uv lock --check
```

`uv lock --check` says whether `uv.lock` still matches `pyproject.toml`. It prints `Resolved 1 package`, and ends with
exit code 0. The words of the three moves change no dependency, so `uv.lock` stays as it was.

#### What changed

- <a id="tut-01.5-pyproject.toml-5d07e7"></a>`pyproject.toml`: the author. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/7f38877e597f5404208fdca2eabb176077d95a8e/pyproject.toml).
  - look at `authors = [{ name = "Rahul Dave" }]`

<a id="tut-01.5-pyproject.toml-5d07e7-diff"></a>

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

[± See the new file `src/babykev/cli.py`](#tut-01.6-src-babykev-cli.py-a9e184-diff)

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

<a id="tut-01.6-src-babykev-cli.py-a9e184-diff"></a>

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

[± See the change to `pyproject.toml`](#tut-01.7-pyproject.toml-5d07e7-diff)

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

<a id="tut-01.7-pyproject.toml-5d07e7-diff"></a>

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

[± See the change to `src/babykev/__init__.py`](#tut-01.8-src-babykev-__init__.py-a40393-diff)

`src/babykev/__init__.py` is empty. Python still needs the file, because it makes `src/babykev` a package.

```bash
wc -c src/babykev/__init__.py
uv run babykev
```

`wc -c` counts 0 bytes. `uv run babykev` prints the help, as before.

#### What changed

- <a id="tut-01.8-src-babykev-__init__.py-a40393"></a>`src/babykev/__init__.py`: the greeting goes, and the file is empty. 0 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/e32c7ba9f7983fc03cc8d91411562b1eac1d38e9/src/babykev/__init__.py).

<a id="tut-01.8-src-babykev-__init__.py-a40393-diff"></a>

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
indented. Before the justfile comes in, we run the command of the recipe `setup` by hand.

[just](https://just.systems/) runs commands by name. A file called `justfile` lists recipes. Each has a name, a comment that says what it does, and the commands it runs. `just setup` runs the recipe `setup`, and `just` alone lists every recipe. So the justfile is the one place that says how to work on the project, for a person and for a machine.

```bash
uv sync --locked
```

`uv sync` makes `.venv` exactly as `uv.lock` says. `--locked` makes it refuse a `uv.lock` that no longer matches
`pyproject.toml`. It prints `Resolved 1 package`. When `.venv` is already right, it then prints `Checked 1 package`, and changes
nothing. In a new clone, it first prints `Creating virtual environment at: .venv`, and then installs babykev.

[± See the new file `justfile`](#tut-01.9-justfile-424f0b-diff)

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

<a id="tut-01.9-justfile-424f0b-diff"></a>

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
the recipe `setup`, and `just help` alone prints the list.

`help` needs the word after its name, for example `setup` in `just help setup`. The line
`set positional-arguments` passes such words to the commands of a recipe. The first word becomes `"$1"` and the
second `"$2"`, and a word with spaces in it stays one word. So `help` finds the name `setup` in `"$1"`.

[± See the change to `justfile`](#tut-01.10-justfile-424f0b-diff)

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

<a id="tut-01.10-justfile-424f0b-diff"></a>

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

[± See the change to `justfile`](#tut-01.11-justfile-424f0b-diff)

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

<a id="tut-01.11-justfile-424f0b-diff"></a>

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

[± See the change to `justfile`](#tut-01.12-justfile-424f0b-diff)

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

<a id="tut-01.12-justfile-424f0b-diff"></a>

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

[± See the change to `README.md`](#tut-01.13-README.md-8ec9a0-diff)

In `README.md`, "Start" says to run `just setup` first, and then names `just`, `just help VERB` and
`uv run babykev help`.

```bash
grep -n '^## ' README.md
```

`grep` prints the headings of the README, with "Start" among them.

#### What changed

- <a id="tut-01.13-README.md-8ec9a0"></a>`README.md`: how to start. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/0d2e163cca5d3eeb9fc8f7223fddd8d7da735fde/README.md).
  - look at ``Run `just setup` first. It installs Python and every dependency into `.venv`, exactly as `uv.lock` says.``

<a id="tut-01.13-README.md-8ec9a0-diff"></a>

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

[± See the change to `README.md`](#tut-01.14-README.md-8ec9a0-diff)

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

<a id="tut-01.14-README.md-8ec9a0-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7ad3a06605fadc9f34b5e2d8180145a3e53389a9).

This part ends at the code at `tut-01`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-01)

<a id="tut-02"></a>

## 2 Tests of the command

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-01`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-01)

```bash
just setup
```

`just setup` prints `Resolved 1 package`, and `Checked 1 package` when `.venv` already matches `uv.lock`. In a new
clone, it first makes `.venv`, and installs babykev.

We cannot tell whether `babykev` still works after a change, unless we run it by hand and read what it prints. Tests
run it for us. pytest finds the tests and runs them, and a recipe `just test` runs pytest. The first tests are of the
command, the only code that babykev has. Last, coverage shows which lines the tests run.

<a id="tut-02.1"></a>

### 2.1 uv installs every dependency group

The tests need pytest, and a package of babykev does not. A person who installs babykev should not get pytest. So the
tools of the project go in dependency groups. A dependency group is a list of packages in `pyproject.toml` that the
project needs while we work on it. A user of the package never gets them. The test tools go in a group `test`, and
later the linters and the docs tools get groups of their own.

uv installs only the group `dev` by default. The setting `default-groups = "all"` makes `uv sync` and `uv run`
install every group. So each later `uv add --group` needs no other change to `pyproject.toml`. A patch adds the
table `[tool.uv]` with this setting.

[± See the change to `pyproject.toml`](#tut-02.1-pyproject.toml-5d07e7-diff)

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

<a id="tut-02.1-pyproject.toml-5d07e7-diff"></a>

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

[pytest](https://docs.pytest.org/) is the test runner of most Python projects. It finds every file `test_*.py`, runs each function whose name starts with `test_`, and reports each failure with the values that made it fail. A test is a plain function with `assert` in it.

This change came from running `uv add --group test pytest`.

`uv add --group test` writes the group `test` in `pyproject.toml`, under `[dependency-groups]`. It prints
`Resolved 7 packages`, and lists pytest and the four packages it needs.

At the end of `pyproject.toml`, the new table `[dependency-groups]` has the group `test`, with the line
`"pytest>=9.1.1",`. `uv.lock` has pytest and the five packages it needs. One of them, colorama, is only for Windows,
so on a Mac or on Linux uv installs the other four.

```bash
uv run pytest
```

`uv run pytest` looks for tests and finds none. It prints `collected 0 items` and `no tests ran`, and ends with exit
code 5. pytest uses exit code 5 to say that it found no test.

#### What changed

- <a id="tut-02.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: the group `test`, with pytest. 5 lines added. It comes from `uv add --group test pytest`. [The file](https://github.com/rahuldave/babykev/blob/966956d738b58505e23586af60f05cd5daceb12f/pyproject.toml).
  - look at `"pytest>=9.1.1",`
- <a id="tut-02.2-uv.lock-8356d8"></a>`uv.lock`: pytest and the five packages it needs. 71 lines added. It comes from `uv add --group test pytest`. [The file](https://github.com/rahuldave/babykev/blob/966956d738b58505e23586af60f05cd5daceb12f/uv.lock).

<a id="tut-02.2-pyproject.toml-5d07e7-diff"></a>

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

[± See the change to `justfile`](#tut-02.3-justfile-424f0b-diff)

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

<a id="tut-02.3-justfile-424f0b-diff"></a>

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

[± See the new file `tests/unit/test_cli.py`](#tut-02.4-tests-unit-test_cli.py-44d4a0-diff)

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

<a id="tut-02.4-tests-unit-test_cli.py-44d4a0-diff"></a>

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

[± See the change to `tests/unit/test_cli.py`](#tut-02.5-tests-unit-test_cli.py-44d4a0-diff)

At the end of `tests/unit/test_cli.py`, the new test runs `train` inside `pytest.raises(SystemExit)`.

`pytest.raises(SystemExit)` passes only when the code inside it ends the program. The test then checks the exit code,
2, and the two parts of the message.

```bash
just test -k unknown_command
```

`-k unknown` runs the tests with `unknown` in their name. pytest prints `5 items / 4 deselected / 1 selected` and
`1 passed`.

#### What changed

- <a id="tut-02.5-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: the test of a word that is not a command. 10 lines added. [The file](https://github.com/rahuldave/babykev/blob/9a4100fd1962921bc11cf9f4b22c5326c7a51807/tests/unit/test_cli.py).
  - look at `assert exit_info.value.code == 2`

<a id="tut-02.5-tests-unit-test_cli.py-44d4a0-diff"></a>

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

[± See the change to `pyproject.toml`](#tut-02.6-pyproject.toml-5d07e7-diff)

At the end of `pyproject.toml`, the new table `[tool.pytest.ini_options]` has `testpaths = ["tests"]`.

```bash
just test
```

`just test` prints `testpaths: tests` and `5 passed`.

#### What changed

- <a id="tut-02.6-pyproject.toml-5d07e7"></a>`pyproject.toml`: the settings of pytest. pytest looks for tests in `tests/` alone. 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/348290a934c2bd1da0a38f4c3336f66758f8523c/pyproject.toml).
  - look at `testpaths = ["tests"]`

<a id="tut-02.6-pyproject.toml-5d07e7-diff"></a>

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

[pytest-cov](https://pytest-cov.readthedocs.io/) connects pytest to [coverage.py](https://coverage.readthedocs.io/), which records each line of the code that the tests run. The report then names the lines that no test reaches. A line that no test runs can break without any test failing.

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

<a id="tut-02.7-pyproject.toml-5d07e7-diff"></a>

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

[± See the change to `pyproject.toml`](#tut-02.8-pyproject.toml-5d07e7-diff)

At the end of `pyproject.toml`, `addopts` stands under `testpaths`, with a comment above it.

```bash
just test
```

`just test` prints the table with a column `Missing`, empty, because the tests run every line of `cli.py`.

#### What changed

- <a id="tut-02.8-pyproject.toml-5d07e7"></a>`pyproject.toml`: the options of every run. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/f44cc53a91bc7db84283d6a9ded16d9a7bbedf90/pyproject.toml).
  - look at `addopts = "--cov=babykev --cov-report=term-missing"`

<a id="tut-02.8-pyproject.toml-5d07e7-diff"></a>

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

[± See the change to `README.md`](#tut-02.9-README.md-8ec9a0-diff)

In `README.md`, "Start" now says to run `just test`, and gives `just test -k help` as an example.

```bash
just test -k help
```

pytest runs the 4 tests with `help` in their name, and prints `4 passed, 1 deselected`.

#### What changed

- <a id="tut-02.9-README.md-8ec9a0"></a>`README.md`: `just test` in "Start". 3 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/ab192e5bd8ff3e3b8ad6c0ae5e17be31b7790557/README.md).
  - look at `help of the program itself. A recipe gives its extra words to the tool behind it. For example,`

<a id="tut-02.9-README.md-8ec9a0-diff"></a>

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

[± See the change to `README.md`](#tut-02.10-README.md-8ec9a0-diff)

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

<a id="tut-02.10-README.md-8ec9a0-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4640589d80e4f224a4b2c1fd9567e952f564f102).

This part ends at the code at `tut-02`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-02)

<a id="tut-03"></a>

## 3 The contract

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-02`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-02)

```bash
just setup
```

babykev will answer typed questions about a text, and its model comes later. First we fix what a request is and what
an answer is. The agreement is a file from kev, `api.py`, and we call it the contract. It comes in whole.

Then three parts that belong to kev's server go, one at a time. Five sample requests come last. No test reaches the
contract yet, so coverage falls.

<a id="tut-03.1"></a>

### 3.1 Pydantic, the first dependency

The contract is written with pydantic, and babykev does not have it yet. pydantic checks that data has the shape that
a class describes. `uv add` writes the package into `dependencies`, because a package of babykev needs it to run.

[pydantic](https://docs.pydantic.dev/) checks data against a description written as Python classes with type hints. A model says which fields a request has and of what type. pydantic then refuses data that does not fit, with a message that names the field. So the rules of a request live in one place, as code.

This change came from running `uv add pydantic`.

`uv add pydantic` prints `Resolved 14 packages`, and lists what it installed. It installed pydantic and the four
packages that pydantic needs, `annotated-types`, `pydantic-core`, `typing-extensions` and `typing-inspection`.

In `pyproject.toml`, `dependencies` now names pydantic. `uv.lock` has pydantic and the four packages it needs, each at
one exact version.

```bash
uv tree --depth 1
```

`uv tree` prints the dependencies as a tree. `--depth 1` keeps the packages that babykev names itself. It prints
pydantic and its version, and the group `test` with pytest and pytest-cov.

#### What changed

- <a id="tut-03.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the first dependency. `>=2.14.1` is the version that `uv add` found, as the lowest version to accept. 3 lines added, 1 removed. It comes from `uv add pydantic`. [The file](https://github.com/rahuldave/babykev/blob/96502df0a92f6f7090d6f624cda901a271dac9a7/pyproject.toml).
  - look at `"pydantic>=2.14.1",`
- <a id="tut-03.1-uv.lock-8356d8"></a>`uv.lock`: pydantic and the four packages it needs, each with its exact version. 136 lines added. It comes from `uv add pydantic`. [The file](https://github.com/rahuldave/babykev/blob/96502df0a92f6f7090d6f624cda901a271dac9a7/uv.lock).

<a id="tut-03.1-pyproject.toml-5d07e7-diff"></a>

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

### 3.2 api.py, the contract

babykev has no contract yet. `api.py`, from kev, says what a request is and what an answer is. It comes in whole,
all 111 lines, and we read it before we change it.

[± See the new file `src/babykev/api.py`](#tut-03.2-src-babykev-api.py-2ea65f-diff)

`src/babykev/api.py` is new. Lines 14 to 43 are the classes of a request. The functions after them turn a request into
options, and probabilities into answers.

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

#### What changed

- <a id="tut-03.2-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a request has a state and its questions by name. Each question is a `Noul`, a `Choice` or a `Score`, and its field `type` says which. New, 111 lines. [The file](https://github.com/rahuldave/babykev/blob/e8e2e72adad9364a58be21dadf6d757e84436b97/src/babykev/api.py).
  - look at `class SystemOneRequest(BaseModel):`

<a id="tut-03.2-src-babykev-api.py-2ea65f-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e8e2e72adad9364a58be21dadf6d757e84436b97). [The code after it](https://github.com/rahuldave/babykev/tree/e8e2e72adad9364a58be21dadf6d757e84436b97).

<a id="tut-03.3"></a>

### 3.3 The docstring of api.py names no server

kev served the model over HTTP, and babykev has no server. The first line of `api.py` names the address of kev's
server, `POST /v1/systemone`.

[± See the change to `src/babykev/api.py`](#tut-03.3-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, the docstring no longer names `POST /v1/systemone`.

```bash
head -n 1 src/babykev/api.py
```

It prints the new first line.

#### What changed

- <a id="tut-03.3-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the docstring. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/93618951b784e928af3d3547f077bb49bff4d5da/src/babykev/api.py).
  - look at `"""The contract: request and answer shapes, mapped onto the single pointer primitive.`

<a id="tut-03.3-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

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

[± See the change to `src/babykev/api.py`](#tut-03.4-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, `SystemOneRequest` ends with the line `questions`.

```bash
uv run python -c "from babykev.api import SystemOneRequest; print(sorted(SystemOneRequest.model_fields))"
```

`model_fields` lists the fields of a pydantic model. The command prints `['questions', 'state']`.

#### What changed

- <a id="tut-03.4-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a request has two fields, `state` and `questions`. 0 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/5cce9c9e5025336d501298d244389b64c696737c/src/babykev/api.py).
  - look at `    questions: dict[str, Question] = Field(min_length=1)`

<a id="tut-03.4-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

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

[± See the change to `src/babykev/api.py`](#tut-03.5-src-babykev-api.py-2ea65f-diff)

`src/babykev/api.py` now ends with `to_answers`.

```bash
wc -l src/babykev/api.py
just test
```

`wc -l` counts 104 lines. `just test` prints `5 passed`, and the total is 11%, 8 of 74 statements.

#### What changed

- <a id="tut-03.5-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the function goes. 0 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/43b7ea4eda990f90abd605920e2fb1d9b376378d/src/babykev/api.py).

<a id="tut-03.5-src-babykev-api.py-2ea65f-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/43b7ea4eda990f90abd605920e2fb1d9b376378d). [The code after it](https://github.com/rahuldave/babykev/tree/43b7ea4eda990f90abd605920e2fb1d9b376378d).

<a id="tut-03.6"></a>

### 3.6 Five requests about cheese, as sample data

The tests of the contract need requests to check, and the project has none. Five requests about cheese come in a file
of their own. Each line of the file is one request, in JSON. Each question has a `label`, the right answer.

[± See the new file `data/cheese/sample.jsonl`](#tut-03.6-data-cheese-sample.jsonl-79f982-diff)

`data/cheese/sample.jsonl` is new, with one request on each line.

```bash
head -n 1 data/cheese/sample.jsonl | python3 -m json.tool
```

`python3 -m json.tool` prints JSON with one key on each line. The first request is about the cheese Coquetdale, and
asks three questions. `vegetarian` is a `noul` with the label `true`. `intensity` is a `score` of four levels with the
label `1`, the second level. `milk` is a `choice` of five options with the label `cow`.

#### What changed

- <a id="tut-03.6-data-cheese-sample.jsonl-79f982"></a>`data/cheese/sample.jsonl`: each line is a request with a `state` and its `questions`. New, 5 lines. [The file](https://github.com/rahuldave/babykev/blob/abb4ece53e114b331e9e32d67309e1f54f9f964e/data/cheese/sample.jsonl).

<a id="tut-03.6-data-cheese-sample.jsonl-79f982-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/abb4ece53e114b331e9e32d67309e1f54f9f964e). [The code after it](https://github.com/rahuldave/babykev/tree/abb4ece53e114b331e9e32d67309e1f54f9f964e).

<a id="tut-03.7"></a>

### 3.7 The README names the contract and the data

The table of the README names neither the contract nor the data. Rows for `api.py`, `cli.py` and the sample data take
the place of the row of `src/babykev/`.

[± See the change to `README.md`](#tut-03.7-README.md-8ec9a0-diff)

In the table of `README.md`, the rows of `src/babykev/api.py`, `src/babykev/cli.py` and `data/cheese/sample.jsonl`
stand above the row of the tests.

```bash
grep -n -E 'api.py|sample.jsonl' README.md
```

`grep` prints the two new rows.

#### What changed

- <a id="tut-03.7-README.md-8ec9a0"></a>`README.md`: the rows of the contract and the data. 3 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/56606771fb23f7a0a01825f477050d2980a47736/README.md).
  - look at ``| `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |``

<a id="tut-03.7-README.md-8ec9a0-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/56606771fb23f7a0a01825f477050d2980a47736).

This part ends at the code at `tut-03`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-03)

<a id="tut-04"></a>

## 4 What a request is

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-03`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-03)

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

[± See the new file `tests/unit/test_api.py`](#tut-04.1-tests-unit-test_api.py-58d97c-diff)

The new file `tests/unit/test_api.py` reads the sample data into `SAMPLE_LINES`, and has one test,
`test_sample_line_fits_the_contract`.

```bash
just test
```

`just test` prints `10 passed`, the 5 of the command and one for each sample line. `api.py` is at 77%. The missing
lines are the functions that turn probabilities into answers.

#### What changed

- <a id="tut-04.1-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the sample data, and the test that checks each line. New, 27 lines. [The file](https://github.com/rahuldave/babykev/blob/5e134165b7e1feeded775bcfb2269aec951ad39f/tests/unit/test_api.py).
  - look at `def test_sample_line_fits_the_contract(line):`

<a id="tut-04.1-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5e134165b7e1feeded775bcfb2269aec951ad39f). [The code after it](https://github.com/rahuldave/babykev/tree/5e134165b7e1feeded775bcfb2269aec951ad39f).

<a id="tut-04.2"></a>

### 4.2 Every question of the sample data has a label

The tests will compare answers with labels, so each label must have the right kind. A label is a boolean for a noul,
the name of an option for a choice, and the number of a level for a score.

[± See the change to `tests/unit/test_api.py`](#tut-04.2-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the new test checks the label of every question of each line.

```bash
just test -k label
```

pytest runs the new test once for each line, and prints `5 passed`.

#### What changed

- <a id="tut-04.2-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the labels of the sample data. 13 lines added. [The file](https://github.com/rahuldave/babykev/blob/1ca39523b4fdf6c75c244b8c0e0f2371593cfbff/tests/unit/test_api.py).
  - look at `def test_sample_line_has_a_usable_label_on_every_question(line):`

<a id="tut-04.2-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1ca39523b4fdf6c75c244b8c0e0f2371593cfbff). [The code after it](https://github.com/rahuldave/babykev/tree/1ca39523b4fdf6c75c244b8c0e0f2371593cfbff).

<a id="tut-04.3"></a>

### 4.3 A request holds one model for each type of question

The field `type` of a question decides which class of the contract it becomes. A helper, `cheese_request`, makes one
request with a question of each type, for the tests to share. The test checks that the noul is a `Noul`, the choice a
`Choice` and the score a `Score`.

[± See the change to `tests/unit/test_api.py`](#tut-04.3-tests-unit-test_api.py-58d97c-diff)

In `tests/unit/test_api.py`, `cheese_request` stands under the constants. The new test at the end checks the class of
each of its three questions.

```bash
just test -k one_model
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.3-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the helper, and the test of the three types. 32 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/847d160f4a2f014bd58eb06030268ce762577cbc/tests/unit/test_api.py).
  - look at `def test_request_holds_one_model_per_question_type():`

<a id="tut-04.3-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/847d160f4a2f014bd58eb06030268ce762577cbc). [The code after it](https://github.com/rahuldave/babykev/tree/847d160f4a2f014bd58eb06030268ce762577cbc).

<a id="tut-04.4"></a>

### 4.4 A request without questions is refused

A request must ask at least one question. `Field(min_length=1)` on `questions` says so. The test checks that pydantic
refuses a request with none.

[± See the change to `tests/unit/test_api.py`](#tut-04.4-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the new test expects a `ValidationError` for `"questions": {}`.

```bash
just test -k without_questions
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.4-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a request with no questions. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/c2af99cdd8e0b6f40e33a1ebcf9aa602904a83ba/tests/unit/test_api.py).
  - look at `def test_request_without_questions_is_rejected():`

<a id="tut-04.4-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c2af99cdd8e0b6f40e33a1ebcf9aa602904a83ba). [The code after it](https://github.com/rahuldave/babykev/tree/c2af99cdd8e0b6f40e33a1ebcf9aa602904a83ba).

<a id="tut-04.5"></a>

### 4.5 An unknown type of question is refused

Only noul, choice and score exist. The test gives a question the type `essay`, and expects a refusal.

[± See the change to `tests/unit/test_api.py`](#tut-04.5-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the new test makes a question of type `essay`.

```bash
just test -k unknown_question
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.5-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a type that does not exist. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/6acc5e7d6f228ce76a9083d915f238c3d6696c85/tests/unit/test_api.py).
  - look at `question = {"type": "essay", "instructions": "Describe this cheese."}`

<a id="tut-04.5-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/6acc5e7d6f228ce76a9083d915f238c3d6696c85). [The code after it](https://github.com/rahuldave/babykev/tree/6acc5e7d6f228ce76a9083d915f238c3d6696c85).

<a id="tut-04.6"></a>

### 4.6 A noul needs no criteria

A question of yes or no may leave out what yes and no mean. The test makes a `Noul` with no criteria, and checks that
its criteria are `None`.

[± See the change to `tests/unit/test_api.py`](#tut-04.6-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the new test makes a `Noul` with an instruction alone.

```bash
just test -k noul_needs
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.6-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a noul without criteria. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/3a99587d325837f9104661b3d06d9630679dc8eb/tests/unit/test_api.py).
  - look at `assert Noul(type="noul", instructions="Is it blue?").criteria is None`

<a id="tut-04.6-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3a99587d325837f9104661b3d06d9630679dc8eb). [The code after it](https://github.com/rahuldave/babykev/tree/3a99587d325837f9104661b3d06d9630679dc8eb).

<a id="tut-04.7"></a>

### 4.7 A choice without options is refused

A choice needs at least one option. The test gives a `Choice` empty criteria, and expects a refusal.

[± See the change to `tests/unit/test_api.py`](#tut-04.7-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the new test makes a `Choice` with `criteria={}`.

```bash
just test -k choice_without
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.7-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a choice of nothing. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/4653d298261d887195e59a2cf00593036151657c/tests/unit/test_api.py).
  - look at `def test_choice_without_options_is_rejected():`

<a id="tut-04.7-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4653d298261d887195e59a2cf00593036151657c). [The code after it](https://github.com/rahuldave/babykev/tree/4653d298261d887195e59a2cf00593036151657c).

<a id="tut-04.8"></a>

### 4.8 A choice has at most MAX_OPTIONS options

`MAX_OPTIONS` is 255. The test makes a choice of exactly 255 options, which is valid, and one of 256, which is
refused. A limit is tested on both of its sides.

[± See the change to `tests/unit/test_api.py`](#tut-04.8-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the new test makes `at_limit`, 255 options, and then adds `one_more`.

```bash
just test -k largest
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-04.8-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the limit, from both sides. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/3addf0f2bd69e0910ba506a41a240fec5218c77a/tests/unit/test_api.py).
  - look at `at_limit = {f"option{i}": None for i in range(MAX_OPTIONS)}`

<a id="tut-04.8-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3addf0f2bd69e0910ba506a41a240fec5218c77a). [The code after it](https://github.com/rahuldave/babykev/tree/3addf0f2bd69e0910ba506a41a240fec5218c77a).

<a id="tut-04.9"></a>

### 4.9 A score of one level is refused

A scale needs two levels at least, or it measures nothing. The test gives a `Score` one level, and expects a refusal.

[± See the change to `tests/unit/test_api.py`](#tut-04.9-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the new test makes a `Score` with the one level `Soft`.

```bash
just test
```

`just test` prints `22 passed`. `api.py` is still at 77%. The tests of validation run lines that the sample data ran
already.

#### What changed

- <a id="tut-04.9-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a scale of one level. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/b9a4861a26a74623a6daf8c7c776cebe5f30a626/tests/unit/test_api.py).
  - look at `Score(type="score", instructions="How firm?", criteria=["Soft"])`

<a id="tut-04.9-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b9a4861a26a74623a6daf8c7c776cebe5f30a626). [The code after it](https://github.com/rahuldave/babykev/tree/b9a4861a26a74623a6daf8c7c776cebe5f30a626).

<a id="tut-04.10"></a>

### 4.10 The README names the tests of the contract

The row of `tests/unit/` names only the tests of the command. It now names the tests of the contract too.

[± See the change to `README.md`](#tut-04.10-README.md-8ec9a0-diff)

In the table of `README.md`, the row of `tests/unit/` names the tests of the contract and the sample data.

```bash
grep -n 'tests/unit' README.md
```

`grep` prints the new row.

#### What changed

- <a id="tut-04.10-README.md-8ec9a0"></a>`README.md`: the row of the tests. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/1fef13ae49e24d280d05c250289c41d5636feff7/README.md).
  - look at ``| `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |``

<a id="tut-04.10-README.md-8ec9a0-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1fef13ae49e24d280d05c250289c41d5636feff7).

This part ends at the code at `tut-04`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-04)

<a id="tut-05"></a>

## 5 From a request to the model, and back

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-04`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-04)

```bash
just setup
```

The contract also maps a request to what the model reads, and the model's probabilities back to answers. `render`
turns JSON into text, `option_text` writes an option, `to_record` turns a request into a record, and `to_answers`
turns probabilities into answers. Each test checks one of their rules.

<a id="tut-05.1"></a>

### 5.1 render turns JSON into text

The model reads text, and the state of a request is JSON. `render` writes JSON as text. One test gives `render` nine
values, from `None` to a list of objects, and checks the text of each.

[± See the change to `tests/unit/test_api.py`](#tut-05.1-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the parametrized test lists nine pairs, each a value and its text.

```bash
just test -k render
```

pytest prints `9 passed`, one for each value.

#### What changed

- <a id="tut-05.1-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: nine values, and their text. 26 lines added. [The file](https://github.com/rahuldave/babykev/blob/9f861048b50c3705e7e1195ccbd90a7b01e60180/tests/unit/test_api.py).
  - look at `def test_render_flattens_json_into_text(value, text):`

<a id="tut-05.1-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9f861048b50c3705e7e1195ccbd90a7b01e60180). [The code after it](https://github.com/rahuldave/babykev/tree/9f861048b50c3705e7e1195ccbd90a7b01e60180).

<a id="tut-05.2"></a>

### 5.2 An option has a description only when it has one

An option is its name, followed by its description when it has one. `option_text` writes it. The test gives it no
description, an empty one, and a real one.

[± See the change to `tests/unit/test_api.py`](#tut-05.2-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test gives `option_text` three cases.

```bash
just test -k option_text
```

pytest prints `3 passed`.

#### What changed

- <a id="tut-05.2-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: three cases of an option. 14 lines added. [The file](https://github.com/rahuldave/babykev/blob/e6270727deb4467393c6c7b73cfaf0908392387f/tests/unit/test_api.py).
  - look at `def test_option_text_adds_a_description_only_when_there_is_one(name, description, text):`

<a id="tut-05.2-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e6270727deb4467393c6c7b73cfaf0908392387f). [The code after it](https://github.com/rahuldave/babykev/tree/e6270727deb4467393c6c7b73cfaf0908392387f).

<a id="tut-05.3"></a>

### 5.3 A record keeps the state and the order of questions

`to_record` turns a request into a record, the text and options that the model reads, and the metadata that maps
them back. The test checks that the state is rendered once, and that the questions keep their order.

[± See the change to `tests/unit/test_api.py`](#tut-05.3-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test reads `record["state"]` and the order of the questions.

```bash
just test -k keeps_the_state
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-05.3-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the state, and the order. 15 lines added. [The file](https://github.com/rahuldave/babykev/blob/3d272bd2edaf22b970b8888429dd23940ffd3f17/tests/unit/test_api.py).
  - look at `assert [m["id"] for m in meta] == ["blue", "milk", "firmness"]`

<a id="tut-05.3-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3d272bd2edaf22b970b8888429dd23940ffd3f17). [The code after it](https://github.com/rahuldave/babykev/tree/3d272bd2edaf22b970b8888429dd23940ffd3f17).

<a id="tut-05.4"></a>

### 5.4 A noul becomes no, then yes

A noul has two options, `no` first and `yes` second. The code counts the options from 0, so `yes` is option 1. The
answer to a noul is the probability of option 1.

[± See the change to `tests/unit/test_api.py`](#tut-05.4-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test checks the options `["no", "yes"]`.

```bash
just test -k no_then_yes
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-05.4-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the two options of a noul. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/7dee26abd961a5a85d897f82332ae46e556e2f80/tests/unit/test_api.py).
  - look at `assert record["questions"][0]["options"] == ["no", "yes"]`

<a id="tut-05.4-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7dee26abd961a5a85d897f82332ae46e556e2f80). [The code after it](https://github.com/rahuldave/babykev/tree/7dee26abd961a5a85d897f82332ae46e556e2f80).

<a id="tut-05.5"></a>

### 5.5 The criteria of a noul describe no and yes

A noul can say what yes and no mean, under `true` and `false`. They become the descriptions of the two options.

[± See the change to `tests/unit/test_api.py`](#tut-05.5-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test expects `"no: It has none"` and `"yes: It has blue veins"`.

```bash
just test -k describe_no
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-05.5-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the descriptions of no and yes. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/f9b390d64cc717326b28f9c7a6adbb88de59363f/tests/unit/test_api.py).
  - look at `def test_noul_criteria_describe_no_and_yes():`

<a id="tut-05.5-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f9b390d64cc717326b28f9c7a6adbb88de59363f). [The code after it](https://github.com/rahuldave/babykev/tree/f9b390d64cc717326b28f9c7a6adbb88de59363f).

<a id="tut-05.6"></a>

### 5.6 A choice becomes one option per criterion

A choice has one option for each criterion, in order, and the metadata keeps their names.

[± See the change to `tests/unit/test_api.py`](#tut-05.6-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test expects four options, the last with its description.

```bash
just test -k one_option_per_criterion
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-05.6-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the options of a choice. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/0930c8de69e9710470eb60380b99cae5c3e82558/tests/unit/test_api.py).
  - look at `def test_choice_becomes_one_option_per_criterion_in_order():`

<a id="tut-05.6-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0930c8de69e9710470eb60380b99cae5c3e82558). [The code after it](https://github.com/rahuldave/babykev/tree/0930c8de69e9710470eb60380b99cae5c3e82558).

<a id="tut-05.7"></a>

### 5.7 A score becomes one option per level

A score has one option for each level, in order. Its legend maps the number of each level to its name.

[± See the change to `tests/unit/test_api.py`](#tut-05.7-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test checks the options and the legend of `firmness`.

```bash
just test -k one_option_per_level
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-05.7-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the levels, and the legend. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/8368a8202dab8159f95043310e2bf22a24c1e474/tests/unit/test_api.py).
  - look at `def test_score_becomes_one_option_per_level_with_a_legend():`

<a id="tut-05.7-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/8368a8202dab8159f95043310e2bf22a24c1e474). [The code after it](https://github.com/rahuldave/babykev/tree/8368a8202dab8159f95043310e2bf22a24c1e474).

<a id="tut-05.8"></a>

### 5.8 The answer of a noul is the probability of yes

`to_answers` turns the probabilities of the model into answers. The answer to a noul is one number, the probability of
yes.

[± See the change to `tests/unit/test_api.py`](#tut-05.8-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test gives `to_answers` the probabilities `[0.25, 0.75]`, and expects
`0.75`.

```bash
just test
```

`just test` prints `40 passed`, and `api.py` is at 86%.

#### What changed

- <a id="tut-05.8-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the answer of a noul. 10 lines added. [The file](https://github.com/rahuldave/babykev/blob/0740c2c246273e99e34494512152d5b97ea4f7b9/tests/unit/test_api.py).
  - look at `assert answers == {"blue": {"type": "noul", "noul": 0.75}}`

<a id="tut-05.8-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0740c2c246273e99e34494512152d5b97ea4f7b9). [The code after it](https://github.com/rahuldave/babykev/tree/0740c2c246273e99e34494512152d5b97ea4f7b9).

<a id="tut-05.9"></a>

### 5.9 A choice names the most likely option

The answer to a choice has its most likely option, a probability for each option, and a confidence.

[± See the change to `tests/unit/test_api.py`](#tut-05.9-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test gives `[0.1, 0.7, 0.2]`, and expects `goat`.

```bash
just test
```

`just test` prints `41 passed`, and `api.py` is at 94%.

#### What changed

- <a id="tut-05.9-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the answer of a choice. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/a27b71f6a341bb12029a2d3471d6b3bc19d0d94c/tests/unit/test_api.py).
  - look at `assert answer["choice"] == "goat"`

<a id="tut-05.9-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a27b71f6a341bb12029a2d3471d6b3bc19d0d94c). [The code after it](https://github.com/rahuldave/babykev/tree/a27b71f6a341bb12029a2d3471d6b3bc19d0d94c).

<a id="tut-05.10"></a>

### 5.10 A score answers with the expected level

The answer to a score is the expected level, the mean of the levels weighted by their probabilities. For
`[0.1, 0.2, 0.7]` it is 0 × 0.1 + 1 × 0.2 + 2 × 0.7 = 1.6.

[± See the change to `tests/unit/test_api.py`](#tut-05.10-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test expects the score `1.6`.

```bash
just test
```

`just test` prints `42 passed`, and `api.py` is at 100%.

#### What changed

- <a id="tut-05.10-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the answer of a score. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/be8c681092973e7ac1e12bbd1817da81bea45e7e/tests/unit/test_api.py).
  - look at `assert answer["score"] == pytest.approx(1.6)`

<a id="tut-05.10-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/be8c681092973e7ac1e12bbd1817da81bea45e7e). [The code after it](https://github.com/rahuldave/babykev/tree/be8c681092973e7ac1e12bbd1817da81bea45e7e).

<a id="tut-05.11"></a>

### 5.11 Every question gets an answer of its own type

A request of three questions must get three answers, each under the id of its question, each of its type. The test
runs `to_record` and `to_answers` one after the other.

[± See the change to `tests/unit/test_api.py`](#tut-05.11-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test checks the type of the answer to each of the three questions.

```bash
just test
```

`just test` prints `43 passed`, and every line of `api.py` runs, 100%. Two lines are still wrong, and the next part
shows them. Coverage says which lines ran. It does not say that a test checked what each line does.

#### What changed

- <a id="tut-05.11-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: one answer for each question. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/c2f89d37a513382eb2209c2c393e6a4c5a6eb50f/tests/unit/test_api.py).
  - look at `def test_every_question_gets_an_answer_of_its_own_type():`

<a id="tut-05.11-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c2f89d37a513382eb2209c2c393e6a4c5a6eb50f).

This part ends at the code at `tut-05`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-05)

<a id="tut-06"></a>

## 6 Kev's two bugs

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-05`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-05)

```bash
just setup
```

Every line of the contract runs in a test, and two of them are wrong. A test of rounding finds the first. The tests of
confidence find the second. Each test fails, and the move after it fixes the code.

<a id="tut-06.1"></a>

### 6.1 A test of rounding, which fails

The probabilities of an answer must sum to 1. The test makes a choice of 77 options with the same probability, 1/77
each. `pytest.approx(1, abs=0.02)` accepts any number from 0.98 to 1.02. The test fails on purpose, because it finds
a bug of kev.

[± See the change to `tests/unit/test_api.py`](#tut-06.1-tests-unit-test_api.py-58d97c-diff)

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

- <a id="tut-06.1-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the sum of the rounded probabilities. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/9012b28ceacd0bcc3971154a5df2f822e551443d/tests/unit/test_api.py).
  - look at `    assert sum(answer["probabilities"].values()) == pytest.approx(1, abs=0.02)`

<a id="tut-06.1-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9012b28ceacd0bcc3971154a5df2f822e551443d). [The code after it](https://github.com/rahuldave/babykev/tree/9012b28ceacd0bcc3971154a5df2f822e551443d).

<a id="tut-06.2"></a>

### 6.2 Probabilities rounded to four decimals

Two decimals lose too much, and 77 equal options sum to 0.77. `round_prob` takes the place of `r2`, and rounds to four
decimals. Each 1/77 becomes 0.013, and the 77 probabilities sum to 1.001, within 0.02 of 1.

[± See the change to `src/babykev/api.py`](#tut-06.2-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, `round_prob` stands where `r2` was, and `to_answers` calls it.

```bash
just test -k sum_to_one
just test
```

`just test -k sum_to_one` prints `1 passed`. The test did not change, and the code did. `just test` prints `44 passed`.

#### What changed

- <a id="tut-06.2-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: four decimals. 8 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/27e93dd7ee76e609084a1d8a1c1cfbb4f7811da4/src/babykev/api.py).
  - look at `    return round(float(x), 4)`

<a id="tut-06.2-src-babykev-api.py-2ea65f-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/27e93dd7ee76e609084a1d8a1c1cfbb4f7811da4). [The code after it](https://github.com/rahuldave/babykev/tree/27e93dd7ee76e609084a1d8a1c1cfbb4f7811da4).

<a id="tut-06.3"></a>

### 6.3 A guess between options has confidence 0

Confidence runs from 1, when the model is sure, to 0, when it knows nothing. A choice that gives every option the same
probability is a guess.

[± See the change to `tests/unit/test_api.py`](#tut-06.3-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test gives `choice_confidence` four equal probabilities.

```bash
just test -k confidence
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-06.3-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a guess between four options. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/27f1f23cc392446dd80918636dfc7a3c52692aae/tests/unit/test_api.py).
  - look at `assert choice_confidence([0.25] * 4) == pytest.approx(0)`

<a id="tut-06.3-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/27f1f23cc392446dd80918636dfc7a3c52692aae). [The code after it](https://github.com/rahuldave/babykev/tree/27f1f23cc392446dd80918636dfc7a3c52692aae).

<a id="tut-06.4"></a>

### 6.4 A certain choice has confidence 1

All the probability on one option is certainty, with three options or with one.

[± See the change to `tests/unit/test_api.py`](#tut-06.4-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test checks `[0, 1, 0]` and `[1.0]`.

```bash
just test -k confidence
```

pytest prints `2 passed`.

#### What changed

- <a id="tut-06.4-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: certainty. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/9ded0b3177719bb849eda76972daa2f5368af069/tests/unit/test_api.py).
  - look at `assert choice_confidence([0, 1, 0]) == pytest.approx(1)`

<a id="tut-06.4-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9ded0b3177719bb849eda76972daa2f5368af069). [The code after it](https://github.com/rahuldave/babykev/tree/9ded0b3177719bb849eda76972daa2f5368af069).

<a id="tut-06.5"></a>

### 6.5 The confidence of a choice grows with its winner

Between a guess and certainty, confidence follows the probability of the most likely option. `[0.5, 0.25, 0.25]` gets
0.25.

[± See the change to `tests/unit/test_api.py`](#tut-06.5-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test expects 0.25 for `[0.5, 0.25, 0.25]`.

```bash
just test -k confidence
```

pytest prints `3 passed`.

#### What changed

- <a id="tut-06.5-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a confidence between 0 and 1. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/890fbe0900f6a0f59232ca9d94ce4cc439e21dde/tests/unit/test_api.py).
  - look at `assert choice_confidence([0.5, 0.25, 0.25]) == pytest.approx(0.25)`

<a id="tut-06.5-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/890fbe0900f6a0f59232ca9d94ce4cc439e21dde). [The code after it](https://github.com/rahuldave/babykev/tree/890fbe0900f6a0f59232ca9d94ce4cc439e21dde).

<a id="tut-06.6"></a>

### 6.6 A certain score has confidence 1

A score has its own confidence, which measures how close the probabilities sit to the most likely level. All the
probability on one level is certainty, wherever the level is. The test runs for each of three levels.

[± See the change to `tests/unit/test_api.py`](#tut-06.6-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the parametrized test puts 1.0 on level 0, 1 and 2 in turn.

```bash
just test -k confidence
```

pytest prints `6 passed`.

#### What changed

- <a id="tut-06.6-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: certainty, on each level. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/d2564e48ae134802f1d48cc079cfe3b92db14639/tests/unit/test_api.py).
  - look at `def test_score_confidence_is_one_when_certain(level):`

<a id="tut-06.6-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/d2564e48ae134802f1d48cc079cfe3b92db14639). [The code after it](https://github.com/rahuldave/babykev/tree/d2564e48ae134802f1d48cc079cfe3b92db14639).

<a id="tut-06.7"></a>

### 6.7 A score prefers neighbouring levels

Doubt between two neighbouring levels is closer to certain than doubt between the two ends of the scale.

[± See the change to `tests/unit/test_api.py`](#tut-06.7-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the test compares `[0.5, 0.5, 0, 0]` with `[0.5, 0, 0, 0.5]`.

```bash
just test -k confidence
```

pytest prints `7 passed`.

#### What changed

- <a id="tut-06.7-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: near is better than far. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/795356b136ab4b1b1c22c8e63b8175a1a6f6d6de/tests/unit/test_api.py).
  - look at `assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])`

<a id="tut-06.7-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/795356b136ab4b1b1c22c8e63b8175a1a6f6d6de). [The code after it](https://github.com/rahuldave/babykev/tree/795356b136ab4b1b1c22c8e63b8175a1a6f6d6de).

<a id="tut-06.8"></a>

### 6.8 A guess between levels has confidence 0, and the test fails

A score that gives every level the same probability is a guess, as it is for a choice, and its confidence must be 0.
The test fails on purpose, because it finds the second bug of kev.

[± See the change to `tests/unit/test_api.py`](#tut-06.8-tests-unit-test_api.py-58d97c-diff)

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

- <a id="tut-06.8-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a guess between three levels. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/72a00ec85ae4b6f3b591cf06fc65903a56f1f7fa/tests/unit/test_api.py).
  - look at `assert score_confidence([1 / 3] * 3) == pytest.approx(0)`

<a id="tut-06.8-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/72a00ec85ae4b6f3b591cf06fc65903a56f1f7fa). [The code after it](https://github.com/rahuldave/babykev/tree/72a00ec85ae4b6f3b591cf06fc65903a56f1f7fa).

<a id="tut-06.9"></a>

### 6.9 The confidence of a score measures against a guess

A guess gets confidence 0.5, because the code measures the spread against the length of the scale. The fix measures it
against the spread of a guess around the middle level.

[± See the change to `src/babykev/api.py`](#tut-06.9-src-babykev-api.py-2ea65f-diff)

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

- <a id="tut-06.9-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the spread of a guess, as the measure. 12 lines added, 4 removed. [The file](https://github.com/rahuldave/babykev/blob/e97355545c4001a361257c532330f8784aa51b79/src/babykev/api.py).
  - look at `    guess = sum(abs(i - (L - 1) / 2) for i in range(L)) / L`

<a id="tut-06.9-src-babykev-api.py-2ea65f-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e97355545c4001a361257c532330f8784aa51b79). [The code after it](https://github.com/rahuldave/babykev/tree/e97355545c4001a361257c532330f8784aa51b79).

<a id="tut-06.10"></a>

### 6.10 A test of a scale with one level

Line 90 runs in no test. A scale of one level leaves nothing to doubt, so its confidence is 1, and a test that calls
`score_confidence` itself can say so.

[± See the change to `tests/unit/test_api.py`](#tut-06.10-tests-unit-test_api.py-58d97c-diff)

At the end of `tests/unit/test_api.py`, the new test calls `score_confidence([1.0])`.

```bash
just test
```

`just test` prints `53 passed`, and the total is 100%, 79 of 79 statements.

#### What changed

- <a id="tut-06.10-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the test calls the function itself. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/910716f0cec79c3f31afb34cf3a2593f0cd51315/tests/unit/test_api.py).
  - look at `    assert score_confidence([1.0]) == 1.0`

<a id="tut-06.10-tests-unit-test_api.py-58d97c-diff"></a>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/910716f0cec79c3f31afb34cf3a2593f0cd51315).

This part ends at the code at `tut-06`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-06)

<a id="tut-07"></a>

## 7 Format

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-06`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-06)

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

This change came from running `uv add --group lint ruff`.

`uv add` prints `Resolved 15 packages`, and installs ruff. ruff is one program, and needs no other
package.

In `pyproject.toml`, the new group `lint` is on lines 26 to 28, above the group `test`, with the line
`"ruff>=0.17.1",`. `uv.lock` has ruff 0.17.1.

```bash
uv run ruff --version
uv run ruff format --check
```

`uv run ruff --version` prints the version of ruff that uv installed. `ruff format --check` changes nothing. It prints what it would
change in each file, and ends with `3 files would be reformatted, 3 files already formatted`, and exit code 1. The
three files are `src/babykev/api.py`, `src/babykev/cli.py` and `tests/unit/test_api.py`. By default, ruff lets a
line run to 88 characters. Line 19 of `cli.py` has 94 characters, so ruff would split it.

#### What changed

- <a id="tut-07.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the group `lint`, with ruff. 3 lines added. It comes from `uv add --group lint ruff`. [The file](https://github.com/rahuldave/babykev/blob/5085d2a6ae47a58d6259dfa06679bb2a9be692e1/pyproject.toml).
  - look at `"ruff>=0.17.1",`
- <a id="tut-07.1-uv.lock-8356d8"></a>`uv.lock`: ruff, at its exact version. 29 lines added. It comes from `uv add --group lint ruff`. [The file](https://github.com/rahuldave/babykev/blob/5085d2a6ae47a58d6259dfa06679bb2a9be692e1/uv.lock).

<a id="tut-07.1-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the change to `pyproject.toml`](#tut-07.2-pyproject.toml-5d07e7-diff)

At the end of `pyproject.toml`, the new table `[tool.ruff]` is on lines 39 to 41, with `line-length = 100`.

```bash
uv run ruff format --check
```

The check now ends with `1 file would be reformatted, 5 files already formatted`, and exit code 1. `cli.py` and the
tests have no line over 100 characters, so they pass, and `api.py` still fails. ruff prints each change it would
make, with the old lines marked `-` and the new ones `+`. The one-line `if` of `_check`, at line 27, becomes two
lines, and so do the three of `render`, at lines 48 to 50. The long dictionaries of `to_record` and `to_answers`
are split, one key on each line.

#### What changed

- <a id="tut-07.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: the table `[tool.ruff]`. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/58d9bddfeea6344a159569664ac9f9ff489173a6/pyproject.toml).
  - look at `line-length = 100`

<a id="tut-07.2-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the change to `pyproject.toml`](#tut-07.3-pyproject.toml-5d07e7-diff)

At the end of `pyproject.toml`, the new table `[tool.ruff.format]` is on lines 43 to 49. It sets double quotes, four
spaces, and three more defaults, each with a comment.

`skip-magic-trailing-comma = false` is the one that a reader meets most. A list that ends with a comma keeps one item
on each line, even when it would fit on one line. The group `lint`, on lines 26 to 28, is such a list.

```bash
uv run ruff format --check
```

The check prints the same as before, `1 file would be reformatted, 5 files already formatted`. The settings are the
defaults, so nothing changes.

#### What changed

- <a id="tut-07.3-pyproject.toml-5d07e7"></a>`pyproject.toml`: the five settings of the formatter. 8 lines added. [The file](https://github.com/rahuldave/babykev/blob/ff4c6545868df1f51d5aa04277cd16b868550f14/pyproject.toml).
  - look at `quote-style = "double"            # "text", not 'text'`

<a id="tut-07.3-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the change to `justfile`](#tut-07.4-justfile-424f0b-diff)

In `justfile`, the recipe `fmt` is on lines 28 to 32, above `test`, in the group `quality`. It runs
`uv run ruff format "$@"`.

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

#### What changed

- <a id="tut-07.4-justfile-424f0b"></a>`justfile`: the recipe `fmt`. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/03e6443db4c837a51df4786117a33b1d20040c88/justfile).
  - look at `fmt *args:`

<a id="tut-07.4-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

This change came from running `just fmt`.

`just fmt` prints `1 file reformatted, 5 files left unchanged`.

`src/babykev/api.py` grows from 114 lines to 141. A blank line now comes after the docstring, on line 7. Each `if`
of `_check` and of `render` has its statement on a line of its own, on lines 28 to 29 and 50 to 55. The long lines
of `render`, `to_record` and `to_answers` are split, one part or one key on each line. They are now lines 56 to 61,
82 to 88, 126 to 131 and 134 to 140.

```bash
just fmt --check
just test
```

`just fmt --check` prints `6 files already formatted`, and ends with exit code 0. `just test` prints `53 passed`, and
a total of 100%, of 83 statements. `api.py` has 75 of them. Coverage counts each line with a statement, and each of
the four one-line `if` statements of `_check` and `render` is now two lines.

At tut-06, before `just fmt`, `just test` counted 79 statements, and 71 in `api.py`. The four new lines are the four
new statements.

#### What changed

- <a id="tut-07.5-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the same code, in the style of the formatter. 35 lines added, 8 removed. It comes from `just fmt`. [The file](https://github.com/rahuldave/babykev/blob/84b3ac0ce858d907d8d59ffdc9c9096ab8cb2ac4/src/babykev/api.py).
  - look at `        if not 1 <= len(self.criteria) <= MAX_OPTIONS:`

<a id="tut-07.5-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

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

<a id="tut-08"></a>

## 8 Lint

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-07`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-07)

```bash
just setup
```

`just setup` prints `Resolved 15 packages`.

The formatter changes how the code looks, and leaves a wrong line wrong. A linter reads the code against rules,
and reports what breaks them, from an import that nobody uses to a `zip` that drops items silently. ruff is the
linter too, and the families of rules come first. The linter finds 8 problems in `api.py`, and each rule then gets
a fix of its own. ruff makes the last fix itself.

<a id="tut-08.1"></a>

### 8.1 The rules of the linter

ruff has more than 900 rules. The table `[tool.ruff.lint]` chooses which to check, with `select`. Each family of
rules has a prefix, such as `E` or `B`. The list has one family on each line, with a comment that says what it
finds.

[± See the change to `pyproject.toml`](#tut-08.1-pyproject.toml-5d07e7-diff)

At the end of `pyproject.toml`, the new table `[tool.ruff.lint]` starts at line 51. `select = [` on line 53 lists
nine families of rules, from `E` to `N`.

```bash
uv run ruff check --statistics
```

`ruff check` is the linter. `--statistics` prints one line for each code, with the number of problems. ruff finds 52
problems, and ends with exit code 1. 44 of them are `S101`, an `assert`. Python skips every `assert` when it runs with
`python -O`, so a check in the package must not rely on one. Each of the 44 is in the tests, where pytest checks
with `assert`. The other 8 are in `api.py`.

#### What changed

- <a id="tut-08.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: a family of rules on each line. 14 lines added. [The file](https://github.com/rahuldave/babykev/blob/1a067ec6d90256e2f0142390db307c537909c047/pyproject.toml).
  - look at `    "B",   # bugbear: code that is likely a bug, such as a zip that drops items silently`

<a id="tut-08.1-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the change to `pyproject.toml`](#tut-08.2-pyproject.toml-5d07e7-diff)

At the end of `pyproject.toml`, the new table `[tool.ruff.lint.per-file-ignores]` is on lines 65 to 67. It names
`S101` for `"tests/**"`.

```bash
uv run ruff check --statistics
```

ruff finds 8 problems, and ends with exit code 1. `N806`, `UP007` and `B905` come twice each, and `E501` and `I001`
once each. The last line says that `--fix` can fix one, and that 2 unsafe fixes are available.

#### What changed

- <a id="tut-08.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: the tests may use `assert`. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/a6325da466f16c6379613b62554e1e4cf2144e7e/pyproject.toml).
  - look at `"tests/**" = ["S101"]`

<a id="tut-08.2-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the change to `justfile`](#tut-08.3-justfile-424f0b-diff)

In `justfile`, the recipe `lint` is on lines 34 to 38, between `fmt` and `test`. It runs `uv run ruff check "$@"`.

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

#### What changed

- <a id="tut-08.3-justfile-424f0b"></a>`justfile`: the recipe `lint`. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/58d6ece95cf464e01996ad8dbed1d98e92bcc502/justfile).
  - look at `lint *args:`

<a id="tut-08.3-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/58d6ece95cf464e01996ad8dbed1d98e92bcc502). [The code after it](https://github.com/rahuldave/babykev/tree/58d6ece95cf464e01996ad8dbed1d98e92bcc502).

<a id="tut-08.4"></a>

### 8.4 The docstring of api.py fits in 100 characters

`E501`: line 5 of `api.py` has 103 characters. The docstring is a small table, with the three types of question in
lines 3 to 5, and `answer =` lined up in one column. Line 5 is the longest, and sets the column. "The levels, in
order" takes the place of "ordered level descriptions", and says the same in fewer characters. The three lines
line up again, at column 43.

[± See the change to `src/babykev/api.py`](#tut-08.4-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, lines 3 to 5 now have `answer =` at column 43. Line 5 has 97 characters.

```bash
just lint --statistics
just fmt --check
```

`just lint --statistics` prints 7 problems, and no `E501`. `just fmt --check` prints `6 files already formatted`.
The formatter leaves the text of a docstring as it is.

#### What changed

- <a id="tut-08.4-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the table of the docstring, in 97 characters. 3 lines added, 3 removed. [The file](https://github.com/rahuldave/babykev/blob/4a25204449af75e24305189a1395c418ec0295d3/src/babykev/api.py).
  - look at `Score  -> options = the levels, in order; answer = expected level, legend, probabilities by index`

<a id="tut-08.4-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -1,8 +1,8 @@
 """The contract: request and answer shapes, mapped onto the single pointer primitive.
 
-Noul   -> 2 options [false, true];            answer = p(true)
-Choice -> options 'name' or 'name: desc';      answer = argmax, probabilities by name, confidence
-Score  -> options = ordered level descriptions; answer = expected level, legend, probabilities by index
+Noul   -> 2 options [false, true];        answer = p(true)
+Choice -> options 'name' or 'name: desc'; answer = argmax, probabilities by name, confidence
+Score  -> options = the levels, in order; answer = expected level, legend, probabilities by index
 """
 
 from typing import Any, Literal, Union
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4a25204449af75e24305189a1395c418ec0295d3). [The code after it](https://github.com/rahuldave/babykev/tree/4a25204449af75e24305189a1395c418ec0295d3).

<a id="tut-08.5"></a>

### 8.5 X | Y in place of Union

`UP007`: since Python 3.10, `str | None` is a union of two types, and `Union[str, None]` is the old way to write it.
babykev needs Python 3.13. `JSONContent` on line 11 and `Question` on line 39 become `X | Y`. ruff has no fix for
these two lines, so a person writes them.

[± See the change to `src/babykev/api.py`](#tut-08.5-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, line 11 is now `JSONContent = str | dict | list | int | float | bool | None`, and line 39
is `Question = Noul | Choice | Score`.

`Union` is no longer used, and its import on line 8 is now a problem of its own.

```bash
just lint --statistics
just test
```

`just lint --statistics` prints 6 problems. `UP007` is gone, and `F401`, `unused-import`, is new, with a `[*]`.
ruff can remove the import itself, and the last part of this section lets it. `just test` prints `53 passed`.
pydantic reads `X | Y` as it read `Union`.

#### What changed

- <a id="tut-08.5-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: two unions, written with `|`. 2 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/01c4956b31ad768bd11dc5da0c13128a7a3ab0fc/src/babykev/api.py).
  - look at `JSONContent = str | dict | list | int | float | bool | None`

<a id="tut-08.5-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -8,7 +8,7 @@ Score  -> options = the levels, in order; answer = expected level, legend, proba
 from typing import Any, Literal, Union
 from pydantic import BaseModel, Field, model_validator
 
-JSONContent = Union[str, dict, list, int, float, bool, None]
+JSONContent = str | dict | list | int | float | bool | None
 MAX_OPTIONS = 255
 
 
@@ -36,7 +36,7 @@ class Score(BaseModel):
     criteria: list[JSONContent] = Field(min_length=2, max_length=MAX_OPTIONS)
 
 
-Question = Union[Noul, Choice, Score]
+Question = Noul | Choice | Score
 
 
 class SystemOneRequest(BaseModel):
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/01c4956b31ad768bd11dc5da0c13128a7a3ab0fc). [The code after it](https://github.com/rahuldave/babykev/tree/01c4956b31ad768bd11dc5da0c13128a7a3ab0fc).

<a id="tut-08.6"></a>

### 8.6 K and n, in lower case

`N806`: a variable inside a function is in lower case, and a capital marks a constant, such as `MAX_OPTIONS`. `K` in
`choice_confidence` is the number of options, and becomes `k`. `L` in `score_confidence` is the number of levels.
`l` would break another rule, `E741`, because `l` looks like `1` and `I` in many fonts. So `L` becomes `n`.

[± See the change to `src/babykev/api.py`](#tut-08.6-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, `k = len(p)` is on line 94, and `n = len(p)` on line 104. Each use of the two names
changes with them.

```bash
just lint --statistics
just test -k confidence
```

`just lint --statistics` prints 4 problems, and no `N806`. `just test -k confidence` runs the 9 tests of the two
functions, and prints `9 passed, 44 deselected`. A new name changes nothing that runs.

#### What changed

- <a id="tut-08.6-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: two names, in lower case. 6 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/37fed4d2a9bff48f0a928851c8eb640736c7e313/src/babykev/api.py).
  - look at `    n = len(p)`

<a id="tut-08.6-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -91,8 +91,8 @@ def to_record(req: SystemOneRequest):
 
 
 def choice_confidence(p: list[float]) -> float:
-    K = len(p)
-    return 1.0 if K == 1 else (max(p) - 1 / K) / (1 - 1 / K)
+    k = len(p)
+    return 1.0 if k == 1 else (max(p) - 1 / k) / (1 - 1 / k)
 
 
 def score_confidence(p: list[float]) -> float:
@@ -101,12 +101,12 @@ def score_confidence(p: list[float]) -> float:
     `spread` is the expected distance from the most likely level. `guess` is the spread of a guess,
     equal probability on every level, around the middle. Anything as spread out as a guess gets 0.
     """
-    L = len(p)
-    if L == 1:
+    n = len(p)
+    if n == 1:
         return 1.0
-    mode = max(range(L), key=lambda i: p[i])
+    mode = max(range(n), key=lambda i: p[i])
     spread = sum(pi * abs(i - mode) for i, pi in enumerate(p))
-    guess = sum(abs(i - (L - 1) / 2) for i in range(L)) / L
+    guess = sum(abs(i - (n - 1) / 2) for i in range(n)) / n
     return max(0.0, 1.0 - spread / guess)
 
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/37fed4d2a9bff48f0a928851c8eb640736c7e313). [The code after it](https://github.com/rahuldave/babykev/tree/37fed4d2a9bff48f0a928851c8eb640736c7e313).

<a id="tut-08.7"></a>

### 8.7 Zip with strict=True

`B905`: `zip` pairs the items of two lists, and stops at the end of the shorter one. The rest is dropped, and
nothing says so. `to_answers` pairs the probabilities with the questions on line 121, and the keys of a choice with
its probabilities on line 125. Each pair of lists must have the same length. A difference is a bug, and it should
stop the program.

ruff's own fix writes `strict=False`, which keeps the silent drop and says so. ruff calls it unsafe, and leaves the
choice to a person. `strict=True` makes `zip` raise a `ValueError` when the lengths differ.

[± See the change to `src/babykev/api.py`](#tut-08.7-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, line 121 is now `for p, m in zip(probs, meta, strict=True):`, and line 125 ends with
`zip(m["keys"], p, strict=True)}`.

```bash
just lint --statistics
just test -k answer
```

`just lint --statistics` prints 2 problems, `I001` and `F401`, each with a `[*]`. `just test -k answer` runs the 4
tests of the answers, which call `to_answers`, and prints `4 passed, 49 deselected`. Their lists have the same
lengths, so nothing raises.

#### What changed

- <a id="tut-08.7-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: two calls of `zip`, with `strict=True`. 2 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/ca9cfc3b70b7a0c926c9407336c217e3f04c73aa/src/babykev/api.py).
  - look at `    for p, m in zip(probs, meta, strict=True):`

<a id="tut-08.7-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -118,11 +118,11 @@ def round_prob(x: float) -> float:
 
 def to_answers(probs: list[list[float]], meta: list[dict]) -> dict[str, Any]:
     out = {}
-    for p, m in zip(probs, meta):
+    for p, m in zip(probs, meta, strict=True):
         if m["type"] == "noul":
             out[m["id"]] = {"type": "noul", "noul": round_prob(p[1])}
         elif m["type"] == "choice":
-            dist = {k: round_prob(v) for k, v in zip(m["keys"], p)}
+            dist = {k: round_prob(v) for k, v in zip(m["keys"], p, strict=True)}
             out[m["id"]] = {
                 "type": "choice",
                 "choice": m["keys"][max(range(len(p)), key=lambda i: p[i])],
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ca9cfc3b70b7a0c926c9407336c217e3f04c73aa). [The code after it](https://github.com/rahuldave/babykev/tree/ca9cfc3b70b7a0c926c9407336c217e3f04c73aa).

<a id="tut-08.8"></a>

### 8.8 Just lint --fix sorts the imports

The last two problems are on lines 8 and 9 of `api.py`, in the imports, and ruff can fix both safely. `--fix` makes
only the fixes that ruff counts as safe.

This change came from running `just lint --fix`.

`just lint --fix` prints `Found 2 errors (2 fixed, 0 remaining).`, and ends with exit code 0. It removed `Union`
from the import of `typing` (`F401`). It put a blank line between the standard library and pydantic, which is
installed (`I001`).

At the top of `src/babykev/api.py`, line 8 is now `from typing import Any, Literal`, and a blank line comes before
`from pydantic import BaseModel, Field, model_validator`, on line 10.

```bash
just lint
just fmt --check
just test
```

`just lint` prints `All checks passed!`. `just fmt --check` prints `6 files already formatted`, and `just test`
prints `53 passed`.

#### What changed

- <a id="tut-08.8-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the imports, sorted. 2 lines added, 1 removed. It comes from `just lint --fix`. [The file](https://github.com/rahuldave/babykev/blob/7cdb1ba696a32050cba1c335892fccb68bb4fd24/src/babykev/api.py).
  - look at `from typing import Any, Literal`

<a id="tut-08.8-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

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

<a id="tut-09"></a>

## 9 Types in every signature

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-08`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-08)

```bash
just setup
```

`just setup` prints `Resolved 15 packages`.

A reader of `def to_record(req: SystemOneRequest):` knows what the function takes, and not what it returns. A type
annotation says it, in the signature. Python does not check annotations when it runs, but a reader does, and a type
checker can, later. The family `ANN` of ruff asks for the type of every parameter and of every return value. A
person writes each type that ruff cannot guess, and ruff writes the rest.

<a id="tut-09.1"></a>

### 9.1 The rule that every function has types

Nothing asks for types yet. The family `ANN` joins the list `select`, on a line of its own, with its comment.

[± See the change to `pyproject.toml`](#tut-09.1-pyproject.toml-5d07e7-diff)

In `pyproject.toml`, the line `"ANN", # annotations: every parameter and every return value has a type` is now line
63, the last of the list `select`.

```bash
just lint --statistics
```

`just lint --statistics` prints 49 problems in four codes, and ends with exit code 1.

- `ANN201`, 33 times: a public function with no return type.
- `ANN001`, 14 times: a parameter with no type.
- `ANN202`, once: a private function with no return type. Its name starts with `_`.
- `ANN002`, once: `*args` with no type.

The last line says `31 unsafe fixes available with --fix --unsafe-fixes`. ruff can write 31 of the return types
itself, and the other 18 problems need a person. The person goes first, so that ruff's fix comes last and leaves
nothing.

#### What changed

- <a id="tut-09.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the family `ANN`. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/902428993991b5ffbb8ce7630556d7524f04f4ce/pyproject.toml).
  - look at `    "ANN", # annotations: every parameter and every return value has a type`

<a id="tut-09.1-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -60,6 +60,7 @@ select = [
     "SIM", # simplify: code that can be said in fewer words
     "S",   # bandit: security, from `assert` in the package to `eval`
     "N",   # pep8-naming: classes in CamelCase, functions and variables in lower_case
+    "ANN", # annotations: every parameter and every return value has a type
 ]
 
 [tool.ruff.lint.per-file-ignores]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/902428993991b5ffbb8ce7630556d7524f04f4ce). [The code after it](https://github.com/rahuldave/babykev/tree/902428993991b5ffbb8ce7630556d7524f04f4ce).

<a id="tut-09.2"></a>

### 9.2 _check returns Self

`ANN202`: `_check` is the validator of `Choice`, and returns the choice itself, `self`. `Self`, from `typing`, is
the type of the class that the method belongs to.

[± See the change to `src/babykev/api.py`](#tut-09.2-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, line 8 imports `Self` from `typing`, and line 28 is now `def _check(self) -> Self:`.

```bash
just lint --statistics
just test -k choice
```

`just lint --statistics` prints 48 problems, and no `ANN202`. `just test -k choice` runs the 7 tests with `choice` in
their name, and prints `7 passed, 46 deselected`. Two of them check the limits that `_check` sets on the options.

#### What changed

- <a id="tut-09.2-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the return type of `_check`. 2 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/620ea02cd62d1dafd9014783e29d8fe85216175c/src/babykev/api.py).
  - look at `    def _check(self) -> Self:`

<a id="tut-09.2-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -5,7 +5,7 @@ Choice -> options 'name' or 'name: desc'; answer = argmax, probabilities by name
 Score  -> options = the levels, in order; answer = expected level, legend, probabilities by index
 """
 
-from typing import Any, Literal
+from typing import Any, Literal, Self
 
 from pydantic import BaseModel, Field, model_validator
 
@@ -25,7 +25,7 @@ class Choice(BaseModel):
     criteria: dict[str, JSONContent]
 
     @model_validator(mode="after")
-    def _check(self):
+    def _check(self) -> Self:
         if not 1 <= len(self.criteria) <= MAX_OPTIONS:
             raise ValueError(f"criteria must have 1..{MAX_OPTIONS} options")
         return self
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/620ea02cd62d1dafd9014783e29d8fe85216175c). [The code after it](https://github.com/rahuldave/babykev/tree/620ea02cd62d1dafd9014783e29d8fe85216175c).

<a id="tut-09.3"></a>

### 9.3 The two return types that ruff cannot guess

`ANN201`: of the 33 public functions with no return type, ruff can guess 31. Each of them returns nothing, and its
type is `None`. The other two return something, and a person names the type. `to_record` in `api.py` returns two
things, the record and the metadata of its questions. The record is a dictionary, and the metadata is a list of
dictionaries. `cheese_request` in the tests returns a `SystemOneRequest`.

[± See the change to `src/babykev/api.py`](#tut-09.3-src-babykev-api.py-2ea65f-diff)

[± See the change to `tests/unit/test_api.py`](#tut-09.3-tests-unit-test_api.py-58d97c-diff)

In `src/babykev/api.py`, line 69 now ends with `-> tuple[dict[str, Any], list[dict[str, Any]]]:`. In
`tests/unit/test_api.py`, line 30 is now `def cheese_request() -> SystemOneRequest:`.

```bash
just lint --statistics
```

`just lint --statistics` prints 46 problems. 31 are `ANN201`, and ruff can fix each of them.

#### What changed

- <a id="tut-09.3-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the return type of `to_record`. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/36b5e61136c9bad356ca74b2d790edf10076fdcb/src/babykev/api.py).
  - look at `def to_record(req: SystemOneRequest) -> tuple[dict[str, Any], list[dict[str, Any]]]:`
- <a id="tut-09.3-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the return type of `cheese_request`. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/36b5e61136c9bad356ca74b2d790edf10076fdcb/tests/unit/test_api.py).
  - look at `def cheese_request() -> SystemOneRequest:`

<a id="tut-09.3-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -66,7 +66,7 @@ def option_text(name: str, desc: JSONContent) -> str:
     return name if desc is None or desc == "" else f"{name}: {render(desc)}"
 
 
-def to_record(req: SystemOneRequest):
+def to_record(req: SystemOneRequest) -> tuple[dict[str, Any], list[dict[str, Any]]]:
     """-> internal record for encode(), plus per-question metadata to map probabilities back."""
     qs, meta = [], []
     for qid, q in req.questions.items():
```

</details>

<a id="tut-09.3-tests-unit-test_api.py-58d97c-diff"></a>

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -27,7 +27,7 @@ MILKS = {"cow": None, "goat": None, "sheep": None, "mixed": "More than one kind
 FIRMNESS = ["Soft", "Semi-soft", "Semi-hard", "Hard"]
 
 
-def cheese_request():
+def cheese_request() -> SystemOneRequest:
     """One request that asks a question of each type."""
     return SystemOneRequest.model_validate(
         {
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/36b5e61136c9bad356ca74b2d790edf10076fdcb). [The code after it](https://github.com/rahuldave/babykev/tree/36b5e61136c9bad356ca74b2d790edf10076fdcb).

<a id="tut-09.4"></a>

### 9.4 The types of the fixtures of pytest

`ANN001`: 14 parameters have no type. Five of them are the fixtures of pytest in `test_cli.py`, which pytest passes
in by their names. `monkeypatch` is a `pytest.MonkeyPatch`, and `capsys` is a `pytest.CaptureFixture[str]`, which
catches text. With the types, the two signatures of the tests pass 100 characters, so each is split over three
lines, as the formatter splits it.

[± See the change to `tests/unit/test_cli.py`](#tut-09.4-tests-unit-test_cli.py-44d4a0-diff)

In `tests/unit/test_cli.py`, line 8 is now `def run(monkeypatch: pytest.MonkeyPatch, *words):`. The parameters of the two
tests are on lines 16 and 24, each between the line of the name and the line `):`.

The fixtures are what the tests of the command are made of, so we read them again with their types.

```bash
sed -n '8,30p' tests/unit/test_cli.py
just test -k unknown_command
```

`sed` prints `run` and the two tests. `run` uses `monkeypatch.setattr` to put the words in `sys.argv`, and calls
`main`. Each test reads what `main` printed through `capsys.readouterr()`, `.out` for the help and `.err` for the
message of an unknown command. `just test -k unknown_command` prints `1 passed, 52 deselected`. The test of an unknown
command passes with the types, as it did without them.

#### What changed

- <a id="tut-09.4-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: the types of the fixtures. 7 lines added, 3 removed. [The file](https://github.com/rahuldave/babykev/blob/ea931bef025598ffea0652a14e5051bffb491ef9/tests/unit/test_cli.py).
  - look at `    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]`

<a id="tut-09.4-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -5,20 +5,24 @@ import pytest
 from babykev.cli import HELP, main
 
 
-def run(monkeypatch, *words):
+def run(monkeypatch: pytest.MonkeyPatch, *words):
     """Run `babykev` with these words as its command line."""
     monkeypatch.setattr("sys.argv", ["babykev", *words])
     main()
 
 
 @pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])
-def test_help_is_printed_for_help_and_for_no_words(monkeypatch, capsys, words):
+def test_help_is_printed_for_help_and_for_no_words(
+    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], words
+):
     """`babykev`, `babykev help`, `--help` and `-h` all print the help text, and nothing else."""
     run(monkeypatch, *words)
     assert capsys.readouterr().out == HELP
 
 
-def test_an_unknown_command_is_refused_with_exit_code_2(monkeypatch, capsys):
+def test_an_unknown_command_is_refused_with_exit_code_2(
+    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+):
     """A word that is not a command is named, the help is pointed to, and the exit code is 2."""
     with pytest.raises(SystemExit) as exit_info:
         run(monkeypatch, "train")
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ea931bef025598ffea0652a14e5051bffb491ef9). [The code after it](https://github.com/rahuldave/babykev/tree/ea931bef025598ffea0652a14e5051bffb491ef9).

<a id="tut-09.5"></a>

### 9.5 The types of the parameters of the tests

The other nine parameters with no type get their values from `@pytest.mark.parametrize`. Each gets the type of the
values in its list.

- `words` in `test_cli.py` is a tuple of strings, `tuple[str, ...]`.
- `line` in `test_api.py` is a line of the sample data, a `dict[str, Any]`, so the file imports `Any` from `typing`.
- `value` and `description` are what `render` and `option_text` take, a `JSONContent`, so the file imports it from
  `babykev.api`.
- `text` and `name` are strings, and `level` is an `int`.

[± See the change to `tests/unit/test_api.py`](#tut-09.5-tests-unit-test_api.py-58d97c-diff)

[± See the change to `tests/unit/test_cli.py`](#tut-09.5-tests-unit-test_cli.py-44d4a0-diff)

In `tests/unit/test_api.py`, `from typing import Any` is on line 5, and `JSONContent` on line 13. The five tests with
parameters now give their types, for example `def test_score_confidence_is_one_when_certain(level: int):` on line
283. The signature of `test_option_text_adds_a_description_only_when_there_is_one` is split over lines 156 to 158.
In `tests/unit/test_cli.py`, line 16 ends with `words: tuple[str, ...]`.

```bash
just lint --statistics
just test
```

`just lint --statistics` prints 32 problems, 31 `ANN201` and one `ANN002`. `just test` prints `53 passed`.

#### What changed

- <a id="tut-09.5-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: the types of the parameters, and two imports. 9 lines added, 5 removed. [The file](https://github.com/rahuldave/babykev/blob/e7648b1239e17f96443a9477a85ed36d8b1e6cc6/tests/unit/test_api.py).
  - look at `def test_render_flattens_json_into_text(value: JSONContent, text: str):`
- <a id="tut-09.5-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: the type of `words`. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/e7648b1239e17f96443a9477a85ed36d8b1e6cc6/tests/unit/test_cli.py).
  - look at `    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], words: tuple[str, ...]`

<a id="tut-09.5-tests-unit-test_api.py-58d97c-diff"></a>

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -2,6 +2,7 @@
 
 import json
 from pathlib import Path
+from typing import Any
 
 import pytest
 from pydantic import ValidationError
@@ -9,6 +10,7 @@ from pydantic import ValidationError
 from babykev.api import (
     MAX_OPTIONS,
     Choice,
+    JSONContent,
     Noul,
     Score,
     SystemOneRequest,
@@ -45,7 +47,7 @@ def cheese_request() -> SystemOneRequest:
 
 
 @pytest.mark.parametrize("line", SAMPLE_LINES)
-def test_sample_line_fits_the_contract(line):
+def test_sample_line_fits_the_contract(line: dict[str, Any]):
     """Every line of the sample data is a valid request, with one record question per question."""
     request = SystemOneRequest.model_validate(line)
     record, meta = to_record(request)
@@ -55,7 +57,7 @@ def test_sample_line_fits_the_contract(line):
 
 
 @pytest.mark.parametrize("line", SAMPLE_LINES)
-def test_sample_line_has_a_usable_label_on_every_question(line):
+def test_sample_line_has_a_usable_label_on_every_question(line: dict[str, Any]):
     """A label is a boolean for noul, an option name for choice, and a level index for score."""
     for question in line["questions"].values():
         label = question["label"]
@@ -138,7 +140,7 @@ def test_score_with_one_level_is_rejected():
         ([{"role": "customer", "content": "hello"}], "- role: customer\n  content: hello"),
     ],
 )
-def test_render_flattens_json_into_text(value, text):
+def test_render_flattens_json_into_text(value: JSONContent, text: str):
     """Strings, numbers, lists and objects all become the text the model reads."""
     assert render(value) == text
 
@@ -151,7 +153,9 @@ def test_render_flattens_json_into_text(value, text):
         ("mixed", "More than one kind of milk", "mixed: More than one kind of milk"),
     ],
 )
-def test_option_text_adds_a_description_only_when_there_is_one(name, description, text):
+def test_option_text_adds_a_description_only_when_there_is_one(
+    name: str, description: JSONContent, text: str
+):
     """An option is its name, followed by its description when it has one."""
     assert option_text(name, description) == text
 
@@ -276,7 +280,7 @@ def test_choice_confidence_grows_with_the_winner():
 
 
 @pytest.mark.parametrize("level", [0, 1, 2])
-def test_score_confidence_is_one_when_certain(level):
+def test_score_confidence_is_one_when_certain(level: int):
     """All the probability on one level is certainty, wherever the level is."""
     p = [0.0, 0.0, 0.0]
     p[level] = 1.0
```

</details>

<a id="tut-09.5-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -13,7 +13,7 @@ def run(monkeypatch: pytest.MonkeyPatch, *words):
 
 @pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])
 def test_help_is_printed_for_help_and_for_no_words(
-    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], words
+    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], words: tuple[str, ...]
 ):
     """`babykev`, `babykev help`, `--help` and `-h` all print the help text, and nothing else."""
     run(monkeypatch, *words)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e7648b1239e17f96443a9477a85ed36d8b1e6cc6). [The code after it](https://github.com/rahuldave/babykev/tree/e7648b1239e17f96443a9477a85ed36d8b1e6cc6).

<a id="tut-09.6"></a>

### 9.6 The words of run are strings

`ANN002`: `*words` in `run` gathers any number of words into a tuple. Its annotation is the type of each word, `str`,
and not of the tuple.

[± See the change to `tests/unit/test_cli.py`](#tut-09.6-tests-unit-test_cli.py-44d4a0-diff)

In `tests/unit/test_cli.py`, line 8 is now `def run(monkeypatch: pytest.MonkeyPatch, *words: str):`.

```bash
just lint --statistics
just lint --statistics --unsafe-fixes
```

`just lint --statistics` prints 31 problems, all `ANN201`. With `--unsafe-fixes`, it marks each of them `[*]`, and
says `31 fixable with --fix`. Neither command changes a file.

#### What changed

- <a id="tut-09.6-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: the type of `*words`. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/e0ff9f81ef10ee224eefb9a706f2903aa540463a/tests/unit/test_cli.py).
  - look at `def run(monkeypatch: pytest.MonkeyPatch, *words: str):`

<a id="tut-09.6-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -5,7 +5,7 @@ import pytest
 from babykev.cli import HELP, main
 
 
-def run(monkeypatch: pytest.MonkeyPatch, *words):
+def run(monkeypatch: pytest.MonkeyPatch, *words: str):
     """Run `babykev` with these words as its command line."""
     monkeypatch.setattr("sys.argv", ["babykev", *words])
     main()
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e0ff9f81ef10ee224eefb9a706f2903aa540463a). [The code after it](https://github.com/rahuldave/babykev/tree/e0ff9f81ef10ee224eefb9a706f2903aa540463a).

<a id="tut-09.7"></a>

### 9.7 Just lint --fix --unsafe-fixes writes -> None

The last 31 problems are functions of the tests with no `return`, which return `None`. ruff can add `-> None` to
each of them. ruff marks this fix as unsafe, so `--fix` alone does not make it, and `--unsafe-fixes` lets it.

This change came from running `just lint --fix --unsafe-fixes`.

`just lint --fix --unsafe-fixes` prints `Found 31 errors (31 fixed, 0 remaining).`, and ends with exit code 0.

In `tests/unit/test_api.py`, 28 signatures now end with `-> None:`, for example
`def test_sample_line_fits_the_contract(line: dict[str, Any]) -> None:` on line 50. In `tests/unit/test_cli.py`,
`run` and the two tests end with `-> None:`, on lines 8, 17 and 25.

```bash
just lint
just fmt --check
just test
```

`just lint` prints `All checks passed!`. `just fmt --check` prints `6 files already formatted`. No line passed 100
characters with `-> None`. `just test` prints `53 passed`.

#### What changed

- <a id="tut-09.7-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: `-> None` on 28 functions. 28 lines added, 28 removed. It comes from `just lint --fix --unsafe-fixes`. [The file](https://github.com/rahuldave/babykev/blob/b0e8dd74539e4d3b210defc5e0169f53b1670393/tests/unit/test_api.py).
  - look at `def test_sample_line_fits_the_contract(line: dict[str, Any]) -> None:`
- <a id="tut-09.7-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: `-> None` on `run` and the two tests. 3 lines added, 3 removed. It comes from `just lint --fix --unsafe-fixes`. [The file](https://github.com/rahuldave/babykev/blob/b0e8dd74539e4d3b210defc5e0169f53b1670393/tests/unit/test_cli.py).
  - look at `def run(monkeypatch: pytest.MonkeyPatch, *words: str) -> None:`

<a id="tut-09.7-tests-unit-test_api.py-58d97c-diff"></a>

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -47,7 +47,7 @@ def cheese_request() -> SystemOneRequest:
 
 
 @pytest.mark.parametrize("line", SAMPLE_LINES)
-def test_sample_line_fits_the_contract(line: dict[str, Any]):
+def test_sample_line_fits_the_contract(line: dict[str, Any]) -> None:
     """Every line of the sample data is a valid request, with one record question per question."""
     request = SystemOneRequest.model_validate(line)
     record, meta = to_record(request)
@@ -57,7 +57,7 @@ def test_sample_line_fits_the_contract(line: dict[str, Any]):
 
 
 @pytest.mark.parametrize("line", SAMPLE_LINES)
-def test_sample_line_has_a_usable_label_on_every_question(line: dict[str, Any]):
+def test_sample_line_has_a_usable_label_on_every_question(line: dict[str, Any]) -> None:
     """A label is a boolean for noul, an option name for choice, and a level index for score."""
     for question in line["questions"].values():
         label = question["label"]
@@ -72,7 +72,7 @@ def test_sample_line_has_a_usable_label_on_every_question(line: dict[str, Any]):
 # Validation
 
 
-def test_request_holds_one_model_per_question_type():
+def test_request_holds_one_model_per_question_type() -> None:
     """The `type` field decides which model a question becomes."""
     questions = cheese_request().questions
     assert isinstance(questions["blue"], Noul)
@@ -80,31 +80,31 @@ def test_request_holds_one_model_per_question_type():
     assert isinstance(questions["firmness"], Score)
 
 
-def test_request_without_questions_is_rejected():
+def test_request_without_questions_is_rejected() -> None:
     """A request must ask at least one question."""
     with pytest.raises(ValidationError):
         SystemOneRequest.model_validate({"state": "Brie", "questions": {}})
 
 
-def test_unknown_question_type_is_rejected():
+def test_unknown_question_type_is_rejected() -> None:
     """Only noul, choice and score exist."""
     question = {"type": "essay", "instructions": "Describe this cheese."}
     with pytest.raises(ValidationError):
         SystemOneRequest.model_validate({"state": "Brie", "questions": {"q": question}})
 
 
-def test_noul_needs_no_criteria():
+def test_noul_needs_no_criteria() -> None:
     """A yes-or-no question may leave out what yes and no mean."""
     assert Noul(type="noul", instructions="Is it blue?").criteria is None
 
 
-def test_choice_without_options_is_rejected():
+def test_choice_without_options_is_rejected() -> None:
     """A choice needs at least one option."""
     with pytest.raises(ValidationError):
         Choice(type="choice", instructions="Which milk?", criteria={})
 
 
-def test_choice_accepts_the_largest_number_of_options_and_no_more():
+def test_choice_accepts_the_largest_number_of_options_and_no_more() -> None:
     """The limit on options is exact."""
     at_limit = {f"option{i}": None for i in range(MAX_OPTIONS)}
     assert (
@@ -114,7 +114,7 @@ def test_choice_accepts_the_largest_number_of_options_and_no_more():
         Choice(type="choice", instructions="Which?", criteria={**at_limit, "one_more": None})
 
 
-def test_score_with_one_level_is_rejected():
+def test_score_with_one_level_is_rejected() -> None:
     """A scale needs at least two levels."""
     with pytest.raises(ValidationError):
         Score(type="score", instructions="How firm?", criteria=["Soft"])
@@ -140,7 +140,7 @@ def test_score_with_one_level_is_rejected():
         ([{"role": "customer", "content": "hello"}], "- role: customer\n  content: hello"),
     ],
 )
-def test_render_flattens_json_into_text(value: JSONContent, text: str):
+def test_render_flattens_json_into_text(value: JSONContent, text: str) -> None:
     """Strings, numbers, lists and objects all become the text the model reads."""
     assert render(value) == text
 
@@ -155,7 +155,7 @@ def test_render_flattens_json_into_text(value: JSONContent, text: str):
 )
 def test_option_text_adds_a_description_only_when_there_is_one(
     name: str, description: JSONContent, text: str
-):
+) -> None:
     """An option is its name, followed by its description when it has one."""
     assert option_text(name, description) == text
 
@@ -163,7 +163,7 @@ def test_option_text_adds_a_description_only_when_there_is_one(
 # From a request to a record
 
 
-def test_record_keeps_the_state_and_the_order_of_questions():
+def test_record_keeps_the_state_and_the_order_of_questions() -> None:
     """The state is rendered once and the questions stay in request order."""
     record, meta = to_record(cheese_request())
     assert record["state"] == "cheese: Roquefort\norigin: France"
@@ -175,14 +175,14 @@ def test_record_keeps_the_state_and_the_order_of_questions():
     ]
 
 
-def test_noul_becomes_no_then_yes():
+def test_noul_becomes_no_then_yes() -> None:
     """Option 0 is no and option 1 is yes, so the answer is the probability of option 1."""
     record, meta = to_record(cheese_request())
     assert record["questions"][0]["options"] == ["no", "yes"]
     assert meta[0] == {"id": "blue", "type": "noul"}
 
 
-def test_noul_criteria_describe_no_and_yes():
+def test_noul_criteria_describe_no_and_yes() -> None:
     """The criteria under `false` and `true` become the descriptions of no and yes."""
     criteria = {"true": "It has blue veins", "false": "It has none"}
     question = {"type": "noul", "instructions": "Is it blue?", "criteria": criteria}
@@ -191,7 +191,7 @@ def test_noul_criteria_describe_no_and_yes():
     assert record["questions"][0]["options"] == ["no: It has none", "yes: It has blue veins"]
 
 
-def test_choice_becomes_one_option_per_criterion_in_order():
+def test_choice_becomes_one_option_per_criterion_in_order() -> None:
     """Options keep the order of the criteria, and the metadata remembers their names."""
     record, meta = to_record(cheese_request())
     assert record["questions"][1]["options"] == [
@@ -203,7 +203,7 @@ def test_choice_becomes_one_option_per_criterion_in_order():
     assert meta[1] == {"id": "milk", "type": "choice", "keys": ["cow", "goat", "sheep", "mixed"]}
 
 
-def test_score_becomes_one_option_per_level_with_a_legend():
+def test_score_becomes_one_option_per_level_with_a_legend() -> None:
     """Options are the levels in order, and the legend maps each index to its level."""
     record, meta = to_record(cheese_request())
     assert record["questions"][2]["options"] == FIRMNESS
@@ -213,13 +213,13 @@ def test_score_becomes_one_option_per_level_with_a_legend():
 # From probabilities to answers
 
 
-def test_noul_answer_is_the_probability_of_yes():
+def test_noul_answer_is_the_probability_of_yes() -> None:
     """The answer to a yes-or-no question is one number."""
     answers = to_answers([[0.25, 0.75]], [{"id": "blue", "type": "noul"}])
     assert answers == {"blue": {"type": "noul", "noul": 0.75}}
 
 
-def test_choice_answer_names_the_most_likely_option():
+def test_choice_answer_names_the_most_likely_option() -> None:
     """A choice answer has the winner, a probability for each option, and a confidence."""
     meta = [{"id": "milk", "type": "choice", "keys": ["cow", "goat", "sheep"]}]
     answer = to_answers([[0.1, 0.7, 0.2]], meta)["milk"]
@@ -228,7 +228,7 @@ def test_choice_answer_names_the_most_likely_option():
     assert answer["confidence"] == pytest.approx(0.55)
 
 
-def test_score_answer_is_the_expected_level():
+def test_score_answer_is_the_expected_level() -> None:
     """A score answer is the mean level under the probabilities, with the legend to read it by."""
     legend = {"0": "Soft", "1": "Semi-soft", "2": "Hard"}
     answer = to_answers([[0.1, 0.2, 0.7]], [{"id": "firmness", "type": "score", "legend": legend}])[
@@ -239,7 +239,7 @@ def test_score_answer_is_the_expected_level():
     assert answer["probabilities"] == {"0": 0.1, "1": 0.2, "2": 0.7}
 
 
-def test_every_question_gets_an_answer_of_its_own_type():
+def test_every_question_gets_an_answer_of_its_own_type() -> None:
     """Records and answers line up: one answer per question, under the question's id."""
     record, meta = to_record(cheese_request())
     uniform = [[1 / len(q["options"])] * len(q["options"]) for q in record["questions"]]
@@ -251,7 +251,7 @@ def test_every_question_gets_an_answer_of_its_own_type():
     }
 
 
-def test_rounded_probabilities_still_sum_to_one():
+def test_rounded_probabilities_still_sum_to_one() -> None:
     """Rounding for output must not lose probability, even with many options."""
     keys = [f"intent{i}" for i in range(77)]
     answer = to_answers([[1 / 77] * 77], [{"id": "intent", "type": "choice", "keys": keys}])[
@@ -263,40 +263,40 @@ def test_rounded_probabilities_still_sum_to_one():
 # Confidence
 
 
-def test_choice_confidence_is_zero_for_a_guess():
+def test_choice_confidence_is_zero_for_a_guess() -> None:
     """Equal probabilities are a guess, whatever the number of options."""
     assert choice_confidence([0.25] * 4) == pytest.approx(0)
 
 
-def test_choice_confidence_is_one_when_certain():
+def test_choice_confidence_is_one_when_certain() -> None:
     """All the probability on one option is certainty."""
     assert choice_confidence([0, 1, 0]) == pytest.approx(1)
     assert choice_confidence([1.0]) == 1.0
 
 
-def test_choice_confidence_grows_with_the_winner():
+def test_choice_confidence_grows_with_the_winner() -> None:
     """Between a guess and certainty, confidence follows the winning probability."""
     assert choice_confidence([0.5, 0.25, 0.25]) == pytest.approx(0.25)
 
 
 @pytest.mark.parametrize("level", [0, 1, 2])
-def test_score_confidence_is_one_when_certain(level: int):
+def test_score_confidence_is_one_when_certain(level: int) -> None:
     """All the probability on one level is certainty, wherever the level is."""
     p = [0.0, 0.0, 0.0]
     p[level] = 1.0
     assert score_confidence(p) == pytest.approx(1)
 
 
-def test_score_confidence_prefers_neighbouring_levels():
+def test_score_confidence_prefers_neighbouring_levels() -> None:
     """Doubt between adjacent levels is more confident than doubt between the two ends."""
     assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])
 
 
-def test_score_confidence_is_zero_for_a_guess():
+def test_score_confidence_is_zero_for_a_guess() -> None:
     """Equal probabilities over the levels are a guess, as they are for a choice."""
     assert score_confidence([1 / 3] * 3) == pytest.approx(0)
 
 
-def test_score_confidence_is_one_for_a_single_level():
+def test_score_confidence_is_one_for_a_single_level() -> None:
     """One level leaves nothing to doubt. A request cannot have one, but the function answers it."""
     assert score_confidence([1.0]) == 1.0
```

</details>

<a id="tut-09.7-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -5,7 +5,7 @@ import pytest
 from babykev.cli import HELP, main
 
 
-def run(monkeypatch: pytest.MonkeyPatch, *words: str):
+def run(monkeypatch: pytest.MonkeyPatch, *words: str) -> None:
     """Run `babykev` with these words as its command line."""
     monkeypatch.setattr("sys.argv", ["babykev", *words])
     main()
@@ -14,7 +14,7 @@ def run(monkeypatch: pytest.MonkeyPatch, *words: str):
 @pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])
 def test_help_is_printed_for_help_and_for_no_words(
     monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], words: tuple[str, ...]
-):
+) -> None:
     """`babykev`, `babykev help`, `--help` and `-h` all print the help text, and nothing else."""
     run(monkeypatch, *words)
     assert capsys.readouterr().out == HELP
@@ -22,7 +22,7 @@ def test_help_is_printed_for_help_and_for_no_words(
 
 def test_an_unknown_command_is_refused_with_exit_code_2(
     monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
-):
+) -> None:
     """A word that is not a command is named, the help is pointed to, and the exit code is 2."""
     with pytest.raises(SystemExit) as exit_info:
         run(monkeypatch, "train")
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b0e8dd74539e4d3b210defc5e0169f53b1670393).

This part ends at the code at `tut-09`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-09)

<a id="tut-10"></a>

## 10 Docstrings

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-09`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-09)

```bash
just setup
```

`just setup` prints `Resolved 15 packages`.

A docstring says what a module, a class or a function is for. Python keeps it in `__doc__`, and `help()` and the
editor show it. kev gave a docstring to some functions of `api.py`, and to none of its classes. The rules `D1` of
ruff ask for a docstring on every public module, class and function. ruff cannot write one, so each comes by hand,
one kind at a time.

<a id="tut-10.1"></a>

### 10.1 The rule that every public name has a docstring

Nothing asks for docstrings yet. The rules `D1` of the family `D`, pydocstyle, join the list `select`. `D1` is the
part of the family that asks whether a docstring is there. The rest of the family checks how a docstring is written,
and stays off.

[± See the change to `pyproject.toml`](#tut-10.1-pyproject.toml-5d07e7-diff)

In `pyproject.toml`, the line of `"D1"` is now line 64, the last of the list `select`.

```bash
just lint --output-format concise
```

`--output-format concise` prints each problem on one line, with its file, line and column. `just lint` finds 8
problems, and ends with exit code 1. `D104` is the package, `src/babykev/__init__.py`, which is empty. `D101` is
four classes of `api.py`, on lines 16, 22, 34 and 43. `D103` is three functions, on lines 65, 94 and 120. `_check`
is private, so it needs none.

#### What changed

- <a id="tut-10.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the rules `D1`. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/09ad56d2e465ac5b485ba5d1b077c540fd7c45ef/pyproject.toml).
  - look at `    "D1",  # pydocstyle: every public module, class and function has a docstring`

<a id="tut-10.1-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -61,6 +61,7 @@ select = [
     "S",   # bandit: security, from `assert` in the package to `eval`
     "N",   # pep8-naming: classes in CamelCase, functions and variables in lower_case
     "ANN", # annotations: every parameter and every return value has a type
+    "D1",  # pydocstyle: every public module, class and function has a docstring
 ]
 
 [tool.ruff.lint.per-file-ignores]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/09ad56d2e465ac5b485ba5d1b077c540fd7c45ef). [The code after it](https://github.com/rahuldave/babykev/tree/09ad56d2e465ac5b485ba5d1b077c540fd7c45ef).

<a id="tut-10.2"></a>

### 10.2 The docstring of the package

`D104`: `src/babykev/__init__.py` is the package `babykev` itself, and it is empty. Its docstring says what babykev
is, as the first line of the help of the command does.

[± See the change to `src/babykev/__init__.py`](#tut-10.2-src-babykev-__init__.py-a40393-diff)

`src/babykev/__init__.py` now has one line, the docstring of the package.

```bash
uv run python -c "import babykev; print(babykev.__doc__)"
just test
```

`uv run python -c` prints the docstring, `babykev: a small decision model. A state, typed questions, and a probability
for every answer.` `just test` prints `53 passed`. `__init__.py` still has 0 statements, because coverage does not
count a docstring.

#### What changed

- <a id="tut-10.2-src-babykev-__init__.py-a40393"></a>`src/babykev/__init__.py`: the docstring of the package. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/7943e585faa81e4c0400f5e2e9ca7b42ce4bf286/src/babykev/__init__.py).
  - look at `"""babykev: a small decision model. A state, typed questions, and a probability for every answer."""`

<a id="tut-10.2-src-babykev-__init__.py-a40393-diff"></a>

<details><summary>The diff of <code>src/babykev/__init__.py</code></summary>

```diff
@@ -0,0 +1 @@
+"""babykev: a small decision model. A state, typed questions, and a probability for every answer."""
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/7943e585faa81e4c0400f5e2e9ca7b42ce4bf286). [The code after it](https://github.com/rahuldave/babykev/tree/7943e585faa81e4c0400f5e2e9ca7b42ce4bf286).

<a id="tut-10.3"></a>

### 10.3 The docstrings of the four classes of a request

`D101`: `Noul`, `Choice`, `Score` and `SystemOneRequest` are the classes of a request, and none has a docstring.
Each gets one line, under its `class` line, that says what it is.

[± See the change to `src/babykev/api.py`](#tut-10.3-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, the docstrings of the classes are on lines 17, 25, 39 and 50, under the lines of `Noul`,
`Choice`, `Score` and `SystemOneRequest`.

```bash
uv run python -c "from babykev.api import Score; print(Score.__doc__)"
just lint --statistics
```

`uv run python -c` prints the docstring of `Score`, `A question answered by a level of a scale, whose criteria are
the levels in order.` `just lint --statistics` prints 3 problems, all `D103`.

#### What changed

- <a id="tut-10.3-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a docstring on each class of a request. 8 lines added. [The file](https://github.com/rahuldave/babykev/blob/9a769c7d9551fb181bf7c36d989f94f35f836c2d/src/babykev/api.py).
  - look at `    """A question answered by a level of a scale, whose criteria are the levels in order."""`

<a id="tut-10.3-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9a769c7d9551fb181bf7c36d989f94f35f836c2d). [The code after it](https://github.com/rahuldave/babykev/tree/9a769c7d9551fb181bf7c36d989f94f35f836c2d).

<a id="tut-10.4"></a>

### 10.4 The docstrings of three functions

`D103`: `option_text`, `choice_confidence` and `to_answers` have no docstring. Each gets one line, under its `def`
line, that says what it does. The docstring of `choice_confidence` gives the two ends of its scale, as the docstring
of `score_confidence` does.

[± See the change to `src/babykev/api.py`](#tut-10.4-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, the docstrings of the functions are on lines 74, 104 and 131, under the lines of
`option_text`, `choice_confidence` and `to_answers`.

```bash
uv run python -c "from babykev.api import choice_confidence; print(choice_confidence.__doc__)"
just lint
just fmt --check
just test
```

`uv run python -c` prints `Measure how far the most likely option stands above a guess: 1 if certain, 0 for a
guess.` `just lint` prints `All checks passed!`, and `just fmt --check` prints `6 files already formatted`. `just
test` prints `53 passed`, and the total is 100%, 83 of 83 statements.

#### What changed

- <a id="tut-10.4-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a docstring on each of the three functions. 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/ebd0888f135c00e29b583f6fad0575c290fd4876/src/babykev/api.py).
  - look at `    """Measure how far the most likely option stands above a guess: 1 if certain, 0 for a guess."""`

<a id="tut-10.4-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -71,6 +71,7 @@ def render(v: JSONContent, indent: int = 0) -> str:
 
 
 def option_text(name: str, desc: JSONContent) -> str:
+    """Write an option as its name, followed by its description when it has one."""
     return name if desc is None or desc == "" else f"{name}: {render(desc)}"
 
 
@@ -100,6 +101,7 @@ def to_record(req: SystemOneRequest) -> tuple[dict[str, Any], list[dict[str, Any
 
 
 def choice_confidence(p: list[float]) -> float:
+    """Measure how far the most likely option stands above a guess: 1 if certain, 0 for a guess."""
     k = len(p)
     return 1.0 if k == 1 else (max(p) - 1 / k) / (1 - 1 / k)
 
@@ -126,6 +128,7 @@ def round_prob(x: float) -> float:
 
 
 def to_answers(probs: list[list[float]], meta: list[dict]) -> dict[str, Any]:
+    """Turn the probabilities of the model into an answer of the type of each question."""
     out = {}
     for p, m in zip(probs, meta, strict=True):
         if m["type"] == "noul":
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ebd0888f135c00e29b583f6fad0575c290fd4876).

This part ends at the code at `tut-10`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-10)

<a id="tut-11"></a>

## 11 The gate and the hook

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-10`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-10)

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

[± See the change to `justfile`](#tut-11.1-justfile-424f0b-diff)

At the end of the `justfile`, the recipe `check` is on lines 46 to 55, in the group `quality`. Its body is a script
of `sh`. `set -e` is on line 51, and the three checks are on lines 53 to 55.

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

#### What changed

- <a id="tut-11.1-justfile-424f0b"></a>`justfile`: the recipe `check`, with three checks. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/dbfc285a2adeb4900fc68c863c4850b84004a04e/justfile).
  - look at `    just test -q`

<a id="tut-11.1-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

This change came from running `uv add --group lint pre-commit`.

`uv add` prints `Resolved 25 packages`, and installs pre-commit and the 9 packages that it needs, such as
`pyyaml` and `virtualenv`.

In `pyproject.toml`, the group `lint` now starts with `"pre-commit>=4.7.0",`, on line 27, above ruff. uv sorts the
names of a group. `uv.lock` has the exact version of pre-commit, and of the packages that it needs.

```bash
uv run pre-commit --version
```

It prints the version of pre-commit that uv installed. No hook is installed yet.

#### What changed

- <a id="tut-11.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: pre-commit, in the group `lint`. 1 line added. It comes from `uv add --group lint pre-commit`. [The file](https://github.com/rahuldave/babykev/blob/56dee300cda2e0f34bfb18be026897e83bf6981a/pyproject.toml).
  - look at `"pre-commit>=4.7.0",`
- <a id="tut-11.2-uv.lock-8356d8"></a>`uv.lock`: the exact version of pre-commit, and of the packages that it needs. 139 lines added, 1 removed. It comes from `uv add --group lint pre-commit`. [The file](https://github.com/rahuldave/babykev/blob/56dee300cda2e0f34bfb18be026897e83bf6981a/uv.lock).

<a id="tut-11.2-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the new file `.pre-commit-config.yaml`](#tut-11.3-.pre-commit-config.yaml-e7d14d-diff)

The new file `.pre-commit-config.yaml` has 14 lines. The hook is on lines 9 to 14. `entry: just check`, on line 11,
is the command. `pass_filenames: false` gives `just check` no file names, and `always_run: true` runs it for any
change, whatever its files.

With this hook, `just check` is the gate. The hook is not installed yet, and pre-commit can still run every hook
by hand.

```bash
uv run pre-commit run --all-files
```

`pre-commit run --all-files` runs every hook on every file that git tracks, as `git commit` would. It prints one
line for the hook, `just check....Passed`. A hook that passes prints nothing more.

#### What changed

- <a id="tut-11.3-.pre-commit-config.yaml-e7d14d"></a>`.pre-commit-config.yaml`: one hook, which runs `just check`. New, 14 lines. [The file](https://github.com/rahuldave/babykev/blob/0c645eb0a770a34bf7fe3f055dfc9ab4c19aa6fe/.pre-commit-config.yaml).
  - look at `        entry: just check`

<a id="tut-11.3-.pre-commit-config.yaml-e7d14d-diff"></a>

<details><summary>The diff of <code>.pre-commit-config.yaml</code></summary>

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

[± See the change to `justfile`](#tut-11.4-justfile-424f0b-diff)

In the `justfile`, the recipe `hook` is on lines 28 to 31, under `setup`. It runs `uv run pre-commit install`.

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

#### What changed

- <a id="tut-11.4-justfile-424f0b"></a>`justfile`: the recipe `hook`. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/fbe4cca80366ec49c7fa9c23a11af8b4e1a2bde3/justfile).
  - look at `hook *args:`

<a id="tut-11.4-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[± See the change to `.pre-commit-config.yaml`](#tut-11.5-.pre-commit-config.yaml-e7d14d-diff)

In `.pre-commit-config.yaml`, the new repository is on lines 7 to 11, above `repo: local`. `rev: v6.0.0` is the tag
of the collection that pre-commit uses.

```bash
uv run pre-commit run --all-files
```

The first time on a machine, pre-commit prints lines that start with `[INFO]` while it downloads the collection, into a
folder of its own. Then it prints two lines, `check for added large files....Passed` and `just check....Passed`.

#### What changed

- <a id="tut-11.5-.pre-commit-config.yaml-e7d14d"></a>`.pre-commit-config.yaml`: the hook of large files. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/352e33d87006028ec33ed46ba0e53d48255b3d66/.pre-commit-config.yaml).
  - look at `        args: [--maxkb=1000]`

<a id="tut-11.5-.pre-commit-config.yaml-e7d14d-diff"></a>

<details><summary>The diff of <code>.pre-commit-config.yaml</code></summary>

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

[± See the change to `.pre-commit-config.yaml`](#tut-11.6-.pre-commit-config.yaml-e7d14d-diff)

In `.pre-commit-config.yaml`, line 12 is the new hook, `- id: check-merge-conflict`.

```bash
uv run pre-commit run --all-files
```

pre-commit prints three lines, each `Passed`. The new one is `check for merge conflicts`.

#### What changed

- <a id="tut-11.6-.pre-commit-config.yaml-e7d14d"></a>`.pre-commit-config.yaml`: the hook of merge conflicts. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/64d0f4f781da1a8520315f899c4231645623280c/.pre-commit-config.yaml).
  - look at `      - id: check-merge-conflict`

<a id="tut-11.6-.pre-commit-config.yaml-e7d14d-diff"></a>

<details><summary>The diff of <code>.pre-commit-config.yaml</code></summary>

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

[± See the change to `.pre-commit-config.yaml`](#tut-11.7-.pre-commit-config.yaml-e7d14d-diff)

In `.pre-commit-config.yaml`, the hook `no-env-file` is on lines 15 to 19. `files: (^|/)\.env$`, on line 19, matches
a file named `.env` in any folder.

```bash
uv run pre-commit run --all-files
```

pre-commit prints four lines. The new one ends `(no files to check)Skipped`, because git tracks no `.env` file. The
other three pass.

#### What changed

- <a id="tut-11.7-.pre-commit-config.yaml-e7d14d"></a>`.pre-commit-config.yaml`: the hook that refuses a `.env` file. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/2d080c9e228f2f9959f4eeed801726ea402e66a3/.pre-commit-config.yaml).
  - look at `        language: fail`

<a id="tut-11.7-.pre-commit-config.yaml-e7d14d-diff"></a>

<details><summary>The diff of <code>.pre-commit-config.yaml</code></summary>

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

[± See the change to `src/babykev/cli.py`](#tut-11.8-src-babykev-cli.py-a9e184-diff)

In `src/babykev/cli.py`, line 3 is now `import os`, and nothing in the file uses `os`.

```bash
uv run pre-commit run --all-files
```

The first three hooks pass or skip, as before. `just check....Failed` follows, with `- exit code: 1` and the output of
`just check`. `just fmt --check` prints `6 files already formatted`, because the import is in its place. Then
`just lint` finds `F401`, `` `os` imported but unused ``, at line 3, column 8 of `src/babykev/cli.py`.

`set -e` stops `just check` there, so the tests do not run. pre-commit ends with exit code 1. A `git commit` would
stop here, and record nothing.

#### What changed

- <a id="tut-11.8-src-babykev-cli.py-a9e184"></a>`src/babykev/cli.py`: an import that nothing uses, on purpose. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/f4fabd3272713cb5ac1c26021e4c23fa33ab15e6/src/babykev/cli.py).
  - look at `import os`

<a id="tut-11.8-src-babykev-cli.py-a9e184-diff"></a>

<details><summary>The diff of <code>src/babykev/cli.py</code></summary>

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

[± See the change to `src/babykev/cli.py`](#tut-11.9-src-babykev-cli.py-a9e184-diff)

In `src/babykev/cli.py`, `import sys` is on line 3 again.

```bash
uv run pre-commit run --all-files
```

The four hooks pass or skip, and pre-commit ends with exit code 0. A `git commit` would now record the change.

#### What changed

- <a id="tut-11.9-src-babykev-cli.py-a9e184"></a>`src/babykev/cli.py`: the import of `os` goes. 0 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/054c40b6cc1839f8b35dfab81f9f2ae7c9f1aaf0/src/babykev/cli.py).
  - look at `import os`

<a id="tut-11.9-src-babykev-cli.py-a9e184-diff"></a>

<details><summary>The diff of <code>src/babykev/cli.py</code></summary>

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

[± See the change to `README.md`](#tut-11.10-README.md-8ec9a0-diff)

In `README.md`, the new paragraph is on lines 61 to 63, and the row of `.pre-commit-config.yaml` is on line 79.

```bash
grep -n 'just hook' README.md
```

`grep` prints line 61, the first line of the paragraph, and line 79, the row of the table.

#### What changed

- <a id="tut-11.10-README.md-8ec9a0"></a>`README.md`: a paragraph on `just hook`, and a row of the table. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/cab87c139ebd3b72771ed6db08b02dd7646c7d02/README.md).
  - look at ``Run `just hook` once in each clone. It installs a git hook, which runs `just check` before each commit.``

<a id="tut-11.10-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

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

## 12 The config files are checked

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-11`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-11)

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

This change came from running `uv add --group lint validate-pyproject`.

`uv add` prints `Resolved 27 packages`, and installs validate-pyproject and `fastjsonschema`, which it needs.

In `pyproject.toml`, the group `lint` now ends with `"validate-pyproject>=0.26",`, on line 29. `uv.lock` has its
exact version, and that of `fastjsonschema`.

```bash
uv run validate-pyproject --version
```

It prints the version of validate-pyproject that uv installed. Nothing runs it yet.

#### What changed

- <a id="tut-12.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: validate-pyproject, in the group `lint`. 1 line added. It comes from `uv add --group lint validate-pyproject`. [The file](https://github.com/rahuldave/babykev/blob/7506fb7a39f80397361a8e97ceb816f4b6931cd1/pyproject.toml).
  - look at `"validate-pyproject>=0.26",`
- <a id="tut-12.1-uv.lock-8356d8"></a>`uv.lock`: the exact version of validate-pyproject, and of `fastjsonschema`. 23 lines added. It comes from `uv add --group lint validate-pyproject`. [The file](https://github.com/rahuldave/babykev/blob/7506fb7a39f80397361a8e97ceb816f4b6931cd1/uv.lock).

<a id="tut-12.1-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the change to `justfile`](#tut-12.2-justfile-424f0b-diff)

In the `justfile`, the recipe `lint-config` is on lines 45 to 52, between `lint` and `test`. Line 52 runs
`uv run validate-pyproject pyproject.toml`.

```bash
uv run validate-pyproject pyproject.toml
just --show lint-config
just lint-config
just help lint-config
```

`validate-pyproject` prints `Valid file: pyproject.toml`, and ends with exit code 0.

`just --show lint-config` prints the recipe, and `just lint-config` prints the same line as the command.
`just help lint-config` prints the line of the recipe.

#### What changed

- <a id="tut-12.2-justfile-424f0b"></a>`justfile`: the recipe `lint-config`, with its first check. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/64b71c6c0bdb792769aeef413b2ccead2be00ac4/justfile).
  - look at `lint-config *args:`

<a id="tut-12.2-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[± See the change to `justfile`](#tut-12.3-justfile-424f0b-diff)

In the `justfile`, `uv lock --check` is line 53, the second check of `lint-config`. The comment on line 45 now names
the lockfile too.

```bash
uv lock --check
just lint-config
```

`uv lock --check` prints `Resolved 27 packages`, and ends with exit code 0. `just lint-config` prints
`Valid file: pyproject.toml`, then the same line.

#### What changed

- <a id="tut-12.3-justfile-424f0b"></a>`justfile`: the check of the lockfile. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/4308e46ddc44bbe18fb2ec528e4573e956219a16/justfile).
  - look at `    uv lock --check`

<a id="tut-12.3-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[± See the change to `justfile`](#tut-12.4-justfile-424f0b-diff)

Near the top of the `justfile`, `export UV_LOCKED := "1"` is on line 9, under its comment.

```bash
just --evaluate UV_LOCKED
```

It prints `1`. `just` puts the variable in the environment of each command of each recipe, so every `uv run` of a
recipe sees it.

#### What changed

- <a id="tut-12.4-justfile-424f0b"></a>`justfile`: one line, which exports `UV_LOCKED` to every recipe. 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/9f70971667e9a2fc6cbc1767fe58061ad9f26e22/justfile).
  - look at `export UV_LOCKED := "1"`

<a id="tut-12.4-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[± See the change to `justfile`](#tut-12.5-justfile-424f0b-diff)

In the `justfile`, `just --fmt --check --unstable` is line 57, the third check of `lint-config`. The comment on line
48 names the `justfile`.

```bash
just --fmt --check --unstable
just lint-config
```

`just --fmt --check --unstable` prints nothing, and ends with exit code 0. We wrote the recipes of this tutorial
in the format of just. `just lint-config` prints the same two lines as before.

#### What changed

- <a id="tut-12.5-justfile-424f0b"></a>`justfile`: the check of the `justfile`. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/284e4b7e241387e68463cb96fde80f81603f99c3/justfile).
  - look at `    just --fmt --check --unstable`

<a id="tut-12.5-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

This change came from running `uv add --group lint yamllint`.

`uv add` prints `Resolved 29 packages`, and installs yamllint and `pathspec`, which it needs.

In `pyproject.toml`, the group `lint` now ends with `"yamllint>=1.38.0",`, on line 30. `uv.lock` has its exact
version, and that of `pathspec`.

```bash
uv run yamllint --version
```

It prints the version of yamllint that uv installed.

#### What changed

- <a id="tut-12.6-pyproject.toml-5d07e7"></a>`pyproject.toml`: yamllint, in the group `lint`. 1 line added. It comes from `uv add --group lint yamllint`. [The file](https://github.com/rahuldave/babykev/blob/304e0a2564ddf8d95a9b3964d6b5b8536032d79d/pyproject.toml).
  - look at `"yamllint>=1.38.0",`
- <a id="tut-12.6-uv.lock-8356d8"></a>`uv.lock`: the exact version of yamllint, and of `pathspec`. 24 lines added. It comes from `uv add --group lint yamllint`. [The file](https://github.com/rahuldave/babykev/blob/304e0a2564ddf8d95a9b3964d6b5b8536032d79d/uv.lock).

<a id="tut-12.6-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the change to `justfile`](#tut-12.7-justfile-424f0b-diff)

In the `justfile`, `uv run yamllint --strict .` is line 58, the last check of `lint-config`.

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

#### What changed

- <a id="tut-12.7-justfile-424f0b"></a>`justfile`: yamllint, the fourth check. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/8786cb9f3dd685412d3c315e4b25d7023dc0ad15/justfile).
  - look at `    uv run yamllint --strict .`

<a id="tut-12.7-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[± See the new file `.yamllint`](#tut-12.8-.yamllint-dfe50a-diff)

The new file `.yamllint` has 3 lines. Line 3 is `ignore-from-file: .gitignore`, with a comment.

```bash
uv run yamllint --strict .
```

yamllint now finds problems in two files, and ends with exit code 1. The two files in `.venv` are gone. The four
findings of `.pre-commit-config.yaml` stay. `.yamllint` is YAML too, and yamllint checks it. Line 2 has the warning
`missing document start "---"`, and line 3 has 87 characters.

#### What changed

- <a id="tut-12.8-.yamllint-dfe50a"></a>`.yamllint`: the settings of yamllint. New, 3 lines. [The file](https://github.com/rahuldave/babykev/blob/aee8ff779a7d2889f24a61ab979558405a9c3007/.yamllint).
  - look at `ignore-from-file: .gitignore  # the files that git ignores, such as everything in .venv`

<a id="tut-12.8-.yamllint-dfe50a-diff"></a>

<details><summary>The diff of <code>.yamllint</code></summary>

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

[± See the change to `.yamllint`](#tut-12.9-.yamllint-dfe50a-diff)

In `.yamllint`, `rules:` is on line 4, and line 5 is `document-start: disable`, with a comment.

```bash
uv run yamllint --strict .
```

yamllint finds four problems, and ends with exit code 1. The four are the lines too long, lines 1, 4 and 17 of
`.pre-commit-config.yaml`, and line 3 of `.yamllint`. The warnings are gone.

#### What changed

- <a id="tut-12.9-.yamllint-dfe50a"></a>`.yamllint`: the rule `document-start`, off. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/44f6865153ebeff1c321b4da65ace21285161796/.yamllint).
  - look at `  document-start: disable  # a file need not start with a line of three dashes`

<a id="tut-12.9-.yamllint-dfe50a-diff"></a>

<details><summary>The diff of <code>.yamllint</code></summary>

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

[± See the change to `.yamllint`](#tut-12.10-.yamllint-dfe50a-diff)

In `.yamllint`, line 6 is `line-length: {max: 100}`, with a comment.

```bash
just lint-config
```

yamllint prints nothing, and `just lint-config` passes. It prints `Valid file: pyproject.toml` and
`Resolved 29 packages`, and ends with exit code 0.

#### What changed

- <a id="tut-12.10-.yamllint-dfe50a"></a>`.yamllint`: lines of up to 100 characters. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/063c1a9ec17bea160da66c14711bb87eb1f54ddb/.yamllint).
  - look at `  line-length: {max: 100}  # as long as a line of the Python code`

<a id="tut-12.10-.yamllint-dfe50a-diff"></a>

<details><summary>The diff of <code>.yamllint</code></summary>

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

[± See the change to `justfile`](#tut-12.11-justfile-424f0b-diff)

In the `justfile`, `just lint-config` is line 76, the last line of `check`. The comment on line 66 names the config
files.

```bash
just --show check
just check
```

`just --show check` prints the recipe, with four checks. `just check` prints the output of the format, the linter and
the tests, as before, then `Valid file: pyproject.toml` and `Resolved 29 packages`. It ends with exit code 0.

#### What changed

- <a id="tut-12.11-justfile-424f0b"></a>`justfile`: `lint-config`, the last check of the gate. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/a7699bdb248aa3ff3816137433e5d4482424f3ed/justfile).
  - look at `    just lint-config`

<a id="tut-12.11-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[± See the change to `README.md`](#tut-12.12-README.md-8ec9a0-diff)

In `README.md`, the row of `.yamllint` is on line 80, the last row of the table.

```bash
grep -n yamllint README.md
```

`grep` prints line 80, the new row.

#### What changed

- <a id="tut-12.12-README.md-8ec9a0"></a>`README.md`: a row for `.yamllint`. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/cbbf9bedfc2ba814fc979c43fd2770f5464e3aac/README.md).
  - look at ``| `.yamllint` | The settings of yamllint, which `just lint-config` runs on every YAML file |``

<a id="tut-12.12-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

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

<a id="tut-13"></a>

## 13 Documentation in the code

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-12`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-12)

```bash
just setup
```

`just setup` prints `Resolved 29 packages`.

The signature of `render` gives the types of its parameters, and its docstring says what it does. Neither says what
`indent` means, or what the text that `render` returns is for. A docment says it. A docment is a comment beside a
parameter, a return type or a field, on the same line.

smalldocs reads the signature, the docstring and the docments, and writes the reference of the code from them. It
also lists what has no documentation, as coverage lists the lines that no test runs. The gaps close one part at a
time. A long docment then shows what the formatter can do to one, and the gate runs the check.

<a id="tut-13.1"></a>

### 13.1 Smalldocs, in the group docs

Nothing reads the documentation of the code yet. smalldocs is a Python package, so uv installs it like any other. It
is for the documentation, so it goes in a third dependency group, `docs`.

[smalldocs](https://github.com/rahuldave/smalldocs) makes documentation from the code. It reads docstrings and docments, the comments beside each parameter. It prints them in a terminal, checks that every function has them, and builds a website from them. Its own documentation is at [docs.smallish.dev](https://docs.smallish.dev/).

This change came from running `uv add --group docs smalldocs`.

`uv add` prints `Resolved 34 packages`, and installs smalldocs and four packages that it needs, among them
fastcore and markdown-it-py.

In `pyproject.toml`, the new group `docs` is on lines 26 to 28, above the group `lint`. uv sorts the groups by name.
`uv.lock` has the exact version of smalldocs, and of the packages that it needs.

`default-groups = "all"`, on line 23 of `pyproject.toml`, makes uv install every group. So `just setup` installs
smalldocs, with no other change.

```bash
uv run smalldocs --version
uv tree --only-group docs
```

`uv run smalldocs --version` prints the version of smalldocs that uv installed. `uv tree` prints smalldocs `(group: docs)`,
and under it fastcore, markdown-it-py, mdit-py-plugins, pygments and pyyaml. mdurl is under markdown-it-py.

#### What changed

- <a id="tut-13.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the group `docs`, with smalldocs. 3 lines added. It comes from `uv add --group docs smalldocs`. [The file](https://github.com/rahuldave/babykev/blob/609d58ce5f8c0fb8e7b60548c8ee097766446ff5/pyproject.toml).
  - look at `"smalldocs>=0.1.5",`
- <a id="tut-13.1-uv.lock-8356d8"></a>`uv.lock`: the exact version of smalldocs, and of the packages that it needs. 62 lines added. It comes from `uv add --group docs smalldocs`. [The file](https://github.com/rahuldave/babykev/blob/609d58ce5f8c0fb8e7b60548c8ee097766446ff5/uv.lock).

<a id="tut-13.1-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the new file `docs/_smalldocs.yml`](#tut-13.2-docs-_smalldocs.yml-4b0b48-diff)

The new file `docs/_smalldocs.yml` has 5 lines. Line 3 names the package, `babykev`, and line 5 names the tests,
`tests/**/*.py`.

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

#### What changed

- <a id="tut-13.2-docs-_smalldocs.yml-4b0b48"></a>`docs/_smalldocs.yml`: the package to document, and the tests to check. New, 5 lines. [The file](https://github.com/rahuldave/babykev/blob/4444b1e809427e92a5dc08a9e9fdbbddab7de830/docs/_smalldocs.yml).
  - look at `  packages: [babykev]`

<a id="tut-13.2-docs-_smalldocs.yml-4b0b48-diff"></a>

<details><summary>The diff of <code>docs/_smalldocs.yml</code></summary>

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

[± See the change to `justfile`](#tut-13.3-justfile-424f0b-diff)

At the end of the `justfile`, the recipe `docs` is on lines 78 to 82. Line 82 runs `uv run smalldocs api "$@" --dir
docs`.

```bash
just --show docs
just docs check
just help docs
```

`just --show docs` prints the recipe. `just docs check` prints the same as `smalldocs api check` above, and ends with
`24 of 45` and exit code 1. `just help docs` prints the line of the recipe.

#### What changed

- <a id="tut-13.3-justfile-424f0b"></a>`justfile`: the recipe `docs`. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/a582ad38e75bb188174b75a5e80405cebcd1259d/justfile).
  - look at `docs *args:`

<a id="tut-13.3-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a582ad38e75bb188174b75a5e80405cebcd1259d). [The code after it](https://github.com/rahuldave/babykev/tree/a582ad38e75bb188174b75a5e80405cebcd1259d).

<a id="tut-13.4"></a>

### 13.4 Docments on the functions of api.py

`babykev.api` has seven functions, from `render` to `to_answers`, and none has a docment. Each function now has one
parameter on a line, with its docment beside it, and a docment on its return type, after `-> TYPE:`. The type says
`int`, and the docment says what the number means.

[± See the change to `src/babykev/api.py`](#tut-13.4-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, the signature of `render` is on lines 56 to 59. `indent: int = 0,  # How deeply the value is
nested. Each level indents by two spaces` is line 58, and `) -> str:  # The text that the model sees` is line 59. The
six other functions follow the same pattern, down to `to_answers` on lines 144 to 147.

`just docs module api` prints the reference of the module, as Markdown. `sed` keeps the part of `render`.

```bash
just docs module api | sed -n '/^## render$/,/^## option_text$/p'
just docs check
```

The reference of `render` has its signature, its docstring, and a table with a row for `v`, for `indent` and for
`returns`. The column Description holds the docments. `just docs check` prints `babykev.api 7 of 12`, and
`31 of 45`, with exit code 1. The 7 are the seven functions. The five left in `babykev.api` are the four classes and
`_check`.

#### What changed

- <a id="tut-13.4-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a docment on each parameter and each return of seven functions. 24 lines added, 7 removed. [The file](https://github.com/rahuldave/babykev/blob/ae28dff704c768a862e416a894ac42443ab3468c/src/babykev/api.py).
  - look at `) -> str:  # The text that the model sees`

<a id="tut-13.4-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -53,7 +53,10 @@ class SystemOneRequest(BaseModel):
     questions: dict[str, Question] = Field(min_length=1)
 
 
-def render(v: JSONContent, indent: int = 0) -> str:
+def render(
+    v: JSONContent,  # Text, a number, a list or an object, from a request
+    indent: int = 0,  # How deeply the value is nested. Each level indents by two spaces
+) -> str:  # The text that the model sees
     """Flatten str | object | array into text the model sees. Field names are kept as labels."""
     pad = "  " * indent
     if v is None:
@@ -70,12 +73,17 @@ def render(v: JSONContent, indent: int = 0) -> str:
     )
 
 
-def option_text(name: str, desc: JSONContent) -> str:
+def option_text(
+    name: str,  # The name of the option
+    desc: JSONContent,  # Its description, or None or "" when the name says enough
+) -> str:  # The name alone, or the name and the description
     """Write an option as its name, followed by its description when it has one."""
     return name if desc is None or desc == "" else f"{name}: {render(desc)}"
 
 
-def to_record(req: SystemOneRequest) -> tuple[dict[str, Any], list[dict[str, Any]]]:
+def to_record(
+    req: SystemOneRequest,  # A request that the contract has accepted
+) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record, and the metadata of each question
     """-> internal record for encode(), plus per-question metadata to map probabilities back."""
     qs, meta = [], []
     for qid, q in req.questions.items():
@@ -100,13 +108,17 @@ def to_record(req: SystemOneRequest) -> tuple[dict[str, Any], list[dict[str, Any
     return {"state": render(req.state), "questions": qs}, meta
 
 
-def choice_confidence(p: list[float]) -> float:
+def choice_confidence(
+    p: list[float],  # The probability of each option
+) -> float:  # From 0 for a guess to 1 when one option has all the probability
     """Measure how far the most likely option stands above a guess: 1 if certain, 0 for a guess."""
     k = len(p)
     return 1.0 if k == 1 else (max(p) - 1 / k) / (1 - 1 / k)
 
 
-def score_confidence(p: list[float]) -> float:
+def score_confidence(
+    p: list[float],  # The probability of each level, the lowest level first
+) -> float:  # From 0 for a guess to 1 when one level has all the probability
     """How closely the probabilities sit around the most likely level: 1 if certain, 0 for a guess.
 
     `spread` is the expected distance from the most likely level. `guess` is the spread of a guess,
@@ -121,13 +133,18 @@ def score_confidence(p: list[float]) -> float:
     return max(0.0, 1.0 - spread / guess)
 
 
-def round_prob(x: float) -> float:
+def round_prob(
+    x: float,  # A probability, or a number made from probabilities
+) -> float:  # The same number, to four decimals
     """Round a number for output. Four decimals keep the sum of a distribution within 0.02 of 1,
     even with MAX_OPTIONS options. Two decimals did not: 77 equal options summed to 0.77."""
     return round(float(x), 4)
 
 
-def to_answers(probs: list[list[float]], meta: list[dict]) -> dict[str, Any]:
+def to_answers(
+    probs: list[list[float]],  # For each question, the probability of each of its options
+    meta: list[dict],  # The metadata of the questions, as to_record returns it
+) -> dict[str, Any]:  # The answer to each question, under its name
     """Turn the probabilities of the model into an answer of the type of each question."""
     out = {}
     for p, m in zip(probs, meta, strict=True):
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ae28dff704c768a862e416a894ac42443ab3468c). [The code after it](https://github.com/rahuldave/babykev/tree/ae28dff704c768a862e416a894ac42443ab3468c).

<a id="tut-13.5"></a>

### 13.5 _check says what it checks

`_check` is the validator of `Choice`. Its name starts with `_`, so the linter asks for no docstring, and the
reference leaves it out. smalldocs checks it still, because a reader of the code needs to know what it does. It gets
a docstring, and a docment on its return, the choice itself.

[± See the change to `src/babykev/api.py`](#tut-13.5-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, line 32 is now `def _check(self) -> Self:  # The choice itself, unchanged`, and line 33 is its
docstring.

```bash
just docs check
```

`just docs check` prints `babykev.api 8 of 12`, and `32 of 45`. The gaps of `_check` are gone.

#### What changed

- <a id="tut-13.5-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a docstring and a docment for `_check`. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/a064e34557be7fc006863c995c8cd39e85491b31/src/babykev/api.py).
  - look at `    def _check(self) -> Self:  # The choice itself, unchanged`

<a id="tut-13.5-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -29,7 +29,8 @@ class Choice(BaseModel):
     criteria: dict[str, JSONContent]
 
     @model_validator(mode="after")
-    def _check(self) -> Self:
+    def _check(self) -> Self:  # The choice itself, unchanged
+        """Refuse a choice with no options, or with more than MAX_OPTIONS."""
         if not 1 <= len(self.criteria) <= MAX_OPTIONS:
             raise ValueError(f"criteria must have 1..{MAX_OPTIONS} options")
         return self
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a064e34557be7fc006863c995c8cd39e85491b31). [The code after it](https://github.com/rahuldave/babykev/tree/a064e34557be7fc006863c995c8cd39e85491b31).

<a id="tut-13.6"></a>

### 13.6 A description on every field of a request

The four classes of a request have no signature to put a docment on. Each field is a line of the class, such as
`type: Literal["noul"]`. pydantic takes a description of a field in `Field(description="...")`. It keeps the
description in the schema of the model, which other programs read, and smalldocs puts it in the reference.

[± See the change to `src/babykev/api.py`](#tut-13.6-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, the fields of `Noul` are on lines 19 to 24, and the fields of `SystemOneRequest` on lines 62
to 65. The `criteria` of `Score`, on lines 49 to 53, keep their limits, `min_length=2` and `max_length=MAX_OPTIONS`,
beside the new description.

```bash
uv run python -c "from babykev.api import Score; print(Score.model_json_schema()['properties']['criteria']['description'])"
just docs check
just test
```

`model_json_schema()` is the schema of the model, as JSON, and `uv run python -c` prints the description of the
field `criteria` of `Score`, `The levels of the scale, the lowest first`. `just docs check` prints `babykev.api 12 of
12`, and `36 of 45`. Every gap left is in the tests. `just test` prints `53 passed`. A description changes no rule of
the contract.

#### What changed

- <a id="tut-13.6-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a description on every field of the four classes. 22 lines added, 11 removed. [The file](https://github.com/rahuldave/babykev/blob/6ad6c02267070b7c260934e3165ea40aeb49a035/src/babykev/api.py).
  - look at `    type: Literal["noul"] = Field(description="Marks the question as one of yes or no")`

<a id="tut-13.6-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -16,17 +16,22 @@ MAX_OPTIONS = 255
 class Noul(BaseModel):
     """A question of yes or no. Its criteria, if it has them, describe false and true."""
 
-    type: Literal["noul"]
-    instructions: JSONContent
-    criteria: dict[str, JSONContent] | None = None
+    type: Literal["noul"] = Field(description="Marks the question as one of yes or no")
+    instructions: JSONContent = Field(description="The question, as text or as structured content")
+    criteria: dict[str, JSONContent] | None = Field(
+        default=None,
+        description="What no and yes mean, under the keys false and true. May be left out",
+    )
 
 
 class Choice(BaseModel):
     """A question answered by one of its options, named in its criteria."""
 
-    type: Literal["choice"]
-    instructions: JSONContent
-    criteria: dict[str, JSONContent]
+    type: Literal["choice"] = Field(description="Marks the question as a choice")
+    instructions: JSONContent = Field(description="The question, as text or as structured content")
+    criteria: dict[str, JSONContent] = Field(
+        description="The name of each option, with its description, or null if the name says enough"
+    )
 
     @model_validator(mode="after")
     def _check(self) -> Self:  # The choice itself, unchanged
@@ -39,9 +44,13 @@ class Choice(BaseModel):
 class Score(BaseModel):
     """A question answered by a level of a scale, whose criteria are the levels in order."""
 
-    type: Literal["score"]
-    instructions: JSONContent
-    criteria: list[JSONContent] = Field(min_length=2, max_length=MAX_OPTIONS)
+    type: Literal["score"] = Field(description="Marks the question as a score")
+    instructions: JSONContent = Field(description="The question, as text or as structured content")
+    criteria: list[JSONContent] = Field(
+        min_length=2,
+        max_length=MAX_OPTIONS,
+        description="The levels of the scale, the lowest first",
+    )
 
 
 Question = Noul | Choice | Score
@@ -50,8 +59,10 @@ Question = Noul | Choice | Score
 class SystemOneRequest(BaseModel):
     """One request: a state, and the questions to answer about it, each by its name."""
 
-    state: JSONContent
-    questions: dict[str, Question] = Field(min_length=1)
+    state: JSONContent = Field(description="The context: the document that the questions are about")
+    questions: dict[str, Question] = Field(
+        min_length=1, description="The questions, each under a name that the caller chooses"
+    )
 
 
 def render(
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/6ad6c02267070b7c260934e3165ea40aeb49a035). [The code after it](https://github.com/rahuldave/babykev/tree/6ad6c02267070b7c260934e3165ea40aeb49a035).

<a id="tut-13.7"></a>

### 13.7 Docments on the tests of the command

The tests are documentation too. A reader learns from them what the code must do. `smalldocs api check` holds the
tests to the same rule as the package. In `test_cli.py`, `run` and the two tests have parameters with no docment.
Each now has one parameter on a line, with its docment.

[± See the change to `tests/unit/test_cli.py`](#tut-13.7-tests-unit-test_cli.py-44d4a0-diff)

In `tests/unit/test_cli.py`, the signature of `run` is on lines 8 to 11. The parameters of the two tests are on lines
19 to 21 and 29 to 30.

We read the tests of the command again, with their docments.

```bash
sed -n '8,40p' tests/unit/test_cli.py
just test -k unknown_command
just docs check
```

`sed` prints `run` and the two tests. Each docment says what pytest gives the test. `monkeypatch` sets the command
line, and `capsys` catches what the test prints. The test of an unknown command runs `babykev train`, and checks the
exit code 2 and the message. `just test -k unknown_command` prints `1 passed, 52 deselected`. `just docs check`
prints `tests/unit/test_cli.py 3 of 3`, and `39 of 45`.

#### What changed

- <a id="tut-13.7-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: a docment on each parameter. 9 lines added, 3 removed. [The file](https://github.com/rahuldave/babykev/blob/28caad31e7a7fbab5acefd39c2b2b9e153f096b0/tests/unit/test_cli.py).
  - look at `    capsys: pytest.CaptureFixture[str],  # Catches the message of the refusal`

<a id="tut-13.7-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -5,7 +5,10 @@ import pytest
 from babykev.cli import HELP, main
 
 
-def run(monkeypatch: pytest.MonkeyPatch, *words: str) -> None:
+def run(
+    monkeypatch: pytest.MonkeyPatch,  # pytest's fixture, which undoes each change after the test
+    *words: str,  # The words after `babykev` on the command line
+) -> None:
     """Run `babykev` with these words as its command line."""
     monkeypatch.setattr("sys.argv", ["babykev", *words])
     main()
@@ -13,7 +16,9 @@ def run(monkeypatch: pytest.MonkeyPatch, *words: str) -> None:
 
 @pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])
 def test_help_is_printed_for_help_and_for_no_words(
-    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], words: tuple[str, ...]
+    monkeypatch: pytest.MonkeyPatch,  # Sets the command line for the test
+    capsys: pytest.CaptureFixture[str],  # pytest's fixture, which catches what the test prints
+    words: tuple[str, ...],  # The words of the command line, which ask for the help
 ) -> None:
     """`babykev`, `babykev help`, `--help` and `-h` all print the help text, and nothing else."""
     run(monkeypatch, *words)
@@ -21,7 +26,8 @@ def test_help_is_printed_for_help_and_for_no_words(
 
 
 def test_an_unknown_command_is_refused_with_exit_code_2(
-    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+    monkeypatch: pytest.MonkeyPatch,  # Sets the command line for the test
+    capsys: pytest.CaptureFixture[str],  # Catches the message of the refusal
 ) -> None:
     """A word that is not a command is named, the help is pointed to, and the exit code is 2."""
     with pytest.raises(SystemExit) as exit_info:
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/28caad31e7a7fbab5acefd39c2b2b9e153f096b0). [The code after it](https://github.com/rahuldave/babykev/tree/28caad31e7a7fbab5acefd39c2b2b9e153f096b0).

<a id="tut-13.8"></a>

### 13.8 Docments on the tests of the contract

In `test_api.py`, the helper `cheese_request` has no docment on its return. Five tests take parameters from
`@pytest.mark.parametrize`, with no docment. Each gets its docments.

[± See the change to `tests/unit/test_api.py`](#tut-13.8-tests-unit-test_api.py-58d97c-diff)

In `tests/unit/test_api.py`, line 32 is `def cheese_request() -> SystemOneRequest:  # A noul, a choice and a score about
one cheese`. The test of `option_text` is on lines 155 to 169, with its three parameters on lines 164 to 166.

```bash
sed -n '155,169p' tests/unit/test_api.py
just test -k option_text
just docs check
```

`sed` prints the test of `option_text`. `@pytest.mark.parametrize` gives it three cases. The docments say what each
value is, the name, the description, and the text that `option_text` must make of them. `just test -k option_text`
prints `3 passed, 50 deselected`, one for each case. `just docs check` prints a count for each file, all
complete, and `45 of 45 functions, methods and classes are typed and documented`. It ends with exit code 0.

#### What changed

- <a id="tut-13.8-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: a docment on each parameter, and on the return of `cheese_request`. 17 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/4bd145b7895a9e6f7841a997995efcd343d0049c/tests/unit/test_api.py).
  - look at `    description: JSONContent,  # Its description, or None or "" for none`

<a id="tut-13.8-tests-unit-test_api.py-58d97c-diff"></a>

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -29,7 +29,7 @@ MILKS = {"cow": None, "goat": None, "sheep": None, "mixed": "More than one kind
 FIRMNESS = ["Soft", "Semi-soft", "Semi-hard", "Hard"]
 
 
-def cheese_request() -> SystemOneRequest:
+def cheese_request() -> SystemOneRequest:  # A noul, a choice and a score about one cheese
     """One request that asks a question of each type."""
     return SystemOneRequest.model_validate(
         {
@@ -47,7 +47,9 @@ def cheese_request() -> SystemOneRequest:
 
 
 @pytest.mark.parametrize("line", SAMPLE_LINES)
-def test_sample_line_fits_the_contract(line: dict[str, Any]) -> None:
+def test_sample_line_fits_the_contract(
+    line: dict[str, Any],  # One line of the sample data, read as JSON
+) -> None:
     """Every line of the sample data is a valid request, with one record question per question."""
     request = SystemOneRequest.model_validate(line)
     record, meta = to_record(request)
@@ -57,7 +59,9 @@ def test_sample_line_fits_the_contract(line: dict[str, Any]) -> None:
 
 
 @pytest.mark.parametrize("line", SAMPLE_LINES)
-def test_sample_line_has_a_usable_label_on_every_question(line: dict[str, Any]) -> None:
+def test_sample_line_has_a_usable_label_on_every_question(
+    line: dict[str, Any],  # One line of the sample data, read as JSON
+) -> None:
     """A label is a boolean for noul, an option name for choice, and a level index for score."""
     for question in line["questions"].values():
         label = question["label"]
@@ -140,7 +144,10 @@ def test_score_with_one_level_is_rejected() -> None:
         ([{"role": "customer", "content": "hello"}], "- role: customer\n  content: hello"),
     ],
 )
-def test_render_flattens_json_into_text(value: JSONContent, text: str) -> None:
+def test_render_flattens_json_into_text(
+    value: JSONContent,  # A value of a request
+    text: str,  # The text that render must make of it
+) -> None:
     """Strings, numbers, lists and objects all become the text the model reads."""
     assert render(value) == text
 
@@ -154,7 +161,9 @@ def test_render_flattens_json_into_text(value: JSONContent, text: str) -> None:
     ],
 )
 def test_option_text_adds_a_description_only_when_there_is_one(
-    name: str, description: JSONContent, text: str
+    name: str,  # The name of the option
+    description: JSONContent,  # Its description, or None or "" for none
+    text: str,  # The text that option_text must make of them
 ) -> None:
     """An option is its name, followed by its description when it has one."""
     assert option_text(name, description) == text
@@ -280,7 +289,9 @@ def test_choice_confidence_grows_with_the_winner() -> None:
 
 
 @pytest.mark.parametrize("level", [0, 1, 2])
-def test_score_confidence_is_one_when_certain(level: int) -> None:
+def test_score_confidence_is_one_when_certain(
+    level: int,  # The level that has all the probability
+) -> None:
     """All the probability on one level is certainty, wherever the level is."""
     p = [0.0, 0.0, 0.0]
     p[level] = 1.0
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4bd145b7895a9e6f7841a997995efcd343d0049c). [The code after it](https://github.com/rahuldave/babykev/tree/4bd145b7895a9e6f7841a997995efcd343d0049c).

<a id="tut-13.9"></a>

### 13.9 A docment too long for its line, on purpose

A docment is on the line of its parameter or of its return type, and a line has at most 100 characters. This move
makes a mistake on purpose. The docment of the return of `to_record` says more, and its line grows to 119
characters. The next moves show what the formatter makes of it.

[± See the change to `src/babykev/api.py`](#tut-13.9-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, line 98 now ends with `# The record that the model reads, and the metadata of each question`.

```bash
just lint
just fmt --check
just docs check
```

`just lint` finds `E501`, `Line too long (119 > 100)`, at line 98, and ends with exit code 1. `just fmt --check`
would rewrite the line. It shows the return type split over three lines, with the comment after `]:`, and ends with
exit code 1. `just docs check` still prints `45 of 45`, because the docment is on its line.

#### What changed

- <a id="tut-13.9-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: a docment longer than its line, on purpose. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/95ebd81a9d15158c39a8adf35237da700e9334b2/src/babykev/api.py).
  - look at `) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record that the model reads, and the metadata of each question`

<a id="tut-13.9-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -95,7 +95,7 @@ def option_text(
 
 def to_record(
     req: SystemOneRequest,  # A request that the contract has accepted
-) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record, and the metadata of each question
+) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record that the model reads, and the metadata of each question
     """-> internal record for encode(), plus per-question metadata to map probabilities back."""
     qs, meta = [], []
     for qid, q in req.questions.items():
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/95ebd81a9d15158c39a8adf35237da700e9334b2). [The code after it](https://github.com/rahuldave/babykev/tree/95ebd81a9d15158c39a8adf35237da700e9334b2).

<a id="tut-13.10"></a>

### 13.10 Just fmt wraps the return type

The formatter fixes a line that is too long, and a person runs it without a second thought.

This change came from running `just fmt`.

`just fmt` prints `1 file reformatted, 5 files left unchanged`.

In `src/babykev/api.py`, the return type of `to_record` is now on lines 98 to 100. `) -> tuple[` is line 98, the
types are line 99, and `]:  # The record that the model reads, and the metadata of each question` is line 100.

The comment is now two lines below the arrow `->`. smalldocs reads it as a comment on the line `]:`, and not as the
docment of the return.

```bash
just lint
just check
just docs check
```

`just lint` prints `All checks passed!`, and `just check` passes, with exit code 0. `just docs check` prints
`babykev.api 11 of 12`, `babykev.api:to_record: no return docment`, and `44 of 45`, with exit code 1. The linter and
the formatter are happy, and only the docs check sees the lost docment. `just check` does not run it yet.

#### What changed

- <a id="tut-13.10-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the return type of `to_record`, over three lines. 3 lines added, 1 removed. It comes from `just fmt`. [The file](https://github.com/rahuldave/babykev/blob/54535b100f054ffd8b787c50cac1d3a828770ec9/src/babykev/api.py).
  - look at `]:  # The record that the model reads, and the metadata of each question`

<a id="tut-13.10-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -95,7 +95,9 @@ def option_text(
 
 def to_record(
     req: SystemOneRequest,  # A request that the contract has accepted
-) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record that the model reads, and the metadata of each question
+) -> tuple[
+    dict[str, Any], list[dict[str, Any]]
+]:  # The record that the model reads, and the metadata of each question
     """-> internal record for encode(), plus per-question metadata to map probabilities back."""
     qs, meta = [], []
     for qid, q in req.questions.items():
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/54535b100f054ffd8b787c50cac1d3a828770ec9). [The code after it](https://github.com/rahuldave/babykev/tree/54535b100f054ffd8b787c50cac1d3a828770ec9).

<a id="tut-13.11"></a>

### 13.11 The docment, short enough

The fix is a docment that fits on the line of the return type, with the type on one line again. The docment of
before, `The record, and the metadata of each question`, fits, at 98 characters.

[± See the change to `src/babykev/api.py`](#tut-13.11-src-babykev-api.py-2ea65f-diff)

In `src/babykev/api.py`, line 98 is `) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record, and the metadata of
each question`, as it was before the mistake.

```bash
just fmt --check
just docs check
```

`just fmt --check` prints `6 files already formatted`, and `just docs check` prints `45 of 45`, with exit code 0.

#### What changed

- <a id="tut-13.11-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: the return type on one line, with its short docment. 1 line added, 3 removed. [The file](https://github.com/rahuldave/babykev/blob/861142a50356963bb5e371fe8226ba73b87eef93/src/babykev/api.py).
  - look at `) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record, and the metadata of each question`

<a id="tut-13.11-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -95,9 +95,7 @@ def option_text(
 
 def to_record(
     req: SystemOneRequest,  # A request that the contract has accepted
-) -> tuple[
-    dict[str, Any], list[dict[str, Any]]
-]:  # The record that the model reads, and the metadata of each question
+) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record, and the metadata of each question
     """-> internal record for encode(), plus per-question metadata to map probabilities back."""
     qs, meta = [], []
     for qid, q in req.questions.items():
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/861142a50356963bb5e371fe8226ba73b87eef93). [The code after it](https://github.com/rahuldave/babykev/tree/861142a50356963bb5e371fe8226ba73b87eef93).

<a id="tut-13.12"></a>

### 13.12 The gate checks the docs

`just check` passed with a docment lost. As a line of `check`, `just docs check` runs before each `git commit`,
through the hook. It goes after the tests, and before the config files.

[± See the change to `justfile`](#tut-13.12-justfile-424f0b-diff)

In the `justfile`, `just docs check` is line 76, between `just test -q` and `just lint-config`. The comment on line 66
names the docs.

```bash
just --show check
just check
```

`just --show check` prints the recipe, with five checks. `just check` prints the output of each, with `45 of 45`
after the tests, and ends with exit code 0. A function, a parameter or a field with no documentation now stops
`git commit`.

#### What changed

- <a id="tut-13.12-justfile-424f0b"></a>`justfile`: the docs check, in the gate. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/005b87bdfa2e70c6ceca52dc07197c69702f00be/justfile).
  - look at `    just docs check`

<a id="tut-13.12-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

<a id="tut-14"></a>

## 14 The docs site

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-13`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-13)

```bash
just setup
```

`just setup` prints `Resolved 34 packages`.

The reference exists only as Markdown that `just docs module` prints in a terminal. A reader wants a site, with a
front page that says what babykev is, and a page of reference for each module. smalldocs builds that site from the
same docstrings and docments. Git first learns to ignore the files that a build writes into `docs/`. Then the recipe
`docs` builds the site, the site gets its settings and its front page, and the README names it.

<a id="tut-14.1"></a>

### 14.1 Git ignores what a build of the docs makes

smalldocs builds the site, and the build writes three things into `docs/`. `docs/_site/` is the site, as HTML.
`docs/api/` holds the reference pages, as Markdown, and `docs/_symbols.json` holds the names that a link can point
to. A build makes all three again from the code, so they do not belong in git. `.gitignore` names the files that git
does not track, and three lines at its end name these, before the first build. A `/` at the start of a line means
the root of the repository, so `/docs/api/` is only that folder.

[± See the change to `.gitignore`](#tut-14.1-.gitignore-a5cc29-diff)

At the end of `.gitignore`, the comment is on line 222, and `/docs/_site/`, `/docs/api/` and `/docs/_symbols.json` on
lines 223 to 225.

```bash
tail -n 4 .gitignore
```

`tail -n 4 .gitignore` prints the comment and the three lines.

#### What changed

- <a id="tut-14.1-.gitignore-a5cc29"></a>`.gitignore`: the files that a build of the docs makes. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/3593f61e4e221b04f00f360fe96e6dc4243b02dd/.gitignore).
  - look at `/docs/_site/`

<a id="tut-14.1-.gitignore-a5cc29-diff"></a>

<details><summary>The diff of <code>.gitignore</code></summary>

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

[± See the change to `justfile`](#tut-14.2-justfile-424f0b-diff)

In the `justfile`, the recipe `docs` starts at line 79, with its comment. Line 85,
`if [ "$#" -eq 0 ]; then exec uv run smalldocs render docs; fi`, is the case with no words.

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

#### What changed

- <a id="tut-14.2-justfile-424f0b"></a>`justfile`: with no words, `docs` builds the site. 5 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/64de40516df5aa215bfac1c0198e898ac0960061/justfile).
  - look at `    if [ "$#" -eq 0 ]; then exec uv run smalldocs render docs; fi`

<a id="tut-14.2-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/64de40516df5aa215bfac1c0198e898ac0960061). [The code after it](https://github.com/rahuldave/babykev/tree/64de40516df5aa215bfac1c0198e898ac0960061).

<a id="tut-14.3"></a>

### 14.3 The settings of the site

The site has no title, no sidebar and no links between its pages. Its settings go in `docs/_smalldocs.yml`, above the
section `api`, which stays as it is. They are the type of the project, its output folder, the title, the sidebar, the
theme and a table of contents on each page. With them, a name in backticks, such as `Score`, becomes a link to its
entry in the reference.

[± See the change to `docs/_smalldocs.yml`](#tut-14.3-docs-_smalldocs.yml-4b0b48-diff)

In `docs/_smalldocs.yml`, the sidebar is on lines 8 to 12. It lists the front page, `index.qmd`, then the reference
pages, `contents: api/*`, under the title Reference. The section `api` is on lines 18 to 21, as before.

```bash
just docs
open docs/_site/api/api.html
```

`just docs` prints `wrote 2 page(s) to docs/_site`, then two warnings, `api/api.qmd: broken link /index.qmd` and the
same for `api/cli.qmd`. The sidebar names the front page, which does not exist yet. The next move writes it. The
reference of `api.py` opens in the browser, with the sidebar on the left.

#### What changed

- <a id="tut-14.3-docs-_smalldocs.yml-4b0b48"></a>`docs/_smalldocs.yml`: the settings of the site, above the reference. 17 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/aee2a9faf7fe05e5d8780c8cf42e82c3d4145330/docs/_smalldocs.yml).
  - look at `        contents: api/*  # the reference pages, which each build makes from the code`

<a id="tut-14.3-docs-_smalldocs.yml-4b0b48-diff"></a>

<details><summary>The diff of <code>docs/_smalldocs.yml</code></summary>

```diff
@@ -1,4 +1,20 @@
-# The settings of smalldocs. `api` is the reference, made from the code of the package
+# The settings of smalldocs. `just docs` builds the site into docs/_site
+project:
+  type: website
+  output-dir: _site
+
+website:
+  title: "babykev"
+  sidebar:
+    contents:
+      - index.qmd
+      - section: Reference
+        contents: api/*  # the reference pages, which each build makes from the code
+
+theme: cosmo
+toc: true
+
+# `api` is the reference, made from the code of the package. A name in backticks links to its entry
 api:
   packages: [babykev]
   source: https://github.com/rahuldave/babykev/blob/tutorial  # each entry links to its line here
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/aee2a9faf7fe05e5d8780c8cf42e82c3d4145330). [The code after it](https://github.com/rahuldave/babykev/tree/aee2a9faf7fe05e5d8780c8cf42e82c3d4145330).

<a id="tut-14.4"></a>

### 14.4 A front page

The front page, `docs/index.qmd`, says what babykev is, what a request holds, and what each module does. A `.qmd`
file is Markdown, with a header between two lines `---` that gives the title of the page. The file is new, and comes
whole, as a patch.

[± See the new file `docs/index.qmd`](#tut-14.4-docs-index.qmd-d6d880-diff)

The new file `docs/index.qmd` has 29 lines. Lines 1 to 3 are the header, with `title: babykev`. The list of modules is
on lines 17 to 19.

```bash
just docs
grep -o 'href="api/api.html#[^"]*"' docs/_site/index.html
open docs/_site/index.html
```

`just docs` prints `wrote 3 page(s) to docs/_site`, and no warning. `grep -o` prints each link of the front page into
the reference of `api.py`, seven of them. `SystemOneRequest`, `Noul`, `Choice` and `Score` link to their classes, and
`to_record` and `to_answers` to their functions. `to_answers` is named twice. The front page opens in the browser.

#### What changed

- <a id="tut-14.4-docs-index.qmd-d6d880"></a>`docs/index.qmd`: the front page, written by hand. New, 29 lines. [The file](https://github.com/rahuldave/babykev/blob/e849099979801bc865c5a466d2b098b5ac9aa2e6/docs/index.qmd).
  - look at ``A name in backticks, such as `to_answers`, links to its entry.``

<a id="tut-14.4-docs-index.qmd-d6d880-diff"></a>

<details><summary>The diff of <code>docs/index.qmd</code></summary>

```diff
@@ -0,0 +1,29 @@
+---
+title: babykev
+---
+
+babykev is a small decision model. You send it one document, the context, and a set of typed questions
+about it. It returns a probability for every possible answer to every question.
+
+A request is a `SystemOneRequest`. It has a `state`, the context, and its questions, each under a name. A
+question has one of three types:
+
+- a `Noul` asks for yes or no
+- a `Choice` asks for one of several named options
+- a `Score` asks for a level on an ordered scale
+
+The code is in two modules:
+
+- `babykev.api` is the contract. `to_record` turns a request into the text and the options that the model
+  reads. `to_answers` turns the probabilities of the model into an answer of the type of each question.
+- `babykev.cli` is the command `babykev`.
+
+Each build of the site makes the pages under Reference from the code. A page takes these parts from each
+function and each class:
+
+- the signature and the types
+- the description, from the docstring
+- the description of each parameter, each return value and each field, from its docment or its
+  `Field(description=...)`
+
+A name in backticks, such as `to_answers`, links to its entry.
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e849099979801bc865c5a466d2b098b5ac9aa2e6). [The code after it](https://github.com/rahuldave/babykev/tree/e849099979801bc865c5a466d2b098b5ac9aa2e6).

<a id="tut-14.5"></a>

### 14.5 The README names the docs

The table of the README says where each part of the project is, and it does not list the docs. `docs/` gets a row,
under the tests.

[± See the change to `README.md`](#tut-14.5-README.md-8ec9a0-diff)

In `README.md`, the row of `docs/` is on line 74.

```bash
grep -n 'docs/' README.md
```

`grep` prints line 74, the new row.

#### What changed

- <a id="tut-14.5-README.md-8ec9a0"></a>`README.md`: a row for `docs/`. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/e1efb48492d7223fd0442906d2e55a83e0db481e/README.md).
  - look at ``| `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |``

<a id="tut-14.5-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -71,6 +71,7 @@ yourself at any time.
 | `src/babykev/cli.py` | The command `babykev` |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
 | `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |
+| `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `README.md` | This file |
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e1efb48492d7223fd0442906d2e55a83e0db481e).

This part ends at the code at `tut-14`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-14)

<a id="tut-15"></a>

## 15 The packages of the model

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-14`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-14)

```bash
just setup
```

`just setup` prints `Resolved 34 packages`.

The model of kev is a language model with an adapter and a head of its own, and it needs four packages.

torch computes with tensors, on the CPU or on a GPU. transformers loads a base model and its tokenizer
from the Hugging Face Hub. peft adds a LoRA adapter to the base model. safetensors is the format of the weights on the
Hub. Each package comes in by its own `uv add`, and torch comes first, from an index of its own.

<a id="tut-15.1"></a>

### 15.1 The index of PyTorch's builds for the CPU

torch has several builds of each version. On Linux, the build on PyPI brings the libraries of CUDA, for the GPUs of
NVIDIA. PyTorch keeps a build for the CPU alone on an index of its own, `https://download.pytorch.org/whl/cpu`. An
index is a server of packages, as PyPI is. The patch names the index in `pyproject.toml`.

[± See the change to `pyproject.toml`](#tut-15.1-pyproject.toml-5d07e7-diff)

In `pyproject.toml`, the comment is on lines 25 and 26. The index is on lines 27 to 30, with its name `pytorch-cpu`,
its address and `explicit = true`.

`explicit = true` means that uv takes from the index only the packages that `[tool.uv.sources]` sends there. That
table does not exist yet.

```bash
uv lock --check
```

`uv lock --check` prints `Resolved 34 packages`, and ends with exit code 0. No package uses the index yet, so the
lockfile does not change.

#### What changed

- <a id="tut-15.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: the index of PyTorch. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/b44da7cc2f35c24f23c9f056eb9ec6681a3111e0/pyproject.toml).
  - look at `url = "https://download.pytorch.org/whl/cpu"`

<a id="tut-15.1-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[PyTorch](https://pytorch.org/), the package `torch`, holds tensors, the arrays of numbers that a model computes with, and the layers of neural networks. It runs on a CPU, on an NVIDIA GPU, and on the GPU of a Mac.

This change came from running `uv add torch --index pytorch-cpu --frozen`.

`uv add` prints one warning, `Referencing an index by name is experimental`, and ends with exit code 0. It installs
nothing.

In `pyproject.toml`, line 12 is now `"torch",`, under pydantic. `--frozen` resolves nothing, so uv writes no lowest
version. `[tool.uv.sources]` is on lines 33 and 34, with `torch = { index = "pytorch-cpu" }`. `uv.lock` has not
changed.

```bash
uv lock --check
```

`uv lock --check` prints `Resolved 43 packages`, then `The lockfile at uv.lock needs to be updated`, and ends with
exit code 1. `pyproject.toml` names torch, and `uv.lock` does not have it. `just lint-config` runs the same command, so
`just check` fails too. The next move writes the lockfile.

#### What changed

- <a id="tut-15.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: torch, in the dependencies, and its source. 4 lines added. It comes from `uv add torch --index pytorch-cpu --frozen`. [The file](https://github.com/rahuldave/babykev/blob/a263314ef270d756122972876e80270ed4cde130/pyproject.toml).
  - look at `torch = { index = "pytorch-cpu" }`

<a id="tut-15.2-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

This change came from running `uv lock`.

`uv lock` prints `Resolved 43 packages`, and eight lines `Added`. The line of torch,
`Added torch`, names two versions, one of them with `+cpu`. They are two
builds of torch. The seven packages that it needs, among them `sympy` and `networkx`, are the other seven. `uv lock` writes
`uv.lock` and installs nothing.

`uv.lock` has 230 new lines, with torch and the seven packages that it needs.

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

#### What changed

- <a id="tut-15.3-uv.lock-8356d8"></a>`uv.lock`: torch, from the index of PyTorch, and the seven packages that it needs, from PyPI. 230 lines added, 1 removed. It comes from `uv lock`. [The file](https://github.com/rahuldave/babykev/blob/92e81476ed9ccd19ab2da210dfacb5886dac1712/uv.lock).

[This change on GitHub](https://github.com/rahuldave/babykev/commit/92e81476ed9ccd19ab2da210dfacb5886dac1712). [The code after it](https://github.com/rahuldave/babykev/tree/92e81476ed9ccd19ab2da210dfacb5886dac1712).

<a id="tut-15.4"></a>

### 15.4 transformers

The base model of kev, and its tokenizer, are on the Hugging Face Hub. transformers loads them.

[transformers](https://huggingface.co/docs/transformers), from Hugging Face, loads trained language models and their tokenizers by name, such as `Qwen/Qwen2.5-0.5B`, and downloads their weights once.

This change came from running `uv add transformers`.

`uv add` prints `Resolved 63 packages`, and installs transformers and 18 packages that it needs, among
them `huggingface-hub`, `tokenizers`, `numpy` and `safetensors`.

In `pyproject.toml`, line 13 is now `"transformers>=5.20.0",`, under torch. `uv.lock` has transformers, and the
packages that it needs.

```bash
uv run python -c "import torch, transformers; print(transformers.__version__)"
```

It prints the version of transformers, and no warning. numpy came with transformers, so torch no longer warns.

#### What changed

- <a id="tut-15.4-pyproject.toml-5d07e7"></a>`pyproject.toml`: transformers, in the dependencies. 1 line added. It comes from `uv add transformers`. [The file](https://github.com/rahuldave/babykev/blob/92f659c4e74206cfb776c114d474c2be2501be81/pyproject.toml).
  - look at `"transformers>=5.20.0",`
- <a id="tut-15.4-uv.lock-8356d8"></a>`uv.lock`: the exact version of transformers, and of the packages that it needs. 419 lines added. It comes from `uv add transformers`. [The file](https://github.com/rahuldave/babykev/blob/92f659c4e74206cfb776c114d474c2be2501be81/uv.lock).

<a id="tut-15.4-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[peft](https://huggingface.co/docs/peft), also from Hugging Face, trains a small adapter beside a large model, such as LoRA, in place of all its weights. Training then changes a few million numbers, not hundreds of millions.

This change came from running `uv add peft`.

`uv add` prints `Resolved 66 packages`, and installs peft, `accelerate` and `psutil`.

In `pyproject.toml`, line 11 is now `"peft>=0.21.2",`, above pydantic. uv sorts the names. `uv.lock` has peft, and
the two packages that it needs.

```bash
uv tree --invert --package torch --depth 1
```

`uv tree --invert` prints the packages that need torch, in place of the packages that torch needs. The first line is
`Resolved 66 packages`. Under torch come `accelerate`, `babykev` and `peft`. peft needs torch, and
torch was already here, from the index of PyTorch.

Had peft come first, uv would have taken torch from PyPI, with the libraries of CUDA for Linux. So torch comes first,
from its index.

#### What changed

- <a id="tut-15.5-pyproject.toml-5d07e7"></a>`pyproject.toml`: peft, in the dependencies. 1 line added. It comes from `uv add peft`. [The file](https://github.com/rahuldave/babykev/blob/4b43f5a9f99a891891ac42cb03e3927957e9116c/pyproject.toml).
  - look at `"peft>=0.21.2",`
- <a id="tut-15.5-uv.lock-8356d8"></a>`uv.lock`: the exact version of peft, and of the packages that it needs. 71 lines added. It comes from `uv add peft`. [The file](https://github.com/rahuldave/babykev/blob/4b43f5a9f99a891891ac42cb03e3927957e9116c/uv.lock).

<a id="tut-15.5-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[safetensors](https://huggingface.co/docs/safetensors) stores the weights of a model in a file that loads fast and runs no code when it loads. It is the format that Hugging Face uses to share models.

This change came from running `uv add safetensors`.

`uv add` prints `Resolved 66 packages`, the same count as before, and installs no new package. It installs babykev
again, with its new list of dependencies.

In `pyproject.toml`, line 13 is now `"safetensors>=0.8.0",`. `uv.lock` changes on two lines, which name safetensors
among the dependencies of babykev.

```bash
uv tree --invert --package safetensors --depth 1
```

Under safetensors come `accelerate`, `babykev`, `peft` and `transformers`. Before the move, the list had
no `babykev`.

#### What changed

- <a id="tut-15.6-pyproject.toml-5d07e7"></a>`pyproject.toml`: safetensors, in the dependencies. 1 line added. It comes from `uv add safetensors`. [The file](https://github.com/rahuldave/babykev/blob/8176ced7157929f551e3722149016dbc31d42601/pyproject.toml).
  - look at `"safetensors>=0.8.0",`
- <a id="tut-15.6-uv.lock-8356d8"></a>`uv.lock`: safetensors, as a dependency of babykev. 2 lines added. It comes from `uv add safetensors`. [The file](https://github.com/rahuldave/babykev/blob/8176ced7157929f551e3722149016dbc31d42601/uv.lock).

<a id="tut-15.6-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the change to `README.md`](#tut-15.7-README.md-8ec9a0-diff)

In `README.md`, the new paragraph is on lines 61 to 63.

```bash
just setup
du -sh .venv .venv/lib/python3.13/site-packages/torch
```

`just setup` prints `Resolved 66 packages`. `du -sh` prints the size of the environment, `765M`, and of torch alone,
`542M`. The sizes can differ a little on another machine.

#### What changed

- <a id="tut-15.7-README.md-8ec9a0"></a>`README.md`: a paragraph on the packages of the model. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/c7037ec460963acd41edf1f63a6a03d2e52e5bae/README.md).
  - look at `The model needs four packages, torch, transformers, peft and safetensors. torch is the build for the CPU,`

<a id="tut-15.7-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

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

<a id="tut-16"></a>

## 16 The model

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-15`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-15)

```bash
just setup
```

`just setup` prints `Resolved 66 packages`.

babykev has a contract and no model. `model.py` is the model. It comes in whole, from kev's first version, and we
read it before anything else. It meets the gate as it is. No test calls it yet, and the coverage shows it. Then the
front page of the docs and the README name it.

<a id="tut-16.1"></a>

### 16.1 model.py, the model

`model.py` turns a language model into a model that decides. It has 274 lines, and four ideas, which its docstring
names. The file comes in whole, as a patch.

[± See the new file `src/babykev/model.py`](#tut-16.1-src-babykev-model.py-a86a0b-diff)

`src/babykev/model.py` is new, with 274 lines. The docstring of the module is on lines 1 to 18. The functions that
pack a record are on lines 78 to 142, and the mask is on lines 145 to 162. The head is on lines 165 to 184, and
`DecisionModel` on lines 187 to 274.

```bash
sed -n '1,18p' src/babykev/model.py
```

The four ideas are packing, the mask, the restarted positions and pointing. Packing writes the state and every
question into one sequence of tokens. The mask lets each token see the state and its own question, and never another
question. The positions of each question start right after the state. The head points at an option, and the model
generates no text.

```bash
sed -n '34,54p' src/babykev/model.py
```

Line 37, `SPECIAL`, lists the five delimiters, special tokens that the base model already has. Line 38 sets the
longest state, 384 tokens, and the longest state and question together, 1024. The `TypedDict` `Encoded`, on lines 45
to 53, is a packed record. Each key has a type and a docment.

```bash
sed -n '145,162p' src/babykev/model.py
```

The docstring of `branch_mask`, on lines 150 to 155, gives the rule. Token i may look at token j when j is not after
i, and j is in the state or in the question of i. The mask is added to the scores of the attention, so a blocked pair
gets the most negative number of its type.

```bash
sed -n '187,219p' src/babykev/model.py
```

`DecisionModel` loads a backbone from the Hub, on lines 200 to 205, if the caller gives none. The parameter
`backbone`, on line 195, is there for the tests. With `lora`, peft wraps the backbone in an adapter, on lines 208 to
216. The head comes last, on line 217.

The file is formatted, typed and documented, so the gate has nothing to say about it.

```bash
just fmt --check
just lint
just docs check
```

`just fmt --check` prints `7 files already formatted`, and `just lint` prints `All checks passed!`. `just docs check`
prints a note of torch, `NOTE: Redirects are currently not supported in MacOs.` smalldocs imports `model.py` to
read it. On a Mac, the import of peft makes torch print the note, and it is not an error. The note goes to the
standard error, so where it shows among the other lines can vary. `just docs check` also prints
`babykev.model 15 of 15`, and `60 of 60 functions, methods and classes are typed and documented`.

```bash
just test
```

`just test` prints `53 passed`, and the coverage falls. `model.py` has 109 statements at 0%, and the column Missing
says `20-274`. No test imports `model.py`, and `--cov=babykev` still counts every file of the package. The total is
43%, 83 of 192 statements, where it was 100%, 83 of 83. `just check` has no floor on the coverage, so it passes. The
tests of the model come later, and bring the coverage back.

#### What changed

- <a id="tut-16.1-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: the model. It packs a request into tokens, masks it, and points at the options. New, 274 lines. [The file](https://github.com/rahuldave/babykev/blob/c4c288ccc7e47190fd3d3340cbbbb7cf63b77d93/src/babykev/model.py).
  - look at `class DecisionModel(nn.Module):`

<a id="tut-16.1-src-babykev-model.py-a86a0b-diff"></a>

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

```diff
@@ -0,0 +1,274 @@
+"""The model: a language model that reads a packed request, and a head that points at options.
+
+Four ideas make a language model into a decision model.
+
+1. **Packing.** `encode` writes the state and every question into one sequence of tokens. Five
+   delimiter tokens mark the parts: the state, a question, the start and the end of an option, and
+   the place where the question is decided.
+2. **The mask.** `branch_mask` lets each token see the state and its own question, and never another
+   question. The questions share one reading of the state and cannot influence each other.
+3. **Positions restart.** Each question's positions begin right after the state, so a question looks
+   the same to the model wherever it comes in the request.
+4. **Pointing.** `PointerHead` scores each option's closing token against the question's decide
+   token. The model has no vocabulary head and generates nothing.
+
+`DecisionModel` puts them together around a backbone, with a LoRA adapter if asked for. It reads
+several records in one pass: they are padded to the same length, and the padding is given a segment
+of its own, so the mask that keeps questions apart keeps every real token away from it too.
+"""
+
+import math
+import re
+from typing import Any, TypedDict
+
+import torch
+from peft import LoraConfig, get_peft_model
+from torch import nn
+from transformers import (
+    AutoModelForCausalLM,
+    AutoTokenizer,
+    PreTrainedModel,
+    PreTrainedTokenizerBase,
+)
+
+# The delimiters are special tokens the base model already has and rarely uses, in this order:
+# state, question, option start, option end, decide. No embedding has to be added or trained for
+# them; the adapter learns their new meaning.
+SPECIAL = ["<|fim_prefix|>", "<|fim_middle|>", "<|box_start|>", "<|box_end|>", "<|fim_suffix|>"]
+MAX_STATE, MAX_BRANCH = 384, 1024
+LORA_TARGETS = ["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"]
+PAD_SEGMENT = -1  # The segment of padding. No real token is in it, so none can attend to it
+
+_SPECIAL_RE = re.compile(r"<\|([A-Za-z0-9_]+)\|>")
+
+
+class Encoded(TypedDict):
+    """One packed record, ready for the model."""
+
+    ids: list[int]  # The token ids of the whole sequence
+    seg: list[int]  # The segment of each token: 0 for the state, k for question k
+    pos: list[int]  # The position of each token; every question restarts right after the state
+    decide_idx: list[int]  # For each question, where its decide token is
+    opt_idx: list[list[int]]  # For each question, where the closing token of each option is
+    labels: list[int]  # For each question, the index of the right option
+
+
+def pick_device(
+    override: str | None = None,  # A device name to use whatever the machine has
+) -> str:  # `cuda`, `mps` or `cpu`
+    """Choose where the model runs: a CUDA GPU if there is one, then Apple's GPU, then the CPU."""
+    if override:
+        return override
+    if torch.cuda.is_available():
+        return "cuda"
+    return "mps" if torch.backends.mps.is_available() else "cpu"
+
+
+def load_tokenizer(
+    name: str,  # A model name on the Hugging Face Hub, or a local folder
+    revision: str | None = None,  # The commit of the model to use; `None` for the latest
+) -> PreTrainedTokenizerBase:  # Its tokenizer
+    """Load the tokenizer that belongs to a base model."""
+    tok = AutoTokenizer.from_pretrained(name, revision=revision)
+    if not isinstance(tok, PreTrainedTokenizerBase):
+        raise TypeError(f"{name} has no tokenizer this model can use")
+    return tok
+
+
+def delimiter_ids(
+    tok: PreTrainedTokenizerBase,  # The base model's tokenizer
+) -> list[int]:  # The ids of the five delimiters, in the order of `SPECIAL`
+    """Look up the token ids of the delimiters."""
+    ids = tok.convert_tokens_to_ids(SPECIAL)
+    return ids if isinstance(ids, list) else [ids]
+
+
+def user_tokens(
+    tok: PreTrainedTokenizerBase,  # The base model's tokenizer
+    text: str,  # Text that came from a caller: a state, an instruction or an option
+) -> list[int]:  # Its token ids, none of which is a delimiter or any other special token
+    """Tokenize a caller's text so that it can never forge a delimiter.
+
+    A tokenizer turns the string `<|box_end|>` into the special token of that name, wherever the
+    string appears. Text that contained it could close an option early. So `<|name|>` is rewritten
+    to `<¦name¦>` before tokenizing, which reads the same to a person and is ordinary text to the
+    tokenizer.
+    """
+    return tok(_SPECIAL_RE.sub(r"<¦\1¦>", text), add_special_tokens=False).input_ids
+
+
+def encode(
+    tok: PreTrainedTokenizerBase,  # The base model's tokenizer
+    rec: dict[str, Any],  # A record, as `to_record` returns it: a state and its questions
+    max_state: int = MAX_STATE,  # The longest state allowed, in tokens
+    max_branch: int = MAX_BRANCH,  # The longest state and question together, in tokens
+) -> Encoded:  # The packed record
+    """Pack a record into one sequence: the state, then one branch for each question.
+
+    The state is the state delimiter and its text. A branch is the question delimiter, the
+    instruction, each option between its two delimiters, and the decide delimiter.
+
+    Raises `ValueError` when the state is longer than `max_state` or a branch does not fit in
+    `max_branch`. Nothing is cut to fit: a record that is too long is refused, by name.
+    """
+    s_id, q_id, o_id, c_id, d_id = delimiter_ids(tok)
+    state = [s_id] + user_tokens(tok, rec["state"])
+    if len(state) > max_state:
+        raise ValueError(f"state too long: {len(state)} tokens, the limit is {max_state}")
+    ids, seg, pos = list(state), [0] * len(state), list(range(len(state)))
+    decide_idx, opt_idx = [], []
+    for k, q in enumerate(rec["questions"], start=1):
+        br = [q_id] + user_tokens(tok, q["instr"])
+        oi = []
+        for o in q["options"]:
+            br += [o_id] + user_tokens(tok, o) + [c_id]
+            oi.append(len(br) - 1)
+        br.append(d_id)
+        if len(br) > max_branch - len(state):
+            raise ValueError(f"branch too long: {len(br)}")
+        base = len(ids)
+        ids += br
+        seg += [k] * len(br)
+        pos += list(range(len(state), len(state) + len(br)))
+        decide_idx.append(base + len(br) - 1)
+        opt_idx.append([base + i for i in oi])
+    return {
+        "ids": ids,
+        "seg": seg,
+        "pos": pos,
+        "decide_idx": decide_idx,
+        "opt_idx": opt_idx,
+        "labels": [q["label"] for q in rec["questions"]],
+    }
+
+
+def branch_mask(
+    seg: list[int],  # The segment of each token: 0 for the state, k for question k
+    device: str,  # Where to build the mask
+    dtype: torch.dtype = torch.float32,  # The number type of the model's attention scores
+) -> torch.Tensor:  # Shape [1, 1, n, n]: 0 where i may attend to j, very negative elsewhere
+    """Build the block-causal mask: a token sees the state and its own question, never a sibling.
+
+    Token i may attend to token j when j is not after i, and j is in the state or in the same
+    question as i. The mask is added to the attention scores, so a blocked pair gets the most
+    negative number the type can hold.
+    """
+    s = torch.tensor(seg, device=device)
+    n = len(seg)
+    causal = torch.tril(torch.ones(n, n, dtype=torch.bool, device=device))
+    same = torch.ones_like(causal) | (s[None, :] == 0)
+    allow = causal & same
+    blocked = torch.finfo(dtype).min
+    return torch.zeros(n, n, dtype=dtype, device=device).masked_fill(~allow, blocked)[None, None]
+
+
+class PointerHead(nn.Module):
+    """Scores the options of one question against its decide token."""
+
+    def __init__(
+        self,
+        d: int,  # The width of the backbone's hidden states
+        dp: int = 256,  # The width of the space in which options and decide tokens are compared
+    ) -> None:
+        """Make the two projections, one for decide tokens and one for options."""
+        super().__init__()
+        self.q, self.k = nn.Linear(d, dp), nn.Linear(d, dp)
+        self.scale = 1 / math.sqrt(dp)
+
+    def forward(
+        self,
+        h_decide: torch.Tensor,  # The hidden state at the decide token, shape [d]
+        h_opts: torch.Tensor,  # The hidden states at the K options' closing tokens, shape [K, d]
+    ) -> torch.Tensor:  # One logit per option, shape [K]
+        """Project both sides and take their scaled dot products."""
+        return (self.k(h_opts) @ self.q(h_decide)) * self.scale
+
+
+class DecisionModel(nn.Module):
+    """A language model without its vocabulary head, read through a mask, with a `PointerHead`."""
+
+    def __init__(
+        self,
+        name: str,  # The base model to load from the Hugging Face Hub, when no backbone is given
+        device: str,  # Where the model runs: `cuda`, `mps` or `cpu`
+        lora: int | None = None,  # The rank of a LoRA adapter to add, or `None` for no adapter
+        backbone: PreTrainedModel | None = None,  # A ready backbone, such as a small one in tests
+        revision: str | None = None,  # The commit of the base model to load; `None` for the latest
+    ) -> None:
+        """Load or take the backbone, wrap it in an adapter if asked, and add the head."""
+        super().__init__()
+        if backbone is None:
+            # Only the transformer is kept. The vocabulary head is dropped: nothing is generated.
+            lm = AutoModelForCausalLM.from_pretrained(
+                name, revision=revision, dtype=torch.float32, attn_implementation="eager"
+            )
+            backbone = lm.model
+        width: int = backbone.config.hidden_size
+        self.lm: nn.Module = backbone
+        if lora:
+            cfg = LoraConfig(
+                task_type="FEATURE_EXTRACTION",
+                r=lora,
+                lora_alpha=2 * lora,
+                lora_dropout=0.05,
+                target_modules=LORA_TARGETS,
+            )
+            self.lm = get_peft_model(self.lm, cfg)
+        self.head = PointerHead(width)
+        self.device = device
+        self.to(device)
+
+    def hidden(
+        self,
+        encs: list[Encoded],  # Packed records
+    ) -> torch.Tensor:  # The hidden state of every token of every record, shape [B, n, d]
+        """Run the backbone over packed records in one pass, each with its positions and its mask.
+
+        The records are padded to the length of the longest. Padding is in `PAD_SEGMENT`, which
+        `branch_mask` treats as one more question: no real token attends to it, and what the
+        model computes at a padded place is never read.
+        """
+        longest = max(len(enc["ids"]) for enc in encs)
+        ids = torch.zeros(len(encs), longest, dtype=torch.long, device=self.device)
+        pos = torch.zeros_like(ids)
+        masks = []
+        for b, enc in enumerate(encs):
+            n = len(enc["ids"])
+            ids[b, :n] = torch.tensor(enc["ids"], device=self.device)
+            pos[b, :n] = torch.tensor(enc["pos"], device=self.device)
+            masks.append(branch_mask(enc["seg"] + [PAD_SEGMENT] * (longest - n), self.device)[0])
+        mask = torch.stack(masks)
+        return self.lm(input_ids=ids, position_ids=pos, attention_mask=mask).last_hidden_state
+
+    def forward_batch(
+        self,
+        encs: list[Encoded],  # Packed records
+    ) -> list[list[torch.Tensor]]:  # For each record, for each question, one logit per option
+        """Score every option of every question of several records in one pass."""
+        h = self.hidden(encs)
+        return [
+            [
+                self.head(h[b, d], h[b, torch.tensor(oi, device=self.device)])
+                for d, oi in zip(enc["decide_idx"], enc["opt_idx"], strict=True)
+            ]
+            for b, enc in enumerate(encs)
+        ]
+
+    def forward(
+        self,
+        enc: Encoded,  # A packed record
+    ) -> list[torch.Tensor]:  # For each question, one logit per option
+        """Score every option of every question of one record."""
+        return self.forward_batch([enc])[0]
+
+    @torch.no_grad()
+    def probs(
+        self,
+        enc: Encoded,  # A packed record
+    ) -> list[torch.Tensor]:  # For each question, the probability of each option, on the CPU
+        """Answer without tracking gradients: the logits of `forward` turned into probabilities."""
+        return [torch.softmax(z, -1).cpu() for z in self.forward(enc)]
+
+    def trainable_parameters(self) -> list[nn.Parameter]:  # The adapter's and the head's
+        """List the parameters that training changes."""
+        return [p for p in self.parameters() if p.requires_grad]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c4c288ccc7e47190fd3d3340cbbbb7cf63b77d93). [The code after it](https://github.com/rahuldave/babykev/tree/c4c288ccc7e47190fd3d3340cbbbb7cf63b77d93).

<a id="tut-16.2"></a>

### 16.2 The front page names the model

The front page of the docs says that the code is in two modules. Now it is in three.

[± See the change to `docs/index.qmd`](#tut-16.2-docs-index.qmd-d6d880-diff)

In `docs/index.qmd`, line 15 says `three modules`, and the item of `babykev.model` is on lines 20 and 21.

`encode()` has its brackets on line 20. smalldocs does not link the plain word `encode`, and it links `encode()` to
the function.

```bash
just docs
grep -o 'href="api/model.html#[^"]*"' docs/_site/index.html
```

`just docs` prints `wrote 4 page(s) to docs/_site`, and the note of torch. The fourth page is the reference of
`model.py`. `grep -o` prints the two links of the front page into it, `#encode` and `#DecisionModel`.

#### What changed

- <a id="tut-16.2-docs-index.qmd-d6d880"></a>`docs/index.qmd`: the module `babykev.model`, in the list. 3 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/bc2df6d99386f11f4e193e0b530fa87128a3acd7/docs/index.qmd).
  - look at ``- `babykev.model` is the model. `encode()` packs a record into one sequence of tokens, and a``

<a id="tut-16.2-docs-index.qmd-d6d880-diff"></a>

<details><summary>The diff of <code>docs/index.qmd</code></summary>

```diff
@@ -12,11 +12,13 @@ question has one of three types:
 - a `Choice` asks for one of several named options
 - a `Score` asks for a level on an ordered scale
 
-The code is in two modules:
+The code is in three modules:
 
 - `babykev.api` is the contract. `to_record` turns a request into the text and the options that the model
   reads. `to_answers` turns the probabilities of the model into an answer of the type of each question.
 - `babykev.cli` is the command `babykev`.
+- `babykev.model` is the model. `encode()` packs a record into one sequence of tokens, and a
+  `DecisionModel` scores every option of every question in one pass.
 
 Each build of the site makes the pages under Reference from the code. A page takes these parts from each
 function and each class:
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/bc2df6d99386f11f4e193e0b530fa87128a3acd7). [The code after it](https://github.com/rahuldave/babykev/tree/bc2df6d99386f11f4e193e0b530fa87128a3acd7).

<a id="tut-16.3"></a>

### 16.3 The README names model.py

The table of the README lists each file of the code. `model.py` gets a row, under `cli.py`.

[± See the change to `README.md`](#tut-16.3-README.md-8ec9a0-diff)

In `README.md`, the row of `src/babykev/model.py` is on line 76.

```bash
grep -n 'model.py' README.md
```

`grep` prints line 76, the new row.

#### What changed

- <a id="tut-16.3-README.md-8ec9a0"></a>`README.md`: a row for `src/babykev/model.py`. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/056fe2ced73ff8568dfc329555795524c2465eb1/README.md).
  - look at ``| `src/babykev/model.py` | The model, a language model with a head that points at the options |``

<a id="tut-16.3-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -73,6 +73,7 @@ yourself at any time.
 | `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, the settings of its tools, and the exact versions to install |
 | `src/babykev/api.py` | The contract: the request and its three types of question as pydantic models, the text and options the model reads, and the answers made from its probabilities |
 | `src/babykev/cli.py` | The command `babykev` |
+| `src/babykev/model.py` | The model, a language model with a head that points at the options |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
 | `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |
 | `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/056fe2ced73ff8568dfc329555795524c2465eb1).

This part ends at the code at `tut-16`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-16)

<a id="tut-17"></a>

## 17 Types

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-16`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-16)

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

This change came from running `uv add --group lint ty`.

`uv add` prints `Resolved 67 packages`, and installs ty, which needs no other package.

In `pyproject.toml`, the group `lint` has `"ty>=0.0.88",` on line 46, under ruff. `uv.lock` has its exact version.

```bash
uv run ty --version
```

It prints the version of ty that uv installed. A newer ty can find more, or less, than these notes show.

#### What changed

- <a id="tut-17.1-pyproject.toml-5d07e7"></a>`pyproject.toml`: ty, in the group `lint`. 1 line added. It comes from `uv add --group lint ty`. [The file](https://github.com/rahuldave/babykev/blob/aaa8fe6d7d1dfbca863fe23dc0d660dd10d36c2b/pyproject.toml).
  - look at `"ty>=0.0.88",`
- <a id="tut-17.1-uv.lock-8356d8"></a>`uv.lock`: the exact version of ty. 27 lines added. It comes from `uv add --group lint ty`. [The file](https://github.com/rahuldave/babykev/blob/aaa8fe6d7d1dfbca863fe23dc0d660dd10d36c2b/uv.lock).

<a id="tut-17.1-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the change to `justfile`](#tut-17.2-justfile-424f0b-diff)

In the `justfile`, the recipe `types` is on lines 60 to 64. Line 64 runs `uv run ty check "$@"`.

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

#### What changed

- <a id="tut-17.2-justfile-424f0b"></a>`justfile`: the recipe `types`. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/7866ef7f88d528e2e7ee04d55c68e56ce461cff1/justfile).
  - look at `types *args:`

<a id="tut-17.2-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[± See the change to `src/babykev/model.py`](#tut-17.3-src-babykev-model.py-a86a0b-diff)

In `src/babykev/model.py`, the reason is on lines 178 and 179, and line 180 is
`def forward(  # ty: ignore[invalid-mutable-override]`.

```bash
just types
just docs check
```

`just types` prints one diagnostic, at `src/babykev/model.py:259:9`, the `forward` of `DecisionModel`, two lines lower
than before. It ends with `Found 1 diagnostic`, and exit code 1. `just docs check` prints the note of torch and
`60 of 60`. The comment on the line `def forward(` is not a docment, because a docment is on the line of a parameter
or of the return type.

#### What changed

- <a id="tut-17.3-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: the rule off on the `forward` of `PointerHead`, with the reason. 3 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/d5312a3ec2ed265ca4dbf5c7dd2492c686024696/src/babykev/model.py).
  - look at `    # tensors accepts fewer calls, so ty refuses it. torch only calls forward, and never sets it`

<a id="tut-17.3-src-babykev-model.py-a86a0b-diff"></a>

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

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

[± See the change to `src/babykev/model.py`](#tut-17.4-src-babykev-model.py-a86a0b-diff)

In `src/babykev/model.py`, the reason is on line 259, and line 260 is
`def forward(  # ty: ignore[invalid-mutable-override]`.

```bash
just types
```

`just types` prints `All checks passed!`, and ends with exit code 0.

#### What changed

- <a id="tut-17.4-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: the rule off on the `forward` of `DecisionModel`, with the reason. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/f14349138824af0b107742451814b1234e72b34a/src/babykev/model.py).
  - look at `    # As in PointerHead, nn.Module declares forward as an attribute, and torch never sets it`

<a id="tut-17.4-src-babykev-model.py-a86a0b-diff"></a>

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

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

[± See the change to `justfile`](#tut-17.5-justfile-424f0b-diff)

In the `justfile`, `just types` is line 81, between `just lint` and `just test -q`. The comment on line 72 names the
types.

```bash
just --show check
just check
```

`just --show check` prints the recipe, with six checks. `just check` prints `All checks passed!` twice, once for the
linter and once for ty. Then come `53 passed`, the total of 43%, `60 of 60` and the config files, and it ends with
exit code 0. A call that does not match the types now stops `git commit`.

#### What changed

- <a id="tut-17.5-justfile-424f0b"></a>`justfile`: ty, in the gate. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/d4dd1c8d3d3c94aa391b3baff5c5aab706b149b9/justfile).
  - look at `    just types`

<a id="tut-17.5-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

<a id="tut-18"></a>

## 18 The smoke run

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-17`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-17)

```bash
just setup
```

`just setup` prints `Resolved 67 packages`.

`model.py` passes every check, and nothing has run it. A smoke run is the first thing to try. It loads the real model
on this machine, asks it the questions of the sample data, and prints each answer beside its label. Nothing is trained,
so the answers are guesses. The run shows that the contract, the packing, the model and the answers fit together.

`smoke.py` is ours, and it comes one function at a time. The command `babykev smoke` and the recipe `just smoke` run
it, on this machine only.

<a id="tut-18.1"></a>

### 18.1 smoke.py, which reads the sample

The smoke reads the five labelled requests of `data/cheese/sample.jsonl`. `read_lines` reads one request from each
line of the file.

[± See the new file `src/babykev/smoke.py`](#tut-18.1-src-babykev-smoke.py-76d2ec-diff)

The new file `src/babykev/smoke.py` has 22 lines. The docstring of the module, on lines 1 to 8, says what the smoke
does. `SAMPLE` is on line 14, and `read_lines` on lines 17 to 22.

```bash
uv run python -c "from babykev.smoke import read_lines; lines = read_lines(); print(len(lines), list(lines[0]))"
```

It prints `5 ['state', 'questions']`, five requests, each with a state and its questions.

```bash
just test
```

`just test` prints `53 passed`. `smoke.py` has 7 statements at 0%, and the total falls from 43% to 42%, 83 of 199.
The coverage counts every file of the package, and no test imports `smoke.py`.

#### What changed

- <a id="tut-18.1-src-babykev-smoke.py-76d2ec"></a>`src/babykev/smoke.py`: the docstring, and the function that reads the sample. New, 22 lines. [The file](https://github.com/rahuldave/babykev/blob/5ec6d4a73df947af8d705956fffa07c9787017de/src/babykev/smoke.py).
  - look at `def read_lines(`

<a id="tut-18.1-src-babykev-smoke.py-76d2ec-diff"></a>

<details><summary>The diff of <code>src/babykev/smoke.py</code></summary>

```diff
@@ -0,0 +1,22 @@
+"""A smoke run: everything that exists so far, end to end, on the real model.
+
+It loads the base model with a fresh adapter and an untrained pointer head, asks it the questions
+in the sample data, and prints each answer beside its label. Nothing has been trained yet, so the
+answers are guesses. What the run shows is that the pieces fit: a line of data passes the contract,
+is packed into one sequence, goes through the model on whatever device there is, and comes back as
+answers.
+"""
+
+import json
+from pathlib import Path
+from typing import Any
+
+SAMPLE = Path("data/cheese/sample.jsonl")
+
+
+def read_lines(
+    path: Path = SAMPLE,  # A JSONL file of labelled requests
+) -> list[dict[str, Any]]:  # One labelled request per line of the file
+    """Read labelled requests from a JSONL file."""
+    with path.open(encoding="utf-8") as f:
+        return [json.loads(line) for line in f if line.strip()]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5ec6d4a73df947af8d705956fffa07c9787017de). [The code after it](https://github.com/rahuldave/babykev/tree/5ec6d4a73df947af8d705956fffa07c9787017de).

<a id="tut-18.2"></a>

### 18.2 answer

`answer` takes one request through every part of babykev. The contract checks the request, and `to_record` turns it
into a record. `encode` packs the record into tokens, and `model.probs` gives the probabilities. `to_answers` turns
them into an answer for each question. `answer` also counts the tokens and times the pass of the model.

[± See the change to `src/babykev/smoke.py`](#tut-18.2-src-babykev-smoke.py-76d2ec-diff)

In `src/babykev/smoke.py`, the new imports are on lines 13, 17, 19 and 20, and `answer` is on lines 31 to 41.

`answer` calls four functions of `api.py` and `model.py`, and no test runs it yet. ty reads each call, and compares it
with the types that those functions declare.

```bash
just types
```

`just types` prints `All checks passed!`. Each call gives each function the type of value that it asks for.

#### What changed

- <a id="tut-18.2-src-babykev-smoke.py-76d2ec"></a>`src/babykev/smoke.py`: one request, from the contract to the answers. 19 lines added. [The file](https://github.com/rahuldave/babykev/blob/0de1e2d0a2362ebd41d21b9146eae2961fb2366e/src/babykev/smoke.py).
  - look at `def answer(`

<a id="tut-18.2-src-babykev-smoke.py-76d2ec-diff"></a>

<details><summary>The diff of <code>src/babykev/smoke.py</code></summary>

```diff
@@ -8,9 +8,15 @@ answers.
 """
 
 import json
+import time
 from pathlib import Path
 from typing import Any
 
+from transformers import PreTrainedTokenizerBase
+
+from babykev.api import SystemOneRequest, to_answers, to_record
+from babykev.model import DecisionModel, encode
+
 SAMPLE = Path("data/cheese/sample.jsonl")
 
 
@@ -20,3 +26,16 @@ def read_lines(
     """Read labelled requests from a JSONL file."""
     with path.open(encoding="utf-8") as f:
         return [json.loads(line) for line in f if line.strip()]
+
+
+def answer(
+    model: DecisionModel,  # The model that answers
+    tok: PreTrainedTokenizerBase,  # Its tokenizer
+    line: dict[str, Any],  # One labelled request
+) -> tuple[dict[str, Any], int, float]:  # The answers, the tokens packed, the seconds taken
+    """Answer one request: the contract, then packing, then one forward pass, then answers."""
+    record, meta = to_record(SystemOneRequest.model_validate(line))
+    enc = encode(tok, record)
+    started = time.perf_counter()
+    probs = [p.tolist() for p in model.probs(enc)]
+    return to_answers(probs, meta), len(enc["ids"]), time.perf_counter() - started
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0de1e2d0a2362ebd41d21b9146eae2961fb2366e). [The code after it](https://github.com/rahuldave/babykev/tree/0de1e2d0a2362ebd41d21b9146eae2961fb2366e).

<a id="tut-18.3"></a>

### 18.3 verdict

A label is the right answer to a question. `verdict` puts the answer of the model beside its label, for each of the
three types of question. A noul says yes from a probability of 0.5. A choice names its option. A score is judged by
its most likely level.

[± See the change to `src/babykev/smoke.py`](#tut-18.3-src-babykev-smoke.py-76d2ec-diff)

In `src/babykev/smoke.py`, `verdict` is on lines 44 to 61.

```bash
uv run python -c "from babykev.smoke import verdict; print(verdict({'type': 'noul', 'label': True}, {'type': 'noul', 'noul': 0.78}))"
```

It prints `('yes (0.78)', 'yes', True)`. The three values are what the model said, what the label says, and whether
they agree. `smoke.py` imports `model.py`, so torch prints its note too.

#### What changed

- <a id="tut-18.3-src-babykev-smoke.py-76d2ec"></a>`src/babykev/smoke.py`: one answer beside its label. 20 lines added. [The file](https://github.com/rahuldave/babykev/blob/bd333d90c32a516a97a443fa986f40932f691bad/src/babykev/smoke.py).
  - look at `def verdict(`

<a id="tut-18.3-src-babykev-smoke.py-76d2ec-diff"></a>

<details><summary>The diff of <code>src/babykev/smoke.py</code></summary>

```diff
@@ -39,3 +39,23 @@ def answer(
     started = time.perf_counter()
     probs = [p.tolist() for p in model.probs(enc)]
     return to_answers(probs, meta), len(enc["ids"]), time.perf_counter() - started
+
+
+def verdict(
+    question: dict[str, Any],  # One question of a labelled request, with its `label`
+    given: dict[str, Any],  # The model's answer to it
+) -> tuple[str, str, bool]:  # What the model said, what the label says, and whether they agree
+    """Put one answer beside its label."""
+    label = question["label"]
+    if given["type"] == "noul":
+        said = given["noul"] >= 0.5
+        return (
+            f"{'yes' if said else 'no'} ({given['noul']:.2f})",
+            "yes" if label else "no",
+            said == label,
+        )
+    if given["type"] == "choice":
+        chosen = given["choice"]
+        return f"{chosen} ({given['probabilities'][chosen]:.2f})", str(label), chosen == label
+    level = max(given["probabilities"], key=lambda i: given["probabilities"][i])
+    return f"level {level} (score {given['score']:.2f})", f"level {label}", int(level) == label
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/bd333d90c32a516a97a443fa986f40932f691bad). [The code after it](https://github.com/rahuldave/babykev/tree/bd333d90c32a516a97a443fa986f40932f691bad).

<a id="tut-18.4"></a>

### 18.4 smoke

`smoke` asks the model every question of the sample, and yields the report a line at a time. The first pass on a
device is slow, so it runs once before the timing starts. Each request gets a line with its state, its tokens and its
time. Each question gets a line with `ok` or `--`. The last lines give the count of right answers.

[± See the change to `src/babykev/smoke.py`](#tut-18.4-src-babykev-smoke.py-76d2ec-diff)

In `src/babykev/smoke.py`, `Iterator` is on line 14 and `render` on line 20. `smoke` is on lines 65 to 85.

```bash
just types
```

`just types` prints `All checks passed!`. `smoke` declares that it returns an `Iterator[str]`, and each `yield` gives
a string.

#### What changed

- <a id="tut-18.4-src-babykev-smoke.py-76d2ec"></a>`src/babykev/smoke.py`: the report, a line at a time. 25 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/8490a58a1510d717ce32b48fa0def8498ceb51f9/src/babykev/smoke.py).
  - look at `def smoke(`

<a id="tut-18.4-src-babykev-smoke.py-76d2ec-diff"></a>

<details><summary>The diff of <code>src/babykev/smoke.py</code></summary>

```diff
@@ -9,12 +9,13 @@ answers.
 
 import json
 import time
+from collections.abc import Iterator
 from pathlib import Path
 from typing import Any
 
 from transformers import PreTrainedTokenizerBase
 
-from babykev.api import SystemOneRequest, to_answers, to_record
+from babykev.api import SystemOneRequest, render, to_answers, to_record
 from babykev.model import DecisionModel, encode
 
 SAMPLE = Path("data/cheese/sample.jsonl")
@@ -59,3 +60,26 @@ def verdict(
         return f"{chosen} ({given['probabilities'][chosen]:.2f})", str(label), chosen == label
     level = max(given["probabilities"], key=lambda i: given["probabilities"][i])
     return f"level {level} (score {given['score']:.2f})", f"level {label}", int(level) == label
+
+
+def smoke(
+    model: DecisionModel,  # The model to try
+    tok: PreTrainedTokenizerBase,  # Its tokenizer
+    lines: list[dict[str, Any]],  # Labelled requests to ask it
+) -> Iterator[str]:  # The report, a line at a time
+    """Ask the model every question in `lines` and report each answer beside its label."""
+    answer(model, tok, lines[0])  # the first pass on a device is slow, so it is not timed
+    right, total, seconds = 0, 0, []
+    for line in lines:
+        answers, tokens, took = answer(model, tok, line)
+        seconds.append(took)
+        state = render(line["state"]).splitlines()[0]
+        yield f"\n{state[:70]}   [{tokens} tokens, {took * 1000:.0f} ms]"
+        for qid, question in line["questions"].items():
+            said, label, agree = verdict(question, answers[qid])
+            right, total = right + agree, total + 1
+            mark = "ok" if agree else "--"
+            yield f"  {mark}  {qid:12s} {question['type']:7s} says {said:28s} label: {label}"
+    typical = sorted(seconds)[len(seconds) // 2] * 1000
+    yield f"\n{right} of {total} right, {typical:.0f} ms a request."
+    yield "Nothing is trained yet: these are guesses."
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/8490a58a1510d717ce32b48fa0def8498ceb51f9). [The code after it](https://github.com/rahuldave/babykev/tree/8490a58a1510d717ce32b48fa0def8498ceb51f9).

<a id="tut-18.5"></a>

### 18.5 main loads the real model and runs the smoke

`main` loads the tokenizer and the base model, Qwen2.5-0.5B, from the Hugging Face Hub. It adds an adapter of rank
16, `LORA_RANK`, and the head, which has never been trained. `torch.manual_seed(0)` makes the random weights of the head
the same at every run. `main` counts the parameters, and prints the report of `smoke`. It takes the words after
`babykev smoke`, and answers `help` with the usage.

[± See the change to `src/babykev/smoke.py`](#tut-18.5-src-babykev-smoke.py-76d2ec-diff)

In `src/babykev/smoke.py`, `BASE`, `LORA_RANK` and `USAGE` are on lines 24 to 28, and `main` is on lines 95 to 119.

```bash
uv run python -c "import sys; from babykev.smoke import main; sys.exit(main([]))"
```

The first time on a machine, transformers downloads the base model into `~/.cache/huggingface`, about 1 GB. On this
Mac, the run takes about 10 seconds. It prints `babykev smoke: Qwen/Qwen2.5-0.5B on mps`, where `mps` is the GPU of
Apple. Then it prints the seconds of the load, and `503M parameters, 9.3M of them trainable`.

The report has a line for each of the five requests, with its tokens, 162, 145, 158, 115 and 156, and its time. Under
each are its three questions. The last lines are `6 of 15 right`, with the milliseconds of a typical request, and
`Nothing is trained yet: these are guesses.`. torch prints its
note too.

Some numbers are fixed, and some can vary. The parameters, the tokens and the answers come from the same weights at
every run, because of the seed. On this Mac, a run on the CPU said `6 of 15 right` too. The seconds to load and the
milliseconds of each request change from run to run. On another device, a probability can differ in its last digits.

```bash
just test
```

`just test` prints `53 passed`. `smoke.py` has 71 statements at 0%, and the total is 32%, 83 of 263.

#### What changed

- <a id="tut-18.5-src-babykev-smoke.py-76d2ec"></a>`src/babykev/smoke.py`: the real model, loaded, and the report printed. 35 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/f1bfe993389643bda7f40c6f3b511827a3c9a9a0/src/babykev/smoke.py).
  - look at `def main(`

<a id="tut-18.5-src-babykev-smoke.py-76d2ec-diff"></a>

<details><summary>The diff of <code>src/babykev/smoke.py</code></summary>

```diff
@@ -8,17 +8,24 @@ answers.
 """
 
 import json
+import sys
 import time
 from collections.abc import Iterator
 from pathlib import Path
 from typing import Any
 
+import torch
 from transformers import PreTrainedTokenizerBase
 
 from babykev.api import SystemOneRequest, render, to_answers, to_record
-from babykev.model import DecisionModel, encode
+from babykev.model import DecisionModel, encode, load_tokenizer, pick_device
 
 SAMPLE = Path("data/cheese/sample.jsonl")
+BASE = "Qwen/Qwen2.5-0.5B"
+LORA_RANK = 16
+USAGE = """\
+usage: babykev smoke    load the base model on this machine; answer the sample requests, untrained
+"""
 
 
 def read_lines(
@@ -83,3 +90,30 @@ def smoke(
     typical = sorted(seconds)[len(seconds) // 2] * 1000
     yield f"\n{right} of {total} right, {typical:.0f} ms a request."
     yield "Nothing is trained yet: these are guesses."
+
+
+def main(
+    words: list[str],  # The words after `babykev smoke`: none to run, `help` for the usage
+) -> int:  # The exit code: 0, or 2 for words that are no command
+    """Load the real model on the best device there is and run the smoke on the sample data."""
+    if words in (["help"], ["--help"], ["-h"]):
+        print(USAGE, end="")
+        return 0
+    if words:
+        print(USAGE, end="", file=sys.stderr)
+        return 2
+    device = pick_device()
+    where = torch.cuda.get_device_name(0) if device == "cuda" else device
+    print(f"babykev smoke: {BASE} on {where}", flush=True)
+    started = time.perf_counter()
+    torch.manual_seed(0)
+    tok = load_tokenizer(BASE)
+    model = DecisionModel(BASE, device, lora=LORA_RANK).eval()
+    everything = sum(p.numel() for p in model.parameters())
+    trainable = sum(p.numel() for p in model.trainable_parameters())
+    loaded = time.perf_counter() - started
+    sizes = f"{everything / 1e6:.0f}M parameters, {trainable / 1e6:.1f}M of them trainable"
+    print(f"loaded in {loaded:.1f} s: {sizes}", flush=True)
+    for text in smoke(model, tok, read_lines()):
+        print(text, flush=True)
+    return 0
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f1bfe993389643bda7f40c6f3b511827a3c9a9a0). [The code after it](https://github.com/rahuldave/babykev/tree/f1bfe993389643bda7f40c6f3b511827a3c9a9a0).

<a id="tut-18.6"></a>

### 18.6 The command babykev smoke

`cli.py` refuses every word but `help`. It now runs `smoke.main` for the word `smoke`, with the words after it. The
help lists the command. `smoke.py` imports torch, which takes about two seconds. So `cli.py` imports `smoke` inside the
branch of the command, and `babykev help` stays fast.

[± See the change to `src/babykev/cli.py`](#tut-18.6-src-babykev-cli.py-a9e184-diff)

In `src/babykev/cli.py`, the commands of `HELP` are on lines 11 and 12, and the branch of `smoke` is on lines 22 to
25.

```bash
uv run babykev help
uv run babykev smoke help
```

`babykev help` prints the help, with `smoke` under `commands:`. `babykev smoke help` prints the usage,
`usage: babykev smoke    load the base model on this machine; answer the sample requests, untrained`, and the note of
torch.

The test of the help compares what the command prints with `HELP` itself, so it holds after the change.

```bash
sed -n '17,25p' tests/unit/test_cli.py
just test -k help_is_printed
```

The test runs `babykev` with each of four words, and checks that it prints `HELP`. `just test -k help_is_printed`
prints `4 passed, 49 deselected`. Its table of coverage counts only the four tests that ran, so the total is 13%.

#### What changed

- <a id="tut-18.6-src-babykev-cli.py-a9e184"></a>`src/babykev/cli.py`: the command `smoke`, in the help and in `main`. 12 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/117a59e9838e0fa2e28ad29d02d5aeba3a8622f9/src/babykev/cli.py).
  - look at `        raise SystemExit(smoke.main(words[1:]))`

<a id="tut-18.6-src-babykev-cli.py-a9e184-diff"></a>

<details><summary>The diff of <code>src/babykev/cli.py</code></summary>

```diff
@@ -8,14 +8,20 @@ babykev: a small decision model. Context, typed questions, and a probability for
 usage: babykev COMMAND [FLAGS]
        babykev help
 
-There are no commands yet.
+commands:
+  smoke   load the base model on this machine and answer the five sample requests, untrained
 """
 
 
 def main() -> None:
-    """Print the help, or refuse a command that does not exist yet."""
+    """Run the command named by the first word, print the help, or refuse any other word."""
     words = sys.argv[1:]
-    if words and words[0] not in ("help", "--help", "-h"):
-        print(f"babykev: no command named {words[0]!r}. Run `babykev help`.", file=sys.stderr)
-        raise SystemExit(2)
-    print(HELP, end="")
+    if not words or words[0] in ("help", "--help", "-h"):
+        print(HELP, end="")
+        return
+    if words[0] == "smoke":
+        from babykev import smoke  # imports torch, so only when it is asked for
+
+        raise SystemExit(smoke.main(words[1:]))
+    print(f"babykev: no command named {words[0]!r}. Run `babykev help`.", file=sys.stderr)
+    raise SystemExit(2)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/117a59e9838e0fa2e28ad29d02d5aeba3a8622f9). [The code after it](https://github.com/rahuldave/babykev/tree/117a59e9838e0fa2e28ad29d02d5aeba3a8622f9).

<a id="tut-18.7"></a>

### 18.7 The recipe smoke

The recipe `smoke` runs the command. It answers `help` as every recipe does, and gives any other word to `babykev
smoke`. It is in a group of its own, `model`.

[± See the change to `justfile`](#tut-18.7-justfile-424f0b-diff)

In the `justfile`, the recipe `smoke` is on lines 95 to 101. Line 101 runs `uv run {{ program }} smoke "$@"`.

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

#### What changed

- <a id="tut-18.7-justfile-424f0b"></a>`justfile`: the recipe `smoke`. 8 lines added. [The file](https://github.com/rahuldave/babykev/blob/55844b2320b632b40dd3f34f0a6b5bb962551005/justfile).
  - look at `smoke *args:`

<a id="tut-18.7-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/55844b2320b632b40dd3f34f0a6b5bb962551005). [The code after it](https://github.com/rahuldave/babykev/tree/55844b2320b632b40dd3f34f0a6b5bb962551005).

<a id="tut-18.8"></a>

### 18.8 The front page names the smoke

The front page of the docs lists the modules of the code. `babykev.smoke` is the fourth.

[± See the change to `docs/index.qmd`](#tut-18.8-docs-index.qmd-d6d880-diff)

In `docs/index.qmd`, line 15 says `four modules`, and the item of `babykev.smoke` is on lines 22 and 23.

```bash
just docs
grep -o 'href="api/smoke.html#[^"]*"' docs/_site/index.html
```

`just docs` prints `wrote 5 page(s) to docs/_site`, and the note of torch. The fifth page is the reference of
`smoke.py`. `grep -o` prints the link of `smoke()` into it, `#smoke`.

#### What changed

- <a id="tut-18.8-docs-index.qmd-d6d880"></a>`docs/index.qmd`: the module `babykev.smoke`, in the list. 3 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/aedd5e6659581b7aa6f424e06ccfa12f6a07fff1/docs/index.qmd).
  - look at ``- `babykev.smoke` is the smoke run. `smoke()` asks the model every question of the sample data, and``

<a id="tut-18.8-docs-index.qmd-d6d880-diff"></a>

<details><summary>The diff of <code>docs/index.qmd</code></summary>

```diff
@@ -12,13 +12,15 @@ question has one of three types:
 - a `Choice` asks for one of several named options
 - a `Score` asks for a level on an ordered scale
 
-The code is in three modules:
+The code is in four modules:
 
 - `babykev.api` is the contract. `to_record` turns a request into the text and the options that the model
   reads. `to_answers` turns the probabilities of the model into an answer of the type of each question.
 - `babykev.cli` is the command `babykev`.
 - `babykev.model` is the model. `encode()` packs a record into one sequence of tokens, and a
   `DecisionModel` scores every option of every question in one pass.
+- `babykev.smoke` is the smoke run. `smoke()` asks the model every question of the sample data, and
+  reports each answer beside its label.
 
 Each build of the site makes the pages under Reference from the code. A page takes these parts from each
 function and each class:
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/aedd5e6659581b7aa6f424e06ccfa12f6a07fff1). [The code after it](https://github.com/rahuldave/babykev/tree/aedd5e6659581b7aa6f424e06ccfa12f6a07fff1).

<a id="tut-18.9"></a>

### 18.9 The README names the smoke

The README says what `just smoke` does, and what it downloads. The table gets a row for `smoke.py`.

[± See the change to `README.md`](#tut-18.9-README.md-8ec9a0-diff)

In `README.md`, the paragraph about `just smoke` is on lines 65 to 67, and the row of `smoke.py` is on line 81.

```bash
just check
```

`just check` passes. The tests print `53 passed`, and the total of 32%. `cli.py` is at 83%, because no test runs
lines 23 to 25, the branch of `smoke`. `just docs check` prints `65 of 65`. The coverage has no floor yet, and the
tests of the model come next.

#### What changed

- <a id="tut-18.9-README.md-8ec9a0"></a>`README.md`: `just smoke`, and the row of `smoke.py`. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/3edcb80f6814f9e0afe70942db6fce959799d9c5/README.md).
  - look at ``| `src/babykev/smoke.py` | The smoke run, which asks the real model the sample requests on this machine |``

<a id="tut-18.9-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -62,6 +62,10 @@ The model needs four packages, torch, transformers, peft and safetensors. torch
 from the index of PyTorch that `pyproject.toml` names. On a Mac, the same build runs on the GPU of Apple
 too. With them, `.venv` takes about 750 MB, and torch is most of it.
 
+`just smoke` runs the model on this machine, on the best device that it finds. The first time, it
+downloads the base model from the Hugging Face Hub, about 1 GB. It answers the five sample requests,
+untrained, and prints each answer beside its label.
+
 Run `just hook` once in each clone. It installs a git hook, which runs `just check` before each commit.
 `just check` runs every check of the project, and if one fails, git makes no commit. You can run `just check`
 yourself at any time.
@@ -74,6 +78,7 @@ yourself at any time.
 | `src/babykev/api.py` | The contract: the request and its three types of question as pydantic models, the text and options the model reads, and the answers made from its probabilities |
 | `src/babykev/cli.py` | The command `babykev` |
 | `src/babykev/model.py` | The model, a language model with a head that points at the options |
+| `src/babykev/smoke.py` | The smoke run, which asks the real model the sample requests on this machine |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
 | `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |
 | `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/3edcb80f6814f9e0afe70942db6fce959799d9c5).

This part ends at the code at `tut-18`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-18)

<a id="tut-19"></a>

## 19 Fixtures and the tiny model

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-18`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-18)

```bash
just setup
```

`just setup` prints `Resolved 67 packages`.

The tests of the model need a model. The real one is a download of about 1 GB, and a pass takes about 200 ms on a
GPU. A test of the model checks something exact, such as which token is where, how many probabilities there are, or
which weights get a gradient. That holds for any weights, trained or random. So the tests get a tiny model, built in memory with random
weights. A fixture of pytest gives it to each test that asks for it.

<a id="tut-19.1"></a>

### 19.1 tests/tiny.py, with the tiny tokenizer

The tiny tokenizer has one token for each printable character, and the five delimiters as special tokens. Like the
tokenizer of the base model, it turns the text of a delimiter into the delimiter. `tests/tiny.py` is a helper of the
tests, and not a test, so pytest does not collect it.

[± See the new file `tests/tiny.py`](#tut-19.1-tests-tiny.py-70c1c9-diff)

The new file `tests/tiny.py` has 23 lines, and `tiny_tokenizer` on lines 11 to 23.

```bash
uv run python -c "from tests.tiny import tiny_tokenizer; t = tiny_tokenizer(); print(len(t), t.tokenize('Roquefort'))"
```

It prints `106` and nine tokens, one for each letter of `Roquefort`, and the note of torch. The 106 tokens are the 100
printable characters, the five delimiters and `[UNK]`, the token for any other character. `python -c` runs from the
root of the project, so Python finds the folder `tests`.

```bash
just lint
```

`just lint` finds 2 errors, and ends with exit code 1. Both are `S106`, `Possible hardcoded password assigned to
argument: "unk_token"`, on lines 19 and 21.

```bash
uv run ruff rule S106
```

`ruff rule` says what a rule checks. `S106` looks for a string written in the code, given to a parameter whose name
sounds like a secret, such as `password` or `token`. The name `unk_token` has `token` in it. `"[UNK]"` is the text of a
token, and no secret. The next move answers it.

#### What changed

- <a id="tut-19.1-tests-tiny.py-70c1c9"></a>`tests/tiny.py`: the tiny tokenizer. New, 23 lines. [The file](https://github.com/rahuldave/babykev/blob/b57593b2f1c324a6349f0f5b58a75754f7f261dc/tests/tiny.py).
  - look at `def tiny_tokenizer() -> PreTrainedTokenizerFast:  # A tokenizer with one token per character`

<a id="tut-19.1-tests-tiny.py-70c1c9-diff"></a>

<details><summary>The diff of <code>tests/tiny.py</code></summary>

```diff
@@ -0,0 +1,23 @@
+"""Stand-ins for the parts of the real model, built in memory, with no download."""
+
+import string
+
+from tokenizers import Tokenizer, models, pre_tokenizers
+from transformers import PreTrainedTokenizerFast
+
+from babykev.model import SPECIAL
+
+
+def tiny_tokenizer() -> PreTrainedTokenizerFast:  # A tokenizer with one token per character
+    """Build a real fast tokenizer in memory, with the five delimiters as its special tokens.
+
+    Like the base model's tokenizer, it turns the text of a special token into that token wherever
+    it appears, which is the behaviour `user_tokens` has to defend against.
+    """
+    chars = sorted(set(string.printable))
+    vocab = {"[UNK]": 0, **{c: i + 1 for i, c in enumerate(chars)}}
+    core = Tokenizer(models.WordLevel(vocab, unk_token="[UNK]"))
+    core.pre_tokenizer = pre_tokenizers.Split("", "isolated")
+    tok = PreTrainedTokenizerFast(tokenizer_object=core, unk_token="[UNK]")
+    tok.add_special_tokens({"additional_special_tokens": SPECIAL})
+    return tok
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b57593b2f1c324a6349f0f5b58a75754f7f261dc). [The code after it](https://github.com/rahuldave/babykev/tree/b57593b2f1c324a6349f0f5b58a75754f7f261dc).

<a id="tut-19.2"></a>

### 19.2 The tests may pass a literal to unk_token

`S106` reads the name of a parameter, and not what the value is. The tests already may use `assert`, by a line of
`[tool.ruff.lint.per-file-ignores]`. The same line lets them break `S106`. The package still may not.

[± See the change to `pyproject.toml`](#tut-19.2-pyproject.toml-5d07e7-diff)

In `pyproject.toml`, the comment is on lines 89 and 90, and line 91 is `"tests/**" = ["S101", "S106"]`.

```bash
just lint
```

`just lint` prints `All checks passed!`.

#### What changed

- <a id="tut-19.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: the tests may break `S106`. 3 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/2daaf5f257514e391edb5ad5183c2d2288965de3/pyproject.toml).
  - look at `"tests/**" = ["S101", "S106"]`

<a id="tut-19.2-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -86,5 +86,6 @@ select = [
 ]
 
 [tool.ruff.lint.per-file-ignores]
-# A test is written with assert
-"tests/**" = ["S101"]
+# A test is written with assert, and may pass a literal to a parameter whose name sounds like a
+# secret, such as unk_token
+"tests/**" = ["S101", "S106"]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/2daaf5f257514e391edb5ad5183c2d2288965de3). [The code after it](https://github.com/rahuldave/babykev/tree/2daaf5f257514e391edb5ad5183c2d2288965de3).

<a id="tut-19.3"></a>

### 19.3 The tiny backbone

The backbone is the language model under the head. `tiny_backbone` builds the code of Qwen, `Qwen2Model`, with two
layers of 32 numbers, where the real one has 24 layers of 896. Its weights are random, from a seed, so they are the
same at every run.

[± See the change to `tests/tiny.py`](#tut-19.3-tests-tiny.py-70c1c9-diff)

In `tests/tiny.py`, `tiny_backbone` is on lines 27 to 42.

```bash
uv run python -c "from tests.tiny import tiny_backbone; print(sum(p.numel() for p in tiny_backbone(106).parameters()))"
```

It prints `24224`, the parameters of the tiny backbone. The backbone of Qwen2.5-0.5B has 494,032,768.

#### What changed

- <a id="tut-19.3-tests-tiny.py-70c1c9"></a>`tests/tiny.py`: the tiny backbone. 20 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/a6e3905ee0316fdd0b2e0d3baab9f4a65d0588b5/tests/tiny.py).
  - look at `def tiny_backbone(`

<a id="tut-19.3-tests-tiny.py-70c1c9-diff"></a>

<details><summary>The diff of <code>tests/tiny.py</code></summary>

```diff
@@ -2,8 +2,9 @@
 
 import string
 
+import torch
 from tokenizers import Tokenizer, models, pre_tokenizers
-from transformers import PreTrainedTokenizerFast
+from transformers import PreTrainedTokenizerFast, Qwen2Config, Qwen2Model
 
 from babykev.model import SPECIAL
 
@@ -21,3 +22,21 @@ def tiny_tokenizer() -> PreTrainedTokenizerFast:  # A tokenizer with one token p
     tok = PreTrainedTokenizerFast(tokenizer_object=core, unk_token="[UNK]")
     tok.add_special_tokens({"additional_special_tokens": SPECIAL})
     return tok
+
+
+def tiny_backbone(
+    vocab_size: int,  # How many tokens the tokenizer has
+    seed: int = 0,  # The seed of the random weights
+) -> Qwen2Model:  # A backbone of the base model's architecture, with two small layers
+    """Build a randomly initialised backbone, the same every time for the same seed."""
+    torch.manual_seed(seed)
+    config = Qwen2Config(
+        vocab_size=vocab_size,
+        hidden_size=32,
+        intermediate_size=64,
+        num_hidden_layers=2,
+        num_attention_heads=2,
+        num_key_value_heads=2,
+        max_position_embeddings=2048,
+    )
+    return Qwen2Model(config)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/a6e3905ee0316fdd0b2e0d3baab9f4a65d0588b5). [The code after it](https://github.com/rahuldave/babykev/tree/a6e3905ee0316fdd0b2e0d3baab9f4a65d0588b5).

<a id="tut-19.4"></a>

### 19.4 conftest.py, with the fixture tok

A fixture is a function marked `@pytest.fixture`. A test names it as a parameter, and pytest calls the fixture and
passes in what it returns. `monkeypatch` and `capsys` are fixtures of pytest. pytest reads `tests/conftest.py` before
any test, and every test file can use the fixtures in it, with no import. The first fixture, `tok`, is the tiny
tokenizer. `scope="session"` builds it once for the whole run.

[± See the new file `tests/conftest.py`](#tut-19.4-tests-conftest.py-626af3-diff)

The new file `tests/conftest.py` imports `tiny_tokenizer` from `tests.tiny` on line 10, and has the fixture `tok` on
lines 13 to 16.

```bash
just test
```

`just test` fails before any test runs, with exit code 4. It prints `ImportError while loading conftest`, and
`ModuleNotFoundError: No module named 'tests'`. pytest puts the folder of `conftest.py`, `tests`, on the path of
Python, and not the root of the project. So `tests.tiny` cannot be found. The next move answers it.

#### What changed

- <a id="tut-19.4-tests-conftest.py-626af3"></a>`tests/conftest.py`: the fixture `tok`. New, 16 lines. [The file](https://github.com/rahuldave/babykev/blob/14585bbd144a55ac28ff0473f3d3f2c23c03d314/tests/conftest.py).
  - look at `@pytest.fixture(scope="session")`

<a id="tut-19.4-tests-conftest.py-626af3-diff"></a>

<details><summary>The diff of <code>tests/conftest.py</code></summary>

```diff
@@ -0,0 +1,16 @@
+"""The fixtures that every test file can ask for.
+
+What the tests of the model check is exact, and holds for any weights. So the fixtures need no
+trained model, no download and no GPU.
+"""
+
+import pytest
+from transformers import PreTrainedTokenizerFast
+
+from tests.tiny import tiny_tokenizer
+
+
+@pytest.fixture(scope="session")
+def tok() -> PreTrainedTokenizerFast:  # The tiny tokenizer, built once for the whole test run
+    """Provide the tiny tokenizer."""
+    return tiny_tokenizer()
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/14585bbd144a55ac28ff0473f3d3f2c23c03d314). [The code after it](https://github.com/rahuldave/babykev/tree/14585bbd144a55ac28ff0473f3d3f2c23c03d314).

<a id="tut-19.5"></a>

### 19.5 pytest can import tests.tiny

The setting `pythonpath` of pytest puts folders on the path of Python. `"."` is the root of the project, where the
folder `tests` is.

[± See the change to `pyproject.toml`](#tut-19.5-pyproject.toml-5d07e7-diff)

In `pyproject.toml`, the comment is on line 57, and line 58 is `pythonpath = ["."]`.

```bash
just test
```

`just test` prints `53 passed`. `model.py` goes from 0% to 33%, and the total from 32% to 45%, 121 of 267. No test
calls the model. `tests/tiny.py` imports `SPECIAL` from `babykev.model`, so Python runs the module. Its imports, its
names and the line of each `def` and `class` count as covered, 36 of its 109 statements.

```bash
just test --fixtures
```

`just test --fixtures` lists every fixture that pytest can see. Those of pytest come first, and the last section is
`fixtures defined from conftest`. It has `tok [session scope] -- tests/conftest.py:14`, with its docstring.

#### What changed

- <a id="tut-19.5-pyproject.toml-5d07e7"></a>`pyproject.toml`: the root of the project, on the path of pytest. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/b458ae1df2239c8645f7a4eb35832fd2dddc1114/pyproject.toml).
  - look at `pythonpath = ["."]`

<a id="tut-19.5-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -54,6 +54,8 @@ test = [
 
 [tool.pytest.ini_options]
 testpaths = ["tests"]
+# A test can import its helpers from the folder tests, for example tests.tiny
+pythonpath = ["."]
 # Every run measures how much of src/babykev the tests run, and lists the lines they do not
 addopts = "--cov=babykev --cov-report=term-missing"
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b458ae1df2239c8645f7a4eb35832fd2dddc1114). [The code after it](https://github.com/rahuldave/babykev/tree/b458ae1df2239c8645f7a4eb35832fd2dddc1114).

<a id="tut-19.6"></a>

### 19.6 The fixture model

The fixture `model` is a `DecisionModel` on the tiny backbone, on the CPU, with no adapter. It asks for `tok`, because
the backbone needs to know the number of tokens. A fixture can ask for another fixture. `model` has the default scope,
so pytest builds it again for each test, and no test can spoil it for the next.

[± See the change to `tests/conftest.py`](#tut-19.6-tests-conftest.py-626af3-diff)

In `tests/conftest.py`, the fixture `model` is on lines 20 to 25.

```bash
just test --fixtures
```

The last section lists `tok` and `model -- tests/conftest.py:21`. `tok` is now on line 15, one line lower, under the
new import.

#### What changed

- <a id="tut-19.6-tests-conftest.py-626af3"></a>`tests/conftest.py`: the fixture `model`. 10 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/0806a218722ba7438f265928d3cfbc0b5f0e723e/tests/conftest.py).
  - look at `    return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()`

<a id="tut-19.6-tests-conftest.py-626af3-diff"></a>

<details><summary>The diff of <code>tests/conftest.py</code></summary>

```diff
@@ -7,10 +7,19 @@ trained model, no download and no GPU.
 import pytest
 from transformers import PreTrainedTokenizerFast
 
-from tests.tiny import tiny_tokenizer
+from babykev.model import DecisionModel
+from tests.tiny import tiny_backbone, tiny_tokenizer
 
 
 @pytest.fixture(scope="session")
 def tok() -> PreTrainedTokenizerFast:  # The tiny tokenizer, built once for the whole test run
     """Provide the tiny tokenizer."""
     return tiny_tokenizer()
+
+
+@pytest.fixture
+def model(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+) -> DecisionModel:  # A decision model on the tiny backbone, with no adapter, ready to answer
+    """Provide a fresh tiny model for each test, on the CPU."""
+    return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0806a218722ba7438f265928d3cfbc0b5f0e723e). [The code after it](https://github.com/rahuldave/babykev/tree/0806a218722ba7438f265928d3cfbc0b5f0e723e).

<a id="tut-19.7"></a>

### 19.7 The fixture record

The fixture `record` is one record about Roquefort, in the form that `to_record` returns. It has a state, and three
questions of 2, 3 and 3 options.

[± See the change to `tests/conftest.py`](#tut-19.7-tests-conftest.py-626af3-diff)

In `tests/conftest.py`, the fixture `record` is on lines 30 to 40.

```bash
just test --fixtures
```

The last section lists the three fixtures, `tok`, `model` and `record`, each with its line in `conftest.py` and its
docstring.

#### What changed

- <a id="tut-19.7-tests-conftest.py-626af3"></a>`tests/conftest.py`: the fixture `record`. 15 lines added. [The file](https://github.com/rahuldave/babykev/blob/b4bf2491e8505697eaa015738f93178c6bd7f3fc/tests/conftest.py).
  - look at `        "state": "Roquefort. A blue cheese from France, made from sheep's milk.",`

<a id="tut-19.7-tests-conftest.py-626af3-diff"></a>

<details><summary>The diff of <code>tests/conftest.py</code></summary>

```diff
@@ -4,6 +4,8 @@ What the tests of the model check is exact, and holds for any weights. So the fi
 trained model, no download and no GPU.
 """
 
+from typing import Any
+
 import pytest
 from transformers import PreTrainedTokenizerFast
 
@@ -23,3 +25,16 @@ def model(
 ) -> DecisionModel:  # A decision model on the tiny backbone, with no adapter, ready to answer
     """Provide a fresh tiny model for each test, on the CPU."""
     return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()
+
+
+@pytest.fixture
+def record() -> dict[str, Any]:  # A record with a state and three questions
+    """Provide one record, as `to_record` would return it."""
+    return {
+        "state": "Roquefort. A blue cheese from France, made from sheep's milk.",
+        "questions": [
+            {"instr": "Is this a blue cheese?", "options": ["no", "yes"], "label": 1},
+            {"instr": "Which milk?", "options": ["cow", "goat", "sheep"], "label": 2},
+            {"instr": "How firm?", "options": ["Soft", "Semi-soft", "Hard"], "label": 1},
+        ],
+    }
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b4bf2491e8505697eaa015738f93178c6bd7f3fc). [The code after it](https://github.com/rahuldave/babykev/tree/b4bf2491e8505697eaa015738f93178c6bd7f3fc).

<a id="tut-19.8"></a>

### 19.8 The first test of the model

The first test asks for the three fixtures. It packs the record with the tiny tokenizer, and runs the tiny model and
the head. Each question gets one probability per option, and they sum to 1. Nothing is trained, so the probabilities
mean nothing. The test checks what is true of any probabilities.

[± See the new file `tests/unit/test_model.py`](#tut-19.8-tests-unit-test_model.py-583145-diff)

The new file `tests/unit/test_model.py` has one test, on lines 11 to 20.

```bash
sed -n '11,20p' tests/unit/test_model.py
just test -k probabilities_sum
```

The test never says "tiny". It names `model`, `tok` and `record`, and pytest passes them in. The code that runs is our
`DecisionModel`. Only the backbone and the tokenizer under it are small. `[2, 3, 3]` on line 18 is known in advance,
because the record of the fixture has questions of 2, 3 and 3 options. `just test -k probabilities_sum` prints
`1 passed, 53 deselected`.

```bash
just test --fixtures-per-test -k probabilities_sum
```

`--fixtures-per-test` names the fixtures of each test, and where each is defined. The test gets `model`, `record` and
`tok`, each with its line in `conftest.py`.

```bash
just test
```

`just test` prints `54 passed`. `model.py` is at 85%, and the total at 67%, 178 of 267. One test runs the
packing, the mask, the backbone and the head.

In tut-19.5, before this test, `model.py` was at 33%, and the total at 45%.

#### What changed

- <a id="tut-19.8-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the first test of the model, on the tiny model. New, 20 lines. [The file](https://github.com/rahuldave/babykev/blob/321a8df2c597e0c46d06c9b36c711f0fe270900a/tests/unit/test_model.py).
  - look at `def test_probabilities_sum_to_one_for_every_question(`

<a id="tut-19.8-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -0,0 +1,20 @@
+"""Tests of the model, on the tiny model."""
+
+from typing import Any
+
+import pytest
+from transformers import PreTrainedTokenizerFast
+
+from babykev.model import DecisionModel, encode
+
+
+def test_probabilities_sum_to_one_for_every_question(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Each question gets one probability per option, and they sum to 1."""
+    probs = model.probs(encode(tok, record))
+    assert [len(p) for p in probs] == [2, 3, 3]
+    for p in probs:
+        assert p.sum().item() == pytest.approx(1)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/321a8df2c597e0c46d06c9b36c711f0fe270900a). [The code after it](https://github.com/rahuldave/babykev/tree/321a8df2c597e0c46d06c9b36c711f0fe270900a).

<a id="tut-19.9"></a>

### 19.9 The README names the fixtures and the tiny model

The table of the README gets a row for each of the two new files. The row of `tests/unit/` names the tests of the
model.

[± See the change to `README.md`](#tut-19.9-README.md-8ec9a0-diff)

In `README.md`, the row of `tests/unit/` is on line 83, and the two new rows are on lines 84 and 85.

```bash
just check
```

`just check` passes. The tests print `54 passed`, and the total of 67%. `just docs check` prints `71 of 71`, with the
helpers and the fixtures in it.

#### What changed

- <a id="tut-19.9-README.md-8ec9a0"></a>`README.md`: the rows of the fixtures and of the tiny model. 3 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/88b3a9e08db851ce891ecfcfcf26d18892beea90/README.md).
  - look at ``| `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |``

<a id="tut-19.9-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -80,7 +80,9 @@ yourself at any time.
 | `src/babykev/model.py` | The model, a language model with a head that points at the options |
 | `src/babykev/smoke.py` | The smoke run, which asks the real model the sample requests on this machine |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
-| `tests/unit/` | The unit tests of the contract and of the command. One test checks every line of the sample data against the contract |
+| `tests/unit/` | The tests of the contract, of the command and of the model. One test checks every line of the sample data against the contract |
+| `tests/conftest.py` | The fixtures that every test can ask for: the tiny tokenizer, a tiny model and a record |
+| `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |
 | `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `README.md` | This file |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/88b3a9e08db851ce891ecfcfcf26d18892beea90).

This part ends at the code at `tut-19`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-19)

<a id="tut-20"></a>

## 20 Unit tests of the model and the smoke

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-19`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-19)

```bash
just setup
```

`just setup` prints `Resolved 67 packages`.

A unit test runs one function alone. The tests here check the packing, the defence against a forged
delimiter, the head and the device. Then they check the verdicts of the smoke, and the command `smoke`. Each move adds one test. The
coverage does not rise with every test. It counts the lines that a test runs, and not what a test checks.

<a id="tut-20.1"></a>

### 20.1 Packing marks every part with its delimiter

The test packs a small record, the state `ab` and one question `x?` with the options `n` and `y`. With one token per
character, it can write down every token that it expects.

[± See the change to `tests/unit/test_model.py`](#tut-20.1-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 23 to 35.

```bash
sed -n '23,35p' tests/unit/test_model.py
just test -k packing_marks
```

The list on line 31 is the whole sequence. It has the state delimiter and `a`, `b`, then the question delimiter and
`x`, `?`. Each option is between its two delimiters, and the decide delimiter comes last. Line 32 gives the segment of each token, 0 for the state
and 1 for the question. `just test -k packing_marks` prints `1 passed`.

With `-k`, the table of coverage counts only the tests that ran. This test alone runs 54% of `model.py`.

```bash
just test
```

`just test` prints `55 passed`. The total stays at 67%, and `model.py` at 85%, with the same 16 lines missing. The
test of the probabilities ran `encode` already, and checked none of its tokens. The coverage counts the lines that
run, and not what a test checks.

#### What changed

- <a id="tut-20.1-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the tokens of a packed record. 16 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/6d2401817f1bc2d56de4f3021cfceaa80d5b80f9/tests/unit/test_model.py).
  - look at `def test_packing_marks_every_part_with_its_delimiter(`

<a id="tut-20.1-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -5,7 +5,7 @@ from typing import Any
 import pytest
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import DecisionModel, encode
+from babykev.model import DecisionModel, delimiter_ids, encode
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -18,3 +18,18 @@ def test_probabilities_sum_to_one_for_every_question(
     assert [len(p) for p in probs] == [2, 3, 3]
     for p in probs:
         assert p.sum().item() == pytest.approx(1)
+
+
+def test_packing_marks_every_part_with_its_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+) -> None:
+    """A packed record is the state, then each question with its options and its decide token."""
+    s, q, o, c, d = delimiter_ids(tok)
+    record = {"state": "ab", "questions": [{"instr": "x?", "options": ["n", "y"], "label": 1}]}
+    enc = encode(tok, record)
+    a, b, x, mark, n, y = (tok.convert_tokens_to_ids(ch) for ch in "abx?ny")
+    assert enc["ids"] == [s, a, b, q, x, mark, o, n, c, o, y, c, d]
+    assert enc["seg"] == [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
+    assert enc["decide_idx"] == [12]
+    assert enc["opt_idx"] == [[8, 11]]
+    assert enc["labels"] == [1]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/6d2401817f1bc2d56de4f3021cfceaa80d5b80f9). [The code after it](https://github.com/rahuldave/babykev/tree/6d2401817f1bc2d56de4f3021cfceaa80d5b80f9).

<a id="tut-20.2"></a>

### 20.2 Positions restart after the state

The positions of each question begin right after the state, so a question looks the same wherever it comes.

[± See the change to `tests/unit/test_model.py`](#tut-20.2-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 38 to 47.

```bash
just test -k positions_restart
```

pytest prints `1 passed, 55 deselected`.

#### What changed

- <a id="tut-20.2-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the positions of each question. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/e947449de17438d3aa5ee006bfc98db3944d4457/tests/unit/test_model.py).
  - look at `def test_positions_restart_after_the_state(`

<a id="tut-20.2-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -33,3 +33,15 @@ def test_packing_marks_every_part_with_its_delimiter(
     assert enc["decide_idx"] == [12]
     assert enc["opt_idx"] == [[8, 11]]
     assert enc["labels"] == [1]
+
+
+def test_positions_restart_after_the_state(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Every question starts at the position right after the state, wherever it comes."""
+    enc = encode(tok, record)
+    state_length = enc["seg"].count(0)
+    for k in (1, 2, 3):
+        positions = [p for p, s in zip(enc["pos"], enc["seg"], strict=True) if s == k]
+        assert positions == list(range(state_length, state_length + len(positions)))
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e947449de17438d3aa5ee006bfc98db3944d4457). [The code after it](https://github.com/rahuldave/babykev/tree/e947449de17438d3aa5ee006bfc98db3944d4457).

<a id="tut-20.3"></a>

### 20.3 A question that does not fit is refused

`encode` refuses a question that does not fit, and names its length. The record of the fixture has a state of 62
tokens. The test gives a limit of 80 tokens to the state and a question together, and the questions do not fit.

[± See the change to `tests/unit/test_model.py`](#tut-20.3-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 50 to 56.

```bash
just test -k question_that_does_not_fit
```

pytest prints `1 passed`. The column Missing of `model.py` lists `129-135`, and not 128. Line 128, the `raise`, has
run, and it left `encode` before the lines after it.

#### What changed

- <a id="tut-20.3-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: a question longer than the limit. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/ff097836c2f1b752bb4347f8e5ae59aeca648a05/tests/unit/test_model.py).
  - look at `def test_a_question_that_does_not_fit_is_refused(`

<a id="tut-20.3-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -45,3 +45,12 @@ def test_positions_restart_after_the_state(
     for k in (1, 2, 3):
         positions = [p for p, s in zip(enc["pos"], enc["seg"], strict=True) if s == k]
         assert positions == list(range(state_length, state_length + len(positions)))
+
+
+def test_a_question_that_does_not_fit_is_refused(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """A branch longer than the limit raises, and names its length."""
+    with pytest.raises(ValueError, match="branch too long"):
+        encode(tok, record, max_branch=80)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ff097836c2f1b752bb4347f8e5ae59aeca648a05). [The code after it](https://github.com/rahuldave/babykev/tree/ff097836c2f1b752bb4347f8e5ae59aeca648a05).

<a id="tut-20.4"></a>

### 20.4 A state that does not fit is refused

`encode` refuses a state that is longer than its limit, and names its length and the limit. The state of the fixture
is the state delimiter and 61 characters, 62 tokens.

[± See the change to `tests/unit/test_model.py`](#tut-20.4-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 59 to 65.

```bash
just test -k state_that_does_not_fit
```

pytest prints `1 passed`. Line 117, the other `raise` of `encode`, has run. In the column Missing of `model.py`, the
range of `encode` starts at 118 again.

```bash
just test
```

`just test` prints `58 passed`. `model.py` is at 87%, with 14 lines missing. Lines 117 and 128 are no longer among
them.

#### What changed

- <a id="tut-20.4-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: a state longer than the limit. 9 lines added. [The file](https://github.com/rahuldave/babykev/blob/e3b3ab01357c19f3325d481c80e67ad1f13c1522/tests/unit/test_model.py).
  - look at `    with pytest.raises(ValueError, match="state too long: 62 tokens, the limit is 50"):`

<a id="tut-20.4-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -54,3 +54,12 @@ def test_a_question_that_does_not_fit_is_refused(
     """A branch longer than the limit raises, and names its length."""
     with pytest.raises(ValueError, match="branch too long"):
         encode(tok, record, max_branch=80)
+
+
+def test_a_state_that_does_not_fit_is_refused(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """A state longer than the limit raises, and names its length and the limit."""
+    with pytest.raises(ValueError, match="state too long: 62 tokens, the limit is 50"):
+        encode(tok, record, max_state=50)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e3b3ab01357c19f3325d481c80e67ad1f13c1522). [The code after it](https://github.com/rahuldave/babykev/tree/e3b3ab01357c19f3325d481c80e67ad1f13c1522).

<a id="tut-20.5"></a>

### 20.5 A tokenizer alone would let text forge a delimiter

A caller writes the state, the instructions and the options. A tokenizer turns the text `<|fim_suffix|>` into the
decide token, wherever it is. So text could close an option early, or make a question of its own. This test shows the
danger, before the next test shows the defence.

[± See the change to `tests/unit/test_model.py`](#tut-20.5-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 68 to 73.

```bash
sed -n '68,73p' tests/unit/test_model.py
just test -k tokenizer_alone
```

The test tokenizes `yes<|fim_suffix|>` with the tokenizer alone, and finds the id of the decide delimiter among the
tokens. pytest prints `1 passed`. The danger is real.

#### What changed

- <a id="tut-20.5-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the danger, a forged delimiter. 9 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/1782e1e6803efd49be04e682f3453e39c1c2fc23/tests/unit/test_model.py).
  - look at `def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(`

<a id="tut-20.5-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -5,7 +5,7 @@ from typing import Any
 import pytest
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import DecisionModel, delimiter_ids, encode
+from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -63,3 +63,11 @@ def test_a_state_that_does_not_fit_is_refused(
     """A state longer than the limit raises, and names its length and the limit."""
     with pytest.raises(ValueError, match="state too long: 62 tokens, the limit is 50"):
         encode(tok, record, max_state=50)
+
+
+def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+) -> None:
+    """The danger is real: tokenized directly, the text of a delimiter becomes that delimiter."""
+    decide = delimiter_ids(tok)[4]
+    assert decide in tok(f"yes{SPECIAL[4]}", add_special_tokens=False).input_ids
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/1782e1e6803efd49be04e682f3453e39c1c2fc23). [The code after it](https://github.com/rahuldave/babykev/tree/1782e1e6803efd49be04e682f3453e39c1c2fc23).

<a id="tut-20.6"></a>

### 20.6 User text cannot forge a delimiter

`user_tokens` rewrites `<|name|>` to `<¦name¦>` before it tokenizes, so the text of a delimiter is ordinary text. The
test runs once for each of the five delimiters.

[± See the change to `tests/unit/test_model.py`](#tut-20.6-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 76 to 83.

```bash
just test -k forge
```

`-k forge` takes both tests, the danger and the defence. pytest prints `6 passed`, the danger once and the defence
five times.

```bash
just test
```

`just test` prints `64 passed`. `model.py` is at 87%, with 14 lines missing. The test of the
probabilities had run `user_tokens` already, and checked nothing about it.

The 14 lines are the same as at the end of tut-20.4, so the two new tests add no line to the coverage.

#### What changed

- <a id="tut-20.6-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the defence, for each of the five delimiters. 11 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/e30ea2eb52ae23815152f60b09d07d9d0dd1fd3a/tests/unit/test_model.py).
  - look at `def test_user_text_cannot_forge_a_delimiter(`

<a id="tut-20.6-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -5,7 +5,7 @@ from typing import Any
 import pytest
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode
+from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode, user_tokens
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -71,3 +71,13 @@ def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(
     """The danger is real: tokenized directly, the text of a delimiter becomes that delimiter."""
     decide = delimiter_ids(tok)[4]
     assert decide in tok(f"yes{SPECIAL[4]}", add_special_tokens=False).input_ids
+
+
+@pytest.mark.parametrize("delimiter", SPECIAL)
+def test_user_text_cannot_forge_a_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    delimiter: str,  # The text of one of the five delimiters
+) -> None:
+    """Through `user_tokens`, the text of a delimiter is only ever ordinary tokens."""
+    ids = user_tokens(tok, f"before {delimiter} after")
+    assert not set(ids) & set(delimiter_ids(tok))
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e30ea2eb52ae23815152f60b09d07d9d0dd1fd3a). [The code after it](https://github.com/rahuldave/babykev/tree/e30ea2eb52ae23815152f60b09d07d9d0dd1fd3a).

<a id="tut-20.7"></a>

### 20.7 The pointer head gives one logit per option

The head takes the hidden state of a decide token and those of the options, and gives one logit for each option. The
test builds a head alone, with no model, and gives it five options.

[± See the change to `tests/unit/test_model.py`](#tut-20.7-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 87 to 90.

```bash
just test -k pointer_head
```

pytest prints `1 passed`.

#### What changed

- <a id="tut-20.7-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: five options in, five logits out. 8 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/455b6a8ae64dae7e79fea6dd6b8434d11eb8f542/tests/unit/test_model.py).
  - look at `def test_pointer_head_gives_one_logit_per_option() -> None:`

<a id="tut-20.7-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -3,9 +3,10 @@
 from typing import Any
 
 import pytest
+import torch
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import SPECIAL, DecisionModel, delimiter_ids, encode, user_tokens
+from babykev.model import SPECIAL, DecisionModel, PointerHead, delimiter_ids, encode, user_tokens
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -81,3 +82,9 @@ def test_user_text_cannot_forge_a_delimiter(
     """Through `user_tokens`, the text of a delimiter is only ever ordinary tokens."""
     ids = user_tokens(tok, f"before {delimiter} after")
     assert not set(ids) & set(delimiter_ids(tok))
+
+
+def test_pointer_head_gives_one_logit_per_option() -> None:
+    """Five options in, five logits out."""
+    head = PointerHead(d=32, dp=8)
+    assert head(torch.randn(32), torch.randn(5, 32)).shape == (5,)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/455b6a8ae64dae7e79fea6dd6b8434d11eb8f542). [The code after it](https://github.com/rahuldave/babykev/tree/455b6a8ae64dae7e79fea6dd6b8434d11eb8f542).

<a id="tut-20.8"></a>

### 20.8 pick_device takes an override

`pick_device` returns a device that it is given by name, whatever the machine has.

[± See the change to `tests/unit/test_model.py`](#tut-20.8-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the import from `babykev.model` is on lines 9 to 17, and the new test is on lines 101 to
103.

```bash
just test -k takes_an_override
```

pytest prints `1 passed`. The column Missing of `model.py` starts at `62-64`, so lines 60 and 61 have run.

#### What changed

- <a id="tut-20.8-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: a device asked for by name. 14 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/4e6dafdd492c6ca8c6ebe4935f7065e8434064da/tests/unit/test_model.py).
  - look at `def test_pick_device_takes_an_override() -> None:`

<a id="tut-20.8-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -6,7 +6,15 @@ import pytest
 import torch
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import SPECIAL, DecisionModel, PointerHead, delimiter_ids, encode, user_tokens
+from babykev.model import (
+    SPECIAL,
+    DecisionModel,
+    PointerHead,
+    delimiter_ids,
+    encode,
+    pick_device,
+    user_tokens,
+)
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -88,3 +96,8 @@ def test_pointer_head_gives_one_logit_per_option() -> None:
     """Five options in, five logits out."""
     head = PointerHead(d=32, dp=8)
     assert head(torch.randn(32), torch.randn(5, 32)).shape == (5,)
+
+
+def test_pick_device_takes_an_override() -> None:
+    """A device asked for by name is used, whatever the machine has."""
+    assert pick_device("cpu") == "cpu"
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4e6dafdd492c6ca8c6ebe4935f7065e8434064da). [The code after it](https://github.com/rahuldave/babykev/tree/4e6dafdd492c6ca8c6ebe4935f7065e8434064da).

<a id="tut-20.9"></a>

### 20.9 pick_device finds something to run on

With no override, `pick_device` chooses CUDA, then the GPU of Apple, then the CPU.

[± See the change to `tests/unit/test_model.py`](#tut-20.9-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 106 to 108.

```bash
just test
```

`just test` prints `67 passed`. `model.py` is at 91%, and the missing lines are `63, 72-75, 204-207, 211-218, 277`.
Line 63 returns `cuda`, and runs only on a machine with a GPU of NVIDIA. Lines 72 to 75 load the tokenizer from the
Hub, and lines 204 to 207 load the model. Lines 211 to 218 add the adapter, and line 277 lists the parameters that
train. The total is 69%.

#### What changed

- <a id="tut-20.9-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: a device, whatever the machine. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/fe15072f571cb54b810bf22b511cce5cc81920fa/tests/unit/test_model.py).
  - look at `def test_pick_device_finds_something_to_run_on() -> None:`

<a id="tut-20.9-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -101,3 +101,8 @@ def test_pointer_head_gives_one_logit_per_option() -> None:
 def test_pick_device_takes_an_override() -> None:
     """A device asked for by name is used, whatever the machine has."""
     assert pick_device("cpu") == "cpu"
+
+
+def test_pick_device_finds_something_to_run_on() -> None:
+    """With no override, the choice is one of the three kinds of device."""
+    assert pick_device() in {"cuda", "mps", "cpu"}
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/fe15072f571cb54b810bf22b511cce5cc81920fa). [The code after it](https://github.com/rahuldave/babykev/tree/fe15072f571cb54b810bf22b511cce5cc81920fa).

<a id="tut-20.10"></a>

### 20.10 A verdict agrees when the answer is the label

The tests of the smoke go in a file of their own. `verdict` needs no model, so its tests are unit tests.

[± See the new file `tests/unit/test_smoke.py`](#tut-20.10-tests-unit-test_smoke.py-89db04-diff)

The new file `tests/unit/test_smoke.py` has the test on lines 6 to 10.

```bash
sed -n '6,10p' tests/unit/test_smoke.py
just test -k agrees_when
```

The answer is `goat`, with a probability of 0.8, and the label is `goat`. `verdict` gives `("goat (0.80)", "goat",
True)`. pytest prints `1 passed`.

```bash
just test
```

`just test` prints `68 passed`. `smoke.py` goes from 0% to 34%, and the total from 69% to 78%. The test calls only
`verdict`. The import of `smoke.py` runs its imports, its names and the line of each `def`.

#### What changed

- <a id="tut-20.10-tests-unit-test_smoke.py-89db04"></a>`tests/unit/test_smoke.py`: the first test of `verdict`. New, 10 lines. [The file](https://github.com/rahuldave/babykev/blob/46f7e9637f1653265e237ae9676f543af062afc5/tests/unit/test_smoke.py).
  - look at `def test_verdict_agrees_when_the_answer_is_the_label() -> None:`

<a id="tut-20.10-tests-unit-test_smoke.py-89db04-diff"></a>

<details><summary>The diff of <code>tests/unit/test_smoke.py</code></summary>

```diff
@@ -0,0 +1,10 @@
+"""Tests of the smoke run, without the real model."""
+
+from babykev.smoke import verdict
+
+
+def test_verdict_agrees_when_the_answer_is_the_label() -> None:
+    """A verdict says what the model said, what the label says, and whether they agree."""
+    question = {"type": "choice", "criteria": {"cow": None, "goat": None}, "label": "goat"}
+    given = {"type": "choice", "choice": "goat", "probabilities": {"cow": 0.2, "goat": 0.8}}
+    assert verdict(question, given) == ("goat (0.80)", "goat", True)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/46f7e9637f1653265e237ae9676f543af062afc5). [The code after it](https://github.com/rahuldave/babykev/tree/46f7e9637f1653265e237ae9676f543af062afc5).

<a id="tut-20.11"></a>

### 20.11 A verdict reads a noul as yes from one half

A probability of yes of 0.5 or more is a yes. The test gives `verdict` exactly 0.5, the edge.

[± See the change to `tests/unit/test_smoke.py`](#tut-20.11-tests-unit-test_smoke.py-89db04-diff)

In `tests/unit/test_smoke.py`, the new test is on lines 13 to 16.

```bash
just test -k noul_answer_as_yes
```

pytest prints `1 passed`. The label is no, so the verdict is `("yes (0.50)", "no", False)`.

#### What changed

- <a id="tut-20.11-tests-unit-test_smoke.py-89db04"></a>`tests/unit/test_smoke.py`: a noul at the edge. 6 lines added. [The file](https://github.com/rahuldave/babykev/blob/ec3c03dc7b395c22a898f0c25e754daaa9ce1afa/tests/unit/test_smoke.py).
  - look at `def test_verdict_reads_a_noul_answer_as_yes_from_one_half() -> None:`

<a id="tut-20.11-tests-unit-test_smoke.py-89db04-diff"></a>

<details><summary>The diff of <code>tests/unit/test_smoke.py</code></summary>

```diff
@@ -8,3 +8,9 @@ def test_verdict_agrees_when_the_answer_is_the_label() -> None:
     question = {"type": "choice", "criteria": {"cow": None, "goat": None}, "label": "goat"}
     given = {"type": "choice", "choice": "goat", "probabilities": {"cow": 0.2, "goat": 0.8}}
     assert verdict(question, given) == ("goat (0.80)", "goat", True)
+
+
+def test_verdict_reads_a_noul_answer_as_yes_from_one_half() -> None:
+    """A probability of yes at or above 0.5 is a yes."""
+    said, label, agree = verdict({"type": "noul", "label": False}, {"type": "noul", "noul": 0.5})
+    assert (said, label, agree) == ("yes (0.50)", "no", False)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ec3c03dc7b395c22a898f0c25e754daaa9ce1afa). [The code after it](https://github.com/rahuldave/babykev/tree/ec3c03dc7b395c22a898f0c25e754daaa9ce1afa).

<a id="tut-20.12"></a>

### 20.12 A verdict reads a score as its most likely level

A score is judged by the level with the highest probability, and not by the expected level. The expected level is
1.1. The probabilities are 0.2, 0.5 and 0.3, and level 1 is the most likely.

[± See the change to `tests/unit/test_smoke.py`](#tut-20.12-tests-unit-test_smoke.py-89db04-diff)

In `tests/unit/test_smoke.py`, the new test is on lines 19 to 26.

```bash
just test
```

`just test` prints `70 passed`. `verdict` is covered, and the missing lines of `smoke.py` are
`35-36, 45-49, 78-92, 99-119`. They are the body of `read_lines`, of `answer`, of `smoke` and of `main`. The total is
79%.

#### What changed

- <a id="tut-20.12-tests-unit-test_smoke.py-89db04"></a>`tests/unit/test_smoke.py`: a score, by its most likely level. 10 lines added. [The file](https://github.com/rahuldave/babykev/blob/adb57ffc75cd347933a0bebec13312802817faee/tests/unit/test_smoke.py).
  - look at `def test_verdict_reads_a_score_answer_as_its_most_likely_level() -> None:`

<a id="tut-20.12-tests-unit-test_smoke.py-89db04-diff"></a>

<details><summary>The diff of <code>tests/unit/test_smoke.py</code></summary>

```diff
@@ -14,3 +14,13 @@ def test_verdict_reads_a_noul_answer_as_yes_from_one_half() -> None:
     """A probability of yes at or above 0.5 is a yes."""
     said, label, agree = verdict({"type": "noul", "label": False}, {"type": "noul", "noul": 0.5})
     assert (said, label, agree) == ("yes (0.50)", "no", False)
+
+
+def test_verdict_reads_a_score_answer_as_its_most_likely_level() -> None:
+    """A score is judged by the level with the highest probability."""
+    given = {"type": "score", "score": 1.1, "probabilities": {"0": 0.2, "1": 0.5, "2": 0.3}}
+    assert verdict({"type": "score", "label": 1}, given) == (
+        "level 1 (score 1.10)",
+        "level 1",
+        True,
+    )
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/adb57ffc75cd347933a0bebec13312802817faee). [The code after it](https://github.com/rahuldave/babykev/tree/adb57ffc75cd347933a0bebec13312802817faee).

<a id="tut-20.13"></a>

### 20.13 babykev smoke help prints the usage

`main` of `smoke.py` answers `help` before it loads anything. So a test can run `babykev smoke help` with no model.
It goes in the tests of the command, and uses their helper `run`.

[± See the change to `tests/unit/test_cli.py`](#tut-20.13-tests-unit-test_cli.py-44d4a0-diff)

In `tests/unit/test_cli.py`, the docstring on line 1 names `smoke help`, the import is on line 6, and the new test is
on lines 42 to 50.

```bash
sed -n '42,50p' tests/unit/test_cli.py
just test -k smoke_help
```

`main` of `cli.py` raises `SystemExit` with the code that `smoke.main` returns. The test catches it, and checks the
code, 0, and the usage. pytest prints `1 passed`.

```bash
just test
```

`just test` prints `71 passed`. `cli.py` is back at 100%, and the total is 81%.

#### What changed

- <a id="tut-20.13-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: `babykev smoke help`. 13 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/4322906929f4c1b22be716cd4a341d80b8e75e25/tests/unit/test_cli.py).
  - look at `def test_smoke_help_prints_the_usage(`

<a id="tut-20.13-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -1,8 +1,9 @@
-"""Unit tests for the `babykev` command: `help` prints the help, any other word is refused."""
+"""Unit tests for the `babykev` command: `help`, `smoke help`, and the words that it refuses."""
 
 import pytest
 
 from babykev.cli import HELP, main
+from babykev.smoke import USAGE
 
 
 def run(
@@ -36,3 +37,14 @@ def test_an_unknown_command_is_refused_with_exit_code_2(
     err = capsys.readouterr().err
     assert "no command named 'train'" in err
     assert "babykev help" in err
+
+
+def test_smoke_help_prints_the_usage(
+    monkeypatch: pytest.MonkeyPatch,  # Sets the command line for the test
+    capsys: pytest.CaptureFixture[str],  # Catches the usage
+) -> None:
+    """`babykev smoke help` prints the usage of the smoke, loads no model, and exits with 0."""
+    with pytest.raises(SystemExit) as exit_info:
+        run(monkeypatch, "smoke", "help")
+    assert exit_info.value.code == 0
+    assert capsys.readouterr().out == USAGE
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/4322906929f4c1b22be716cd4a341d80b8e75e25). [The code after it](https://github.com/rahuldave/babykev/tree/4322906929f4c1b22be716cd4a341d80b8e75e25).

<a id="tut-20.14"></a>

### 20.14 babykev smoke refuses a word it does not know

A word after `babykev smoke` that is not `help` gets the usage on the error stream, and exit code 2.

[± See the change to `tests/unit/test_cli.py`](#tut-20.14-tests-unit-test_cli.py-44d4a0-diff)

In `tests/unit/test_cli.py`, the new test is on lines 53 to 61.

```bash
just test
```

`just test` prints `72 passed`, and the total is 82%. The missing lines of `smoke.py` are
`35-36, 45-49, 78-92, 105-119`. Lines 105 to 119 load the real model. `answer` and the body of `smoke` need a model,
and no unit test has one.

#### What changed

- <a id="tut-20.14-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: a word that `babykev smoke` refuses. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/13ba53784ecd145301a1413d56e43938365bbf99/tests/unit/test_cli.py).
  - look at `def test_smoke_refuses_a_word_it_does_not_know(`

<a id="tut-20.14-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -48,3 +48,14 @@ def test_smoke_help_prints_the_usage(
         run(monkeypatch, "smoke", "help")
     assert exit_info.value.code == 0
     assert capsys.readouterr().out == USAGE
+
+
+def test_smoke_refuses_a_word_it_does_not_know(
+    monkeypatch: pytest.MonkeyPatch,  # Sets the command line for the test
+    capsys: pytest.CaptureFixture[str],  # Catches the usage, on the error stream
+) -> None:
+    """A word after `babykev smoke` that is not help gets the usage and exit code 2."""
+    with pytest.raises(SystemExit) as exit_info:
+        run(monkeypatch, "smoke", "local")
+    assert exit_info.value.code == 2
+    assert capsys.readouterr().err == USAGE
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/13ba53784ecd145301a1413d56e43938365bbf99). [The code after it](https://github.com/rahuldave/babykev/tree/13ba53784ecd145301a1413d56e43938365bbf99).

<a id="tut-20.15"></a>

### 20.15 The README names the tests of the smoke

The row of `tests/unit/` names the tests of the smoke too.

[± See the change to `README.md`](#tut-20.15-README.md-8ec9a0-diff)

In `README.md`, line 83 is the row of `tests/unit/`.

```bash
just check
```

`just check` passes. The tests print `72 passed`, and the total of 82%. `just docs check` prints `85 of 85`.

#### What changed

- <a id="tut-20.15-README.md-8ec9a0"></a>`README.md`: the tests of the smoke, in the row of `tests/unit/`. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/ebfa2a8cee251782b3709a379c35af77c80c6170/README.md).
  - look at ``| `tests/unit/` | The tests of the contract, of the command, of the model and of the smoke. One test checks every line of the sample data against the contract |``

<a id="tut-20.15-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -80,7 +80,7 @@ yourself at any time.
 | `src/babykev/model.py` | The model, a language model with a head that points at the options |
 | `src/babykev/smoke.py` | The smoke run, which asks the real model the sample requests on this machine |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
-| `tests/unit/` | The tests of the contract, of the command and of the model. One test checks every line of the sample data against the contract |
+| `tests/unit/` | The tests of the contract, of the command, of the model and of the smoke. One test checks every line of the sample data against the contract |
 | `tests/conftest.py` | The fixtures that every test can ask for: the tiny tokenizer, a tiny model and a record |
 | `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |
 | `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/ebfa2a8cee251782b3709a379c35af77c80c6170).

This part ends at the code at `tut-20`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-20)

<a id="tut-21"></a>

## 21 Integration tests, and the floor

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-20`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-20)

```bash
just setup
```

`just setup` prints `Resolved 67 packages`.

An integration test runs several of our parts together. On the tiny model, it needs no download, and only our code can
make it fail, so it is hermetic. The tests here check what trains, a pass over records of different lengths,
and the whole smoke. Then the coverage is over 90%, and `just check` gets a floor.

<a id="tut-21.1"></a>

### 21.1 With an adapter, only the adapter and the head train

Training changes the adapter and the head, and the backbone stays as it is. The test makes a tiny model with an
adapter of rank 4, and takes one backward pass. Then it names every parameter that got a gradient. The fixture
`model` has no adapter, so the test calls `tiny_backbone` itself.

[± See the change to `tests/unit/test_model.py`](#tut-21.1-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the import is on line 18, and the new test is on lines 112 to 130.

```bash
sed -n '112,130p' tests/unit/test_model.py
just test -k only_the_adapter
```

Line 127 checks that every parameter with a gradient is in the adapter, `lora_`, or in the head, `head.`. Lines 128 to
130 check that `trainable_parameters` lists exactly those. pytest prints `1 passed`.

```bash
just test --cov-fail-under=90
```

`--cov-fail-under=90` makes pytest fail when the total is under 90%. It prints `73 passed`, then `FAIL Required test
coverage of 90% not reached. Total coverage: 83.52%`, and ends with exit code 1. `model.py` is at 94%, and lines 211 to
218 and 277 have run. `smoke.py` is at 48%, and misses lines `35-36, 45-49, 78-92, 105-119`.

#### What changed

- <a id="tut-21.1-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: one backward pass with an adapter. 22 lines added. [The file](https://github.com/rahuldave/babykev/blob/0be44c1de17b8acb4e18a964a782584eb26fee97/tests/unit/test_model.py).
  - look at `def test_with_an_adapter_only_the_adapter_and_the_head_train(`

<a id="tut-21.1-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -15,6 +15,7 @@ from babykev.model import (
     pick_device,
     user_tokens,
 )
+from tests.tiny import tiny_backbone
 
 
 def test_probabilities_sum_to_one_for_every_question(
@@ -106,3 +107,24 @@ def test_pick_device_takes_an_override() -> None:
 def test_pick_device_finds_something_to_run_on() -> None:
     """With no override, the choice is one of the three kinds of device."""
     assert pick_device() in {"cuda", "mps", "cpu"}
+
+
+def test_with_an_adapter_only_the_adapter_and_the_head_train(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """The backbone is frozen: gradients reach the adapter and the pointer head, nothing else."""
+    model = DecisionModel("tiny", "cpu", lora=4, backbone=tiny_backbone(len(tok)))
+    enc = encode(tok, record)
+    labels = torch.tensor(enc["labels"])
+    losses = [
+        torch.nn.functional.cross_entropy(z[None], y[None])
+        for z, y in zip(model(enc), labels, strict=True)
+    ]
+    torch.stack(losses).sum().backward()
+    with_gradient = {name for name, p in model.named_parameters() if p.grad is not None}
+    assert with_gradient
+    assert all("lora_" in name or name.startswith("head.") for name in with_gradient)
+    assert {id(p) for p in model.trainable_parameters()} == {
+        id(p) for name, p in model.named_parameters() if name in with_gradient
+    }
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/0be44c1de17b8acb4e18a964a782584eb26fee97). [The code after it](https://github.com/rahuldave/babykev/tree/0be44c1de17b8acb4e18a964a782584eb26fee97).

<a id="tut-21.2"></a>

### 21.2 Records of different lengths answer in one pass as alone

`forward_batch` reads several records in one pass. They are padded to the length of the longest. The test packs the
record of the fixture and a shorter record, and runs them in one pass. It compares each with a pass of its own.

[± See the change to `tests/unit/test_model.py`](#tut-21.2-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 133 to 146.

```bash
just test -k different_lengths
```

pytest prints `1 passed`. Line 241 builds the mask of each record, with its padding, and every test of the model has
run it. Only this test runs it with padding to build.

```bash
just test --cov-fail-under=90
```

pytest prints `74 passed`, and `Total coverage: 83.52%` again. The test adds no line to the coverage, and the floor
still fails.

#### What changed

- <a id="tut-21.2-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: a padded pass. 16 lines added. [The file](https://github.com/rahuldave/babykev/blob/e6248c7e2cf3b6b45f11e0ecfdd7f25a23745aac/tests/unit/test_model.py).
  - look at `def test_records_of_different_lengths_answer_in_one_pass_as_alone(`

<a id="tut-21.2-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -128,3 +128,19 @@ def test_with_an_adapter_only_the_adapter_and_the_head_train(
     assert {id(p) for p in model.trainable_parameters()} == {
         id(p) for name, p in model.named_parameters() if name in with_gradient
     }
+
+
+def test_records_of_different_lengths_answer_in_one_pass_as_alone(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Padded to the longest, each record gets the logits that it gets in a pass of its own."""
+    short = {"state": "Brie.", "questions": record["questions"][:1]}
+    encs = [encode(tok, record), encode(tok, short)]
+    with torch.no_grad():
+        together = model.forward_batch(encs)
+        alone = [model(enc) for enc in encs]
+    for batch, single in zip(together, alone, strict=True):
+        for a, b in zip(batch, single, strict=True):
+            assert torch.allclose(a, b, atol=1e-5)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e6248c7e2cf3b6b45f11e0ecfdd7f25a23745aac). [The code after it](https://github.com/rahuldave/babykev/tree/e6248c7e2cf3b6b45f11e0ecfdd7f25a23745aac).

<a id="tut-21.3"></a>

### 21.3 The smoke reports on every question, on the tiny model

`smoke` takes a model and a tokenizer. With the tiny ones, the five sample requests go through the contract, the
packing, the model and the answers, with no download. The answers mean nothing. The report must have a verdict for
each of the fifteen questions, and the count.

[± See the change to `tests/unit/test_smoke.py`](#tut-21.3-tests-unit-test_smoke.py-89db04-diff)

In `tests/unit/test_smoke.py`, the imports are on lines 3 to 6, and the new test is on lines 32 to 42.

```bash
sed -n '32,42p' tests/unit/test_smoke.py
just test -k smoke_reports
```

pytest prints `1 passed`. The name of the test says `smoke`, and it is an integration test, of our function `smoke` on
the tiny model. A smoke run uses the real model.

```bash
just test --cov-fail-under=90
```

pytest prints `75 passed`, then `Required test coverage of 90% reached. Total coverage: 91.76%`. The missing lines
need the Hub or a GPU of NVIDIA. They are `63, 72-75, 204-207` of `model.py`, and `105-119` of `smoke.py`.

#### What changed

- <a id="tut-21.3-tests-unit-test_smoke.py-89db04"></a>`tests/unit/test_smoke.py`: the whole smoke, on the tiny model. 17 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/08acf0a3770d58ab7fc3ac85eebf5cf9ed0bad0e/tests/unit/test_smoke.py).
  - look at `def test_smoke_reports_on_every_question_of_the_sample(`

<a id="tut-21.3-tests-unit-test_smoke.py-89db04-diff"></a>

<details><summary>The diff of <code>tests/unit/test_smoke.py</code></summary>

```diff
@@ -1,6 +1,9 @@
 """Tests of the smoke run, without the real model."""
 
-from babykev.smoke import verdict
+from transformers import PreTrainedTokenizerFast
+
+from babykev.model import DecisionModel
+from babykev.smoke import read_lines, smoke, verdict
 
 
 def test_verdict_agrees_when_the_answer_is_the_label() -> None:
@@ -24,3 +27,16 @@ def test_verdict_reads_a_score_answer_as_its_most_likely_level() -> None:
         "level 1",
         True,
     )
+
+
+def test_smoke_reports_on_every_question_of_the_sample(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+) -> None:
+    """Five requests of three questions: fifteen verdicts and a closing count."""
+    lines = read_lines()
+    report = list(smoke(model, tok, lines))
+    verdicts = [text for text in report if text.startswith(("  ok", "  --"))]
+    assert len(verdicts) == sum(len(line["questions"]) for line in lines) == 15
+    right = sum(text.startswith("  ok") for text in verdicts)
+    assert f"\n{right} of 15 right" in report[-2]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/08acf0a3770d58ab7fc3ac85eebf5cf9ed0bad0e). [The code after it](https://github.com/rahuldave/babykev/tree/08acf0a3770d58ab7fc3ac85eebf5cf9ed0bad0e).

<a id="tut-21.4"></a>

### 21.4 The gate has a floor of 90%

`just check` runs the tests with `--cov-fail-under=90`. A change that brings the total under 90% then fails the gate, and the hook refuses it.
`just test` alone has no floor, so a run of a few tests, with `-k`, does not fail on the total.

[± See the change to `justfile`](#tut-21.4-justfile-424f0b-diff)

In the `justfile`, line 82 is `just test -q --cov-fail-under=90`, and the comment on line 72 names the coverage.

```bash
just --show check
just check
```

`just check` prints `Required test coverage of 90% reached. Total coverage: 91.76%` after the tests, and ends with
exit code 0.

#### What changed

- <a id="tut-21.4-justfile-424f0b"></a>`justfile`: the floor, in the gate. 2 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/57604134d9590c16b1c4db0b1d1a11509a65345b/justfile).
  - look at `    just test -q --cov-fail-under=90`

<a id="tut-21.4-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[This change on GitHub](https://github.com/rahuldave/babykev/commit/57604134d9590c16b1c4db0b1d1a11509a65345b). [The code after it](https://github.com/rahuldave/babykev/tree/57604134d9590c16b1c4db0b1d1a11509a65345b).

<a id="tut-21.5"></a>

### 21.5 The README names the floor

The README says that one of the checks of `just check` is the floor.

[± See the change to `README.md`](#tut-21.5-README.md-8ec9a0-diff)

In `README.md`, the two lines are 70 and 71.

```bash
grep -n '90%' README.md
```

`grep` prints line 71, with the floor.

#### What changed

- <a id="tut-21.5-README.md-8ec9a0"></a>`README.md`: the floor of 90%, in the lines on `just check`. 2 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/922d6ba2495756622ad215301da7c48f2ec33fa9/README.md).
  - look at ``The tests must run at least 90% of the code. You can run `just check` yourself at any time.``

<a id="tut-21.5-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -67,8 +67,8 @@ downloads the base model from the Hugging Face Hub, about 1 GB. It answers the f
 untrained, and prints each answer beside its label.
 
 Run `just hook` once in each clone. It installs a git hook, which runs `just check` before each commit.
-`just check` runs every check of the project, and if one fails, git makes no commit. You can run `just check`
-yourself at any time.
+`just check` runs every check of the project, and if one fails, git makes no commit. One check is a floor.
+The tests must run at least 90% of the code. You can run `just check` yourself at any time.
 
 ## What is here
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/922d6ba2495756622ad215301da7c48f2ec33fa9).

This part ends at the code at `tut-21`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-21)

<a id="tut-22"></a>

## 22 The mask, found and fixed

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-21`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-21)

```bash
just setup
```

`just setup` prints `Resolved 67 packages`.

The mask of `model.py` decides which token may attend to which. A token of a question may see the state and the
tokens of its own question before it, and never a token of another question. Every check has passed since `model.py`
came in, and the coverage of `branch_mask` is 100%. But no test has looked at what the mask allows.

The tests here look, and they find that a question sees the questions before it. The code runs, its types are
right, and its lines are covered. It does the wrong thing for its task.

<a id="tut-22.1"></a>

### 22.1 The picture of the mask of a small request

The first test draws the mask of one small request by hand. The request has a state of two tokens and two questions
of two tokens each, so its segments are `[0, 0, 1, 1, 2, 2]`. Row i of the picture is token i, and column j is token
j. `#` means that token i may attend to token j, and `.` means that it may not.

[± See the new file `tests/unit/test_mask.py`](#tut-22.1-tests-unit-test_mask.py-aeb55a-diff)

The new file `tests/unit/test_mask.py` has `allowed` on lines 8 to 12, and the test on lines 15 to 26.

```bash
sed -n '15,26p' tests/unit/test_mask.py
just test -k small_request -vv
```

`allowed` reads the mask back as yes or no. `branch_mask` gives 0 where a token may attend, and a very negative
number where it may not. Rows 5 and 6 of the picture are the tokens of question 2. They see the state, columns 1 and
2, and their own question, columns 5 and 6, and not question 1, columns 3 and 4.

The test fails. `-vv` makes pytest print both lists whole. Rows 5 and 6 of the mask are `#####.` and `######`, where
the picture has `##..#.` and `##..##`. Question 2 sees question 1.

#### What changed

- <a id="tut-22.1-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the picture of a small request. New, 26 lines. [The file](https://github.com/rahuldave/babykev/blob/e7db07241985b2cc80908d108e4229cfb512646b/tests/unit/test_mask.py).
  - look at `def test_mask_of_a_small_request() -> None:`

<a id="tut-22.1-tests-unit-test_mask.py-aeb55a-diff"></a>

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -0,0 +1,26 @@
+"""Tests of the mask: which token of a packed record may attend to which."""
+
+import torch
+
+from babykev.model import branch_mask
+
+
+def allowed(
+    seg: list[int],  # The segment of each token: 0 for the state, k for question k
+) -> torch.Tensor:  # Shape [n, n]: True where token i may attend to token j
+    """Read the mask back as yes or no."""
+    return branch_mask(seg, "cpu")[0, 0] == 0
+
+
+def test_mask_of_a_small_request() -> None:
+    """A state of two tokens, and two questions of two tokens: the picture, drawn by hand."""
+    picture = [
+        "#.....",
+        "##....",
+        "###...",
+        "####..",
+        "##..#.",
+        "##..##",
+    ]
+    rows = ["".join("#" if ok else "." for ok in row) for row in allowed([0, 0, 1, 1, 2, 2])]
+    assert rows == picture
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e7db07241985b2cc80908d108e4229cfb512646b). [The code after it](https://github.com/rahuldave/babykev/tree/e7db07241985b2cc80908d108e4229cfb512646b).

<a id="tut-22.2"></a>

### 22.2 hypothesis, in the group test

A picture checks one size of request. The mask must hold for every size, and nobody can draw them all. hypothesis is
a library for tests. A test states a rule, and hypothesis draws many inputs and runs the test on each.

[hypothesis](https://hypothesis.readthedocs.io/) writes test inputs. A test says what kind of input it takes, such as a list of up to five numbers. hypothesis then tries many of them, and when one fails, it shrinks it to the smallest input that still fails.

This change came from running `uv add --group test hypothesis`.

`uv add` prints `Resolved 69 packages`, and installs hypothesis and sortedcontainers, which
hypothesis needs.

In `pyproject.toml`, the group `test` has `"hypothesis>=6.170.0",` on line 51. `uv.lock` has the exact versions.

```bash
uv run python -c "import hypothesis; print(hypothesis.__version__)"
```

It prints the version of hypothesis that uv installed.

#### What changed

- <a id="tut-22.2-pyproject.toml-5d07e7"></a>`pyproject.toml`: hypothesis, in the group `test`. 1 line added. It comes from `uv add --group test hypothesis`. [The file](https://github.com/rahuldave/babykev/blob/aa4f870deb9ec19ee18484e187f5d850399fa554/pyproject.toml).
  - look at `"hypothesis>=6.170.0",`
- <a id="tut-22.2-uv.lock-8356d8"></a>`uv.lock`: the exact versions of hypothesis and sortedcontainers. 80 lines added. It comes from `uv add --group test hypothesis`. [The file](https://github.com/rahuldave/babykev/blob/aa4f870deb9ec19ee18484e187f5d850399fa554/uv.lock).

<a id="tut-22.2-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -48,6 +48,7 @@ lint = [
     "yamllint>=1.38.0",
 ]
 test = [
+    "hypothesis>=6.170.0",
     "pytest>=9.1.1",
     "pytest-cov>=7.1.0",
 ]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/aa4f870deb9ec19ee18484e187f5d850399fa554). [The code after it](https://github.com/rahuldave/babykev/tree/aa4f870deb9ec19ee18484e187f5d850399fa554).

<a id="tut-22.3"></a>

### 22.3 No question sees another, for any shape of request

The shape of a request is the length of its state and of each question. A strategy of hypothesis says what an input
may be. `shapes` draws a state of 1 to 6 tokens, then up to 4 questions of 1 to 5 tokens each. `segments` lays out a
shape as `encode` does. The test states the rule that no token of a question attends to a token of another question.
`@given(shapes)` runs it on up to 100 shapes.

[± See the change to `tests/unit/test_mask.py`](#tut-22.3-tests-unit-test_mask.py-aeb55a-diff)

In `tests/unit/test_mask.py`, `shapes` is on line 10, `segments` on lines 13 to 18, and the new test on lines 42 to
49.

```bash
sed -n '42,49p' tests/unit/test_mask.py
just test -k no_question_sees_another
```

`siblings`, on line 48, is true for two tokens of two different questions. The assert on line 49 says that no pair
is both allowed and siblings.

The test fails. When a shape breaks the rule, hypothesis tries smaller shapes, and reports the smallest that still
breaks it. It reports `shape=(1, [1, 1])`, a state of one token and two questions of one token. `allowed([0, 1, 2])`
has `True` in row 3, column 2. So the token of question 2 sees the token of question 1.

Under the shape, hypothesis lists lines of torch that only the failing examples ran, and they say nothing about the
mask. hypothesis keeps the failing shape in the folder `.hypothesis`, and tries it first at the next run. The
`.gitignore` of GitHub names the folder already.

#### What changed

- <a id="tut-22.3-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the shapes, and the first rule. 23 lines added. [The file](https://github.com/rahuldave/babykev/blob/857445da99027d423543017a9face7f2cd41ea19/tests/unit/test_mask.py).
  - look at `def test_no_question_sees_another_question(`

<a id="tut-22.3-tests-unit-test_mask.py-aeb55a-diff"></a>

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -1,9 +1,22 @@
 """Tests of the mask: which token of a packed record may attend to which."""
 
 import torch
+from hypothesis import given
+from hypothesis import strategies as st
 
 from babykev.model import branch_mask
 
+# A request of any shape: a state of 1 to 6 tokens, then up to 4 questions of 1 to 5 tokens each
+shapes = st.tuples(st.integers(1, 6), st.lists(st.integers(1, 5), max_size=4))
+
+
+def segments(
+    state: int,  # How many tokens the state has
+    questions: list[int],  # How many tokens each question has
+) -> list[int]:  # The segment of each token: 0 for the state, k for question k
+    """Lay out a request as `encode` does: the state, then each question in turn."""
+    return [0] * state + [k for k, n in enumerate(questions, start=1) for _ in range(n)]
+
 
 def allowed(
     seg: list[int],  # The segment of each token: 0 for the state, k for question k
@@ -24,3 +37,13 @@ def test_mask_of_a_small_request() -> None:
     ]
     rows = ["".join("#" if ok else "." for ok in row) for row in allowed([0, 0, 1, 1, 2, 2])]
     assert rows == picture
+
+
+@given(shapes)
+def test_no_question_sees_another_question(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """A token of one question never attends to a token of another question."""
+    seg = torch.tensor(segments(*shape))
+    siblings = (seg[:, None] != seg[None, :]) & (seg[:, None] > 0) & (seg[None, :] > 0)
+    assert not (allowed(seg.tolist()) & siblings).any()
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/857445da99027d423543017a9face7f2cd41ea19). [The code after it](https://github.com/rahuldave/babykev/tree/857445da99027d423543017a9face7f2cd41ea19).

<a id="tut-22.4"></a>

### 22.4 No token sees a later token, for any shape of request

The second rule is the causal part of the mask. Nothing above the diagonal is allowed, so a token never attends to a
token after it.

[± See the change to `tests/unit/test_mask.py`](#tut-22.4-tests-unit-test_mask.py-aeb55a-diff)

In `tests/unit/test_mask.py`, the new test is on lines 52 to 57.

```bash
just test -k later_token
```

pytest prints `1 passed`. The causal part of the mask was never wrong. Only the part about the questions is.

#### What changed

- <a id="tut-22.4-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the causal rule. 8 lines added. [The file](https://github.com/rahuldave/babykev/blob/55034fc9085b7ba3a5ac86f3cd40b955a698b642/tests/unit/test_mask.py).
  - look at `def test_no_token_sees_a_later_token(`

<a id="tut-22.4-tests-unit-test_mask.py-aeb55a-diff"></a>

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -47,3 +47,11 @@ def test_no_question_sees_another_question(
     seg = torch.tensor(segments(*shape))
     siblings = (seg[:, None] != seg[None, :]) & (seg[:, None] > 0) & (seg[None, :] > 0)
     assert not (allowed(seg.tolist()) & siblings).any()
+
+
+@given(shapes)
+def test_no_token_sees_a_later_token(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """Nothing above the diagonal is allowed: a token never attends to a token after it."""
+    assert not torch.triu(allowed(segments(*shape)), diagonal=1).any()
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/55034fc9085b7ba3a5ac86f3cd40b955a698b642). [The code after it](https://github.com/rahuldave/babykev/tree/55034fc9085b7ba3a5ac86f3cd40b955a698b642).

<a id="tut-22.5"></a>

### 22.5 What the mask allows is exactly the rule

The last rule says the whole of it, in plain Python. Token i may attend to token j when j is not after i, and j is
in the state or in the question of i. The test builds that table for every pair of tokens, and compares it with the
mask.

[± See the change to `tests/unit/test_mask.py`](#tut-22.5-tests-unit-test_mask.py-aeb55a-diff)

In `tests/unit/test_mask.py`, the new test is on lines 60 to 70.

```bash
sed -n '60,70p' tests/unit/test_mask.py
just test -k exactly_the_rule
```

The test fails, and hypothesis shrinks the shape to `(1, [1, 1])` again. The three tests of the rules check the mask
alone, so they are unit tests.

#### What changed

- <a id="tut-22.5-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: the whole rule. 13 lines added. [The file](https://github.com/rahuldave/babykev/blob/41b4f5f236a25a9e8438ba2a00682b5125868a50/tests/unit/test_mask.py).
  - look at `def test_what_is_allowed_is_exactly_the_rule(`

<a id="tut-22.5-tests-unit-test_mask.py-aeb55a-diff"></a>

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -55,3 +55,16 @@ def test_no_token_sees_a_later_token(
 ) -> None:
     """Nothing above the diagonal is allowed: a token never attends to a token after it."""
     assert not torch.triu(allowed(segments(*shape)), diagonal=1).any()
+
+
+@given(shapes)
+def test_what_is_allowed_is_exactly_the_rule(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """Token i sees token j when j is not after i, and j is in the state or in i's question."""
+    seg = segments(*shape)
+    rule = [
+        [j <= i and (seg[j] == 0 or seg[j] == seg[i]) for j in range(len(seg))]
+        for i in range(len(seg))
+    ]
+    assert allowed(seg).tolist() == rule
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/41b4f5f236a25a9e8438ba2a00682b5125868a50). [The code after it](https://github.com/rahuldave/babykev/tree/41b4f5f236a25a9e8438ba2a00682b5125868a50).

<a id="tut-22.6"></a>

### 22.6 A question cannot see its sibling

The rules check the mask alone. The next three tests check what the mask is for, on the tiny model. Each question
must get the answer that it would get if it were the only question. The first test rewrites question 2 of the record,
and the answers to questions 1 and 3 must not move, to the last bit.

[± See the change to `tests/unit/test_model.py`](#tut-22.6-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 149 to 160.

```bash
sed -n '149,160p' tests/unit/test_model.py
just test -k sibling
```

The test fails on line 160, question 3. Its probabilities were `[0.3341, 0.3331, 0.3328]`, and are
`[0.3343, 0.3330, 0.3327]` after question 2 changed. Question 3 sees question 2. Line 159, question 1, passes, because
question 1 comes first and sees only the state. The tiny model is untrained, so the probabilities are close to equal.
`torch.equal` asks for the same numbers, and any change is a failure.

#### What changed

- <a id="tut-22.6-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: rewrite question 2, and questions 1 and 3 keep their answers. 14 lines added. [The file](https://github.com/rahuldave/babykev/blob/12e9fb18c4c86cbd1291da858fd6ad39af01929b/tests/unit/test_model.py).
  - look at `def test_a_question_cannot_see_its_sibling(`

<a id="tut-22.6-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -144,3 +144,17 @@ def test_records_of_different_lengths_answer_in_one_pass_as_alone(
     for batch, single in zip(together, alone, strict=True):
         for a, b in zip(batch, single, strict=True):
             assert torch.allclose(a, b, atol=1e-5)
+
+
+def test_a_question_cannot_see_its_sibling(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Rewriting question 2 leaves the answers to questions 1 and 3 exactly as they were."""
+    before = model.probs(encode(tok, record))
+    changed = {**record, "questions": list(record["questions"])}
+    changed["questions"][1] = {"instr": "Where from?", "options": ["Spain", "Italy"], "label": 0}
+    after = model.probs(encode(tok, changed))
+    assert torch.equal(before[0], after[0])
+    assert torch.equal(before[2], after[2])
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/12e9fb18c4c86cbd1291da858fd6ad39af01929b). [The code after it](https://github.com/rahuldave/babykev/tree/12e9fb18c4c86cbd1291da858fd6ad39af01929b).

<a id="tut-22.7"></a>

### 22.7 Packed questions answer as they would alone

The second test of isolation packs the three questions of the record in one pass. Then it asks each question in a
record of its own, with the same state. The answers must be the same, to within `1e-6`.

[± See the change to `tests/unit/test_model.py`](#tut-22.7-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 163 to 172.

```bash
just test -k packed_questions
```

The test fails on question 2. Packed, it gets `[0.3321, 0.3346, 0.3333]`, and alone it gets
`[0.3317, 0.3351, 0.3332]`. Question 1 passed the loop before it, for the reason of the last test.

#### What changed

- <a id="tut-22.7-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: three questions in one pass, and each alone. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/d3e4a6a067cd7f481a1bd327af08cb2358429e9c/tests/unit/test_model.py).
  - look at `def test_packed_questions_answer_as_they_would_alone(`

<a id="tut-22.7-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -158,3 +158,15 @@ def test_a_question_cannot_see_its_sibling(
     after = model.probs(encode(tok, changed))
     assert torch.equal(before[0], after[0])
     assert torch.equal(before[2], after[2])
+
+
+def test_packed_questions_answer_as_they_would_alone(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """One pass over three questions gives what three passes, of one question each, give."""
+    packed = model.probs(encode(tok, record))
+    for together, question in zip(packed, record["questions"], strict=True):
+        alone = model.probs(encode(tok, {"state": record["state"], "questions": [question]}))[0]
+        assert torch.allclose(together, alone, atol=1e-6)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/d3e4a6a067cd7f481a1bd327af08cb2358429e9c). [The code after it](https://github.com/rahuldave/babykev/tree/d3e4a6a067cd7f481a1bd327af08cb2358429e9c).

<a id="tut-22.8"></a>

### 22.8 The order of questions does not matter

The positions of every question restart after the state. So a question must get the same answer first or last. The
third test of isolation asks the questions in the reverse order.

[± See the change to `tests/unit/test_model.py`](#tut-22.8-tests-unit-test_model.py-583145-diff)

In `tests/unit/test_model.py`, the new test is on lines 175 to 184.

```bash
just test -k questions_does_not_matter
```

The test fails on question 1. In the reverse order it comes last, and sees the two other questions. Its
probabilities go from `[0.5016, 0.4984]` to `[0.5007, 0.4993]`. `-k order_of_questions` would also choose a test of
`test_api.py`, so the command names the end of the test.

#### What changed

- <a id="tut-22.8-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: the questions in the reverse order. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/c3e2706e2b1fbc58bda631e173e26145256bc47e/tests/unit/test_model.py).
  - look at `def test_the_order_of_questions_does_not_matter(`

<a id="tut-22.8-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -170,3 +170,15 @@ def test_packed_questions_answer_as_they_would_alone(
     for together, question in zip(packed, record["questions"], strict=True):
         alone = model.probs(encode(tok, {"state": record["state"], "questions": [question]}))[0]
         assert torch.allclose(together, alone, atol=1e-6)
+
+
+def test_the_order_of_questions_does_not_matter(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Positions restart after the state, so a question gets the same answer first or last."""
+    forward = model.probs(encode(tok, record))
+    backward = model.probs(encode(tok, {**record, "questions": record["questions"][::-1]}))
+    for a, b in zip(forward, backward[::-1], strict=True):
+        assert torch.allclose(a, b, atol=1e-6)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/c3e2706e2b1fbc58bda631e173e26145256bc47e). [The code after it](https://github.com/rahuldave/babykev/tree/c3e2706e2b1fbc58bda631e173e26145256bc47e).

<a id="tut-22.9"></a>

### 22.9 A fix for the picture, wrong on purpose

The mistake of this move is on purpose. The picture failed on rows 5 and 6, where question 2 sees question 1. A quick
fix blocks only the question just before a question. A token sees its own question, the state, and any question two
or more before it. The fix makes the picture right.

[± See the change to `src/babykev/model.py`](#tut-22.9-src-babykev-model.py-a86a0b-diff)

In `src/babykev/model.py`, line 159 now ends with `| (s[None, :] < s[:, None] - 1)`. A token may see a question
whose number is less than its own minus one.

```bash
just test
```

The picture passes, and so does the test of the siblings. 4 tests fail, 78 pass. The two rules that failed before
fail again, and hypothesis shrinks each to `shape=(1, [1, 1, 1])`, three questions of one token. The token of
question 3 sees the token of question 1. The stored shape `(1, [1, 1])` passes now, so hypothesis looks for a new one.
The test of the packed questions and the test of the order fail too, on a question that sees a question two before
it.

The picture has two questions, so it cannot tell. The test of the siblings rewrites question 2, which question 3 no
longer sees. A rule for every shape found the size with three questions.

#### What changed

- <a id="tut-22.9-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: a mask that blocks only the question just before, on purpose. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/18bdfee89d950245956448ab8377cfc8b90e8595/src/babykev/model.py).
  - look at `    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)`

<a id="tut-22.9-src-babykev-model.py-a86a0b-diff"></a>

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

```diff
@@ -156,7 +156,7 @@ def branch_mask(
     s = torch.tensor(seg, device=device)
     n = len(seg)
     causal = torch.tril(torch.ones(n, n, dtype=torch.bool, device=device))
-    same = torch.ones_like(causal) | (s[None, :] == 0)
+    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)
     allow = causal & same
     blocked = torch.finfo(dtype).min
     return torch.zeros(n, n, dtype=dtype, device=device).masked_fill(~allow, blocked)[None, None]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/18bdfee89d950245956448ab8377cfc8b90e8595). [The code after it](https://github.com/rahuldave/babykev/tree/18bdfee89d950245956448ab8377cfc8b90e8595).

<a id="tut-22.10"></a>

### 22.10 A token sees the state and its own question

The line of the mask becomes kev's line. A token may attend to a token of the state, `s[None, :] == 0`, or to a token
of its own question, `s[None, :] == s[:, None]`. `causal`, on line 158, keeps out every token after it, and line 160
joins the two. The docstring of `branch_mask`, lines 150 to 154, has stated this rule from the start.

[± See the change to `src/babykev/model.py`](#tut-22.10-src-babykev-model.py-a86a0b-diff)

In `src/babykev/model.py`, line 159 is `same = (s[None, :] == s[:, None]) | (s[None, :] == 0)`.

```bash
just test
```

`just test` prints `82 passed`, and the total of 92%. A test of what the mask allows adds no line
to the coverage. `branch_mask` was covered all along.

The smoke runs the real model on the sample again, with the right mask.

```bash
just smoke
```

The smoke prints `4 of 15 right`. Questions 2 and 3 of each request now read only the state and themselves, and not
the questions before them. The model is untrained, so the count is a guess, and a right answer is chance.

In tut-18, with the old mask, the smoke printed `6 of 15 right`. The first question of each request keeps its answer,
with the same two decimals. It comes first, so it saw only the state with either mask. Most of the ten other answers
changed. Both counts are guesses.

#### What changed

- <a id="tut-22.10-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: the state, or the same question. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/5f63fb463f94ae6c82a647db8a4b86d4a3d6caa1/src/babykev/model.py).
  - look at `    same = (s[None, :] == s[:, None]) | (s[None, :] == 0)`

<a id="tut-22.10-src-babykev-model.py-a86a0b-diff"></a>

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

```diff
@@ -156,7 +156,7 @@ def branch_mask(
     s = torch.tensor(seg, device=device)
     n = len(seg)
     causal = torch.tril(torch.ones(n, n, dtype=torch.bool, device=device))
-    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)
+    same = (s[None, :] == s[:, None]) | (s[None, :] == 0)
     allow = causal & same
     blocked = torch.finfo(dtype).min
     return torch.zeros(n, n, dtype=dtype, device=device).masked_fill(~allow, blocked)[None, None]
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/5f63fb463f94ae6c82a647db8a4b86d4a3d6caa1). [The code after it](https://github.com/rahuldave/babykev/tree/5f63fb463f94ae6c82a647db8a4b86d4a3d6caa1).

<a id="tut-22.11"></a>

### 22.11 The README names the tests of the mask

The row of the README for `tests/unit/` names the tests of the mask, and hypothesis.

[± See the change to `README.md`](#tut-22.11-README.md-8ec9a0-diff)

In `README.md`, the row of `tests/unit/` is on line 83.

```bash
just check
```

`just check` passes. The tests print `82 passed` and `Total coverage: 91.76%`. `just docs check` prints `97 of 97`,
with the six functions of `test_mask.py`.

#### What changed

- <a id="tut-22.11-README.md-8ec9a0"></a>`README.md`: the tests of the mask, in the row of `tests/unit/`. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/9bfadf5448a5951580b313a781b277f343aa6e30/README.md).
  - look at `hypothesis tries the rules of the mask on many shapes of request |`

<a id="tut-22.11-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -80,7 +80,7 @@ The tests must run at least 90% of the code. You can run `just check` yourself a
 | `src/babykev/model.py` | The model, a language model with a head that points at the options |
 | `src/babykev/smoke.py` | The smoke run, which asks the real model the sample requests on this machine |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
-| `tests/unit/` | The tests of the contract, of the command, of the model and of the smoke. One test checks every line of the sample data against the contract |
+| `tests/unit/` | The tests of the contract, of the command, of the model, of its mask and of the smoke. One test checks every line of the sample data against the contract. hypothesis tries the rules of the mask on many shapes of request |
 | `tests/conftest.py` | The fixtures that every test can ask for: the tiny tokenizer, a tiny model and a record |
 | `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |
 | `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/9bfadf5448a5951580b313a781b277f343aa6e30).

This part ends at the code at `tut-22`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-22)

<a id="tut-23"></a>

## 23 The system test

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-22`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-22)

```bash
just setup
```

`just setup` prints `Resolved 69 packages`.

Every test so far needs nothing but our code. The tiny model is built in memory, so no download, no network and no
device can make a test fail. Such a test is hermetic, and the hook can run it before each `git commit`. The smoke on the
real model is a test too, of the whole program with its real parts. It needs the Hub or its cache, and it is the
system test of the table of the kinds of tests. Here it becomes a test, an experiment shows that it is not
hermetic, and keeps it out of `just test` and the gate.

<a id="tut-23.1"></a>

### 23.1 The smoke on the real model, as a test

The test runs `main` of `smoke.py`, as `babykev smoke` does. It checks what holds on any device, which is the exit
code 0, fifteen verdicts, and the count of the right ones. It does not check the count itself, because an untrained model
guesses.

[± See the new file `tests/system/test_real_model.py`](#tut-23.1-tests-system-test_real_model.py-df0b9d-diff)

The new file `tests/system/test_real_model.py` has the docstring on lines 1 to 7, and the test on lines 14 to 24.

```bash
sed -n '14,24p' tests/system/test_real_model.py
just test
```

`capsys`, on line 15, is the fixture of pytest that catches what the test prints. `just test` prints `83 passed`. The
test loads the real model, so the run takes a few seconds more. `smoke.py` goes to 100%, and the total to 99%. Only
lines 63 and 74 of `model.py` are left, the branch of CUDA and the check of a tokenizer.

A test that needs the network fails without it. `HF_HUB_OFFLINE=1` tells the library of the Hub to make no request,
and `HF_HOME` points its cache at an empty folder. The two together are a machine with no network and no download.

```bash
HF_HUB_OFFLINE=1 HF_HOME="$(mktemp -d)" just test -k real_model
```

The test fails, with `OSError: We couldn't connect to 'https://huggingface.co' to load the files, and couldn't find
them in the cached files.` Nothing in our code changed. So the test is not hermetic.

```bash
HF_HUB_OFFLINE=1 just test -k real_model
```

With the cache of this machine and still no network, the test passes. It passes because the model is in the cache,
and not because it is hermetic.

#### What changed

- <a id="tut-23.1-tests-system-test_real_model.py-df0b9d"></a>`tests/system/test_real_model.py`: the smoke on the real model, as a test. New, 24 lines. [The file](https://github.com/rahuldave/babykev/blob/e8d250399661741adb430b0ab9020fb869279074/tests/system/test_real_model.py).
  - look at `def test_the_real_model_answers_every_sample_question(`

<a id="tut-23.1-tests-system-test_real_model.py-df0b9d-diff"></a>

<details><summary>The diff of <code>tests/system/test_real_model.py</code></summary>

```diff
@@ -0,0 +1,24 @@
+"""The smoke on the real model, the one test here that is not hermetic.
+
+The tests under `tests/unit/` need nothing but our code: the tiny model is built in memory. This
+test loads Qwen2.5-0.5B from the Hugging Face Hub, about 1 GB the first time and from the cache
+after that, onto the best device of the machine. The network, the download and the device can
+each make it fail.
+"""
+
+import pytest
+
+from babykev.smoke import main
+
+
+def test_the_real_model_answers_every_sample_question(
+    capsys: pytest.CaptureFixture[str],  # What the smoke prints
+) -> None:
+    """Five requests of three questions: fifteen verdicts, the count of those right, exit 0."""
+    assert main([]) == 0
+    printed = capsys.readouterr().out.splitlines()
+    assert printed[0].startswith("babykev smoke: Qwen/Qwen2.5-0.5B on ")
+    verdicts = [line for line in printed if line.startswith(("  ok", "  --"))]
+    assert len(verdicts) == 15
+    right = sum(line.startswith("  ok") for line in verdicts)
+    assert f"{right} of 15 right" in "\n".join(printed)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e8d250399661741adb430b0ab9020fb869279074). [The code after it](https://github.com/rahuldave/babykev/tree/e8d250399661741adb430b0ab9020fb869279074).

<a id="tut-23.2"></a>

### 23.2 The test of the real model is marked system

A marker is a name that a test carries. `pytestmark` puts a marker on every test of a file. This file gets the marker
`system`.

[± See the change to `tests/system/test_real_model.py`](#tut-23.2-tests-system-test_real_model.py-df0b9d-diff)

In `tests/system/test_real_model.py`, the comment is on line 13, and `pytestmark` on line 14.

```bash
just test -k real_model
```

pytest prints `1 passed`, and a warning, `PytestUnknownMarkWarning: Unknown pytest.mark.system - is this a typo?`.
pytest knows only the markers that it is told about. A marker with a typo in its name would choose no test, with no
error.

#### What changed

- <a id="tut-23.2-tests-system-test_real_model.py-df0b9d"></a>`tests/system/test_real_model.py`: the marker `system`. 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/14e3ab70450cd154b85d49f1b9a694de35a18557/tests/system/test_real_model.py).
  - look at `pytestmark = pytest.mark.system`

<a id="tut-23.2-tests-system-test_real_model.py-df0b9d-diff"></a>

<details><summary>The diff of <code>tests/system/test_real_model.py</code></summary>

```diff
@@ -10,6 +10,9 @@ import pytest
 
 from babykev.smoke import main
 
+# Every test of this file needs the network, the real weights and a device
+pytestmark = pytest.mark.system
+
 
 def test_the_real_model_answers_every_sample_question(
     capsys: pytest.CaptureFixture[str],  # What the smoke prints
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/14e3ab70450cd154b85d49f1b9a694de35a18557). [The code after it](https://github.com/rahuldave/babykev/tree/14e3ab70450cd154b85d49f1b9a694de35a18557).

<a id="tut-23.3"></a>

### 23.3 pytest knows the marker system

`markers` in `pyproject.toml` declares each marker, with what it means.

[± See the change to `pyproject.toml`](#tut-23.3-pyproject.toml-5d07e7-diff)

In `pyproject.toml`, the comment is on line 62, and `markers` on line 63.

```bash
just test -k real_model
just test --markers
```

The test passes with no warning. `just test --markers` lists every marker, and the first line is
`@pytest.mark.system: needs the network, the real model or a device`.

#### What changed

- <a id="tut-23.3-pyproject.toml-5d07e7"></a>`pyproject.toml`: the marker `system`, declared. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/e194931f1402c90fe5d4d59d5ac3e5c5846b8ac1/pyproject.toml).
  - look at `markers = ["system: needs the network, the real model or a device"]`

<a id="tut-23.3-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -59,6 +59,8 @@ testpaths = ["tests"]
 pythonpath = ["."]
 # Every run measures how much of src/babykev the tests run, and lists the lines they do not
 addopts = "--cov=babykev --cov-report=term-missing"
+# A marker is a name that a test can carry, and -m chooses the tests by it
+markers = ["system: needs the network, the real model or a device"]
 
 [tool.ruff]
 # The formatter and the linter share this setting. ruff's own default is 88, and this project uses 100
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/e194931f1402c90fe5d4d59d5ac3e5c5846b8ac1). [The code after it](https://github.com/rahuldave/babykev/tree/e194931f1402c90fe5d4d59d5ac3e5c5846b8ac1).

<a id="tut-23.4"></a>

### 23.4 just test leaves out the tests marked system

`-m` chooses the tests by their markers. `-m 'not system'` in `addopts` leaves out every test marked `system` from
every run. A `-m` on the command line comes after `addopts`, and wins.

[± See the change to `pyproject.toml`](#tut-23.4-pyproject.toml-5d07e7-diff)

In `pyproject.toml`, the comment is on lines 60 and 61, and line 62 is
`addopts = "--cov=babykev --cov-report=term-missing -m 'not system'"`.

```bash
just test
just test -m system
```

`just test` prints `82 passed, 1 deselected`, and the total of 92%, as before the test of the real model. `just check` runs
the same tests, so the gate and the hook never need the network. `just test -m system` runs the one test, and prints
`1 passed, 82 deselected`.

#### What changed

- <a id="tut-23.4-pyproject.toml-5d07e7"></a>`pyproject.toml`: the tests marked `system` stay out of every run that does not ask for them. 3 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/12e34ad11cf268f667238c3362902c25b462225c/pyproject.toml).
  - look at `addopts = "--cov=babykev --cov-report=term-missing -m 'not system'"`

<a id="tut-23.4-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -57,8 +57,9 @@ test = [
 testpaths = ["tests"]
 # A test can import its helpers from the folder tests, for example tests.tiny
 pythonpath = ["."]
-# Every run measures how much of src/babykev the tests run, and lists the lines they do not
-addopts = "--cov=babykev --cov-report=term-missing"
+# Every run measures how much of src/babykev the tests run, and lists the lines they do not. A run
+# leaves out the tests marked system, unless it asks for them: just test -m system
+addopts = "--cov=babykev --cov-report=term-missing -m 'not system'"
 # A marker is a name that a test can carry, and -m chooses the tests by it
 markers = ["system: needs the network, the real model or a device"]
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/12e34ad11cf268f667238c3362902c25b462225c). [The code after it](https://github.com/rahuldave/babykev/tree/12e34ad11cf268f667238c3362902c25b462225c).

<a id="tut-23.5"></a>

### 23.5 The README names the test of the real model

The README says what `just test` runs, and how to run the test of the real model. The table gets a row for
`tests/system/`.

[± See the change to `README.md`](#tut-23.5-README.md-8ec9a0-diff)

In `README.md`, the new paragraph is on lines 69 to 71, and the row of `tests/system/` on line 88.

```bash
just check
```

`just check` passes. The tests print `82 passed, 1 deselected`, and `Total coverage: 91.76%`. `just docs check` prints
`98 of 98`, with the test of the real model.

#### What changed

- <a id="tut-23.5-README.md-8ec9a0"></a>`README.md`: `just test -m system`, and the row of `tests/system/`. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/d9df8f2a02ed7a7780325aebf281d6107317f9d9/README.md).
  - look at ``| `tests/system/` | The test of the real model, marked `system`. `just test -m system` runs it |``

<a id="tut-23.5-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -66,6 +66,10 @@ too. With them, `.venv` takes about 750 MB, and torch is most of it.
 downloads the base model from the Hugging Face Hub, about 1 GB. It answers the five sample requests,
 untrained, and prints each answer beside its label.
 
+`just test` runs every test that needs nothing but our code. The test in `tests/system/` loads the
+real model, as the smoke does, so it needs the Hub or its cache. It has the marker `system`, and only
+`just test -m system` runs it.
+
 Run `just hook` once in each clone. It installs a git hook, which runs `just check` before each commit.
 `just check` runs every check of the project, and if one fails, git makes no commit. One check is a floor.
 The tests must run at least 90% of the code. You can run `just check` yourself at any time.
@@ -81,6 +85,7 @@ The tests must run at least 90% of the code. You can run `just check` yourself a
 | `src/babykev/smoke.py` | The smoke run, which asks the real model the sample requests on this machine |
 | `data/cheese/sample.jsonl` | Five requests about cheese, one on each line. Every question has a `label`, the right answer |
 | `tests/unit/` | The tests of the contract, of the command, of the model, of its mask and of the smoke. One test checks every line of the sample data against the contract. hypothesis tries the rules of the mask on many shapes of request |
+| `tests/system/` | The test of the real model, marked `system`. `just test -m system` runs it |
 | `tests/conftest.py` | The fixtures that every test can ask for: the tiny tokenizer, a tiny model and a record |
 | `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |
 | `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/d9df8f2a02ed7a7780325aebf281d6107317f9d9).

This part ends at the code at `tut-23`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-23)

<a id="tut-24"></a>

## 24 The model, explained

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-23`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-23)

```bash
just setup
```

`just setup` prints `Resolved 69 packages`.

The reference pages of the site give the signature and the docstring of each function of `model.py`. They do not say
why the model is built as it is. Two pages of a guide say it, in prose. The first gives the four ideas of the model,
and the second draws the mask as a grid. smalldocs runs no code, so a page holds its grids as text.

<a id="tut-24.1"></a>

### 24.1 A page of the guide on the model

The page explains packing, the mask, the positions that restart, and pointing, and then what trains. A name in
backticks, such as `encode()`, links to its entry in the reference, as on the front page.

[± See the new file `docs/guide/model.qmd`](#tut-24.1-docs-guide-model.qmd-3d8904-diff)

The new file `docs/guide/model.qmd` has five parts. Packing starts on line 9, the mask on line 33, the positions on
line 43, pointing on line 48, and what trains on line 57.

```bash
just docs
grep -o 'href="../api/model.html#[^"]*"' docs/_site/guide/model.html
```

`just docs` prints `wrote 6 page(s) to docs/_site`. The sixth page is `docs/_site/guide/model.html`. `grep -o` prints
the eight links of the page into the reference of `model.py`, `encode` twice. The sidebar does not list the page yet.

#### What changed

- <a id="tut-24.1-docs-guide-model.qmd-3d8904"></a>`docs/guide/model.qmd`: the four ideas of the model. New, 61 lines. [The file](https://github.com/rahuldave/babykev/blob/b23fa492cea947fd91a783a6ef8c19ee1d4f38eb/docs/guide/model.qmd).
  - look at `## Packing`

<a id="tut-24.1-docs-guide-model.qmd-3d8904-diff"></a>

<details><summary>The diff of <code>docs/guide/model.qmd</code></summary>

```diff
@@ -0,0 +1,61 @@
+---
+title: The model
+---
+
+babykev is a language model with a head that points at an option, and it writes no text. Four ideas make it
+work, and each is a part of `model.py`. The reference pages give the signatures, and this page gives the
+reasons.
+
+## Packing
+
+A request is one state and several questions. `encode()` writes all of it into one sequence of tokens, in this
+order:
+
+- a delimiter, then the state
+- for each question, a delimiter and the instruction
+- each option of the question, between an opening and a closing delimiter
+- a decide delimiter at the end of each question
+
+The five delimiters are in `SPECIAL`. They are special tokens that the base model already has and rarely uses.
+So no new token is added, and the adapter learns what each one means here.
+
+Text from a caller goes through `user_tokens` first. It rewrites the text of a delimiter, such as
+`<|box_end|>`, to `<¦box_end¦>`, which the tokenizer reads as ordinary text. Without it, a state that holds
+the text of the closing delimiter could close an option early.
+
+`encode()` returns an `Encoded`. Its parts are these:
+
+- the ids of the tokens
+- the segment of each token, 0 for the state and k for question k
+- the position of each token
+- the places of the decide token and of the option tokens of each question
+
+## The mask
+
+The questions share the state, and nothing else. `branch_mask` builds the attention mask that makes this true.
+Token i may attend to token j when j is not after i, and j is in the state or in the question of i. The mask
+is added to the scores of the attention. So a blocked pair gets the most negative number that the type can
+hold, and its weight after the softmax is 0.
+
+With this mask, three questions in one request get the answers that they get in three requests of one
+question each. The tests check it.
+
+## Positions restart
+
+The positions of every question start right after the state. So a question looks the same to the model, in
+any place in the request. The tests check that the order of the questions changes no answer.
+
+## Pointing
+
+`PointerHead` has two small projections. At the decide token of a question, it projects the hidden state. At
+the closing token of each option, it projects the hidden state too. The scaled dot product of the two is the
+score of the option. One pass gives every question its scores.
+
+`DecisionModel` keeps the transformer of the base model, and drops its head over the vocabulary. It adds a
+LoRA adapter when it is asked to, and then the head. So the model cannot write text.
+
+## What trains
+
+With an adapter, the backbone does not change. The gradients reach the matrices of the adapter and the
+pointer head, and nothing else. `DecisionModel.trainable_parameters()` lists exactly those. The smoke run
+prints their number, 9.3M of 503M.
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/b23fa492cea947fd91a783a6ef8c19ee1d4f38eb). [The code after it](https://github.com/rahuldave/babykev/tree/b23fa492cea947fd91a783a6ef8c19ee1d4f38eb).

<a id="tut-24.2"></a>

### 24.2 A page of the guide on the mask

The page draws the mask of the small request of `test_mask.py`, then the grid of a plain causal mask for the same
request. The first grid is the picture of the test, so `just test` keeps it true.

[± See the new file `docs/guide/mask.qmd`](#tut-24.2-docs-guide-mask.qmd-5cd81a-diff)

The new file `docs/guide/mask.qmd` has the grid of the mask on lines 13 to 21. The grid of a plain causal mask is on
lines 33 to 41.

```bash
just docs
```

`just docs` prints `wrote 7 page(s) to docs/_site`.

#### What changed

- <a id="tut-24.2-docs-guide-mask.qmd-5cd81a"></a>`docs/guide/mask.qmd`: the mask, as a grid. New, 52 lines. [The file](https://github.com/rahuldave/babykev/blob/872a008d4a67bfd58f67b5db28198f4293cc34f5/docs/guide/mask.qmd).
  - look at `## A plain causal mask`

<a id="tut-24.2-docs-guide-mask.qmd-5cd81a-diff"></a>

<details><summary>The diff of <code>docs/guide/mask.qmd</code></summary>

````diff
@@ -0,0 +1,52 @@
+---
+title: The mask
+---
+
+The mask says which token of a packed request may attend to which. This page draws it as a grid. A row is a
+token, and a column is a token that it might attend to. `#` is allowed, and `.` is blocked.
+
+## A small request
+
+The request has a state of two tokens and two questions of two tokens each. The segments are
+`[0, 0, 1, 1, 2, 2]`.
+
+```
+     s s 1 1 2 2
+s    # . . . . .
+s    # # . . . .
+1    # # # . . .
+1    # # # # . .
+2    # # . . # .
+2    # # . . # #
+```
+
+Every token sees the state and the tokens of its own question that come before it. Rows 5 and 6, the tokens of
+question 2, do not see columns 3 and 4, the tokens of question 1.
+
+The picture is the test `test_mask_of_a_small_request`, in `tests/unit/test_mask.py`. So `just test` checks
+that the grid on the page is the grid that `branch_mask` builds.
+
+## A plain causal mask
+
+A plain causal mask lets each token see every token before it. For the same request, it gives this grid.
+
+```
+     s s 1 1 2 2
+s    # . . . . .
+s    # # . . . .
+1    # # # . . .
+1    # # # # . .
+2    # # # # # .
+2    # # # # # #
+```
+
+Rows 5 and 6 differ. Question 2 sees question 1, so the answer to question 2 depends on question 1.
+
+## The rule, for any request
+
+One picture checks one size. The tests in `test_mask.py` state the rule, and hypothesis tries many sizes of
+request:
+
+- no token sees a token after it
+- no token of a question sees a token of another question
+- the mask allows exactly what the rule allows
````

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/872a008d4a67bfd58f67b5db28198f4293cc34f5). [The code after it](https://github.com/rahuldave/babykev/tree/872a008d4a67bfd58f67b5db28198f4293cc34f5).

<a id="tut-24.3"></a>

### 24.3 The guide in the sidebar

The sidebar of the site gets a section, Guide, between the front page and the reference. It names the two pages one
by one, so that the model comes before the mask. A pattern such as `guide/*` would list them in the order of their
names.

[± See the change to `docs/_smalldocs.yml`](#tut-24.3-docs-_smalldocs.yml-4b0b48-diff)

In `docs/_smalldocs.yml`, the section `Guide` is on lines 11 to 14.

```bash
just docs
grep -o 'href="guide/[^"]*"' docs/_site/index.html
```

`just docs` prints `wrote 7 page(s) to docs/_site`. `grep -o` prints the two links of the sidebar of the front page,
`guide/model.html` and then `guide/mask.html`.

#### What changed

- <a id="tut-24.3-docs-_smalldocs.yml-4b0b48"></a>`docs/_smalldocs.yml`: the section `Guide`. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/f19e99afaa9f11778658710d44ef1785dbc40ed0/docs/_smalldocs.yml).
  - look at `      - section: Guide`

<a id="tut-24.3-docs-_smalldocs.yml-4b0b48-diff"></a>

<details><summary>The diff of <code>docs/_smalldocs.yml</code></summary>

```diff
@@ -8,6 +8,10 @@ website:
   sidebar:
     contents:
       - index.qmd
+      - section: Guide
+        contents:  # named one by one, so that the model comes before its mask
+          - guide/model.qmd
+          - guide/mask.qmd
       - section: Reference
         contents: api/*  # the reference pages, which each build makes from the code
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/f19e99afaa9f11778658710d44ef1785dbc40ed0). [The code after it](https://github.com/rahuldave/babykev/tree/f19e99afaa9f11778658710d44ef1785dbc40ed0).

<a id="tut-24.4"></a>

### 24.4 The front page names the guide

A paragraph of the front page links to the two pages.

[± See the change to `docs/index.qmd`](#tut-24.4-docs-index.qmd-d6d880-diff)

In `docs/index.qmd`, the new paragraph is on lines 25 and 26.

```bash
just docs
grep -o 'href="guide/[^"]*"' docs/_site/index.html
```

`grep -o` prints four links to the guide. The first two are in the sidebar, and the last two are in the new
paragraph.

#### What changed

- <a id="tut-24.4-docs-index.qmd-d6d880"></a>`docs/index.qmd`: the links to the guide. 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/62f48f0b9de6c97825153cd50a7f131a5c07b0c7/docs/index.qmd).
  - look at ``The pages under Guide explain the model. [The model](guide/model.qmd) gives the four ideas of `model.py`, and``

<a id="tut-24.4-docs-index.qmd-d6d880-diff"></a>

<details><summary>The diff of <code>docs/index.qmd</code></summary>

```diff
@@ -22,6 +22,9 @@ The code is in four modules:
 - `babykev.smoke` is the smoke run. `smoke()` asks the model every question of the sample data, and
   reports each answer beside its label.
 
+The pages under Guide explain the model. [The model](guide/model.qmd) gives the four ideas of `model.py`, and
+[the mask](guide/mask.qmd) draws the mask as a grid.
+
 Each build of the site makes the pages under Reference from the code. A page takes these parts from each
 function and each class:
 
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/62f48f0b9de6c97825153cd50a7f131a5c07b0c7). [The code after it](https://github.com/rahuldave/babykev/tree/62f48f0b9de6c97825153cd50a7f131a5c07b0c7).

<a id="tut-24.5"></a>

### 24.5 The README names the guide

The row of `docs/` in the table of the README names the two pages.

[± See the change to `README.md`](#tut-24.5-README.md-8ec9a0-diff)

In `README.md`, the row of `docs/` is on line 91.

```bash
just check
```

`just check` passes. The tests print `82 passed, 1 deselected`, and `Total coverage: 91.76%`. `just docs check` prints
`98 of 98`. It checks the docments of the code, and does not read the pages of the guide.

#### What changed

- <a id="tut-24.5-README.md-8ec9a0"></a>`README.md`: the guide, in the row of `docs/`. 1 line added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/41d24729682119b9bbb828187c5e9684a2921308/README.md).
  - look at ``The two pages of `docs/guide/` explain the model and its mask |``

<a id="tut-24.5-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -88,7 +88,7 @@ The tests must run at least 90% of the code. You can run `just check` yourself a
 | `tests/system/` | The test of the real model, marked `system`. `just test -m system` runs it |
 | `tests/conftest.py` | The fixtures that every test can ask for: the tiny tokenizer, a tiny model and a record |
 | `tests/tiny.py` | A small tokenizer and backbone, built in memory, in place of the real ones |
-| `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code |
+| `docs/` | The docs site. `just docs` builds it into `docs/_site`, with the reference made from the code. The two pages of `docs/guide/` explain the model and its mask |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `README.md` | This file |
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/commit/41d24729682119b9bbb828187c5e9684a2921308).

This part ends at the code at `tut-24`. [The code after this part](https://github.com/rahuldave/babykev/tree/tut-24)

<a id="tut-25"></a>

## 25 Two images

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-24`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-24)

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

[± See the new file `Dockerfile`](#tut-25.1-Dockerfile-6651dd-diff)

In the new file `Dockerfile`, the stage `uv` is on line 9, and the stage `build` on lines 13 to 25. The stage `run`
is on lines 28 to 36.

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

#### What changed

- <a id="tut-25.1-Dockerfile-6651dd"></a>`Dockerfile`: the stages `uv`, `build` and `run`. New, 36 lines. [The file](https://github.com/rahuldave/babykev/blob/570bb2134f032a64a34d14852c82fa1a199f69f6/Dockerfile).
  - look at `FROM python:3.13-slim-trixie AS run`

<a id="tut-25.1-Dockerfile-6651dd-diff"></a>

<details><summary>The diff of <code>Dockerfile</code></summary>

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

[± See the change to `Dockerfile`](#tut-25.2-Dockerfile-6651dd-diff)

In `Dockerfile`, the comment names the dev image on lines 5 and 6, and the stage `dev` is on lines 41 to 66. Line 64,
`COPY . .`, copies the folder of the project.

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

#### What changed

- <a id="tut-25.2-Dockerfile-6651dd"></a>`Dockerfile`: the stage `dev`. 31 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/40012bdfeb76ad96615227e9772d387ee5e48495/Dockerfile).
  - look at `FROM python:3.13-slim-trixie AS dev`

<a id="tut-25.2-Dockerfile-6651dd-diff"></a>

<details><summary>The diff of <code>Dockerfile</code></summary>

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

[± See the new file `.dockerignore`](#tut-25.3-.dockerignore-05a721-diff)

The new file `.dockerignore` names `.git` on line 3 and `.venv` on line 4, and twelve more paths.

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

#### What changed

- <a id="tut-25.3-.dockerignore-05a721"></a>`.dockerignore`: what a build never copies. New, 16 lines. [The file](https://github.com/rahuldave/babykev/blob/f0862402733db839738f0b350a049b2ee5e2a2aa/.dockerignore).
  - look at `.venv`

<a id="tut-25.3-.dockerignore-05a721-diff"></a>

<details><summary>The diff of <code>.dockerignore</code></summary>

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

[± See the change to `tests/conftest.py`](#tut-25.4-tests-conftest.py-626af3-diff)

In `tests/conftest.py`, the import is on line 10, the comment on lines 16 to 18, and the profile on lines 19 and 20.

```bash
sed -n '16,20p' tests/conftest.py
docker run --rm -v "$PWD":/work babykev-dev just test -q
```

pytest reads `conftest.py` before any test, so the profile holds for the whole run. The dev image runs the folder of
this Mac, so the change needs no new build. The tests print `82 passed, 1 deselected`.

#### What changed

- <a id="tut-25.4-tests-conftest.py-626af3"></a>`tests/conftest.py`: no deadline, for every test that hypothesis feeds. 7 lines added. [The file](https://github.com/rahuldave/babykev/blob/3043d160e0d6e424e7178bd6c86dfeb1aa17abb4/tests/conftest.py).
  - look at `settings.register_profile("babykev", deadline=None)`

<a id="tut-25.4-tests-conftest.py-626af3-diff"></a>

<details><summary>The diff of <code>tests/conftest.py</code></summary>

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

[± See the change to `justfile`](#tut-25.5-justfile-424f0b-diff)

In the `justfile`, the recipe `image` is on lines 36 to 67. `build` is on lines 47 to 52, `shell` on lines 53 to 61,
and `run` on lines 62 to 65.

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

#### What changed

- <a id="tut-25.5-justfile-424f0b"></a>`justfile`: the recipe `image`. 33 lines added. [The file](https://github.com/rahuldave/babykev/blob/a2cd7c083154e3f1161449592635e04b8f84cebe/justfile).
  - look at `image *args:`

<a id="tut-25.5-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

This change came from running `uv add --group lint hadolint-bin`.

`uv add` prints `Resolved 70 packages`, and installs hadolint-bin.

In `pyproject.toml`, the group `lint` has `"hadolint-bin>=2.15.1",` on line 44. `uv.lock` has its exact version.

```bash
uv run hadolint --version
```

It prints `Haskell Dockerfile Linter` and its version.

#### What changed

- <a id="tut-25.6-pyproject.toml-5d07e7"></a>`pyproject.toml`: hadolint, in the group `lint`. 1 line added. It comes from `uv add --group lint hadolint-bin`. [The file](https://github.com/rahuldave/babykev/blob/ce3646d2f0cdacf2177d9ba36355dd4ffc1b2f4a/pyproject.toml).
  - look at `"hadolint-bin>=2.15.1",`
- <a id="tut-25.6-uv.lock-8356d8"></a>`uv.lock`: the exact version of hadolint. 13 lines added. It comes from `uv add --group lint hadolint-bin`. [The file](https://github.com/rahuldave/babykev/blob/ce3646d2f0cdacf2177d9ba36355dd4ffc1b2f4a/uv.lock).

<a id="tut-25.6-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the change to `justfile`](#tut-25.7-justfile-424f0b-diff)

In the `justfile`, the comment on line 81 names the `Dockerfile`, and line 92 is `uv run hadolint Dockerfile`.

```bash
uv run hadolint Dockerfile
just lint-config
```

hadolint prints `Dockerfile:44 DL3008 warning: Pin versions in apt get install.`, and ends with exit code 1.
`just lint-config` stops on the same line. Line 44 is the `apt-get install` of the dev image, which names no version
of git. This finding is real, and nothing was broken to make it.

#### What changed

- <a id="tut-25.7-justfile-424f0b"></a>`justfile`: hadolint, in `lint-config`. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/fe092b54847ade1223f40297937fe59259096f68/justfile).
  - look at `    uv run hadolint Dockerfile`

<a id="tut-25.7-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[± See the change to `Dockerfile`](#tut-25.8-Dockerfile-6651dd-diff)

In `Dockerfile`, the reason is on lines 44 to 46, and `# hadolint ignore=DL3008` on line 47.

```bash
just lint-config
```

`just lint-config` passes. hadolint prints nothing.

#### What changed

- <a id="tut-25.8-Dockerfile-6651dd"></a>`Dockerfile`: the reason, and the line for hadolint. 4 lines added. [The file](https://github.com/rahuldave/babykev/blob/fd4dc51723462cdeaf072a4f2a18472a0cf6a645/Dockerfile).
  - look at `# hadolint ignore=DL3008`

<a id="tut-25.8-Dockerfile-6651dd-diff"></a>

<details><summary>The diff of <code>Dockerfile</code></summary>

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

[± See the change to `README.md`](#tut-25.9-README.md-8ec9a0-diff)

In `README.md`, the section is on lines 77 to 99, and the row on line 118.

The README says that every check passes in the dev image with no network. `--network none` gives the container no
network at all.

```bash
just image shell --network none -- just check
```

It fails before any check runs, with an error from uv. The dev image was built
before hadolint came into `uv.lock`, and `UV_LOCKED` makes uv install the packages of the lockfile first. An image
holds the packages of the lockfile at the time of its build.

```bash
just image build dev
just image shell --network none -- just check
```

`just check` passes in the new image, with no network. Every check of the gate is hermetic.

#### What changed

- <a id="tut-25.9-README.md-8ec9a0"></a>`README.md`: the section on the images, and the row of the `Dockerfile`. 24 lines added. [The file](https://github.com/rahuldave/babykev/blob/6c85dd08f3cd441259b3749ac38cceaf7f2392e0/README.md).
  - look at `## The images`

<a id="tut-25.9-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

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

## 26 GitHub

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-25`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-25)

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

[± See the new file `.github/workflows/check.yaml`](#tut-26.1-.github-workflows-check.yaml-6ceb50-diff)

The new file `.github/workflows/check.yaml` has `on` on lines 5 to 8, and what the job `check` runs on lines 16
to 21.

```bash
just lint-config
```

yamllint reads every YAML file, and the new file too. It prints `5:1 warning truthy value should be one of [false,
true] (truthy)`. `just lint-config` ends with exit code 2, because `--strict` makes a warning fail. YAML 1.1 reads the
word `on` as true. GitHub reads it as the name `on`, and every workflow has it. The next move answers it.

#### What changed

- <a id="tut-26.1-.github-workflows-check.yaml-6ceb50"></a>`.github/workflows/check.yaml`: `just check`, after every push. New, 21 lines. [The file](https://github.com/rahuldave/babykev/blob/2f210829183a3c52bb22f1196d50000716a4beec/.github/workflows/check.yaml).
  - look at `      - run: just check`

<a id="tut-26.1-.github-workflows-check.yaml-6ceb50-diff"></a>

<details><summary>The diff of <code>.github/workflows/check.yaml</code></summary>

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

[± See the change to `.yamllint`](#tut-26.2-.yamllint-dfe50a-diff)

In `.yamllint`, line 7 is `truthy: {check-keys: false}`, with its reason.

```bash
just lint-config
```

`just lint-config` passes.

#### What changed

- <a id="tut-26.2-.yamllint-dfe50a"></a>`.yamllint`: the rule `truthy` checks no key. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/7b7e22f04247cefdd2d01adbe6dff64d88a6116c/.yamllint).
  - look at `  truthy: {check-keys: false}  # a key may be a word such as on, which YAML 1.1 reads as true`

<a id="tut-26.2-.yamllint-dfe50a-diff"></a>

<details><summary>The diff of <code>.yamllint</code></summary>

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

This change came from running `uv add --group lint actionlint-py`.

`uv add` prints `Resolved 71 packages`, and installs actionlint-py.

In `pyproject.toml`, the group `lint` has `"actionlint-py>=1.7.12.25",` on line 44. `uv.lock` has its exact version.

```bash
uv run actionlint --version
```

The first line is the version of actionlint.

#### What changed

- <a id="tut-26.3-pyproject.toml-5d07e7"></a>`pyproject.toml`: actionlint, in the group `lint`. 1 line added. It comes from `uv add --group lint actionlint-py`. [The file](https://github.com/rahuldave/babykev/blob/bb15f17ccbb62cf1f8a61d67d67674bf9d445c86/pyproject.toml).
  - look at `"actionlint-py>=1.7.12.25",`
- <a id="tut-26.3-uv.lock-8356d8"></a>`uv.lock`: the exact version of actionlint. 8 lines added. It comes from `uv add --group lint actionlint-py`. [The file](https://github.com/rahuldave/babykev/blob/bb15f17ccbb62cf1f8a61d67d67674bf9d445c86/uv.lock).

<a id="tut-26.3-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

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

[± See the change to `justfile`](#tut-26.4-justfile-424f0b-diff)

In the `justfile`, the comment on line 81 names the workflows, and line 93 is `uv run actionlint`.

```bash
uv run actionlint
just lint-config
```

actionlint prints nothing, and ends with exit code 0. It finds no problem in `check.yaml`. `just lint-config` passes.

#### What changed

- <a id="tut-26.4-justfile-424f0b"></a>`justfile`: actionlint, in `lint-config`. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/eb0acd148867bdbc6292660b7268b656074fb727/justfile).
  - look at `    uv run actionlint`

<a id="tut-26.4-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

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

[± See the new file `.github/workflows/docs.yaml`](#tut-26.5-.github-workflows-docs.yaml-ce7835-diff)

In the new file `.github/workflows/docs.yaml`, `on` is on lines 6 to 9, and `permissions` on lines 11 to 14. Line 26
renders the site with the group `docs` alone.

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

#### What changed

- <a id="tut-26.5-.github-workflows-docs.yaml-ce7835"></a>`.github/workflows/docs.yaml`: the docs site, built with the group `docs` alone, then published. New, 40 lines. [The file](https://github.com/rahuldave/babykev/blob/606da22657c965404206b25f8fbcccffbe3f2756/.github/workflows/docs.yaml).
  - look at `      - run: uv run --locked --no-default-groups --group docs smalldocs render docs`

<a id="tut-26.5-.github-workflows-docs.yaml-ce7835-diff"></a>

<details><summary>The diff of <code>.github/workflows/docs.yaml</code></summary>

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

[± See the change to `README.md`](#tut-26.6-README.md-8ec9a0-diff)

In `README.md`, the section is on lines 100 to 112, and the row on line 135.

```bash
just check
```

`just check` passes. The tests print `82 passed, 1 deselected`, and `Total coverage: 91.76%`. The last lines of
`lint-config` print nothing, because yamllint, hadolint and actionlint find nothing.

#### What changed

- <a id="tut-26.6-README.md-8ec9a0"></a>`README.md`: the section on GitHub, and the row of the workflows. 14 lines added. [The file](https://github.com/rahuldave/babykev/blob/88854e32ebcb4647672742cc4ef709eefc5fde0c/README.md).
  - look at `## On GitHub`

<a id="tut-26.6-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

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
