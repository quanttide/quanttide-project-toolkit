"""
Mixin类
"""
from .choices import StatusChoices


class StatusMixin:
    @property
    def is_abnormal(self) -> bool:
        """
        是否异常，包括已延期、已暂停、已取消。
        """
        return self.status in [StatusChoices.DELAYED, StatusChoices.PAUSED, StatusChoices.CANCELLED]

    @property
    def is_normal(self) -> bool:
        """
        是否正常
        """
        return not self.is_abnormal

    @property
    def is_not_started(self) -> bool:
        """
        是否未开始
        """
        return self.status in [
            StatusChoices.DRAFT,
            StatusChoices.EVALUATION,
            StatusChoices.AWAITING
        ]

    @property
    def is_concluded(self) -> bool:
        """
        是否已结束，包括已完成和已取消。
        """
        return self.status in [StatusChoices.COMPLETED, StatusChoices.CANCELLED]

    @property
    def is_completed(self) -> bool:
        """
        是否已完成
        """
        return self.status == StatusChoices.COMPLETED
