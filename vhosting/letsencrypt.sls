# Install LetsEncrypt client via LE formula
include:
  - letsencrypt

# Create a webroot placeholder folder
/opt/letsencrypt/www:
  file.directory:
    - require_in:
      - file: letsencrypt-config
