# Memory Limit Test

This project contains scripts and Docker configurations to test memory usage and sorting performance using Python and Docker.

## Project Structure

- `Dockerfile.ubuntu20`: Dockerfile for building the Docker image based on Ubuntu 20.04.
- `Dockerfile.ubuntu22`: Dockerfile for building the Docker image based on Ubuntu 22.04.
- `docker-compose.yml`: Docker Compose configuration file to manage and run multiple Docker containers.
- `sorter.py`: Python script to run a sort command on a specified input file and log memory usage and execution time.
- `output.txt`: Sample input file with data to be sorted.

## Prerequisites

- Docker
- Docker Compose
- Python 3.x

## Setup

1. **Clone the Repository**:
   ```sh
   git clone git@github.com:kraghavan/memoryLimitTest.git
   cd memoryLimitTest