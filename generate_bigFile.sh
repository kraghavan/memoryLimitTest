#!/bin/bash

lines=15000000
#lines=10
output_file=${1:-output.txt}

generate_random_string () {
    cat /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1 | cut -c -$1
}

# Overwrite the file at the beginning
> $output_file

for i in $(seq 1 $lines)
do
    alphanumeric_7=$(generate_random_string 7)
    alphanumeric_4=$(generate_random_string 4)
    alphanumeric_5=$(generate_random_string 5)
    alphanumeric_3=$(generate_random_string 3)
    echo "${alphanumeric_7}:${alphanumeric_4}:${alphanumeric_5}:${alphanumeric_3}" >> $output_file
    if (( i % 1000000 == 0 )); then
        echo "$i records written"
    fi
done