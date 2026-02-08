from rest_framework import serializers
from .models import Conversation, Message

class MessageSerializer(serializers.ModelSerializer):
    sender_username = serializers.CharField(source='sender.username', read_only=True)

    class Meta:
        model = Message
        fields = ('id', 'conversation', 'sender', 'sender_username', 'text', 'is_read', 'timestamp')
        read_only_fields = ('sender', 'timestamp')

class ConversationSerializer(serializers.ModelSerializer):
    item_title = serializers.CharField(source='item.title', read_only=True)
    last_message = serializers.SerializerMethodField()

    class Meta:
        model = Conversation
        fields = ('id', 'item', 'item_title', 'participants', 'created_at', 'last_message_at', 'last_message')

    def get_last_message(self, obj):
        message = obj.messages.last()
        if message:
            return MessageSerializer(message).data
        return None
