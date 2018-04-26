# FROM    python:3.6.4-slim
#
# RUN     apt-get -y update
# RUN     apt-get -y dist-upgrade
#
# RUN     apt-get -y install nginx supervisor
#
# # File copy
# COPY    . /srv/backend
# WORKDIR /srv/backend
# RUN     pip install -r requirements.txt
#
# # Copy Nginx conf
# RUN     rm -rf /etc/nginx/sites-enabled/*
# RUN     cp -f /srv/backend/.config/nginx-app.conf \
#            /etc/nginx/nginx.config
#
# # Copy Nginx appllication conf
# RUN     cp -f /srv/backend/.config/nginx-app.conf \
#             /etc/nginx/sites-available/
# RUN     ln -sf /etc/nginx/sites-available/nginx-app.conf \
#                /etc/nginx/sites-enabled/nginx-app.conf
#
# # Copy supervisor conf
# RUN     cp -f /srv/backend/.config/supervisord.conf \
#               /etc/supervisor/conf.d/
#
# # Stop Nginx, Run supervisord
# CMD     pkill nginx; supervisord -n
#
# # # Django runserver
# # WORKDIR /srv/backend/app
# # CMD     python manage.py runserver 0:8000;nginx
#
# EXPOSE  80


FROM		python:3.6.4-slim

RUN			apt-get -y update
RUN			apt-get -y dist-upgrade

RUN			apt-get -y install nginx supervisor
RUN     apt-get -y install git curl
RUN     curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN     apt-get -y install nodejs


# Backend File copy
COPY		. /srv/backend
WORKDIR		/srv/backend
RUN			pip install -r requirements.txt

# Frontend Settings
WORKDIR /srv
RUN     git clone https://github.com/Fastcampus-WPS-7th/MultiDeploy-Frontend.git frontend
WORKDIR /srv/frontend
RUN     npm install
RUN     npm run build


# Nginx settings
RUN			rm -rf /etc/nginx/sites-enabled/*
# Copy Nginx conf
RUN			cp -f /srv/backend/.config/nginx.conf \
			      /etc/nginx/nginx.conf
# Copy Nginx application conf
RUN			cp -f /srv/backend/.config/nginx-app.conf \
			      /etc/nginx/sites-available/
RUN			ln -sf /etc/nginx/sites-available/nginx-app.conf \
				   /etc/nginx/sites-enabled/nginx-app.conf

# Copy supervisor conf
RUN			cp -f /srv/backend/.config/supervisord.conf \
				  /etc/supervisor/conf.d/

# Stop Nginx, Run supervisor
CMD			pkill nginx; supervisord -n

EXPOSE		80
