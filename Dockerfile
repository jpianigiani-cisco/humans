FROM python:3.11
WORKDIR /app
COPY ./locustfile.py /app
RUN pip install -r requirements.txt
RUN pip install locust
#CMD ["python", "./locustfile.py"]
CMD ["locust"]

FROM locustio/locust
WORKDIR /app
COPY ./locustfile.py /app
CMD ["locust"]