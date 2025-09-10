#! /bin/bash

frame_dir='./fig/output'
output_dir='./fig/animation'
mkdir -p $output_dir
ffmpeg -framerate 10 -i "${frame_dir}/output_%04d.png" -vcodec libx264 -pix_fmt yuv420p "${output_dir}/output.mp4"