from fastapi import FastAPI, HTTPException, Query, Path
from fastapi.params import Depends
from fastapi.responses import JSONResponse
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt

from datetime import datetime, timedelta

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from passlib.context import CryptContext

from bson.json_util import dumps
from bson.objectid import ObjectId

from models import Usuario, Publicacion, Comentario, Reaccion, UsuarioLogin, TokenData
from config import MONGODB_URI, SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES

app = FastAPI()

# Create a new client and connect to the server
client = MongoClient(MONGODB_URI, server_api=ServerApi('1'))
db = client['proyecto2']

usuarios_collection = db['usuarios']
publicaciones_collection = db['publicaciones']
comentarios_collection = db['comentarios']
reacciones_collection = db['reacciones']

crypt_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

"""Usuarios"""
# Funcion que crea un usuario
@app.post("/usuarios")
def crear_usuario(usuario: Usuario):
    # Verificar si el usuario ya existe
    if usuarios_collection.find_one({"username": usuario.username}):
        raise HTTPException(status_code=400, detail="El usuario ya existe")
    
    # Encriptar la contraseña
    usuario.password = crypt_context.hash(usuario.password)

    resultado = usuarios_collection.insert_one({
        "username": usuario.username,
        "password": usuario.password,
        "email": usuario.email
    })

    return JSONResponse({
        "message": "Usuario creado exitosamente",
        "id": str(resultado.inserted_id)
    }, status_code=201)

# Funcion que obtiene todos los usuarios
@app.get("/usuarios")
def obtener_all_usuario():
    usuarios = list(usuarios_collection.find())
    
    for usuario in usuarios:
        usuario["_id"] = str(usuario["_id"])

    return JSONResponse({
        "message": "Usuarios obtenidos exitosamente",
        "usuarios": usuarios
    }, status_code=200)

# Funcion que obtiene un usuario por su id
@app.get("/usuarios/{usuario_id}")
def obtener_usuario(usuario_id: str = Path(..., description="ID usuario")):
    # Convertir el ID de cadena a ObjectId
    usuarioObjectId = ObjectId(usuario_id)
    
    # Buscar el usuario por ObjectId
    usuario = usuarios_collection.find_one({"_id": usuarioObjectId})

    if usuario is None:
        raise HTTPException(status_code=404, detail="El usuario no existe")
    
    # Convertir el ObjectId de vuelta a cadena para la respuesta JSON
    usuario["_id"] = str(usuario["_id"])

    return JSONResponse({
        "message": "Usuario obtenido exitosamente",
        "usuario": usuario
    }, status_code=200)

# Funcion que elimina un usuario por su id
@app.delete("/usuarios/{usuario_id}")
def eliminar_usuario(usuario_id: str = Path(..., description="ID usuario")):

    # Convertir el ID de cadena a ObjectId
    usuarioObjectId = ObjectId(usuario_id)
    
    # Buscar el usuario por ObjectId
    usuario = usuarios_collection.find_one({"_id": usuarioObjectId})

    if usuario is None:
        raise HTTPException(status_code=404, detail="El usuario no existe")
    
    # Eliminar el usuario
    usuarios_collection.delete_one({"_id": usuarioObjectId})

    return JSONResponse({
        "message": "Usuario eliminado exitosamente"
    }, status_code=200)

"""Autenticacion"""
def crear_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

    return encoded_jwt

def autenticar_usuario(username: str, password: str):
    # Buscar el usuario por username
    usuario = usuarios_collection.find_one({"username": username})

    if usuario is None:
        return False
    
    # Verificar la contraseña
    if not crypt_context.verify(password, usuario["password"]):
        return False
    
    return usuario

def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")

        if username is None:
            raise HTTPException(status_code=401, detail="Credenciales invalidas")
        
        token_data = TokenData(username=username)
    except JWTError:
        raise HTTPException(status_code=401, detail="Credenciales invalidas")
    
    usuario = usuarios_collection.find_one({"username": token_data.username})

    if usuario is None:
        raise HTTPException(status_code=404, detail="El usuario no existe")
    
    return usuario

@app.post("/usuarios/login")
def login_usuario(usuario: UsuarioLogin):
    usuario = autenticar_usuario(usuario.username, usuario.password)

    if not usuario:
        raise HTTPException(status_code=401, detail="Credenciales invalidas")
    
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = crear_token(
        data={"sub": usuario["username"]}, expires_delta=access_token_expires
    )

    return JSONResponse({
        "access_token": access_token,
        "token_type": "bearer"
    }, status_code=200)

"""Publicaciones"""
#Funcion que crea una publicacion
@app.post("/publicaciones")
def crear_publicacion(publicacion: Publicacion):

    usuario_creador = usuarios_collection.find_one({"_id": ObjectId(publicacion.idCreador)})
    if usuario_creador is None:
        raise HTTPException(status_code=404, detail="El usuario no existe")

    resultado = publicaciones_collection.insert_one({
        "sector": publicacion.sector,
        "descripcion": publicacion.descripcion,
        "imagen1": publicacion.imagen1,
        "imagen2": publicacion.imagen2,
        "idCreador": publicacion.idCreador
    })

    return JSONResponse({
        "message": "Publicacion creada exitosamente",
        "id": str(resultado.inserted_id)
    }, status_code=201)

# Funcion que obtiene todas las publicaciones
@app.get("/publicaciones")
def obtener_all_publicacion():
    publicaciones = list(publicaciones_collection.find())
    
    for publicacion in publicaciones:
        publicacion["_id"] = str(publicacion["_id"])

    return JSONResponse({
        "message": "Publicaciones obtenidas exitosamente",
        "publicaciones": publicaciones
    }, status_code=200)

# Funcion que obtiene una publicacion por su id
@app.get("/publicaciones/{publicacion_id}")
def obtener_publicacion(publicacion_id: str = Path(..., description="ID publicacion")):
    # Convertir el ID de cadena a ObjectId
    publicacionObjectId = ObjectId(publicacion_id)
    
    # Buscar la publicacion por ObjectId
    publicacion = publicaciones_collection.find_one({"_id": publicacionObjectId})

    if publicacion is None:
        raise HTTPException(status_code=404, detail="La publicacion no existe")
    
    # Convertir el ObjectId de vuelta a cadena para la respuesta JSON
    publicacion["_id"] = str(publicacion["_id"])

    return JSONResponse({
        "message": "Publicacion obtenida exitosamente",
        "publicacion": publicacion
    }, status_code=200)

# Funcion que elimina una publicacion por su id
@app.delete("/publicaciones/{publicacion_id}")
def eliminar_publicacion(publicacion_id: str = Path(..., description="ID publicacion")):
    # Convertir el ID de cadena a ObjectId
    publicacionObjectId = ObjectId(publicacion_id)
        
    # Buscar la publicacion por ObjectId
    publicacion = publicaciones_collection.find_one({"_id": publicacionObjectId})
    
    if publicacion is None:
        raise HTTPException(status_code=404, detail="La publicacion no existe")
        
    # Eliminar la publicacion
    publicaciones_collection.delete_one({"_id": publicacionObjectId})
    
    return JSONResponse({
        "message": "Publicacion eliminada exitosamente"
    }, status_code=200)

"""Comentarios"""
#Funcion que crea un comentario
@app.post("/comentarios")
def crear_comentario(comentario: Comentario):

    usuario_creador = usuarios_collection.find_one({"_id": ObjectId(comentario.idCreador)})
    if usuario_creador is None:
        raise HTTPException(status_code=404, detail="El usuario no existe")

    publicacion = publicaciones_collection.find_one({"_id": ObjectId(comentario.idPublicacion)})
    if publicacion is None:
        raise HTTPException(status_code=404, detail="La publicacion no existe")

    resultado = comentarios_collection.insert_one({
        "comentario": comentario.comentario,
        "idCreador": comentario.idCreador,
        "idPublicacion": comentario.idPublicacion
    })

    return JSONResponse({
        "message": "Comentario creado exitosamente",
        "id": str(resultado.inserted_id)
    }, status_code=201)

# Funcion que obtiene todos los comentarios
@app.get("/comentarios")
def obtener_all_comentario():
    comentarios = list(comentarios_collection.find())
    
    for comentario in comentarios:
        comentario["_id"] = str(comentario["_id"])

    return JSONResponse({
        "message": "Comentarios obtenidos exitosamente",
        "comentarios": comentarios
    }, status_code=200)

# Funcion que obtiene un comentario por su id
@app.get("/comentarios/{comentario_id}")
def obtener_comentario(comentario_id: str = Path(..., description="ID comentario")):
    # Convertir el ID de cadena a ObjectId
    comentarioObjectId = ObjectId(comentario_id)
    
    # Buscar el comentario por ObjectId
    comentario = comentarios_collection.find_one({"_id": comentarioObjectId})

    if comentario is None:
        raise HTTPException(status_code=404, detail="El comentario no existe")
    
    # Convertir el ObjectId de vuelta a cadena para la respuesta JSON
    comentario["_id"] = str(comentario["_id"])

    return JSONResponse({
        "message": "Comentario obtenido exitosamente",
        "comentario": comentario
    }, status_code=200)

# Funcion que elimina un comentario por su id
@app.delete("/comentarios/{comentario_id}")
def eliminar_comentario(comentario_id: str = Path(..., description="ID comentario")):
    # Convertir el ID de cadena a ObjectId
    comentarioObjectId = ObjectId(comentario_id)
    
    # Buscar el comentario por ObjectId
    comentario = comentarios_collection.find_one({"_id": comentarioObjectId})

    if comentario is None:
        raise HTTPException(status_code=404, detail="El comentario no existe")
    
    # Eliminar el comentario
    comentarios_collection.delete_one({"_id": comentarioObjectId})

    return JSONResponse({
        "message": "Comentario eliminado exitosamente"
    }, status_code=200)

"""Reacciones"""
#Funcion que crea una reaccion
@app.post("/reacciones")
def crear_reaccion(reaccion: Reaccion):

    usuario_creador = usuarios_collection.find_one({"_id": ObjectId(reaccion.idCreador)})
    if usuario_creador is None:
        raise HTTPException(status_code=404, detail="El usuario no existe")

    publicacion = publicaciones_collection.find_one({"_id": ObjectId(reaccion.idPublicacion)})
    if publicacion is None:
        raise HTTPException(status_code=404, detail="La publicacion no existe")

    resultado = reacciones_collection.insert_one({
        "tipo": reaccion.tipo,
        "idCreador": reaccion.idCreador,
        "idPublicacion": reaccion.idPublicacion
    })

    return JSONResponse({
        "message": "Reaccion creada exitosamente",
        "id": str(resultado.inserted_id)
    }, status_code=201)

# Funcion que obtiene todas las reacciones
@app.get("/reacciones")
def obtener_all_reaccion():
    reacciones = list(reacciones_collection.find())
    
    for reaccion in reacciones:
        reaccion["_id"] = str(reaccion["_id"])

    return JSONResponse({
        "message": "Reacciones obtenidas exitosamente",
        "reacciones": reacciones
    }, status_code=200)

# Funcion que obtiene una reaccion por su id
@app.get("/reacciones/{reaccion_id}")
def obtener_reaccion(reaccion_id: str = Path(..., description="ID reaccion")):
    # Convertir el ID de cadena a ObjectId
    reaccionObjectId = ObjectId(reaccion_id)
    
    # Buscar la reaccion por ObjectId
    reaccion = reacciones_collection.find_one({"_id": reaccionObjectId})

    if reaccion is None:
        raise HTTPException(status_code=404, detail="La reaccion no existe")
    
    # Convertir el ObjectId de vuelta a cadena para la respuesta JSON
    reaccion["_id"] = str(reaccion["_id"])

    return JSONResponse({
        "message": "Reaccion obtenida exitosamente",
        "reaccion": reaccion
    }, status_code=200)

# Funcion que elimina una reaccion por su id
@app.delete("/reacciones/{reaccion_id}")
def eliminar_reaccion(reaccion_id: str = Path(..., description="ID reaccion")):
    # Convertir el ID de cadena a ObjectId
    reaccionObjectId = ObjectId(reaccion_id)
    
    # Buscar la reaccion por ObjectId
    reaccion = reacciones_collection.find_one({"_id": reaccionObjectId})

    if reaccion is None:
        raise HTTPException(status_code=404, detail="La reaccion no existe")
    
    # Eliminar la reaccion
    reacciones_collection.delete_one({"_id": reaccionObjectId})

    return JSONResponse({
        "message": "Reaccion eliminada exitosamente"
    }, status_code=200)