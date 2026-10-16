## The gate, on GitHub

- The hook runs the gate on the machine that makes a commit. A clone with no hook makes commits that never met it
- GitHub runs a workflow on its own machines, after the events that the key `on` names
- A workflow is a file of YAML in `.github/workflows/`
- The docs site is on one machine only. A second workflow publishes it on GitHub Pages

---

## `check.yaml`: the gate after every push

```yaml
on:
  push:
    branches: ["**"]  # every branch, and no tag
  pull_request:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: astral-sh/setup-uv@v10.2.0
      - uses: extractions/setup-just@v4
      - run: just setup
      - run: just check
```

- yamllint warns on `on`, which YAML 1.1 reads as true. `truthy: {check-keys: false}` lets a key be such a word

---

## `docs.yaml`: the docs on Pages

```yaml
      - run: uv run --locked --no-default-groups --group docs smalldocs render docs
      - uses: actions/upload-pages-artifact@v5
        with:
          path: docs/_site
```

- It runs after a push to `main`, and from the tab Actions
- It installs the package and the group `docs`, and no other group
- actionlint checks both workflows, in `just lint-config`
- A fork turns on its workflows on the tab **Actions**, and chooses **GitHub Actions** as the source of **Pages**
