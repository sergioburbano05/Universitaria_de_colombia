$ErrorActionPreference = "Stop"

$root = "c:\Repositorio\MURIC\biblioteca_sqlalchemy"
$integration = Join-Path $root "tests\integration"

New-Item -ItemType Directory -Force -Path $integration | Out-Null

function Write-File([string]$path, [string]$content) {
    Set-Content -Path $path -Value $content -Encoding UTF8
}

Write-File (Join-Path $root "models.py") @'
from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.orm import DeclarativeBase

class Base(DeclarativeBase):
    pass

class Libro(Base):
    __tablename__ = 'libros'
    id         = Column(Integer, primary_key=True)
    titulo     = Column(String, nullable=False)
    autor      = Column(String, nullable=False)
    disponible = Column(Boolean, default=True)
'@

Write-File (Join-Path $root "repositorio.py") @'
from sqlalchemy.orm import Session
from models import Libro

class LibroRepository:
    def __init__(self, session: Session):
        self.session = session

    def guardar(self, libro: Libro) -> Libro:
        self.session.add(libro)
        self.session.commit()
        self.session.refresh(libro)
        return libro

    def buscar_por_titulo(self, titulo: str) -> Libro | None:
        return self.session.query(Libro)\
            .filter(Libro.titulo == titulo).first()
'@

Write-File (Join-Path $root "servicio.py") @'
from repositorio import LibroRepository
from models import Libro

class BibliotecaService:
    def __init__(self, repo: LibroRepository):
        self.repo = repo

    def agregar_libro(self, titulo: str, autor: str) -> Libro:
        if not titulo or not autor:
            raise ValueError('Título y autor son obligatorios')
        return self.repo.guardar(Libro(titulo=titulo, autor=autor))

    def prestar_libro(self, titulo: str) -> Libro:
        libro = self.repo.buscar_por_titulo(titulo)
        if libro is None:
            raise LookupError(f'Libro {titulo!r} no encontrado')
        if not libro.disponible:
            raise RuntimeError(f'Libro {titulo!r} no disponible')
        libro.disponible = False
        self.repo.session.commit()
        return libro
'@

Write-File (Join-Path $integration "conftest.py") @'
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base
from repositorio import LibroRepository
from servicio import BibliotecaService

@pytest.fixture(scope='session')
def engine():
    _engine = create_engine('sqlite:///:memory:')
    Base.metadata.create_all(_engine)
    yield _engine
    Base.metadata.drop_all(_engine)

@pytest.fixture
def session(engine):
    Session = sessionmaker(bind=engine)
    s = Session()
    yield s
    s.rollback()
    s.close()

@pytest.fixture
def servicio(session):
    return BibliotecaService(LibroRepository(session))
'@

Write-File (Join-Path $integration "test_biblioteca.py") @'
import pytest
from models import Libro

def test_agregar_libro_persiste_en_bd(servicio, session):
    libro = servicio.agregar_libro('El Quijote', 'Cervantes')
    resultado = session.get(Libro, libro.id)
    assert resultado is not None
    assert resultado.titulo == 'El Quijote'
    assert resultado.disponible is True

def test_prestar_libro_cambia_disponibilidad(servicio):
    servicio.agregar_libro('Cien Años', 'García Márquez')
    prestado = servicio.prestar_libro('Cien Años')
    assert prestado.disponible is False

def test_prestar_libro_inexistente_lanza_error(servicio):
    with pytest.raises(LookupError):
        servicio.prestar_libro('Libro Fantasma')
'@

Write-Host "Estructura creada en: $root"