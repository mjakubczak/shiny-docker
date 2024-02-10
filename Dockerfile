FROM r-base:4.3.2

ARG RENV_VERSION=1.0.3
ARG PAK_VERSION=0.7.1
ARG GIT_READ_TOKEN='dummy'

ENV DB_HOST='localhost'
ENV DB_USER='user'
ENV DB_PASSWORD='password'

RUN apt-get update && apt-get install -y \
  libcurl4-openssl-dev \
  libssl-dev \
  # renv needs curl to avoid FD_SETSIZE errors
  curl

RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_version("renv", version="'${RENV_VERSION}'"); remotes::install_version("pak", version="'${PAK_VERSION}'")'

RUN mkdir /install /app
COPY renv.lock /install/renv.lock

RUN cd /install && \
  export GITHUB_PAT=${GIT_READ_TOKEN} && \
  export RENV_CONFIG_PAK_ENABLED=TRUE && \
  export INSTALL_PATH=$(Rscript -e 'cat(.libPaths()[1])') && \
  R -e 'options(timeout=600); renv::settings$use.cache(FALSE); renv::restore(library="'${INSTALL_PATH}'")' && \
  strip --strip-debug ${INSTALL_PATH}/*/libs/*so && \
  cd .. && \
  rm -rf /install \
  # clean after pak and renv...
  rm -r /tmp/* \
  rm -rf /root/.cache/R

COPY app /app/

RUN chmod -R 655 /app
RUN useradd -m appuser
USER appuser

WORKDIR /app

RUN R -e 'testthat::test_dir("tests")'

EXPOSE 3838
ENTRYPOINT ["Rscript"]
CMD ["-e", "shiny::runApp(port=3838, host='0.0.0.0')"]
