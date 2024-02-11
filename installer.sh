# Description: Install gifcmd


#Tell the user to install ffmpeg if not installed, and make sure the user has a bin directory in their home directory, and that it is in their PATH
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg is not installed. Please install it before using this script." >&2
    exit 1
fi

if [ ! -d $HOME/bin ]; then
    echo "Creating ~/bin directory..."
    mkdir $HOME/bin
    echo "Make sure to add ~/bin to your PATH variable in your .bashrc or .zshrc file."
fi

#Copy the script to the bin directory, and make it executable
chmod +x gifcmd.sh
cp gifcmd.sh $HOME/bin/gifcmd
