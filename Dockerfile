FROM makocchi/kmlinters:0.2.0

COPY entrypoint.sh /entrypoint.sh

WORKDIR /work

ENTRYPOINT ["/entrypoint.sh"]
