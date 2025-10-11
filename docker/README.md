# Compiling this uniGUI app into a Docker container

Make the proper directory structure:
```
- ./etc/fmsoft           dir   # contains required uniGUI assets
- ./opt/FrontDCC         file  # uniGUI app binary file
- ./Dockerfile           file  # Dockerfile
- ./docker-build.sh      file  # Docker build script
- ./docker-run.sh        file  # Docker run script
```

Next: 
```bash
./docker-build.sh
./docker-run.sh           # to run as a daemon
```
