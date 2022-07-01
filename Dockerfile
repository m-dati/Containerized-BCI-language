
FROM registry.suse.com/bci/python:3.10
RUN mkdir /home/shared
WORKDIR   /home/shared
RUN mkdir -p etc src bin out
RUN chmod 775 etc src bin out
COPY setup/config.container.sh etc
RUN chmod 775 etc/config.container.sh
RUN etc/config.container.sh python 3.10 python3 
EXPOSE 58123

