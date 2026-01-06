#!/bin/bash

# Use 'read -e' to enable Readline (Tab-completion)
read -e -p "Enter input video: " VIDEO_IN
read -e -p "Enter overlay image: " IMAGE_IN
read -e -p "Enter output name: " OUTPUT_FILE

ffmpeg -i "$VIDEO_IN" -i "$IMAGE_IN" \
-filter_complex "[0:v][1:v] overlay=0:0" \
-c:a copy \
"$OUTPUT_FILE"

