FROM python:3.11
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
RUN pip install locust
#CMD ["python", "./locustfile.py"]
CMD ["locust"]