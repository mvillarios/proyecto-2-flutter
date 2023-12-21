# proyecto2

Proyecto 2 para Apps Moviles

## Integrantes

- Miguel Villa
- Daniel Michel

## Tecnologias

- Flutter
- Dart
- Python
- FastApi

# Antes de usar

 Es necesario crear un archivo en la carpeta API llamado 'config.py'
 Este archivo tiene que contener las siguientes variables:
 - SECRET_KEY
 - ALGORITHM
 - ACCESS_TOKEN_EXPIRE_MINUTES
 - MONGODB_URI

## Instalación y uso

 Instalar dependencias
 - pip install -r requirements.txt

 Iniciar servidor API
 - cd api
 - uvicorn main:app --reload

 Iniciar app (en otra terminal)
 - flutter run