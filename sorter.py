"""
sorter.py

This script runs a sort command on a specified input file and logs memory usage and execution time.
It supports parallel sorting based on the number of CPU cores available.

Usage:
    python -m memory_profiler sorter.py --logfile <logfile> --outputfile <outputfile> [--parallel]

Arguments:
    --logfile: Name of the log file (default: sorter.log)
    --outputfile: Name of the output file (default: output_sorted.txt)
    --parallel: Enable parallel sorting

Environment Variables:
    PARALLEL_SORT: Set to 'true' to enable parallel sorting

Functions:
    get_memory_usage(): Returns the current memory usage of the process in MB.
    sort_command(output_file, use_parallel): Runs the sort command with optional parallel sorting.
    run_sort_command(output_file, use_parallel): Profiles memory usage and execution time of the sort command.

Example:
    To run the script with parallel sorting enabled and custom log/output files:
    PARALLEL_SORT=true python -m memory_profiler sorter.py --logfile custom_log.log --outputfile custom_output.txt

Author:
    Your Name
"""

import os
import logging
from memory_profiler import profile, memory_usage
import time
from subprocess import run
import psutil
import argparse

# Set up argument parser
parser = argparse.ArgumentParser(description='Run sort command and log memory usage.')
parser.add_argument('--parallel', action='store_true', help='Enable parallel sorting')
args = parser.parse_args()

# Set up logging configuration
log_filename = os.getenv('LOG_FILE', 'sorter.log')
logging.basicConfig(
    filename=log_filename,
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

def get_memory_usage():
    process = psutil.Process(os.getpid())
    return process.memory_info().rss / (1024 * 1024)  # Convert bytes to MB

def sort_command(output_file, use_parallel):
    num_threads = os.cpu_count() if use_parallel else 1  # Get the number of CPU cores if parallel is enabled
    parallel_option = f"--parallel={num_threads}" if use_parallel else ""
    run(f"LC_ALL=C /usr/bin/sort {parallel_option} -us -t: -k1,1 -k2,2 -k3,3 output.txt -o {output_file}", shell=True)

@profile(stream=open(log_filename, 'a'))
def run_sort_command(output_file, use_parallel):
    # Record the start time
    start_time = time.time()

    # Profile memory usage during the sort command
    mem_usage = memory_usage((sort_command, (output_file, use_parallel)), interval=0.1, timeout=None)
    
    # Record the end time
    end_time = time.time()

    # Record memory usage after running the sort command
    memory_after = get_memory_usage()
    logger.info(f"Memory usage after running sort command: {memory_after:.2f} MB")

    # Log the time taken to run the sort command
    logger.info(f"Time taken to run the sort command: {end_time - start_time:.4f} seconds")

    # Log the memory usage during the sort command
    logger.info(f"Memory usage during sort command: {mem_usage}")

if __name__ == "__main__":
    logger.info("Starting the script")

    # Check if parallel sorting is enabled via environment variable
    use_parallel = os.getenv('PARALLEL_SORT', 'false').lower() == 'true'
    output_filename = os.getenv('OUTPUT_FILE', 'output_sorted.txt')

    logger.info(f"Parallel sorting enabled: {use_parallel}")
    logger.info(f"Output file: {output_filename}")
    logger.info(f"Log file: {log_filename}")
    # Run the sort command
    run_sort_command(output_filename, use_parallel)

    logger.info("Script finished")