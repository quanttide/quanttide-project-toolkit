from django.db import models

from django_quanttide_projects.models import BaseMatter, BaseStory, BaseTask


class Matter(BaseMatter):
    pass


class Story(BaseStory):
    pass


class Task(BaseTask):
    pass
