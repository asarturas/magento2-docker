#!/bin/bash
set -e

/scripts/run.sh

mysql -e 'DROP DATABASE IF EXISTS magento2;'
mysql -e 'CREATE DATABASE IF NOT EXISTS magento2;'

MAGENTO_PATH=/var/www/app/magento2.docker.loc/magento2
MAGENTO_CONSOLE=bin/magento

COMMANDS=(
    "$MAGENTO_PATH/$MAGENTO_CONSOLE setup:install
        --backend-frontname=admin
        --session-save=db
        --db-host=localhost
        --db-name=magento2
        --db-user=root
        --base-url=http://magento2.docker.loc/
        --language=en_US
        --timezone=America/Los_Angeles
        --currency=USD
        --admin-lastname=Admin
        --admin-firstname=Admin
        --admin-email=admin@example.com
        --admin-user=admin
        --admin-password=123123q"
    "$MAGENTO_PATH/$MAGENTO_CONSOLE deploy:mode:set developer"
    "$MAGENTO_PATH/$MAGENTO_CONSOLE setup:performance:generate-fixtures $MAGENTO_PATH/setup/performance-toolkit/profiles/ce/small.xml"
    "$MAGENTO_PATH/$MAGENTO_CONSOLE setup:static-content:deploy"
    "$MAGENTO_PATH/$MAGENTO_CONSOLE deploy:mode:set production"
    "$MAGENTO_PATH/$MAGENTO_CONSOLE setup:di:compile"
    )

ELEMENTS=${#COMMANDS[@]}

for (( i=0;i<$ELEMENTS;i++)); do
    echo "${COMMANDS[${i}]}"
    ${COMMANDS[${i}]}
    case "$i" in
    0) echo 'Update Magento configuration'
        mysql -e "INSERT INTO \`magento2\`.\`core_config_data\`
        (\`path\`, \`value\`)
        VALUES
        ('dev/template/minify_html', 1),
        ('dev/js/enable_js_bundling', 1),
        ('dev/js/merge_files', 1),
        ('dev/js/minify_files', 1),
        ('dev/css/merge_css_files', 1),
        ('dev/css/minify_files', 1),
        ('web/seo/use_rewrites', 1),
        ('web/url/redirect_to_base', 1),
        ('admin/security/use_form_key', 1)
        ON DUPLICATE KEY UPDATE \`value\` = VALUES(\`value\`);"
    ;;
    2) echo 'Remove static and generated files'
        rm -R -f $MAGENTO_PATH/var/* $MAGENTO_PATH/pub/static/*
    ;;
    4)
        chown -R nginx:nginx $MAGENTO_PATH/var $MAGENTO_PATH/pub/static
    ;;
    esac
done

chown -R nginx:nginx $MAGENTO_PATH
chmod -R 777 $MAGENTO_PATH/var $MAGENTO_PATH/pub/static
bash
