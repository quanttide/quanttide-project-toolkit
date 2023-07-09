from rest_framework import serializers


class BaseMatterSerializer(serializers.ModelSerializer):
    class Meta:
        extra_kwargs = {
            'description': {'required': False},
            'type': {'required': False},
            'status': {'required': False},
            'priority': {'required': False},
        }
