FROM cuahsi/singleuser:legacy

ENV PYTHONPATH="/tmp:/home/jovyan/libs":$PYTHONPATH \
    DOCUMENTS="/home/jovyan/work/notebooks/documents" \
    DATA="/home/jovyan/work/notebooks/data" \
    HOME="/home/jovyan/data" \
    NOTEBOOK_HOME="/home/jovyan/work/notebooks"

ADD utilities /tmp/utilities
WORKDIR $HOME

