#!/bin/bash

# 1. Prompt user for file paths
read -e -p "Enter input file path (e.g., input.mp4): " INPUT_FILE
read -e -p "Enter output file path (e.g., output.mp4): " OUTPUT_FILE

# 2. Prompt user for fade durations (in seconds)
read -e -p "Enter fade-in duration in seconds: " FADE_IN_DUR
read -e -p "Enter fade-out duration in seconds: " FADE_OUT_DUR

# 3. Automatically get total duration of the input file
# This uses ffprobe to find the exact length in seconds
DURATION=$(ffprobe -v error -show_entries format=duration -of default=nk=1:nw=1 "$INPUT_FILE")

# 4. Calculate when the fade-out should start (Total Duration - Fade Out Duration)
# We use 'bc' to handle decimal (floating point) math in the shell
FADE_OUT_START=$(bc -l <<< "$DURATION - $FADE_OUT_DUR")

# 5. Execute the FFmpeg command
# Note: Variables are wrapped in double quotes to handle file paths with spaces
ffmpeg -i "$INPUT_FILE" \
-vf "fade=t=in:st=0:d=$FADE_IN_DUR,fade=t=out:st=$FADE_OUT_START:d=$FADE_OUT_DUR" \
-af "afade=t=in:st=0:d=$FADE_IN_DUR,afade=t=out:st=$FADE_OUT_START:d=$FADE_OUT_DUR" \
"$OUTPUT_FILE"

echo "Processing complete! Saved to $OUTPUT_FILE"
