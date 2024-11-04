
#!/bin/bash

for i in {1..50}; do echo "Running iteration $i"; docker-compose run sorter-u20; done

for i in {1..50}; do echo "Running iteration $i"; docker-compose run sorter-u22; done