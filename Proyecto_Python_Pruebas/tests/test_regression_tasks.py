"""
Pruebas de Regresión - Verifican que cambios no rompan funcionalidad existente
Incluyen casos de uso del mundo real
"""
import pytest
from src.task_manager import TaskManager


class TestRegressionWorkflows:
    """Verifican que workflows comunes funcionan después de cambios"""
    
    def test_regression_create_task_has_timestamp(self):
        """Verificar que tareas siempre tengan timestamp"""
        manager = TaskManager()
        task = manager.add_task("Con timestamp")
        
        assert task.created_at is not None
        assert task.completed_at is None  # No completada aún
    
    def test_regression_completed_task_has_timestamp(self):
        """Verificar que tarea completada tenga timestamp de compleción"""
        manager = TaskManager()
        task = manager.add_task("Test")
        manager.complete_task(task.task_id)
        
        completed_task = manager.get_task(task.task_id)
        assert completed_task.completed_at is not None
    
    def test_regression_task_to_dict(self):
        """Verificar que conversión a diccionario funciona"""
        manager = TaskManager()
        task = manager.add_task("Convertible")
        
        task_dict = task.to_dict()
        assert "id" in task_dict
        assert "title" in task_dict
        assert task_dict["title"] == "Convertible"
    
    def test_regression_persistence_across_operations(self):
        """Verificar que datos persisten después de operaciones"""
        manager = TaskManager()
        task1 = manager.add_task("Persistente")
        task1_id = task1.task_id
        
        # Realizar varias operaciones
        manager.add_task("Otra")
        manager.complete_task(task1_id)
        
        # Verificar que tarea original mantiene sus datos
        retrieved = manager.get_task(task1_id)
        assert retrieved.title == "Persistente"
        assert retrieved.completed == True
    
    def test_regression_empty_manager_statistics(self):
        """Verificar estadísticas en manager vacío"""
        manager = TaskManager()
        
        counts = manager.count_tasks()
        assert counts["total"] == 0
        assert counts["completion_rate"] == 0.0
    
    def test_regression_high_priority_task_filtering(self):
        """Verificar que filtro de alta prioridad ignora completadas"""
        manager = TaskManager()
        
        high = manager.add_task("Urgente completada", priority=5)
        low = manager.add_task("Baja pendiente", priority=1)
        
        manager.complete_task(high.task_id)
        
        high_pending = manager.get_high_priority_tasks()
        # Solo debe retornar tareas de alta prioridad SIN completar
        assert len(high_pending) == 0
    
    def test_regression_priority_validation_consistent(self):
        """Verificar que validación de prioridad es consistente"""
        manager = TaskManager()
        
        # Crear con prioridades válidas
        t1 = manager.add_task("P1", priority=1)
        t5 = manager.add_task("P5", priority=5)
        
        # Actualizar con prioridades válidas
        manager.update_task(t1.task_id, priority=3)
        manager.update_task(t5.task_id, priority=2)
        
        # Verificar
        assert manager.get_task(t1.task_id).priority == 3
        assert manager.get_task(t5.task_id).priority == 2
    
    def test_regression_ID_space_integrity(self):
        """Verificar integridad del espacio de IDs"""
        manager = TaskManager()
        
        ids = []
        for i in range(5):
            task = manager.add_task(f"Tarea {i}")
            ids.append(task.task_id)
        
        # Los IDs deben ser secuenciales y únicos
        assert ids == [1, 2, 3, 4, 5]
        assert len(set(ids)) == len(ids)  # Todos únicos


class TestRegressionEdgeCases:
    """Pruebas de casos extremos para regresión"""
    
    def test_regression_very_long_title_boundary(self):
        """Verificar límite de 200 caracteres para título"""
        manager = TaskManager()
        
        # Exactamente 200 caracteres
        title_200 = "A" * 200
        task = manager.add_task(title_200)
        assert task.title == title_200
        
        # 201 caracteres debe fallar
        with pytest.raises(ValueError):
            manager.add_task("A" * 201)
    
    def test_regression_whitespace_title_handling(self):
        """Verificar que títulos con solo espacios se rechacen"""
        manager = TaskManager()
        
        with pytest.raises(ValueError):
            manager.add_task("   ")
    
    def test_regression_delete_and_recreate(self):
        """Verificar que se puede recrear tarea después de eliminar"""
        manager = TaskManager()
        
        t1 = manager.add_task("Original")
        manager.delete_task(t1.task_id)
        
        # Crear nueva con título igual (debe funcionar)
        t2 = manager.add_task("Original")
        
        assert t2.task_id != t1.task_id
        assert manager.get_task(t2.task_id) is not None
    
    def test_regression_update_multiple_fields(self):
        """Verificar actualización simultánea de múltiples campos"""
        manager = TaskManager()
        
        task = manager.add_task("Original", "Desc", priority=1)
        manager.update_task(
            task.task_id,
            title="Nuevo título",
            description="Nueva descripción",
            priority=5
        )
        
        updated = manager.get_task(task.task_id)
        assert updated.title == "Nuevo título"
        assert updated.description == "Nueva descripción"
        assert updated.priority == 5
