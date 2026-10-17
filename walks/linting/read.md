<!-- Made by the walk skill's render.py from the facts of the walk. Do not edit it by hand: run just walk-update again. -->

# The formatter, the linter and the type checker of babykev

**Read the tutorial.** Each change explained, with the code to look at. [Build it yourself](build.md) is the other way to read it.

Each part ends with a section called **What changed**. It lists every file that the part changes, with a link to the file, and then the whole diff of each file, folded. A lockfile and a binary file have a link alone. The text above it explains the change.

We check the code of babykev, a small decision model. babykev reads a text and a set of questions about it, and
gives a probability for every answer.

Code that works can still be hard to read, and a reader can miss a bug in it. A formatter writes every file in one
style. A linter checks the code against rules, and a type checker checks the types that the code declares. ruff is
the formatter and the linter, and ty is the type checker. pre-commit then runs every check before each
`git commit`.

This tutorial takes these parts out of the whole tutorial of babykev. It leaves out the parts that build the
project, its tests, its docs and its model. Where it skips changes of the whole tutorial, the next section says what
they did, and begins from their code. It first runs `just setup`, which installs the packages of that code.

We make the project in moves. A move is one small change, made by one patch or by one command. A patch changes a
file, and a command such as `uv add` writes the files it needs. In watch mode, each move is already made, and the
text says what it did and where to look.

This tutorial has eight sections:

1. **Where we start**
2. **Format**
3. **Lint**
4. **Types in every signature**
5. **Docstrings**
6. **The gate and the hook**
7. **The config files, checked**
8. **The type checker**

<a id="tut-00"></a>

## 0 Where we start

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part is where the project starts, at `tut-00`. [The code of this part](https://github.com/rahuldave/babykev/tree/tut-00)

The first section shows the folder of babykev before it holds any code.

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

<a id="tut-07.1-to-tut-07.5"></a>

## 7.1 to 7.5 Format

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-06`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-06)

```bash
just setup
```

The whole tutorial then makes babykev a Python project with uv. It has a command, `babykev`, in
`src/babykev/cli.py`, and a `justfile` with the recipes `setup`, `help` and `test`. pytest runs the tests, from the
dependency group `test`, and measures the coverage.

`src/babykev/api.py` is the contract, the rules for what a request and an answer hold. A request has questions of
three types, and pydantic, a library that checks data, checks each request. Two tests find two bugs in `api.py`, and
two changes fix them. `just test` prints `53 passed`, and the coverage is 100%.

`just setup` prints `Resolved 14 packages`. The tests check what the code does, and nothing checks how it looks.
`api.py` has a style of its own. Some lines hold an `if` and its `return` together, and some lines run past 200
characters. ruff comes in, then its settings and the recipe `fmt`, and the formatter rewrites `api.py`.

<a id="tut-07.1"></a>

### 7.1 Ruff, in the group lint

Nothing formats the code yet. ruff is a formatter and a linter in one program. The formatter changes how the code
looks, and never what it does. The linter comes in the next part of the tutorial. ruff is for working on babykev,
and a user of the package does not need it. So it goes in a second dependency group, `lint`, next to the group
`test`.

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

A patch to [`pyproject.toml`](#tut-07.2-pyproject.toml-5d07e7).

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

A patch to [`pyproject.toml`](#tut-07.3-pyproject.toml-5d07e7).

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

A patch to [`justfile`](#tut-07.4-justfile-424f0b).

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

A patch to [`pyproject.toml`](#tut-08.1-pyproject.toml-5d07e7).

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

A patch to [`pyproject.toml`](#tut-08.2-pyproject.toml-5d07e7).

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

A patch to [`justfile`](#tut-08.3-justfile-424f0b).

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

A patch to [`src/babykev/api.py`](#tut-08.4-src-babykev-api.py-2ea65f).

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

A patch to [`src/babykev/api.py`](#tut-08.5-src-babykev-api.py-2ea65f).

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

A patch to [`src/babykev/api.py`](#tut-08.6-src-babykev-api.py-2ea65f).

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

A patch to [`src/babykev/api.py`](#tut-08.7-src-babykev-api.py-2ea65f).

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

A patch to [`pyproject.toml`](#tut-09.1-pyproject.toml-5d07e7).

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

A patch to [`src/babykev/api.py`](#tut-09.2-src-babykev-api.py-2ea65f).

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

A patch to [`src/babykev/api.py`](#tut-09.3-src-babykev-api.py-2ea65f).

A patch to [`tests/unit/test_api.py`](#tut-09.3-tests-unit-test_api.py-58d97c).

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

A patch to [`tests/unit/test_cli.py`](#tut-09.4-tests-unit-test_cli.py-44d4a0).

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

A patch to [`tests/unit/test_api.py`](#tut-09.5-tests-unit-test_api.py-58d97c).

A patch to [`tests/unit/test_cli.py`](#tut-09.5-tests-unit-test_cli.py-44d4a0).

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

A patch to [`tests/unit/test_cli.py`](#tut-09.6-tests-unit-test_cli.py-44d4a0).

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

A patch to [`pyproject.toml`](#tut-10.1-pyproject.toml-5d07e7).

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

A patch to [`src/babykev/__init__.py`](#tut-10.2-src-babykev-__init__.py-a40393).

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

A patch to [`src/babykev/api.py`](#tut-10.3-src-babykev-api.py-2ea65f).

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

A patch to [`src/babykev/api.py`](#tut-10.4-src-babykev-api.py-2ea65f).

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

A patch to [`justfile`](#tut-11.1-justfile-424f0b).

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

A patch to [`.pre-commit-config.yaml`](#tut-11.3-.pre-commit-config.yaml-e7d14d).

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

A patch to [`justfile`](#tut-11.4-justfile-424f0b).

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

A patch to [`.pre-commit-config.yaml`](#tut-11.5-.pre-commit-config.yaml-e7d14d).

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

A patch to [`.pre-commit-config.yaml`](#tut-11.6-.pre-commit-config.yaml-e7d14d).

In `.pre-commit-config.yaml`, line 12 is the new hook, `- id: check-merge-conflict`.

```bash
uv run pre-commit run --all-files
```

pre-commit prints three lines, each `Passed`. The new one is `check for merge conflicts`.

#### What changed

- <a id="tut-11.6-.pre-commit-config.yaml-e7d14d"></a>`.pre-commit-config.yaml`: the hook of merge conflicts. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/64d0f4f781da1a8520315f899c4231645623280c/.pre-commit-config.yaml).
  - look at `      - id: check-merge-conflict`

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

A patch to [`.pre-commit-config.yaml`](#tut-11.7-.pre-commit-config.yaml-e7d14d).

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

A patch to [`src/babykev/cli.py`](#tut-11.8-src-babykev-cli.py-a9e184).

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

A patch to [`src/babykev/cli.py`](#tut-11.9-src-babykev-cli.py-a9e184).

In `src/babykev/cli.py`, `import sys` is on line 3 again.

```bash
uv run pre-commit run --all-files
```

The four hooks pass or skip, and pre-commit ends with exit code 0. A `git commit` would now record the change.

#### What changed

- <a id="tut-11.9-src-babykev-cli.py-a9e184"></a>`src/babykev/cli.py`: the import of `os` goes. 0 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/054c40b6cc1839f8b35dfab81f9f2ae7c9f1aaf0/src/babykev/cli.py).
  - look at `import os`

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

A patch to [`README.md`](#tut-11.10-README.md-8ec9a0).

In `README.md`, the new paragraph is on lines 61 to 63, and the row of `.pre-commit-config.yaml` is on line 79.

```bash
grep -n 'just hook' README.md
```

`grep` prints line 61, the first line of the paragraph, and line 79, the row of the table.

#### What changed

- <a id="tut-11.10-README.md-8ec9a0"></a>`README.md`: a paragraph on `just hook`, and a row of the table. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/cab87c139ebd3b72771ed6db08b02dd7646c7d02/README.md).
  - look at ``Run `just hook` once in each clone. It installs a git hook, which runs `just check` before each commit.``

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

## 12 The config files, checked

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

A patch to [`justfile`](#tut-12.2-justfile-424f0b).

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

A patch to [`justfile`](#tut-12.3-justfile-424f0b).

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

A patch to [`justfile`](#tut-12.4-justfile-424f0b).

Near the top of the `justfile`, `export UV_LOCKED := "1"` is on line 9, under its comment.

```bash
just --evaluate UV_LOCKED
```

It prints `1`. `just` puts the variable in the environment of each command of each recipe, so every `uv run` of a
recipe sees it.

#### What changed

- <a id="tut-12.4-justfile-424f0b"></a>`justfile`: one line, which exports `UV_LOCKED` to every recipe. 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/9f70971667e9a2fc6cbc1767fe58061ad9f26e22/justfile).
  - look at `export UV_LOCKED := "1"`

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

A patch to [`justfile`](#tut-12.5-justfile-424f0b).

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

A patch to [`justfile`](#tut-12.7-justfile-424f0b).

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

A patch to [`.yamllint`](#tut-12.8-.yamllint-dfe50a).

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

A patch to [`.yamllint`](#tut-12.9-.yamllint-dfe50a).

In `.yamllint`, `rules:` is on line 4, and line 5 is `document-start: disable`, with a comment.

```bash
uv run yamllint --strict .
```

yamllint finds four problems, and ends with exit code 1. The four are the lines too long, lines 1, 4 and 17 of
`.pre-commit-config.yaml`, and line 3 of `.yamllint`. The warnings are gone.

#### What changed

- <a id="tut-12.9-.yamllint-dfe50a"></a>`.yamllint`: the rule `document-start`, off. 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/44f6865153ebeff1c321b4da65ace21285161796/.yamllint).
  - look at `  document-start: disable  # a file need not start with a line of three dashes`

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

A patch to [`.yamllint`](#tut-12.10-.yamllint-dfe50a).

In `.yamllint`, line 6 is `line-length: {max: 100}`, with a comment.

```bash
just lint-config
```

yamllint prints nothing, and `just lint-config` passes. It prints `Valid file: pyproject.toml` and
`Resolved 29 packages`, and ends with exit code 0.

#### What changed

- <a id="tut-12.10-.yamllint-dfe50a"></a>`.yamllint`: lines of up to 100 characters. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/063c1a9ec17bea160da66c14711bb87eb1f54ddb/.yamllint).
  - look at `  line-length: {max: 100}  # as long as a line of the Python code`

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

A patch to [`justfile`](#tut-12.11-justfile-424f0b).

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

A patch to [`README.md`](#tut-12.12-README.md-8ec9a0).

In `README.md`, the row of `.yamllint` is on line 80, the last row of the table.

```bash
grep -n yamllint README.md
```

`grep` prints line 80, the new row.

#### What changed

- <a id="tut-12.12-README.md-8ec9a0"></a>`README.md`: a row for `.yamllint`. 1 line added. [The file](https://github.com/rahuldave/babykev/blob/cbbf9bedfc2ba814fc979c43fd2770f5464e3aac/README.md).
  - look at ``| `.yamllint` | The settings of yamllint, which `just lint-config` runs on every YAML file |``

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

<a id="tut-17.1-to-tut-17.5"></a>

## 17.1 to 17.5 The type checker

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-16`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-16)

```bash
just setup
```

The whole tutorial then documents the code. smalldocs, in a third dependency group, `docs`, reads the docstrings
and the docments, the comments beside each parameter. `just docs check` lists what has no documentation, and the
gate runs it. `just docs` builds a site from the docs.

Then come the four packages of the model, torch, transformers, peft and safetensors. torch is the build for the CPU,
from PyTorch's own index. Last, `src/babykev/model.py` comes in, the model, 274 lines. It passes the format, the
linter and the docs check. No test runs it yet, so the coverage falls to 43%.

`just setup` prints `Resolved 66 packages`. `model.py` has a type on every parameter and every return, because the
linter asks for them. Nothing checks that the types are right. ty reads the code, and compares each call and each
value with the types that the code and its libraries declare.

<a id="tut-17.1"></a>

### 17.1 ty, in the group lint

ty is for working on babykev, so it goes in the group `lint`.

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

A patch to [`justfile`](#tut-17.2-justfile-424f0b).

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

A patch to [`src/babykev/model.py`](#tut-17.3-src-babykev-model.py-a86a0b).

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

A patch to [`src/babykev/model.py`](#tut-17.4-src-babykev-model.py-a86a0b).

In `src/babykev/model.py`, the reason is on line 259, and line 260 is
`def forward(  # ty: ignore[invalid-mutable-override]`.

```bash
just types
```

`just types` prints `All checks passed!`, and ends with exit code 0.

#### What changed

- <a id="tut-17.4-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: the rule off on the `forward` of `DecisionModel`, with the reason. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/f14349138824af0b107742451814b1234e72b34a/src/babykev/model.py).
  - look at `    # As in PointerHead, nn.Module declares forward as an attribute, and torch never sets it`

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

A patch to [`justfile`](#tut-17.5-justfile-424f0b).

In the `justfile`, `just types` is line 81, between `just lint` and `just test -q`. The comment on line 72 names the
types.

```bash
just --show check
just check
```

`just --show check` prints the recipe, with six checks. `just check` prints `All checks passed!` twice, once for the
linter and once for ty. Then come `53 passed`, the total of 43%, `60 of 60` and the config files, and it ends with
exit code 0. A call that does not match the types now stops `git commit`.

This tutorial ends here. After it, the whole tutorial runs the model and gives it tests, and the gate gets a floor
on the coverage. The [whole tutorial](https://github.com/rahuldave/babykev/tree/tutorial) has every change.

#### What changed

- <a id="tut-17.5-justfile-424f0b"></a>`justfile`: ty, in the gate. 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/d4dd1c8d3d3c94aa391b3baff5c5aab706b149b9/justfile).
  - look at `    just types`

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
