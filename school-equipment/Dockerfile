# ---------------------------------------------------------
# Stage 1: Build stage
# ---------------------------------------------------------
FROM php:8.3-apache AS builder

WORKDIR /app

# Copy only required application files
COPY index.php admin.php health.php ./
COPY assets ./assets

# ---------------------------------------------------------
# Stage 2: Runtime stage
# ---------------------------------------------------------
FROM php:8.3-apache

RUN groupadd -g 1001 appgroup \
    && useradd -u 1001 -g appgroup -m -s /usr/sbin/nologin appuser \
    && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
    && sed -i 's/:80/:8080/' /etc/apache2/sites-available/000-default.conf

COPY --from=builder /app /var/www/html

RUN printf '%s\n' \
    '<Location /health>' \
    '  Require all granted' \
    '</Location>' \
    'Alias /health /var/www/html/health.php' \
    > /etc/apache2/conf-available/health.conf \
    && a2enconf health

RUN chown -R appuser:appgroup \
    /var/www/html \
    /var/lock/apache2 \
    /var/run/apache2 \
    /var/log/apache2

USER appuser

EXPOSE 8080

CMD ["apache2-foreground"]