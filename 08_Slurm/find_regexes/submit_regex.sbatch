#!/bin/bash
#SBATCH --job-name=regex_game
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --output=/playground/logs/regex_game_%u_%j.out
#SBATCH --error=/playground/logs/regex_game_%u_%j.err

REQUIRED_LENGTH=10

REGEX="$1"
FASTQ="/playground/filtered.fastq"
HIGHSCORE="/playground/highscore_regex.txt"
LOCKFILE="/playground/.lockfile"

if [[ -z "$REGEX" ]]; then
    echo "Error: You must provide a regex."
    exit 1
fi

# Enforce literal length
if [[ ${#REGEX} -ne $REQUIRED_LENGTH ]]; then
    echo "Error: Regex must be exactly $REQUIRED_LENGTH characters long."
    echo "You provided ${#REGEX} characters."
    exit 1
fi

# Count matches in sequence lines
COUNT=$(awk 'NR%4==2' "$FASTQ" | grep -E "$REGEX" | wc -l)

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
USER_NAME=$(whoami)
GROUP_NAME=$(id -gn)

ENTRY="$COUNT | $TIMESTAMP | $USER_NAME | $GROUP_NAME | $REGEX"

(
  flock -x 200
  echo "$ENTRY" >> "$HIGHSCORE"
  sort -t'|' -k1,1nr "$HIGHSCORE" -o "$HIGHSCORE"
) 200>"$LOCKFILE"

echo "Your score: $COUNT"
echo "Current Top 5:"
head -5 "$HIGHSCORE"