from django_quanttide_projects.models import (
    BaseProject,
    BaseMatter, BaseStory, BaseTask
)


class Project(BaseProject):
    pass


class Matter(BaseMatter):
    pass


class Story(BaseStory):
    pass


class Task(BaseTask):
    pass
