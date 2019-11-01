FROM rocker/binder:3.6.0
LABEL maintainer='Unknown'
USER root
RUN apt-get update \
 && apt-get install libmpfr-dev \
 && tlmgr init-usertree \
 && tlmgr update --self \
 && tlmgr install multirow wrapfig colortbl tabu varwidth threeparttable environ trimspaces ulem makecell xcolor
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}
USER ${NB_USER}
RUN wget https://github.com/rbtreeman/student_project/raw/master/DESCRIPTION && R -e "options(repos = list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/2019-10-31/')); devtools::install_deps()"
RUN rm DESCRIPTION.1; exit 0
