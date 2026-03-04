#!/bin/bash
#SBATCH --job-name=regex_game
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G

REGEX="$1"
FASTQ="/common/workshop_data/raw_data/SRR1039508_1.fastq"
HIGHSCORE="/playground/highscore_string.txt"
LOCKFILE="/playground/.lockfile"

# Count matches only in sequence lines
COUNT=$(awk 'NR%4==2' "$FASTQ" | grep -E "$REGEX" | wc -l)

# Metadata
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
USER_NAME=$(whoami)
GROUP_NAME=$(id -gn)

ENTRY="$COUNT | $TIMESTAMP | $USER_NAME | $GROUP_NAME | $REGEX"

# Critical section (prevent race conditions)
(
  flock -x 200

  echo "$ENTRY" >> "$HIGHSCORE"
  sort -t'|' -k1,1nr "$HIGHSCORE" -o "$HIGHSCORE"

) 200>"$LOCKFILE"

echo "Your score: $COUNT"
echo "Current Top 5:"
head -5 "$HIGHSCORE"
