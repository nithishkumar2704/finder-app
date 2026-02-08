from rest_framework import serializers
from .models import Category, Item, ItemImage

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'

class ItemImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ItemImage
        fields = ('id', 'image', 'is_primary')

class ItemSerializer(serializers.ModelSerializer):
    images = ItemImageSerializer(many=True, read_only=True)
    category_name = serializers.SerializerMethodField()
    posted_by_username = serializers.CharField(source='posted_by.username', read_only=True)

    class Meta:
        model = Item
        fields = ('id', 'title', 'description', 'category', 'category_name', 'item_type', 'status', 
                  'latitude', 'longitude', 'address', 'posted_by', 'posted_by_username', 
                  'images', 'created_at', 'updated_at')
        read_only_fields = ('posted_by', 'status')

    def get_category_name(self, obj):
        return obj.category.name if obj.category else "Uncategorized"

    def create(self, validated_data):
        # The user is already set in the view via perform_create, 
        # but DRF also allows setting it here via context.
        # We'll just rely on the view's perform_create for better clarity.
        return super().create(validated_data)
