FROM php:8.2-fpm

# Install system packages
RUN apt-get update && apt-get install -y \
    nginx supervisor git unzip \
    && rm -rf /var/lib/apt/lists/*

# Clean the default web root (php image includes a default index)
RUN rm -rf /var/www/html/*

# Install LinkStack
RUN git clone https://github.com/LinkStackOrg/LinkStack.git /var/www/html

WORKDIR /var/www/html

# Copy example environment file
RUN cp .env.example .env

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

# Nginx configuration
COPY nginx.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Supervisor runs both services
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["supervisord", "-n"]
