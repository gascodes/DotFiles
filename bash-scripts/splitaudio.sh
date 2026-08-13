#!/bin/bash

# Split into equal 10-minute (600) chunks

split_opus_to_mp3() {
    local input="$1"
    local output="${2:-part}"

    ffmpeg -i "$input" \
        -f segment \
        -segment_time 600 \
        -c:a libmp3lame \
        -b:a 192k \
        "${output}_%03d.mp3"
}

# How to run
# split_opus_to_mp3 "input.opus"

# You can also specify the output prefix:
# split_opus_to_mp3 "input.opus" "audio"
# → audio_000.mp3 audio_001.mp3 audio_002.mp3
