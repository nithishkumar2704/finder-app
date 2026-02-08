from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from items.models import Item
from items.serializers import ItemSerializer

class ModerationViewSet(viewsets.ViewSet):
    permission_classes = [permissions.IsAdminUser]

    @action(detail=False, methods=['get'])
    def flagged_items(self, request):
        items = Item.objects.filter(is_flagged=True)
        serializer = ItemSerializer(items, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def resolve_flag(self, request, pk=None):
        try:
            item = Item.objects.get(pk=pk)
            item.is_flagged = False
            item.save()
            return Response({'status': 'flag resolved'})
        except Item.DoesNotExist:
            return Response({'error': 'item not found'}, status=status.HTTP_404_NOT_FOUND)
