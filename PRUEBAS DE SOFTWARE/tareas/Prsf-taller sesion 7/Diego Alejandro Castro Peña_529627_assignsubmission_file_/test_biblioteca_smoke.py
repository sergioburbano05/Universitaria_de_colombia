
import pytest
import requests

BASE = 'http://localhost:8000/api'

@pytest.mark.smoke
class TestBibliotecaSmoke:

    def test_01_api_disponible(self):
        response = requests.get(f'{BASE}/health')
        assert response.status_code == 200

    def test_02_login_funciona(self):
        response = requests.post(f'{BASE}/auth/login', json={
            'usuario': 'estudiante1',
            'password': '1234'
        })
        assert response.status_code == 200
        assert 'access_token' in response.json()

    def test_03_listar_libros_responde(self):
        response = requests.get(f'{BASE}/libros')
        assert response.status_code == 200
        assert isinstance(response.json(), list)

    def test_04_base_de_datos_conectada(self):
        response = requests.get(f'{BASE}/health')
        assert response.json()['db'] == 'connected'

    def test_05_modulo_multas_responde(self):
        response = requests.get(f'{BASE}/multas/estudiante1')
        assert response.status_code == 200
        assert 'multa_total' in response.json()
