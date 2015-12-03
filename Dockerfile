FROM ubuntu:14.04
MAINTAINER Dale-Kurt Murray "dalekurt.murray@gmail.com"

# Create environment variables for installation
#ENV SITE-NAME fms
#ENV UNIX-USER fms
#ENV HOST fms

RUN \
#  add-apt-repository -y ppa:nginx/stable && \
#  echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list && \
#  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8 && \
  apt-get -qq update && \
  DEBIAN_FRONTEND=noninteractive
#  rm -rf /var/lib/apt/lists/* && \


ADD . /var/www/fixmystreet/fixmystreet

WORKDIR /var/www/fixmystreet/fixmystreet

# Supervisor
RUN apt-get -qq install -y supervisor



# Language

RUN apt-get -qq install -y language-pack-en && \
  locale-gen en_US.UTF-8 && \
  echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
  echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale

ENV LANG en_US.UTF-8
ENV LC_ALL en_GB.UTF-8

# Fix for Arabic Language
# RUN sed -i '/ar__AR/d' /var/lib/locales/supported.d/local
#RUN \
  # locale-gen --purge && \
  # locale-gen ar && \
  #locale-gen fr_FR.UTF-8 && \
  #locale-gen es.UTF-8 && \
  #locale-gen ru.UTF-8

# Add user account
RUN \
  adduser --quiet --disabled-password --gecos "A user for the site fixmystreet" "fms" && \
  chown -R fms.fms /var/www/fixmystreet/

# Install debconf
RUN \
  apt-get -qq -y install debconf && \
  echo postfix postfix/main_mailer_type select 'Internet Site' | debconf-set-selections && \
  echo postfix postfix/mail_name string "fms" | debconf-set-selections

# Install postfix
RUN \ 
  echo postfix postfix/destinations string \
  "$(hostname --fqdn), localhost.localdomain, localhost" | debconf-set-selections && \
  apt-get -qq -y install postfix

# Install Nginx
RUN \
  apt-get install -y -qq nginx libfcgi-procmanager-perl

# Make log directory
RUN mkdir /var/www/fixmystreet/logs \
                && touch /var/www/fixmystreet/logs/access.log \
                && touch /var/www/fixmystreet/logs/error.log

# Install packages
RUN xargs -a conf/packages.ubuntu-precise apt-get install -y -q

# Install prerequisite Perl modules
RUN bin/install_perl_modules

# Install compass and generate CSS
RUN gem install --user-install --no-ri --no-rdoc bundler
RUN $(ruby -rubygems -e 'puts Gem.user_dir')/bin/bundle install --deployment --path ../gems --binstubs ../gem-bin
RUN bin/make_css

# setup config
#ADD conf/general.yml-default /var/www/fixmystreet/fixmystreet/conf/general.yml
ADD conf/general.yml-docker conf/general.yml

# Crontab
ADD conf/crontab-example /tmp/crontab
RUN sed -i \
        -e 's,$FMS,'"/var/www/fixmystreet/fixmystreet,g" \
        -e 's,$LOCK_DIR,'"/tmp,g" \
        -e 's,$UNIX_USER,'"fms,g" \
        "/tmp/crontab" \
	&& crontab /tmp/crontab

# Nginx configuration
ADD conf/nginx.conf.example /etc/nginx/sites-available/default
RUN sed -i "s/^.*listen 80.*$/    listen 80 default;/" /etc/nginx/sites-available/default
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf 

# FastCGI configuration
ADD conf/sysvinit.example /etc/init.d/fixmystreet
RUN \
  chmod a+rx /etc/init.d/fixmystreet && \
  update-rc.d fixmystreet start 20 2 3 4 5 . stop 20 0 1 6 .

# Copy shell script
ADD setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh
ADD pgpass /root/.pgpass
RUN chmod 0600 /root/.pgpass

# Supervisord to start fixmystreet
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/var/www/fixmystreet/fixmystreet"]

EXPOSE 80

# CMD ["nginx"]
CMD ["/usr/bin/supervisord"]
#	ENTRYPOINT ["/var/www/fixmystreet/fixmystreet/entrypoint.sh"]
