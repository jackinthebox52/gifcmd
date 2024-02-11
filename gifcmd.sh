#!/bin/bash

## A simple script to create a gif from a video file using ffmpeg
## Author: jackinthebox52
##
## Usage: gifcmd.sh -s <start> -d <duration> -i <input> (Optional:) <output>
## Example: gifcmd.sh -s 10 -d 5 -i /path/to/video.mp4 /path/to/output/clip.gif
## Note: Output file is optional, and should be the last parameter.
## Start and duration should be in seconds.
 

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

#additionally, get a final optional parameter, with no flag letter assosciated, and save as variable output file
shift $((OPTIND -1))
output=$1

# Check if mandatory flags are present
if [[ -z $seconds || -z $duration || -z $filepath ]]; then
    echo "Usage: gifcmd.sh -s <start> -d <duration> -i <input> (Optional:) <output>" >&2
    echo "Example: gifcmd.sh -s 10 -d 5 -i /path/to/video.mp4 /path/to/output/clip.gif" >&2
    echo "Note: Output file is optional, and should be the last parameter." >&2
    echo "Start and duration should be in seconds." >&2
    exit 1
fi
# Check if seconds and duration are numbers
if [[ ! $seconds =~ ^[0-9]+$ || ! $duration =~ ^[0-9]+$ ]]; then
    echo "Invalid seconds or duration" >&2
    exit 1
fi

#Check if file exists, check if file is a video (by extension), check if user can read file
if [[ ! -f $filepath || ! -r $filepath || ! $filepath =~ \.(mp4|avi|mkv|mov|flv|wmv|webm)$ ]]; then
    echo "Invalid input file (Extension is not video, or file not found/accessible.)" >&2
    exit 1
fi

#Get the name of the file without extension
filename=$(basename $filepath)
filename="${filename%.*}"

# Check if output parameter is present, strip .gif from it
if [[ -n $output ]]; then
    if [[ $output != *.gif ]]; then
        echo "Invalid output file extension. Please provide a .gif file." >&2
        exit 1
    fi
    filename=${output%.gif}
fi


# Run ffmpeg command to create gif, using seconds as start time, duration as duration, fps=15, width=720, height=-1 and filename as output
ffmpeg -ss $seconds -t $duration -i $filepath -filter_complex "[0:v] fps=15,scale=720:-1" $filename.gif > /dev/null 2>&1

echo "Gif created successfully: $filename.gif"
exit 0
