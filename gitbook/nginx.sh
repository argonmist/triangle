#!/bin/bash
docker run --name gitbook-html -p 8090:80 -v $(pwd)/html:/usr/share/nginx/html -d nginx
