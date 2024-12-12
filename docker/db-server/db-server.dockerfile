## https://hub.docker.com/r/postgis/postgis
FROM postgis/postgis:16-3.4

RUN localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8
ENV LANG pt_BR.utf8
