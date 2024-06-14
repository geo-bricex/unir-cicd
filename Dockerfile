FROM python:3.8-slim

# Instalamos dependencias necesarias incluyendo Docker
RUN apt-get update && apt-get install -y docker.io

WORKDIR /opt/calc

# Copiar los archivos del proyecto
COPY . .

# Instalar dependencias de Python
RUN pip install -r requirements.txt

# Configurar la aplicación Flask
ENV FLASK_APP=app/api.py

# Ejecutar la aplicación Flask
CMD ["flask", "run", "--host=0.0.0.0"]
