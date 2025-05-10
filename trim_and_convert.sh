#!/bin/bash

vname="Diving"
time_start=(30 31 32 33 34 35 36 37 38 39)

mkdir -p "$vname"
cd "$vname" || exit 1

for time in "${time_start[@]}"; do
    timestamp=$(printf "00:00:%02d.0" "$time")
    output_file="${vname}_${time}.mp4"
    ffmpeg -ss "$timestamp" -i "../${vname}.mkv" -t 1 -c copy "$output_file"
done

mkdir -p yuv_file
for file in *.mp4; do
    base_name="${file%.*}"
    ffmpeg -y -i "$file" -pix_fmt yuv420p "yuv_file/${base_name}.yuv"
done
