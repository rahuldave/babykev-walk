# The walk through babykev: replay the class with timewalk. Run `just` to see the list.

timewalk := "../timewalk"
repo := "../babykev"

[private]
default:
    @just --list --unsorted

# Open the step browser on babykev with the script of each step. Prints the projector and presenter addresses
present *args:
    uv run {{ timewalk }}/timewalk.py {{ repo }} --notes walk.md --discard-edits {{ args }}
