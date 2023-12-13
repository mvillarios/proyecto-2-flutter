from pydantic import BaseModel

class Usuario(BaseModel):
    username: str
    password: str
    email: str

class UsuarioLogin(BaseModel):
    username: str
    password: str

class Publicacion(BaseModel):
    sector: str # nombre sector
    descripcion: str # descripcion de la publicacion
    fecha: str # fecha de la publicacion
    imagen1: str 
    imagen2: str 
    idCreador: str # id de usuario

class Comentario(BaseModel):
    comentario: str # comentario
    idCreador: str # id de usuario
    idPublicacion: str # id de publicacion

class Reaccion(BaseModel):
    tipo: bool # tipo de reaccion
    idCreador: str # id de usuario
    idPublicacion: str # id de publicacion

class TokenData(BaseModel):
    username: str | None = None