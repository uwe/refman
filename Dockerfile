# docker build -t refman . && docker stop refman && docker rm refman && docker run -d -p 127.0.0.1:8013:8080 --link mysql:mysql --name refman refman

FROM phusion/baseimage

RUN apt-get update -y
RUN apt-get install -y build-essential perl libmysqlclient-dev unzip
RUN curl -L http://cpanmin.us | perl - App::cpanminus

WORKDIR /home/app
ADD cpanfile /home/app/
RUN cpanm --notest --installdeps .

ADD . /home/app

# ADD crontab /etc/cron.d/refman

RUN mkdir /etc/service/hypnotoad
ADD hypnotoad.sh /etc/service/hypnotoad/run

CMD ["/sbin/my_init"]
