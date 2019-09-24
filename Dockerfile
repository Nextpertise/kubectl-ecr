FROM debian:buster

ADD kubectl /usr/local/bin
RUN chmod 755 /usr/local/bin/kubectl

ADD do.sh /do.sh
RUN chmod 755 /do.sh 

RUN apt-get update && apt-get install --no-install-recommends -y \
    python-pip jq
RUN pip install setuptools
RUN pip install wheel
RUN pip install awscli

CMD ["bash"]
