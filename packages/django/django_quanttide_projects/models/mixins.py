"""
Mixin类
"""


class StatusMixin:
    @property
    def is_completed(self):
        """
        是否已完成
        """
        return self.status == "completed"

    @property
    def is_concluded(self):
        """
        是否已结束，包括已完成和已取消。
        """
        return self.status == "completed" or self.status == "cancelled"
