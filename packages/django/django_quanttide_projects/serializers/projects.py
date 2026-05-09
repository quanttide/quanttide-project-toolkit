from rest_framework import serializers


class BaseProjectSerializer(serializers.ModelSerializer):
    class Meta:
        extra_kwargs = {
            'description': {'required': False},
            'type': {'required': False},
            'status': {'required': False},
            'priority': {'required': False},
        }
