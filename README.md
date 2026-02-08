# 🔍 Finder App - Lost & Found Item Tracker

A full-stack mobile application that helps people find their lost items and return found items to their rightful owners through location-based search, real-time chat, and admin-moderated claim verification.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Django](https://img.shields.io/badge/Django-092E20?style=for-the-badge&logo=django&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

## ✨ Features

### 🔐 User Authentication
- JWT-based authentication
- Secure token storage
- User profiles with reputation scores

### 📱 Item Management
- Post lost or found items with images
- Category-based organization
- Location-based search (Haversine formula)
- Status tracking: Posted → Claimed → Verified → Returned

### 💬 Real-time Chat
- WebSocket-powered messaging (Django Channels)
- Direct communication between finders and owners
- Message persistence and read receipts

### ✅ Claim Verification
- Submit claims with proof
- Admin moderation system
- Verification workflow

### 🗺️ Location Services
- Nearby items search
- Map integration
- Address geocoding

## 🏗️ Tech Stack

### Backend
- **Framework**: Django 5.0.1 + Django REST Framework
- **Authentication**: JWT (djangorestframework-simplejwt)
- **Database**: MySQL
- **Real-time**: Django Channels + Redis
- **API Documentation**: Swagger (drf-yasg)

### Frontend
- **Framework**: Flutter
- **State Management**: Provider
- **HTTP Client**: http package
- **WebSocket**: web_socket_channel
- **Secure Storage**: flutter_secure_storage
- **Maps**: google_maps_flutter
- **Location**: geolocator

## 📦 Installation

### Prerequisites
- Python 3.11+
- Flutter SDK
- MySQL Server
- Redis Server
- Android Studio (for mobile development)

### Backend Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/finder-app.git
   cd finder-app/backend
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables**
   
   Create a `.env` file in the `backend` directory:
   ```env
   SECRET_KEY=your-secret-key-here
   DEBUG=True
   DB_NAME=finder_app_db
   DB_USER=your_mysql_user
   DB_PASSWORD=your_mysql_password
   DB_HOST=localhost
   DB_PORT=3306
   REDIS_URL=redis://localhost:6379/0
   ALLOWED_HOSTS=localhost,127.0.0.1
   ```

5. **Create MySQL database**
   ```sql
   CREATE DATABASE finder_app_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

6. **Run migrations**
   ```bash
   python manage.py migrate
   ```

7. **Create superuser**
   ```bash
   python manage.py createsuperuser
   ```

8. **Seed categories (optional)**
   ```bash
   python seed_categories.py
   ```

9. **Start the server**
   ```bash
   python manage.py runserver
   ```

   The API will be available at `http://localhost:8000`
   - Swagger UI: `http://localhost:8000/swagger/`
   - Admin Panel: `http://localhost:8000/admin/`

### Mobile App Setup

1. **Navigate to mobile directory**
   ```bash
   cd ../mobile/finder_app
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint**
   
   The app is configured to use `http://10.0.2.2:8000` for Android emulator.
   For physical devices, update the base URLs in:
   - `lib/services/auth_service.dart`
   - `lib/services/item_service.dart`
   - `lib/services/chat_service.dart`
   - `lib/services/claim_service.dart`

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
finder-app/
├── backend/                    # Django REST API
│   ├── config/                # Project settings
│   ├── apps/
│   │   ├── accounts/          # User authentication
│   │   ├── items/             # Item management
│   │   ├── chat/              # Real-time messaging
│   │   ├── claims/            # Claim verification
│   │   └── moderation/        # Admin moderation
│   └── requirements.txt
│
└── mobile/
    └── finder_app/            # Flutter application
        ├── lib/
        │   ├── models/        # Data models
        │   ├── services/      # API services
        │   ├── providers/     # State management
        │   ├── screens/       # UI screens
        │   ├── widgets/       # Reusable widgets
        │   └── utils/         # Utilities
        └── pubspec.yaml
```

## 🔌 API Endpoints

### Authentication
- `POST /api/accounts/register/` - Register new user
- `POST /api/accounts/login/` - Login
- `GET /api/accounts/profile/` - Get user profile
- `PUT /api/accounts/profile/` - Update profile

### Items
- `GET /api/items/` - List all items
- `POST /api/items/` - Create item
- `GET /api/items/{id}/` - Get item details
- `PUT /api/items/{id}/` - Update item
- `DELETE /api/items/{id}/` - Delete item
- `GET /api/items/nearby/` - Search nearby items

### Chat
- `GET /api/chat/conversations/` - List conversations
- `POST /api/chat/conversations/` - Create conversation
- `GET /api/chat/conversations/{id}/messages/` - Get messages
- `WS /ws/chat/{conversation_id}/` - WebSocket endpoint

### Claims
- `POST /api/claims/` - Submit claim
- `GET /api/claims/my-claims/` - User's claims
- `GET /api/admin/claims/pending/` - Pending claims (admin)
- `POST /api/admin/claims/{id}/verify/` - Verify claim (admin)

## 🚀 Deployment

### Backend (Django)
- Use Gunicorn + Nginx for production
- Configure HTTPS with SSL certificates
- Set `DEBUG=False` in production
- Use environment variables for sensitive data
- Set up Redis for WebSocket channel layer

### Mobile App
- Build release APK: `flutter build apk --release`
- Build iOS: `flutter build ios --release`
- Configure app signing for production
- Update API endpoints to production URLs

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.

## 👤 Author

Your Name - [GitHub Profile](https://github.com/yourusername)

## 🙏 Acknowledgments

- Django REST Framework for the powerful API toolkit
- Flutter team for the amazing cross-platform framework
- Django Channels for WebSocket support
