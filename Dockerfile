FROM ubuntu
USER root

# install jq to parse json within bash scripts
RUN apt-get -y -qq update && apt-get install -y jq && apt-get clean
# install sendmail util
RUN apt-get update && apt-get install -y sendemail libio-socket-ssl-perl ca-certificates && apt-get clean && rm -r /var/lib/apt/lists/*

RUN mkdir -p /home/app
COPY get-pr.sh /home/app
CMD /home/app/get-pr.sh
