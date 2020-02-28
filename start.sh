#!/bin/bash -x
pwd
sed -E 's/^/DB_PASSWORD=/;s/$/\n/' < /etc/app/DB_PASSWORD >> /var/www/html/.env
sed -E 's/^/DB_USERNAME=/;s/$/\n/' < /etc/app/DB_USERNAME >> /var/www/html/.env
# start all the services
/usr/bin/supervisord -c /etc/supervisor/conf.d/apache.conf -n