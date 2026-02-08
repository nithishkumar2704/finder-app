from django.db import models
from django.conf import settings

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)
    icon = models.CharField(max_length=50, help_text="Material icon name")
    description = models.TextField(blank=True)

    class Meta:
        verbose_name_plural = "Categories"

    def __str__(self):
        return self.name

class Item(models.Model):
    ITEM_TYPES = (
        ('LOST', 'Lost'),
        ('FOUND', 'Found'),
    )
    
    STATUS_CHOICES = (
        ('POSTED', 'Posted'),
        ('CLAIMED', 'Claimed'),
        ('VERIFIED', 'Verified'),
        ('RETURNED', 'Returned'),
    )

    title = models.CharField(max_length=200)
    description = models.TextField()
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, related_name='items')
    item_type = models.CharField(max_length=10, choices=ITEM_TYPES)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='POSTED')
    
    # Location
    latitude = models.DecimalField(max_digits=9, decimal_places=6)
    longitude = models.DecimalField(max_digits=9, decimal_places=6)
    address = models.CharField(max_length=255, blank=True)
    is_flagged = models.BooleanField(default=False)
    
    posted_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='items')

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.item_type}: {self.title}"

class ItemImage(models.Model):
    item = models.ForeignKey(Item, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to='items/')
    is_primary = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Image for {self.item.title}"

