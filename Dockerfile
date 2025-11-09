FROM php:8.2-fpm

# Install system packages
RUN apt-get update && apt-get install -y \
    nginx supervisor git unzip \
    && rm -rf /var/lib/apt/lists/*

# Remove default html dir and recreate
RUN rm -rf /var/www/html && mkdir -p /var/www/html

# Clone LinkStack into the web root
RUN git clone https://github.com/LinkStackOrg/LinkStack.git /var/www/html && echo "nocache-$(date +%s)"

WORKDIR /var/www/html

# Ensure storage exists BEFORE Railway mounts volume
RUN mkdir -p /var/www/html/storage

# Create .env
RUN cp .env.example .env

# Fix permissions for web server
RUN chown -R www-data:www-data /var/www/html

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Add supervisord config to run both nginx + php-fpm
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["supervisord", "-n"]
