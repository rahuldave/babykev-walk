## The site, from the same text

- `just docs` builds the site into `docs/_site`, with smalldocs
- Each build writes the reference pages from the code first. git ignores what the build makes
- A front page, written by hand, says what the project is
- A name in backticks, such as `to_answers`, becomes a link to its entry

---

## What the build makes

- `just docs` prints `wrote 3 page(s) to docs/_site`, the front page and one page for each module
- `docs/_symbols.json` maps 24 names to their entries, a short and a full name for each
- `git status --short --ignored docs` marks `docs/_site/`, `docs/api/` and `docs/_symbols.json` with `!!`. Three lines
  of `.gitignore` name them, because each build makes them again
