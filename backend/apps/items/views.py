from rest_framework import viewsets, permissions, filters, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
import math

from .models import Category, Item, ItemImage
from .serializers import CategorySerializer, ItemSerializer, ItemImageSerializer

class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
    permission_classes = [permissions.AllowAny]

class ItemViewSet(viewsets.ModelViewSet):
    queryset = Item.objects.all().order_by('-created_at')
    serializer_class = ItemSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_fields = ['category', 'item_type', 'status']
    search_fields = ['title', 'description', 'address']

    def get_permissions(self):
        if self.action in ['list', 'retrieve']:
            return [permissions.AllowAny()]
        return [permissions.IsAuthenticated()]

    def create(self, request, *args, **kwargs):
        print("\n" + "="*50)
        print(f"CRITICAL DEBUG: Post Item Request started")
        print(f"User: {request.user}")
        print(f"Data: {request.data}")
        try:
            res = super().create(request, *args, **kwargs)
            print("CRITICAL DEBUG: Post Item Success")
            return res
        except Exception as e:
            print(f"CRITICAL DEBUG ERROR: {str(e)}")
            import traceback
            traceback.print_exc()
            return Response(
                {"error": str(e), "detail": "Check server logs"}, 
                status=status.HTTP_400_BAD_REQUEST
            )

    def perform_create(self, serializer):
        serializer.save(posted_by=self.request.user)

    @action(detail=False, methods=['get'])
    def nearby(self, request):
        lat = request.query_params.get('lat')
        lng = request.query_params.get('lng')
        radius = request.query_params.get('radius', 10) # km

        if not lat or not lng:
            return Response({"error": "lat and lng are required"}, status=400)

        # Basic bounding box filtering before exact calculation (optimization)
        # 1 degree of latitude is ~111km
        lat_delta = float(radius) / 111.0
        lng_delta = float(radius) / (111.0 * abs(math.cos(math.radians(float(lat)))))

        queryset = self.queryset.filter(
            latitude__range=(float(lat) - lat_delta, float(lat) + lat_delta),
            longitude__range=(float(lng) - lng_delta, float(lng) + lng_delta)
        )

        # Exact distance calculation (optional if precision is needed)
        # For simplicity, returning the filtered queryset
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

