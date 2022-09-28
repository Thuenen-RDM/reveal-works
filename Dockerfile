FROM node:latest

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    git clone https://github.com/hakimel/reveal.js.git

WORKDIR /reveal.js
RUN npm install
RUN mkdir -p presentation/assets

# The directory `presentation` is just populated to create the symlinks.
# When running the container, the working directory of the host is mounted
# onto (over) /reveal.js/presentation to allow live-editing.

# The `plugin`-directory is moved to the host in this manner too,
# because it is necessary for deploying the presentation as static
# website somewhere else.

RUN cp index.html demo.html presentation/ && \
    cp -a dist presentation/ && \
    cp -a plugin presentation/ && \
    rm index.html && rm demo.html && rm -rf dist && rm -rf plugin && \
    ln -s presentation/index.html ./index.html && \
    ln -s presentation/demo.html ./demo.html && \
    ln -s presentation/dist ./dist && \
    ln -s presentation/plugin ./plugin && \ 
    ln -s presentation/assets ./assets 

ENTRYPOINT ["/usr/local/bin/npm", "start", "--", "--host=0.0.0.0", "--port=8000"]

