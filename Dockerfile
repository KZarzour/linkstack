FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    nginx supervisor git unzip \
    && rm -rf /var/lib/apt/lists/*

# Remove default HTML directory completely to avoid clone conflicts
RUN rm -rf /var/www/html && mkdir -p /var/www/html

# Clone LinkStack
RUN git clone https://github.com/LinkStackOrg/LinkStack.git /var/www/html

WORKDIR /var/www/html

# Copy env
RUN cp .env.example .env

# Permissions
RUN chown -R www-data:www-data /var/www/html

# Nginx configuration
COPY nginx.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["supervisord", "-n"]
