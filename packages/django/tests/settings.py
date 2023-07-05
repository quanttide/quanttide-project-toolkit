"""
测试模拟声明式配置文件
"""

SECRET_KEY = 'fake-key'

INSTALLED_APPS = [
    'django.contrib.contenttypes',
    'django_quanttide_projects',
    "tests",
]

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3"
    }
}
