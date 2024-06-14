FROM python:3.8-slim

WORKDIR /opt/calc

COPY . .

RUN pip install -r requirements.txt

ENV FLASK_APP=app/api.py

CMD ["flask", "run", "--host=0.0.0.0"]
