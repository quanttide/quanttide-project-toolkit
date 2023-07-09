from django_quanttide import models

from .fields import MatterTypeField, StatusField, PriorityField


class BaseMatter(models.Model):
    number = models.NumberField()
    title = models.TitleField()
    description = models.DescriptionField()
    type = MatterTypeField()
    status = StatusField()
    priority = PriorityField()
    created_at = models.CreatedAtField()
    updated_at = models.UpdatedAtField()

    class Meta:
        abstract = True
        verbose_name = '事项'
        verbose_name_plural = '事项列表'


class MillstoneMixin:
    pass


class EpicMixin:
    pass


class StoryMixin:
    pass


class TaskMixin:
    pass
