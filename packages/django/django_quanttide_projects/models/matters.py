from django_quanttide import models as quanttide_models

from .fields import StatusField, PriorityField
from .mixins import StatusMixin


class BaseMatter(quanttide_models.PolymorphicModel, StatusMixin):
    number = quanttide_models.NumberField()
    title = quanttide_models.TitleField()
    description = quanttide_models.DescriptionField()
    status = StatusField()
    priority = PriorityField()
    created_at = quanttide_models.CreatedAtField()
    updated_at = quanttide_models.UpdatedAtField()

    class Meta:
        abstract = True
        verbose_name = '事项'
        verbose_name_plural = '事项列表'

    @property
    def type(self):
        return 'default'


class BaseAgileMatter(BaseMatter):
    class Meta:
        abstract = True
        verbose_name = '敏捷事项'
        verbose_name_plural = '敏捷事项列表'

    @property
    def type(self):
        return 'agile'


class BaseMillstone(BaseMatter):
    class Meta:
        abstract = True
        verbose_name = '里程碑'
        verbose_name_plural = '里程碑列表'

    @property
    def type(self):
        return 'millstone'


class BaseEpic(BaseMatter):
    class Meta:
        abstract = True
        verbose_name = '史诗'
        verbose_name_plural = '史诗列表'

    @property
    def type(self):
        return 'epic'


class BaseStory(BaseMatter):
    class Meta:
        abstract = True
        verbose_name = '用户故事'
        verbose_name_plural = '用户故事列表'

    @property
    def type(self):
        return 'story'


class BaseTask(BaseMatter):
    class Meta:
        abstract = True
        verbose_name = '任务'
        verbose_name_plural = '任务列表'

    @property
    def type(self):
        return 'task'


class BaseDefect(BaseMatter):
    class Meta:
        abstract = True
        verbose_name = '缺陷'
        verbose_name_plural = '缺陷列表'

    @property
    def type(self):
        return 'defect'
