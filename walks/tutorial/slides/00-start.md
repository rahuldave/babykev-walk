<h1 style="text-align: center">SOFTWARE DEVELOPMENT</h1>
<h1 style="text-align: center">FOR</h1>
<h1 style="text-align: center">MACHINE LEARNING</h1>

<div style="text-align: center">

## *Rahul Dave*

</div>

---

<img src="pictures/pavlos-worried.png" alt="Pavlos, the cartoon, worried, with a hand raised" style="max-height: 480px; object-position: center top">

---

<img src="pictures/rahul.jpg" alt="Rahul, in a T-shirt that says You're Absolutely Right!" style="max-height: 480px; object-position: center top">

---

## The parts of a machine-learning project

| | |
|---|---|
| Design | <u>Setup</u>, Product, <u>Systems</u> |
| Data | Preparation, Exploration, Preprocessing, Distributed |
| Model | Training, Tracking, Tuning, Evaluation, Serving |
| <u>Developing</u> | <u>Scripting</u>, <u>CLI</u> |
| Utilities | Logging, <u>Documentation</u>, <u>Styling</u>, <u>Pre-commit</u> |
| <u>Testing</u> | <u>Code</u>, Data, <u>Models</u> |
| Reproducibility | <u>Versioning</u> |
| Production | <u>Jobs & Services</u>, <u>CI/CD workflows</u>, Monitoring, Data engineering |

The table has 26 parts. The rows Data and Model hold nine of them, and the rest are engineering.

---

## The ML code is a small box

<img src="pictures/memes/ml-system-elements.png" alt="The ML code is a small box among data collection, configuration, serving, monitoring and more" style="max-height: 480px; max-width: 100%">

Google Cloud, *MLOps: continuous delivery and automation pipelines in machine learning*, after Sculley et al., *Hidden technical debt in machine learning systems*, NeurIPS 2015

---

## The parts of a software project

| | |
|---|---|
| Source | Version control, Code review |
| Environment | <u>One known Python</u>, <u>every dependency pinned</u>, <u>one way to run anything</u> |
| Code | <u>A package</u>, <u>a command-line interface</u>, <u>types</u>, <u>docstrings</u> |
| Quality | <u>Formatting</u>, <u>linting</u>, <u>type checking</u> |
| Tests | <u>Unit tests</u>, <u>property tests</u>, <u>integration tests</u>, <u>system tests</u>, <u>coverage</u> |
| Documentation | <u>Reference built from code</u>, <u>guides</u>, <u>a site</u> |
| Automation | <u>Hooks on dev</u>, <u>continuous integration</u>, <u>builds</u> |
| Shipping | <u>Containers</u>, packaging for others, releases, deployment |
| Running | Logging, monitoring, someone on call |

A machine-learning project is a software project with a model and data in it.

---

## The steps of the tutorial

| Step | What it adds | Tools |
|---|---|---|
| tut-01 | The project, its command and its justfile | **uv**, **just** |
| tut-02 | The contract of the model, and its unit tests | **pydantic**, **pytest**, **pytest-cov** |
| tut-03 | Format and lint | **ruff** |
| tut-04 | `just check`, and a git hook that runs it | **pre-commit**, **yamllint**, **validate-pyproject** |
| tut-05 | Documentation from the code | **smalldocs** |
| tut-06 | The model, and a smoke run on the real model | **torch**, **transformers**, **peft**, **ty** |
| tut-07 | The tests of the model | **hypothesis** |
| tut-08 | Two images from one lockfile | **Docker**, **hadolint** |
| tut-09 | The checks on GitHub, and the docs on Pages | **GitHub Actions** |

---

# babykev

A small model that makes decisions, and the project built around it.

- The model comes from kev, by Jared Palmer.
- We start from the first commit of kev. It has about 830 lines that work, one test that needs a running server, no types and no docs.
- We build the project again in steps, and bring in the files of kev one at a time.
- Each step brings a new tool. We learn about the tool, and we run it.
- Each tool gets a recipe in the justfile, so the project has one interface.

---

## The second example: the cheese app

<img src="pictures/cheese-app-ci-cd-qr.svg" width="300" alt="QR code for github.com/dlops-io/cheese-app-ci-cd">

[github.com/dlops-io/cheese-app-ci-cd](https://github.com/dlops-io/cheese-app-ci-cd)

A FastAPI app with linters, formatters, tests and pre-commit hooks. It uses Docker in every step.

---

## One request, one answer

```yaml
state: "Roquefort is a semi-soft, blue-veined cheese from France. It tastes sharp, tangy and salty."
questions:
  milk:       {type: choice, criteria: {cow: …, goat: …, sheep: …, buffalo: …, mixed: …}}
  vegetarian: {type: noul}      # yes or no
  intensity:  {type: score, criteria: [mild, medium, pronounced, strong]}
```

```yaml
milk:       {choice: sheep, confidence: 0.81}
vegetarian: {noul: 0.08}
intensity:  {score: 2.7}
```

The state is the text that the questions are about. It is also called the context. The model gives a probability
for every option, and generates no text.

---

## A model that decides

![A request is packed into one sequence, read by a small language model, and scored by a pointer head](pictures/decision-model.svg)

The model reads all the questions in one sequence. A mask keeps each question from seeing the others.

---

## You install two tools, and the project installs the rest

| Tool | For |
|---|---|
| **uv** | Python itself, every dependency, running the program |
| **just** | The recipes of the project. `just` lists them |

The lockfile names everything else, for example pydantic, pytest, ruff, smalldocs and torch. `just setup` installs
it.

---

## The files of kev, one at a time

| File in the first commit of kev | Lines | What it does | Arrives at |
|---|---|---|---|
| `api.py` | 111 | The contract: what a request and an answer look like | tut-02 |
| `model.py` | 101 | Packing, the mask, the pointer head | tut-06 |
| `data.py`, `train.py`, `evaluate.py` | 446 | Training records, the loop, accuracy and calibration | The class on training |
| `serve.py` | 170 | Inference | The class on CI/CD with GitHub Actions |
