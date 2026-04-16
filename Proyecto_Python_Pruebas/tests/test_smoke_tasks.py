"""
Smoke Tests - Verifican funcionalidad básica del sistema
Pruebas rápidas que validan que el sistema funciona en general
"""
import pytest
from src.task_manager import TaskManager


class TestSmokeBasic:
    """Smoke tests básicos - funcionalidad central"""
    
    def test_smoke_create_and_list(self):
        """Smoke: Crear tarea y listarla"""
        manager = TaskManager()
        manager.add_task("Primera tarea")
        
        tasks = manager.get_all_tasks()
        assert len(tasks) == 1
        assert tasks[0].title == "Primera tarea"
    
    def test_smoke_complete_workflow(self):
        """Smoke: Crear, completar y listar"""
        manager = TaskManager()
        task = manager.add_task("Tarea importante", priority=5)
        manager.complete_task(task.task_id)
        
        completed = manager.get_completed_tasks()
        assert len(completed) == 1
        assert completed[0].completed == True
    
    def test_smoke_multiple_operations(self):
        """Smoke: Múltiples operaciones en secuencia"""
        manager = TaskManager()
        
        # Crear 3 tareas
        t1 = manager.add_task("Tarea 1")
        t2 = manager.add_task("Tarea 2")
        t3 = manager.add_task("Tarea 3")
        
        # Completar 1
        manager.complete_task(t2.task_id)
        
        # Eliminar 1
        manager.delete_task(t3.task_id)
        
        # Verificar estado
        assert len(manager.get_all_tasks()) == 2
        assert len(manager.get_completed_tasks()) == 1
        assert len(manager.get_pending_tasks()) == 1
    
    def test_smoke_manager_initialization(self):
        """Smoke: TaskManager se inicializa correctamente"""
        manager = TaskManager()
        
        assert len(manager.get_all_tasks()) == 0
        assert manager.count_tasks()["total"] == 0
    
    def test_smoke_priority_filtering(self):
        """Smoke: Filtrado por prioridad funciona"""
        manager = TaskManager()
        
        manager.add_task("Baja prioridad", priority=1)
        manager.add_task("Alta prioridad", priority=5)
        
        high = manager.get_high_priority_tasks()
        assert len(high) == 1
        assert high[0].priority == 5


class TestSmokeErrorHandling:
    """Smoke tests de manejo de errores"""
    
    def test_smoke_error_invalid_priority(self):
        """Smoke: Sistema rechaza prioridad inválida"""
        manager = TaskManager()
        
        with pytest.raises(ValueError):
            manager.add_task("Test", priority=10)
    
    def test_smoke_error_empty_task(self):
        """Smoke: Sistema rechaza tarea vacía"""
        manager = TaskManager()
        
        with pytest.raises(ValueError):
            manager.add_task("")
    
    def test_smoke_error_missing_task(self):
        """Smoke: Sistema maneja tarea no existente"""
        manager = TaskManager()
        
        with pytest.raises(ValueError):
            manager.complete_task(999)
