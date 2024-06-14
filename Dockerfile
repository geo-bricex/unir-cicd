FROM python:3.8-slim

WORKDIR /opt/calc

COPY . .

ENV PYTHONPATH=/opt/calc

RUN pip install -r requirements.txt

ENV FLASK_APP=app/api.py

CMD ["flask", "run", "--host=0.0.0.0"]
