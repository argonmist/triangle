FROM node:6-slim

ARG VERSION=3.2.1

LABEL version=$VERSION

RUN npm install --global gitbook-cli &&\
	gitbook fetch ${VERSION} &&\
	npm cache clear &&\
	rm -rf /tmp/*

RUN sed -i 's@confirm: true@confirm: false@g' /root/.gitbook/versions/3.2.1/lib/output/website/copyPluginAssets.js

WORKDIR /srv/gitbook

VOLUME /srv/gitbook /srv/html

EXPOSE 4000 35729

CMD /usr/local/bin/gitbook serve
