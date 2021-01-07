from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

# Create your models here.
class Room(models.Model):
    room_name = models.CharField(max_length=32)

class Message(models.Model):
    room_name = models.ForeignKey(Room, on_delete=models.CASCADE)
    author = models.ForeignKey(User, related_name='message_author', on_delete=models.CASCADE)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)