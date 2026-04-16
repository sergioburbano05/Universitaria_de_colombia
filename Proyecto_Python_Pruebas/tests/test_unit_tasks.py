"""
Pruebas Unitarias - TaskManager
Verifican la funcionalidad de componentes individuales
"""
import pytest
from src.task_manager import TaskManager, Task


class TestTaskCreation:
    """Pruebas de creación de tareas"""
    
    def test_create_basic_task(self):
        """Verifica que se crea una tarea básica correctamente"""
        manager = TaskManager()
        task = manager.add_task("Comprar leche")
        
        assert task.title == "Comprar leche"
        assert task.completed == False
        assert task.priority == 1
    
    def test_create_task_with_priority(self):
        """Verifica creación de tarea con prioridad específica"""
        manager = TaskManager()
        task = manager.add_task("Urgente", priority=5)
        
        assert task.priority == 5
    
    def test_task_id_increments(self):
        """Verifica que los IDs se incrementan correctamente"""
        manager = TaskManager()
        task1 = manager.add_task("Tarea 1")
        task2 = manager.add_task("Tarea 2")
        
        assert task1.task_id == 1
        assert task2.task_id == 2
    
    def test_empty_title_raises_error(self):
        """Verifica que título vacío lanza excepción"""
        manager = TaskManager()
        with pytest.raises(ValueError):
            manager.add_task("")
    
    def test_invalid_priority_raises_error(self):
        """Verifica que prioridad inválida lanza excepción"""
        manager = TaskManager()
        with pytest.raises(ValueError):
            manager.add_task("Test", priority=6)
        
        with pytest.raises(ValueError):
            manager.add_task("Test", priority=0)
    
    def test_title_too_long_raises_error(self):
        """Verifica que título muy largo lanza excepción"""
        manager = TaskManager()
        long_title = "A" * 201
        with pytest.raises(ValueError):
            manager.add_task(long_title)


class TestTaskCompletion:
    """Pruebas de completar tareas"""
    
    def test_complete_task(self):
        """Verifica que una tarea se marca como completada"""
        manager = TaskManager()
        task = manager.add_task("Test")
        manager.complete_task(task.task_id)
        
        assert manager.get_task(task.task_id).completed == True
    
    def test_complete_nonexistent_task_raises_error(self):
        """Verifica que completar tarea inexistente lanza error"""
        manager = TaskManager()
        with pytest.raises(ValueError):
            manager.complete_task(999)


class TestTaskRetrieval:
    """Pruebas de obtención de tareas"""
    
    def test_get_all_tasks(self):
        """Verifica obtención de todas las tareas"""
        manager = TaskManager()
        manager.add_task("Tarea 1")
        manager.add_task("Tarea 2")
        
        all_tasks = manager.get_all_tasks()
        assert len(all_tasks) == 2
    
    def test_get_pending_tasks(self):
        """Verifica filtro de tareas pendientes"""
        manager = TaskManager()
        task1 = manager.add_task("Pendiente")
        task2 = manager.add_task("Completada")
        manager.complete_task(task2.task_id)
        
        pending = manager.get_pending_tasks()
        assert len(pending) == 1
        assert pending[0].task_id == task1.task_id
    
    def test_get_completed_tasks(self):
        """Verifica filtro de tareas completadas"""
        manager = TaskManager()
        task1 = manager.add_task("Tarea 1")
        manager.complete_task(task1.task_id)
        
        completed = manager.get_completed_tasks()
        assert len(completed) == 1
    
    def test_get_tasks_by_priority(self):
        """Verifica filtro por prioridad"""
        manager = TaskManager()
        manager.add_task("Alta", priority=5)
        manager.add_task("Baja", priority=1)
        
        high_priority = manager.get_tasks_by_priority(5)
        assert len(high_priority) == 1
        assert high_priority[0].priority == 5


class TestTaskDeletion:
    """Pruebas de eliminación de tareas"""
    
    def test_delete_task(self):
        """Verifica eliminación de tarea"""
        manager = TaskManager()
        task = manager.add_task("Eliminar")
        manager.delete_task(task.task_id)
        
        assert manager.get_task(task.task_id) is None
    
    def test_delete_nonexistent_task_raises_error(self):
        """Verifica que eliminar tarea inexistente lanza error"""
        manager = TaskManager()
        with pytest.raises(ValueError):
            manager.delete_task(999)


class TestTaskStatistics:
    """Pruebas de estadísticas"""
    
    def test_count_tasks(self):
        """Verifica conteo de tareas"""
        manager = TaskManager()
        manager.add_task("Tarea 1")
        manager.add_task("Tarea 2")
        
        counts = manager.count_tasks()
        assert counts["total"] == 2
        assert counts["pending"] == 2
        assert counts["completion_rate"] == 0.0
    
    def test_completion_rate(self):
        """Verifica cálculo de porcentaje de completitud"""
        manager = TaskManager()
        task1 = manager.add_task("Tarea 1")
        task2 = manager.add_task("Tarea 2")
        manager.complete_task(task1.task_id)
        
        counts = manager.count_tasks()
        assert counts["completion_rate"] == 50.0


class TestTaskUpdate:
    """Pruebas de actualización de tareas"""
    
    def test_update_task_title(self):
        """Verifica actualización del título"""
        manager = TaskManager()
        task = manager.add_task("Original")
        manager.update_task(task.task_id, title="Actualizado")
        
        updated_task = manager.get_task(task.task_id)
        assert updated_task.title == "Actualizado"
    
    def test_update_task_priority(self):
        """Verifica actualización de prioridad"""
        manager = TaskManager()
        task = manager.add_task("Test", priority=1)
        manager.update_task(task.task_id, priority=5)
        
        assert manager.get_task(task.task_id).priority == 5
    
    def test_update_nonexistent_task_raises_error(self):
        """Verifica que actualizar tarea inexistente lanza error"""
        manager = TaskManager()
        with pytest.raises(ValueError):
            manager.update_task(999, title="Test")
