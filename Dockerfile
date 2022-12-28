FROM alpine

# Upgrade existing packages in the base image
RUN apk --no-cache upgrade

# Install apache from packages with out caching install files
RUN apk add --no-cache apache2

# Copy index.html to docroot
COPY index.html /var/www/html

# Create directory for apache2 to store PID file
RUN mkdir /run/apache2

# Open port for httpd access
EXPOSE 80

# Run httpd in foreground so that the container does not quit soon after start
CMD ["-D","FOREGROUND"]

# Start httpd when container runs
#ENTRYPOINT ["/usr/sbin/httpd"]
ENTRYPOINT [ "/usr/bin/apache2ctl" ]