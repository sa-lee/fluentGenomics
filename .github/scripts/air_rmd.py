"""Format the R code chunks in R Markdown / Quarto files with Air.

Air only formats .R files, so this extracts each ```{r} chunk, pipes it
through `air format --stdin-file-path` (which applies the project's air.toml),
and writes the formatted code back in place. Prose, inline code and non-R
chunks are left untouched.

Usage: python air_rmd.py FILE [FILE ...]

Exits 1 if any chunk fails to parse (that chunk is left as is), else 0.
Run by the `air-format-rmd` hook in .pre-commit-config.yaml.
"""

import re
import subprocess
import sys
from pathlib import Path

# Opening fence of an R chunk: ```{r}, ```{r label, echo=FALSE}, ```{R} ...
CHUNK_START = re.compile(r"^(?P<indent>[ \t]*)(?P<fence>`{3,})\s*\{[rR](?:[\s,}])")


def format_code(code: str, source: Path) -> str | None:
    """Return Air-formatted code, or None if Air could not parse it."""
    # A .R stdin path next to the source file so Air finds the same air.toml.
    stdin_path = source.with_name(source.name + ".R")
    result = subprocess.run(
        ["air", "format", "--stdin-file-path", str(stdin_path)],
        input=code,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return None
    return result.stdout


def format_file(path: Path) -> bool:
    """Format the R chunks in `path` in place. Return False on parse errors."""
    lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
    out: list[str] = []
    ok = True
    i = 0
    while i < len(lines):
        line = lines[i]
        out.append(line)
        i += 1
        start = CHUNK_START.match(line)
        if not start:
            continue

        indent, fence = start["indent"], start["fence"]
        closing = re.compile(rf"^{re.escape(indent)}`{{{len(fence)},}}\s*$")
        body_start = i
        while i < len(lines) and not closing.match(lines[i]):
            i += 1
        if i == len(lines):  # unterminated chunk: leave the rest alone
            out.extend(lines[body_start:])
            break

        body = lines[body_start:i]
        if not "".join(body).strip():
            out.extend(body)
            continue

        # Chunks nested in lists are indented; strip that before formatting.
        dedented = [l[len(indent) :] if l.startswith(indent) else l for l in body]
        formatted = format_code("".join(dedented), path)
        if formatted is None:
            print(f"{path}:{body_start + 1}: air could not parse this chunk", file=sys.stderr)
            out.extend(body)
            ok = False
            continue

        out.extend(
            (indent + l if l.strip() else l)
            for l in formatted.splitlines(keepends=True)
        )

    new_text = "".join(out)
    if new_text != "".join(lines):
        path.write_text(new_text, encoding="utf-8")
    return ok


def main(argv: list[str]) -> int:
    results = [format_file(Path(p)) for p in argv]
    return 0 if all(results) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
