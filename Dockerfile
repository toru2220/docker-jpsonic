FROM alpine:3.6

LABEL description="Jpsonic is a free, web-based media streamer, providing ubiquitious access to your music." \
      url="https://github.com/tesshucom/jpsonic"

ENV JPSONIC_PORT=4040 JPSONIC_DIR=/jpsonic CONTEXT_PATH=/jpsonic

WORKDIR $JPSONIC_DIR

RUN apk --no-cache add \
    ffmpeg \
    lame \
    bash \
    libressl \
    fontconfig \
    ttf-dejavu \
    ca-certificates \
    tini \
    curl \
    openjdk8-jre \
    wget

COPY run.sh /usr/local/bin/run.sh

ENV JPSONIC_VERSOPN 2.2.6

RUN chmod +x /usr/local/bin/run.sh

RUN wget -O jpsonic.war https://github.com/tesshucom/jpsonic/releases/download/v$JPSONIC_VERSOPN/jpsonic.war

EXPOSE $JPSONIC_PORT

VOLUME $JPSONIC_DIR/data $JPSONIC_DIR/music $JPSONIC_DIR/playlists $JPSONIC_DIR/podcasts

HEALTHCHECK --interval=15s --timeout=3s CMD wget -q http://localhost:"$JPSONIC_PORT""$CONTEXT_PATH"rest/ping -O /dev/null || exit 1

ENTRYPOINT ["tini", "--", "run.sh"]
