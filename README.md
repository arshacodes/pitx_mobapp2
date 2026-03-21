# PITX Commuter App

Flutter client for the commuter-facing side of PITX.

## What It Does

- Authenticates against the Laravel commuter API in `pitx_system`
- Restores commuter sessions locally
- Searches direct routes from the backend route dataset
- Shows discoverable stops/locations and recent searches

## Backend Expectations

The app expects the Laravel API to expose:

- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `GET /api/v1/auth/me`
- `POST /api/v1/auth/logout`
- `GET /api/v1/locations`
- `GET /api/v1/routes/search`

## Running Locally

1. Start the Laravel backend in `pitx_system`.
2. Run the app with an API base URL when needed:

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1
```

Android emulator usually needs:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

If no `API_BASE_URL` is provided, the app falls back to a platform-aware local default.
