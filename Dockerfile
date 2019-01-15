FROM opencpu/base

WORKDIR /tmp
RUN mkdir webapp
COPY . /tmp/webapp
RUN apt-get install libssl-dev
RUN apt-get install libsasl2-dev
RUN R -e "install.packages(c('plyr','jsonlite','mongolite','rpart'))"

RUN R CMD INSTALL /tmp/webapp/kdd_0.0.0.9000.tar.gz


