# 🧘 Tranquil Study AI

A student wellness + academic companion app built with Flutter and powered by AI.

## Features

- 🧠 **Mind Check-In** — Log mood, energy, and stress levels daily
- 💬 **AI Companion** — Chat with Tranquil Study AI for personalized guidance
- 📅 **Smart Planner** — Manage tasks with deadline tracking
- 🌿 **Calm Toolkit** — Breathing exercises, grounding, and micro breaks

## Tech Stack

- **Frontend:** Flutter
- **AI:** Groq API (Llama 3.3 70B)
- **Storage:** SharedPreferences (local)
- **Language:** Dart

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Groq API Key (free at https://console.groq.com)

### Setup

1. Clone the repository
```bash
   git clone https://github.com/YOUR_USERNAME/tranquilstudy_ai.git
   cd tranquilstudy_ai
```

2. Install dependencies
```bash
   flutter pub get
```

3. Add your API key
   - Create `lib/core/secrets.dart`
   - Add your Groq API key:
```dart
   class AppSecrets {
     static const String groqApiKey = 'your_key_here';
   }
```

4. Run the app
```bash
   flutter run
```

## Project Structure

lib/
├── core/          # Constants, theme, routes
├── models/        # Data models
├── services/      # AI and storage services
├── screens/       # App screens
└── widgets/       # Reusable widgets

## Screenshots

_Coming soon_

## License

MIT License — feel free to use for educational purposes.