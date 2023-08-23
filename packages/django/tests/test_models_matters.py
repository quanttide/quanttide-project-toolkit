from django.test import TestCase

from tests.models import Matter, Task


class BaseMatterTestCase(TestCase):
    def setUp(self):
        self.matter = Matter.objects.create(
            title='Test Matter',
            description='Test Description',
        )

    def test_fields(self):
        self.assertEqual(self.matter.number, 1)
        self.assertEqual(self.matter.title, 'Test Matter')
        self.assertEqual(self.matter.description, 'Test Description')
        self.assertEqual(self.matter.status, 'drafting')
        self.assertEqual(self.matter.priority, 10)
        self.assertIsNotNone(self.matter.created_at)
        self.assertIsNotNone(self.matter.updated_at)

    def test_type(self):
        self.assertEqual(self.matter.type, 'default')

    def test_meta(self):
        self.assertEqual(Matter._meta.verbose_name, '事项')
        self.assertEqual(Matter._meta.verbose_name_plural, '事项列表')


class BaseTaskTestCase(TestCase):
    def setUp(self):
        self.task = Task.objects.create(
            title='Test Matter',
            description='Test Description',
        )

    def test_type(self):
        self.assertEqual(self.task.type, 'task')
