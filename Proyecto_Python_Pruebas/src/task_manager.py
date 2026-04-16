"""
Módulo de administración de tareas
Proporciona funcionalidad para crear, actualizar, completar y listar tareas
"""
from datetime import datetime
from typing import List, Dict, Optional


class Task:
    """Representa una tarea individual"""
    
    def __init__(self, task_id: int, title: str, description: str = "", priority: int = 1):
        """
        Inicializa una tarea
        
        Args:
            task_id: Identificador único de la tarea
            title: Título de la tarea
            description: Descripción detallada
            priority: Nivel de prioridad (1-5)
        """
        if priority < 1 or priority > 5:
            raise ValueError("Prioridad debe estar entre 1 y 5")
        
        self.task_id = task_id
        self.title = title
        self.description = description
        self.priority = priority
        self.completed = False
        self.created_at = datetime.now()
        self.completed_at = None
    
    def complete(self):
        """Marca la tarea como completada"""
        self.completed = True
        self.completed_at = datetime.now()
    
    def to_dict(self) -> Dict:
        """Convierte la tarea a diccionario"""
        return {
            "id": self.task_id,
            "title": self.title,
            "description": self.description,
            "priority": self.priority,
            "completed": self.completed,
            "created_at": self.created_at.isoformat(),
            "completed_at": self.completed_at.isoformat() if self.completed_at else None
        }


class TaskManager:
    """Gestor principal de tareas"""
    
    def __init__(self):
        self.tasks: Dict[int, Task] = {}
        self.next_id = 1
    
    def add_task(self, title: str, description: str = "", priority: int = 1) -> Task:
        """Crea y añade una nueva tarea"""
        if not title or len(title.strip()) == 0:
            raise ValueError("El título de la tarea no puede estar vacío")
        
        if len(title) > 200:
            raise ValueError("El título no puede exceder 200 caracteres")
        
        task = Task(self.next_id, title, description, priority)
        self.tasks[self.next_id] = task
        self.next_id += 1
        return task
    
    def get_task(self, task_id: int) -> Optional[Task]:
        """Obtiene una tarea por ID"""
        return self.tasks.get(task_id)
    
    def complete_task(self, task_id: int) -> bool:
        """Marca una tarea como completada"""
        task = self.get_task(task_id)
        if task is None:
            raise ValueError(f"Tarea con ID {task_id} no existe")
        
        task.complete()
        return True
    
    def delete_task(self, task_id: int) -> bool:
        """Elimina una tarea"""
        if task_id not in self.tasks:
            raise ValueError(f"Tarea con ID {task_id} no existe")
        
        del self.tasks[task_id]
        return True
    
    def get_all_tasks(self) -> List[Task]:
        """Retorna todas las tareas"""
        return list(self.tasks.values())
    
    def get_pending_tasks(self) -> List[Task]:
        """Retorna tareas incompletas"""
        return [t for t in self.tasks.values() if not t.completed]
    
    def get_completed_tasks(self) -> List[Task]:
        """Retorna tareas completadas"""
        return [t for t in self.tasks.values() if t.completed]
    
    def get_tasks_by_priority(self, priority: int) -> List[Task]:
        """Retorna tareas filtradas por prioridad"""
        if priority < 1 or priority > 5:
            raise ValueError("Prioridad debe estar entre 1 y 5")
        
        return [t for t in self.tasks.values() if t.priority == priority]
    
    def get_high_priority_tasks(self) -> List[Task]:
        """Retorna tareas de alta prioridad (4-5)"""
        return [t for t in self.tasks.values() if t.priority >= 4 and not t.completed]
    
    def count_tasks(self) -> Dict[str, int]:
        """Retorna estadísticas de tareas"""
        total = len(self.tasks)
        completed = len(self.get_completed_tasks())
        pending = len(self.get_pending_tasks())
        
        return {
            "total": total,
            "completed": completed,
            "pending": pending,
            "completion_rate": round((completed / total * 100) if total > 0 else 0, 2)
        }
    
    def update_task(self, task_id: int, title: str = None, description: str = None, priority: int = None) -> Task:
        """Actualiza una tarea existente"""
        task = self.get_task(task_id)
        if task is None:
            raise ValueError(f"Tarea con ID {task_id} no existe")
        
        if title is not None:
            if not title or len(title.strip()) == 0:
                raise ValueError("El título no puede estar vacío")
            task.title = title
        
        if description is not None:
            task.description = description
        
        if priority is not None:
            if priority < 1 or priority > 5:
                raise ValueError("Prioridad debe estar entre 1 y 5")
            task.priority = priority
        
        return task
