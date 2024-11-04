
docker build -t sorter-image-u20 -f Dockerfile.ubuntu20 .
docker run -v /Users/kraghavan/KarthikaRepo/PycharmProjects/memoryLimitTest:/home/kraghavan sorter-image-u20

docker build -t sorter-image-u22 -f Dockerfile.ubuntu20 .
docker run -v /Users/kraghavan/KarthikaRepo/PycharmProjects/memoryLimitTest://home/kraghavan sorter-image-u22