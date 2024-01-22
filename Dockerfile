# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG REGISTRY=quay.io
ARG OWNER=jupyter
ARG BASE_CONTAINER=$REGISTRY/$OWNER/pyspark-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# RSpark config
ENV R_LIBS_USER "${SPARK_HOME}/R/lib"
RUN fix-permissions "${R_LIBS_USER}"

# R pre-requisites
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

# R packages including IRKernel which gets installed globally.
RUN mamba install --yes \
    'r-base' \
    'r-ggplot2' \
    'r-irkernel' \
    'r-rcurl' \
    'hvplot' \
    'datashader' \
    apache-airflow \
    luigi \
    pyarrow \
    SQLAlchemy \
    ansible \
    jenkinsapi \
    pyparsing \
    polars \
    PyYAML \
#    mage-ai \
    seaborn \
    plotly \
    apache-superset \
    dbt-postgres \
    prefect \
    duckdb \
    'r-sparklyr' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

    # apache-airflow==2.8.0 \
    # luigi==3.5.0 \
    # pyarrow==14.0.2 \
    # SQLAlchemy==2.0.25 \
    # ansible==9.1.0 \
    # jenkinsapi==0.3.13 \
    # pyparsing==3.1.1 \
    # polars==0.20.4 \
    # PyYAML==6.0.1 \
    # mage-ai==0.9.59 \
    # seaborn==0.13.1 \
    # plotly==5.18.0 \
    # apache-superset==3.0.2 \
    # dbt-postgres \
    # prefect==2.14.15 \
    # duckdb==0.9.2 \