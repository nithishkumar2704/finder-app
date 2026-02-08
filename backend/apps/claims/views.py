from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Claim, ClaimVerification
from .serializers import ClaimSerializer, ClaimVerificationSerializer

class ClaimViewSet(viewsets.ModelViewSet):
    queryset = Claim.objects.all()
    serializer_class = ClaimSerializer

    def get_queryset(self):
        user = self.request.user
        if user.is_staff:
            return Claim.objects.all()
        return Claim.objects.filter(claimant=user)

    def perform_create(self, serializer):
        serializer.save(claimant=self.request.user)

    @action(detail=True, methods=['post'], permission_classes=[permissions.IsAdminUser])
    def verify(self, request, pk=None):
        claim = self.get_object()
        serializer = ClaimVerificationSerializer(data=request.data)
        
        if serializer.is_valid():
            is_approved = serializer.validated_data['is_approved']
            
            # Create verification record
            serializer.save(claim=claim, verified_by=request.user)
            
            # Update claim status
            claim.status = 'APPROVED' if is_approved else 'REJECTED'
            claim.save()
            
            # Update item status if approved
            if is_approved:
                item = claim.item
                item.status = 'VERIFIED'
                item.save()
                
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
