#!/usr/bin/env bash
#
# gen.sh - generate PowerPoint slides from Markdown sources.
#
# Usage:
#   ./gen.sh                         # convert every <Parsha>/Slides/*.md in the repo
#   ./gen.sh Vayishlach/Slides/05.md # convert one file
#   ./gen.sh Vayishlach/Slides        # convert every *.md in that directory
#   ./gen.sh -o build Vayishlach/Slides/05.md
#
# Options:
#   -t TEMPLATE   slide template passed to md2pptx.py (default: ES)
#   -o OUTDIR     write the .pptx files here (default: next to the .md)
#   -h            show this help
#
# The conversion itself is done by the Elephant Scale tool
# $ES_HOME/utils/presentations/md2pptx.py, which expects reveal-style Markdown:
# "# Title" for a section/cover slide, "## Heading" for a content slide,
# "---" between slides, bullets as "* item", and an optional "Notes:" block
# at the end of a slide for speaker notes.

set -euo pipefail

TEMPLATE="ES"
OUTDIR=""

usage() { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; }

while getopts ":t:o:h" opt; do
    case "$opt" in
        t) TEMPLATE="$OPTARG" ;;
        o) OUTDIR="$OPTARG" ;;
        h) usage; exit 0 ;;
        \?) echo "unknown option: -$OPTARG" >&2; usage >&2; exit 1 ;;
        :)  echo "option -$OPTARG needs an argument" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- locate the Elephant Scale md -> pptx converter -------------------------
ES_HOME="${ES_HOME:-/media/mark/data1/ES}"
MD2PPTX="$ES_HOME/utils/presentations/md2pptx.py"
if [ ! -f "$MD2PPTX" ]; then
    echo "error: md2pptx.py not found at $MD2PPTX" >&2
    echo "       set ES_HOME to your ES checkout (e.g. export ES_HOME=/media/mark/data1/ES)" >&2
    exit 1
fi

PYTHON="${PYTHON:-python3}"
command -v "$PYTHON" >/dev/null 2>&1 || PYTHON=python
if ! "$PYTHON" -c "import pptx, mistletoe, pygments, PIL, pylab" 2>/dev/null; then
    echo "error: missing Python dependencies for md2pptx.py" >&2
    echo "       pip install python-pptx mistletoe pygments Pillow matplotlib" >&2
    exit 1
fi

# --- build the list of Markdown files to convert ----------------------------
declare -a SOURCES=()
if [ "$#" -eq 0 ]; then
    # Default: every slide deck in the repo, i.e. <Parsha>/Slides/*.md
    while IFS= read -r -d '' f; do SOURCES+=("$f"); done \
        < <(find "$REPO_DIR" -type d -name .git -prune -o \
                 -type f -name '*.md' -path '*/Slides/*' -print0 | sort -z)
    if [ "${#SOURCES[@]}" -eq 0 ]; then
        echo "no */Slides/*.md files found under $REPO_DIR" >&2
        exit 1
    fi
else
    for arg in "$@"; do
        if [ -d "$arg" ]; then
            while IFS= read -r -d '' f; do SOURCES+=("$f"); done \
                < <(find "$arg" -maxdepth 1 -type f -name '*.md' -print0 | sort -z)
        elif [ -f "$arg" ]; then
            SOURCES+=("$arg")
        else
            echo "error: no such file or directory: $arg" >&2
            exit 1
        fi
    done
fi

# --- convert ----------------------------------------------------------------
generated=0
for src in "${SOURCES[@]}"; do
    src_abs="$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"
    src_dir="$(dirname "$src_abs")"
    base="$(basename "${src_abs%.md}")"

    if [ -n "$OUTDIR" ]; then
        mkdir -p "$OUTDIR"
        out_dir="$(cd "$OUTDIR" && pwd)"
    else
        out_dir="$src_dir"
    fi
    out_abs="$out_dir/$base.pptx"

    echo "==> $src_abs"
    # Run from the source directory: md2pptx.py resolves images relative to the
    # Markdown file and drops scratch files (1.png, formula.png) in the cwd.
    ( cd "$src_dir" && "$PYTHON" "$MD2PPTX" -t "$TEMPLATE" -o "$out_abs" "$src_abs" )
    rm -f "$src_dir/1.png" "$src_dir/formula.png"

    if [ -f "$out_abs" ]; then
        echo "    wrote $out_abs"
        generated=$((generated + 1))
    else
        echo "    *** failed to produce $out_abs" >&2
        exit 1
    fi
done

echo "generated $generated presentation(s)"
