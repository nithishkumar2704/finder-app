from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=15, blank=True, null=True)
    profile_picture = models.ImageField(upload_to='profiles/', blank=True, null=True)
    reputation_score = models.IntegerField(default=0)
    
    # Custom fields for location
    last_known_lat = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    last_known_lng = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)

    REQUIRED_FIELDS = ['email']

    def __str__(self):
        return self.username

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    bio = models.TextField(max_length=500, blank=True)
    is_verified = models.BooleanField(default=False)
    items_found_count = models.PositiveIntegerField(default=0)
    items_lost_count = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username}'s Profile"

