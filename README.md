# Docker developer's container for Magento 2 (CentOS)

This is a fork of [original magento2-docker][fork_origin], but is aimed at hosting developer's environment, rather than just testing functionality.

## How to set it up for new Magento2 project (developer's environment)?

Follow [Quickstart with Magento 2 guide][quickstart_with_magento2].

## How to use it to host existing Magento 2 installation?

1. Run the container from your project's root (see Step 1 in a Quickstart guide above).
2. Once in container - import your database.
3. If you need to modify it - you can create your own image setting this one as a source.
   Example `Dockerfile` in this case:
   
   ```
     FROM asarturas/magento2-docker
     RUN echo "further customisation"
   ```
   
   If a change is generic enough - consider making a pull request or opening an issue ticket here, cheers.


*This container is for developer's use only - not for production or pipeline environment.*

[fork_origin]: https://github.com/magento/magento2-docker
[quickstart_with_magento2]: http://arturas.smorgun.com/2016/02/28/quick-start-with-magento2.html
