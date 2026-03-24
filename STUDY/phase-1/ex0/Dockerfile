FROM ubuntu:latest

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

CMD ["sleep", "infinity"]

# docker build -it ex0

# docker run -d --name ubuntu-bg ex0

# docker stop "container_name_or_id"

# docker rm -f ex0