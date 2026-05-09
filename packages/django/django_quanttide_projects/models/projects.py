from django_quanttide import models as quanttide_models

from .fields import ProjectTypeField, StatusField, PriorityField
from .mixins import StatusMixin


class BaseProject(quanttide_models.PolymorphicModel, StatusMixin):
    """
    项目模型基类
    """
    name = quanttide_models.NameField()
    verbose_name = quanttide_models.VerboseNameField()
    readme = quanttide_models.ReadmeField()
    status = StatusField()
    priority = PriorityField()
    created_at = quanttide_models.CreatedAtField()
    updated_at = quanttide_models.UpdatedAtField()

    class Meta:
        verbose_name = '项目'
        verbose_name_plural = '项目列表'
        abstract = True

    @property
    def type(self) -> str:
        return 'default'


class BaseProgram(BaseProject):
    class Meta:
        abstract = True
        verbose_name = '项目集'
        verbose_name_plural = '项目集列表'

    @property
    def type(self) -> str:
        return 'program'


class BaseProjectPortfolio(BaseProject):
    class Meta:
        abstract = True
        verbose_name = '项目组合'
        verbose_name_plural = '项目组合列表'

    @property
    def type(self) -> str:
        return 'project_portfolio'
