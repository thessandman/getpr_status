FROM ubuntu
USER root
RUN apt-get -y -qq update && \
	apt-get install -y -qq curl && \
	apt-get clean
#
# install jq to parse json within bash scripts
RUN apt-get install -y jq
RUN apt-get update && apt-get install -y sendemail libio-socket-ssl-perl ca-certificates && apt-get clean && rm -r /var/lib/apt/lists/*    
#service postfix start && \
#RUN mkfifo /var/spool/postfix/public/pickup && \
#    service postfix restart 

RUN mkdir -p /home/app
COPY get-pr.sh /home/app

#RUN service postfix start
#RUN mkfifo /var/spool/postfix/public/pickup
#RUN service postfix restart

CMD /home/app/get-pr.sh
