#!/bin/bash

# This script generates a large file containing random alphanumeric strings.
# It uses multiple threads to speed up the generation process. Each line in the
# output file consists of four random alphanumeric strings separated by colons.

# Usage:
# ./generate_bigFile_mt2.sh [output_file]

# Parameters:
# - output_file: (Optional) The name of the output file. If not provided, the default is 'output.txt'.

# Example:
# To generate 5 million lines using 16 threads and save the output to 'output.txt':
# ./generate_bigFile_mt2.sh output.txt

# Ensure that GNU Parallel is installed on your system. You can install it using Homebrew on macOS:
# brew install parallel

# Adjust the 'lines', 'num_threads', and 'chunks' variables as needed to suit your requirements.

lines=5000000
chunks=500000  # Number of records after which to print progress

output_file=${1:-output.txt}
num_threads=16  # Adjust the number of threads as needed
# num_threads=$(nproc)  # Set the number of threads based on the number of CPU cores

generate_random_string () {
    local length=$1
    openssl rand -base64 $((length * 3 / 4)) | tr -dc 'a-zA-Z0-9' | head -c $length
}

generate_lines() {
    local thread_id=$1
    local lines_per_thread=$2
    local chunks=$3
    local temp_file="temp_output_${thread_id}.txt"
    
    for ((i=1; i<=lines_per_thread; i++))
    do
        alphanumeric_7=$(generate_random_string 7)
        alphanumeric_4=$(generate_random_string 4)
        alphanumeric_5=$(generate_random_string 5)
        alphanumeric_3=$(generate_random_string 3)
        echo "${alphanumeric_7}:${alphanumeric_4}:${alphanumeric_5}:${alphanumeric_3}" >> $temp_file
        
        if (( i % chunks == 0 )); then
            echo "Thread $thread_id: $i records written"
        fi
    done
}

export -f generate_random_string
export -f generate_lines

lines_per_thread=$((lines / num_threads))
remaining_lines=$((lines % num_threads))

echo "Total lines: $lines"
echo "Lines per thread: $lines_per_thread"
echo "Remaining lines: $remaining_lines"

# Run parallel tasks and write to temporary files
parallel -j $num_threads generate_lines {#} $lines_per_thread $chunks ::: $(seq 1 $num_threads)

# Handle remaining lines
if (( remaining_lines > 0 )); then
    generate_lines "remaining" $remaining_lines $chunks > temp_output_remaining.txt
fi

# Concatenate temporary files into the final output file
cat temp_output_*.txt > $output_file

# Remove temporary files
rm temp_output_*.txt