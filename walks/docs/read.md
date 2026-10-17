<!-- Made by the walk skill's render.py from the facts of the walk. Do not edit it by hand: run just walk-update again. -->

# The documentation of babykev

**Read the tutorial.** Each change explained, with the code to look at. [Build it yourself](build.md) is the other way to read it.

Each part ends with a section called **What changed**. It lists every file that the part changes, with a link to the file, and then the whole diff of each file, folded. A lockfile and a binary file have a link alone. The text above it explains the change.

We document babykev, a small decision model. babykev reads a text and a set of questions about it, and gives a
probability for every answer. A person who reads the project on GitHub needs to know what it is, and where each part
is. A person who calls the code needs to know what each function does, and what each parameter means. A person who
wants to know why the model is built as it is needs a page of prose.

This tutorial takes the parts about documentation out of the
[whole tutorial](https://rahuldave.com/babykev-walk/) of babykev. It starts from the README, before any code. The
docstrings come when the code has tests and a linter. The rest of the documentation comes after them.

We make the project in moves. A move is one small change, made by one patch or by one command. A patch changes a
file, and a command such as `uv add` writes the files it needs. You make each move, and the page checks your files
against it.

This tutorial has seven sections:

1. **The README, before any code**
2. **The README says how to begin**
3. **Docstrings**
4. **Documentation in the code**
5. **The docs site**
6. **The guide to the model**
7. **The docs on GitHub Pages**

Some changes of the whole tutorial are not in this one. After such a gap, the next section says what those changes
did, and begins from the code that they left. It first runs `just setup`, which installs the packages of that code.

**Kinds of documentation**

The table gives each kind of documentation, and the sections where it appears.

| Kind | Who reads it, and what it says | Where |
|---|---|---|
| README | A reader on GitHub. What babykev is, how to begin, and where each part is | Sections 1, 2, 5, 6 and 7 |
| Docstring | What a module, a class or a function is for | Section 3 |
| Docment | What each parameter, field and return is | Section 4 |
| Docs check | Counts what is documented, and names each gap. From section 4, each `git commit` must pass it | Section 4 |
| Reference | A person who calls the code. smalldocs makes it from the docstrings and the docments | Sections 4 and 5 |
| A written page | What babykev is, on the front page of the site, and why the model is built as it is, in the guide | Sections 5 and 6 |
| A published site | The site, on GitHub Pages, built again after every push to `main` | Section 7 |

Two tools run everything here. [uv](https://docs.astral.sh/uv/) manages the project. It installs Python and the packages, keeps them in `.venv`, and pins their versions in `uv.lock`. [just](https://just.systems/) runs the tasks of the project by name, from the recipes of its `justfile`. `just setup`, for example, runs `uv sync`.

<a id="tut-00"></a>

## 0 The README, before any code

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part is where the project starts, at `tut-00`. [The code of this part](https://github.com/rahuldave/babykev/tree/tut-00)

The first documentation of a project is its README. Here babykev is only words. There is the README, the licence, the
notice and `.gitignore`.

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

<a id="tut-01.13-to-tut-01.14"></a>

## 1.13 to 1.14 The README says how to begin

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `9218f21a7842`, partway through `tut-01`. [The code before this part](https://github.com/rahuldave/babykev/tree/9218f21a784277593cf6930e10389b04e41bf9d0)

```bash
just setup
```

The whole tutorial makes babykev a Python project before the README grows. uv is the tool that installs Python and
the packages that babykev needs. `uv init` makes `pyproject.toml`, the file that describes the project, and the folder
of the code, `src/babykev/`. `uv lock` writes `uv.lock`, the lockfile, which lists the exact version of each package.
`pyproject.toml` gets a description, a licence and an author.

`src/babykev/cli.py` gives the command `babykev` a help text, which says what babykev is and how to use it.
`uv run babykev help` prints it. A `justfile` names the tasks of the project, as recipes. `just setup` installs the project,
and `just help VERB` explains a recipe.

The description and the help are documentation too, for a person who installs babykev or runs it. The README now says
how to begin, and what each file is.

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

<a id="tut-10"></a>

## 10 Docstrings

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-09`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-09)

The whole tutorial then gives babykev its code and its checks. `src/babykev/api.py` is the contract, the rules for
what a request and an answer hold. Its class `SystemOneRequest` is a request, which holds a state and its questions.
The classes `Noul`, `Choice` and `Score` are the three types of question. A noul has the answer yes or no, a choice
picks one option, and a score picks a level on a scale.

The functions of `api.py`, from `render` to `to_answers`, turn a request into the text that the model reads. They
also turn the probabilities of the model into answers. The tests are in `tests/unit/`, and `just test` runs them with
pytest. Each run also measures coverage, the share of the lines of the code that the tests run.

ruff formats the code, through `just fmt`, and lints it, through `just lint`. To lint is to check the code against a
list of rules. The families of rules are in the list `select` of `pyproject.toml`. The last of them, `ANN`, asks for a
type on every parameter and every return. The README names each new file in its table.

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

<a id="tut-13"></a>

## 13 Documentation in the code

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-12`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-12)

The whole tutorial then adds a gate. `just check` runs every check, one after another, and stops at the first that
fails. `just hook` installs a git hook, a script that git runs before each `git commit`, and the hook runs
`just check`. `just lint-config` checks the config files, `pyproject.toml`, the lockfile, the `justfile` and every
YAML file, and the gate runs it too.

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

So far, `just docs module api` prints the reference of `api.py` as text in the terminal. This section builds a
website from it, with a front page written by hand.

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

<a id="tut-24"></a>

## 24 The guide to the model

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `tut-23`. [The code before this part](https://github.com/rahuldave/babykev/tree/tut-23)

The whole tutorial then builds the model, and tests it. The project adds four packages for the model, torch,
transformers, peft and safetensors. `src/babykev/model.py` holds the model. ty checks the types, through
`just types`. `src/babykev/smoke.py` runs the real model on the sample data, through `just smoke`.

The model reads text as tokens, which are small pieces of words. `encode` packs the state and its questions into one
sequence of tokens. `branch_mask` builds the mask, a table that says which tokens the model may look at while it
reads each token.

The tests of the model run on a tiny model, in `tests/tiny.py`. `tests/conftest.py` holds the fixtures, the objects
that a test gets ready-made, such as the tiny model and a record. The gate asks
the tests to run at least 90% of the code. `tests/unit/test_mask.py` draws the mask of a small request as a picture.
It found a bug in the mask, which is now fixed. A test of the real model is marked `system`, and `just test` leaves
it out.

The site now has a page of reference for each of `api.py`, `cli.py`, `model.py` and `smoke.py`. The front
page and the README name the model and the smoke.

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

<a id="tut-26.5-to-tut-26.6"></a>

## 26.5 to 26.6 The docs on GitHub Pages

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `eb0acd148867`, partway through `tut-26`. [The code before this part](https://github.com/rahuldave/babykev/tree/eb0acd148867bdbc6292660b7268b656074fb727)

```bash
just setup
```

The whole tutorial then adds a `Dockerfile`, which builds two images. An image of Docker is a Linux machine that one
file describes. The run image starts `babykev`, and the dev image holds the whole project and the tools to work on
it. The recipe `just image` builds them, and `just lint-config` now runs hadolint, a linter of the `Dockerfile`.

The site is only on the machine that builds it. GitHub runs workflows on its own machines. A workflow is a file of
YAML in `.github/workflows/`, and its key `on` names the events that start it. The first workflow, `check.yaml`, runs
`just setup` and `just check` after every push. yamllint refused the key `on`, because YAML 1.1 reads the word `on`
as the value true. Its settings now let a key be such a word.

The project adds actionlint, a linter of the workflows of GitHub, to its other linters, and `just lint-config` runs
it. The second workflow builds the site and publishes it.

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

This tutorial ends here. The [whole tutorial](https://rahuldave.com/babykev-walk/) has every change.

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
