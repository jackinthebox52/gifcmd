#!/bin/bash

## A simple script to create a gif from a video file using ffmpeg
## Author: jackinthebox52
##
## Usage: gifcmd.sh -s <start> -d <duration> -i <input> (Optional:) <output>
## Example: gifcmd.sh -s 1:15 -d 5 -i /path/to/video.mp4 /path/to/output/clip.gif
## Note: Output file is optional, and should be the last parameter.
## Start should be of format: hh:mm:ss, mm:ss, or ss. Duration should be of format: ss.
## Width of the gif is set to 720px, and height is set to maintain aspect ratio. These can be changed in the script (ffmpeg command).


current_time=$(date +%s)

while getopts ":s:d:i:" flag; do
    case $flag in
        s)
            seconds=$OPTARG
        ;;
        d)
            duration=$OPTARG
        ;;
        i)
            filepath=$OPTARG
        ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
        ;;
    esac
done

shift $((OPTIND -1))
output=$1

if [[ -z $seconds || -z $duration || -z $filepath ]]; then
    echo "Usage: gifcmd.sh -s <start> -d <duration> -i <input> (Optional:) <output>" >&2
    echo "Example: gifcmd.sh -s 1:15 -d 5 -i /path/to/video.mp4 /path/to/output/clip.gif" >&2
    echo "Note: Output file is optional, and should be the last parameter." >&2
    echo "Start should be of format: hh:mm:ss, mm:ss, or ss. Duration should be of format: ss." >&2
    exit 1
fi

#if s flag is of fomat hh:mm:ss or mm:ssm convert it to seconds, else, check if it's a number, else exit with error message
if [[ $seconds =~ ^[0-9]+:[0-9]+:[0-9]+$ ]]; then
    seconds=$(echo $seconds | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
    elif [[ $seconds =~ ^[0-9]+:[0-9]+$ ]]; then
    seconds=$(echo $seconds | awk -F: '{ print ($1 * 60) + $2 }')
fi

if [[ ! $seconds =~ ^[0-9]+$ ]]; then
    echo "Invalid start time. Please provide a valid number of seconds." >&2
    exit 1
fi

if [[ ! $duration =~ ^[0-9]+$ ]]; then
    echo "Invalid duration. Please provide a valid number of seconds." >&2
    exit 1
fi

if [[ ! -f $filepath || ! -r $filepath || ! $filepath =~ \.(mp4|avi|mkv|mov|flv|wmv|webm)$ ]]; then
    echo "Invalid input file (Extension is not video type, or file not found/accessible.)" >&2
    exit 1
fi

filename=$(basename $filepath)
filename="${filename%.*}"

if [[ -n $output ]]; then
    if [[ $output != *.gif ]]; then
        echo "Invalid output file extension. Please provide a .gif file." >&2
        exit 1
    fi
    filename=${output%.gif}
fi

ffmpeg -y -ss $seconds -t $duration -i $filepath -filter_complex "[0:v] fps=15,scale=720:-1" $filename.gif > /dev/null 2>&1

echo "Gif created successfully: $filename.gif, in $(( $(date +%s) - $current_time )) seconds."
exit 0
