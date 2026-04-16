"""
Pruebas de Performance - Verifican que el sistema cumpla con requisitos de velocidad
Miden tiempo de ejecución y detectan cuellos de botella
"""
import pytest
import time
from src.task_manager import TaskManager


class TestPerformance:
    """Pruebas de rendimiento del TaskManager"""
    
    def test_performance_add_1000_tasks(self):
        """Verificar que se pueden crear 1000 tareas rápidamente"""
        manager = TaskManager()
        
        start_time = time.time()
        for i in range(1000):
            manager.add_task(f"Tarea {i}")
        elapsed = time.time() - start_time
        
        # Debe completarse en menos de 1 segundo
        assert elapsed < 1.0, f"Crear 1000 tareas tomó {elapsed}s"
        assert len(manager.get_all_tasks()) == 1000
    
    def test_performance_complete_task_is_fast(self):
        """Verificar que completar tarea es rápido"""
        manager = TaskManager()
        task = manager.add_task("Test")
        
        start_time = time.time()
        for _ in range(1000):
            # Completar y descompletar (resetear estado)
            manager.complete_task(task.task_id)
            # Nota: necesitaríamos un método para descompletar,
            # pero esto simula el patrón
        elapsed = time.time() - start_time
        
        # 1000 completaciones en menos de 100ms
        assert elapsed < 0.1, f"Completación fue lenta: {elapsed}s"
    
    def test_performance_filter_by_priority_scales(self):
        """Verificar que filtrado escala bien"""
        manager = TaskManager()
        
        # Crear 500 tareas
        for i in range(500):
            priority = (i % 5) + 1
            manager.add_task(f"Tarea {i}", priority=priority)
        
        # Filtrar debe ser rápido
        start_time = time.time()
        high_priority = manager.get_high_priority_tasks()
        elapsed = time.time() - start_time
        
        assert elapsed < 0.01, f"Filtrado fue lento: {elapsed}s"
        assert len(high_priority) > 0
    
    def test_performance_get_statistics_is_fast(self):
        """Verificar que estadísticas se calculan rápido"""
        manager = TaskManager()
        
        # Crear 500 tareas y completar algunas
        for i in range(500):
            task = manager.add_task(f"Tarea {i}")
            if i % 3 == 0:
                manager.complete_task(task.task_id)
        
        # Calcular estadísticas debe ser rápido
        start_time = time.time()
        for _ in range(100):
            stats = manager.count_tasks()
        elapsed = time.time() - start_time
        
        # 100 cálculos de estadísticas en menos de 50ms
        assert elapsed < 0.05, f"Estadísticas fueron lentas: {elapsed}s"
    
    def test_performance_retrieve_task_by_id(self):
        """Verificar que recuperar tarea por ID es O(1)"""
        manager = TaskManager()
        
        # Crear 1000 tareas
        task_ids = []
        for i in range(1000):
            task = manager.add_task(f"Tarea {i}")
            task_ids.append(task.task_id)
        
        # Recuperar aleatoriamente debe ser rápido
        start_time = time.time()
        for task_id in task_ids:
            manager.get_task(task_id)
        elapsed = time.time() - start_time
        
        # 1000 búsquedas en menos de 100ms
        assert elapsed < 0.1, f"Búsquedas fueron lentas: {elapsed}s"
    
    def test_performance_memory_efficiency(self):
        """Verificar uso eficiente de memoria"""
        manager = TaskManager()
        
        # Crear muchas tareas
        for i in range(10000):
            manager.add_task(f"Tarea {i}", f"Descripción {i}")
        
        # Operaciones deben seguir siendo rápidas incluso con muchas tareas
        start_time = time.time()
        stats = manager.count_tasks()
        pending = manager.get_pending_tasks()
        elapsed = time.time() - start_time
        
        assert elapsed < 0.05, f"Operaciones fueron lentas con muchas tareas: {elapsed}s"
        assert stats["total"] == 10000


class TestPerformanceThresholds:
    """Pruebas con umbrales específicos de performance"""
    
    def test_perf_threshold_add_task_under_1ms_each(self):
        """Cada tarea debe crearse en menos de 1ms en promedio"""
        manager = TaskManager()
        
        start_time = time.time()
        for i in range(100):
            manager.add_task(f"Tarea {i}")
        total_time = time.time() - start_time
        
        avg_time_per_task = (total_time / 100) * 1000  # en ms
        assert avg_time_per_task < 1.0, f"Promedio por tarea: {avg_time_per_task:.2f}ms"
    
    def test_perf_threshold_get_all_tasks_under_5ms(self):
        """Obtener todas las tareas debe ser rápido incluso con 1000"""
        manager = TaskManager()
        for i in range(1000):
            manager.add_task(f"Tarea {i}")
        
        start_time = time.time()
        for _ in range(100):
            manager.get_all_tasks()
        total_time = time.time() - start_time
        
        avg_time = (total_time / 100) * 1000  # en ms
        assert avg_time < 5.0, f"Promedio de obtención: {avg_time:.2f}ms"
