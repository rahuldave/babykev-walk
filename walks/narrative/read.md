<!-- Made by the walk skill's render.py from the facts of the walk. Do not edit it by hand: run just walk-update again. -->

# The lecture, as given

**Read the tutorial.** Each change explained, with the code to look at.

Each part ends with a section called **What changed**. It lists every file that the part changes, with a link to the file, and then the whole diff of each file, folded. A lockfile and a binary file have a link alone. The text above it explains the change.

The first lecture walks through babykev on its branch `main`, from `step-00` to `step-05b`. Each step is one
commit, with no moves between the steps. The tutorial, on the branch `tutorial`, builds the same project again
one move at a time.

<a id="step-00"></a>

## 0 Where we start

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part is where the project starts, at `step-00`. [The code of this part](https://github.com/rahuldave/babykev/tree/step-00)

**The first three slides.** No commands. The title, SOFTWARE DEVELOPMENT FOR MACHINE LEARNING, with Rahul Dave's name under it. Then the worried Pavlos, the cartoon, with a hand raised: he is worried about this lecture. Then a picture of Rahul, in a T-shirt that says "You're Absolutely Right!". After them the first slide of the talk, "What goes into a machine-learning project?". The pictures are `walks/narrative/slides/pictures/pavlos-worried.png` and `walks/narrative/slides/pictures/rahul.jpg`.

**Init.** The environment is made by uv, before any recipe. `uv sync --locked` reads `pyproject.toml` and `uv.lock` and makes `.venv` with exactly what the lockfile says: Python 3.13 from `.python-version`, and babykev alone, editable. It prints `Resolved 1 package` and what it installed (or `Checked 1 package` when the venv already matches). `--locked` means: refuse if the lockfile is out of date with `pyproject.toml`, never re-lock on the quiet.

```bash
uv sync --locked
```

**The recipe.** `just --show setup` prints the recipe behind the word: one line, `uv sync --locked`, inside an `if` that answers `help`. That is the whole trick of the justfile: a verb on the left, the command on the right, and `just` lists the verbs. `just setup` runs it again and prints `Checked 1 package`: nothing to do, because it was just done. From now on, `just setup`.

```bash
just --show setup
just setup
```

**What is here.** A README, the licence and its notice, `pyproject.toml` with no dependencies, a justfile with `setup` and `help`, and a `babykev` command whose only word is `help`. No code of kev's yet. kev's code comes in one file at a time, at the step that needs it, and we rebuild each file as it arrives.

**The justfile is the interface.** `just` lists every task; `just help VERB` or `just VERB help` explains one; a recipe wraps one command.

```bash
just
just help setup
```

**How a recipe gets its words.** In `just help setup`, `setup` is a word for the recipe `help`. Line 6 of the justfile, `set positional-arguments`, makes just give each word to the recipe's commands whole: the first as `"$1"`, the second as `"$2"`, all of them as `"$@"`. `help` uses `"$1"`: `just help setup` runs `just --show "$1"` with `$1` set to `setup`. A word is never pasted into a command as text, so a space, a quote or a `*` inside it stays part of the word.

```bash
sed -n '5,6p' justfile
```

**The command.** `babykev help` prints the help; any other word is refused with exit code 2. The two lines under `[project.scripts]` in `pyproject.toml` are what make `babykev` a command: a name on the left, a function on the right.

```bash
uv run babykev help
uv run babykev train
cat pyproject.toml
```

**`.gitignore`** is complete from the first commit: nothing a run writes will ever show up as a stray file.

### What changed

- <a id="step-00-.gitignore-a5cc29"></a>`.gitignore`: New, 57 lines. [The file](https://github.com/rahuldave/babykev/blob/ee96429002cd04cb95e86e9a77e9c3d02a0e9497/.gitignore).
- <a id="step-00-.python-version-7696e9"></a>`.python-version`: New, 1 line. [The file](https://github.com/rahuldave/babykev/blob/ee96429002cd04cb95e86e9a77e9c3d02a0e9497/.python-version).
- <a id="step-00-LICENSE-0398cc"></a>`LICENSE`: New, 202 lines. [The file](https://github.com/rahuldave/babykev/blob/ee96429002cd04cb95e86e9a77e9c3d02a0e9497/LICENSE).
- <a id="step-00-NOTICE-fe7187"></a>`NOTICE`: New, 8 lines. [The file](https://github.com/rahuldave/babykev/blob/ee96429002cd04cb95e86e9a77e9c3d02a0e9497/NOTICE).
- <a id="step-00-README.md-8ec9a0"></a>`README.md`: New, 80 lines. [The file](https://github.com/rahuldave/babykev/blob/ee96429002cd04cb95e86e9a77e9c3d02a0e9497/README.md).
- <a id="step-00-justfile-424f0b"></a>`justfile`: adds `recipe default`, `recipe help`, `recipe setup`. New, 26 lines. [The file](https://github.com/rahuldave/babykev/blob/ee96429002cd04cb95e86e9a77e9c3d02a0e9497/justfile).
- <a id="step-00-pyproject.toml-5d07e7"></a>`pyproject.toml`: New, 17 lines. [The file](https://github.com/rahuldave/babykev/blob/ee96429002cd04cb95e86e9a77e9c3d02a0e9497/pyproject.toml).
- <a id="step-00-src-babykev-__init__.py-a40393"></a>`src/babykev/__init__.py`: New, 0 lines. [The file](https://github.com/rahuldave/babykev/blob/ee96429002cd04cb95e86e9a77e9c3d02a0e9497/src/babykev/__init__.py).
- <a id="step-00-src-babykev-cli.py-a9e184"></a>`src/babykev/cli.py`: adds `main`. New, 21 lines. [The file](https://github.com/rahuldave/babykev/blob/ee96429002cd04cb95e86e9a77e9c3d02a0e9497/src/babykev/cli.py).
- <a id="step-00-uv.lock-8356d8"></a>`uv.lock`: New, 8 lines. [The file](https://github.com/rahuldave/babykev/blob/ee96429002cd04cb95e86e9a77e9c3d02a0e9497/uv.lock).

<a id="step-00-.gitignore-a5cc29-diff"></a>

<details><summary>The diff of <code>.gitignore</code></summary>

```diff
@@ -0,0 +1,57 @@
+# Nothing a run produces is tracked. This list is complete from the first commit, so a run's output
+# never shows up as a stray file, whichever step of the history is checked out.
+
+# Experiment tracking: the MLflow store and its artifacts
+mlflow.db
+mlflow.db-*
+mlartifacts/
+mlruns/
+
+# The general training data and the later batches, when they are built here: made from datasets
+# with their own licences
+/data/general/
+/data/later/
+
+# Checkpoints, predictions and reports
+/runs/
+/checkpoints/
+/predictions/
+/reports/
+*.safetensors
+*.ckpt
+*.pt
+
+# Settings for one machine. .env.example is the committed list of them
+.env
+.env.*
+!.env.example
+
+# The built docs site and its generated reference pages
+/docs/_site/
+/docs/.quarto/
+/docs/api/
+/docs/_symbols.json
+/.quarto/
+
+# Python
+__pycache__/
+*.py[cod]
+.venv/
+*.egg-info/
+/build/
+/dist/
+
+# Tool caches
+.ruff_cache/
+.pytest_cache/
+.hypothesis/
+.coverage
+.coverage.*
+htmlcov/
+.ipynb_checkpoints/
+
+# Logs, operating systems, editors
+*.log
+.DS_Store
+.idea/
+.vscode/
```

</details>

<a id="step-00-.python-version-7696e9-diff"></a>

<details><summary>The diff of <code>.python-version</code></summary>

```diff
@@ -0,0 +1 @@
+3.13
```

</details>

<a id="step-00-LICENSE-0398cc-diff"></a>

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

<a id="step-00-NOTICE-fe7187-diff"></a>

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

<a id="step-00-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

````diff
@@ -0,0 +1,80 @@
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
+There are three types of question:
+
+| Type | Asks for | The answer holds |
+|---|---|---|
+| `noul` | Yes or no | The probability of yes |
+| `choice` | One of several named options | The chosen option, a probability for each option, and a confidence |
+| `score` | A level on an ordered scale | The expected level, a probability for each level, and a confidence |
+
+## Where it comes from
+
+babykev is derived from the first commit of [kev](https://github.com/jaredpalmer/kev/tree/d0e2b1fc4f9e410137b6b4ab7f7153fc52868a16)
+by Jared Palmer. That commit is about 830 lines of Python around one idea: a small language model
+(Qwen2.5-0.5B with a LoRA adapter) reads the state and the questions as one sequence, an attention mask
+keeps each question from seeing the others, and a pointer head scores every option.
+
+This is an educational repo. The repo `babykev` keeps the original model but rebuilds the engineering around it: packaging, tests, types, docs, training, experiment tracking, and simple inference on the command line. The idea is to expose to a student the infrastructural and software development aspects of, for now, training a model.
+
+## What you need
+
+Three tools on the machine. This project installs everything else itself.
+
+| Tool | What it is for |
+|---|---|
+| [uv](https://docs.astral.sh/uv/) | Python itself, the dependencies, and running the program |
+| [just](https://just.systems/) | The project's tasks. `just` lists them |
+| [Quarto](https://quarto.org/) | The docs site |
+
+Then `just setup`. `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is
+the program's own help.
+
+## What is here
+
+| Path | What it is |
+|---|---|
+| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, and the exact versions installed |
+| `src/babykev/` | The code. `cli.py` is the `babykev` command |
+| `justfile` | Every task of the project, one recipe each. `just help` explains them |
+| `LICENSE`, `NOTICE` | The licence, and the credit to kev |
+| `.python-version` | The Python version the project uses |
+| `.gitignore` | Everything a training run will write, ignored from the first commit on |
+
+## How the history is organised
+
+The project is built in steps. Each step is one commit on `main` with a tag, `step-00`, `step-01` and so
+on, and the tag's message says what the step adds.
+
+```
+git tag -n1 --list 'step-*'     # the steps, one line each
+git show step-00                # a step's full note, and what it changed
+git switch --detach step-00     # the project as it was at that step
+```
+
+## Licence
+
+Apache-2.0: see [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE). The original project kev's first commit carried no licence file; kev became Apache-2.0 three commits later.
````

</details>

<a id="step-00-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

```diff
@@ -0,0 +1,26 @@
+# babykev: every task is a recipe here. `just` lists them; `just help VERB` explains one.
+
+program := "babykev"
+
+# Each word after a recipe's name reaches its commands whole, as "$1", "$2" and so on; "$@" is all of them
+set positional-arguments
+
+[private]
+default:
+    @just --list --unsorted
+
+# Explain a verb: its line, and the program's flags where the program has them. Alone, the list
+[no-exit-message]
+help *verb:
+    #!/usr/bin/env sh
+    if [ "$#" -eq 0 ]; then just --list --unsorted; exit 0; fi
+    shown=$(just --show "$1") || exit 1
+    printf '%s\n' "$shown" | head -1 | sed 's/^# //'
+    if printf '%s\n' "$shown" | grep -qF '{{ "{{ program }}" }} '"$1"; then
+        uv run {{ program }} "$1" help
+    fi
+
+# Install Python and every dependency into .venv, exactly as the lockfile says
+[group('setup')]
+setup *args:
+    @{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
```

</details>

<a id="step-00-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -0,0 +1,17 @@
+[project]
+name = "babykev"
+version = "0.1.0"
+description = "A small decision model: one state, typed questions, a probability for every answer"
+readme = "README.md"
+license = "Apache-2.0"
+license-files = ["LICENSE", "NOTICE"]
+authors = [{ name = "Rahul Dave" }]
+requires-python = ">=3.13"
+dependencies = []
+
+[project.scripts]
+babykev = "babykev.cli:main"
+
+[build-system]
+requires = ["uv_build>=0.12.13,<0.13.0"]
+build-backend = "uv_build"
```

</details>

<a id="step-00-src-babykev-cli.py-a9e184-diff"></a>

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

<a id="step-01"></a>

## 1 The contract, and its tests

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `step-00`. [The code before this part](https://github.com/rahuldave/babykev/tree/step-00)

**Init.** `just setup` adds 13 packages: pydantic and pydantic-core, pytest, pytest-cov and coverage, and their dependencies. `.venv` goes from 1 package to 14.

```bash
just setup
```

**What is new:** `src/babykev/api.py`, kev's file as it was, less its serving parts (the request's `model` field, `output_tokens`); five labelled requests in `data/cheese/sample.jsonl`; `tests/unit/test_api.py` and `test_cli.py`; pydantic, pytest and pytest-cov; the `test` recipe.

**Start from the data.** One line is a request about a cheese, with a `label` on every question. The five lines are test data, kept in the repository so the tests can read them; they are not the students' data, which comes with training.

```bash
head -n 1 data/cheese/sample.jsonl | python3 -m json.tool
just
just help test
```

**The tests.** `uv run pytest` runs them. `uv run` runs a command inside `.venv`, syncing it first if it has to; `pytest` reads `[tool.pytest.ini_options]` in `pyproject.toml`, looks under `tests/`, and runs every function whose name starts with `test_`. The first lines say so: `configfile: pyproject.toml`, `testpaths: tests`, `plugins: cov-7.1.0`. 52 runs, two fail, and the tests are right. A guess over three score levels gets confidence 0.5, not 0. Confidence runs from 1, when the model is sure, down to 0, when it knows nothing. A model that gives every level the same chance knows nothing. Rounding to two decimals makes 77 equal options sum to 0.77. Two real bugs in code that works (`sundry/the-two-bugs.md`). Under the summary, the coverage table: every statement of `api.py` and `cli.py` is touched. From now on the table says which lines are not. The `grep` line shows where the table comes from: `addopts` in `pyproject.toml` adds `--cov=babykev --cov-report=term-missing` to every run, so nobody has to remember the flags.

```bash
uv run pytest
grep -n -B1 addopts pyproject.toml
```

**The recipe.** `just --show test` prints the recipe: its comment, two attributes, its name, and a body of one line, `uv run pytest "$@"`, inside an `if` that answers `help`. `"$@"` is every word after `just test`, each one whole. So `just test -k name` runs `uv run pytest -k name`, and in `just test -k "score_confidence_is_zero or rounded_probabilities"` pytest gets two words, `-k` and the whole pattern: 2 tests selected, both failing. Before it runs, just prints the line as it is written, `uv run pytest "$@"`, not your words. The shell fills them in after.

```bash
just --show test
just test -k "score_confidence_is_zero or rounded_probabilities"
```

**The command's tests** (`tests/unit/test_cli.py`, lines 8 to 18). `run` sets `sys.argv`, the list of words a program was started with, and calls `main()`, as if `babykev` had been typed at a terminal. `monkeypatch` and `capsys` are two of pytest's built-in fixtures: pytest sees their names among the test's arguments and passes them in. The project's own fixtures arrive with the model. `monkeypatch.setattr` changes `sys.argv` for this test only and puts it back afterwards; `capsys` catches what the program printed, and the test compares it with `HELP`. `@pytest.mark.parametrize` on line 14 runs the function once for each value in its list: one function, four tests, one for each way of asking for help (`babykev`, `babykev help`, `--help`, `-h`). With `-v`, pytest prints each on its own line, `[words0]` to `[words3]`, all passed: `4 passed, 48 deselected`.

```bash
sed -n '8,18p' tests/unit/test_cli.py
just test -k help_is_printed -v
```

**Four tests of the contract.** Every test at this step is a unit test: it runs one function, alone. The other kinds, where several parts or the whole program run together, come with the model at step 05. Every test in `test_api.py` has a name that reads as a sentence and a docstring that states the rule, and the file is in sections, `# Validation`, `# Rendering`, `# From a request to a record`, `# From probabilities to answers`, `# Confidence`. Two of the four tests are small and two carry weight. For each, the `sed` line prints it and the `just test -k` line runs it alone.

**Test 1, small: a request must ask at least one question** (lines 81 to 86). Three lines. `pytest.raises` says "this must fail". The contract refuses bad input, and the test pins the rule so nobody loosens it by accident. One passed.

```bash
sed -n '81,86p' tests/unit/test_api.py
just test -k without_questions
```

**Test 2, small: the limit on options is exact** (lines 105 to 114). 255 options are accepted, 256 are refused. The classic boundary test: the bug that is off by one lives exactly here, so the test stands exactly here. One passed.

```bash
sed -n '105,114p' tests/unit/test_api.py
just test -k largest_number
```

**Test 3, weighty: every line of the sample data fits the contract** (lines 47 to 56). `@pytest.mark.parametrize` again, now over the data: one function, five tests, one per line of the sample. It is a test of the data against the code: every line validates, every question becomes one record question, every question has at least two options. When the real data arrives at training, this is the test that grows. Five passed.

```bash
sed -n '47,56p' tests/unit/test_api.py
just test -k sample_line_fits
```

**Test 4, weighty: rounded probabilities still sum to one** (lines 250 to 258). A property, not a value: whatever the probabilities are, they must sum to 1. And the extreme case: 77 options, not three. `pytest.approx(1, abs=0.02)` is how a float is compared. This one fails here, 0.77, and it is the proof that code that "works" had a bug. One failed.

```bash
sed -n '250,258p' tests/unit/test_api.py
just test -k rounded_probabilities
```

**A subset.** Eight tests run; the coverage drops to 49%, because the table is about the tests that ran. The number that matters is the whole suite's.

```bash
just test -k confidence
```

**A break.** The `sed` line changes the noul option `"no"` to `"NO"` in `api.py`, and `just test` then fails four. Nothing to put back: the move to the next step drops the edit. (Changing `MAX_OPTIONS` breaks nothing: the test imports the constant.)

```bash
sed -i '' 's/option_text("no", c.get("false"))/option_text("NO", c.get("false"))/' src/babykev/api.py && just test
```

### What changed

- <a id="step-01-README.md-8ec9a0"></a>`README.md`: 9 lines added, 5 removed. [The file](https://github.com/rahuldave/babykev/blob/9cc0343527b93a817207a11a2866752807f0013d/README.md).
- <a id="step-01-data-cheese-sample.jsonl-79f982"></a>`data/cheese/sample.jsonl`: New, 5 lines. [The file](https://github.com/rahuldave/babykev/blob/9cc0343527b93a817207a11a2866752807f0013d/data/cheese/sample.jsonl).
- <a id="step-01-justfile-424f0b"></a>`justfile`: adds `recipe test`. 7 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/9cc0343527b93a817207a11a2866752807f0013d/justfile).
- <a id="step-01-pyproject.toml-5d07e7"></a>`pyproject.toml`: 15 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/9cc0343527b93a817207a11a2866752807f0013d/pyproject.toml).
- <a id="step-01-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: adds `_check`, `choice_confidence`, `class Choice`, `class Noul`, `class Score`, `class SystemOneRequest`, `option_text`, `r2`, `render`, `score_confidence`, `to_answers`, `to_record`. New, 104 lines. [The file](https://github.com/rahuldave/babykev/blob/9cc0343527b93a817207a11a2866752807f0013d/src/babykev/api.py).
- <a id="step-01-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: adds `cheese_request`, `test_choice_accepts_the_largest_number_of_options_and_no_more`, `test_choice_answer_names_the_most_likely_option`, `test_choice_becomes_one_option_per_criterion_in_order`, `test_choice_confidence_grows_with_the_winner`, `test_choice_confidence_is_one_when_certain`, `test_choice_confidence_is_zero_for_a_guess`, `test_choice_without_options_is_rejected`, `test_every_question_gets_an_answer_of_its_own_type`, `test_noul_answer_is_the_probability_of_yes`, `test_noul_becomes_no_then_yes`, `test_noul_criteria_describe_no_and_yes`, `test_noul_needs_no_criteria`, `test_option_text_adds_a_description_only_when_there_is_one`, `test_record_keeps_the_state_and_the_order_of_questions`, `test_render_flattens_json_into_text`, `test_request_holds_one_model_per_question_type`, `test_request_without_questions_is_rejected`, `test_rounded_probabilities_still_sum_to_one`, `test_sample_line_fits_the_contract`, `test_sample_line_has_a_usable_label_on_every_question`, `test_score_answer_is_the_expected_level`, `test_score_becomes_one_option_per_level_with_a_legend`, `test_score_confidence_is_one_when_certain`, `test_score_confidence_is_zero_for_a_guess`, `test_score_confidence_prefers_neighbouring_levels`, `test_score_with_one_level_is_rejected`, `test_unknown_question_type_is_rejected`. New, 293 lines. [The file](https://github.com/rahuldave/babykev/blob/9cc0343527b93a817207a11a2866752807f0013d/tests/unit/test_api.py).
- <a id="step-01-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: adds `run`, `test_an_unknown_command_is_refused_with_exit_code_2`, `test_help_is_printed_for_help_and_for_no_words`. New, 28 lines. [The file](https://github.com/rahuldave/babykev/blob/9cc0343527b93a817207a11a2866752807f0013d/tests/unit/test_cli.py).
- <a id="step-01-uv.lock-8356d8"></a>`uv.lock`: 286 lines added. [The file](https://github.com/rahuldave/babykev/blob/9cc0343527b93a817207a11a2866752807f0013d/uv.lock).

<a id="step-01-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -1,6 +1,6 @@
 # babykev
 
-babykev is a small decision model. You send it one document, the *context*, and a set of typed questions about it. It returns a probability for every possible answer to every question, in one forward pass. It generates no text.
+babykev is a small decision model. You send it one document, the *context* (the `state` field of a request), and a set of typed questions about it. It returns a probability for every possible answer to every question, in one forward pass. It generates no text.
 
 A request looks like this:
 
@@ -50,15 +50,19 @@ Three tools on the machine. This project installs everything else itself.
 | [just](https://just.systems/) | The project's tasks. `just` lists them |
 | [Quarto](https://quarto.org/) | The docs site |
 
-Then `just setup`. `just` lists the tasks, `just help VERB` explains one, and `uv run babykev help` is
-the program's own help.
+Then `just setup`, and `just test`. `just` lists the tasks, `just help VERB` explains one, and `uv run
+babykev help` is the program's own help. Extra arguments go to the tool behind a recipe: `just test -k
+render` runs only the tests whose name contains `render`.
 
 ## What is here
 
 | Path | What it is |
 |---|---|
-| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, and the exact versions installed |
-| `src/babykev/` | The code. `cli.py` is the `babykev` command |
+| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, the settings of its tools, and the exact versions installed |
+| `src/babykev/api.py` | The contract: the request and its three question types as Pydantic models, how they become the text and options the model sees, and how probabilities become answers |
+| `src/babykev/cli.py` | The `babykev` command |
+| `data/cheese/sample.jsonl` | Five lines of data. Each is a request about a cheese with a `label` on every question: the right answer |
+| `tests/unit/` | Unit tests of the contract and of the command. One test checks every line of the sample data against the contract |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
 | `.python-version` | The Python version the project uses |
```

</details>

<a id="step-01-data-cheese-sample.jsonl-79f982-diff"></a>

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

<a id="step-01-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

```diff
@@ -23,4 +23,10 @@ help *verb:
 # Install Python and every dependency into .venv, exactly as the lockfile says
 [group('setup')]
 setup *args:
-    @{{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
+    {{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
+
+# Run the tests, with coverage of src/babykev. Extra arguments go to pytest: just test -k render
+[group('quality')]
+[no-exit-message]
+test *args:
+    {{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
```

</details>

<a id="step-01-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -7,7 +7,9 @@ license = "Apache-2.0"
 license-files = ["LICENSE", "NOTICE"]
 authors = [{ name = "Rahul Dave" }]
 requires-python = ">=3.13"
-dependencies = []
+dependencies = [
+    "pydantic>=2.11",
+]
 
 [project.scripts]
 babykev = "babykev.cli:main"
@@ -15,3 +17,15 @@ babykev = "babykev.cli:main"
 [build-system]
 requires = ["uv_build>=0.12.13,<0.13.0"]
 build-backend = "uv_build"
+
+[dependency-groups]
+test = [
+    "pytest>=9.1",
+    "pytest-cov>=7.1.0",
+]
+dev = [{ include-group = "test" }]
+
+[tool.pytest.ini_options]
+testpaths = ["tests"]
+# Every run measures how much of src/babykev the tests touch and lists the lines they do not
+addopts = "--cov=babykev --cov-report=term-missing"
```

</details>

<a id="step-01-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -0,0 +1,104 @@
+"""The contract: request and answer shapes, mapped onto the single pointer primitive.
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
```

</details>

<a id="step-01-tests-unit-test_api.py-58d97c-diff"></a>

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -0,0 +1,293 @@
+"""Unit tests for the contract in `babykev.api`: validation, rendering, the mappings, the confidences."""
+
+import json
+from pathlib import Path
+
+import pytest
+from pydantic import ValidationError
+
+from babykev.api import (
+    MAX_OPTIONS,
+    Choice,
+    Noul,
+    Score,
+    SystemOneRequest,
+    choice_confidence,
+    option_text,
+    render,
+    score_confidence,
+    to_answers,
+    to_record,
+)
+
+SAMPLE = Path(__file__).parents[2] / "data" / "cheese" / "sample.jsonl"
+SAMPLE_LINES = [json.loads(line) for line in SAMPLE.read_text(encoding="utf-8").splitlines()]
+
+MILKS = {"cow": None, "goat": None, "sheep": None, "mixed": "More than one kind of milk"}
+FIRMNESS = ["Soft", "Semi-soft", "Semi-hard", "Hard"]
+
+
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
+# The sample data
+
+
+@pytest.mark.parametrize("line", SAMPLE_LINES)
+def test_sample_line_fits_the_contract(line):
+    """Every line of the sample data is a valid request and gives one record question per question."""
+    request = SystemOneRequest.model_validate(line)
+    record, meta = to_record(request)
+    assert record["state"]
+    assert [m["id"] for m in meta] == list(line["questions"])
+    assert all(len(q["options"]) >= 2 for q in record["questions"])
+
+
+@pytest.mark.parametrize("line", SAMPLE_LINES)
+def test_sample_line_has_a_usable_label_on_every_question(line):
+    """A label is a boolean for noul, one of the option names for choice, a level index for score."""
+    for question in line["questions"].values():
+        label = question["label"]
+        if question["type"] == "noul":
+            assert isinstance(label, bool)
+        elif question["type"] == "choice":
+            assert label in question["criteria"]
+        else:
+            assert label in range(len(question["criteria"]))
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
+
+
+def test_request_without_questions_is_rejected():
+    """A request must ask at least one question."""
+    with pytest.raises(ValidationError):
+        SystemOneRequest.model_validate({"state": "Brie", "questions": {}})
+
+
+def test_unknown_question_type_is_rejected():
+    """Only noul, choice and score exist."""
+    question = {"type": "essay", "instructions": "Describe this cheese."}
+    with pytest.raises(ValidationError):
+        SystemOneRequest.model_validate({"state": "Brie", "questions": {"q": question}})
+
+
+def test_noul_needs_no_criteria():
+    """A yes-or-no question may leave out what yes and no mean."""
+    assert Noul(type="noul", instructions="Is it blue?").criteria is None
+
+
+def test_choice_without_options_is_rejected():
+    """A choice needs at least one option."""
+    with pytest.raises(ValidationError):
+        Choice(type="choice", instructions="Which milk?", criteria={})
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
+
+
+def test_score_with_one_level_is_rejected():
+    """A scale needs at least two levels."""
+    with pytest.raises(ValidationError):
+        Score(type="score", instructions="How firm?", criteria=["Soft"])
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
+
+
+def test_noul_becomes_no_then_yes():
+    """Option 0 is no and option 1 is yes, so the answer is the probability of option 1."""
+    record, meta = to_record(cheese_request())
+    assert record["questions"][0]["options"] == ["no", "yes"]
+    assert meta[0] == {"id": "blue", "type": "noul"}
+
+
+def test_noul_criteria_describe_no_and_yes():
+    """The criteria under `false` and `true` become the descriptions of no and yes."""
+    criteria = {"true": "It has blue veins", "false": "It has none"}
+    question = {"type": "noul", "instructions": "Is it blue?", "criteria": criteria}
+    request = SystemOneRequest.model_validate({"state": "Brie", "questions": {"blue": question}})
+    record, _ = to_record(request)
+    assert record["questions"][0]["options"] == ["no: It has none", "yes: It has blue veins"]
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
+
+
+def test_score_becomes_one_option_per_level_with_a_legend():
+    """Options are the levels in order, and the legend maps each index to its level."""
+    record, meta = to_record(cheese_request())
+    assert record["questions"][2]["options"] == FIRMNESS
+    assert meta[2]["legend"] == {"0": "Soft", "1": "Semi-soft", "2": "Semi-hard", "3": "Hard"}
+
+
+# From probabilities to answers
+
+
+def test_noul_answer_is_the_probability_of_yes():
+    """The answer to a yes-or-no question is one number."""
+    answers = to_answers([[0.25, 0.75]], [{"id": "blue", "type": "noul"}])
+    assert answers == {"blue": {"type": "noul", "noul": 0.75}}
+
+
+def test_choice_answer_names_the_most_likely_option():
+    """A choice answer has the winner, a probability for each option, and a confidence."""
+    meta = [{"id": "milk", "type": "choice", "keys": ["cow", "goat", "sheep"]}]
+    answer = to_answers([[0.1, 0.7, 0.2]], meta)["milk"]
+    assert answer["choice"] == "goat"
+    assert answer["probabilities"] == {"cow": 0.1, "goat": 0.7, "sheep": 0.2}
+    assert answer["confidence"] == pytest.approx(0.55)
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
+
+
+def test_rounded_probabilities_still_sum_to_one():
+    """Rounding for output must not lose probability, even with many options."""
+    keys = [f"intent{i}" for i in range(77)]
+    answer = to_answers([[1 / 77] * 77], [{"id": "intent", "type": "choice", "keys": keys}])[
+        "intent"
+    ]
+    assert sum(answer["probabilities"].values()) == pytest.approx(1, abs=0.02)
+
+
+# Confidence
+
+
+def test_choice_confidence_is_zero_for_a_guess():
+    """Equal probabilities are a guess, whatever the number of options."""
+    assert choice_confidence([0.25] * 4) == pytest.approx(0)
+
+
+def test_choice_confidence_is_one_when_certain():
+    """All the probability on one option is certainty."""
+    assert choice_confidence([0, 1, 0]) == pytest.approx(1)
+    assert choice_confidence([1.0]) == 1.0
+
+
+def test_choice_confidence_grows_with_the_winner():
+    """Between a guess and certainty, confidence follows the winning probability."""
+    assert choice_confidence([0.5, 0.25, 0.25]) == pytest.approx(0.25)
+
+
+@pytest.mark.parametrize("level", [0, 1, 2])
+def test_score_confidence_is_one_when_certain(level):
+    """All the probability on one level is certainty, wherever the level is."""
+    p = [0.0, 0.0, 0.0]
+    p[level] = 1.0
+    assert score_confidence(p) == pytest.approx(1)
+
+
+def test_score_confidence_is_zero_for_a_guess():
+    """Equal probabilities over the levels are a guess, as they are for a choice."""
+    assert score_confidence([1 / 3] * 3) == pytest.approx(0)
+
+
+def test_score_confidence_prefers_neighbouring_levels():
+    """Doubt between adjacent levels is more confident than doubt between the two ends."""
+    assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])
```

</details>

<a id="step-01-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -0,0 +1,28 @@
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

[This change on GitHub](https://github.com/rahuldave/babykev/compare/ee96429002cd04cb95e86e9a77e9c3d02a0e9497...9cc0343527b93a817207a11a2866752807f0013d).

This part ends at the code at `step-01`. [The code after this part](https://github.com/rahuldave/babykev/tree/step-01)

<a id="step-02"></a>

## 2 Format and lint arrive

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `step-01`. [The code before this part](https://github.com/rahuldave/babykev/tree/step-01)

**Init.** `just setup` adds one package, ruff. `.venv`: 15 packages. (Coming from step-00 instead of step-01, it adds 14.)

```bash
just setup
```

**What is new:** ruff; `[tool.ruff]` in `pyproject.toml` with the formatter's settings and the lint rules, a comment on each; the `fmt` and `lint` recipes; the two fixes (`score_confidence` is 0 for a guess, `round_prob` rounds to four decimals; `sundry/the-two-bugs.md` explains both); `UV_LOCKED` exported from the justfile. `api.py` is still as it arrived. This step brings the tools and we run them here; the next commit holds what they leave behind.

**First, the two fixes.** The two tests that failed at step 01 pass here. The tests did not change; the code did. The file view shows what changed in `api.py`.

The first fix: a guess now has confidence 0. When the model cannot tell the levels of a score apart, the answer used to say it was half sure, 0.5. Now it says it is not sure at all. The code measured how spread out the answer was against the wrong yardstick: the whole length of the scale, instead of how spread out a guess is. With numbers: three levels, and the model gives each one a third. How spread out the answer is: all three are equally likely, so the code counts from the first, and the levels are 0, 1 and 2 steps from it, so 1/3 × 0 + 1/3 × 1 + 1/3 × 2 = 1 step. The old yardstick, first level to last, is 2 steps, so the confidence was 1 − 1/2 = 0.5. The new yardstick, how spread out a guess is, around the middle level, is 1/3 × 1 + 1/3 × 0 + 1/3 × 1 = 0.67 steps; 1 − 1/0.67 = −0.5. The formula counts anything below 0 as 0, so an answer as spread out as a guess, or more, has confidence 0. `just test -k score_confidence_is_zero`: 1 passed.

```bash
just test -k score_confidence_is_zero
```

The second fix: the probabilities add up to 1 again. Each one was rounded to two decimal places. With 77 options, each 0.013 became 0.01, and the total came to 0.77. Now they are rounded to four places, and the total stays close to 1. `just test -k rounded_probabilities`: 1 passed.

```bash
just test -k rounded_probabilities
```

**A. The tests pass, and one line is never reached.** 52 passed. The coverage table: `api.py` 71 statements, 1 missed, column `Missing` says `90`. The `sed` line prints lines 88 to 91:

```
    L = len(p)
    if L == 1:
        return 1.0
    mode = max(range(L), key=lambda i: p[i])
```

The fix added this branch. No test reaches it, because a `Score` needs at least two levels (`criteria` has `min_length=2`), so no request ever makes a one-level score. But `score_confidence` is a public function, and without the branch `score_confidence([1.0])` divides by zero: a guess's spread over one level is 0. The table found an edge no one had thought about. Two honest answers. Cut the branch, on the grounds that the function is only ever called through a request, and accept that calling it with one level then crashes. Or keep the branch and write the one test that reaches it: `score_confidence([1.0]) == 1.0`, "one level is the whole scale, there is nothing to be unsure about". The second is right here: the function is public, its contract is "a list of probabilities", and a crash on a legal input is a bug waiting for a caller. So the next step adds that test, and coverage goes back to 100% honestly, by asking the question the table raised. What never happens: adding a test only to make the number 100. The column is not a score to maximise. It is a list of lines nobody has asked a question about.

```bash
just test
sed -n '88,91p' src/babykev/api.py
```

**B. The formatter.** ruff is one tool with two jobs, a formatter and a linter, and this step brings both. `uv run ruff format --check` asks the formatter what it would change, without changing anything. It is red: "1 file would be reformatted, 5 files already formatted", and it prints what it would change in `api.py`:

| Where | What kev wrote | What the formatter does |
|---|---|---|
| line 7 | the imports right after the module docstring | a blank line between |
| line 27, `Choice._check` | `if not 1 <= len(...) <= MAX_OPTIONS: raise ValueError(...)`, 119 characters, two statements on one line | two lines |
| lines 48 to 51, `render` | three `if ...: return ...` on one line each, then a 142-character `return "\n".join(...)` | six lines, then the join spread over five |
| line 72, `to_record` | `meta.append({...})`, 118 characters | the dictionary over seven lines, one key per line |
| lines 110 and 113, `to_answers` | two dictionaries of 177 and 209 characters | six lines each |

```bash
uv run ruff format --check
```

`just --show fmt` prints the recipe: `uv run ruff format "$@"`, where `"$@"` is the words after `just fmt`. So `just fmt --check` is the command above, and `just fmt` alone is `uv run ruff format`, which rewrites the files.

```bash
just --show fmt
```

`just fmt`: "1 file reformatted". 114 lines become 141; the longest line goes from 209 characters to 107. `just fmt --check`: "6 files already formatted". `just test`: 52 passed. The formatter changed the look of every long line and the meaning of none.

```bash
just fmt
just fmt --check
just test
```

**C. What formatting did to the lint count.** At the commit `just lint --statistics` says 79 findings; after `just fmt` it says 70. The nine that went: the four E701 (several statements on one line, lines 27, 48, 49, 50) and five of the twelve E501 (lines over 100: the five long code lines). The seven E501 left are all in docstrings: the formatter rewraps code, never text.

**D. Reading the linter.** `uv run ruff check --statistics` is the linter, the other half of ruff: it reads the code against the rule families listed in `[tool.ruff.lint]` in `pyproject.toml` and prints one line per code with its count and name; `[*]` marks a code ruff can fix by itself. "Found 70 errors." After formatting, with what each code means:

| Code | Count | Meaning | Where |
|---|---|---|---|
| ANN201 | 32 | a public function has no return type | 30 tests; `to_record`; `cheese_request` in the tests |
| ANN001 | 14 | an argument has no type | all in the tests: `line`, `level`, `text`, `monkeypatch`, `capsys`, ... |
| E501 | 7 | a line over 100 characters | docstrings: 4 in `api.py`, 3 in the tests |
| D101 | 4 | a class has no docstring | `Noul`, `Choice`, `Score`, `SystemOneRequest` |
| D103 | 3 | a function has no docstring | `option_text`, `choice_confidence`, `to_answers` |
| N806 | 2 | a variable inside a function is not lower case | `K` in `choice_confidence`, `L` in `score_confidence` |
| UP007 | 2 | `Union[X, Y]` where `X \| Y` is the modern form | the aliases `JSONContent` and `Question` |
| B905 | 2 | `zip()` without `strict=`: if the two sequences differ in length, it silently drops the tail | both in `to_answers` |
| ANN202 | 1 | a private function has no return type | `Choice._check` |
| ANN002 | 1 | `*args` has no type | `*words` in `test_cli.run` |
| D104 | 1 | the package has no docstring | `src/babykev/__init__.py` |
| I001 | 1 | imports not in isort's order | `api.py`: the standard library and pydantic imports with no blank line between |

```bash
uv run ruff check --statistics
```

`just --show lint` prints the recipe: `uv run ruff check "$@"`, with the words after `just lint` in place of `"$@"`. From now on, `just lint`. Without `--statistics` it prints each finding with its line, a caret under the place, and a help text. Every code we have met, what it means, why it matters and what fixed it: `sundry/lint-codes.md`.

```bash
just --show lint
just lint
```

**E. Safe fixes.** `just lint --fix`: "70 errors (1 fixed, 69 remaining)". The one is I001: a blank line between `from typing import ...` and `from pydantic import ...`. A safe fix is one that cannot change what the code does.

```bash
just lint --fix
just lint --statistics
```

**F. Unsafe fixes, read the diff.** `just lint --fix --unsafe-fixes`: "69 errors (32 fixed, 37 remaining)". The 32: `-> None` written on the thirty test functions that return nothing (ruff is sure of `None`, not of other types: `to_record` and `cheese_request` keep their ANN201), and `strict=False` on the two `zip` calls (unsafe because the author might have meant `strict=True`; `False` keeps today's behaviour and makes the choice visible). `just lint --statistics` shows the 37 that remain.

```bash
just lint --fix --unsafe-fixes
just lint --statistics
```

After 33 automatic edits, `just fmt --check` is still green and `just test` still says 52 passed.

```bash
just fmt --check
just test
```

**G. What is left for a person, 37.** Fourteen argument types in the tests. Seven long docstring lines to rewrap. Eight docstrings to write (four classes, three functions, the package). Two return types ruff would not guess, `to_record` and `cheese_request`, and `_check`'s. `*words: str`. Two names, `K` and `L`. Two `Union`s. None of these is mechanical: each needs someone who knows what the function means. That is the next step.

**H. One by hand.** The `echo` line writes a one-line docstring into `__init__.py`; `just lint --statistics` goes from 37 to 36: D104 gone.

```bash
echo '"""babykev: a small decision model."""' > src/babykev/__init__.py
just lint --statistics
```

**What the next step does with all this.** The next commit holds: the formatted `api.py`; the two automatic fixes (the import order, `strict=False` on the `zip`s) and the thirty `-> None`s; and the 36 a person has to do, which is what the next step is: eight docstrings, the fourteen argument types in the tests, the three return types ruff would not guess, `*words: str`, `K` and `L` renamed, the two `Union`s rewritten, seven docstring lines rewrapped. And the test for the one-level edge, so the coverage column is empty again. After that `just fmt --check`, `just lint` and `just test` are all green, which is the moment to make them stay green. Nothing is put back: the move to the next step drops every edit made here, and the next commit holds all of them.

### What changed

- <a id="step-02-README.md-8ec9a0"></a>`README.md`: 3 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/4681f251318456e721cb4a7dcecbb9f73d3589cf/README.md).
- <a id="step-02-justfile-424f0b"></a>`justfile`: adds `recipe fmt`, `recipe lint`. 15 lines added. [The file](https://github.com/rahuldave/babykev/blob/4681f251318456e721cb4a7dcecbb9f73d3589cf/justfile).
- <a id="step-02-pyproject.toml-5d07e7"></a>`pyproject.toml`: 39 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/4681f251318456e721cb4a7dcecbb9f73d3589cf/pyproject.toml).
- <a id="step-02-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: adds `round_prob`; changes `score_confidence`, `to_answers`; removes `r2`. 20 lines added, 10 removed. [The file](https://github.com/rahuldave/babykev/blob/4681f251318456e721cb4a7dcecbb9f73d3589cf/src/babykev/api.py).
- <a id="step-02-uv.lock-8356d8"></a>`uv.lock`: 31 lines added. [The file](https://github.com/rahuldave/babykev/blob/4681f251318456e721cb4a7dcecbb9f73d3589cf/uv.lock).

<a id="step-02-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -50,7 +50,8 @@ Three tools on the machine. This project installs everything else itself.
 | [just](https://just.systems/) | The project's tasks. `just` lists them |
 | [Quarto](https://quarto.org/) | The docs site |
 
-Then `just setup`, and `just test`. `just` lists the tasks, `just help VERB` explains one, and `uv run
+Then `just setup`, and `just test`. `just fmt` formats the code and `just lint` checks it against the
+rules in `pyproject.toml`. `just` lists the tasks, `just help VERB` explains one, and `uv run
 babykev help` is the program's own help. Extra arguments go to the tool behind a recipe: `just test -k
 render` runs only the tests whose name contains `render`.
 
@@ -58,7 +59,7 @@ render` runs only the tests whose name contains `render`.
 
 | Path | What it is |
 |---|---|
-| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, the settings of its tools, and the exact versions installed |
+| `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, the settings of its tools (the formatter's, and every lint rule with its reason), and the exact versions installed |
 | `src/babykev/api.py` | The contract: the request and its three question types as Pydantic models, how they become the text and options the model sees, and how probabilities become answers |
 | `src/babykev/cli.py` | The `babykev` command |
 | `data/cheese/sample.jsonl` | Five lines of data. Each is a request about a cheese with a `label` on every question: the right answer |
```

</details>

<a id="step-02-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

```diff
@@ -5,6 +5,9 @@ program := "babykev"
 # Each word after a recipe's name reaches its commands whole, as "$1", "$2" and so on; "$@" is all of them
 set positional-arguments
 
+# uv refuses a stale lockfile instead of quietly re-locking it: a lockfile changes only on purpose
+export UV_LOCKED := "1"
+
 [private]
 default:
     @just --list --unsorted
@@ -25,6 +28,18 @@ help *verb:
 setup *args:
     {{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
 
+# Format the code, one way, no arguments. Extra arguments go to ruff: just fmt --check, just fmt --diff
+[group('quality')]
+[no-exit-message]
+fmt *args:
+    {{ if args == "help" { "just help fmt" } else { 'uv run ruff format "$@"' } }}
+
+# Check the code against the rules in pyproject.toml. Extra arguments go to ruff: just lint --statistics
+[group('quality')]
+[no-exit-message]
+lint *args:
+    {{ if args == "help" { "just help lint" } else { 'uv run ruff check "$@"' } }}
+
 # Run the tests, with coverage of src/babykev. Extra arguments go to pytest: just test -k render
 [group('quality')]
 [no-exit-message]
```

</details>

<a id="step-02-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -23,9 +23,47 @@ test = [
     "pytest>=9.1",
     "pytest-cov>=7.1.0",
 ]
-dev = [{ include-group = "test" }]
+dev = [{ include-group = "test" }, { include-group = "lint" }]
+lint = [
+    "ruff>=0.16",
+]
 
 [tool.pytest.ini_options]
 testpaths = ["tests"]
 # Every run measures how much of src/babykev the tests touch and lists the lines they do not
 addopts = "--cov=babykev --cov-report=term-missing"
+
+[tool.ruff]
+# The one setting the formatter and the linter share. Ruff's own default is 88; this project reads better
+# at 100, and docs-check (later) needs a signature with its docments to fit on a line.
+line-length = 100
+
+[tool.ruff.format]
+# The formatter has no style to argue about. These are ruff's defaults, written out so the choice is visible.
+quote-style = "double"            # "text", not 'text'
+indent-style = "space"            # four spaces, never tabs
+skip-magic-trailing-comma = false # a trailing comma means "keep this one item per line"
+line-ending = "auto"              # the file's own line endings
+docstring-code-format = false     # code examples inside docstrings are left as written
+
+[tool.ruff.lint]
+# What the linter checks. A family of rules per line, and why it is on.
+select = [
+    "E",   # pycodestyle errors: the basics, from indentation to line length
+    "W",   # pycodestyle warnings: stray whitespace and the like
+    "F",   # pyflakes: names that are unused, undefined or redefined
+    "I",   # isort: imports in one order, standard library first
+    "B",   # bugbear: constructs that are likely bugs, such as a mutable default argument
+    "UP",  # pyupgrade: older syntax that this Python has a newer form for
+    "SIM", # simplify: code that can be said in fewer words
+    "S",   # bandit: security, from `assert` in production code to `eval`
+    "N",   # pep8-naming: classes CamelCase, functions and variables lower_case
+    "ANN", # annotations: every parameter and every return value has a type
+    "D1",  # pydocstyle: every module, class and function has a docstring
+]
+# random is used to shuffle and to augment data, never for secrets
+ignore = ["S311"]
+
+[tool.ruff.lint.per-file-ignores]
+# A test is written with assert
+"tests/**" = ["S101"]
```

</details>

<a id="step-02-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -80,25 +80,35 @@ def choice_confidence(p: list[float]) -> float:
 
 
 def score_confidence(p: list[float]) -> float:
-    """Approximation of TypeSafe's 'distance from the modal level' statistic (exact formula unpublished):
-    1 - E|level - mode| / (L - 1)."""
-    L = len(p); mode = max(range(L), key=lambda i: p[i])
-    return 1.0 - sum(pi * abs(i - mode) for i, pi in enumerate(p)) / (L - 1)
+    """How closely a score's probabilities sit around the most likely level: 1 when certain, 0 for a guess.
 
+    The expected distance from the most likely level, divided by the distance a guess would have: equal
+    probability on every level, measured from the middle of the scale.
+    """
+    L = len(p)
+    if L == 1:
+        return 1.0
+    mode = max(range(L), key=lambda i: p[i])
+    spread = sum(pi * abs(i - mode) for i, pi in enumerate(p))
+    guess = sum(abs(i - (L - 1) / 2) for i in range(L)) / L
+    return max(0.0, 1.0 - spread / guess)
 
-def r2(x: float) -> float:
-    return round(float(x), 2)
+
+def round_prob(x: float) -> float:
+    """Round a number for output. Four decimals keep a rounded distribution's sum within 0.02 of 1 even
+    with MAX_OPTIONS options; two decimals did not: 77 equal options summed to 0.77."""
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

[This change on GitHub](https://github.com/rahuldave/babykev/compare/9cc0343527b93a817207a11a2866752807f0013d...4681f251318456e721cb4a7dcecbb9f73d3589cf).

This part ends at the code at `step-02`. [The code after this part](https://github.com/rahuldave/babykev/tree/step-02)

<a id="step-03"></a>

## 3 Clean, and kept clean

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `step-02`. [The code before this part](https://github.com/rahuldave/babykev/tree/step-02)

**Init.** `just setup` adds 15 packages (pre-commit, yamllint, validate-pyproject and what they need) and then prints `pre-commit installed at ...git/hooks/pre-commit`.

```bash
just setup
```

**A. The rest, fixed by a person.** At step 02 the tools left 36 problems that only a person could fix: docstrings, types, names. This commit holds those fixes, and the file view shows them. `just lint`: "All checks passed!".

```bash
just lint
```

**The hook.** The last line `just setup` printed, `pre-commit installed at ...`, came from a second command in the recipe. `uv run pre-commit install` is pre-commit, a tool that runs the hooks listed in `.pre-commit-config.yaml` at every commit; `install` writes the script `.git/hooks/pre-commit` that git runs, and prints where it put it. `just --show setup` shows the recipe grew from one command to two, joined by `&&`.

```bash
uv run pre-commit install
just --show setup
```

**What `install` wrote.** Before every commit, git looks in its hooks folder for a file named after the moment, `pre-commit`, and runs it. The replay copy is a second working copy of the repository, so its `.git` is a small file that points to the main repository; `git rev-parse --git-path hooks` prints where the hooks folder really is. `ls` shows `pre-commit` among the `.sample` files git puts there. `cat` shows the 20 lines pre-commit wrote: they start pre-commit from this folder's `.venv` and tell it to read `.pre-commit-config.yaml`. The path is this machine's, so the file is never committed, and every clone runs `just setup` to write its own. Any program in that place would do: two lines, `#!/bin/sh` and `just check`, would work. pre-commit adds the config file, the hooks it downloads, and the install.

```bash
ls "$(git rev-parse --git-path hooks)"
cat "$(git rev-parse --git-path hooks)/pre-commit"
```

**What is new:** the result of step 02's live run (`api.py` formatted, the import order, `strict=False` on the two `zip`s, `-> None` on thirty tests) and everything a person had to do after it: a one-line docstring on each of the four classes, the three functions and the package; the two missing return types (`to_record`, `_check -> Self`); `Union` written `|`; `K` and `L` renamed `k` and `n`; types on every test argument; the test for the one-level score. Then `just lint-config`, `just check`, and the git hook.

**B. Green.** `just test`: 53 passed, and the `Missing` column is empty.

```bash
just test
```

One test is new, and it is the answer to step 02's uncovered line. The `sed` line prints it, lines 282 to 284: three lines, a name that states the rule and a docstring that says why. `just test -k single_level`: 1 passed.

```bash
sed -n '282,284p' tests/unit/test_api.py
just test -k single_level
```

**C. `just check`.** `just --show check` prints the recipe: a small shell script, four lines after the `help` line, each a recipe already seen: `just fmt --check`, `just lint`, `just test -q --cov-fail-under=90`, `just lint-config`. The two flags are pytest's: `-q` for a short report, `--cov-fail-under=90` for a floor on the coverage. The floor lives here, in `check`, and not in `pyproject.toml`, so that `just test -k name` still works on a few tests.

```bash
just --show check
```

`just check` runs the four, one after another: `ruff format --check` ("6 files already formatted"), `ruff check` ("All checks passed!"), the tests with the floor ("Required test coverage of 90% reached. Total coverage: 100.00%"), and `lint-config` ("Valid file: pyproject.toml"; the lockfile and the justfile say nothing when they pass). 1.9 seconds.

```bash
just check
```

**D. The floor, failing.** With only the nine confidence tests selected: "FAIL Required test coverage of 90% not reached. Total coverage: 49.40%".

```bash
just test -k confidence --cov-fail-under=90
```

**E. Config files are checked too.** `just lint-config` runs four checks, one for each kind of file that is not Python. Each is run by hand first: once clean, and once with one break. Each break is put back at once, because the commit attempts in G and H run `just check`, and `just check` runs all four.

**yamllint.** `uv run yamllint --strict .` checks every YAML file in the repository against `.yamllint` (lines of at most 100 characters, no need for the `---` line) and prints nothing when all is well. `--strict` makes a warning fail as well as an error. The `sed` line indents the `args:` line of `.pre-commit-config.yaml` two spaces too far. yamllint then names the file and prints `10:15 error syntax error: mapping values are not allowed here (syntax)`: line 10, column 15. The `git restore` line puts the file back.

```bash
uv run yamllint --strict .
sed -i '' 's/^        args: \[--maxkb=1000\]$/          args: [--maxkb=1000]/' .pre-commit-config.yaml
uv run yamllint --strict .
git restore .pre-commit-config.yaml
```

**validate-pyproject.** `pyproject.toml` has an agreed format, written down as a standard: which sections there are, which keys each may hold, and what kind of value each key takes. `uv run validate-pyproject pyproject.toml` checks the file against it and prints `Valid file: pyproject.toml`. The `sed` line misspells one key, `requires_python` for `requires-python`. The output is long, 32 lines: uv first warns that it found no `requires-python` and rebuilds babykev, then validate-pyproject prints `[ERROR] `project` must not contain {'requires_python'} properties`, a traceback, and last `Invalid file: pyproject.toml`. `uv.lock` is not changed. The `git restore` line puts the file back.

```bash
uv run validate-pyproject pyproject.toml
sed -i '' 's/^requires-python = /requires_python = /' pyproject.toml
uv run validate-pyproject pyproject.toml
git restore pyproject.toml
```

**`uv lock --check`.** No new package: uv is already here. `--check` compares `uv.lock` with `pyproject.toml` and changes nothing; when they agree it prints `Resolved 29 packages`. The `sed` line raises pydantic's lowest allowed version from 2.11 to 2.12 without running `uv lock`. uv then prints `Resolved 29 packages`, and after it `error: The lockfile at `uv.lock` needs to be updated, but `--check` was provided.` and the hint `To update the lockfile, run `uv lock`.` The `git restore` line puts the file back.

```bash
uv lock --check
sed -i '' 's/"pydantic>=2.11"/"pydantic>=2.12"/' pyproject.toml
uv lock --check
git restore pyproject.toml
```

**`just --fmt --check --unstable`.** No new package: just has its own formatter, and `--unstable` is needed because just still marks it as unstable. It prints nothing when the justfile is formatted. The `sed` line writes `program:="babykev"` with no spaces. The check then prints 70 lines: the justfile as a diff, where two lines carry the change, `-program:="babykev"` and `+program := "babykev"`, and the last line says `error: Formatted justfile differs from original.` The `git restore` line puts the file back.

```bash
just --fmt --check --unstable
sed -i '' 's/^program := "babykev"/program:="babykev"/' justfile
just --fmt --check --unstable
git restore justfile
```

**The recipe.** `just --show lint-config` prints the four in one recipe, a script like `check`; `set -e` stops it at the first check that fails. `just lint-config` runs them: `Valid file: pyproject.toml` and `Resolved 29 packages`, and nothing from the other two. From now on, `just lint-config`.

```bash
just --show lint-config
just lint-config
```

**F. The hook.** The config lists four hooks. No file over 1 MB (a checkpoint is not a commit). No merge-conflict markers. No `.env` file, ever. And `just check`.

```bash
cat .pre-commit-config.yaml
```

**G. A bad commit.** The `perl` line adds `import os` at the top of `api.py`, unused. The commit attempt prints the four hooks with their results: three `Passed` or `Skipped`, then `just check...Failed`, and under it the linter's finding, `F401 [*] os imported but unused`, with the line, a caret under `os`, and `help: Remove unused import`. 0.8 seconds.

```bash
perl -pi -e 's/^(from typing)/import os\n$1/' src/babykev/api.py
git commit -am "try"
```

`git status`: the file is still modified; no new commit was made. The `git restore` line puts the file back.

```bash
git status
git restore src/babykev/api.py
```

**H. A secret.** The `echo` line writes a `.env` and force-adds it (`.env` is in `.gitignore`, so `-f` is needed even to try). The commit attempt prints `no .env file...Failed`, then the sentence from the config: "A .env file holds the settings and secrets of one machine. It is never committed", and the file name.

```bash
echo X=1 > .env && git add -f .env
git commit -m "try"
```

The last line takes the file out of the index and deletes it, so the next move does not ask.

```bash
git rm --cached -q .env && rm .env
```

**What the next step does.** Step 04 is the documentation: docments on the parameters, the generated reference pages, the site.

### What changed

- <a id="step-03-.pre-commit-config.yaml-e7d14d"></a>`.pre-commit-config.yaml`: New, 24 lines. [The file](https://github.com/rahuldave/babykev/blob/651cd62cf2d09d53225ed11c9befd7c2316ec1aa/.pre-commit-config.yaml).
- <a id="step-03-.yamllint-dfe50a"></a>`.yamllint`: New, 6 lines. [The file](https://github.com/rahuldave/babykev/blob/651cd62cf2d09d53225ed11c9befd7c2316ec1aa/.yamllint).
- <a id="step-03-README.md-8ec9a0"></a>`README.md`: 3 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/651cd62cf2d09d53225ed11c9befd7c2316ec1aa/README.md).
- <a id="step-03-justfile-424f0b"></a>`justfile`: adds `recipe check`, `recipe lint-config`. 26 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/651cd62cf2d09d53225ed11c9befd7c2316ec1aa/justfile).
- <a id="step-03-pyproject.toml-5d07e7"></a>`pyproject.toml`: 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/651cd62cf2d09d53225ed11c9befd7c2316ec1aa/pyproject.toml).
- <a id="step-03-src-babykev-__init__.py-a40393"></a>`src/babykev/__init__.py`: 1 line added. [The file](https://github.com/rahuldave/babykev/blob/651cd62cf2d09d53225ed11c9befd7c2316ec1aa/src/babykev/__init__.py).
- <a id="step-03-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: changes `Choice`, `Noul`, `Score`, `SystemOneRequest`, `_check`, `choice_confidence`, `option_text`, `render`, `round_prob`, `score_confidence`, `to_answers`, `to_record`. 72 lines added, 29 removed. [The file](https://github.com/rahuldave/babykev/blob/651cd62cf2d09d53225ed11c9befd7c2316ec1aa/src/babykev/api.py).
- <a id="step-03-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: adds `test_score_confidence_of_a_single_level_is_one`; changes `cheese_request`, `test_choice_accepts_the_largest_number_of_options_and_no_more`, `test_choice_answer_names_the_most_likely_option`, `test_choice_becomes_one_option_per_criterion_in_order`, `test_choice_confidence_grows_with_the_winner`, `test_choice_confidence_is_one_when_certain`, `test_choice_confidence_is_zero_for_a_guess`, `test_choice_without_options_is_rejected`, `test_every_question_gets_an_answer_of_its_own_type`, `test_noul_answer_is_the_probability_of_yes`, `test_noul_becomes_no_then_yes`, `test_noul_criteria_describe_no_and_yes`, `test_noul_needs_no_criteria`, `test_option_text_adds_a_description_only_when_there_is_one`, `test_record_keeps_the_state_and_the_order_of_questions`, `test_render_flattens_json_into_text`, `test_request_holds_one_model_per_question_type`, `test_request_without_questions_is_rejected`, `test_rounded_probabilities_still_sum_to_one`, `test_sample_line_fits_the_contract`, `test_sample_line_has_a_usable_label_on_every_question`, `test_score_answer_is_the_expected_level`, `test_score_becomes_one_option_per_level_with_a_legend`, `test_score_confidence_is_one_when_certain`, `test_score_confidence_is_zero_for_a_guess`, `test_score_confidence_prefers_neighbouring_levels`, `test_score_with_one_level_is_rejected`, `test_unknown_question_type_is_rejected`. 40 lines added, 31 removed. [The file](https://github.com/rahuldave/babykev/blob/651cd62cf2d09d53225ed11c9befd7c2316ec1aa/tests/unit/test_api.py).
- <a id="step-03-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: changes `run`, `test_an_unknown_command_is_refused_with_exit_code_2`, `test_help_is_printed_for_help_and_for_no_words`. 7 lines added, 3 removed. [The file](https://github.com/rahuldave/babykev/blob/651cd62cf2d09d53225ed11c9befd7c2316ec1aa/tests/unit/test_cli.py).
- <a id="step-03-uv.lock-8356d8"></a>`uv.lock`: 192 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/651cd62cf2d09d53225ed11c9befd7c2316ec1aa/uv.lock).

<a id="step-03-.pre-commit-config.yaml-e7d14d-diff"></a>

<details><summary>The diff of <code>.pre-commit-config.yaml</code></summary>

```diff
@@ -0,0 +1,24 @@
+# What every commit must pass. `just setup` installs it as a git hook.
+#
+# The project's own checks are one hook that runs `just check`, so the hook and the terminal run the
+# same thing. The hooks before it guard against files that should never be committed.
+repos:
+  - repo: https://github.com/pre-commit/pre-commit-hooks
+    rev: v6.0.0
+    hooks:
+      - id: check-added-large-files
+        args: [--maxkb=1000]
+      - id: check-merge-conflict
+  - repo: local
+    hooks:
+      - id: no-env-file
+        name: no .env file
+        entry: A .env file holds the settings and secrets of one machine. It is never committed
+        language: fail
+        files: (^|/)\.env$
+      - id: check
+        name: just check
+        entry: just check
+        language: system
+        pass_filenames: false
+        always_run: true
```

</details>

<a id="step-03-.yamllint-dfe50a-diff"></a>

<details><summary>The diff of <code>.yamllint</code></summary>

```diff
@@ -0,0 +1,6 @@
+# Settings for yamllint, which checks every YAML file in the repository.
+extends: default
+ignore-from-file: .gitignore
+rules:
+  line-length: {max: 100}
+  document-start: disable  # a file need not start with a line of three dashes
```

</details>

<a id="step-03-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -51,7 +51,8 @@ Three tools on the machine. This project installs everything else itself.
 | [Quarto](https://quarto.org/) | The docs site |
 
 Then `just setup`, and `just test`. `just fmt` formats the code and `just lint` checks it against the
-rules in `pyproject.toml`. `just` lists the tasks, `just help VERB` explains one, and `uv run
+rules in `pyproject.toml`. `just check` runs everything a commit must pass, and `just setup` installs it
+as a git hook, so a commit that fails a check is refused. `just` lists the tasks, `just help VERB` explains one, and `uv run
 babykev help` is the program's own help. Extra arguments go to the tool behind a recipe: `just test -k
 render` runs only the tests whose name contains `render`.
 
@@ -68,6 +69,7 @@ render` runs only the tests whose name contains `render`.
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
 | `.python-version` | The Python version the project uses |
 | `.gitignore` | Everything a training run will write, ignored from the first commit on |
+| `.pre-commit-config.yaml`, `.yamllint` | The git hook: what every commit must pass; and the settings of the YAML linter |
 
 ## How the history is organised
 
```

</details>

<a id="step-03-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

```diff
@@ -23,10 +23,10 @@ help *verb:
         uv run {{ program }} "$1" help
     fi
 
-# Install Python and every dependency into .venv, exactly as the lockfile says
+# Install Python and every dependency into .venv, exactly as the lockfile says, and the git hook
 [group('setup')]
 setup *args:
-    {{ if args == "help" { "just help setup" } else { "uv sync --locked" } }}
+    {{ if args == "help" { "just help setup" } else { "uv sync --locked && uv run pre-commit install" } }}
 
 # Format the code, one way, no arguments. Extra arguments go to ruff: just fmt --check, just fmt --diff
 [group('quality')]
@@ -40,8 +40,32 @@ fmt *args:
 lint *args:
     {{ if args == "help" { "just help lint" } else { 'uv run ruff check "$@"' } }}
 
+# Lint the config files: the YAML files, pyproject.toml, the lockfile and this justfile
+[group('quality')]
+[no-exit-message]
+lint-config *args:
+    #!/usr/bin/env sh
+    set -e
+    if [ "$*" = help ]; then just help lint-config; exit 0; fi
+    uv run yamllint --strict .
+    uv run validate-pyproject pyproject.toml
+    uv lock --check
+    just --fmt --check --unstable
+
 # Run the tests, with coverage of src/babykev. Extra arguments go to pytest: just test -k render
 [group('quality')]
 [no-exit-message]
 test *args:
     {{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
+
+# Everything a commit must pass: format, lint, the tests over the coverage floor, the config files
+[group('quality')]
+[no-exit-message]
+check *args:
+    #!/usr/bin/env sh
+    set -e
+    if [ "$*" = help ]; then just help check; exit 0; fi
+    just fmt --check
+    just lint
+    just test -q --cov-fail-under=90
+    just lint-config
```

</details>

<a id="step-03-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -25,7 +25,10 @@ test = [
 ]
 dev = [{ include-group = "test" }, { include-group = "lint" }]
 lint = [
+    "pre-commit>=4.6",
     "ruff>=0.16",
+    "validate-pyproject>=0.26",
+    "yamllint>=1.38",
 ]
 
 [tool.pytest.ini_options]
```

</details>

<a id="step-03-src-babykev-__init__.py-a40393-diff"></a>

<details><summary>The diff of <code>src/babykev/__init__.py</code></summary>

```diff
@@ -0,0 +1 @@
+"""babykev: a small decision model. One context, typed questions, a probability for every answer."""
```

</details>

<a id="step-03-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -1,43 +1,54 @@
 """The contract: request and answer shapes, mapped onto the single pointer primitive.
 
-Noul   -> 2 options [false, true];            answer = p(true)
-Choice -> options 'name' or 'name: desc';      answer = argmax, probabilities by name, confidence
-Score  -> options = ordered level descriptions; answer = expected level, legend, probabilities by index
+Noul   -> two options, no and yes;         answer = p(yes)
+Choice -> one option per criterion;        answer = the likeliest, probabilities by name, confidence
+Score  -> one option per level, in order;  answer = expected level, legend, probabilities by level
 """
-from typing import Any, Literal, Union
+
+from typing import Any, Literal, Self
+
 from pydantic import BaseModel, Field, model_validator
 
-JSONContent = Union[str, dict, list, int, float, bool, None]
+JSONContent = str | dict | list | int | float | bool | None
 MAX_OPTIONS = 255
 
 
 class Noul(BaseModel):
+    """A yes-or-no question."""
+
     type: Literal["noul"]
     instructions: JSONContent
     criteria: dict[str, JSONContent] | None = None
 
 
 class Choice(BaseModel):
+    """A question answered by picking one of several named options."""
+
     type: Literal["choice"]
     instructions: JSONContent
     criteria: dict[str, JSONContent]
 
     @model_validator(mode="after")
-    def _check(self):
-        if not 1 <= len(self.criteria) <= MAX_OPTIONS: raise ValueError(f"criteria must have 1..{MAX_OPTIONS} options")
+    def _check(self) -> Self:
+        if not 1 <= len(self.criteria) <= MAX_OPTIONS:
+            raise ValueError(f"criteria must have 1..{MAX_OPTIONS} options")
         return self
 
 
 class Score(BaseModel):
+    """A question answered with a level on an ordered scale."""
+
     type: Literal["score"]
     instructions: JSONContent
     criteria: list[JSONContent] = Field(min_length=2, max_length=MAX_OPTIONS)
 
 
-Question = Union[Noul, Choice, Score]
+Question = Noul | Choice | Score
 
 
 class SystemOneRequest(BaseModel):
+    """One request: a state, and the questions to answer about it."""
+
     state: JSONContent
     questions: dict[str, Question] = Field(min_length=1)
 
@@ -45,17 +56,26 @@ class SystemOneRequest(BaseModel):
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
+    """Write one option as the model sees it."""
     return name if desc is None or desc == "" else f"{name}: {render(desc)}"
 
 
-def to_record(req: SystemOneRequest):
+def to_record(req: SystemOneRequest) -> tuple[dict[str, Any], list[dict[str, Any]]]:
     """-> internal record for encode(), plus per-question metadata to map probabilities back."""
     qs, meta = [], []
     for qid, q in req.questions.items():
@@ -69,46 +89,69 @@ def to_record(req: SystemOneRequest):
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
 
 
 def choice_confidence(p: list[float]) -> float:
-    K = len(p)
-    return 1.0 if K == 1 else (max(p) - 1 / K) / (1 - 1 / K)
+    """Measure how far the most likely option stands above a guess among `len(p)` options."""
+    k = len(p)
+    return 1.0 if k == 1 else (max(p) - 1 / k) / (1 - 1 / k)
 
 
 def score_confidence(p: list[float]) -> float:
-    """How closely a score's probabilities sit around the most likely level: 1 when certain, 0 for a guess.
+    """Measure how closely a score's probabilities sit around the most likely level.
 
-    The expected distance from the most likely level, divided by the distance a guess would have: equal
+    1 when one level has all the probability, 0 for a guess or anything as spread out. The expected
+    distance from the most likely level is divided by the distance a guess would have: equal
     probability on every level, measured from the middle of the scale.
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
 
 
 def round_prob(x: float) -> float:
-    """Round a number for output. Four decimals keep a rounded distribution's sum within 0.02 of 1 even
-    with MAX_OPTIONS options; two decimals did not: 77 equal options summed to 0.77."""
+    """Round a number for output.
+
+    Four decimals keep a rounded distribution's sum within 0.02 of 1 even with MAX_OPTIONS options.
+    Two decimals did not: 77 equal options summed to 0.77.
+    """
     return round(float(x), 4)
 
 
-def to_answers(probs: list[list[float]], meta: list[dict]) -> dict[str, Any]:
+def to_answers(probs: list[list[float]], meta: list[dict[str, Any]]) -> dict[str, Any]:
+    """Turn the model's probabilities into answers of each question's type."""
     out = {}
-    for p, m in zip(probs, meta):
+    for p, m in zip(probs, meta, strict=False):
         if m["type"] == "noul":
             out[m["id"]] = {"type": "noul", "noul": round_prob(p[1])}
         elif m["type"] == "choice":
-            dist = {k: round_prob(v) for k, v in zip(m["keys"], p)}
-            out[m["id"]] = {"type": "choice", "choice": m["keys"][max(range(len(p)), key=lambda i: p[i])], "confidence": round_prob(choice_confidence(p)), "probabilities": dist}
+            dist = {k: round_prob(v) for k, v in zip(m["keys"], p, strict=False)}
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

<a id="step-03-tests-unit-test_api.py-58d97c-diff"></a>

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -1,7 +1,8 @@
-"""Unit tests for the contract in `babykev.api`: validation, rendering, the mappings, the confidences."""
+"""Unit tests for the contract in `babykev.api`: validation, rendering, mappings, confidences."""
 
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
@@ -27,7 +29,7 @@ MILKS = {"cow": None, "goat": None, "sheep": None, "mixed": "More than one kind
 FIRMNESS = ["Soft", "Semi-soft", "Semi-hard", "Hard"]
 
 
-def cheese_request():
+def cheese_request() -> SystemOneRequest:
     """One request that asks a question of each type."""
     return SystemOneRequest.model_validate(
         {
@@ -45,8 +47,8 @@ def cheese_request():
 
 
 @pytest.mark.parametrize("line", SAMPLE_LINES)
-def test_sample_line_fits_the_contract(line):
-    """Every line of the sample data is a valid request and gives one record question per question."""
+def test_sample_line_fits_the_contract(line: dict[str, Any]) -> None:
+    """Every sample line is a valid request and gives one record question per question."""
     request = SystemOneRequest.model_validate(line)
     record, meta = to_record(request)
     assert record["state"]
@@ -55,8 +57,8 @@ def test_sample_line_fits_the_contract(line):
 
 
 @pytest.mark.parametrize("line", SAMPLE_LINES)
-def test_sample_line_has_a_usable_label_on_every_question(line):
-    """A label is a boolean for noul, one of the option names for choice, a level index for score."""
+def test_sample_line_has_a_usable_label_on_every_question(line: dict[str, Any]) -> None:
+    """A label is a boolean for noul, an option name for choice, a level index for score."""
     for question in line["questions"].values():
         label = question["label"]
         if question["type"] == "noul":
@@ -70,7 +72,7 @@ def test_sample_line_has_a_usable_label_on_every_question(line):
 # Validation
 
 
-def test_request_holds_one_model_per_question_type():
+def test_request_holds_one_model_per_question_type() -> None:
     """The `type` field decides which model a question becomes."""
     questions = cheese_request().questions
     assert isinstance(questions["blue"], Noul)
@@ -78,31 +80,31 @@ def test_request_holds_one_model_per_question_type():
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
@@ -112,7 +114,7 @@ def test_choice_accepts_the_largest_number_of_options_and_no_more():
         Choice(type="choice", instructions="Which?", criteria={**at_limit, "one_more": None})
 
 
-def test_score_with_one_level_is_rejected():
+def test_score_with_one_level_is_rejected() -> None:
     """A scale needs at least two levels."""
     with pytest.raises(ValidationError):
         Score(type="score", instructions="How firm?", criteria=["Soft"])
@@ -138,7 +140,7 @@ def test_score_with_one_level_is_rejected():
         ([{"role": "customer", "content": "hello"}], "- role: customer\n  content: hello"),
     ],
 )
-def test_render_flattens_json_into_text(value, text):
+def test_render_flattens_json_into_text(value: JSONContent, text: str) -> None:
     """Strings, numbers, lists and objects all become the text the model reads."""
     assert render(value) == text
 
@@ -151,7 +153,9 @@ def test_render_flattens_json_into_text(value, text):
         ("mixed", "More than one kind of milk", "mixed: More than one kind of milk"),
     ],
 )
-def test_option_text_adds_a_description_only_when_there_is_one(name, description, text):
+def test_option_text_adds_a_description_only_when_there_is_one(
+    name: str, description: str | None, text: str
+) -> None:
     """An option is its name, followed by its description when it has one."""
     assert option_text(name, description) == text
 
@@ -159,7 +163,7 @@ def test_option_text_adds_a_description_only_when_there_is_one(name, description
 # From a request to a record
 
 
-def test_record_keeps_the_state_and_the_order_of_questions():
+def test_record_keeps_the_state_and_the_order_of_questions() -> None:
     """The state is rendered once and the questions stay in request order."""
     record, meta = to_record(cheese_request())
     assert record["state"] == "cheese: Roquefort\norigin: France"
@@ -171,14 +175,14 @@ def test_record_keeps_the_state_and_the_order_of_questions():
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
@@ -187,7 +191,7 @@ def test_noul_criteria_describe_no_and_yes():
     assert record["questions"][0]["options"] == ["no: It has none", "yes: It has blue veins"]
 
 
-def test_choice_becomes_one_option_per_criterion_in_order():
+def test_choice_becomes_one_option_per_criterion_in_order() -> None:
     """Options keep the order of the criteria, and the metadata remembers their names."""
     record, meta = to_record(cheese_request())
     assert record["questions"][1]["options"] == [
@@ -199,7 +203,7 @@ def test_choice_becomes_one_option_per_criterion_in_order():
     assert meta[1] == {"id": "milk", "type": "choice", "keys": ["cow", "goat", "sheep", "mixed"]}
 
 
-def test_score_becomes_one_option_per_level_with_a_legend():
+def test_score_becomes_one_option_per_level_with_a_legend() -> None:
     """Options are the levels in order, and the legend maps each index to its level."""
     record, meta = to_record(cheese_request())
     assert record["questions"][2]["options"] == FIRMNESS
@@ -209,13 +213,13 @@ def test_score_becomes_one_option_per_level_with_a_legend():
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
@@ -224,7 +228,7 @@ def test_choice_answer_names_the_most_likely_option():
     assert answer["confidence"] == pytest.approx(0.55)
 
 
-def test_score_answer_is_the_expected_level():
+def test_score_answer_is_the_expected_level() -> None:
     """A score answer is the mean level under the probabilities, with the legend to read it by."""
     legend = {"0": "Soft", "1": "Semi-soft", "2": "Hard"}
     answer = to_answers([[0.1, 0.2, 0.7]], [{"id": "firmness", "type": "score", "legend": legend}])[
@@ -235,7 +239,7 @@ def test_score_answer_is_the_expected_level():
     assert answer["probabilities"] == {"0": 0.1, "1": 0.2, "2": 0.7}
 
 
-def test_every_question_gets_an_answer_of_its_own_type():
+def test_every_question_gets_an_answer_of_its_own_type() -> None:
     """Records and answers line up: one answer per question, under the question's id."""
     record, meta = to_record(cheese_request())
     uniform = [[1 / len(q["options"])] * len(q["options"]) for q in record["questions"]]
@@ -247,7 +251,7 @@ def test_every_question_gets_an_answer_of_its_own_type():
     }
 
 
-def test_rounded_probabilities_still_sum_to_one():
+def test_rounded_probabilities_still_sum_to_one() -> None:
     """Rounding for output must not lose probability, even with many options."""
     keys = [f"intent{i}" for i in range(77)]
     answer = to_answers([[1 / 77] * 77], [{"id": "intent", "type": "choice", "keys": keys}])[
@@ -259,35 +263,40 @@ def test_rounded_probabilities_still_sum_to_one():
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
 
 
+def test_score_confidence_of_a_single_level_is_one() -> None:
+    """One level is the whole scale; there is nothing to be unsure about."""
+    assert score_confidence([1.0]) == 1.0
+
+
 @pytest.mark.parametrize("level", [0, 1, 2])
-def test_score_confidence_is_one_when_certain(level):
+def test_score_confidence_is_one_when_certain(level: int) -> None:
     """All the probability on one level is certainty, wherever the level is."""
     p = [0.0, 0.0, 0.0]
     p[level] = 1.0
     assert score_confidence(p) == pytest.approx(1)
 
 
-def test_score_confidence_is_zero_for_a_guess():
+def test_score_confidence_is_zero_for_a_guess() -> None:
     """Equal probabilities over the levels are a guess, as they are for a choice."""
     assert score_confidence([1 / 3] * 3) == pytest.approx(0)
 
 
-def test_score_confidence_prefers_neighbouring_levels():
+def test_score_confidence_prefers_neighbouring_levels() -> None:
     """Doubt between adjacent levels is more confident than doubt between the two ends."""
     assert score_confidence([0.5, 0.5, 0, 0]) > score_confidence([0.5, 0, 0, 0.5])
```

</details>

<a id="step-03-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -5,20 +5,24 @@ import pytest
 from babykev.cli import HELP, main
 
 
-def run(monkeypatch, *words):
+def run(monkeypatch: pytest.MonkeyPatch, *words: str) -> None:
     """Run `babykev` with these words as its command line."""
     monkeypatch.setattr("sys.argv", ["babykev", *words])
     main()
 
 
 @pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])
-def test_help_is_printed_for_help_and_for_no_words(monkeypatch, capsys, words):
+def test_help_is_printed_for_help_and_for_no_words(
+    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], words: tuple[str, ...]
+) -> None:
     """`babykev`, `babykev help`, `--help` and `-h` all print the help text, and nothing else."""
     run(monkeypatch, *words)
     assert capsys.readouterr().out == HELP
 
 
-def test_an_unknown_command_is_refused_with_exit_code_2(monkeypatch, capsys):
+def test_an_unknown_command_is_refused_with_exit_code_2(
+    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+) -> None:
     """A word that is not a command is named, the help is pointed to, and the exit code is 2."""
     with pytest.raises(SystemExit) as exit_info:
         run(monkeypatch, "train")
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/compare/4681f251318456e721cb4a7dcecbb9f73d3589cf...651cd62cf2d09d53225ed11c9befd7c2316ec1aa).

This part ends at the code at `step-03`. [The code after this part](https://github.com/rahuldave/babykev/tree/step-03)

<a id="step-04"></a>

## 4 Documentation from the code

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `step-03`. [The code before this part](https://github.com/rahuldave/babykev/tree/step-03)

**Init.** `just setup` adds one package, fastcore 2.2.32, and rebuilds babykev because `pyproject.toml` changed; then `pre-commit installed at .git/hooks/pre-commit`. The recipe is a script now, like `check`: `uv sync --locked`, `uv run pre-commit install`, and a line that says if Quarto is not on the machine (it is, so nothing is printed). 0.4 s.

```bash
just setup
```

**What is new:** a command, `babykev docs`, in `src/babykev/docs.py`, that reads the code and prints plain Markdown; `docs/` with the Quarto site (`_quarto.yml`, `index.qmd`, `apidocs.py`, `linkify.lua`); one recipe, `docs`; tests of the command. This commit is dirty on purpose: `docs.py` is documented with docments, nothing else is, and `docs check` is red. Step 04b fills the gaps.

**A. The recipe.** `just` shows a new group, `docs`, with one recipe. `just help docs` prints the recipe's line and then the program's usage: three words, `list`, `module NAME`, `check`.

```bash
just
just help docs
```

**B. What the code says about itself.** `uv run babykev docs list` is the program's own command, run the way any command in the venv is run. It prints 41 lines: every module, class and function of the package, its kind, its full name, and the first line of its docstring. `babykev.api` has 4 classes and 7 functions; `babykev.docs` has 1 class and 25 functions. 0.4 s.

```bash
uv run babykev docs list
```

`just --show docs` prints the recipe, a script with three branches: `help` explains; no words at all runs `uv run quarto render docs`, the site; any other words go to the program, `uv run babykev docs "$@"` (the recipe writes `{{ program }}` for `babykev`). So `just docs list` is the command above.

```bash
just --show docs
```

**C. One module, as Markdown.** `just docs module api` prints `api.py` as Markdown: a heading per symbol, the signature as a line of Python, the docstring, and a table of the parameters with type, default and description. Every Description cell is empty, because nothing in `api.py` carries a docment yet. The types are written as the source writes them, `JSONContent` and not the seven-way union it stands for. Then `just docs module docs`: the same for `docs.py`, and every Description cell is filled. Scroll to `class Symbol`: five fields, five descriptions, each from the comment beside the field.

```bash
just docs module api
just docs module docs
```

**D. Where a description comes from.** The first `sed` line prints `line_of`, lines 108 to 112 of `docs.py`: one parameter per line, a comment two spaces after it, and the return's comment after the colon of the `def` line. That comment is a docment, and fastcore reads it. The second `sed` line prints the `Symbol` dataclass, lines 46 to 54: the same for a field.

```bash
sed -n '108,112p' src/babykev/docs.py
sed -n '46,54p' src/babykev/docs.py
```

**E. The gaps.** `just docs check` prints one line per module and per test file: `babykev.api 0 of 12`, `babykev.cli 1 of 1`, `babykev.docs 26 of 26`, `test_api.py 23 of 29`, `test_cli.py 0 of 4`, `test_docs.py 0 of 16`; then every gap, one per line, 84 of them: 62 parameters with no docment, 10 returns with no docment, 11 pydantic fields with no description, 1 method with no docstring (`Choice._check`); then `50 of 88 functions, methods and classes are typed and documented`, and exit 1. 0.6 s. The rule is one sentence: every parameter typed and with a comment, the return typed and with a comment unless it is `None`, a docstring, and a description on every model field. `cli.main` passes with nothing to write: it has no parameters and returns `None`; the 23 of `test_api.py` pass the same way. `just check` is green at this commit because `docs check` is not in it yet. Step 04b adds it, once the gaps are filled.

```bash
just docs check
```

How do we know the checker is right? `docs.py` arrived with 16 tests, and they do not test it on babykev, which changes at every step. They write a small package into a temporary folder, with one documented function, one bare one, and a class, and check what the tool says about that. The `sed` line prints the start of that package, inside the test file as a string.

```bash
sed -n '10,20p' tests/unit/test_docs.py
```

The gaps test, lines 171 to 196, is the checker's rule written out: the documented symbols have no gaps, and the bare function is missing its docstring, two types, two docments and a return type, each named the way `docs check` names it. `just test -k gaps_names`: 1 passed.

```bash
sed -n '171,196p' tests/unit/test_docs.py
just test -k gaps_names
```

The Markdown test, lines 105 to 117, pins the shape of one entry: the heading, the signature as a line of Python, the docstring, and three rows of the table, each with its description. `just test -k heading_a_signature`: 1 passed.

```bash
sed -n '105,117p' tests/unit/test_docs.py
just test -k heading_a_signature
```

**F. The site, in two commands.** `uv run python docs/apidocs.py build` is the dev-side script: it asks the program for each module's Markdown, adds what a site needs, and writes `docs/api/api.qmd`, `cli.qmd`, `docs.qmd` and `docs/_symbols.json`; it prints `wrote 3 page(s) to docs/api/`.

```bash
uv run python docs/apidocs.py build
```

`uv run quarto render docs` is Quarto, the one tool this project does not install. Its `_quarto.yml` names the script above as `pre-render`, so Quarto prints `python`, runs it again (`wrote 3 page(s)` once more), then renders four pages and prints `Output created: _site/index.html`. 5 s. The no-words branch of the `docs` recipe is exactly this line, so from now on `just docs`. The `open` line shows the site: the front page, and under Reference one page per module, every heading with a link to its source line, and the empty Description columns of `api`. On the front page, `render` in backticks is a link to its entry.

```bash
uv run quarto render docs
open docs/_site/index.html
```

**G. How the links are made.** `head -8 docs/_symbols.json` shows the index `apidocs.py` writes: a name, short and full, to a page and an anchor; 75 entries in all.

```bash
head -8 docs/_symbols.json
```

`docs/linkify.lua` is 19 lines. At render, a name in backticks that is in the index becomes a link.

```bash
cat docs/linkify.lua
```

The `sed` line shows what `apidocs.py` added to the program's Markdown for `api`: the front matter, `{#Noul}` on the heading, the `[source]` link. This is the split: the program knows only its own code and prints plain Markdown; the dev side adds the site layer. The one interface between them is three functions in `docs.py`: the inventory, the Markdown of a module, the gaps.

```bash
sed -n '1,12p' docs/api/api.qmd
```

**H. Do docments hurt the formatter and the linter?** No, with one rule: the line must fit in 100 characters. The `perl` line makes the return docment of `line_of` 102 characters long. `just lint` then reports `E501 Line too long (102 > 100)` on line 110, and exits 1.

```bash
perl -pi -e 's/^\) -> int:  # The line its definition starts on$/) -> int:  # The line its definition starts on, counted from one as every editor does, never from zero/' src/babykev/docs.py
just lint
```

`just fmt --diff` shows what the formatter would do: wrap the return type, `) -> (` then `int` then `):  # The line its...`, so the comment lands two lines below the annotation. `just fmt` does it: `1 file reformatted`.

```bash
just fmt --diff
just fmt
```

`just lint` is now green: every line fits. Nothing else touches a docment: the formatter never joins a line that carries a comment, so a signature written one parameter per line stays that way, and no lint rule looks inside a comment (ERA001, E261 and E262 were run against the file; all pass).

```bash
just lint
```

But `just docs check` says `babykev.docs 25 of 26` and `babykev.docs:line_of: no return docment`: fastcore reads the comment on the line of the annotation, and the annotation moved.

```bash
just docs check
```

**I. Still green.** `just check` passes: 9 files formatted, lint clean, 69 tests, coverage 97.78%, the config files valid. 2.3 s. Seven lines of `docs.py` are reached by no test, and the coverage table names them (75, 192, 201, 205, 208, 221, 248): the `ImportError` of `file_modules`; in `type_text`, a forward reference written as a string, a generic such as `list[float]` (the real package has them, the test package does not), `...`, and the fallback `repr`; in `signature`, the keyword-only star; in `table`, the empty table of a function with nothing to list.

```bash
just check
```

**What the next step does.** The move to 04b drops the edit of section H. Step 04b fills the 84 gaps: the docments on `api.py`, `cli.py` and the tests, the descriptions on the model fields, and `docs check` into `check`.

### What changed

- <a id="step-04-README.md-8ec9a0"></a>`README.md`: 12 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/README.md).
- <a id="step-04-docs-.gitignore-402aec"></a>`docs/.gitignore`: New, 2 lines. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/docs/.gitignore).
- <a id="step-04-docs-_quarto.yml-ee884f"></a>`docs/_quarto.yml`: New, 20 lines. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/docs/_quarto.yml).
- <a id="step-04-docs-apidocs.py-e63616"></a>`docs/apidocs.py`: adds `build`, `main`, `page`, `source_link`. New, 86 lines. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/docs/apidocs.py).
- <a id="step-04-docs-index.qmd-d6d880"></a>`docs/index.qmd`: New, 21 lines. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/docs/index.qmd).
- <a id="step-04-docs-linkify.lua-9e5197"></a>`docs/linkify.lua`: New, 19 lines. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/docs/linkify.lua).
- <a id="step-04-justfile-424f0b"></a>`justfile`: adds `recipe docs`. 16 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/justfile).
- <a id="step-04-pyproject.toml-5d07e7"></a>`pyproject.toml`: 5 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/pyproject.toml).
- <a id="step-04-src-babykev-cli.py-a9e184"></a>`src/babykev/cli.py`: changes `main`. 12 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/src/babykev/cli.py).
- <a id="step-04-src-babykev-docs.py-267fa4"></a>`src/babykev/docs.py`: adds `cell`, `check`, `class Symbol`, `doc`, `entry`, `fields_table`, `file_modules`, `gaps`, `gaps_of`, `has_init`, `held`, `inventory`, `is_dunder`, `line_of`, `main`, `markdown`, `methods`, `module`, `name_of`, `own`, `package_modules`, `params_table`, `signature`, `summary`, `table`, `type_text`. New, 407 lines. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/src/babykev/docs.py).
- <a id="step-04-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: adds `test_docs_is_passed_to_the_docs_command`. 11 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/tests/unit/test_cli.py).
- <a id="step-04-tests-unit-test_docs.py-31dd08"></a>`tests/unit/test_docs.py`: adds `_hidden`, `bare`, `class Box`, `class Thing`, `example`, `greet`, `size`, `span`, `test_a_return_that_is_not_none_needs_a_docment`, `test_an_unknown_module_is_a_lookup_error`, `test_check_holds_the_tests_to_the_convention_too`, `test_check_prints_a_count_per_module_then_every_gap_and_fails`, `test_gaps_names_what_each_symbol_is_missing`, `test_help_and_a_bad_word`, `test_inventory_knows_the_line_of_each_symbol`, `test_inventory_lists_the_public_symbols_in_source_order`, `test_list_prints_one_line_per_symbol`, `test_markdown_has_a_heading_a_signature_a_docstring_and_a_table_per_function`, `test_markdown_has_no_links_and_no_ids`, `test_markdown_shows_a_class_and_its_public_methods_only`, `test_markdown_shows_a_pydantic_model_as_a_table_of_fields`, `test_markdown_writes_a_type_alias_by_its_name`, `test_module_prints_the_markdown_and_an_unknown_name_is_refused`. New, 265 lines. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/tests/unit/test_docs.py).
- <a id="step-04-uv.lock-8356d8"></a>`uv.lock`: 14 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/d27a7f152ade46e9024f0b97481b85fcce07a16c/uv.lock).

<a id="step-04-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -48,7 +48,7 @@ Three tools on the machine. This project installs everything else itself.
 |---|---|
 | [uv](https://docs.astral.sh/uv/) | Python itself, the dependencies, and running the program |
 | [just](https://just.systems/) | The project's tasks. `just` lists them |
-| [Quarto](https://quarto.org/) | The docs site |
+| [Quarto](https://quarto.org/) | The docs site: `just docs`. `just setup` says if it is missing |
 
 Then `just setup`, and `just test`. `just fmt` formats the code and `just lint` checks it against the
 rules in `pyproject.toml`. `just check` runs everything a commit must pass, and `just setup` installs it
@@ -56,6 +56,14 @@ as a git hook, so a commit that fails a check is refused. `just` lists the tasks
 babykev help` is the program's own help. Extra arguments go to the tool behind a recipe: `just test -k
 render` runs only the tests whose name contains `render`.
 
+The documentation comes from the code. `just docs` builds the site into `docs/_site/`; open
+`docs/_site/index.html`. The same text is there at the terminal as plain Markdown, for people and for
+agents: `just docs list` names every module, class and function with its summary, `just docs module api`
+prints one module, and `just docs check` counts what is typed and documented and lists every gap. The
+convention: every function is typed, has a docstring, and carries a docment, a comment beside each
+parameter and the return, which the formatter and the linter leave alone as long as the line fits in 100
+characters. `src/babykev/docs.py` is the example to read.
+
 ## What is here
 
 | Path | What it is |
@@ -63,8 +71,10 @@ render` runs only the tests whose name contains `render`.
 | `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, the settings of its tools (the formatter's, and every lint rule with its reason), and the exact versions installed |
 | `src/babykev/api.py` | The contract: the request and its three question types as Pydantic models, how they become the text and options the model sees, and how probabilities become answers |
 | `src/babykev/cli.py` | The `babykev` command |
+| `src/babykev/docs.py` | What the code says about itself, as plain Markdown: `babykev docs list`, `docs module NAME`, `docs check` |
+| `docs/` | The docs site: `_quarto.yml`, the front page `index.qmd`, `apidocs.py` (writes the reference pages from `babykev docs` before every render) and `linkify.lua` (a name in backticks becomes a link). The built site in `_site/` is not committed |
 | `data/cheese/sample.jsonl` | Five lines of data. Each is a request about a cheese with a `label` on every question: the right answer |
-| `tests/unit/` | Unit tests of the contract and of the command. One test checks every line of the sample data against the contract |
+| `tests/unit/` | Unit tests of the contract, of the command and of the documentation. One test checks every line of the sample data against the contract |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
 | `.python-version` | The Python version the project uses |
```

</details>

<a id="step-04-docs-.gitignore-402aec-diff"></a>

<details><summary>The diff of <code>docs/.gitignore</code></summary>

```diff
@@ -0,0 +1,2 @@
+/.quarto/
+**/*.quarto_ipynb
```

</details>

<a id="step-04-docs-_quarto.yml-ee884f-diff"></a>

<details><summary>The diff of <code>docs/_quarto.yml</code></summary>

```diff
@@ -0,0 +1,20 @@
+project:
+  type: website
+  output-dir: _site
+  pre-render: python apidocs.py build  # the reference pages are generated, never edited by hand
+
+website:
+  title: "babykev"
+  sidebar:
+    contents:
+      - index.qmd
+      - section: Reference
+        contents: api/*
+
+format:
+  html:
+    theme: cosmo
+    toc: true
+
+filters:
+  - linkify.lua
```

</details>

<a id="step-04-docs-apidocs.py-e63616-diff"></a>

<details><summary>The diff of <code>docs/apidocs.py</code></summary>

```diff
@@ -0,0 +1,86 @@
+"""Build the reference pages of the docs site from what the program says about itself.
+
+    python docs/apidocs.py build     one page per module into docs/api/, and the index of names
+
+`babykev docs module NAME` prints plain Markdown with no links. This script adds what a site needs:
+a front-matter title, an explicit id on every heading so that anchors are stable, a link to the line
+in the source, and `_symbols.json`, the index that `linkify.lua` reads to turn a name in backticks
+into a link. Quarto runs it before every render (`pre-render` in `_quarto.yml`); nothing is edited.
+"""
+
+import importlib
+import json
+import re
+import sys
+from pathlib import Path
+
+from babykev.docs import PACKAGE, Symbol, inventory, markdown
+
+REPO = "https://github.com/rahuldave/babykev"
+DOCS = Path(__file__).resolve().parent
+ROOT = DOCS.parent
+OUT = DOCS / "api"
+HEADING = re.compile(r"^(#+) (?:class )?(\S+)$")
+
+
+def source_link(
+    sym: Symbol,  # One entry of the inventory
+) -> str:  # A Markdown link to the line that defines it on GitHub
+    """Link a symbol to the line that defines it."""
+    file = Path(importlib.import_module(sym.module).__file__ or "").resolve().relative_to(ROOT)
+    return f"[source]({REPO}/blob/main/{file.as_posix()}#L{sym.line}){{.source-link}}"
+
+
+def page(
+    name: str,  # The module's short name, such as `api`
+    syms: list[Symbol],  # The inventory entries of that module, the module's own first
+) -> str:  # The text of its `.qmd` page
+    """Turn one module's Markdown into a Quarto page: front matter, an id and a link per heading."""
+    by_name = {s.name: s for s in syms if s.name}
+    mod = next(s for s in syms if not s.name)
+    body = markdown(name).split("\n", 1)[1].strip()
+    if body.startswith(mod.summary):
+        body = body[len(mod.summary) :].strip()
+    out = []
+    for line in body.split("\n"):
+        m = HEADING.match(line)
+        if m and m.group(2) in by_name:
+            sym = by_name[m.group(2)]
+            out += [f"{line} {{#{sym.name}}}", "", source_link(sym)]
+        else:
+            out.append(line)
+    front = f"---\ntitle: {json.dumps(mod.module)}\ndescription: {json.dumps(mod.summary)}\n---\n\n"
+    return front + "\n".join(out) + "\n"
+
+
+def build() -> int:  # The exit code, always 0
+    """Write one reference page per module, and the index of names that cross-references use."""
+    OUT.mkdir(exist_ok=True)
+    index: dict[str, str] = {}
+    modules = sorted({s.module for s in inventory(PACKAGE)})
+    for name in modules:
+        syms = [s for s in inventory(PACKAGE) if s.module == name]
+        short = name.rpartition(".")[2]
+        (OUT / f"{short}.qmd").write_text(page(short, syms), encoding="utf-8")
+        for s in syms:
+            if s.name:
+                target = f"/api/{short}.qmd#{s.name}"
+                index.setdefault(s.name, target)  # `render`
+                index[f"{name}.{s.name}"] = target  # `babykev.api.render`
+    (DOCS / "_symbols.json").write_text(json.dumps(index, indent=1), encoding="utf-8")
+    print(f"wrote {len(modules)} page(s) to {OUT.relative_to(ROOT)}/")
+    return 0
+
+
+def main(
+    command: str = "build",  # The one command the script has
+) -> int:  # The exit code: 0, or 2 for a word that is no command
+    """Run one command of the script: only `build`, so far."""
+    if command == "build":
+        return build()
+    print(f"unknown command {command!r}: use build")
+    return 2
+
+
+if __name__ == "__main__":
+    sys.exit(main(*sys.argv[1:]))
```

</details>

<a id="step-04-docs-index.qmd-d6d880-diff"></a>

<details><summary>The diff of <code>docs/index.qmd</code></summary>

```diff
@@ -0,0 +1,21 @@
+---
+title: babykev
+---
+
+babykev is a small decision model. You send it one document, the *context* (the `state` field of a
+request), and a set of typed questions about it. It returns a probability for every possible answer to
+every question, in one forward pass. It generates no text.
+
+## The contract
+
+A request is a `SystemOneRequest`: a context and one or more questions, each a `Noul`, a `Choice` or a
+`Score`. `to_record` turns the request into the text and the options the model sees, and `to_answers`
+turns the model's probabilities back into answers.
+
+## The reference
+
+The pages under Reference are generated from the source, by `babykev docs module NAME`. Types come from
+the annotations, the description of each parameter from the comment beside it, and the summary from the
+docstring. A name in backticks, anywhere on this site, links to its entry: `render`, `choice_confidence`,
+`score_confidence`. The same text, as plain Markdown, is what `babykev docs list` and `babykev docs
+module api` print at the terminal, for people and for agents.
```

</details>

<a id="step-04-docs-linkify.lua-9e5197-diff"></a>

<details><summary>The diff of <code>docs/linkify.lua</code></summary>

```diff
@@ -0,0 +1,19 @@
+-- Cross-references: a backticked name in prose becomes a link to its reference entry,
+-- when the name is a documented symbol. The index is written by apidocs.py.
+local symbols = {}
+local f = io.open(quarto.project.directory .. "/_symbols.json", "r")
+if f then
+  symbols = quarto.json.decode(f:read("a"))
+  f:close()
+end
+
+return {
+  {
+    traverse = "topdown",
+    Link = function(el) return el, false end,   -- leave existing links alone
+    Code = function(el)
+      local target = symbols[(el.text:gsub("%(%)$", ""))]
+      if target then return pandoc.Link(el, target), false end   -- false: do not revisit the new link
+    end,
+  },
+}
```

</details>

<a id="step-04-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

```diff
@@ -23,10 +23,15 @@ help *verb:
         uv run {{ program }} "$1" help
     fi
 
-# Install Python and every dependency into .venv, exactly as the lockfile says, and the git hook
+# Install Python and every dependency into .venv, exactly as the lockfile says, and the git hook. Says if Quarto is missing
 [group('setup')]
 setup *args:
-    {{ if args == "help" { "just help setup" } else { "uv sync --locked && uv run pre-commit install" } }}
+    #!/usr/bin/env sh
+    set -e
+    if [ "$*" = help ]; then just help setup; exit 0; fi
+    uv sync --locked
+    uv run pre-commit install
+    command -v quarto > /dev/null || echo "Quarto is not on this machine; just docs needs it: https://quarto.org/docs/get-started/"
 
 # Format the code, one way, no arguments. Extra arguments go to ruff: just fmt --check, just fmt --diff
 [group('quality')]
@@ -69,3 +74,12 @@ check *args:
     just lint
     just test -q --cov-fail-under=90
     just lint-config
+
+# Build the docs site into docs/_site. Words go to the program: just docs list, just docs module api, just docs check
+[group('docs')]
+[no-exit-message]
+docs *args:
+    #!/usr/bin/env sh
+    if [ "$*" = help ]; then just help docs; exit 0; fi
+    if [ "$#" -eq 0 ]; then exec uv run quarto render docs; fi
+    exec uv run {{ program }} docs "$@"
```

</details>

<a id="step-04-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -8,6 +8,7 @@ license-files = ["LICENSE", "NOTICE"]
 authors = [{ name = "Rahul Dave" }]
 requires-python = ">=3.13"
 dependencies = [
+    "fastcore>=2.2.32",
     "pydantic>=2.11",
 ]
 
@@ -38,7 +39,10 @@ addopts = "--cov=babykev --cov-report=term-missing"
 
 [tool.ruff]
 # The one setting the formatter and the linter share. Ruff's own default is 88; this project reads better
-# at 100, and docs-check (later) needs a signature with its docments to fit on a line.
+# at 100. A docment (the comment beside a parameter, read by `babykev docs`) must fit on its line: the
+# formatter wraps a longer line, the comment lands away from its parameter, and `docs check` reports it
+# as missing. Nothing else in the formatter or the linter touches a docment: a line with a comment is
+# never joined with another, and no rule here looks inside a comment.
 line-length = 100
 
 [tool.ruff.format]
```

</details>

<a id="step-04-src-babykev-cli.py-a9e184-diff"></a>

<details><summary>The diff of <code>src/babykev/cli.py</code></summary>

```diff
@@ -2,20 +2,26 @@
 
 import sys
 
+from babykev import docs
+
 HELP = """\
 babykev: a small decision model. Context, typed questions, and a probability for every answer.
 
 usage: babykev COMMAND [FLAGS]
        babykev help
 
-There are no commands yet.
+commands:
+  docs    what the code says about itself, as Markdown: docs list, docs module NAME, docs check
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
+    if words[0] == "docs":
+        raise SystemExit(docs.main(words[1:]))
+    print(f"babykev: no command named {words[0]!r}. Run `babykev help`.", file=sys.stderr)
+    raise SystemExit(2)
```

</details>

<a id="step-04-src-babykev-docs.py-267fa4-diff"></a>

<details><summary>The diff of <code>src/babykev/docs.py</code></summary>

````diff
@@ -0,0 +1,407 @@
+"""What the code says about itself, as plain Markdown: every symbol, one module, or the gaps.
+
+    babykev docs list          every module, class, method and function, one line each
+    babykev docs module NAME   one module: a heading per symbol, its signature, docstring and table
+    babykev docs check         count what is typed and documented, list every gap, fail if any
+
+Types come from the annotations, the description of a parameter from its docment (the comment beside
+it, read by fastcore) and the summary from the docstring. Nothing is written twice. The output is
+plain Markdown with no links, ids or URLs, so that a person, an agent or the docs site can read it.
+`list` and `module` show the package; `check` holds the package and the tests to the convention.
+
+How to write a docment, so that the formatter and the linter leave it alone: one parameter per
+line, a trailing comma after the last, the comment two spaces after the code; the return's comment
+after the colon of the `def` line. Every function in this file is an example. The whole line must
+fit in 100 characters: the formatter wraps a longer line, the comment lands away from its parameter,
+and `check` reports it as missing. The formatter never joins a line that carries a comment, and no
+lint rule looks inside one.
+"""
+
+import importlib
+import importlib.util
+import inspect
+import sys
+import types
+import typing
+from dataclasses import dataclass, is_dataclass
+from pathlib import Path
+from pkgutil import iter_modules
+from types import FunctionType, ModuleType
+
+from fastcore.docments import docments
+from pydantic import BaseModel
+
+PACKAGE = "babykev"
+TESTS = Path("tests")
+EMPTY = inspect.Parameter.empty
+USAGE = """\
+usage: babykev docs list            every module, class, method and function, one line each
+       babykev docs module NAME     one module as Markdown: api, cli or docs
+       babykev docs check           what is typed and documented, and every gap; exit 1 if any
+"""
+
+Code = FunctionType | type
+
+
+@dataclass(frozen=True)
+class Symbol:
+    """One line of the inventory: a module, a class, a method or a function, and where it is."""
+
+    module: str  # The module's full name, such as `babykev.api`
+    name: str  # `render` or `Choice._check`: the name inside the module; empty for the module
+    kind: str  # `module`, `class`, `method` or `function`
+    summary: str  # The first line of the docstring, or empty when there is none
+    line: int  # The line the definition starts on; 1 for a module
+
+
+def package_modules(
+    package: str = PACKAGE,  # The name of an importable package
+) -> list[ModuleType]:  # Its public modules, in name order
+    """Import every public module of a package, in name order."""
+    pkg = importlib.import_module(package)
+    names = sorted(m.name for m in iter_modules(pkg.__path__) if not m.name.startswith("_"))
+    return [importlib.import_module(f"{package}.{n}") for n in names]
+
+
+def file_modules(
+    folder: Path,  # A folder of Python files, such as `tests/`
+) -> list[ModuleType]:  # One module per file found, named by its path, in path order
+    """Import every Python file under a folder as a module of its own, named by its path."""
+    mods = []
+    for file in sorted(folder.rglob("*.py")):
+        name = file.as_posix()
+        spec = importlib.util.spec_from_file_location(name, file)
+        if spec is None or spec.loader is None:
+            raise ImportError(f"cannot load {name}")
+        mod = importlib.util.module_from_spec(spec)
+        sys.modules[name] = mod
+        spec.loader.exec_module(mod)
+        mods.append(mod)
+    return mods
+
+
+def module(
+    name: str,  # The module's short name, `api`, or its full name, `babykev.api`
+    package: str = PACKAGE,  # The package to look in
+) -> ModuleType:  # The imported module; `LookupError` when the package has no such module
+    """Find one module of the package by its short name or its full name."""
+    for mod in package_modules(package):
+        if name in (mod.__name__, mod.__name__.rpartition(".")[2]):
+            return mod
+    raise LookupError(name)
+
+
+def doc(
+    obj: object,  # A module, class or function
+) -> str:  # Its own docstring, cleaned of its indentation; empty when there is none
+    """Read an object's own docstring, cleaned of its indentation; empty when there is none."""
+    return inspect.cleandoc(obj.__doc__) if isinstance(obj.__doc__, str) else ""
+
+
+def summary(
+    obj: object,  # A module, class or function
+) -> str:  # The first line of its docstring; empty when there is none
+    """Read the first line of an object's docstring."""
+    return doc(obj).partition("\n")[0]
+
+
+def line_of(
+    sym: Code,  # A function, method or class
+) -> int:  # The line its definition starts on
+    """Find the line a symbol's definition starts on, to keep symbols in source order."""
+    return inspect.getsourcelines(sym)[1]
+
+
+def own(
+    mod: ModuleType,  # An imported module
+    private: bool = False,  # Include names that start with an underscore
+) -> list[Code]:  # The functions and classes the module defines, in source order
+    """List the functions and classes a module defines itself, in source order; not its imports."""
+    found = [
+        o
+        for n, o in vars(mod).items()
+        if (private or not n.startswith("_"))
+        and (inspect.isfunction(o) or inspect.isclass(o))
+        and o.__module__ == mod.__name__
+    ]
+    return sorted(found, key=line_of)
+
+
+def is_dunder(
+    name: str,  # An attribute name
+) -> bool:  # Whether it is one of Python's own, written `__like_this__`
+    """Tell whether a name is one of Python's own, such as `__init__`: a dataclass writes those."""
+    return name.startswith("__") and name.endswith("__")
+
+
+def methods(
+    klass: type,  # A class
+    private: bool = False,  # Include names that start with one underscore
+) -> list[FunctionType]:  # The methods the class defines, in source order
+    """List the methods a class defines itself, in source order, not what it inherits."""
+    found = [(n, getattr(o, "__func__", o)) for n, o in vars(klass).items() if not is_dunder(n)]
+    own_ = [o for n, o in found if (private or not n.startswith("_")) and inspect.isfunction(o)]
+    return sorted(own_, key=line_of)
+
+
+def held(
+    mod: ModuleType,  # An imported module
+) -> list[Code]:  # Every function, class and method in it, private ones too
+    """List everything `check` holds to the convention: every function, class and method."""
+    tops = own(mod, private=True)
+    return [s for t in tops for s in [t, *(methods(t, private=True) if inspect.isclass(t) else [])]]
+
+
+def inventory(
+    package: str = PACKAGE,  # The name of an importable package
+) -> list[Symbol]:  # One entry per public module, class, method and function, in source order
+    """List every public module, class, method and function of a package, with its summary."""
+    out = []
+    for mod in package_modules(package):
+        out.append(Symbol(mod.__name__, "", "module", summary(mod), 1))
+        for top in own(mod):
+            kind = "class" if inspect.isclass(top) else "function"
+            out.append(Symbol(mod.__name__, top.__qualname__, kind, summary(top), line_of(top)))
+            if inspect.isclass(top):
+                out += [
+                    Symbol(mod.__name__, m.__qualname__, "method", summary(m), line_of(m))
+                    for m in methods(top)
+                ]
+    return out
+
+
+def name_of(
+    anno: object,  # A type, as an annotation holds it
+    mod: ModuleType,  # The module the annotation was written in
+) -> str | None:  # The name that module gives the type, or `None` when it has none
+    """Find what a module calls a type: an alias such as `JSONContent`, or the name it imported."""
+    for name, value in vars(mod).items():
+        if name.startswith("_") or inspect.ismodule(value):
+            continue
+        if value is anno or (typing.get_origin(value) is not None and value == anno):
+            return name
+    return None
+
+
+def type_text(
+    anno: object,  # A type, as an annotation holds it
+    mod: ModuleType,  # The module the annotation was written in
+) -> str:  # The type as the source would write it
+    """Write a type the way the source does: `JSONContent`, not the union it stands for."""
+    if isinstance(anno, str):
+        return anno
+    if name := name_of(anno, mod):
+        return name
+    origin, args = typing.get_origin(anno), typing.get_args(anno)
+    if origin in (typing.Union, types.UnionType):
+        return " | ".join(type_text(a, mod) for a in args)
+    if origin is typing.Literal:
+        return f"Literal[{', '.join(repr(a) for a in args)}]"
+    if origin is not None:
+        return f"{type_text(origin, mod)}[{', '.join(type_text(a, mod) for a in args)}]"
+    if anno is None or anno is type(None):
+        return "None"
+    if anno is Ellipsis:
+        return "..."
+    if isinstance(anno, type):
+        return anno.__name__
+    return repr(anno).replace("typing.", "")
+
+
+def signature(
+    sym: Code,  # A function, method or class
+    mod: ModuleType,  # The module it was written in
+) -> str:  # Its parameters and return as one line of Python, without the name
+    """Write a signature as one line of Python: each parameter with its type and default."""
+    sig, parts, star = inspect.signature(sym), [], False
+    for p in sig.parameters.values():
+        if p.name in ("self", "cls"):
+            continue
+        if p.kind is p.KEYWORD_ONLY and not star:
+            parts.append("*")
+        star = star or p.kind in (p.KEYWORD_ONLY, p.VAR_POSITIONAL)
+        prefix = {p.VAR_POSITIONAL: "*", p.VAR_KEYWORD: "**"}.get(p.kind, "")
+        text = prefix + p.name
+        if p.annotation is not EMPTY:
+            text += f": {type_text(p.annotation, mod)}"
+        if p.default is not EMPTY:
+            text += f" = {p.default!r}"
+        parts.append(text)
+    if inspect.isclass(sym) or sig.return_annotation is EMPTY:
+        return f"({', '.join(parts)})"
+    return f"({', '.join(parts)}) -> {type_text(sig.return_annotation, mod)}"
+
+
+def cell(
+    text: str,  # The text of one cell
+) -> str:  # The same text with every `|` escaped
+    """Make text safe inside a Markdown table cell."""
+    return text.replace("|", "\\|")
+
+
+def table(
+    rows: list[list[str]],  # The cells of each row
+    head: list[str],  # The column titles
+) -> str:  # A Markdown table; empty when there are no rows
+    """Write a Markdown table, or nothing when there are no rows."""
+    if not rows:
+        return ""
+    lines = [head, ["---"] * len(head), *rows]
+    return "\n".join("| " + " | ".join(cell(c) for c in row) + " |" for row in lines)
+
+
+def params_table(
+    sym: Code,  # A function, method or dataclass
+    mod: ModuleType,  # The module it was written in
+) -> str:  # A Markdown table of its parameters and its return: type, default, description
+    """Describe a function by its parameters and its return: type, default, docment."""
+    rows = []
+    for name, d in docments(sym, full=True).items():
+        if name in ("self", "cls"):
+            continue
+        anno = "" if d.anno is EMPTY else type_text(d.anno, mod)
+        if name == "return":
+            if d.anno is not EMPTY and d.anno is not None:
+                rows.append(["returns", anno, "", d.docment or ""])
+            continue
+        default = "required" if d.default is EMPTY else f"`{d.default!r}`"
+        rows.append([f"`{name}`", anno, default, d.docment or ""])
+    return table(rows, ["Parameter", "Type", "Default", "Description"])
+
+
+def fields_table(
+    model: type[BaseModel],  # A pydantic model class
+    mod: ModuleType,  # The module it was written in
+) -> str:  # A Markdown table of its fields: type, default, description
+    """Describe a pydantic model by its fields, because its constructor signature says nothing."""
+    rows = []
+    for name, f in model.model_fields.items():
+        default = "required" if f.is_required() else f"`{f.default!r}`"
+        rows.append([f"`{name}`", type_text(f.annotation, mod), default, f.description or ""])
+    return table(rows, ["Field", "Type", "Default", "Description"])
+
+
+def has_init(
+    klass: type,  # A class
+) -> bool:  # Whether it has a constructor of its own, written by hand or by `dataclass`
+    """Tell whether a class has a constructor of its own to show, as a dataclass does."""
+    return is_dataclass(klass) or "__init__" in vars(klass)
+
+
+def entry(
+    sym: Code,  # A function, method or class
+    level: int,  # The heading level of its entry: 2 for a top-level symbol, 3 for a method
+) -> str:  # The Markdown of one entry
+    """Write one symbol: a heading, its signature, its docstring and the table of its parameters."""
+    mod = sys.modules[sym.__module__]
+    is_class = inspect.isclass(sym)
+    head = f"{'#' * level} {'class ' if is_class else ''}{sym.__qualname__}"
+    if is_class and issubclass(sym, BaseModel):
+        parts = [head, doc(sym), fields_table(sym, mod)]
+    elif is_class and not has_init(sym):
+        parts = [head, doc(sym)]
+    else:
+        code = f"```python\n{sym.__qualname__}{signature(sym, mod)}\n```"
+        parts = [head, code, doc(sym), params_table(sym, mod)]
+    return "\n\n".join(p for p in parts if p)
+
+
+def markdown(
+    name: str,  # The module's short name, `api`, or its full name, `babykev.api`
+    package: str = PACKAGE,  # The package to look in
+) -> str:  # The whole module as plain Markdown
+    """Write one module as plain Markdown: its docstring, then an entry for each public symbol."""
+    mod = module(name, package)
+    parts = [f"# {mod.__name__}", doc(mod)]
+    for top in own(mod):
+        parts.append(entry(top, 2))
+        if inspect.isclass(top):
+            parts += [entry(m, 3) for m in methods(top)]
+    return "\n\n".join(p for p in parts if p) + "\n"
+
+
+def gaps_of(
+    sym: Code,  # A function, method or class
+) -> list[str]:  # One message per gap; empty when the symbol is fully typed and documented
+    """Find what one symbol is missing: a docstring, a type, a docment, or a field description."""
+    name, out = f"{sym.__module__}:{sym.__qualname__}", []
+    if not doc(sym):
+        out.append(f"{name}: no docstring")
+    is_class = inspect.isclass(sym)
+    if is_class and issubclass(sym, BaseModel):
+        fields = sym.model_fields.items()
+        return out + [f"{name}.{n}: no description" for n, f in fields if not f.description]
+    if is_class and not has_init(sym):
+        return out
+    for pname, d in docments(sym, full=True).items():
+        if pname in ("self", "cls"):
+            continue
+        if pname == "return":
+            if d.anno is EMPTY and not is_class:
+                out.append(f"{name}: no return type")
+            elif d.anno is not None and not d.docment and not is_class:
+                out.append(f"{name}: no return docment")
+            continue
+        if d.anno is EMPTY:
+            out.append(f"{name}({pname}): no type")
+        if not d.docment:
+            out.append(f"{name}({pname}): no docment")
+    return out
+
+
+def gaps(
+    mod: ModuleType,  # An imported module
+) -> dict[str, list[str]]:  # The gaps of each symbol under its name, the module's under its own
+    """Find every gap in a module, under the module's name and then under each symbol's."""
+    out = {mod.__name__: [] if doc(mod) else [f"{mod.__name__}: no module docstring"]}
+    for sym in held(mod):
+        out[sym.__qualname__] = gaps_of(sym)
+    return out
+
+
+def check(
+    package: str = PACKAGE,  # The package to hold to the convention
+    tests: Path | None = None,  # A folder of tests to hold to it too, or `None`
+) -> int:  # The exit code: 0 when nothing is missing, 1 otherwise
+    """Print how much of each module is typed and documented, then every gap, then the total."""
+    found, done, total = [], 0, 0
+    for mod in package_modules(package) + (file_modules(tests) if tests else []):
+        missing = gaps(mod)
+        found += missing.pop(mod.__name__)
+        complete = sum(not g for g in missing.values())
+        print(f"{mod.__name__:32s} {complete:3d} of {len(missing):3d}")
+        found += [message for g in missing.values() for message in g]
+        done, total = done + complete, total + len(missing)
+    print("\n".join(["", *found]) if found else "")
+    print(f"{done} of {total} functions, methods and classes are typed and documented")
+    return 1 if found else 0
+
+
+def main(
+    words: list[str],  # The words after `babykev docs`: `list`, `module NAME`, `check`, `help`
+    package: str = PACKAGE,  # The package to document
+    tests: Path = TESTS,  # The folder of tests that `check` holds to the convention, if it exists
+) -> int:  # The exit code: 0, 1 when `check` finds a gap, 2 for words that are no command
+    """Run one docs command and return its exit code."""
+    if words in (["help"], ["--help"], ["-h"]):
+        print(USAGE, end="")
+        return 0
+    if words == ["list"]:
+        found = inventory(package)
+        names = [f"{s.module}.{s.name}" if s.name else s.module for s in found]
+        width = max(len(n) for n in names)
+        for s, name in zip(found, names, strict=True):
+            print(f"{s.kind:9s} {name:{width}s}  {s.summary}")
+        return 0
+    if len(words) == 2 and words[0] == "module":
+        try:
+            print(markdown(words[1], package), end="")
+        except LookupError:
+            names = ", ".join(m.__name__.rpartition(".")[2] for m in package_modules(package))
+            print(f"babykev docs: no module {words[1]!r}. The modules: {names}", file=sys.stderr)
+            return 2
+        return 0
+    if words == ["check"]:
+        return check(package, tests if tests.is_dir() else None)
+    print(USAGE, end="", file=sys.stderr)
+    return 2
````

</details>

<a id="step-04-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -1,4 +1,4 @@
-"""Unit tests for the `babykev` command: `help` prints the help, any other word is refused."""
+"""Unit tests for the `babykev` command: `help`, `docs`, and the refusal of any other word."""
 
 import pytest
 
@@ -30,3 +30,13 @@ def test_an_unknown_command_is_refused_with_exit_code_2(
     err = capsys.readouterr().err
     assert "no command named 'train'" in err
     assert "babykev help" in err
+
+
+def test_docs_is_passed_to_the_docs_command(
+    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+) -> None:
+    """`babykev docs list` runs the docs command and exits with its code."""
+    with pytest.raises(SystemExit) as exit_info:
+        run(monkeypatch, "docs", "list")
+    assert exit_info.value.code == 0
+    assert "babykev.api" in capsys.readouterr().out
```

</details>

<a id="step-04-tests-unit-test_docs.py-31dd08-diff"></a>

<details><summary>The diff of <code>tests/unit/test_docs.py</code></summary>

````diff
@@ -0,0 +1,265 @@
+"""Unit tests for `babykev.docs`: the inventory, the Markdown of a module, the gaps, the command."""
+
+import sys
+from pathlib import Path
+
+import pytest
+
+from babykev import docs
+
+# A small package to document: one module with a documented function, a bare one, and a class
+THING = '''
+"""A thing, with one function that is documented and one that is not."""
+
+from typing import Literal
+
+from pydantic import BaseModel, Field
+
+Pair = tuple[int, int]
+
+
+def greet(
+    name: str,  # Who to greet
+    times: int = 1,  # How many times over
+) -> str:  # The greeting
+    """Say hello."""
+    return f"hello {name}" * times
+
+
+def bare(x, y=2):
+    return x + y
+
+
+def span(
+    p: Pair,  # Two numbers
+) -> None:
+    """Print the pair."""
+    print(p)
+
+
+class Box(BaseModel):
+    """A box, as a pydantic model: its fields are its signature."""
+
+    kind: Literal["big", "small"] = Field(description="How big")
+    label: str | None = None
+
+
+class Thing:
+    """A thing with a method."""
+
+    def size(self) -> int:  # Always one
+        """Measure the thing."""
+        return 1
+
+    def _hidden(self):
+        return 0
+'''
+
+
+def example(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> str:
+    """Write the example package into a folder, make it importable, and return its name."""
+    (tmp_path / "pkg").mkdir()
+    (tmp_path / "pkg" / "__init__.py").write_text('"""The example package."""\n', encoding="utf-8")
+    (tmp_path / "pkg" / "thing.py").write_text(THING, encoding="utf-8")
+    for name in ("pkg", "pkg.thing"):
+        monkeypatch.delitem(sys.modules, name, raising=False)
+    monkeypatch.syspath_prepend(tmp_path)
+    return "pkg"
+
+
+# The inventory
+
+
+def test_inventory_lists_the_public_symbols_in_source_order(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+) -> None:
+    """Every module, function, class and public method is listed once, with its kind and summary."""
+    pkg = example(tmp_path, monkeypatch)
+    found = [(s.kind, s.name, s.summary) for s in docs.inventory(pkg)]
+    assert found == [
+        ("module", "", "A thing, with one function that is documented and one that is not."),
+        ("function", "greet", "Say hello."),
+        ("function", "bare", ""),
+        ("function", "span", "Print the pair."),
+        ("class", "Box", "A box, as a pydantic model: its fields are its signature."),
+        ("class", "Thing", "A thing with a method."),
+        ("method", "Thing.size", "Measure the thing."),
+    ]
+
+
+def test_inventory_knows_the_line_of_each_symbol(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+) -> None:
+    """The line of a symbol is where its `def` or `class` is in the source."""
+    pkg = example(tmp_path, monkeypatch)
+    lines = {s.name: s.line for s in docs.inventory(pkg)}
+    source = THING.splitlines()
+    assert source[lines["greet"] - 1].startswith("def greet(")
+    assert source[lines["Thing"] - 1] == "class Thing:"
+    assert source[lines["Thing.size"] - 1].strip().startswith("def size(")
+
+
+# The Markdown of a module
+
+
+def test_markdown_has_a_heading_a_signature_a_docstring_and_a_table_per_function(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+) -> None:
+    """A function's entry shows its signature as Python and its parameters with their docments."""
+    text = docs.markdown("thing", example(tmp_path, monkeypatch))
+    assert text.startswith("# pkg.thing\n\nA thing, with one function")
+    assert (
+        "## greet\n\n```python\ngreet(name: str, times: int = 1) -> str\n```\n\nSay hello." in text
+    )
+    assert "| `name` | str | required | Who to greet |" in text
+    assert "| `times` | int | `1` | How many times over |" in text
+    assert "| returns | str |  | The greeting |" in text
+
+
+def test_markdown_writes_a_type_alias_by_its_name(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+) -> None:
+    """`Pair` is written as the source wrote it, and a `None` return gets no row in the table."""
+    text = docs.markdown("thing", example(tmp_path, monkeypatch))
+    assert "span(p: Pair) -> None" in text
+    assert "| `p` | Pair | required | Two numbers |" in text
+    assert "| returns | None" not in text
+
+
+def test_markdown_shows_a_class_and_its_public_methods_only(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+) -> None:
+    """A class is a heading and its docstring; each public method is a heading one level down."""
+    text = docs.markdown("thing", example(tmp_path, monkeypatch))
+    assert "## class Thing\n\nA thing with a method.\n\n### Thing.size\n\n" in text
+    assert "### Thing.size\n\n```python\nThing.size() -> int\n```\n\nMeasure the thing." in text
+    assert "_hidden" not in text
+
+
+def test_markdown_shows_a_pydantic_model_as_a_table_of_fields(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+) -> None:
+    """A model has no signature to show; its fields are the table, each with its description."""
+    text = docs.markdown("thing", example(tmp_path, monkeypatch))
+    assert (
+        "## class Box\n\nA box, as a pydantic model: its fields are its signature.\n\n| Field |"
+        in text
+    )
+    assert "| `kind` | Literal['big', 'small'] | required | How big |" in text
+    assert "| `label` | str \\| None | `None` |  |" in text
+
+
+def test_markdown_has_no_links_and_no_ids(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
+    """The program's Markdown is plain: the site adds the ids and the links itself."""
+    text = docs.markdown("thing", example(tmp_path, monkeypatch))
+    assert "{#" not in text
+    assert "](" not in text
+    assert "http" not in text
+
+
+def test_an_unknown_module_is_a_lookup_error(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+) -> None:
+    """Asking for a module the package does not have raises, with the name."""
+    with pytest.raises(LookupError, match="nothing"):
+        docs.markdown("nothing", example(tmp_path, monkeypatch))
+
+
+# The gaps
+
+
+def test_gaps_names_what_each_symbol_is_missing(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+) -> None:
+    """A documented symbol has no gaps; a bare one is missing its docstring, types and docments.
+
+    `y` has a default, and fastcore takes a type from a default, so only its docment is missing.
+    """
+    pkg = example(tmp_path, monkeypatch)
+    found = docs.gaps(docs.module("thing", pkg))
+    assert found["pkg.thing"] == []
+    assert found["greet"] == []
+    assert found["Thing"] == []
+    assert found["Thing.size"] == []
+    assert found["Box"] == ["pkg.thing:Box.label: no description"]
+    assert found["bare"] == [
+        "pkg.thing:bare: no docstring",
+        "pkg.thing:bare(x): no type",
+        "pkg.thing:bare(x): no docment",
+        "pkg.thing:bare(y): no docment",
+        "pkg.thing:bare: no return type",
+    ]
+    assert found["Thing._hidden"] == [
+        "pkg.thing:Thing._hidden: no docstring",
+        "pkg.thing:Thing._hidden: no return type",
+    ]
+
+
+def test_a_return_that_is_not_none_needs_a_docment(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+) -> None:
+    """`span` returns `None` and needs no docment for it; `greet` returns a value and has one."""
+    pkg = example(tmp_path, monkeypatch)
+    found = docs.gaps(docs.module("thing", pkg))
+    assert found["span"] == []
+    (tmp_path / "pkg" / "thing.py").write_text(THING.replace("-> str:  # The greeting", "-> str:"))
+    monkeypatch.delitem(sys.modules, "pkg.thing")
+    found = docs.gaps(docs.module("thing", pkg))
+    assert found["greet"] == ["pkg.thing:greet: no return docment"]
+
+
+# The command
+
+
+def test_check_prints_a_count_per_module_then_every_gap_and_fails(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+) -> None:
+    """`check` prints one line per module, the gaps, the total, and exits 1 when there is a gap."""
+    pkg = example(tmp_path, monkeypatch)
+    assert docs.main(["check"], pkg, tmp_path / "no-tests") == 1
+    out = capsys.readouterr().out
+    assert "pkg.thing                          4 of   7" in out
+    assert "pkg.thing:bare(x): no docment" in out
+    assert out.endswith("4 of 7 functions, methods and classes are typed and documented\n")
+
+
+def test_check_holds_the_tests_to_the_convention_too(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+) -> None:
+    """A folder of tests is checked like the package, each file under its path."""
+    pkg = example(tmp_path, monkeypatch)
+    (tmp_path / "tests").mkdir()
+    (tmp_path / "tests" / "test_x.py").write_text(
+        '"""Tests."""\n\n\ndef test_x() -> None:\n    """One."""\n'
+    )
+    assert docs.main(["check"], pkg, tmp_path / "tests") == 1
+    assert "/tests/test_x.py" in capsys.readouterr().out
+
+
+def test_list_prints_one_line_per_symbol(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+) -> None:
+    """`list` prints the kind, the full name and the summary, aligned."""
+    assert docs.main(["list"], example(tmp_path, monkeypatch)) == 0
+    lines = capsys.readouterr().out.splitlines()
+    assert lines[0].startswith("module    pkg.thing             A thing, with one function")
+    assert lines[-1] == "method    pkg.thing.Thing.size  Measure the thing."
+
+
+def test_module_prints_the_markdown_and_an_unknown_name_is_refused(
+    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+) -> None:
+    """`module NAME` prints the Markdown; a name that is no module is refused, the modules named."""
+    pkg = example(tmp_path, monkeypatch)
+    assert docs.main(["module", "thing"], pkg) == 0
+    assert capsys.readouterr().out.startswith("# pkg.thing\n")
+    assert docs.main(["module", "nothing"], pkg) == 2
+    assert "no module 'nothing'. The modules: thing" in capsys.readouterr().err
+
+
+def test_help_and_a_bad_word(capsys: pytest.CaptureFixture[str]) -> None:
+    """`help` prints the usage and exits 0; anything else prints it to stderr and exits 2."""
+    assert docs.main(["help"]) == 0
+    assert capsys.readouterr().out == docs.USAGE
+    assert docs.main(["render"]) == 2
+    assert capsys.readouterr().err == docs.USAGE
````

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/compare/651cd62cf2d09d53225ed11c9befd7c2316ec1aa...d27a7f152ade46e9024f0b97481b85fcce07a16c).

This part ends at the code at `step-04`. [The code after this part](https://github.com/rahuldave/babykev/tree/step-04)

<a id="step-04b"></a>

## 4b Every function documented

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `step-04`. [The code before this part](https://github.com/rahuldave/babykev/tree/step-04)

**Init.** `just setup` changes nothing in `.venv`: no dependency arrived. It prints `Checked 29 packages` and reinstalls the hook. 0.4 s.

```bash
just setup
```

**What is new:** the 84 gaps of step 04, filled. A docment beside each of the 18 parameters and returns of `api.py`, a description on each of its 11 model fields, a docstring on the validator; a docment on each of the 54 parameters and returns of the tests. And one line in the justfile: `just docs check` inside `just check`. This commit is clean. Everything is green, and the live part deletes one docment to show the check, and then the hook, catching it.

**A. Green.** `just docs check` prints `12 of 12` for `api`, then `1 of 1`, `26 of 26`, `29 of 29`, `4 of 4`, `16 of 16`, no gap, and `88 of 88 functions, methods and classes are typed and documented`, exit 0. 0.6 s, or 1.5 s the first time after a move, while Python compiles the files.

```bash
just docs check
```

**B. What a documented function looks like.** The `sed` line prints `render`, lines 68 to 72 of `api.py`: each parameter on its own line with its docment, the return's docment after the colon, the docstring below. The types of `indent` and the return say `int` and `str`; their comments say what the number means and what the text is for. A docment is for what the type cannot say.

```bash
sed -n '68,72p' src/babykev/api.py
```

**C. A model field's description.** The `sed` line prints `Noul`, lines 16 to 24. A pydantic model has no signature to put a comment on, so each field carries `Field(description=...)`, and `docs check` reads that the way it reads a docment. The `state` field of `SystemOneRequest` says "The context: the document the questions are about".

```bash
sed -n '16,24p' src/babykev/api.py
```

**D. The Markdown, filled.** `just docs module api` prints the same table as at step 04, every Description cell now filled. Scroll to `render`: "Text, a number, a list or an object, from a request", "How deeply nested this value is; each level indents by two spaces", "The text the model sees". Nothing was written twice: the comment beside the parameter is the cell in the table.

```bash
just docs module api
```

**E. The site, filled.** `just docs` builds the site again, 5 s. The `open` line shows `api`'s page with every description in place.

```bash
just docs
open docs/_site/index.html
```

**F. Delete one docment.** The `sed` line removes the comment beside `indent` in `render`. `just docs check` then prints `babykev.api 11 of 12`, one gap, `babykev.api:render(indent): no docment`, `87 of 88`, exit 1. 0.6 s. The `git restore` line puts the comment back.

```bash
sed -i '' 's|,  # How deeply nested.*|,|' src/babykev/api.py
just docs check
git restore src/babykev/api.py
```

**G. The hook refuses it.** The same `sed` line again, then a commit. The hook prints its four hooks: three `Passed` or `Skipped`, then `just check...Failed`, and under it everything `check` ran: the formatter (9 files), the linter (All checks passed!), the tests (69 passed, 97.78%), and then `docs check`'s table ending `babykev.api:render(indent): no docment`, `87 of 88`. 3.3 s. No commit was made: `git status` shows the file still modified, and the log still ends at this step. The `git restore` line puts the file back.

```bash
sed -i '' 's|,  # How deeply nested.*|,|' src/babykev/api.py
git commit -am "try"
git status
git restore src/babykev/api.py
```

**H. `check` has five lines now.** `just --show check` prints the recipe: `fmt --check`, `lint`, `test` over the floor, `docs check`, `lint-config`. `just check` runs all five, green, 2.8 s.

```bash
just --show check
just check
```

**What the next step does.** Step 05 brings the second file, `model.py`, as kev wrote it, and the cycle runs again: a file arrives bare, then its tests, types and docments, now under checks that exist.

### What changed

- <a id="step-04b-README.md-8ec9a0"></a>`README.md`: 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/a9a391de1f271392a948cdd16afe2f3b1cfdd437/README.md).
- <a id="step-04b-justfile-424f0b"></a>`justfile`: 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/a9a391de1f271392a948cdd16afe2f3b1cfdd437/justfile).
- <a id="step-04b-src-babykev-api.py-2ea65f"></a>`src/babykev/api.py`: changes `Choice`, `Noul`, `Score`, `SystemOneRequest`, `_check`, `choice_confidence`, `option_text`, `render`, `round_prob`, `score_confidence`, `to_answers`, `to_record`. 48 lines added, 19 removed. [The file](https://github.com/rahuldave/babykev/blob/a9a391de1f271392a948cdd16afe2f3b1cfdd437/src/babykev/api.py).
- <a id="step-04b-tests-unit-test_api.py-58d97c"></a>`tests/unit/test_api.py`: changes `cheese_request`, `test_option_text_adds_a_description_only_when_there_is_one`, `test_render_flattens_json_into_text`, `test_sample_line_fits_the_contract`, `test_sample_line_has_a_usable_label_on_every_question`, `test_score_confidence_is_one_when_certain`. 17 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/a9a391de1f271392a948cdd16afe2f3b1cfdd437/tests/unit/test_api.py).
- <a id="step-04b-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: changes `run`, `test_an_unknown_command_is_refused_with_exit_code_2`, `test_docs_is_passed_to_the_docs_command`, `test_help_is_printed_for_help_and_for_no_words`. 11 lines added, 4 removed. [The file](https://github.com/rahuldave/babykev/blob/a9a391de1f271392a948cdd16afe2f3b1cfdd437/tests/unit/test_cli.py).
- <a id="step-04b-tests-unit-test_docs.py-31dd08"></a>`tests/unit/test_docs.py`: changes `example`, `test_a_return_that_is_not_none_needs_a_docment`, `test_an_unknown_module_is_a_lookup_error`, `test_check_holds_the_tests_to_the_convention_too`, `test_check_prints_a_count_per_module_then_every_gap_and_fails`, `test_gaps_names_what_each_symbol_is_missing`, `test_help_and_a_bad_word`, `test_inventory_knows_the_line_of_each_symbol`, `test_inventory_lists_the_public_symbols_in_source_order`, `test_list_prints_one_line_per_symbol`, `test_markdown_has_a_heading_a_signature_a_docstring_and_a_table_per_function`, `test_markdown_has_no_links_and_no_ids`, `test_markdown_shows_a_class_and_its_public_methods_only`, `test_markdown_shows_a_pydantic_model_as_a_table_of_fields`, `test_markdown_writes_a_type_alias_by_its_name`, `test_module_prints_the_markdown_and_an_unknown_name_is_refused`. 41 lines added, 16 removed. [The file](https://github.com/rahuldave/babykev/blob/a9a391de1f271392a948cdd16afe2f3b1cfdd437/tests/unit/test_docs.py).

<a id="step-04b-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -62,7 +62,8 @@ agents: `just docs list` names every module, class and function with its summary
 prints one module, and `just docs check` counts what is typed and documented and lists every gap. The
 convention: every function is typed, has a docstring, and carries a docment, a comment beside each
 parameter and the return, which the formatter and the linter leave alone as long as the line fits in 100
-characters. `src/babykev/docs.py` is the example to read.
+characters. `src/babykev/docs.py` is the example to read. `just docs check` is part of `just check`, so a
+commit that leaves a gap is refused by the hook.
 
 ## What is here
 
```

</details>

<a id="step-04b-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

```diff
@@ -63,7 +63,7 @@ lint-config *args:
 test *args:
     {{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
 
-# Everything a commit must pass: format, lint, the tests over the coverage floor, the config files
+# Everything a commit must pass: format, lint, the tests over the coverage floor, the docs, the config files
 [group('quality')]
 [no-exit-message]
 check *args:
@@ -73,6 +73,7 @@ check *args:
     just fmt --check
     just lint
     just test -q --cov-fail-under=90
+    just docs check
     just lint-config
 
 # Build the docs site into docs/_site. Words go to the program: just docs list, just docs module api, just docs check
```

</details>

<a id="step-04b-src-babykev-api.py-2ea65f-diff"></a>

<details><summary>The diff of <code>src/babykev/api.py</code></summary>

```diff
@@ -16,20 +16,26 @@ MAX_OPTIONS = 255
 class Noul(BaseModel):
     """A yes-or-no question."""
 
-    type: Literal["noul"]
-    instructions: JSONContent
-    criteria: dict[str, JSONContent] | None = None
+    type: Literal["noul"] = Field(description="Marks the question as yes-or-no")
+    instructions: JSONContent = Field(description="The question, as text or as structured content")
+    criteria: dict[str, JSONContent] | None = Field(
+        default=None,
+        description="What no and yes mean, under the keys `false` and `true`. May be left out",
+    )
 
 
 class Choice(BaseModel):
     """A question answered by picking one of several named options."""
 
-    type: Literal["choice"]
-    instructions: JSONContent
-    criteria: dict[str, JSONContent]
+    type: Literal["choice"] = Field(description="Marks the question as a choice")
+    instructions: JSONContent = Field(description="The question, as text or as structured content")
+    criteria: dict[str, JSONContent] = Field(
+        description="Each option's name with its description, or `null` when the name says enough"
+    )
 
     @model_validator(mode="after")
-    def _check(self) -> Self:
+    def _check(self) -> Self:  # The question, unchanged
+        """Reject a choice with no options or with more than `MAX_OPTIONS`."""
         if not 1 <= len(self.criteria) <= MAX_OPTIONS:
             raise ValueError(f"criteria must have 1..{MAX_OPTIONS} options")
         return self
@@ -38,9 +44,13 @@ class Choice(BaseModel):
 class Score(BaseModel):
     """A question answered with a level on an ordered scale."""
 
-    type: Literal["score"]
-    instructions: JSONContent
-    criteria: list[JSONContent] = Field(min_length=2, max_length=MAX_OPTIONS)
+    type: Literal["score"] = Field(description="Marks the question as a score")
+    instructions: JSONContent = Field(description="The question, as text or as structured content")
+    criteria: list[JSONContent] = Field(
+        min_length=2,
+        max_length=MAX_OPTIONS,
+        description="The levels of the scale, from lowest to highest",
+    )
 
 
 Question = Noul | Choice | Score
@@ -49,11 +59,16 @@ Question = Noul | Choice | Score
 class SystemOneRequest(BaseModel):
     """One request: a state, and the questions to answer about it."""
 
-    state: JSONContent
-    questions: dict[str, Question] = Field(min_length=1)
+    state: JSONContent = Field(description="The context: the document the questions are about")
+    questions: dict[str, Question] = Field(
+        min_length=1, description="The questions, each under an id the caller chooses"
+    )
 
 
-def render(v: JSONContent, indent: int = 0) -> str:
+def render(
+    v: JSONContent,  # Text, a number, a list or an object, from a request
+    indent: int = 0,  # How deeply nested this value is; each level indents by two spaces
+) -> str:  # The text the model sees
     """Flatten str | object | array into text the model sees. Field names are kept as labels."""
     pad = "  " * indent
     if v is None:
@@ -70,12 +85,17 @@ def render(v: JSONContent, indent: int = 0) -> str:
     )
 
 
-def option_text(name: str, desc: JSONContent) -> str:
+def option_text(
+    name: str,  # The option's name
+    desc: JSONContent,  # Its description, or `None` or an empty string when the name says enough
+) -> str:  # `name`, or `name: description`
     """Write one option as the model sees it."""
     return name if desc is None or desc == "" else f"{name}: {render(desc)}"
 
 
-def to_record(req: SystemOneRequest) -> tuple[dict[str, Any], list[dict[str, Any]]]:
+def to_record(
+    req: SystemOneRequest,  # A validated request
+) -> tuple[dict[str, Any], list[dict[str, Any]]]:  # The record, and one metadata entry per question
     """-> internal record for encode(), plus per-question metadata to map probabilities back."""
     qs, meta = [], []
     for qid, q in req.questions.items():
@@ -100,13 +120,17 @@ def to_record(req: SystemOneRequest) -> tuple[dict[str, Any], list[dict[str, Any
     return {"state": render(req.state), "questions": qs}, meta
 
 
-def choice_confidence(p: list[float]) -> float:
+def choice_confidence(
+    p: list[float],  # The probability of each option
+) -> float:  # 0 for a guess, 1 when one option has all the probability
     """Measure how far the most likely option stands above a guess among `len(p)` options."""
     k = len(p)
     return 1.0 if k == 1 else (max(p) - 1 / k) / (1 - 1 / k)
 
 
-def score_confidence(p: list[float]) -> float:
+def score_confidence(
+    p: list[float],  # The probability of each level, lowest level first
+) -> float:  # 1 when one level has all the probability, 0 for a guess or anything as spread out
     """Measure how closely a score's probabilities sit around the most likely level.
 
     1 when one level has all the probability, 0 for a guess or anything as spread out. The expected
@@ -122,7 +146,9 @@ def score_confidence(p: list[float]) -> float:
     return max(0.0, 1.0 - spread / guess)
 
 
-def round_prob(x: float) -> float:
+def round_prob(
+    x: float,  # A probability, or a number worked out from probabilities
+) -> float:  # The same number to four decimals
     """Round a number for output.
 
     Four decimals keep a rounded distribution's sum within 0.02 of 1 even with MAX_OPTIONS options.
@@ -131,7 +157,10 @@ def round_prob(x: float) -> float:
     return round(float(x), 4)
 
 
-def to_answers(probs: list[list[float]], meta: list[dict[str, Any]]) -> dict[str, Any]:
+def to_answers(
+    probs: list[list[float]],  # For each question, the probability of each of its options
+    meta: list[dict[str, Any]],  # The metadata `to_record` returned for the same request
+) -> dict[str, Any]:  # One answer per question, under the question's id
     """Turn the model's probabilities into answers of each question's type."""
     out = {}
     for p, m in zip(probs, meta, strict=False):
```

</details>

<a id="step-04b-tests-unit-test_api.py-58d97c-diff"></a>

<details><summary>The diff of <code>tests/unit/test_api.py</code></summary>

```diff
@@ -29,7 +29,7 @@ MILKS = {"cow": None, "goat": None, "sheep": None, "mixed": "More than one kind
 FIRMNESS = ["Soft", "Semi-soft", "Semi-hard", "Hard"]
 
 
-def cheese_request() -> SystemOneRequest:
+def cheese_request() -> SystemOneRequest:  # A valid request with three questions
     """One request that asks a question of each type."""
     return SystemOneRequest.model_validate(
         {
@@ -47,7 +47,9 @@ def cheese_request() -> SystemOneRequest:
 
 
 @pytest.mark.parametrize("line", SAMPLE_LINES)
-def test_sample_line_fits_the_contract(line: dict[str, Any]) -> None:
+def test_sample_line_fits_the_contract(
+    line: dict[str, Any],  # One line of the sample data
+) -> None:
     """Every sample line is a valid request and gives one record question per question."""
     request = SystemOneRequest.model_validate(line)
     record, meta = to_record(request)
@@ -57,7 +59,9 @@ def test_sample_line_fits_the_contract(line: dict[str, Any]) -> None:
 
 
 @pytest.mark.parametrize("line", SAMPLE_LINES)
-def test_sample_line_has_a_usable_label_on_every_question(line: dict[str, Any]) -> None:
+def test_sample_line_has_a_usable_label_on_every_question(
+    line: dict[str, Any],  # One line of the sample data
+) -> None:
     """A label is a boolean for noul, an option name for choice, a level index for score."""
     for question in line["questions"].values():
         label = question["label"]
@@ -140,7 +144,10 @@ def test_score_with_one_level_is_rejected() -> None:
         ([{"role": "customer", "content": "hello"}], "- role: customer\n  content: hello"),
     ],
 )
-def test_render_flattens_json_into_text(value: JSONContent, text: str) -> None:
+def test_render_flattens_json_into_text(
+    value: JSONContent,  # What a request might hold
+    text: str,  # What the model should see
+) -> None:
     """Strings, numbers, lists and objects all become the text the model reads."""
     assert render(value) == text
 
@@ -154,7 +161,9 @@ def test_render_flattens_json_into_text(value: JSONContent, text: str) -> None:
     ],
 )
 def test_option_text_adds_a_description_only_when_there_is_one(
-    name: str, description: str | None, text: str
+    name: str,  # The option's name
+    description: str | None,  # Its description, if it has one
+    text: str,  # The option as the model should see it
 ) -> None:
     """An option is its name, followed by its description when it has one."""
     assert option_text(name, description) == text
@@ -285,7 +294,9 @@ def test_score_confidence_of_a_single_level_is_one() -> None:
 
 
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

<a id="step-04b-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -5,7 +5,10 @@ import pytest
 from babykev.cli import HELP, main
 
 
-def run(monkeypatch: pytest.MonkeyPatch, *words: str) -> None:
+def run(
+    monkeypatch: pytest.MonkeyPatch,  # Replaces `sys.argv` for this test only
+    *words: str,  # The command line, as words
+) -> None:
     """Run `babykev` with these words as its command line."""
     monkeypatch.setattr("sys.argv", ["babykev", *words])
     main()
@@ -13,7 +16,9 @@ def run(monkeypatch: pytest.MonkeyPatch, *words: str) -> None:
 
 @pytest.mark.parametrize("words", [(), ("help",), ("--help",), ("-h",)])
 def test_help_is_printed_for_help_and_for_no_words(
-    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], words: tuple[str, ...]
+    monkeypatch: pytest.MonkeyPatch,  # Replaces `sys.argv` for this test only
+    capsys: pytest.CaptureFixture[str],  # Captures what the command prints
+    words: tuple[str, ...],  # The command line, as words
 ) -> None:
     """`babykev`, `babykev help`, `--help` and `-h` all print the help text, and nothing else."""
     run(monkeypatch, *words)
@@ -21,7 +26,8 @@ def test_help_is_printed_for_help_and_for_no_words(
 
 
 def test_an_unknown_command_is_refused_with_exit_code_2(
-    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+    monkeypatch: pytest.MonkeyPatch,  # Replaces `sys.argv` for this test only
+    capsys: pytest.CaptureFixture[str],  # Captures what the command prints
 ) -> None:
     """A word that is not a command is named, the help is pointed to, and the exit code is 2."""
     with pytest.raises(SystemExit) as exit_info:
@@ -33,7 +39,8 @@ def test_an_unknown_command_is_refused_with_exit_code_2(
 
 
 def test_docs_is_passed_to_the_docs_command(
-    monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+    monkeypatch: pytest.MonkeyPatch,  # Replaces `sys.argv` for this test only
+    capsys: pytest.CaptureFixture[str],  # Captures what the command prints
 ) -> None:
     """`babykev docs list` runs the docs command and exits with its code."""
     with pytest.raises(SystemExit) as exit_info:
```

</details>

<a id="step-04b-tests-unit-test_docs.py-31dd08-diff"></a>

<details><summary>The diff of <code>tests/unit/test_docs.py</code></summary>

```diff
@@ -56,7 +56,10 @@ class Thing:
 '''
 
 
-def example(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> str:
+def example(
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
+) -> str:  # The package's name
     """Write the example package into a folder, make it importable, and return its name."""
     (tmp_path / "pkg").mkdir()
     (tmp_path / "pkg" / "__init__.py").write_text('"""The example package."""\n', encoding="utf-8")
@@ -71,7 +74,8 @@ def example(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> str:
 
 
 def test_inventory_lists_the_public_symbols_in_source_order(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
 ) -> None:
     """Every module, function, class and public method is listed once, with its kind and summary."""
     pkg = example(tmp_path, monkeypatch)
@@ -88,7 +92,8 @@ def test_inventory_lists_the_public_symbols_in_source_order(
 
 
 def test_inventory_knows_the_line_of_each_symbol(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
 ) -> None:
     """The line of a symbol is where its `def` or `class` is in the source."""
     pkg = example(tmp_path, monkeypatch)
@@ -103,7 +108,8 @@ def test_inventory_knows_the_line_of_each_symbol(
 
 
 def test_markdown_has_a_heading_a_signature_a_docstring_and_a_table_per_function(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
 ) -> None:
     """A function's entry shows its signature as Python and its parameters with their docments."""
     text = docs.markdown("thing", example(tmp_path, monkeypatch))
@@ -117,7 +123,8 @@ def test_markdown_has_a_heading_a_signature_a_docstring_and_a_table_per_function
 
 
 def test_markdown_writes_a_type_alias_by_its_name(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
 ) -> None:
     """`Pair` is written as the source wrote it, and a `None` return gets no row in the table."""
     text = docs.markdown("thing", example(tmp_path, monkeypatch))
@@ -127,7 +134,8 @@ def test_markdown_writes_a_type_alias_by_its_name(
 
 
 def test_markdown_shows_a_class_and_its_public_methods_only(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
 ) -> None:
     """A class is a heading and its docstring; each public method is a heading one level down."""
     text = docs.markdown("thing", example(tmp_path, monkeypatch))
@@ -137,7 +145,8 @@ def test_markdown_shows_a_class_and_its_public_methods_only(
 
 
 def test_markdown_shows_a_pydantic_model_as_a_table_of_fields(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
 ) -> None:
     """A model has no signature to show; its fields are the table, each with its description."""
     text = docs.markdown("thing", example(tmp_path, monkeypatch))
@@ -149,7 +158,10 @@ def test_markdown_shows_a_pydantic_model_as_a_table_of_fields(
     assert "| `label` | str \\| None | `None` |  |" in text
 
 
-def test_markdown_has_no_links_and_no_ids(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
+def test_markdown_has_no_links_and_no_ids(
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
+) -> None:
     """The program's Markdown is plain: the site adds the ids and the links itself."""
     text = docs.markdown("thing", example(tmp_path, monkeypatch))
     assert "{#" not in text
@@ -158,7 +170,8 @@ def test_markdown_has_no_links_and_no_ids(tmp_path: Path, monkeypatch: pytest.Mo
 
 
 def test_an_unknown_module_is_a_lookup_error(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
 ) -> None:
     """Asking for a module the package does not have raises, with the name."""
     with pytest.raises(LookupError, match="nothing"):
@@ -169,7 +182,8 @@ def test_an_unknown_module_is_a_lookup_error(
 
 
 def test_gaps_names_what_each_symbol_is_missing(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
 ) -> None:
     """A documented symbol has no gaps; a bare one is missing its docstring, types and docments.
 
@@ -196,7 +210,8 @@ def test_gaps_names_what_each_symbol_is_missing(
 
 
 def test_a_return_that_is_not_none_needs_a_docment(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
 ) -> None:
     """`span` returns `None` and needs no docment for it; `greet` returns a value and has one."""
     pkg = example(tmp_path, monkeypatch)
@@ -212,7 +227,9 @@ def test_a_return_that_is_not_none_needs_a_docment(
 
 
 def test_check_prints_a_count_per_module_then_every_gap_and_fails(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
+    capsys: pytest.CaptureFixture[str],  # Captures what the command prints
 ) -> None:
     """`check` prints one line per module, the gaps, the total, and exits 1 when there is a gap."""
     pkg = example(tmp_path, monkeypatch)
@@ -224,7 +241,9 @@ def test_check_prints_a_count_per_module_then_every_gap_and_fails(
 
 
 def test_check_holds_the_tests_to_the_convention_too(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
+    capsys: pytest.CaptureFixture[str],  # Captures what the command prints
 ) -> None:
     """A folder of tests is checked like the package, each file under its path."""
     pkg = example(tmp_path, monkeypatch)
@@ -237,7 +256,9 @@ def test_check_holds_the_tests_to_the_convention_too(
 
 
 def test_list_prints_one_line_per_symbol(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
+    capsys: pytest.CaptureFixture[str],  # Captures what the command prints
 ) -> None:
     """`list` prints the kind, the full name and the summary, aligned."""
     assert docs.main(["list"], example(tmp_path, monkeypatch)) == 0
@@ -247,7 +268,9 @@ def test_list_prints_one_line_per_symbol(
 
 
 def test_module_prints_the_markdown_and_an_unknown_name_is_refused(
-    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
+    capsys: pytest.CaptureFixture[str],  # Captures what the command prints
 ) -> None:
     """`module NAME` prints the Markdown; a name that is no module is refused, the modules named."""
     pkg = example(tmp_path, monkeypatch)
@@ -257,7 +280,9 @@ def test_module_prints_the_markdown_and_an_unknown_name_is_refused(
     assert "no module 'nothing'. The modules: thing" in capsys.readouterr().err
 
 
-def test_help_and_a_bad_word(capsys: pytest.CaptureFixture[str]) -> None:
+def test_help_and_a_bad_word(
+    capsys: pytest.CaptureFixture[str],  # Captures what the command prints
+) -> None:
     """`help` prints the usage and exits 0; anything else prints it to stderr and exits 2."""
     assert docs.main(["help"]) == 0
     assert capsys.readouterr().out == docs.USAGE
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/compare/d27a7f152ade46e9024f0b97481b85fcce07a16c...a9a391de1f271392a948cdd16afe2f3b1cfdd437).

This part ends at the code at `step-04b`. [The code after this part](https://github.com/rahuldave/babykev/tree/step-04b)

<a id="step-05"></a>

## 5 A second file: model.py

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `step-04b`. [The code before this part](https://github.com/rahuldave/babykev/tree/step-04b)

**Init.** `just setup` brings the model's stack: torch (the CPU build, from PyTorch's own index), transformers, peft, safetensors and what they need, hypothesis for the tests, and ty, the type checker. 64 packages in `.venv`, up from 30. From uv's cache it takes a second; the first time on a machine it is a download of a few hundred megabytes.

```bash
just setup
```

**What is new:** `src/babykev/model.py`, kev's model, typed, with a docment on every parameter and return and a docstring on everything; `src/babykev/smoke.py` and `babykev smoke`; a tiny model for the tests (`tests/tiny.py`, `tests/conftest.py`); `test_model.py` and `test_smoke.py`; two recipes, `smoke` and `types`. This commit is dirty on purpose, and nothing in it can tell: the mask lets a question see the questions before it (pretend it came that way from upstream), and two lines are written the way kev wrote them, which ty refuses. Everything `just check` runs is green. Step 05a brings what can see it.

**A. The four ideas.** The `sed` line prints the top of `model.py`, the module docstring, which names them. Packing: the state and every question into one sequence, marked off by five delimiter tokens. The mask: each token sees the state and its own question, never another. Positions restart after the state, so a question looks the same wherever it comes. Pointing: a head scores each option's closing token against the question's decide token; no text is generated.

```bash
sed -n '1,20p' src/babykev/model.py
```

**B. Packing, in the signature.** `encode`, lines 85 to 97: a tokenizer, a record as `to_record` returns it, two limits, and an `Encoded` back, each docment saying what the thing is. The last line printed looks up the five delimiter ids.

```bash
sed -n '85,97p' src/babykev/model.py
```

**The mask, as designed.** `branch_mask`'s docstring, lines 131 to 135 of `model.py`, states the rule: token i may attend to token j when j is not after i, and j is in the state or in the same question as i. The slide draws it as a grid. The cell that matters is a token of question 2 looking at question 1: an ordinary causal mask would allow it, and this rule forbids it. That one cell is the whole difference: it is why question 2 gets the same answer whether or not question 1 was asked. The slide shows the mask as it was designed; whether the code keeps the rule is a question for the end of this step.

```bash
sed -n '131,135p' src/babykev/model.py
```

**C. Pointing.** `PointerHead`, lines 146 to 166: two linear layers and a scaled dot product. The docments carry the shapes: `[d]`, `[K, d]`, `[K]`.

```bash
sed -n '146,166p' src/babykev/model.py
```

**What is trained.** The language model, Qwen2.5-0.5B, is frozen: 494,032,768 parameters that never change. Two things train: the LoRA adapter of rank 16, 8,798,208 parameters, and the pointer head, 459,264. That is 503,290,240 in all, 9,257,472 of them trainable, which the smoke prints as `503M parameters, 9.3M of them trainable`. The four counts were measured on step 05's code with the real model from the cache.

**D. Fixtures.** A test needs things to work on before it can check anything: a sample request, a tokenizer, a model. Not the real ones, but small stand-ins made up for the tests: data such as one request with three questions, and objects such as a tokenizer with one token per character. A fixture makes one of them, in one place, for every test that asks. It is a function marked `@pytest.fixture`. A test names it as one of its arguments; pytest finds the fixture of that name, calls it, and passes in what it returns. The `sed` line prints all three of ours, the whole of `tests/conftest.py` below its imports, lines 16 to 40. `tok` is built once for the whole run, because of `scope="session"`. `record` and `model` have the default scope, one per test, so they are built fresh for every test that asks, and no test can spoil them for the next. `model` itself asks for `tok`: a fixture can use another fixture. `capsys` and `monkeypatch` at step 01 were pytest's own fixtures; these are ours.

```bash
sed -n '16,40p' tests/conftest.py
```

**Writing a fixture.** At step 01 the tests built a request with a helper, `cheese_request`, lines 32 to 43 of `test_api.py`, and six tests call it by hand, as on line 81. The `record` fixture, lines 30 to 40 of `conftest.py`, does the same job the other way round: it is marked `@pytest.fixture`, and a test asks for it by name. To write one: a function that returns what the test needs, marked `@pytest.fixture`, in `conftest.py` if more than one file needs it. If the test leaves something to clean up, the fixture uses `yield` instead of `return`, and the code after `yield` runs when the test is done; `tmp_path`, which the documentation tests used at step 04, is pytest's own fixture of that kind.

```bash
sed -n '32,43p' tests/unit/test_api.py
sed -n '81p' tests/unit/test_api.py
sed -n '30,40p' tests/conftest.py
```

**`conftest.py`.** pytest reads `tests/conftest.py` before it runs any test, and every test file under `tests/` can use its fixtures without importing anything. Ours contains three fixtures: `tok`, the tiny tokenizer; `model`, a tiny model; `record`, one request with a state and three questions. Eight test functions ask for them: all eight for `tok`, four for `record`, two for `model`. pytest runs them as 12 tests, because one of the eight, the forgery test, runs once for each of the five delimiters. `just test --fixtures` lists every fixture pytest can see, 125 lines on the terminal with just's echo of the command: pytest's own and its plugins' first, then, at the end, under `fixtures defined from conftest`, ours, each with the line of its `def` in `conftest.py` (17, 23 and 31) and its docstring.

```bash
just test --fixtures
```

**Fixtures in use.** Eight test functions ask for the fixtures, and each asks for its own mix. `tok`: all eight. `record`: `test_positions_restart_after_the_state`, `test_a_question_that_does_not_fit_is_refused`, `test_probabilities_sum_to_one_for_every_question`, `test_with_an_adapter_only_the_adapter_and_the_head_train`. `model`: `test_probabilities_sum_to_one_for_every_question` and `test_smoke_reports_on_every_question_of_the_sample`. The other three that ask only for `tok` are `test_packing_marks_every_part_with_its_delimiter` and the two forgery tests. The `sed` lines print three of them. `test_positions_restart_after_the_state`, lines 60 to 69 of `test_model.py`, kind: unit, takes `tok` and `record`. `test_probabilities_sum_to_one_for_every_question`, lines 137 to 146, kind: integration, takes all three, and expects `[2, 3, 3]` because the `record` fixture's three questions have 2, 3 and 3 options: a fixture's data is known in advance, so a test can expect exact numbers. `test_smoke_reports_on_every_question_of_the_sample`, lines 9 to 21 of `test_smoke.py`, kind: integration, takes `model` and `tok`. Each test gets its own fresh `model` and `record`; all share one `tok`. `just test --fixtures-per-test` names the fixtures a test uses and where each is defined: for `-k "probabilities_sum or positions_restart"`, the two tests, `record` and `tok` for the first, `model`, `record` and `tok` for the second, each with its line in `conftest.py` and its docstring; for `test_smoke.py`, `model` and `tok`.

```bash
sed -n '60,69p' tests/unit/test_model.py
sed -n '137,146p' tests/unit/test_model.py
sed -n '9,21p' tests/unit/test_smoke.py
just test --fixtures-per-test -k "probabilities_sum or positions_restart"
just test --fixtures-per-test tests/unit/test_smoke.py
```

**E. The tiny model: a test that uses it.** `test_probabilities_sum_to_one_for_every_question`, lines 137 to 146 of `test_model.py`, kind: integration: packing, the model and the head together. The test never says "tiny". It names `model` and `tok` as arguments, and pytest passes it the tiny model and the tiny tokenizer. `encode(tok, record)` turns the record into tokens with the tiny tokenizer, and `model.probs(...)` runs them through the tiny model and the pointer head. The code that runs is our real `DecisionModel`, from `model.py`; only the backbone and the tokenizer under it are small. Nothing is trained, so the probabilities mean nothing. The test checks what is true of any probabilities: one per option, `[2, 3, 3]`, and they add up to 1. `just test -k probabilities_sum`: 1 passed.

```bash
sed -n '137,146p' tests/unit/test_model.py
just test -k probabilities_sum
```

**The tiny model: where `model` and `tok` come from.** `tests/conftest.py`, lines 16 to 27, contains two fixtures. `tok`, lines 16 to 19, returns `tiny_tokenizer()`; it is built once for the whole run (`scope="session"`). `model`, lines 22 to 27, returns `DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()`, a decision model on the tiny backbone, without an adapter; it is built again for each test, the default scope. pytest calls the two fixtures and passes what they return to every test that names them. `tests/tiny.py` contains two ordinary functions, `tiny_tokenizer` on line 16 and `tiny_backbone` from line 31. Nothing marks them `@pytest.fixture`: they build the two small parts, and any code can call them, as the two fixtures do. Why the builders are not fixtures: our `model` fixture takes no arguments and always returns one model, without an adapter. The adapter test needs a tiny model with an adapter, so it calls the function itself, at line 163 of `test_model.py`: `DecisionModel("tiny", "cpu", lora=4, backbone=tiny_backbone(len(tok)))`. `test_model.py` also calls `tiny_tokenizer()` at line 14, `TOK = tiny_tokenizer()`, for two tests further down, at lines 82 and 115. Those two are fed by hypothesis, which runs a test many times; hypothesis refuses a test that takes a function-scoped fixture such as `model` (step 05a tries it), so a test that hypothesis feeds builds what it needs itself. The `grep` line finds every call.

```bash
sed -n '16p;31,34p' tests/tiny.py
sed -n '16,27p' tests/conftest.py
grep -n "tiny_backbone\|tiny_tokenizer" tests/unit/test_model.py tests/conftest.py
```

**The tiny model: what the two functions build.** Both halves are built in memory, with no download. The tokenizer has one token for each of the 100 printable characters, one for each of the five delimiters, and `[UNK]`, the token for any other character: 106 tokens in all; the `python` line asks it to split "Roquefort" and gets nine tokens, one per letter. The backbone is Qwen's own code, `Qwen2Model`, built smaller: 2 layers of 32 numbers, where the real model has 24 layers of 896. Its weights are random, from a fixed seed, so they are the same every run. The second `python` line counts them: 24,224 parameters, against the real backbone's 494,032,768.

```bash
sed -n '22,27p' tests/tiny.py
sed -n '37,46p' tests/tiny.py
uv run python -c "from tests.tiny import tiny_tokenizer; t = tiny_tokenizer(); print(len(t), t.tokenize('Roquefort'))"
uv run python -c "from tests.tiny import tiny_backbone; print(sum(p.numel() for p in tiny_backbone(106).parameters()))"
```

**F. The tiny model, why it is enough.** What the tests check is exact: which token may see which, where the positions start, which parameters get a gradient. That is true for any weights, trained or random. What the tiny model cannot tell: whether the answers are any good, how the real tokenizer splits words, how fast it runs on a GPU. What it buys: no download, no GPU, a few seconds. It is a working, simplified stand-in for the real model; testers call such a stand-in a fake. Only our code can make these tests fail: no network, no download, and they run on the CPU, which every machine has. They are hermetic, so they run on every commit.

**G. Kinds of tests.** Five names, by how much of the program a test runs. A unit test runs one function alone: `test_score_confidence_is_zero_for_a_guess` gives `score_confidence` three numbers. An integration test runs several of our parts together, with stand-ins for what comes from outside: `test_probabilities_sum_to_one_for_every_question` packs a request and runs the model and the head, and `test_smoke_reports_on_every_question_of_the_sample` takes each request of the sample file through the contract, the packing, the model and the answers, both on the tiny model. An end-to-end, or system, test runs the whole program with its real parts, the way a user does: `just smoke local`, on the real model. A smoke test is a quick end-to-end run, to see whether the program starts and answers at all; our end-to-end run is a smoke. An acceptance test asks whether a promise to the users is kept, such as an answer within 50 ms; we have none. An end-to-end test uses the real parts, so something outside our code can make it fail: it is never hermetic, and our smoke needs the download and a device. An integration test is hermetic only when what comes from outside is replaced: ours are, because the tiny model replaces the real one; one that talks to a real database is not. The tiny model is not a kind of test: it is the stand-in for the real model, and the `model` fixture returns it to the tests that name it. A test's name says what it calls, not what kind of test it is: `test_smoke_reports_on_every_question_of_the_sample` calls our function `smoke`, but it is an integration test, not a smoke test. Teams draw the lines between these names differently, so when you call a test an integration test, say what runs in it.

**H. The tests.** `just test`: 92 passed, 23 of them new. The coverage table has two new rows: `model.py` 96% (the CUDA branch and the real-model loading path are not reached by a tiny model), `smoke.py` 71% (its `main` loads the real model). Total 94%, over the floor. The first run after a move takes about 30 seconds while Python compiles torch's modules; after that, about 7.

```bash
just test
```

`just test -k forge` runs the forgery tests alone: 6 passed. Kind: unit, `user_tokens` and a tokenizer. The `sed` line prints two of them: the first proves the danger is real (the text of a delimiter, tokenized plainly, becomes that delimiter), the second that `user_tokens` closes the door, for each of the five.

```bash
just test -k forge
sed -n '96,112p' tests/unit/test_model.py
```

Two more to read. `test_smoke.py`, lines 9 to 21, kind: integration. It calls our function `smoke` with the tiny model, and the report must have a line for each of the fifteen questions of the sample, and a closing count. `just test -k smoke_reports`: 1 passed, and no model was downloaded for it.

```bash
sed -n '9,21p' tests/unit/test_smoke.py
just test -k smoke_reports
```

And the weighty one, `test_model.py` lines 158 to 178, kind: integration, what trains: one backward pass on the tiny model with an adapter, then every parameter that received a gradient is named, and all of them are the adapter's or the head's, and `trainable_parameters` lists exactly those. `just test -k only_the_adapter`: 1 passed. This test says what fine-tuning means here: the backbone never moves; nine million parameters do.

```bash
sed -n '158,178p' tests/unit/test_model.py
just test -k only_the_adapter
```

**I. Documented, and checked.** `just docs check`: 139 of 139, every function, method and class in the package, the tests and `docs/apidocs.py`. `just check`: green, 15 seconds now that the model tests are in it.

```bash
just docs check
just check
```

**What a smoke test is.** The name comes from electronics: switch a new circuit on, and see whether it smokes. A smoke test asks whether the whole thing starts and gives an answer at all, not whether the answer is right. It is fast and shallow, and runs first, before the slow and deep tests. Ours loads the real model, asks the 15 sample questions, and prints each answer beside its label. Kind: smoke, which is end-to-end; run by hand, not part of `just test`.

**J. The smoke, as a command.** `uv run babykev smoke` is the program's new word. It loads the base model, Qwen2.5-0.5B, with a fresh adapter and an untrained pointer head, on the best device this machine has (`mps` here, Apple's GPU), and asks it the five sample requests. It prints the device, the load time (4 s), the parameter counts (503M, 9.3M of them trainable: the adapter and the head), then each answer beside its label, and the count: 6 of 15 right, about 200 ms a request on this Mac (198 ms at one run, 212 at another). 10 seconds in all. The first time on a machine, the download of the base model, about 1 GB. Nothing is trained, so these are guesses. What the run proves is that the pieces fit: the contract, the packing, the model, the answers.

```bash
uv run babykev smoke
```

`just --show smoke` prints the recipe: a script with three branches, `help`, `local` (the command above), and anything else refused with a message, because no other platform exists yet. `just smoke local` runs it: the same report, 6 of 15 right. From now on, `just smoke local`.

```bash
just --show smoke
just smoke local
```

**K. The type checker.** A type says what kind of value something is: a whole number, a list of numbers, a tokenizer. Since step 03, every function of ours says the types it takes and the type it returns, and we use this in docments. `uv run ty check` is ty: it compares every call and every `return` with what the function says, by reading the code, without running it. It prints 6 diagnostics, in 3 seconds. The code runs, and every test passes; ty finds the places where a caller trusts more than the called function promises.

```bash
uv run ty check
```

`just --show types` prints the recipe: its comment, two attributes, its name, and a body of one line, `uv run ty check "$@"`, inside an `if` that answers `help`. The words after `just types` go to ty. From now on, `just types`.

```bash
just --show types
just types
```

`just --show check` shows what is not there: no `types` line. Here we run ty by hand and read what it finds. `just check` does not include it yet, so a commit with negative ty findings still goes through, and the hook let this commit in with its six findings. At the next step, 05a, `just check` runs ty too. From then on, a commit with a negative ty finding is refused.

```bash
just --show check
```

**Currently we get six findings.** Each is printed with a file, a line and a code. `model.py:68`, `invalid-return-type`: `load_tokenizer` says it returns a `PreTrainedTokenizerBase`, and returns what `AutoTokenizer.from_pretrained` gives, which the library says may be one of two backends or `None`. `model.py:97`, `not-iterable`: the result of `convert_tokens_to_ids` may be a single number, which cannot be split into five names. `test_model.py:49` and `:120`, `not-iterable`: the same. `test_model.py:100`, `not-subscriptable`: the same result, followed by `[4]`; a single number has no item 4. `test_model.py:111`, `invalid-argument-type`: the same result, given to `set(...)`, which needs something it can go through item by item. The first comes from one call; the other five from one other call, `convert_tokens_to_ids`. The `sed` line prints the first.

```bash
sed -n '65,68p' src/babykev/model.py
```

**The five findings from one call.** `model.py` line 97 splits the result of `tok.convert_tokens_to_ids(SPECIAL)` into five names. `SPECIAL` is the list of the five delimiters, and `convert_tokens_to_ids` turns tokens into their numbers. The library says it returns `int | list[int]`: one number when given one token, a list when given a list. We give it a list of five, so it returns a list of five, and the line de-structures them into five names. The code runs, and the tests pass. ty reads only what the library says, not what happens at run time, and "it may be one number" is enough: one number cannot be split into five names. The `grep` line finds the call in `model.py` and the tests: line 52 of `test_model.py` passes one character at a time and uses each result as one number, so ty has nothing to say about it. In the next step, 05a, we call this once, in a new function `delimiter_ids`, which always returns a list. It also makes `load_tokenizer` stop with an error when it gets no tokenizer. Then ty finds nothing, and `just types` joins `just check`.

```bash
sed -n '97p' src/babykev/model.py
grep -n "convert_tokens_to_ids" src/babykev/model.py tests/unit/test_model.py
```

**L. The problem with the mask as written.** This is what the mask should be, token by token: say we have a small request of six tokens, numbered 1 to 6 in the order they are packed: two for the state, two for question 1, two for question 2. The mask says, for each token, which tokens it may look at. The slide draws it as a grid, one row per token, `#` for "may look at this token" and `.` for "may not". No token may look at a token after it, so everything right of the diagonal is `.`. The tokens of question 2, rows 5 and 6, may not look at question 1, tokens 3 and 4: rows 5 and 6 read `##..#.` and `##..##`. This is the red cell of the earlier picture, token by token, and it is the rule of `branch_mask`'s docstring, lines 131 to 135.

**All green, and the mask is wrong.** Here there is no test that checks the mask. Every check in `just check` passes: 92 tests, 94% coverage, 139 of 139 documented, a smoke that answers every question. Coverage counts `branch_mask` as tested, because its lines ran; no test looks at the mask the code here builds. The `python` line asks `branch_mask` for the mask of the six tokens of the last slide, parts `[0, 0, 1, 1, 2, 2]`, and prints it as rows of `#` and `.`. Rows 1 to 4 are as they should be. Rows 5 and 6 are `#####.` and `######`: question 2 may look at question 1. The `sed` line prints the cause, line 140. `same` should be yes only when two tokens are in the same question, or the other one is in the state; `torch.ones_like(causal)` makes it yes for every pair, so every token may look at every token before it.

```bash
uv run python -c "from babykev.model import branch_mask; m = branch_mask([0, 0, 1, 1, 2, 2], 'cpu')[0, 0] == 0; print('\n'.join(''.join('#' if x else '.' for x in r) for r in m))"
sed -n '140p' src/babykev/model.py
```

**A check that sees it.** At step 05 there is no test of the mask, and we bring none forward: a few lines of plain Python do the job. The slide shows them as a function; the shell runs the same comparison as a here document, where `python -` reads the lines up to `EOF`. The lines import `branch_mask`, hold the right mask for six tokens, two of the state and two each of two questions, as six lines of `#` and `.`, build the mask with `branch_mask` for the parts `[0, 0, 1, 1, 2, 2]`, and print each pair of rows, the right one and the built one, with `ok` or `WRONG`. Rows 1 to 4 print `ok`. Row 5 prints `##..#. #####. WRONG`: the state and itself are right, and the built mask also takes question 1's two tokens. Row 6 prints `##..## ###### WRONG`. The same two rows as the grids of the last slide. Nothing to clean up: nothing was written to a file.

```bash
uv run python - <<'EOF'
from babykev.model import branch_mask
picture = ["#.....", "##....", "###...", "####..", "##..#.", "##..##"]
mask = branch_mask([0, 0, 1, 1, 2, 2], "cpu")[0, 0] == 0
rows = ["".join("#" if ok else "." for ok in row) for row in mask]
for want, got in zip(picture, rows, strict=True): print(want, got, "ok" if want == got else "WRONG")
EOF
```

**The commit anyway.** The last slide, with Pavlos. Normally we would fix before we commit. This commit went in with the mask wrong, and with six ty findings, on purpose: nothing in `just check` can see either, so the hook let it through. Pavlos distracted us, so we committed and went to his class. The next step is what we do when we come back.

**What the next step does.** Step 05a brings the seven tests that see the mask, the one-line fix, the two guards ty asked for, `just types` into `check`, and two pages on the model.

### What changed

- <a id="step-05-README.md-8ec9a0"></a>`README.md`: 19 lines added, 3 removed. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/README.md).
- <a id="step-05-justfile-424f0b"></a>`justfile`: adds `recipe smoke`, `recipe types`. 17 lines added. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/justfile).
- <a id="step-05-pyproject.toml-5d07e7"></a>`pyproject.toml`: 20 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/pyproject.toml).
- <a id="step-05-src-babykev-cli.py-a9e184"></a>`src/babykev/cli.py`: changes `main`. 5 lines added. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/src/babykev/cli.py).
- <a id="step-05-src-babykev-docs.py-267fa4"></a>`src/babykev/docs.py`: adds `key_comments`, `keys_table`, `python_files`, `unwrapped`; changes `check`, `entry`, `file_modules`, `gaps_of`, `main`, `methods`, `own`. 56 lines added, 12 removed. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/src/babykev/docs.py).
- <a id="step-05-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: adds `__init__`, `branch_mask`, `class DecisionModel`, `class Encoded`, `class PointerHead`, `encode`, `forward`, `hidden`, `load_tokenizer`, `pick_device`, `probs`, `trainable_parameters`, `user_tokens`. New, 232 lines. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/src/babykev/model.py).
- <a id="step-05-src-babykev-smoke.py-76d2ec"></a>`src/babykev/smoke.py`: adds `answer`, `main`, `read_lines`, `smoke`, `verdict`. New, 122 lines. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/src/babykev/smoke.py).
- <a id="step-05-tests-conftest.py-626af3"></a>`tests/conftest.py`: adds `model`, `record`, `tok`. New, 40 lines. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/tests/conftest.py).
- <a id="step-05-tests-tiny.py-70c1c9"></a>`tests/tiny.py`: adds `tiny_backbone`, `tiny_tokenizer`. New, 46 lines. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/tests/tiny.py).
- <a id="step-05-tests-unit-test_cli.py-44d4a0"></a>`tests/unit/test_cli.py`: adds `test_smoke_runs_the_smoke`. 12 lines added. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/tests/unit/test_cli.py).
- <a id="step-05-tests-unit-test_docs.py-31dd08"></a>`tests/unit/test_docs.py`: adds `class Point`, `grow`, `inner`, `logged`, `test_a_decorated_method_is_seen_through_its_decorator`, `test_check_holds_the_tests_and_the_root_and_docs_files_too`, `test_markdown_shows_a_typeddict_as_a_table_of_keys`; changes `test_check_prints_a_count_per_module_then_every_gap_and_fails`, `test_gaps_names_what_each_symbol_is_missing`, `test_inventory_lists_the_public_symbols_in_source_order`, `test_list_prints_one_line_per_symbol`; removes `test_check_holds_the_tests_to_the_convention_too`. 69 lines added, 12 removed. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/tests/unit/test_docs.py).
- <a id="step-05-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: adds `logits_of`, `test_a_packed_record_has_exactly_the_delimiters_its_shape_needs`, `test_a_question_that_does_not_fit_is_refused`, `test_a_tokenizer_alone_would_let_text_forge_a_delimiter`, `test_packed_lists_always_line_up`, `test_packing_marks_every_part_with_its_delimiter`, `test_pick_device_finds_something_to_run_on`, `test_pick_device_takes_an_override`, `test_pointer_head_gives_one_logit_per_option`, `test_positions_restart_after_the_state`, `test_probabilities_sum_to_one_for_every_question`, `test_user_text_cannot_forge_a_delimiter`, `test_with_an_adapter_only_the_adapter_and_the_head_train`. New, 190 lines. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/tests/unit/test_model.py).
- <a id="step-05-tests-unit-test_smoke.py-89db04"></a>`tests/unit/test_smoke.py`: adds `test_smoke_reports_on_every_question_of_the_sample`, `test_verdict_agrees_when_the_answer_is_the_label`, `test_verdict_reads_a_noul_answer_as_yes_from_one_half`, `test_verdict_reads_a_score_answer_as_its_most_likely_level`. New, 44 lines. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/tests/unit/test_smoke.py).
- <a id="step-05-uv.lock-8356d8"></a>`uv.lock`: 766 lines added, 13 removed. [The file](https://github.com/rahuldave/babykev/blob/46cf8625a031e10049355df4c37abcb7af58d847/uv.lock).

<a id="step-05-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -50,7 +50,8 @@ Three tools on the machine. This project installs everything else itself.
 | [just](https://just.systems/) | The project's tasks. `just` lists them |
 | [Quarto](https://quarto.org/) | The docs site: `just docs`. `just setup` says if it is missing |
 
-Then `just setup`, and `just test`. `just fmt` formats the code and `just lint` checks it against the
+Then `just setup`, and `just test`. `just setup` installs torch's CPU build from PyTorch's own index,
+which is enough for the tests and for running the model on a laptop. `just fmt` formats the code and `just lint` checks it against the
 rules in `pyproject.toml`. `just check` runs everything a commit must pass, and `just setup` installs it
 as a git hook, so a commit that fails a check is refused. `just` lists the tasks, `just help VERB` explains one, and `uv run
 babykev help` is the program's own help. Extra arguments go to the tool behind a recipe: `just test -k
@@ -65,17 +66,32 @@ parameter and the return, which the formatter and the linter leave alone as long
 characters. `src/babykev/docs.py` is the example to read. `just docs check` is part of `just check`, so a
 commit that leaves a gap is refused by the hook.
 
+## Running it
+
+`just smoke local` runs everything that exists so far, end to end, on this machine: it loads the base
+model, Qwen2.5-0.5B, with a fresh adapter and an untrained pointer head, asks it the questions in the
+sample data, and prints each answer beside its label. Nothing is trained yet, so the answers are guesses;
+what the run shows is that the pieces fit. The first run downloads the base model from the Hugging Face
+Hub, about 1 GB, into its cache; later runs read it from there. The platform is a word of the recipe, and
+only `local` exists so far.
+
+`just types` is ty, the type checker: it reads every call against what the called function declares.
+It is not part of `just check` yet.
+
 ## What is here
 
 | Path | What it is |
 |---|---|
 | `pyproject.toml`, `uv.lock` | The project: its name, its Python, its dependencies, the settings of its tools (the formatter's, and every lint rule with its reason), and the exact versions installed |
 | `src/babykev/api.py` | The contract: the request and its three question types as Pydantic models, how they become the text and options the model sees, and how probabilities become answers |
-| `src/babykev/cli.py` | The `babykev` command |
+| `src/babykev/cli.py` | The `babykev` command: `docs` and `smoke` |
+| `src/babykev/model.py` | The model: packing a context and its questions into one sequence, the mask that keeps questions apart, the pointer head that scores options, and the class that puts them on a language model |
+| `src/babykev/smoke.py` | The smoke run behind `just smoke` |
 | `src/babykev/docs.py` | What the code says about itself, as plain Markdown: `babykev docs list`, `docs module NAME`, `docs check` |
 | `docs/` | The docs site: `_quarto.yml`, the front page `index.qmd`, `apidocs.py` (writes the reference pages from `babykev docs` before every render) and `linkify.lua` (a name in backticks becomes a link). The built site in `_site/` is not committed |
 | `data/cheese/sample.jsonl` | Five lines of data. Each is a request about a cheese with a `label` on every question: the right answer |
-| `tests/unit/` | Unit tests of the contract, of the command and of the documentation. One test checks every line of the sample data against the contract |
+| `tests/unit/` | Unit tests of the contract, of the command, of the documentation, of the model and of the smoke. One test checks every line of the sample data against the contract |
+| `tests/tiny.py`, `tests/conftest.py` | A tokenizer with one token per character and a two-layer backbone with random weights, built in memory: the model's tests need no download and no GPU |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
 | `LICENSE`, `NOTICE` | The licence, and the credit to kev |
 | `.python-version` | The Python version the project uses |
```

</details>

<a id="step-05-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

```diff
@@ -57,6 +57,12 @@ lint-config *args:
     uv lock --check
     just --fmt --check --unstable
 
+# Check the types: what a caller passes against what a function declares. Extra arguments go to ty
+[group('quality')]
+[no-exit-message]
+types *args:
+    {{ if args == "help" { "just help types" } else { 'uv run ty check "$@"' } }}
+
 # Run the tests, with coverage of src/babykev. Extra arguments go to pytest: just test -k render
 [group('quality')]
 [no-exit-message]
@@ -84,3 +90,14 @@ docs *args:
     if [ "$*" = help ]; then just help docs; exit 0; fi
     if [ "$#" -eq 0 ]; then exec uv run quarto render docs; fi
     exec uv run {{ program }} docs "$@"
+
+# Run everything that exists so far on the real model: just smoke local. Other platforms arrive later
+[group('model')]
+[no-exit-message]
+smoke *args:
+    #!/usr/bin/env sh
+    case "$*" in
+        help) just help smoke ;;
+        local) exec uv run {{ program }} smoke ;;
+        *) echo "smoke: the platform is local; $* is not here yet" >&2; exit 2 ;;
+    esac
```

</details>

<a id="step-05-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -9,7 +9,11 @@ authors = [{ name = "Rahul Dave" }]
 requires-python = ">=3.13"
 dependencies = [
     "fastcore>=2.2.32",
+    "peft>=0.21",
     "pydantic>=2.11",
+    "safetensors>=0.5",
+    "torch>=2.14,<2.15",
+    "transformers>=5.17,<6",
 ]
 
 [project.scripts]
@@ -21,6 +25,7 @@ build-backend = "uv_build"
 
 [dependency-groups]
 test = [
+    "hypothesis>=6.168",
     "pytest>=9.1",
     "pytest-cov>=7.1.0",
 ]
@@ -28,12 +33,22 @@ dev = [{ include-group = "test" }, { include-group = "lint" }]
 lint = [
     "pre-commit>=4.6",
     "ruff>=0.16",
+    "ty>=0.0.84",
     "validate-pyproject>=0.26",
     "yamllint>=1.38",
 ]
 
+# torch comes in several builds. This project installs the CPU build everywhere, from PyTorch's own
+# index: small, and enough for the tests and for inference on a laptop. `explicit` keeps every other
+# package on PyPI. A GPU build arrives with the first platform that has a GPU.
+[[tool.uv.index]]
+name = "pytorch-cpu"
+url = "https://download.pytorch.org/whl/cpu"
+explicit = true
+
 [tool.pytest.ini_options]
 testpaths = ["tests"]
+pythonpath = ["."] # so that a test can import its helpers as tests.tiny
 # Every run measures how much of src/babykev the tests touch and lists the lines they do not
 addopts = "--cov=babykev --cov-report=term-missing"
 
@@ -72,5 +87,8 @@ select = [
 ignore = ["S311"]
 
 [tool.ruff.lint.per-file-ignores]
-# A test is written with assert
-"tests/**" = ["S101"]
+# A test is written with assert. S106 mistakes the tokenizer argument `unk_token` for a password
+"tests/**" = ["S101", "S106"]
+
+[tool.uv.sources]
+torch = { index = "pytorch-cpu" } # the CPU build, from the index above
```

</details>

<a id="step-05-src-babykev-cli.py-a9e184-diff"></a>

<details><summary>The diff of <code>src/babykev/cli.py</code></summary>

```diff
@@ -12,6 +12,7 @@ usage: babykev COMMAND [FLAGS]
 
 commands:
   docs    what the code says about itself, as Markdown: docs list, docs module NAME, docs check
+  smoke   load the base model on this machine and answer the five sample requests, untrained
 """
 
 
@@ -23,5 +24,9 @@ def main() -> None:
         return
     if words[0] == "docs":
         raise SystemExit(docs.main(words[1:]))
+    if words[0] == "smoke":
+        from babykev import smoke  # imports torch, so only when asked for
+
+        raise SystemExit(smoke.main(words[1:]))
     print(f"babykev: no command named {words[0]!r}. Run `babykev help`.", file=sys.stderr)
     raise SystemExit(2)
```

</details>

<a id="step-05-src-babykev-docs.py-267fa4-diff"></a>

<details><summary>The diff of <code>src/babykev/docs.py</code></summary>

```diff
@@ -7,7 +7,8 @@
 Types come from the annotations, the description of a parameter from its docment (the comment beside
 it, read by fastcore) and the summary from the docstring. Nothing is written twice. The output is
 plain Markdown with no links, ids or URLs, so that a person, an agent or the docs site can read it.
-`list` and `module` show the package; `check` holds the package and the tests to the convention.
+`list` and `module` show the package; `check` holds the package, the tests, and the Python files at
+the root and under `docs/` to the convention.
 
 How to write a docment, so that the formatter and the linter leave it alone: one parameter per
 line, a trailing comma after the last, the comment two spaces after the code; the return's comment
@@ -20,6 +21,7 @@ lint rule looks inside one.
 import importlib
 import importlib.util
 import inspect
+import re
 import sys
 import types
 import typing
@@ -32,8 +34,9 @@ from fastcore.docments import docments
 from pydantic import BaseModel
 
 PACKAGE = "babykev"
-TESTS = Path("tests")
+ROOT = Path()
 EMPTY = inspect.Parameter.empty
+KEY_COMMENT = re.compile(r"^\s+(\w+)\s*:[^#\n]+#\s*(.+)$", re.MULTILINE)
 USAGE = """\
 usage: babykev docs list            every module, class, method and function, one line each
        babykev docs module NAME     one module as Markdown: api, cli or docs
@@ -63,12 +66,20 @@ def package_modules(
     return [importlib.import_module(f"{package}.{n}") for n in names]
 
 
+def python_files(
+    root: Path,  # The repository's root
+) -> list[Path]:  # Every `.py` file at the root, under `docs/` and under `tests/`, in that order
+    """Find the Python files that are not the package and are held to the convention too."""
+    found = sorted(root.glob("*.py")) + sorted((root / "docs").glob("*.py"))
+    return found + sorted((root / "tests").rglob("*.py"))
+
+
 def file_modules(
-    folder: Path,  # A folder of Python files, such as `tests/`
-) -> list[ModuleType]:  # One module per file found, named by its path, in path order
-    """Import every Python file under a folder as a module of its own, named by its path."""
+    files: list[Path],  # Python files that are not part of a package
+) -> list[ModuleType]:  # One module per file, named by its path, in the order given
+    """Import Python files as modules of their own, named by their paths."""
     mods = []
-    for file in sorted(folder.rglob("*.py")):
+    for file in files:
         name = file.as_posix()
         spec = importlib.util.spec_from_file_location(name, file)
         if spec is None or spec.loader is None:
@@ -112,6 +123,14 @@ def line_of(
     return inspect.getsourcelines(sym)[1]
 
 
+def unwrapped(
+    obj: object,  # Anything a module or a class holds under a name
+) -> object:  # The function inside it when it is a decorator's wrapper; otherwise the object itself
+    """See through a decorator that kept the function, as `functools.wraps` and a fixture do."""
+    inner = getattr(obj, "__func__", obj)
+    return inspect.unwrap(inner) if callable(inner) and hasattr(inner, "__wrapped__") else inner
+
+
 def own(
     mod: ModuleType,  # An imported module
     private: bool = False,  # Include names that start with an underscore
@@ -119,7 +138,7 @@ def own(
     """List the functions and classes a module defines itself, in source order; not its imports."""
     found = [
         o
-        for n, o in vars(mod).items()
+        for n, o in ((n, unwrapped(o)) for n, o in vars(mod).items())
         if (private or not n.startswith("_"))
         and (inspect.isfunction(o) or inspect.isclass(o))
         and o.__module__ == mod.__name__
@@ -139,7 +158,7 @@ def methods(
     private: bool = False,  # Include names that start with one underscore
 ) -> list[FunctionType]:  # The methods the class defines, in source order
     """List the methods a class defines itself, in source order, not what it inherits."""
-    found = [(n, getattr(o, "__func__", o)) for n, o in vars(klass).items() if not is_dunder(n)]
+    found = [(n, unwrapped(o)) for n, o in vars(klass).items() if not is_dunder(n)]
     own_ = [o for n, o in found if (private or not n.startswith("_")) and inspect.isfunction(o)]
     return sorted(own_, key=line_of)
 
@@ -281,6 +300,24 @@ def fields_table(
     return table(rows, ["Field", "Type", "Default", "Description"])
 
 
+def key_comments(
+    klass: type,  # A TypedDict class
+) -> dict[str, str]:  # For each key that has one, the comment beside it
+    """Read the docments of a TypedDict: the comment beside each key in the class body."""
+    return dict(KEY_COMMENT.findall(inspect.getsource(klass)))
+
+
+def keys_table(
+    klass: type,  # A TypedDict class
+    mod: ModuleType,  # The module it was written in
+) -> str:  # A Markdown table of its keys: type, description
+    """Describe a TypedDict by its keys, because calling it says nothing."""
+    said = key_comments(klass)
+    keys = klass.__annotations__.items()
+    rows = [[f"`{n}`", type_text(a, mod), said.get(n, "")] for n, a in keys]
+    return table(rows, ["Key", "Type", "Description"])
+
+
 def has_init(
     klass: type,  # A class
 ) -> bool:  # Whether it has a constructor of its own, written by hand or by `dataclass`
@@ -298,6 +335,8 @@ def entry(
     head = f"{'#' * level} {'class ' if is_class else ''}{sym.__qualname__}"
     if is_class and issubclass(sym, BaseModel):
         parts = [head, doc(sym), fields_table(sym, mod)]
+    elif is_class and typing.is_typeddict(sym):
+        parts = [head, doc(sym), keys_table(sym, mod)]
     elif is_class and not has_init(sym):
         parts = [head, doc(sym)]
     else:
@@ -331,6 +370,9 @@ def gaps_of(
     if is_class and issubclass(sym, BaseModel):
         fields = sym.model_fields.items()
         return out + [f"{name}.{n}: no description" for n, f in fields if not f.description]
+    if is_class and typing.is_typeddict(sym):
+        said = key_comments(sym)
+        return out + [f"{name}.{n}: no docment" for n in sym.__annotations__ if n not in said]
     if is_class and not has_init(sym):
         return out
     for pname, d in docments(sym, full=True).items():
@@ -361,11 +403,13 @@ def gaps(
 
 def check(
     package: str = PACKAGE,  # The package to hold to the convention
-    tests: Path | None = None,  # A folder of tests to hold to it too, or `None`
+    root: Path = ROOT,  # The repository's root, whose own Python files are held to it too
 ) -> int:  # The exit code: 0 when nothing is missing, 1 otherwise
     """Print how much of each module is typed and documented, then every gap, then the total."""
     found, done, total = [], 0, 0
-    for mod in package_modules(package) + (file_modules(tests) if tests else []):
+    if str(root.resolve()) not in sys.path:
+        sys.path.insert(0, str(root.resolve()))  # a test imports its helpers as tests.tiny
+    for mod in package_modules(package) + file_modules(python_files(root)):
         missing = gaps(mod)
         found += missing.pop(mod.__name__)
         complete = sum(not g for g in missing.values())
@@ -380,7 +424,7 @@ def check(
 def main(
     words: list[str],  # The words after `babykev docs`: `list`, `module NAME`, `check`, `help`
     package: str = PACKAGE,  # The package to document
-    tests: Path = TESTS,  # The folder of tests that `check` holds to the convention, if it exists
+    root: Path = ROOT,  # The repository's root, for the files `check` holds to the convention
 ) -> int:  # The exit code: 0, 1 when `check` finds a gap, 2 for words that are no command
     """Run one docs command and return its exit code."""
     if words in (["help"], ["--help"], ["-h"]):
@@ -402,6 +446,6 @@ def main(
             return 2
         return 0
     if words == ["check"]:
-        return check(package, tests if tests.is_dir() else None)
+        return check(package, root)
     print(USAGE, end="", file=sys.stderr)
     return 2
```

</details>

<a id="step-05-src-babykev-model.py-a86a0b-diff"></a>

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

```diff
@@ -0,0 +1,232 @@
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
+`DecisionModel` puts them together around a backbone, with a LoRA adapter if asked for.
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
+) -> PreTrainedTokenizerBase:  # Its tokenizer
+    """Load the tokenizer that belongs to a base model."""
+    return AutoTokenizer.from_pretrained(name)
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
+    max_state: int = MAX_STATE,  # The longest state kept, in tokens
+    max_branch: int = MAX_BRANCH,  # The longest state and question together, in tokens
+) -> Encoded:  # The packed record
+    """Pack a record into one sequence: the state, then one branch for each question.
+
+    The state is the state delimiter and its text. A branch is the question delimiter, the
+    instruction, each option between its two delimiters, and the decide delimiter. Raises
+    `ValueError` when a branch does not fit in `max_branch`.
+    """
+    s_id, q_id, o_id, c_id, d_id = tok.convert_tokens_to_ids(SPECIAL)
+    state = [s_id] + user_tokens(tok, rec["state"])[: max_state - 1]
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
+    ) -> None:
+        """Load or take the backbone, wrap it in an adapter if asked, and add the head."""
+        super().__init__()
+        if backbone is None:
+            # Only the transformer is kept. The vocabulary head is dropped: nothing is generated.
+            lm = AutoModelForCausalLM.from_pretrained(
+                name, dtype=torch.float32, attn_implementation="eager"
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
+        enc: Encoded,  # A packed record
+    ) -> torch.Tensor:  # The hidden state of every token, shape [n, d]
+        """Run the backbone over a packed record, with its restarted positions and its mask."""
+        ids = torch.tensor([enc["ids"]], device=self.device)
+        pos = torch.tensor([enc["pos"]], device=self.device)
+        mask = branch_mask(enc["seg"], self.device)
+        return self.lm(input_ids=ids, position_ids=pos, attention_mask=mask).last_hidden_state[0]
+
+    def forward(
+        self,
+        enc: Encoded,  # A packed record
+    ) -> list[torch.Tensor]:  # For each question, one logit per option
+        """Score every option of every question in one pass."""
+        h = self.hidden(enc)
+        return [
+            self.head(h[d], h[torch.tensor(oi, device=self.device)])
+            for d, oi in zip(enc["decide_idx"], enc["opt_idx"], strict=True)
+        ]
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

<a id="step-05-src-babykev-smoke.py-76d2ec-diff"></a>

<details><summary>The diff of <code>src/babykev/smoke.py</code></summary>

```diff
@@ -0,0 +1,122 @@
+"""A smoke run: everything that exists so far, end to end, on the real model.
+
+    babykev smoke
+
+It loads the base model with a fresh adapter and an untrained pointer head, asks it the questions
+in the sample data, and prints each answer beside its label. Nothing has been trained yet, so the
+answers are guesses. What the run shows is that the pieces fit: a line of data passes the contract,
+is packed into one sequence, goes through the model on whatever device there is, and comes back as
+answers.
+"""
+
+import json
+import sys
+import time
+from collections.abc import Iterator
+from pathlib import Path
+from typing import Any
+
+import torch
+from transformers import PreTrainedTokenizerBase
+
+from babykev.api import SystemOneRequest, to_answers, to_record
+from babykev.model import DecisionModel, encode, load_tokenizer, pick_device
+
+BASE = "Qwen/Qwen2.5-0.5B"
+LORA_RANK = 16
+SAMPLE = Path("data/cheese/sample.jsonl")
+USAGE = """\
+usage: babykev smoke    load the base model on this machine; answer the sample requests, untrained
+"""
+
+
+def read_lines(
+    path: Path = SAMPLE,  # A JSONL file of labelled requests
+) -> list[dict[str, Any]]:  # One labelled request per line of the file
+    """Read labelled requests from a JSONL file."""
+    with path.open(encoding="utf-8") as f:
+        return [json.loads(line) for line in f if line.strip()]
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
+        first = SystemOneRequest.model_validate(line)
+        state = to_record(first)[0]["state"].splitlines()[0]
+        yield f"\n{state[:70]}   [{tokens} tokens, {took * 1000:.0f} ms]"
+        for qid, question in line["questions"].items():
+            said, label, agree = verdict(question, answers[qid])
+            right, total = right + agree, total + 1
+            mark = "ok" if agree else "--"
+            yield f"  {mark}  {qid:12s} {question['type']:7s} says {said:28s} label: {label}"
+    typical = sorted(seconds)[len(seconds) // 2] * 1000
+    yield f"\n{right} of {total} right, {typical:.0f} ms a request."
+    yield "Nothing is trained yet: these are guesses."
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

<a id="step-05-tests-conftest.py-626af3-diff"></a>

<details><summary>The diff of <code>tests/conftest.py</code></summary>

```diff
@@ -0,0 +1,40 @@
+"""Shared fixtures: the tiny tokenizer, a tiny model and a record.
+
+The properties the tests check (the mask, the packing, the isolation of questions) are exact. They
+hold for any weights, so they need no trained model, no download and no GPU.
+"""
+
+from typing import Any
+
+import pytest
+from transformers import PreTrainedTokenizerFast
+
+from babykev.model import DecisionModel
+from tests.tiny import tiny_backbone, tiny_tokenizer
+
+
+@pytest.fixture(scope="session")
+def tok() -> PreTrainedTokenizerFast:  # The tiny tokenizer, built once for the whole test run
+    """Provide the tiny tokenizer."""
+    return tiny_tokenizer()
+
+
+@pytest.fixture
+def model(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+) -> DecisionModel:  # A decision model on the tiny backbone, with no adapter, ready to answer
+    """Provide a fresh tiny model for each test, on the CPU."""
+    return DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(tok))).eval()
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

<a id="step-05-tests-tiny.py-70c1c9-diff"></a>

<details><summary>The diff of <code>tests/tiny.py</code></summary>

```diff
@@ -0,0 +1,46 @@
+"""A tokenizer and a backbone small enough to build in memory, with random weights.
+
+The tokenizer has one token per character. The backbone has the base model's architecture, with
+two layers and 32 dimensions. Neither needs a download.
+"""
+
+import string
+
+import torch
+from tokenizers import Tokenizer, models, pre_tokenizers
+from transformers import PreTrainedTokenizerFast, Qwen2Config, Qwen2Model
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

<a id="step-05-tests-unit-test_cli.py-44d4a0-diff"></a>

<details><summary>The diff of <code>tests/unit/test_cli.py</code></summary>

```diff
@@ -47,3 +47,15 @@ def test_docs_is_passed_to_the_docs_command(
         run(monkeypatch, "docs", "list")
     assert exit_info.value.code == 0
     assert "babykev.api" in capsys.readouterr().out
+
+
+def test_smoke_runs_the_smoke(
+    monkeypatch: pytest.MonkeyPatch,  # Replaces `sys.argv` and the smoke itself for this test only
+) -> None:
+    """`babykev smoke` runs the smoke's `main` with the words after it; here a stand-in."""
+    ran = []
+    monkeypatch.setattr("babykev.smoke.main", lambda words: ran.append(words) or 0)
+    with pytest.raises(SystemExit) as exit_info:
+        run(monkeypatch, "smoke")
+    assert exit_info.value.code == 0
+    assert ran == [[]]
```

</details>

<a id="step-05-tests-unit-test_docs.py-31dd08-diff"></a>

<details><summary>The diff of <code>tests/unit/test_docs.py</code></summary>

````diff
@@ -11,13 +11,34 @@ from babykev import docs
 THING = '''
 """A thing, with one function that is documented and one that is not."""
 
-from typing import Literal
+import functools
+from collections.abc import Callable
+from typing import Literal, TypedDict
 
 from pydantic import BaseModel, Field
 
 Pair = tuple[int, int]
 
 
+def logged(
+    f: Callable,  # A function to wrap
+) -> Callable:  # The same function, wrapped
+    """Decorate a function, keeping it under `__wrapped__`."""
+
+    @functools.wraps(f)
+    def inner(*a, **k):
+        return f(*a, **k)
+
+    return inner
+
+
+class Point(TypedDict):
+    """A point, as a TypedDict: its keys are its signature."""
+
+    x: int  # Across
+    y: int
+
+
 def greet(
     name: str,  # Who to greet
     times: int = 1,  # How many times over
@@ -51,6 +72,14 @@ class Thing:
         """Measure the thing."""
         return 1
 
+    @logged
+    def grow(
+        self,
+        by: int,  # How much
+    ) -> int:  # The new size
+        """Grow the thing, through a decorator."""
+        return 1 + by
+
     def _hidden(self):
         return 0
 '''
@@ -82,12 +111,15 @@ def test_inventory_lists_the_public_symbols_in_source_order(
     found = [(s.kind, s.name, s.summary) for s in docs.inventory(pkg)]
     assert found == [
         ("module", "", "A thing, with one function that is documented and one that is not."),
+        ("function", "logged", "Decorate a function, keeping it under `__wrapped__`."),
+        ("class", "Point", "A point, as a TypedDict: its keys are its signature."),
         ("function", "greet", "Say hello."),
         ("function", "bare", ""),
         ("function", "span", "Print the pair."),
         ("class", "Box", "A box, as a pydantic model: its fields are its signature."),
         ("class", "Thing", "A thing with a method."),
         ("method", "Thing.size", "Measure the thing."),
+        ("method", "Thing.grow", "Grow the thing, through a decorator."),
     ]
 
 
@@ -158,6 +190,27 @@ def test_markdown_shows_a_pydantic_model_as_a_table_of_fields(
     assert "| `label` | str \\| None | `None` |  |" in text
 
 
+def test_markdown_shows_a_typeddict_as_a_table_of_keys(
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
+) -> None:
+    """A TypedDict has no signature to show; its keys are the table, with their comments."""
+    text = docs.markdown("thing", example(tmp_path, monkeypatch))
+    assert "## class Point\n\nA point, as a TypedDict: its keys are its signature.\n\n| Key" in text
+    assert "| `x` | int | Across |" in text
+    assert "| `y` | int |  |" in text
+
+
+def test_a_decorated_method_is_seen_through_its_decorator(
+    tmp_path: Path,  # A folder of this test's own, where the example package is written
+    monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
+) -> None:
+    """`Thing.grow` is wrapped by `logged`; its own signature and docments are what is shown."""
+    text = docs.markdown("thing", example(tmp_path, monkeypatch))
+    assert "### Thing.grow\n\n```python\nThing.grow(by: int) -> int\n```" in text
+    assert "| `by` | int | required | How much |" in text
+
+
 def test_markdown_has_no_links_and_no_ids(
     tmp_path: Path,  # A folder of this test's own, where the example package is written
     monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
@@ -196,6 +249,8 @@ def test_gaps_names_what_each_symbol_is_missing(
     assert found["Thing"] == []
     assert found["Thing.size"] == []
     assert found["Box"] == ["pkg.thing:Box.label: no description"]
+    assert found["Point"] == ["pkg.thing:Point.y: no docment"]
+    assert found["Thing.grow"] == []
     assert found["bare"] == [
         "pkg.thing:bare: no docstring",
         "pkg.thing:bare(x): no type",
@@ -233,26 +288,28 @@ def test_check_prints_a_count_per_module_then_every_gap_and_fails(
 ) -> None:
     """`check` prints one line per module, the gaps, the total, and exits 1 when there is a gap."""
     pkg = example(tmp_path, monkeypatch)
-    assert docs.main(["check"], pkg, tmp_path / "no-tests") == 1
+    assert docs.main(["check"], pkg, tmp_path / "nowhere") == 1
     out = capsys.readouterr().out
-    assert "pkg.thing                          4 of   7" in out
+    assert "pkg.thing                          6 of  10" in out
     assert "pkg.thing:bare(x): no docment" in out
-    assert out.endswith("4 of 7 functions, methods and classes are typed and documented\n")
+    assert out.endswith("6 of 10 functions, methods and classes are typed and documented\n")
 
 
-def test_check_holds_the_tests_to_the_convention_too(
+def test_check_holds_the_tests_and_the_root_and_docs_files_too(
     tmp_path: Path,  # A folder of this test's own, where the example package is written
     monkeypatch: pytest.MonkeyPatch,  # Makes the example importable for this test only
     capsys: pytest.CaptureFixture[str],  # Captures what the command prints
 ) -> None:
-    """A folder of tests is checked like the package, each file under its path."""
+    """The tests, a script at the root and a script under docs/ are checked like the package."""
     pkg = example(tmp_path, monkeypatch)
     (tmp_path / "tests").mkdir()
-    (tmp_path / "tests" / "test_x.py").write_text(
-        '"""Tests."""\n\n\ndef test_x() -> None:\n    """One."""\n'
-    )
-    assert docs.main(["check"], pkg, tmp_path / "tests") == 1
-    assert "/tests/test_x.py" in capsys.readouterr().out
+    (tmp_path / "docs").mkdir()
+    one = '"""One file."""\n\n\ndef f() -> None:\n    """One."""\n'
+    for name in ("tests/test_x.py", "tool.py", "docs/build.py"):
+        (tmp_path / name).write_text(one)
+    assert docs.main(["check"], pkg, tmp_path) == 1
+    out = capsys.readouterr().out
+    assert all(f"/{name}" in out for name in ("tool.py", "docs/build.py", "tests/test_x.py"))
 
 
 def test_list_prints_one_line_per_symbol(
@@ -264,7 +321,7 @@ def test_list_prints_one_line_per_symbol(
     assert docs.main(["list"], example(tmp_path, monkeypatch)) == 0
     lines = capsys.readouterr().out.splitlines()
     assert lines[0].startswith("module    pkg.thing             A thing, with one function")
-    assert lines[-1] == "method    pkg.thing.Thing.size  Measure the thing."
+    assert lines[-1] == "method    pkg.thing.Thing.grow  Grow the thing, through a decorator."
 
 
 def test_module_prints_the_markdown_and_an_unknown_name_is_refused(
````

</details>

<a id="step-05-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -0,0 +1,190 @@
+"""Tests of the model on a tiny random backbone: packing, forgery, isolation, and what trains."""
+
+from typing import Any
+
+import pytest
+import torch
+from hypothesis import given
+from hypothesis import strategies as st
+from transformers import PreTrainedTokenizerFast
+
+from babykev.model import SPECIAL, DecisionModel, PointerHead, encode, pick_device, user_tokens
+from tests.tiny import tiny_backbone, tiny_tokenizer
+
+TOK = tiny_tokenizer()
+
+# Text a caller might send, including text that contains the delimiters themselves.
+texts = st.lists(st.sampled_from([*"abc xyz.", *SPECIAL]), max_size=12).map("".join)
+questions = st.lists(
+    st.fixed_dictionaries(
+        {
+            "instr": texts,
+            "options": st.lists(texts, min_size=2, max_size=4),
+            "label": st.just(0),
+        }
+    ),
+    min_size=1,
+    max_size=3,
+)
+records = st.fixed_dictionaries({"state": texts, "questions": questions})
+
+
+def logits_of(
+    model: DecisionModel,  # The model to ask
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record
+) -> list[torch.Tensor]:  # For each question, one logit per option
+    """Pack a record and score it, without tracking gradients."""
+    with torch.no_grad():
+        return model(encode(tok, record))
+
+
+# Packing
+
+
+def test_packing_marks_every_part_with_its_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+) -> None:
+    """A packed record is the state, then each question with its options and its decide token."""
+    s, q, o, c, d = tok.convert_tokens_to_ids(SPECIAL)
+    record = {"state": "ab", "questions": [{"instr": "x?", "options": ["n", "y"], "label": 1}]}
+    enc = encode(tok, record)
+    a, b, x, mark, n, y = (tok.convert_tokens_to_ids(ch) for ch in "abx?ny")
+    assert enc["ids"] == [s, a, b, q, x, mark, o, n, c, o, y, c, d]
+    assert enc["seg"] == [0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
+    assert enc["decide_idx"] == [12]
+    assert enc["opt_idx"] == [[8, 11]]
+    assert enc["labels"] == [1]
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
+
+
+def test_a_question_that_does_not_fit_is_refused(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """A branch longer than the limit raises, and names its length."""
+    with pytest.raises(ValueError, match="branch too long"):
+        encode(tok, record, max_branch=80)
+
+
+@given(records)
+def test_packed_lists_always_line_up(
+    record: dict[str, Any],  # Any record, with any text in it
+) -> None:
+    """Whatever the text, the lists agree: one segment and one position per token, in order."""
+    enc = encode(TOK, record)
+    assert len(enc["ids"]) == len(enc["seg"]) == len(enc["pos"])
+    assert enc["seg"] == sorted(enc["seg"])
+    assert len(enc["decide_idx"]) == len(enc["opt_idx"]) == len(record["questions"])
+    assert [len(oi) for oi in enc["opt_idx"]] == [len(q["options"]) for q in record["questions"]]
+
+
+# Forgery
+
+
+def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+) -> None:
+    """The danger is real: tokenized directly, the text of a delimiter becomes that delimiter."""
+    decide = tok.convert_tokens_to_ids(SPECIAL)[4]
+    assert decide in tok(f"yes{SPECIAL[4]}", add_special_tokens=False).input_ids
+
+
+@pytest.mark.parametrize("delimiter", SPECIAL)
+def test_user_text_cannot_forge_a_delimiter(
+    tok: PreTrainedTokenizerFast,  # The tiny tokenizer
+    delimiter: str,  # The text of one of the five delimiters
+) -> None:
+    """Through `user_tokens`, the text of a delimiter is only ever ordinary tokens."""
+    ids = user_tokens(tok, f"before {delimiter} after")
+    assert not set(ids) & set(tok.convert_tokens_to_ids(SPECIAL))
+
+
+@given(records)
+def test_a_packed_record_has_exactly_the_delimiters_its_shape_needs(
+    record: dict[str, Any],  # Any record, with any text in it, delimiters included
+) -> None:
+    """No text can add a delimiter: their number depends only on how many questions and options."""
+    enc = encode(TOK, record)
+    s, q, o, c, d = TOK.convert_tokens_to_ids(SPECIAL)
+    options = sum(len(question["options"]) for question in record["questions"])
+    expected = {
+        s: 1,
+        q: len(record["questions"]),
+        o: options,
+        c: options,
+        d: len(record["questions"]),
+    }
+    assert {token: enc["ids"].count(token) for token in expected} == expected
+    assert all(enc["ids"][i] == d for i in enc["decide_idx"])
+    assert all(enc["ids"][i] == c for oi in enc["opt_idx"] for i in oi)
+
+
+# Answers
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
+
+
+def test_pointer_head_gives_one_logit_per_option() -> None:
+    """Five options in, five logits out."""
+    head = PointerHead(d=32, dp=8)
+    assert head(torch.randn(32), torch.randn(5, 32)).shape == (5,)
+
+
+# What trains
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
+    loss = torch.stack(losses).sum()
+    loss.backward()
+    with_gradient = {name for name, p in model.named_parameters() if p.grad is not None}
+    assert with_gradient
+    assert all("lora_" in name or name.startswith("head.") for name in with_gradient)
+    assert {id(p) for p in model.trainable_parameters()} == {
+        id(p) for name, p in model.named_parameters() if name in with_gradient
+    }
+
+
+# Devices
+
+
+def test_pick_device_takes_an_override() -> None:
+    """A device asked for by name is used, whatever the machine has."""
+    assert pick_device("cpu") == "cpu"
+
+
+def test_pick_device_finds_something_to_run_on() -> None:
+    """With no override, the choice is one of the three kinds of device."""
+    assert pick_device() in {"cuda", "mps", "cpu"}
```

</details>

<a id="step-05-tests-unit-test_smoke.py-89db04-diff"></a>

<details><summary>The diff of <code>tests/unit/test_smoke.py</code></summary>

```diff
@@ -0,0 +1,44 @@
+"""The smoke run, on the tiny model: it must report on every question of the sample data."""
+
+from transformers import PreTrainedTokenizerFast
+
+from babykev.model import DecisionModel
+from babykev.smoke import read_lines, smoke, verdict
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
+    assert any(
+        text.strip().startswith(f"{sum('  ok' in v for v in verdicts)} of 15 right")
+        for text in report
+    )
+
+
+def test_verdict_agrees_when_the_answer_is_the_label() -> None:
+    """A verdict says what the model said, what the label says, and whether they agree."""
+    question = {"type": "choice", "criteria": {"cow": None, "goat": None}, "label": "goat"}
+    given = {"type": "choice", "choice": "goat", "probabilities": {"cow": 0.2, "goat": 0.8}}
+    assert verdict(question, given) == ("goat (0.80)", "goat", True)
+
+
+def test_verdict_reads_a_noul_answer_as_yes_from_one_half() -> None:
+    """A probability of yes at or above 0.5 is a yes."""
+    said, label, agree = verdict({"type": "noul", "label": False}, {"type": "noul", "noul": 0.5})
+    assert (said, label, agree) == ("yes (0.50)", "no", False)
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

[This change on GitHub](https://github.com/rahuldave/babykev/compare/a9a391de1f271392a948cdd16afe2f3b1cfdd437...46cf8625a031e10049355df4c37abcb7af58d847).

This part ends at the code at `step-05`. [The code after this part](https://github.com/rahuldave/babykev/tree/step-05)

<a id="step-05a"></a>

## 5a The tests that could tell

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `step-05`. [The code before this part](https://github.com/rahuldave/babykev/tree/step-05)

**Init.** `just setup` changes nothing in `.venv`: no new package. 0.5 s.

```bash
just setup
```

**What is new:** seven tests that see the mask, of nine new tests: `tests/unit/test_mask.py`, five tests of the mask's rule, three of which fail on step 05's mask, and four isolation tests in `test_model.py`, which all fail on it; the fix, one line of `branch_mask`; the two guards ty asked for, `delimiter_ids` and a check in `load_tokenizer`; `just types` as a line of `check`; two pages of the docs site, `docs/guide/00_model.qmd` (the four ideas) and `docs/guide/01_mask.ipynb` (the mask as a grid, with the mask of step 05 beside it), and a test that re-runs the notebook. Clean: 103 tests, 154 of 154, green.

**We had two problems left over from step 05.** The slide names them; both are lines of step 05's `model.py`, which this step changes, so there is nothing to print here. The first is a type problem. `just types` printed six findings at step 05. Five come from one line, line 97, `tok.convert_tokens_to_ids(SPECIAL)`, which gives back a list of five numbers that the line splits into five names; the library says it may give back one number, which ty cannot see past. The sixth is `load_tokenizer`, which may give back `None`. The second is a mask problem. `branch_mask` lets question 2 look at question 1, line 140 of step 05's file, and every check passed, because no test checks the function that builds the mask. Step 05a deals with both: the tests that see the mask, the one-line fix, and the two guards for ty.

**The tiny model, again.** Step 05 built a tiny tokenizer and a tiny model in memory, in `tests/tiny.py`: 106 tokens, 2 layers of 32 numbers, 24,224 parameters, measured at step 05; neither `tiny.py` nor `conftest.py` changed in this step. A test gets them as fixtures. The first `sed` line prints `tests/conftest.py`, lines 16 to 27: `tok`, built once for the whole run (`scope="session"`), returns `tiny_tokenizer()`; `model`, built fresh for each test, returns a decision model on `tiny_backbone(len(tok))`, on the CPU, without an adapter. A test builds nothing. It names `model` and `tok` as arguments, and pytest passes in what the two functions return; the tests of this step do that. The second `sed` line prints lines 30 to 40, the `record` fixture: one request about Roquefort, with a state and three questions, `Is this a blue cheese?` with 2 options, `Which milk?` with 3, `How firm?` with 3.

```bash
sed -n '16,27p' tests/conftest.py
sed -n '30,40p' tests/conftest.py
```

**A. Test properties, not examples.** Four properties, for any request: change question 2 and question 1's answer must not move; three questions in one pass give the numbers of three passes; the order of the questions does not matter; and the mask's rule, no token sees a later one and no question sees another. They are true for any weights, so the tiny model is enough. `just test`: 103 passed, the 92 of step 05 and 11 new: nine tests of the mask and of isolation, and two notebook tests.

```bash
just test
```

**B. A picture checks one size.** At the end of step 05, five lines of plain Python drew the right mask for a request of six tokens next to the one `branch_mask` built, and rows 5 and 6 were WRONG. The mask is fixed in this step, and the same five lines print `ok` six times. In `test_mask.py` the same comparison is the test `test_mask_of_a_small_request`, lines 28 to 39. Suppose someone fixed the mask like this instead: a token may look at the state, at its own question, and at any question more than one before it, so only the question right before is blocked. The first `perl` line writes that wrong fix into line 151 of `branch_mask`. The first here document, the six-token request of the end of step 05, still prints `ok` six times: its picture has only two questions, so it cannot tell. The second here document has a different size: one state token and three questions of one token each, parts `[0, 1, 2, 3]`, four tokens, with a picture drawn by hand. Rows 1 to 3 print `ok`. Row 4 prints `#..# ##.# WRONG`: question 3 looks at question 1. The `git restore` line puts the fix back: every paragraph from here puts in what it needs, and restores it, so each runs on its own. We have no function that draws the right mask for any size, and the hypothesis tests of the next paragraphs do not draw pictures: they state the rule. A request can have 1 to 6 state tokens, then 0 to 4 questions of 1 to 5 tokens each, 6 times 781, which is 4,686 shapes, and each would need its own picture.

```bash
perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)/' src/babykev/model.py
uv run python - <<'EOF'
from babykev.model import branch_mask
picture = ["#.....", "##....", "###...", "####..", "##..#.", "##..##"]
mask = branch_mask([0, 0, 1, 1, 2, 2], "cpu")[0, 0] == 0
rows = ["".join("#" if ok else "." for ok in row) for row in mask]
for want, got in zip(picture, rows, strict=True): print(want, got, "ok" if want == got else "WRONG")
EOF
uv run python - <<'EOF'
from babykev.model import branch_mask
picture = ["#...", "##..", "#.#.", "#..#"]
mask = branch_mask([0, 1, 2, 3], "cpu")[0, 0] == 0
rows = ["".join("#" if ok else "." for ok in row) for row in mask]
for want, got in zip(picture, rows, strict=True): print(want, got, "ok" if want == got else "WRONG")
EOF
git restore src/babykev/model.py
```

**C. hypothesis: state the rule, the computer tries the shapes.** `hypothesis` is a Python library for tests; `just setup` installed it with the model's stack at step 05. The `sed` line prints three lines of `test_mask.py`. Line 10, `shapes`, says what a request may look like: a state of 1 to 6 tokens, then a list of up to 4 questions of 1 to 5 tokens each. `@given(shapes)` on line 58 runs the test below it again and again, each time with a shape drawn at random from the 4,686: by default, up to 100 times. When a shape breaks the rule, hypothesis shrinks it, trying smaller shapes until none smaller breaks, and shows that one. hypothesis also allows each run 200 ms by default. The first run that uses torch can take longer than that on a slow or busy machine: in a rehearsal in the dev container, one example of the rule test took 1180 ms, the run failed with `DeadlineExceeded`, and the same test passed on another run. The second `sed` line prints lines 43 to 51 of `tests/conftest.py`, which turn the deadline off for the whole run, with a comment that says why; the import sits below the fixtures so that they keep lines 16 to 40.

```bash
sed -n '10p;58,59p' tests/unit/test_mask.py
sed -n '43,51p' tests/conftest.py
```

**D. hypothesis finds the size for us.** The `perl` line writes the wrong fix of paragraph B in again, so that this paragraph runs on its own. The `sed` line prints one rule test, lines 58 to 65 of `test_mask.py`, kind: unit: `segments` gives the part of each token, 0 for the state and k for question k; `siblings` is yes for two tokens in two different questions; `allowed` is the mask read as yes or no; the test says no pair is both. `just test -k no_question_sees_another` runs it alone. hypothesis tries shapes until the rule breaks, and shrinks the failure to `shape = (1, [1, 1, 1])`: one state token and three questions of one token each, parts `[0, 1, 2, 3]`, the request we drew by hand in paragraph B. We chose that size; hypothesis found it on its own. The output prints `allowed` and `siblings` as tensors of `True` and `False`; written as `#` and `.`, `allowed` is `# . . .`, `# # . .`, `# . # .`, `# # . #`, and `siblings` is `. . . .`, `. . # #`, `. # . #`, `. # # .`. Row 4, column 2 is yes in both: token 4, in question 3, looks at token 2, in question 1. The `git restore` line puts the fix back.

```bash
perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = (s[None, :] == s[:, None]) | (s[None, :] == 0) | (s[None, :] < s[:, None] - 1)/' src/babykev/model.py
sed -n '58,65p' tests/unit/test_mask.py
just test -k no_question_sees_another
git restore src/babykev/model.py
```

**E. How we tested isolation.** The `perl` line writes step 05's mask line back into `branch_mask`: a plain causal mask, every token sees everything before it. The isolation test needs that mask: with the wrong fix of paragraph B it passes, because question 3 cannot see question 2, so rewriting question 2 changes nothing. `test_a_question_cannot_see_its_sibling`, lines 145 to 157 of `test_model.py`, kind: integration, on the tiny model. It takes the fixtures `model`, `tok` and `record`, from `conftest.py`. `logits_of` packs a request and gives, for each question, one score for each of its options. The test scores the request, rewrites question 2 (`Where from?`, two options in place of three), and scores again. Questions 1 and 3 must get exactly the same scores, `torch.equal`, and question 2 must get a different number of scores. With step 05's mask the line for question 3 fails: before, `tensor([-0.2301, -0.2331, -0.2340])`; after, `tensor([-0.2266, -0.2302, -0.2312])`. Question 3 could look at question 2, so rewriting question 2 moved its scores. The line for question 1 passes: question 1 comes first and cannot look at what follows. The `git restore` line puts the fix back. The same idea for any request is `test_packed_equals_separate_for_any_record`, lines 184 to 194, which hypothesis feeds: one pass over all the questions must give what one pass for each question alone gives. It builds its own tiny model, at line 190, in place of taking the `model` fixture: hypothesis runs the test body many times, and refuses a test that takes a function-scoped fixture. Tried in a scratch copy, a `@given` test with `model` as an argument fails with `FailedHealthCheck: ... uses a function-scoped fixture 'model'`.

```bash
perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = torch.ones_like(causal) | (s[None, :] == 0)/' src/babykev/model.py
sed -n '145,157p' tests/unit/test_model.py
just test -k a_question_cannot_see_its_sibling
git restore src/babykev/model.py
```

**F. The tests see it, and the one-line fix.** The `perl` line writes step 05's mask line back, as in the last paragraph. `just test`: 8 failed, 95 passed, in about 20 seconds, because hypothesis shrinks each failing case to its smallest. Three of the five tests of `test_mask.py` fail: the picture test and two of the three rules. The two that pass check the mask's shape and that no token sees a later token. The four isolation tests fail, and the notebook test, because the grid the notebook stored no longer matches what the code prints. The commit hook, installed at step 03, runs `just check`, and `just check` runs these tests, so this commit would now be refused, at the tests, with the same eight names. ty passes here: the two guards of paragraph H are already in the files, and only the mask line is wrong. We saw a refused commit at steps 03 and 04b, so we do not make one here. The `git restore` line puts the fix back, because everything after this needs it. The last `sed` line prints line 151, the fix: a token may look at the state, or at its own question. Step 05 had `torch.ones_like(causal)` where the first part is.

```bash
perl -pi -e 's/^    same = \(s\[None, :\] == s\[:, None\]\) \| \(s\[None, :\] == 0\)$/    same = torch.ones_like(causal) | (s[None, :] == 0)/' src/babykev/model.py
just test
git restore src/babykev/model.py
sed -n '151p' src/babykev/model.py
```

**G. The smoke run on Qwen, again.** `just smoke local` on the right mask: 4 of 15 right, about 300 ms a request (242 ms at one run, 327 at another). It was 6 at step 05, and several answers changed: the first cheese's milk went from buffalo to cow. A pure guess on these fifteen questions expects 4.75 right: the sample has five yes-or-no questions, a guess right once in 2, five choice questions of 5 options, once in 5, and five score questions of 4 levels, once in 4, which is 2.5 + 1 + 1.25.

```bash
just smoke local
```

**H. The type problem: two guards.** The `sed` line prints lines 64 to 80: `load_tokenizer` checks what came back, and stops with an error if it is not a tokenizer, so it never gives back `None`; `delimiter_ids` is the one place that calls `convert_tokens_to_ids`, and turns one number into a list of one, so it always gives back a list. `encode`, line 108, and the tests, lines 57, 108, 119 and 128 of `test_model.py`, call it in place of the five calls ty complained about. `just types`: All checks passed!

```bash
sed -n '64,80p' src/babykev/model.py
just types
```

**I. ty joins `just check`.** `just --show check`: six commands now, `types` between `lint` and the tests. `just check`: green, 20 seconds. The commit hook runs `just check`, so a commit with a type problem is now refused, at ty, before the tests run: a type error added to `model.py` in a scratch copy stopped `just check` there, with `Found 1 diagnostic`. At step 05 we could commit with six ty findings. From now on we cannot.

```bash
just --show check
just check
```

**J. The model, explained.** `just docs` renders eight pages now, with a Guide section. 11 seconds.

```bash
just docs
```

The first guide page is the four ideas, in prose, where every name in backticks links to its reference entry. The second is the mask as a grid, a notebook committed with its outputs, with the mask of step 05 beside the right one.

```bash
open docs/_site/guide/00_model.html
open docs/_site/guide/01_mask.html
```

`just test -k notebook` re-runs the notebook's cells and checks the stored outputs are still what the code prints: 2 passed.

```bash
just test -k notebook
```

**What the next step does.** 05b puts the project in two images, so it runs the same on any system with Docker, and is ready for the platforms.

### What changed

- <a id="step-05a-README.md-8ec9a0"></a>`README.md`: 6 lines added, 4 removed. [The file](https://github.com/rahuldave/babykev/blob/c954af4beae61eaab89bcb2d4724eea4f2706703/README.md).
- <a id="step-05a-docs-_quarto.yml-ee884f"></a>`docs/_quarto.yml`: 2 lines added. [The file](https://github.com/rahuldave/babykev/blob/c954af4beae61eaab89bcb2d4724eea4f2706703/docs/_quarto.yml).
- <a id="step-05a-docs-guide-00_model.qmd-42835e"></a>`docs/guide/00_model.qmd`: New, 55 lines. [The file](https://github.com/rahuldave/babykev/blob/c954af4beae61eaab89bcb2d4724eea4f2706703/docs/guide/00_model.qmd).
- <a id="step-05a-docs-guide-01_mask.ipynb-f6e9ba"></a>`docs/guide/01_mask.ipynb`: New, 265 lines. [The file](https://github.com/rahuldave/babykev/blob/c954af4beae61eaab89bcb2d4724eea4f2706703/docs/guide/01_mask.ipynb).
- <a id="step-05a-justfile-424f0b"></a>`justfile`: 2 lines added, 1 removed. [The file](https://github.com/rahuldave/babykev/blob/c954af4beae61eaab89bcb2d4724eea4f2706703/justfile).
- <a id="step-05a-pyproject.toml-5d07e7"></a>`pyproject.toml`: 3 lines added. [The file](https://github.com/rahuldave/babykev/blob/c954af4beae61eaab89bcb2d4724eea4f2706703/pyproject.toml).
- <a id="step-05a-src-babykev-model.py-a86a0b"></a>`src/babykev/model.py`: adds `delimiter_ids`; changes `branch_mask`, `encode`. 14 lines added, 3 removed. [The file](https://github.com/rahuldave/babykev/blob/c954af4beae61eaab89bcb2d4724eea4f2706703/src/babykev/model.py).
- <a id="step-05a-tests-conftest.py-626af3"></a>`tests/conftest.py`: changes `record`. 11 lines added. [The file](https://github.com/rahuldave/babykev/blob/c954af4beae61eaab89bcb2d4724eea4f2706703/tests/conftest.py).
- <a id="step-05a-tests-unit-test_mask.py-aeb55a"></a>`tests/unit/test_mask.py`: adds `allowed`, `segments`, `test_every_token_sees_the_state_before_it_and_its_own_question`, `test_mask_has_a_shape_the_model_can_add_to_its_attention`, `test_mask_of_a_small_request`, `test_no_question_sees_another_question`, `test_no_token_sees_a_later_token`. New, 78 lines. [The file](https://github.com/rahuldave/babykev/blob/c954af4beae61eaab89bcb2d4724eea4f2706703/tests/unit/test_mask.py).
- <a id="step-05a-tests-unit-test_model.py-583145"></a>`tests/unit/test_model.py`: adds `test_a_question_cannot_see_its_sibling`, `test_packed_equals_separate_for_any_record`, `test_packed_questions_answer_as_they_would_alone`, `test_the_order_of_questions_does_not_matter`; changes `test_a_packed_record_has_exactly_the_delimiters_its_shape_needs`, `test_a_tokenizer_alone_would_let_text_forge_a_delimiter`, `test_packing_marks_every_part_with_its_delimiter`, `test_user_text_cannot_forge_a_delimiter`. 69 lines added, 6 removed. [The file](https://github.com/rahuldave/babykev/blob/c954af4beae61eaab89bcb2d4724eea4f2706703/tests/unit/test_model.py).
- <a id="step-05a-tests-unit-test_notebooks.py-057539"></a>`tests/unit/test_notebooks.py`: adds `printed`, `test_notebook_prints_what_its_stored_outputs_show`, `test_there_is_a_notebook_to_check`. New, 42 lines. [The file](https://github.com/rahuldave/babykev/blob/c954af4beae61eaab89bcb2d4724eea4f2706703/tests/unit/test_notebooks.py).

<a id="step-05a-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

```diff
@@ -58,7 +58,9 @@ babykev help` is the program's own help. Extra arguments go to the tool behind a
 render` runs only the tests whose name contains `render`.
 
 The documentation comes from the code. `just docs` builds the site into `docs/_site/`; open
-`docs/_site/index.html`. The same text is there at the terminal as plain Markdown, for people and for
+`docs/_site/index.html`. Under Guide, two pages explain the model: the four ideas, and the mask as a
+grid (a notebook, committed with its outputs; a test re-runs its cells and checks the outputs are still
+true). The same text is there at the terminal as plain Markdown, for people and for
 agents: `just docs list` names every module, class and function with its summary, `just docs module api`
 prints one module, and `just docs check` counts what is typed and documented and lists every gap. The
 convention: every function is typed, has a docstring, and carries a docment, a comment beside each
@@ -75,8 +77,8 @@ what the run shows is that the pieces fit. The first run downloads the base mode
 Hub, about 1 GB, into its cache; later runs read it from there. The platform is a word of the recipe, and
 only `local` exists so far.
 
-`just types` is ty, the type checker: it reads every call against what the called function declares.
-It is not part of `just check` yet.
+`just types` is ty, the type checker: it reads every call against what the called function declares,
+and it is one of the lines of `just check`, so the hook runs it on every commit.
 
 ## What is here
 
@@ -88,7 +90,7 @@ It is not part of `just check` yet.
 | `src/babykev/model.py` | The model: packing a context and its questions into one sequence, the mask that keeps questions apart, the pointer head that scores options, and the class that puts them on a language model |
 | `src/babykev/smoke.py` | The smoke run behind `just smoke` |
 | `src/babykev/docs.py` | What the code says about itself, as plain Markdown: `babykev docs list`, `docs module NAME`, `docs check` |
-| `docs/` | The docs site: `_quarto.yml`, the front page `index.qmd`, `apidocs.py` (writes the reference pages from `babykev docs` before every render) and `linkify.lua` (a name in backticks becomes a link). The built site in `_site/` is not committed |
+| `docs/` | The docs site: `_quarto.yml`, the front page `index.qmd`, the guide pages under `guide/`, `apidocs.py` (writes the reference pages from `babykev docs` before every render) and `linkify.lua` (a name in backticks becomes a link). The built site in `_site/` is not committed |
 | `data/cheese/sample.jsonl` | Five lines of data. Each is a request about a cheese with a `label` on every question: the right answer |
 | `tests/unit/` | Unit tests of the contract, of the command, of the documentation, of the model and of the smoke. One test checks every line of the sample data against the contract |
 | `tests/tiny.py`, `tests/conftest.py` | A tokenizer with one token per character and a two-layer backbone with random weights, built in memory: the model's tests need no download and no GPU |
```

</details>

<a id="step-05a-docs-_quarto.yml-ee884f-diff"></a>

<details><summary>The diff of <code>docs/_quarto.yml</code></summary>

```diff
@@ -8,6 +8,8 @@ website:
   sidebar:
     contents:
       - index.qmd
+      - section: Guide
+        contents: guide/*
       - section: Reference
         contents: api/*
 
```

</details>

<a id="step-05a-docs-guide-00_model.qmd-42835e-diff"></a>

<details><summary>The diff of <code>docs/guide/00_model.qmd</code></summary>

```diff
@@ -0,0 +1,55 @@
+---
+title: "The model"
+---
+
+babykev is a language model that has been taught to point instead of to speak. Four ideas make that
+work, and each is one piece of `model.py`. The reference pages hold the signatures; this page holds the
+reasons.
+
+## 1. Packing
+
+A request is one context and several questions. `encode` writes all of it into a single sequence of
+tokens, in this order: a delimiter and the context, then for each question a delimiter, the instruction,
+each option between an opening and a closing delimiter, and a decide delimiter where the question ends.
+The five delimiters are special tokens the base model already has and rarely uses, listed in `SPECIAL`,
+so no embedding has to be added or trained: the adapter learns their new meaning.
+
+Text that comes from a caller goes through `user_tokens` first, which rewrites anything that looks like
+a special token before tokenizing it. Without that, a context containing the text of the closing
+delimiter could close an option early. The tests put the delimiters' text into every field and count
+the delimiters that come out.
+
+`encode` returns an `Encoded`: the ids, and three things the model needs to read them correctly: the
+segment of each token (0 for the context, *k* for question *k*), the position of each token, and where
+each question's decide token and option tokens are.
+
+## 2. The mask
+
+The questions share one reading of the context, and nothing else. `branch_mask` builds the attention
+mask that makes this true: token *i* may attend to token *j* only when *j* is not after *i*, and *j* is
+in the context or in the same question as *i*. The mask is added to the attention scores, so a blocked
+pair gets the most negative number the number type can hold.
+
+Because of this mask, three questions packed into one request get exactly the answers they would get
+in three separate requests, and the tests check that to the last decimal. The next page shows the mask
+as a grid.
+
+## 3. Positions restart
+
+Every question's positions begin right after the context. To the model, a question looks the same
+wherever it comes in the request, and the tests check that reversing the order of the questions
+changes nothing.
+
+## 4. Pointing
+
+`PointerHead` is two small projections. At each question's decide token it takes the hidden state and
+projects it; at each option's closing token it takes the hidden state and projects it; the scaled dot
+product of the two is the option's score. One pass gives every question its scores at once. The base
+model's vocabulary head is dropped: `DecisionModel` keeps only the transformer, wraps it in a LoRA
+adapter when asked, and adds the head. The model has no way to generate text.
+
+## What trains
+
+With an adapter, the backbone is frozen. Gradients reach the adapter's matrices and the pointer head
+and nothing else; `trainable_parameters` lists exactly those. The smoke run reports how many
+parameters that is: about 9 million of 503 million.
```

</details>

<a id="step-05a-docs-guide-01_mask.ipynb-f6e9ba-diff"></a>

<details><summary>The diff of <code>docs/guide/01_mask.ipynb</code></summary>

````diff
@@ -0,0 +1,265 @@
+{
+ "cells": [
+  {
+   "cell_type": "markdown",
+   "id": "cell-0",
+   "metadata": {},
+   "source": [
+    "# The mask\n",
+    "\n",
+    "A request asks several questions about one context. The model reads the context once and answers every\n",
+    "question in the same pass, and yet no question can influence another. What makes that possible is the\n",
+    "attention mask, built by `branch_mask`.\n",
+    "\n",
+    "This page is a notebook. The reference entry below is pulled from the source, and the grids are what the\n",
+    "code printed when the notebook was last run."
+   ]
+  },
+  {
+   "cell_type": "code",
+   "execution_count": null,
+   "id": "cell-1",
+   "metadata": {
+    "execution": {
+     "iopub.execute_input": "2026-10-05T04:48:47.932699Z",
+     "iopub.status.busy": "2026-10-05T04:48:47.932312Z",
+     "iopub.status.idle": "2026-10-05T04:48:52.500370Z",
+     "shell.execute_reply": "2026-10-05T04:48:52.499652Z"
+    }
+   },
+   "outputs": [
+    {
+     "data": {
+      "text/markdown": [
+       "```python\n",
+       "def branch_mask(\n",
+       "    seg:list[int], # The segment of each token: 0 for the state, k for question k\n",
+       "    device:str, # Where to build the mask\n",
+       "    dtype:torch.dtype=torch.float32, # The number type of the model's attention scores\n",
+       ")->torch.Tensor: # Shape [1, 1, n, n]: 0 where i may attend to j, very negative elsewhere\n",
+       "```\n",
+       "\n",
+       "*Build the block-causal mask: a token sees the state and its own question, never a sibling.*\n",
+       "\n",
+       "Token i may attend to token j when j is not after i, and j is in the state or in the same\n",
+       "question as i. The mask is added to the attention scores, so a blocked pair gets the most\n",
+       "negative number the type can hold."
+      ],
+      "text/plain": [
+       "def branch_mask(\n",
+       "    seg:list[int], # The segment of each token: 0 for the state, k for question k\n",
+       "    device:str, # Where to build the mask\n",
+       "    dtype:torch.dtype=torch.float32, # The number type of the model's attention scores\n",
+       ")->torch.Tensor: # Shape [1, 1, n, n]: 0 where i may attend to j, very negative elsewhere\"\"\"Build the block-causal mask: a token sees the state and its own question, never a sibling.\n",
+       "\n",
+       "Token i may attend to token j when j is not after i, and j is in the state or in the same\n",
+       "question as i. The mask is added to the attention scores, so a blocked pair gets the most\n",
+       "negative number the type can hold.\"\"\""
+      ]
+     },
+     "execution_count": null,
+     "metadata": {},
+     "output_type": "execute_result"
+    }
+   ],
+   "source": [
+    "#| echo: false\n",
+    "from fastcore.docments import MarkdownRenderer as show_doc\n",
+    "\n",
+    "from babykev.model import branch_mask\n",
+    "\n",
+    "show_doc(branch_mask)"
+   ]
+  },
+  {
+   "cell_type": "markdown",
+   "id": "cell-2",
+   "metadata": {},
+   "source": [
+    "## A small request\n",
+    "\n",
+    "Take three context tokens, then two questions of two tokens each. `encode` gives every token a segment:\n",
+    "0 for the context, 1 for the first question, 2 for the second. In the grid, each row is a token, and a\n",
+    "filled cell means it may attend to the token in that column."
+   ]
+  },
+  {
+   "cell_type": "code",
+   "execution_count": null,
+   "id": "cell-3",
+   "metadata": {
+    "execution": {
+     "iopub.execute_input": "2026-10-05T04:48:52.501975Z",
+     "iopub.status.busy": "2026-10-05T04:48:52.501737Z",
+     "iopub.status.idle": "2026-10-05T04:48:52.523683Z",
+     "shell.execute_reply": "2026-10-05T04:48:52.522904Z"
+    }
+   },
+   "outputs": [
+    {
+     "name": "stdout",
+     "output_type": "stream",
+     "text": [
+      "   0 0 0 1 1 2 2\n",
+      "0  # . . . . . .\n",
+      "0  # # . . . . .\n",
+      "0  # # # . . . .\n",
+      "1  # # # # . . .\n",
+      "1  # # # # # . .\n",
+      "2  # # # . . # .\n",
+      "2  # # # . . # #\n"
+     ]
+    }
+   ],
+   "source": [
+    "def show(seg, mask=branch_mask):\n",
+    "    allow = mask(seg, \"cpu\")[0, 0] == 0\n",
+    "    print(\"   \" + \" \".join(str(s) for s in seg))\n",
+    "    for s, row in zip(seg, allow, strict=True):\n",
+    "        print(f\"{s}  \" + \" \".join(\"#\" if ok else \".\" for ok in row))\n",
+    "\n",
+    "\n",
+    "show([0, 0, 0, 1, 1, 2, 2])"
+   ]
+  },
+  {
+   "cell_type": "markdown",
+   "id": "cell-4",
+   "metadata": {},
+   "source": [
+    "Read the last two rows. The second question sees the three context tokens and itself. The two columns\n",
+    "of the first question are empty: to the second question, the first one is not there.\n",
+    "\n",
+    "## The rule\n",
+    "\n",
+    "Token *i* may attend to token *j* when *j* is not later than *i*, and *j* is in the context or in the\n",
+    "same question as *i*. Nothing else. A longer request shows the same blocks:"
+   ]
+  },
+  {
+   "cell_type": "code",
+   "execution_count": null,
+   "id": "cell-5",
+   "metadata": {
+    "execution": {
+     "iopub.execute_input": "2026-10-05T04:48:52.525230Z",
+     "iopub.status.busy": "2026-10-05T04:48:52.525102Z",
+     "iopub.status.idle": "2026-10-05T04:48:52.528362Z",
+     "shell.execute_reply": "2026-10-05T04:48:52.527657Z"
+    }
+   },
+   "outputs": [
+    {
+     "name": "stdout",
+     "output_type": "stream",
+     "text": [
+      "   0 0 1 1 1 2 3 3\n",
+      "0  # . . . . . . .\n",
+      "0  # # . . . . . .\n",
+      "1  # # # . . . . .\n",
+      "1  # # # # . . . .\n",
+      "1  # # # # # . . .\n",
+      "2  # # . . . # . .\n",
+      "3  # # . . . . # .\n",
+      "3  # # . . . . # #\n"
+     ]
+    }
+   ],
+   "source": [
+    "show([0, 0, 1, 1, 1, 2, 3, 3])"
+   ]
+  },
+  {
+   "cell_type": "markdown",
+   "id": "cell-6",
+   "metadata": {},
+   "source": [
+    "## The mask as it was at step 05\n",
+    "\n",
+    "The model arrived with a plain causal mask, the usual one for a language model: every token sees\n",
+    "everything before it. Here is the same request under that mask. The second question's rows now have\n",
+    "the first question's columns filled: it reads the first question as if it were part of the context.\n",
+    "Nothing crashes, the model still returns probabilities, and the answers to one question depend on\n",
+    "which questions were asked before it. Only a test of the rule above can tell."
+   ]
+  },
+  {
+   "cell_type": "code",
+   "execution_count": null,
+   "id": "cell-7",
+   "metadata": {
+    "execution": {
+     "iopub.execute_input": "2026-10-05T04:48:52.529728Z",
+     "iopub.status.busy": "2026-10-05T04:48:52.529589Z",
+     "iopub.status.idle": "2026-10-05T04:48:52.533448Z",
+     "shell.execute_reply": "2026-10-05T04:48:52.532772Z"
+    }
+   },
+   "outputs": [
+    {
+     "name": "stdout",
+     "output_type": "stream",
+     "text": [
+      "   0 0 0 1 1 2 2\n",
+      "0  # . . . . . .\n",
+      "0  # # . . . . .\n",
+      "0  # # # . . . .\n",
+      "1  # # # # . . .\n",
+      "1  # # # # # . .\n",
+      "2  # # # # # # .\n",
+      "2  # # # # # # #\n"
+     ]
+    }
+   ],
+   "source": [
+    "import torch\n",
+    "\n",
+    "\n",
+    "def plain_causal_mask(seg, device, dtype=torch.float32):\n",
+    "    n = len(seg)\n",
+    "    causal = torch.tril(torch.ones(n, n, dtype=torch.bool, device=device))\n",
+    "    blocked = torch.finfo(dtype).min\n",
+    "    return torch.zeros(n, n, dtype=dtype, device=device).masked_fill(~causal, blocked)[None, None]\n",
+    "\n",
+    "\n",
+    "show([0, 0, 0, 1, 1, 2, 2], plain_causal_mask)"
+   ]
+  },
+  {
+   "cell_type": "markdown",
+   "id": "cell-8",
+   "metadata": {},
+   "source": [
+    "## Why it matters\n",
+    "\n",
+    "Because of this mask, three questions packed into one request get exactly the answers they would get\n",
+    "in three separate requests. That is a property of the mask and not of the weights, so the tests check\n",
+    "it on a tiny model with random weights. The other half of the trick is in `encode`: each question's\n",
+    "positions restart right after the context, so a question looks the same to the model whether it comes\n",
+    "first or last. `PointerHead` then reads the answer off the question's own tokens, and `DecisionModel`\n",
+    "puts the pieces together."
+   ]
+  }
+ ],
+ "metadata": {
+  "kernelspec": {
+   "display_name": "Python 3",
+   "language": "python",
+   "name": "python3"
+  },
+  "language_info": {
+   "codemirror_mode": {
+    "name": "ipython",
+    "version": 3
+   },
+   "file_extension": ".py",
+   "mimetype": "text/x-python",
+   "name": "python",
+   "nbconvert_exporter": "python",
+   "pygments_lexer": "ipython3",
+   "version": "3.13.3"
+  }
+ },
+ "nbformat": 4,
+ "nbformat_minor": 5
+}
````

</details>

<a id="step-05a-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

```diff
@@ -69,7 +69,7 @@ types *args:
 test *args:
     {{ if args == "help" { "just help test" } else { 'uv run pytest "$@"' } }}
 
-# Everything a commit must pass: format, lint, the tests over the coverage floor, the docs, the config files
+# Everything a commit must pass: format, lint, types, the tests over the coverage floor, the docs, the config files
 [group('quality')]
 [no-exit-message]
 check *args:
@@ -78,6 +78,7 @@ check *args:
     if [ "$*" = help ]; then just help check; exit 0; fi
     just fmt --check
     just lint
+    just types
     just test -q --cov-fail-under=90
     just docs check
     just lint-config
```

</details>

<a id="step-05a-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -89,6 +89,9 @@ ignore = ["S311"]
 [tool.ruff.lint.per-file-ignores]
 # A test is written with assert. S106 mistakes the tokenizer argument `unk_token` for a password
 "tests/**" = ["S101", "S106"]
+# A notebook imports the renderer under the name nbdev users know it by, and its helper functions
+# are part of the story it tells, not of the code
+"docs/guide/*.ipynb" = ["N813", "ANN", "D1"]
 
 [tool.uv.sources]
 torch = { index = "pytorch-cpu" } # the CPU build, from the index above
```

</details>

<a id="step-05a-src-babykev-model.py-a86a0b-diff"></a>

<details><summary>The diff of <code>src/babykev/model.py</code></summary>

```diff
@@ -65,7 +65,18 @@ def load_tokenizer(
     name: str,  # A model name on the Hugging Face Hub, or a local folder
 ) -> PreTrainedTokenizerBase:  # Its tokenizer
     """Load the tokenizer that belongs to a base model."""
-    return AutoTokenizer.from_pretrained(name)
+    tok = AutoTokenizer.from_pretrained(name)
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
 
 
 def user_tokens(
@@ -94,7 +105,7 @@ def encode(
     instruction, each option between its two delimiters, and the decide delimiter. Raises
     `ValueError` when a branch does not fit in `max_branch`.
     """
-    s_id, q_id, o_id, c_id, d_id = tok.convert_tokens_to_ids(SPECIAL)
+    s_id, q_id, o_id, c_id, d_id = delimiter_ids(tok)
     state = [s_id] + user_tokens(tok, rec["state"])[: max_state - 1]
     ids, seg, pos = list(state), [0] * len(state), list(range(len(state)))
     decide_idx, opt_idx = [], []
@@ -137,7 +148,7 @@ def branch_mask(
     s = torch.tensor(seg, device=device)
     n = len(seg)
     causal = torch.tril(torch.ones(n, n, dtype=torch.bool, device=device))
-    same = torch.ones_like(causal) | (s[None, :] == 0)
+    same = (s[None, :] == s[:, None]) | (s[None, :] == 0)
     allow = causal & same
     blocked = torch.finfo(dtype).min
     return torch.zeros(n, n, dtype=dtype, device=device).masked_fill(~allow, blocked)[None, None]
```

</details>

<a id="step-05a-tests-conftest.py-626af3-diff"></a>

<details><summary>The diff of <code>tests/conftest.py</code></summary>

```diff
@@ -38,3 +38,14 @@ def record() -> dict[str, Any]:  # A record with a state and three questions
             {"instr": "How firm?", "options": ["Soft", "Semi-soft", "Hard"], "label": 1},
         ],
     }
+
+
+# hypothesis runs a test again and again, and by default allows each run 200 ms. The first run
+# that uses torch can take longer than that on a slow or busy machine, for example inside a
+# container, and the test then fails by chance: `DeadlineExceeded`, reported as `FlakyFailure`.
+# The tests that hypothesis feeds check a rule and not a speed, so the deadline is off for the
+# whole run. The import sits here, below the fixtures, so that they keep their places in the file.
+from hypothesis import settings  # noqa: E402
+
+settings.register_profile("babykev", deadline=None)
+settings.load_profile("babykev")
```

</details>

<a id="step-05a-tests-unit-test_mask.py-aeb55a-diff"></a>

<details><summary>The diff of <code>tests/unit/test_mask.py</code></summary>

```diff
@@ -0,0 +1,78 @@
+"""Tests of the block-causal mask. They state its rule as properties that hold for any request."""
+
+import torch
+from hypothesis import given
+from hypothesis import strategies as st
+
+from babykev.model import branch_mask
+
+# A request of any shape: a state of 1 to 6 tokens, then up to 4 questions of 1 to 5 tokens each.
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
+
+def allowed(
+    seg: list[int],  # The segment of each token
+) -> torch.Tensor:  # Shape [n, n]: True where token i may attend to token j
+    """Read the mask back as yes or no."""
+    return branch_mask(seg, "cpu")[0, 0] == 0
+
+
+def test_mask_of_a_small_request() -> None:
+    """Two state tokens and two questions of two tokens: the picture to keep in mind."""
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
+
+
+def test_mask_has_a_shape_the_model_can_add_to_its_attention() -> None:
+    """One batch, one head, a square of the sequence length; 0 allows, very negative blocks."""
+    mask = branch_mask([0, 0, 1, 2], "cpu")
+    assert mask.shape == (1, 1, 4, 4)
+    assert set(mask.unique().tolist()) == {0.0, torch.finfo(torch.float32).min}
+
+
+@given(shapes)
+def test_no_token_sees_a_later_token(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """The mask is causal: nothing above the diagonal is allowed."""
+    allow = allowed(segments(*shape))
+    assert not torch.triu(allow, diagonal=1).any()
+
+
+@given(shapes)
+def test_no_question_sees_another_question(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """A token of one question never attends to a token of another."""
+    seg = torch.tensor(segments(*shape))
+    siblings = (seg[:, None] != seg[None, :]) & (seg[:, None] > 0) & (seg[None, :] > 0)
+    assert not (allowed(seg.tolist()) & siblings).any()
+
+
+@given(shapes)
+def test_every_token_sees_the_state_before_it_and_its_own_question(
+    shape: tuple[int, list[int]],  # The lengths of a state and of its questions
+) -> None:
+    """What is allowed is exactly: not later, and in the state or in the same question."""
+    seg = segments(*shape)
+    rule = [
+        [j <= i and (seg[j] == 0 or seg[j] == seg[i]) for j in range(len(seg))]
+        for i in range(len(seg))
+    ]
+    assert allowed(seg).tolist() == rule
```

</details>

<a id="step-05a-tests-unit-test_model.py-583145-diff"></a>

<details><summary>The diff of <code>tests/unit/test_model.py</code></summary>

```diff
@@ -4,11 +4,19 @@ from typing import Any
 
 import pytest
 import torch
-from hypothesis import given
+from hypothesis import given, settings
 from hypothesis import strategies as st
 from transformers import PreTrainedTokenizerFast
 
-from babykev.model import SPECIAL, DecisionModel, PointerHead, encode, pick_device, user_tokens
+from babykev.model import (
+    SPECIAL,
+    DecisionModel,
+    PointerHead,
+    delimiter_ids,
+    encode,
+    pick_device,
+    user_tokens,
+)
 from tests.tiny import tiny_backbone, tiny_tokenizer
 
 TOK = tiny_tokenizer()
@@ -46,7 +54,7 @@ def test_packing_marks_every_part_with_its_delimiter(
     tok: PreTrainedTokenizerFast,  # The tiny tokenizer
 ) -> None:
     """A packed record is the state, then each question with its options and its decide token."""
-    s, q, o, c, d = tok.convert_tokens_to_ids(SPECIAL)
+    s, q, o, c, d = delimiter_ids(tok)
     record = {"state": "ab", "questions": [{"instr": "x?", "options": ["n", "y"], "label": 1}]}
     enc = encode(tok, record)
     a, b, x, mark, n, y = (tok.convert_tokens_to_ids(ch) for ch in "abx?ny")
@@ -97,7 +105,7 @@ def test_a_tokenizer_alone_would_let_text_forge_a_delimiter(
     tok: PreTrainedTokenizerFast,  # The tiny tokenizer
 ) -> None:
     """The danger is real: tokenized directly, the text of a delimiter becomes that delimiter."""
-    decide = tok.convert_tokens_to_ids(SPECIAL)[4]
+    decide = delimiter_ids(tok)[4]
     assert decide in tok(f"yes{SPECIAL[4]}", add_special_tokens=False).input_ids
 
 
@@ -108,7 +116,7 @@ def test_user_text_cannot_forge_a_delimiter(
 ) -> None:
     """Through `user_tokens`, the text of a delimiter is only ever ordinary tokens."""
     ids = user_tokens(tok, f"before {delimiter} after")
-    assert not set(ids) & set(tok.convert_tokens_to_ids(SPECIAL))
+    assert not set(ids) & set(delimiter_ids(tok))
 
 
 @given(records)
@@ -117,7 +125,7 @@ def test_a_packed_record_has_exactly_the_delimiters_its_shape_needs(
 ) -> None:
     """No text can add a delimiter: their number depends only on how many questions and options."""
     enc = encode(TOK, record)
-    s, q, o, c, d = TOK.convert_tokens_to_ids(SPECIAL)
+    s, q, o, c, d = delimiter_ids(TOK)
     options = sum(len(question["options"]) for question in record["questions"])
     expected = {
         s: 1,
@@ -131,6 +139,61 @@ def test_a_packed_record_has_exactly_the_delimiters_its_shape_needs(
     assert all(enc["ids"][i] == c for oi in enc["opt_idx"] for i in oi)
 
 
+# Isolation
+
+
+def test_a_question_cannot_see_its_sibling(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Rewriting one question leaves the answers to the others exactly as they were."""
+    before = logits_of(model, tok, record)
+    changed = {**record, "questions": list(record["questions"])}
+    changed["questions"][1] = {"instr": "Where from?", "options": ["Spain", "Italy"], "label": 0}
+    after = logits_of(model, tok, changed)
+    assert torch.equal(before[0], after[0])
+    assert torch.equal(before[2], after[2])
+    assert before[1].shape != after[1].shape
+
+
+def test_packed_questions_answer_as_they_would_alone(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """One pass over three questions gives what three passes over one question each would give."""
+    packed = logits_of(model, tok, record)
+    for together, question in zip(packed, record["questions"], strict=True):
+        alone = logits_of(model, tok, {"state": record["state"], "questions": [question]})[0]
+        assert torch.allclose(together, alone, atol=1e-5)
+
+
+def test_the_order_of_questions_does_not_matter(
+    model: DecisionModel,  # The tiny model
+    tok: PreTrainedTokenizerFast,  # Its tokenizer
+    record: dict[str, Any],  # A record with three questions
+) -> None:
+    """Because positions restart, a question gets the same answer first or last."""
+    forward = logits_of(model, tok, record)
+    backward = logits_of(model, tok, {**record, "questions": record["questions"][::-1]})
+    for a, b in zip(forward, backward[::-1], strict=True):
+        assert torch.allclose(a, b, atol=1e-5)
+
+
+@settings(max_examples=20, deadline=None)
+@given(records)
+def test_packed_equals_separate_for_any_record(
+    record: dict[str, Any],  # Any record, with any text in it
+) -> None:
+    """The isolation of questions is a property of the mask, so it holds for any request."""
+    model = DecisionModel("tiny", "cpu", backbone=tiny_backbone(len(TOK))).eval()
+    packed = logits_of(model, TOK, record)
+    for together, question in zip(packed, record["questions"], strict=True):
+        alone = logits_of(model, TOK, {"state": record["state"], "questions": [question]})[0]
+        assert torch.allclose(together, alone, atol=1e-5)
+
+
 # Answers
 
 
```

</details>

<a id="step-05a-tests-unit-test_notebooks.py-057539-diff"></a>

<details><summary>The diff of <code>tests/unit/test_notebooks.py</code></summary>

```diff
@@ -0,0 +1,42 @@
+"""The guide notebooks: their code must still run, and print what their stored outputs show."""
+
+import contextlib
+import io
+import json
+from pathlib import Path
+from typing import Any
+
+import pytest
+
+GUIDE = Path(__file__).parents[2] / "docs" / "guide"
+NOTEBOOKS = sorted(GUIDE.glob("*.ipynb"))
+
+
+def printed(
+    cell: dict[str, Any],  # A code cell of a notebook
+) -> str:  # What the cell printed when the notebook was last run and saved
+    """Read the text a cell's stored outputs show on standard output."""
+    streams = [o for o in cell["outputs"] if o["output_type"] == "stream" and o["name"] == "stdout"]
+    return "".join("".join(o["text"]) for o in streams)
+
+
+@pytest.mark.parametrize("notebook", NOTEBOOKS, ids=lambda path: path.name)
+def test_notebook_prints_what_its_stored_outputs_show(
+    notebook: Path,  # A notebook of the guide
+) -> None:
+    """Run the code cells in order, as plain Python, and compare what each prints with its output.
+
+    The docs site shows the stored outputs without running anything. This test keeps them true.
+    """
+    cells = json.loads(notebook.read_text(encoding="utf-8"))["cells"]
+    namespace: dict[str, Any] = {}
+    for cell in (c for c in cells if c["cell_type"] == "code"):
+        out = io.StringIO()
+        with contextlib.redirect_stdout(out):
+            exec("".join(cell["source"]), namespace)  # noqa: S102 - running the notebook is the test
+        assert out.getvalue() == printed(cell)
+
+
+def test_there_is_a_notebook_to_check() -> None:
+    """The guide has at least one notebook, so the test above is not vacuous."""
+    assert NOTEBOOKS
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/compare/46cf8625a031e10049355df4c37abcb7af58d847...c954af4beae61eaab89bcb2d4724eea4f2706703).

This part ends at the code at `step-05a`. [The code after this part](https://github.com/rahuldave/babykev/tree/step-05a)

<a id="step-05b"></a>

## 5b Two images from one lockfile

This walk goes through [rahuldave/babykev](https://github.com/rahuldave/babykev) on GitHub. This part starts from the code at `step-05a`. [The code before this part](https://github.com/rahuldave/babykev/tree/step-05a)

**Init.** `just setup` brings one package, hadolint 2.15.1, the Dockerfile's linter, as a wheel from PyPI: there are wheels for the Mac and for Linux on both architectures. 0.5 s.

```bash
just setup
```

**What is new:** a `Dockerfile` that builds two images from `uv.lock`, and a `.dockerignore`; the `image` recipe; hadolint as a line of `lint-config`; `tests/system/test_real_model.py`, the smoke on the real model, marked `system` and left out of `just test`; a section of the README on Docker. Clean: 103 tests and 1 deselected, 155 of 155 documented, green.

**How Docker was born.** The second slide is the meme: "It works on my machine." "Then we'll ship your machine." And that is how Docker was born. A widely shared meme; its author is unknown (imgflip.com/i/24ac74).

**Two images from one lockfile.** The table of the next two pictures. The dev image has every dependency with the dev tools, uv, just, Quarto and git; it starts a shell with your folder mounted; it is for working on the project on any system, and in CI; 1.84 GB. The run image has Python and what the program needs; it starts `babykev`; it is for a platform that runs the program; 1.15 GB. Both are built from `uv.lock`, the packages first and the code after, so a change to the code does not reinstall torch.

**A. The run image, in the file.** The `sed` line prints lines 11 to 39 of the `Dockerfile`. Line 12 takes uv from its own image. Lines 16 to 28 are a build stage: the packages from the lockfile first (line 25), then the code (lines 27 and 28), so a change to the code reinstalls one package and not torch. Lines 31 to 39 are the run image: a fresh Python, the finished environment copied over from the build stage (line 32), the sample data, and `babykev` as the command it starts. No uv, no just, no dev tools. The first slide of the two shows these lines with the settings (lines 18 to 23 and 35 to 37) left out, and a note on each stage.

```bash
sed -n '11,39p' Dockerfile
```

**B. Build it, run it.** `docker build --target run` builds that image and names it `babykev-run`: 20 s with the cache warm. `docker run --rm babykev-run` starts it with no words, which runs line 39's default, `babykev help`, and removes the container when it exits.

```bash
docker build --target run --tag babykev-run .
docker run --rm babykev-run
```

`docker image ls` with a format prints the name and the size: 1.15 GB, nearly all of it torch.

```bash
docker image ls babykev-run --format '{{.Repository}}:{{.Tag}}  {{.Size}}'
```

**C. The smoke on Linux.** The same smoke, in the image. The `-v` mounts this Mac's Hugging Face cache at `/hf`, where line 36 tells the image to look, so the 953 MB model is not downloaded again. It says `on cpu`: a container on a Mac is Linux in a virtual machine, and sees no Apple GPU. 4 of 15 right, 2.9 s a request, 33 s in all. On the Mac (05a) it was 362 ms a request on `mps`, and the fifteen answers are identical, line for line, to the two decimals printed.

```bash
docker run --rm -v ~/.cache/huggingface:/hf babykev-run smoke
```

**D. The dev image.** Lines 41 to 77: the image to work in. Debian packages for git and curl (lines 49 to 51), Quarto from its release (lines 53 to 56), uv (line 57), just from PyPI (line 68), and then the whole project with its dev group (lines 71 to 74). The environment is in `/opt/venv` (line 58), outside the project folder. Line 76 declares the port the step browser uses. It starts a shell. The second slide shows these lines with the long ones cut, and a note on each part. `docker build --target dev` needs only the first stage, `uv`, because that is the only stage the dev image copies from.

```bash
sed -n '41,77p' Dockerfile
```

`docker build --target dev`: 2 s with the cache warm; 61 s cold. 1.84 GB: the dev tools, Quarto and git on top of the run image's 1.15.

```bash
docker build --target dev --tag babykev-dev .
```

**E. Working inside it.** `docker run -it` gives a terminal in the container; `-v "$PWD":/work` mounts this folder as the project, so an edit here is seen in there at once. The prompt changes: we are in Linux, in `/work`.

```bash
docker run --rm -it -v "$PWD":/work babykev-dev
```

`which` shows where each tool is: Python from `/opt/venv`, just, Quarto and uv from `/usr/local/bin`. This folder's own `.venv` is the Mac's, and nothing in the container looks at it.

```bash
which python just quarto uv
```

`just check`, inside: the same lines as on the Mac, and green. 103 passed, 1 deselected, 155 of 155, 93.12% coverage. 24 s on its own, 65 s in the rehearsal of 2026-10-06 with another container running. `just smoke local`, inside: the same smoke as on the Mac, on the CPU, from the mounted cache: 4 of 15 right, loaded in 10 s, about 8 s a request with another container running. `git status` works in the mounted folder, because line 69 of the `Dockerfile` declares every folder safe. As `root`, in `/work`: Python 3.13, just 1.50.0, uv 0.12.13, Quarto 1.8.26.

```bash
just check
just smoke local
exit
```

**F. The recipe.** `just --show image`: one recipe, three words. `build dev|run` runs the `docker build` of B or D and names the image by the commit, so the image always says which code is in it; `shell` is E's `docker run`; `run WORDS` is C's. On a machine with no Docker, and inside the image, it says so instead of failing.

```bash
just --show image
```

From now on `just image`. Both builds are instant from the cache, and `docker image ls` shows each image under two names: `latest`, from B and D, and the commit's short hash.

```bash
just image build dev
just image build run
docker image ls 'babykev-*' --format '{{.Repository}}:{{.Tag}}  {{.Size}}'
```

`just image shell` starts a new container every time, and `exit` deletes it: whatever was installed or run in there is gone, and only the mounted folder keeps what changed. To keep one, `just image start` leaves a container named `babykev-dev` running in the background; `just image shell` then goes into that one (`docker exec`), and a second `just image start` refuses. Both publish the dev image's port 8765, the step browser's, on the first free port here from 8765 up, and print the address: in the rehearsal `http://localhost:8766`, because the step browser on this Mac uses 8765. `docker ps` shows it running, with the port. `just test` inside: 103 passed, 1 deselected. `just image stop` removes it.

```bash
just image start
docker ps --filter name=babykev-dev --format '{{.Names}}  {{.Image}}  {{.Status}}  {{.Ports}}'
just image shell
just test
exit
just image stop
```

**G. hadolint.** A linter for Dockerfiles. `uv run hadolint Dockerfile` says nothing: clean, exit 0. It found two things in the first draft, and the slide shows both.

The first is rule DL3059: two `RUN` lines in a row could be one. Lines 68 and 69 are one `RUN`, the `just` install and the `git` setting joined with `&&`. The first `perl` line splits them into two `RUN` lines, and hadolint then says `Dockerfile:69 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation.`, exit 1. The `git restore` line puts the file back.

```bash
uv run hadolint Dockerfile
perl -pi -e 's/^RUN uv tool install "rust-just==\$\{JUST\}" \\$/RUN uv tool install "rust-just==\${JUST}"/; s/^    && git config /RUN git config /' Dockerfile
uv run hadolint Dockerfile
git restore Dockerfile
```

The second is DL3008. Lines 46 to 48 say why: hadolint's rule DL3008 asks for a pinned version of every Debian package, and we declined it, with the reason beside the line. The `perl` line deletes the ignore, line 48; hadolint then says `Dockerfile:48 DL3008 warning: Pin versions in apt get install. Instead of `apt-get install <package>` use `apt-get install <package>=<version>``, exit 1, at the `RUN` line. A pinned Debian version is removed from the archive at its next security fix, and the build breaks within weeks; the base image's tag is the pin. The `git restore` line puts the ignore back, because the next command checks the file.

```bash
sed -n '46,48p' Dockerfile
perl -ni -e 'print unless /^# hadolint ignore=DL3008$/' Dockerfile
uv run hadolint Dockerfile
git restore Dockerfile
```

`just --show lint-config`: hadolint is the second line. `just lint-config`: green, 1.5 s. So the hook runs it on every commit.

```bash
just --show lint-config
just lint-config
```

**What should not go in the hook?** The slide asks it, because the slides so far were about the hook: at almost every step we added a check, `just check` runs them all, and the commit hook runs `just check`. A check that needs the network, a download, a GPU or a lot of time can fail for reasons outside our code, and a hook that fails for those reasons cannot be trusted. The question for every check: can anything but our code make it fail?

**Kinds of tests, and which can run on every commit.** The table of step 05 again, with an example of ours for each kind and whether it is hermetic. Unit: a confidence function on a list of numbers. Integration: the mask, the packing and the model together, and the whole smoke on the tiny model; hermetic, because the tiny model stands in for the real one. End-to-end: the smoke on the real model, `test_real_model.py`; not hermetic. Smoke: the same smoke, by hand, `just smoke local`. Acceptance: none yet. pytest has no built-in kinds: a marker is a name we make up in `pyproject.toml`, put on a test as `@pytest.mark.NAME`, and choose with `-m NAME`. Our one marker is `system`, the end-to-end kind of the table: it is on the one test that needs the Hub, the weights and a device.

**2 unit tests, 0 integration tests.** The meme: two window handles that each work when used alone, and block each other when used together. Made popular by Randal Olson in January 2016; the clip's author is unknown. The file in `walks/narrative/slides/pictures/memes/` is the clip from Giphy, cut to 300 pixels wide and 8 frames a second, 2.6 MB; an earlier copy was Giphy's "This content is not available" placeholder.

**H. The test that is not hermetic.** `pyproject.toml` lines 53 to 57: pytest now leaves out every test marked `system` (line 56), and line 57 declares the marker.

```bash
sed -n '53,57p' pyproject.toml
```

The test, `tests/system/test_real_model.py`: the docstring says why it is apart, line 14 marks every test in the file, and the test runs the smoke's `main` and asserts what is true on any device: exit code 0, fifteen verdicts, and a count of them. Not the score: an untrained model guesses.

```bash
sed -n '1,27p' tests/system/test_real_model.py
```

`just test`: 103 passed, 1 deselected. `just test -m system`: 1 passed, 103 deselected, 19 s on the Mac's GPU. Its coverage table shows `smoke.py` at 94%: `main`, lines 102 to 122, which no unit test reaches.

```bash
just test
just test -m system
```

**I. Hermetic, by experiment.** `just image shell` with `--network none`: extra words go to docker, and this container has no network at all.

```bash
just image shell --network none
```

`just check`: green, 25 s, as with the network. Everything the hook runs is hermetic.

```bash
just check
```

The system test passes too, 29 s on the CPU: not because it is hermetic, but because the model is in the mounted cache.

```bash
just test -m system
```

Point the cache at an empty folder and it fails, in 48 s: "We couldn't connect to 'https://huggingface.co' to load the files, and couldn't find them in the cached files."

```bash
HF_HOME=/tmp/empty just test -m system
exit
```

**A test is anything that can fail and stop you.** The table lists what is checked, how, with which recipe, and whether it runs on every commit: the functions, the mask and the model with pytest, hypothesis and the tiny model, `just test`; types with ty, `just types`; documentation, `just docs check`; format and lint with ruff; the config files and the Dockerfile with yamllint, validate-pyproject, uv and hadolint, `just lint-config`; all of these on every commit. The real model from the Hub, the smoke marked `system`, `just test -m system`, does not run on every commit: it is not hermetic. More generally, a test is anything that can fail and stop a commit. Most of these are not pytest. All of them are `just`.

**You may even call it a gate.** The distracted girlfriend: the agent looks back at the gate, and the general test, her boyfriend, watches. A widely shared stock photo, labelled by us; the template is on imgflip, imgflip.com/memetemplate/118429510. The file is `walks/narrative/slides/pictures/memes/distracted-agent-gate.jpg`.

**J. If there is time: amd64.** This Mac is arm64; most platforms and CI runners are amd64. `--platform linux/amd64` goes through to `docker build`: 33 s, under Rosetta. `docker image inspect` says `linux/amd64`. The smoke runs, with a warning that the image's platform is not the host's: 4 of 15 again, 10.4 s a request, three and a half times slower than native.

```bash
just image build run --platform linux/amd64
docker image inspect babykev-run:$(git rev-parse --short HEAD) --format '{{.Os}}/{{.Architecture}}'
just image run smoke
```

**K. The site, published.** So far the site was a folder on this machine, `docs/_site/`. `just --show docs`: one more word, `publish`. It checks that the remote `origin` exists and is on GitHub, and says so and stops if not; then `quarto publish gh-pages docs` renders the site and pushes it to the `gh-pages` branch, which GitHub Pages serves. Once, in the repository's settings, Pages is set to deploy from that branch.

```bash
just --show docs
just docs publish
```

**What the next step does.** This is the end of the first lecture. Running on the platforms is a different class.

### What changed

- <a id="step-05b-.dockerignore-05a721"></a>`.dockerignore`: New, 26 lines. [The file](https://github.com/rahuldave/babykev/blob/47b43c0916ac186e3efdf42e15dbcf1f04edb1a0/.dockerignore).
- <a id="step-05b-Dockerfile-6651dd"></a>`Dockerfile`: New, 77 lines. [The file](https://github.com/rahuldave/babykev/blob/47b43c0916ac186e3efdf42e15dbcf1f04edb1a0/Dockerfile).
- <a id="step-05b-README.md-8ec9a0"></a>`README.md`: 41 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/47b43c0916ac186e3efdf42e15dbcf1f04edb1a0/README.md).
- <a id="step-05b-justfile-424f0b"></a>`justfile`: adds `recipe image`. 88 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/47b43c0916ac186e3efdf42e15dbcf1f04edb1a0/justfile).
- <a id="step-05b-pyproject.toml-5d07e7"></a>`pyproject.toml`: 6 lines added, 2 removed. [The file](https://github.com/rahuldave/babykev/blob/47b43c0916ac186e3efdf42e15dbcf1f04edb1a0/pyproject.toml).
- <a id="step-05b-tests-system-test_real_model.py-df0b9d"></a>`tests/system/test_real_model.py`: adds `test_the_real_model_answers_every_sample_question`. New, 27 lines. [The file](https://github.com/rahuldave/babykev/blob/47b43c0916ac186e3efdf42e15dbcf1f04edb1a0/tests/system/test_real_model.py).
- <a id="step-05b-uv.lock-8356d8"></a>`uv.lock`: 158 lines added, 108 removed. [The file](https://github.com/rahuldave/babykev/blob/47b43c0916ac186e3efdf42e15dbcf1f04edb1a0/uv.lock).

<a id="step-05b-.dockerignore-05a721-diff"></a>

<details><summary>The diff of <code>.dockerignore</code></summary>

```diff
@@ -0,0 +1,26 @@
+# What `docker build` never copies into an image: the git history, this machine's environment and
+# settings, and everything a run or a tool writes. The image makes its own environment in /opt/venv.
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
+htmlcov
+mlflow.db
+mlflow.db-*
+mlartifacts
+mlruns
+runs
+checkpoints
+predictions
+reports
+docs/_site
+docs/.quarto
+docs/api
+docs/_symbols.json
+.DS_Store
```

</details>

<a id="step-05b-Dockerfile-6651dd-diff"></a>

<details><summary>The diff of <code>Dockerfile</code></summary>

```diff
@@ -0,0 +1,77 @@
+# Two images from one file, both built from uv.lock, so they hold the versions the lockfile names.
+#
+#   docker build --target dev --tag babykev-dev .
+#       everything to work on the project: the dev tools, uv, just and Quarto. Starts a shell
+#   docker build --target run --tag babykev-run .
+#       only what the program needs, with no dev tools, no uv and no just. Starts `babykev`
+#
+# `just image build dev|run` runs these and names the image by the commit. The environment lives
+# in /opt/venv, never in the project folder, so a mounted folder's own .venv is never used.
+
+# uv itself, copied from its own image: the same version as on the machine that wrote the lockfile
+FROM ghcr.io/astral-sh/uv:0.12.13 AS uv
+
+# The environment without the dev tools. Its packages first and the code after, so a change to the
+# code reinstalls one package, not torch.
+FROM python:3.13-slim-trixie AS build
+COPY --from=uv /uv /usr/local/bin/uv
+ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
+    UV_PYTHON_DOWNLOADS=never \
+    UV_COMPILE_BYTECODE=1 \
+    UV_LINK_MODE=copy \
+    UV_NO_CACHE=1
+WORKDIR /app
+COPY pyproject.toml uv.lock .python-version ./
+RUN uv sync --locked --no-dev --no-install-project
+COPY README.md LICENSE NOTICE ./
+COPY src ./src
+RUN uv sync --locked --no-dev --no-editable
+
+# The run image: Python, the environment, the program and its sample data. What a platform starts
+FROM python:3.13-slim-trixie AS run
+COPY --from=build /opt/venv /opt/venv
+WORKDIR /app
+COPY data ./data
+ENV PATH=/opt/venv/bin:$PATH \
+    HF_HOME=/hf \
+    PYTHONUNBUFFERED=1
+ENTRYPOINT ["babykev"]
+CMD ["help"]
+
+# The dev image: the whole project with its dev group, and the three tools the README asks for
+FROM python:3.13-slim-trixie AS dev
+ARG TARGETARCH
+ARG JUST=1.50.0
+ARG QUARTO=1.8.26
+# hadolint asks for a pinned version of each Debian package (DL3008). Debian replaces a package
+# with each security fix, so a pinned version stops building within weeks. The base image is the pin
+# hadolint ignore=DL3008
+RUN apt-get update \
+    && apt-get install --yes --no-install-recommends ca-certificates curl git \
+    && rm -rf /var/lib/apt/lists/*
+ARG RELEASES=https://github.com/quarto-dev/quarto-cli/releases/download
+RUN curl --fail --silent --show-error --location --output /tmp/quarto.deb \
+        "${RELEASES}/v${QUARTO}/quarto-${QUARTO}-linux-${TARGETARCH}.deb" \
+    && dpkg --install /tmp/quarto.deb \
+    && rm /tmp/quarto.deb
+COPY --from=uv /uv /uvx /usr/local/bin/
+ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
+    UV_PYTHON_DOWNLOADS=never \
+    UV_LINK_MODE=copy \
+    UV_NO_CACHE=1 \
+    UV_TOOL_BIN_DIR=/usr/local/bin \
+    PATH=/opt/venv/bin:$PATH \
+    HF_HOME=/hf \
+    PYTHONUNBUFFERED=1
+# just, as a wheel from PyPI. git refuses a repository owned by another user, and a mounted folder
+# is owned by the host's user, so every folder is declared safe
+RUN uv tool install "rust-just==${JUST}" \
+    && git config --system --add safe.directory '*'
+WORKDIR /work
+COPY pyproject.toml uv.lock .python-version ./
+RUN UV_COMPILE_BYTECODE=1 uv sync --locked --no-install-project
+COPY . .
+RUN uv sync --locked
+# The step browser, when it runs in here; `docker run -p 8765:8765` makes it reachable from outside
+EXPOSE 8765
+CMD ["bash"]
```

</details>

<a id="step-05b-README.md-8ec9a0-diff"></a>

<details><summary>The diff of <code>README.md</code></summary>

````diff
@@ -42,7 +42,9 @@ This is an educational repo. The repo `babykev` keeps the original model but reb
 
 ## What you need
 
-Three tools on the machine. This project installs everything else itself.
+Three tools on the machine. This project installs everything else itself. On a Mac or on Linux,
+install them directly. On Windows, work inside WSL2, which is Linux, or use the dev image (below);
+the recipes are not written for Windows itself.
 
 | Tool | What it is for |
 |---|---|
@@ -58,7 +60,10 @@ babykev help` is the program's own help. Extra arguments go to the tool behind a
 render` runs only the tests whose name contains `render`.
 
 The documentation comes from the code. `just docs` builds the site into `docs/_site/`; open
-`docs/_site/index.html`. Under Guide, two pages explain the model: the four ideas, and the mask as a
+`docs/_site/index.html`. `just docs publish` builds it and pushes it to the `gh-pages` branch of the
+GitHub repository that `origin` names, for GitHub Pages to serve (once, in the repository's settings,
+Pages must be set to deploy from that branch); with no remote, or one that is not on GitHub, it says so
+and does nothing. Under Guide, two pages explain the model: the four ideas, and the mask as a
 grid (a notebook, committed with its outputs; a test re-runs its cells and checks the outputs are still
 true). The same text is there at the terminal as plain Markdown, for people and for
 agents: `just docs list` names every module, class and function with its summary, `just docs module api`
@@ -77,9 +82,41 @@ what the run shows is that the pieces fit. The first run downloads the base mode
 Hub, about 1 GB, into its cache; later runs read it from there. The platform is a word of the recipe, and
 only `local` exists so far.
 
+`just test` runs every test that needs nothing but our code. One more test, in
+`tests/system/`, loads the real model the way the smoke does; it needs the Hub, the weights and a
+device, so it runs only when asked for: `just test -m system`.
+
 `just types` is ty, the type checker: it reads every call against what the called function declares,
 and it is one of the lines of `just check`, so the hook runs it on every commit.
 
+## In Docker
+
+The `Dockerfile` builds two images from the lockfile, for any machine that has Docker (Docker Desktop
+on a Mac or on Windows, OrbStack on a Mac, Docker Engine on Linux or on a cloud VM):
+
+| Image | Holds | Starts | For |
+|---|---|---|---|
+| dev | Python, every dependency with the dev tools, uv, just, Quarto, git | a shell | working on the project on any system, and checking it the way a CI runner would |
+| run | Python and the dependencies the program needs, nothing else | `babykev` | a platform that runs the program |
+
+```
+just image build dev        # docker build --target dev, named babykev-dev:COMMIT
+just image shell            # a shell in a new container, with this folder mounted at /work: just check
+just image start            # or keep one running in the background; then just image shell goes into it,
+just image stop             #   and what you installed or ran there is still there, until stop removes it
+just image build run
+just image run smoke        # the smoke in the run image, on the CPU
+```
+
+Each image is built for the machine's own architecture; `just image build run --platform linux/amd64`
+builds the one most platforms run. The environment inside lives in `/opt/venv`, so a mounted folder's
+own `.venv` is never used. Both images read the Hugging Face cache of the machine, mounted at `/hf`, so
+the base model is downloaded once. Extra arguments go to docker: `just image shell --network none`
+starts the shell with no network at all, where `just check` still passes and the real model can load
+only from the cache. The dev image declares port 8765, the step browser's: `just image shell` and `just image start`
+publish it on the first free port here from 8765 up, and say which. The recipe runs on the machine,
+never inside an image.
+
 ## What is here
 
 | Path | What it is |
@@ -92,6 +129,8 @@ and it is one of the lines of `just check`, so the hook runs it on every commit.
 | `src/babykev/docs.py` | What the code says about itself, as plain Markdown: `babykev docs list`, `docs module NAME`, `docs check` |
 | `docs/` | The docs site: `_quarto.yml`, the front page `index.qmd`, the guide pages under `guide/`, `apidocs.py` (writes the reference pages from `babykev docs` before every render) and `linkify.lua` (a name in backticks becomes a link). The built site in `_site/` is not committed |
 | `data/cheese/sample.jsonl` | Five lines of data. Each is a request about a cheese with a `label` on every question: the right answer |
+| `Dockerfile`, `.dockerignore` | The two images, dev and run, and what a build never copies into them |
+| `tests/system/` | The test that is not hermetic: the real model, from the Hub, on this machine's device |
 | `tests/unit/` | Unit tests of the contract, of the command, of the documentation, of the model and of the smoke. One test checks every line of the sample data against the contract |
 | `tests/tiny.py`, `tests/conftest.py` | A tokenizer with one token per character and a two-layer backbone with random weights, built in memory: the model's tests need no download and no GPU |
 | `justfile` | Every task of the project, one recipe each. `just help` explains them |
````

</details>

<a id="step-05b-justfile-424f0b-diff"></a>

<details><summary>The diff of <code>justfile</code></summary>

```diff
@@ -33,6 +33,75 @@ setup *args:
     uv run pre-commit install
     command -v quarto > /dev/null || echo "Quarto is not on this machine; just docs needs it: https://quarto.org/docs/get-started/"
 
+# The two images of the Dockerfile, by commit: just image build dev|run, just image start|shell|stop, just image run smoke
+[group('setup')]
+[no-exit-message]
+image *args:
+    #!/usr/bin/env sh
+    set -e
+    if [ "$*" = help ]; then just help image; exit 0; fi
+    if ! command -v docker > /dev/null; then
+        echo "image: there is no docker here. Inside the dev image, run the recipes themselves: just check" >&2
+        exit 2
+    fi
+    tag=$(git rev-parse --short HEAD)
+    cache="${HF_HOME:-$HOME/.cache/huggingface}"
+    name="{{ program }}-dev"
+    if [ -t 0 ]; then terminal=-it; else terminal=-i; fi
+    # The step browser's port in the dev image, 8765, is published on the first free port here from 8765 up
+    port=8765
+    while command -v nc > /dev/null && nc -z 127.0.0.1 "$port" 2> /dev/null; do port=$((port + 1)); done
+    case "$1" in
+        build)
+            case "$2" in dev | run) ;; *) echo "image build: say which image, dev or run" >&2; exit 2 ;; esac
+            if [ -n "$(git status --porcelain)" ]; then
+                echo "image: the working copy has changes the commit $tag does not; the image holds them" >&2
+            fi
+            kind=$2
+            shift 2
+            exec docker build --target "$kind" --tag "{{ program }}-$kind:$tag" "$@" .
+            ;;
+        stop)
+            exec docker rm --force "$name"
+            ;;
+        shell)
+            if [ -n "$(docker ps --quiet --filter "name=^$name\$")" ]; then
+                running=$(docker inspect --format '{{ "{{" }}.Config.Image{{ "}}" }}' "$name")
+                there=$(docker port "$name" 8765 | head -1 | sed 's/.*://')
+                echo "image: into $name, which runs $running; its port 8765 is http://localhost:$there here" >&2
+                exec docker exec "$terminal" "$name" bash
+            fi
+            ;;
+    esac
+    case "$1" in
+        start | shell | run)
+            if [ "$1" = run ]; then kind=run; else kind=dev; fi
+            image="{{ program }}-$kind:$tag"
+            if ! docker image inspect "$image" > /dev/null 2>&1; then
+                echo "image: there is no $image yet; build it with: just image build $kind" >&2
+                exit 1
+            fi
+            case "$1" in
+                run) shift; exec docker run --rm -v "$cache:/hf" "$image" "$@" ;;
+                shell)
+                    shift
+                    echo "image: a new container of $image; its port 8765 is http://localhost:$port here" >&2
+                    exec docker run --rm "$terminal" -p "$port:8765" -v "$PWD:/work" -v "$cache:/hf" "$@" "$image"
+                    ;;
+            esac
+            if [ -n "$(docker ps --all --quiet --filter "name=^$name\$")" ]; then
+                echo "image: $name is there already: just image shell goes into it, just image stop removes it" >&2
+                exit 1
+            fi
+            shift
+            docker run --detach -it --name "$name" -p "$port:8765" -v "$PWD:/work" -v "$cache:/hf" \
+                "$@" "$image" > /dev/null
+            echo "image: $name runs $image in the background; its port 8765 is http://localhost:$port here"
+            echo "image: just image shell goes into it, just image stop ends it"
+            ;;
+        *) echo "image: build dev|run, start, shell, stop, or run WORDS" >&2; exit 2 ;;
+    esac
+
 # Format the code, one way, no arguments. Extra arguments go to ruff: just fmt --check, just fmt --diff
 [group('quality')]
 [no-exit-message]
@@ -45,7 +114,7 @@ fmt *args:
 lint *args:
     {{ if args == "help" { "just help lint" } else { 'uv run ruff check "$@"' } }}
 
-# Lint the config files: the YAML files, pyproject.toml, the lockfile and this justfile
+# Lint the config files: the YAML files, the Dockerfile, pyproject.toml, the lockfile and this justfile
 [group('quality')]
 [no-exit-message]
 lint-config *args:
@@ -53,6 +122,7 @@ lint-config *args:
     set -e
     if [ "$*" = help ]; then just help lint-config; exit 0; fi
     uv run yamllint --strict .
+    uv run hadolint Dockerfile
     uv run validate-pyproject pyproject.toml
     uv lock --check
     just --fmt --check --unstable
@@ -83,13 +153,29 @@ check *args:
     just docs check
     just lint-config
 
-# Build the docs site into docs/_site. Words go to the program: just docs list, just docs module api, just docs check
+# Build the docs site into docs/_site; just docs publish puts it on GitHub Pages. Other words go to the program: just docs list
 [group('docs')]
 [no-exit-message]
 docs *args:
     #!/usr/bin/env sh
     if [ "$*" = help ]; then just help docs; exit 0; fi
     if [ "$#" -eq 0 ]; then exec uv run quarto render docs; fi
+    if [ "$*" = publish ]; then
+        if ! origin=$(git remote get-url origin 2> /dev/null); then
+            echo "docs publish: this repository has no remote named origin; GitHub Pages needs one on GitHub" >&2
+            exit 2
+        fi
+        case "$origin" in
+            *github.com*) ;;
+            *) echo "docs publish: origin is $origin, not GitHub; GitHub Pages needs a GitHub repository" >&2; exit 2 ;;
+        esac
+        if ! git ls-remote --exit-code --heads origin gh-pages > /dev/null; then
+            empty=$(git commit-tree "$(git hash-object -t tree /dev/null)" -m "An empty branch for GitHub Pages")
+            git push origin "$empty:refs/heads/gh-pages"
+        fi
+        # The site is committed on gh-pages, which has no .pre-commit-config.yaml: the hook lets that pass
+        PRE_COMMIT_ALLOW_NO_CONFIG=1 exec uv run quarto publish gh-pages docs --no-prompt --no-browser
+    fi
     exec uv run {{ program }} docs "$@"
 
 # Run everything that exists so far on the real model: just smoke local. Other platforms arrive later
```

</details>

<a id="step-05b-pyproject.toml-5d07e7-diff"></a>

<details><summary>The diff of <code>pyproject.toml</code></summary>

```diff
@@ -31,6 +31,7 @@ test = [
 ]
 dev = [{ include-group = "test" }, { include-group = "lint" }]
 lint = [
+    "hadolint-bin>=2.15.1",
     "pre-commit>=4.6",
     "ruff>=0.16",
     "ty>=0.0.84",
@@ -49,8 +50,11 @@ explicit = true
 [tool.pytest.ini_options]
 testpaths = ["tests"]
 pythonpath = ["."] # so that a test can import its helpers as tests.tiny
-# Every run measures how much of src/babykev the tests touch and lists the lines they do not
-addopts = "--cov=babykev --cov-report=term-missing"
+# Every run measures how much of src/babykev the tests touch and lists the lines they do not. A test
+# marked system needs something besides our code (the Hub, the real weights, a device) and runs
+# only when asked for: just test -m system
+addopts = "--cov=babykev --cov-report=term-missing -m 'not system'"
+markers = ["system: needs the network, the real model or a device; run with -m system"]
 
 [tool.ruff]
 # The one setting the formatter and the linter share. Ruff's own default is 88; this project reads better
```

</details>

<a id="step-05b-tests-system-test_real_model.py-df0b9d-diff"></a>

<details><summary>The diff of <code>tests/system/test_real_model.py</code></summary>

```diff
@@ -0,0 +1,27 @@
+"""The smoke on the real model: the one test here that is not hermetic.
+
+Every test under `tests/unit/` needs nothing but our code: the tiny model is built in memory, with
+random weights. This one loads Qwen2.5-0.5B from the Hugging Face Hub (953 MB the first time, from
+the cache after that) onto the best device the machine has. The network, the download and the
+device can each make it fail, so it is marked `system` and runs only when asked for:
+`just test -m system`. It asserts what is true on any device: the model answers every question.
+"""
+
+import pytest
+
+from babykev.smoke import main
+
+pytestmark = pytest.mark.system
+
+
+def test_the_real_model_answers_every_sample_question(
+    capsys: pytest.CaptureFixture[str],  # What the smoke prints
+) -> None:
+    """Five requests of three questions: fifteen verdicts, a count of those right, exit code 0."""
+    assert main([]) == 0
+    printed = capsys.readouterr().out.splitlines()
+    assert printed[0].startswith("babykev smoke: Qwen/Qwen2.5-0.5B on ")
+    verdicts = [line for line in printed if line.startswith(("  ok", "  --"))]
+    assert len(verdicts) == 15
+    right = sum(line.startswith("  ok") for line in verdicts)
+    assert f"{right} of 15 right" in "\n".join(printed)
```

</details>

[This change on GitHub](https://github.com/rahuldave/babykev/compare/c954af4beae61eaab89bcb2d4724eea4f2706703...47b43c0916ac186e3efdf42e15dbcf1f04edb1a0).

This part ends at the code at `step-05b`. [The code after this part](https://github.com/rahuldave/babykev/tree/step-05b)
