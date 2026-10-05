## What a person had to do

36 fixes the tools could not make:

- a one-line docstring on every class and function
- the missing types: on test arguments, on returns
- names a reader can say: `K` and `L` became `k` and `n`
- one more test, for a score with a single level

Result: 53 tests, coverage 100%, 0 findings.

---

## `just check`: everything a commit must pass

```
just fmt --check
just lint
just test -q --cov-fail-under=90
just lint-config
```

- Coverage below 90% fails the check
- `just lint-config` checks the files that are not Python: every YAML file, `pyproject.toml`, the lockfile against it, and the justfile's own format

---

## pre-commit: the checks run themselves

- A git hook runs before every commit, and refuses the commit if a check fails
- **The hook runs `just check`.** The hook and your terminal run the same thing
- Two more hooks refuse a file over 1 MB and a `.env` file
- `just setup` installs the hook, so nobody has to remember

A commit that fails the check does not happen.
