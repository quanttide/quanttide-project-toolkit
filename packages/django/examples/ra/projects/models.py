from django.db import models

# Create your models here.
from django_quanttide_projects.models import BaseTask, BaseStory


class RAStory(BaseStory):
    pass


class RATask(BaseTask):
    pass
