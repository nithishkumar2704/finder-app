from rest_framework import serializers
from .models import Claim, ClaimVerification

class ClaimVerificationSerializer(serializers.ModelSerializer):
    verified_by_username = serializers.CharField(source='verified_by.username', read_only=True)

    class Meta:
        model = ClaimVerification
        fields = ('id', 'is_approved', 'admin_notes', 'verified_by', 'verified_by_username', 'verified_at')
        read_only_fields = ('verified_by', 'verified_at')

class ClaimSerializer(serializers.ModelSerializer):
    claimant_username = serializers.CharField(source='claimant.username', read_only=True)
    item_title = serializers.CharField(source='item.title', read_only=True)
    verification = ClaimVerificationSerializer(read_only=True)

    class Meta:
        model = Claim
        fields = ('id', 'item', 'item_title', 'claimant', 'claimant_username', 'description', 
                  'proof_images', 'status', 'verification', 'created_at', 'updated_at')
        read_only_fields = ('claimant', 'status')

    def create(self, validated_data):
        validated_data['claimant'] = self.context['request'].user
        return super().create(validated_data)
