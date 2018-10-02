FROM uwhydro/summa:sopron_2018

# run summa when running the docker image
WORKDIR /code/bin

# add the summa entry point script
ADD entry.py /code/bin/entry.py

ENTRYPOINT ["./entry.py"]
