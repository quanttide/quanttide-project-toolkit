from django.test import TestCase
from django_quanttide_projects.models import (
    StatusChoices, PriorityChoices
)

from tests.models import Project


class BaseProjectTest(TestCase):
    def test_create(self):
        project = Project.objects.create(
            name="test-name",
            verbose_name="Test Project",
            readme="README for test project",
        )
        self.assertEqual(project.name, "test-name")
        self.assertEqual(project.verbose_name, "Test Project")
        self.assertEqual(project.readme, "README for test project")
        self.assertEqual(project.type, 'default')
        self.assertEqual(project.status, StatusChoices.DRAFT)
        self.assertEqual(project.priority, PriorityChoices.LOW)
