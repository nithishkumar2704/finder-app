import os
import django

from pathlib import Path
BASE_DIR = Path(__file__).resolve().parent
import sys
sys.path.insert(0, os.path.join(BASE_DIR, 'apps'))

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from items.models import Category

cat, created = Category.objects.get_or_create(
    id=1, 
    defaults={
        'name': 'General', 
        'icon': 'category',
        'description': 'General items category'
    }
)
if created:
    print("Successfully created 'General' category with ID 1.")
else:
    print(f"Category ID 1 already exists: {cat.name}")
