FROM makocchi/kmlinters:0.1.0

COPY entrypoint.sh /entrypoint.sh

WORKDIR /work

ENTRYPOINT ["/entrypoint.sh"]
