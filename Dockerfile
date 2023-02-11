##docker build -f nginxdocker  -t ng390 .
##$ docker run --name ng390-xx -d -p 8090:8090  ng390 
FROM nginx:stable

RUN apt update -y && apt install -y procps && apt-get -qq -y install curl wget inetutils-ping net-tools sysstat 
RUN mkdir -p /etc/nginx/ssl 
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt  -passout pass:foobar \
  -subj "/C=US/ST=Test/L=Test/O=Test/CN=localhost"
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.orig
COPY default.conf     /etc/nginx/conf.d/default.conf
# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8090
EXPOSE 44390
# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
###disable access log 'access_log  /var/log/nginx/access.log  main;''
RUN sed -i.bak 's/access_log\(.*\) main;/access_log  off;/'  /etc/nginx/nginx.conf
RUN cd /usr/share/nginx/html/ && dd if=/dev/zero of=1b.bin bs=c count=1 && dd if=/dev/zero of=1kb.bin bs=1kB count=1 \
    && dd if=/dev/zero of=10kb.bin bs=1kB count=10 && dd if=/dev/zero of=100kb.bin bs=1kB count=100 
RUN chmod 777 /etc/nginx/conf.d/default.conf
RUN chmod 755 /etc/nginx/ssl/nginx.key
RUN chmod 755 /etc/nginx/ssl/nginx.crt
