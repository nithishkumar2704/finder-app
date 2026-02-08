from django.db import models
from django.conf import settings
from items.models import Item

class Claim(models.Model):
    STATUS_CHOICES = (
        ('PENDING', 'Pending'),
        ('APPROVED', 'Approved'),
        ('REJECTED', 'Rejected'),
    )

    item = models.ForeignKey(Item, on_delete=models.CASCADE, related_name='claims')
    claimant = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='claims')
    description = models.TextField(help_text="Why do you think this item belongs to you?")
    proof_images = models.JSONField(default=list, blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='PENDING')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Claim by {self.claimant.username} for {self.item.title}"

class ClaimVerification(models.Model):
    claim = models.OneToOneField(Claim, on_delete=models.CASCADE, related_name='verification')
    verified_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, related_name='verifications_made')
    is_approved = models.BooleanField()
    admin_notes = models.TextField(blank=True)
    verified_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        status = "Approved" if self.is_approved else "Rejected"
        return f"Verification for {self.claim}: {status}"

