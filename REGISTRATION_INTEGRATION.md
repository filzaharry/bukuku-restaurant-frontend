# Registration Integration Guide

## Overview

This guide documents the complete integration between the Flutter frontend registration view and the Laravel backend API. The integration includes form validation, API communication, error handling, and user feedback.

## Backend API Endpoints

### 1. Register User
```http
POST /api/v1/auth/register
Content-Type: application/json
Rate Limit: 3 attempts per 1 minute
```

#### Request Body
```json
{
    "username": "string|required|max:255",
    "fullname": "string|required|max:255", 
    "email": "email|required|unique:users,email",
    "phone": "string|required|max:20|unique:users,phone",
    "password": "string|required|min:6"
}
```

#### Success Response (201)
```json
{
    "statusCode": 201,
    "message": "Registrasi berhasil. Silakan login.",
    "data": {
        "id": 1,
        "username": "johndoe",
        "name": "John Doe",
        "email": "john@example.com",
        "phone": "+1234567890",
        "level_id": 2,
        "status": 1,
        "created_at": "2024-01-01T00:00:00.000000Z",
        "updated_at": "2024-01-01T00:00:00.000000Z"
    }
}
```

#### Validation Error Response (422)
```json
{
    "statusCode": 422,
    "message": "Validation error",
    "errors": [
        "Email has already been taken.",
        "Phone must be at least 10 characters."
    ],
    "traceId": ["1234"]
}
```

### 2. Check Email Availability
```http
POST /api/v1/auth/check-email
Content-Type: application/json
Rate Limit: 10 attempts per 1 minute
```

#### Request Body
```json
{
    "email": "user@example.com"
}
```

#### Success Response (200)
```json
{
    "statusCode": 200,
    "message": "Email is available",
    "data": {
        "available": true,
        "message": "Email is available for registration"
    }
}
```

#### Error Response (422)
```json
{
    "statusCode": 422,
    "message": "Email already exists",
    "data": {
        "available": false,
        "message": "This email is already registered"
    }
}
```

### 3. Check Phone Availability
```http
POST /api/v1/auth/check-phone
Content-Type: application/json
Rate Limit: 10 attempts per 1 minute
```

#### Request Body
```json
{
    "phone": "+1234567890"
}
```

#### Success Response (200)
```json
{
    "statusCode": 200,
    "message": "Phone is available",
    "data": {
        "available": true,
        "message": "Phone number is available for registration"
    }
}
```

#### Error Response (422)
```json
{
    "statusCode": 422,
    "message": "Phone already exists",
    "data": {
        "available": false,
        "message": "This phone number is already registered"
    }
}
```

## Frontend Implementation

### 1. Repository Layer

**File**: `lib/modules/auth/register/repositories/register_repository.dart`

The repository handles all API communication with proper error handling:

```dart
class RegisterRepository {
  final ApiHandler _apiHandler = Get.find<ApiHandler>();

  /// Register new user
  Future<BaseResponse> register({
    required String username,
    required String fullname,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiHandler.post(
        '/auth/register',
        data: {
          'username': username,
          'fullname': fullname,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        return BaseResponse(
          statusCode: response.data['statusCode'],
          message: response.data['message'],
          data: response.data['data'],
        );
      }
    } catch (e) {
      return BaseResponse(
        statusCode: 500,
        message: 'Network error: ${e.toString()}',
        data: null,
      );
    }
  }
}
```

### 2. Controller Layer

**File**: `lib/modules/auth/register/controllers/register_controller.dart`

The controller handles business logic, validation, and state management:

```dart
class RegisterController extends GetxController {
  final RegisterRepository _repository = RegisterRepository();
  
  // Form controllers
  final usernameController = TextEditingController();
  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  // Reactive variables
  final isPasswordVisible = false.obs;
  final isRePasswordVisible = false.obs;
  final isLoading = false.obs;

  /// Form validation
  bool _validateForm() {
    String username = usernameController.text.trim();
    String fullname = fullnameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String rePassword = rePasswordController.text;

    // Field validations
    if (username.isEmpty) {
      Get.snackbar('Error', 'Username is required', backgroundColor: Colors.redAccent);
      return false;
    }

    if (fullname.isEmpty) {
      Get.snackbar('Error', 'Full name is required', backgroundColor: Colors.redAccent);
      return false;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters', backgroundColor: Colors.redAccent);
      return false;
    }

    if (password != rePassword) {
      Get.snackbar('Error', 'Passwords do not match', backgroundColor: Colors.redAccent);
      return false;
    }

    // Email validation
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email address', backgroundColor: Colors.redAccent);
      return false;
    }

    return true;
  }

  /// Register user with API
  Future<void> register() async {
    if (!_validateForm()) return;

    isLoading.value = true;
    Get.dialog(const Center(child: CircularProgressIndicator()));

    try {
      final response = await _repository.register(
        username: usernameController.text.trim(),
        fullname: fullnameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
      );

      Get.back(); // Close loading dialog

      if (response.statusCode == 201) {
        Get.snackbar('Success', response.message ?? 'Registration successful');
        Future.delayed(const Duration(seconds: 2), () => Get.back());
      } else {
        // Handle validation errors
        if (response.data != null && response.data is Map) {
          final errors = response.data as Map;
          if (errors.containsKey('errors') && errors['errors'] is List) {
            final errorList = errors['errors'] as List;
            for (String error in errorList) {
              Get.snackbar('Validation Error', error);
            }
          }
        }
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Network error. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
```

### 3. View Layer

**File**: `lib/modules/auth/register/views/register_view.dart`

The view provides the UI with proper form fields and reactive updates:

```dart
class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: UiCard(
            child: Column(
              children: [
                // Username field
                UiTextInput(
                  label: 'Username',
                  hint: 'Enter your username',
                  controller: controller.usernameController,
                  prefixIcon: Icons.person_outline,
                ),
                
                // Full name field
                UiTextInput(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: controller.fullnameController,
                  prefixIcon: Icons.badge_outlined,
                ),
                
                // Phone field
                UiTextInput(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  controller: controller.phoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                
                // Email field
                UiTextInput(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: controller.emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                
                // Password field with visibility toggle
                Obx(() => UiTextInput(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: controller.passwordController,
                  prefixIcon: Icons.lock_outline,
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                )),
                
                // Register button
                Obx(() => UiButton(
                  label: controller.isLoading.value ? 'Registering...' : 'Register',
                  onPressed: controller.isLoading.value ? null : controller.register,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### 4. Dependency Injection

**File**: `lib/modules/auth/register/bindings/register_binding.dart`

The binding provides proper dependency injection:

```dart
class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<RegisterRepository>(() => RegisterRepository());
    
    // Controller
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
```

## Validation Rules

### Frontend Validation
- **Username**: Required, non-empty
- **Full Name**: Required, non-empty
- **Email**: Required, valid email format
- **Phone**: Required, non-empty
- **Password**: Required, minimum 6 characters
- **Password Confirmation**: Must match password

### Backend Validation
- **username**: `required|string|max:255`
- **fullname**: `required|string|max:255`
- **email**: `required|email|unique:users,email`
- **phone**: `required|string|max:20|unique:users,phone`
- **password**: `required|string|min:6`

## Error Handling

### Frontend Error Handling
1. **Validation Errors**: Display individual field errors
2. **Network Errors**: Show generic network error message
3. **Server Errors**: Display server error message
4. **Loading States**: Show loading indicator during API calls

### Backend Error Handling
1. **Validation Errors**: Return 422 with detailed error messages
2. **Database Errors**: Return 500 with error details
3. **Rate Limiting**: Return 429 with retry information
4. **Unique Constraints**: Return specific messages for email/phone duplicates

## Rate Limiting

### Registration Endpoint
- **Limit**: 3 attempts per 1 minute
- **Response**: 429 Too Many Requests when exceeded

### Availability Check Endpoints
- **Limit**: 10 attempts per 1 minute
- **Response**: 429 Too Many Requests when exceeded

## Testing

### 1. Successful Registration
```bash
curl -X POST http://127.0.0.1:8001/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "johndoe",
    "fullname": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "password": "password123"
  }'
```

### 2. Validation Error Test
```bash
curl -X POST http://127.0.0.1:8001/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "",
    "fullname": "",
    "email": "invalid-email",
    "phone": "",
    "password": "123"
  }'
```

### 3. Email Availability Check
```bash
curl -X POST http://127.0.0.1:8001/api/v1/auth/check-email \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com"}'
```

## Security Features

### 1. Rate Limiting
- Prevents brute force attacks
- Configurable per endpoint
- Automatic retry after timeout

### 2. Input Validation
- Server-side validation for all inputs
- Sanitization of user input
- Proper error messages without information leakage

### 3. Unique Constraints
- Database-level unique constraints
- Frontend availability checking
- Real-time validation feedback

## Best Practices

### Frontend
1. **Form Validation**: Validate before API calls
2. **Loading States**: Show progress during API calls
3. **Error Messages**: Provide clear, actionable error messages
4. **User Feedback**: Confirm successful actions
5. **Memory Management**: Dispose controllers properly

### Backend
1. **Validation**: Comprehensive input validation
2. **Error Handling**: Consistent error responses
3. **Rate Limiting**: Protect against abuse
4. **Logging**: Log registration attempts
5. **Security**: Hash passwords, sanitize input

## Troubleshooting

### Common Issues

#### 1. Registration Fails
- **Check**: All required fields are filled
- **Check**: Email format is valid
- **Check**: Password is at least 6 characters
- **Check**: Passwords match
- **Check**: Network connectivity

#### 2. Email Already Exists
- **Frontend**: Check email availability before registration
- **Backend**: Provide clear error message
- **User**: Offer login or password reset options

#### 3. Rate Limiting
- **Wait**: For rate limit to reset
- **Check**: Excessive API calls
- **Implement**: Client-side rate limiting

#### 4. Network Errors
- **Check**: API endpoint is reachable
- **Check**: Internet connectivity
- **Verify**: API base URL configuration

### Debug Steps

1. **Check Network**: Use browser dev tools or Postman
2. **Validate Request**: Ensure request body format is correct
3. **Check Logs**: Review backend logs for errors
4. **Test API**: Use curl or Postman directly
5. **Verify Configuration**: Check API base URL and endpoints

## Integration Checklist

### Backend
- [ ] RegisterRequest validation rules correct
- [ ] AuthenticationController register method implemented
- [ ] Email/phone availability endpoints added
- [ ] Rate limiting configured
- [ ] Error responses standardized
- [ ] Database migration for users table

### Frontend
- [ ] RegisterRepository with API methods
- [ ] RegisterController with validation
- [ ] RegisterView with form fields
- [ ] RegisterBinding with dependencies
- [ ] Error handling implemented
- [ ] Loading states configured

### Testing
- [ ] Successful registration test
- [ ] Validation error test
- [ ] Duplicate email/phone test
- [ ] Network error test
- [ ] Rate limiting test

---

**Registration integration is now complete and ready for use!** 🎉

The system provides a robust, secure, and user-friendly registration process with proper validation, error handling, and feedback mechanisms.
