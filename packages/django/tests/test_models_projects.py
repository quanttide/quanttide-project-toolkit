from django.test import TestCase
from django_quanttide_projects.models import (
    ProjectTypeChoices, StatusChoices, PriorityChoices
)

from tests.models import Project


class BaseProjectTest(TestCase):
    def test_create(self):
        project = Project.objects.create(
            name="test-name",
            title="Test Project Title",
            description="Test project description",
        )
        self.assertEqual(project.name, "test-name")
        self.assertEqual(project.title, "Test Project Title")
        self.assertEqual(project.description, "Test project description")
        self.assertEqual(project.type, ProjectTypeChoices.DEFAULT)
        self.assertEqual(project.status, StatusChoices.DRAFT)
        self.assertEqual(project.priority, PriorityChoices.LOW)
