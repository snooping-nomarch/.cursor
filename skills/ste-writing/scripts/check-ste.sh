#!/usr/bin/env bash
# Shows ASD-STE100 problems in Markdown and .mdc files.
# The script ignores the frontmatter, code blocks, table rows, and text in backticks.
# Exit code 1 means that the script found problems.
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <file> [<file> ...]" >&2
  exit 2
fi

ING_EXCEPTIONS="string thing nothing something anything bring spring during ceiling messaging naming snooping versioning routing warning"
STOP_LIST="ensure ensures utilize utilizes leverage leverages please"
MAX_WORDS=25

status=0
for file in "$@"; do
  if ! awk -v file="$file" -v ingExceptions="$ING_EXCEPTIONS" -v stopList="$STOP_LIST" -v maxWords="$MAX_WORDS" '
    BEGIN {
      split(ingExceptions, list, " "); for (i in list) ingAllowed[list[i]] = 1
      split(stopList, list, " "); for (i in list) stopWords[list[i]] = 1
      problems = 0; inFrontmatter = 0; inCode = 0
    }
    NR == 1 && /^---[[:space:]]*$/ { inFrontmatter = 1; next }
    inFrontmatter { if (/^---[[:space:]]*$/) inFrontmatter = 0; next }
    /^[[:space:]]*```/ { inCode = !inCode; next }
    inCode { next }
    /^[[:space:]]*\|/ { next }
    {
      text = $0
      gsub(/`[^`]*`/, "", text)
      gsub(/\]\([^)]*\)/, "]", text)
      sub(/^[[:space:]]*([-*]|[0-9]+\.)[[:space:]]+/, "", text)
      sub(/^#+[[:space:]]+/, "", text)

      lower = tolower(text)
      wordCount = split(lower, words, /[^a-z-]+/)
      for (i = 1; i <= wordCount; i++) {
        word = words[i]
        if (word ~ /ing$/ && length(word) > 4 && !(word in ingAllowed)) {
          printf "%s:%d: -ing form: %s\n", file, NR, word; problems++
        }
        if (word in stopWords) {
          printf "%s:%d: word not approved: %s\n", file, NR, word; problems++
        }
      }
      if (lower ~ /in order to/) {
        printf "%s:%d: word not approved: in order to\n", file, NR; problems++
      }

      sentenceCount = split(text, sentences, /[.!?]([[:space:]]+|$)/)
      for (i = 1; i <= sentenceCount; i++) {
        n = split(sentences[i], tokens, /[[:space:]]+/)
        realCount = 0
        for (j = 1; j <= n; j++) if (tokens[j] != "") realCount++
        if (realCount > maxWords) {
          printf "%s:%d: sentence has %d words (max %d)\n", file, NR, realCount, maxWords; problems++
        }
      }
    }
    END { exit problems > 0 ? 1 : 0 }
  ' "$file"; then
    status=1
  fi
done

exit "$status"
