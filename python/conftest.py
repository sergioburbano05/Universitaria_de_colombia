"""
Configuración de pytest
"""

import pytest


def pytest_configure(config):
    """Configuración inicial de pytest."""
    config.addinivalue_line(
        "markers", "unit: test unitario"
    )
    config.addinivalue_line(
        "markers", "integration: test de integración"
    )
