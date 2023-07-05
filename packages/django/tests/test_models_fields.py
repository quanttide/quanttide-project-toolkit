from django.test import SimpleTestCase
from django_quanttide_projects.models import ProjectTypeField, MatterTypeField, StatusField, PriorityField
from django_quanttide_projects.models import ProjectTypeChoices, MatterTypeChoices, StatusChoices, PriorityChoices


class ProjectTypeFieldTest(SimpleTestCase):
    def test_description(self):
        field = ProjectTypeField()
        self.assertEqual(field.description, "项目类型字段")

    def test_choices(self):
        field = ProjectTypeField()
        self.assertEqual(field.choices, ProjectTypeChoices.choices)

    def test_default(self):
        field = ProjectTypeField()
        self.assertEqual(field.default, ProjectTypeChoices.DEFAULT)


class MatterTypeFieldTest(SimpleTestCase):
    def test_description(self):
        field = MatterTypeField()
        self.assertEqual(field.description, "事项类型字段")

    def test_choices(self):
        field = MatterTypeField()
        self.assertEqual(field.choices, MatterTypeChoices.choices)

    def test_default(self):
        field = MatterTypeField()
        self.assertEqual(field.default, MatterTypeChoices.DEFAULT)


class StatusFieldTest(SimpleTestCase):
    def test_description(self):
        field = StatusField()
        self.assertEqual(field.description, "状态字段")

    def test_choices(self):
        field = StatusField()
        self.assertEqual(field.choices, StatusChoices.choices)

    def test_default(self):
        field = StatusField()
        self.assertEqual(field.default, StatusChoices.DRAFT)


class PriorityFieldTest(SimpleTestCase):
    def test_description(self):
        field = PriorityField()
        self.assertEqual(field.description, "优先级字段")

    def test_choices(self):
        field = PriorityField()
        self.assertEqual(field.choices, PriorityChoices.choices)

    def test_default(self):
        field = PriorityField()
        self.assertEqual(field.default, PriorityChoices.LOW)

    def test_verbose_name(self):
        field = PriorityField()
        self.assertEqual(field.verbose_name, "优先级")
