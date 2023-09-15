from django.test import TestCase

from tests.models import Matter, Story, Task


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
        self.assertEqual(self.matter.priority, 'low')
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


class PolymorphicModelTestCase(TestCase):
    def test_number_field(self):
        """
        测试number字段。

        测试结果表明，目前的事项是根据类型各自独立编号的，并且删除以后会重新生成。
        """
        matter = Matter.objects.create(
            title='Test Matter',
            description='Test Description',
        )
        self.assertEqual(matter.number, 1)
        story = Story.objects.create(
            title='Test Story',
            description='Test Description',
        )
        self.assertEqual(story.number, 1)
