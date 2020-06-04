FROM makocchi/kmlinters:0.1.1

COPY entrypoint.sh /entrypoint.sh

WORKDIR /work

ENTRYPOINT ["/entrypoint.sh"]
