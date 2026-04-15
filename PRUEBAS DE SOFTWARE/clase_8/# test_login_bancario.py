# test_login_bancario.py
from locust import HttpUser, task, between
from locust import events

class UsuarioBanco(HttpUser):
    host = 'https://httpbin.org'  # Cambia aquí
    wait_time = between(2, 5)

    def on_start(self):
        # Se ejecuta una vez cuando el usuario virtual inicia
        self.headers = {'Content-Type': 'application/json'}

    @task(5)  # 5x más frecuente
    def consultar_saldo(self):
        # Cambia el endpoint a uno que exista en httpbin
        with self.client.get('/get',  # Ejemplo: /get devuelve JSON
            headers=self.headers,
            catch_response=True) as resp:
            if resp.elapsed.total_seconds() > 0.5:
                resp.failure('SLA violado: > 500ms')

# cd "c:\Users\ingse\OneDrive\Desktop\Universitaria_de_colombia\PRUEBAS DE SOFTWARE\clase_8"
# locust -f "# test_login_bancario.py"
#cd "c:\Users\ingse\OneDrive\Desktop\Universitaria_de_colombia\PRUEBAS DE SOFTWARE\clase_8"; & "C:/Users/ingse/AppData/Local/Programs/Python/Python314/python.exe" -m locust -f "# test_login_bancario.py"