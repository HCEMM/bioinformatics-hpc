#!/bin/bash
#SBATCH --job-name=stringx_game
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G

### ---- HARD CODED LENGTH ----
REQUIRED_LENGTH=10
### ---------------------------

STRING="$1"
FASTQ="/common/workshop_data/raw_data/SRR1039508_1.fastq"
HIGHSCORE="/playground/highscore_string.txt"
LOCKFILE="/playground/.lockfile"

# Validate input exists
if [[ -z "$STRING" ]]; then
    echo "Error: You must provide a DNA string."
    exit 1
fi

# Enforce exact length
if [[ ${#STRING} -ne $REQUIRED_LENGTH ]]; then
    echo "Error: String must be exactly $REQUIRED_LENGTH characters long."
    exit 1
fi

# Allow only ACGT
if [[ ! "$STRING" =~ ^[ACGT]+$ ]]; then
    echo "Error: Only A, C, G, T allowed."
    exit 1
fi

# Count matches (literal search)
COUNT=$(awk 'NR%4==2' "$FASTQ" | grep -F "$STRING" | wc -l)

# Metadata
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
USER_NAME=$(whoami)
GROUP_NAME=$(id -gn)

ENTRY="$COUNT | $TIMESTAMP | $USER_NAME | $GROUP_NAME | $STRING"

# Critical section
(
  flock -x 200
  echo "$ENTRY" >> "$HIGHSCORE"
  sort -t'|' -k1,1nr "$HIGHSCORE" -o "$HIGHSCORE"
) 200>"$LOCKFILE"

echo "Your score: $COUNT"
echo "Current Top 5:"
head -5 "$HIGHSCORE"