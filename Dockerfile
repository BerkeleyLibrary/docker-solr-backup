FROM alpine 

RUN apk --update upgrade && \
    apk add \
        bash \
        curl \
        jq

COPY backup-cores.sh /usr/local/bin/backup-cores.sh

ENTRYPOINT [ "/usr/local/bin/backup-cores.sh" ]
CMD [ "http://localhost:8983" ]
