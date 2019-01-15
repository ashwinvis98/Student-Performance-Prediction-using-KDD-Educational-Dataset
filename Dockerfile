# Use the official OpenCPU Dockerfile as a base
FROM opencpu/base

# Put a copy of our R code into the container
WORKDIR /tmp
RUN mkdir webapp
COPY . /tmp/webapp

# Run our custom install script to install R dependencies
RUN apt-get install libssl-dev
RUN apt-get install libsasl2-dev
RUN R -e "install.packages(c('plyr','jsonlite','mongolite','rpart'))"

# Install our code as an R package on the server
RUN R CMD INSTALL /tmp/webapp/kdd_0.0.0.9000.tar.gz


