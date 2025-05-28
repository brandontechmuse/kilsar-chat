# Kilsar Chat

## Getting Started

 - Flutter SDK >= 3.10.0
 - Flutter 3.32.0 • channel stable •

### Enable Web

flutter config --enable-web

### Run on iOS

flutter run -d ios

### Run on Web

flutter run -d chrome

## Architecture & Libraries

 - Clean Architecture: separated domain, data, presentation layers
 - State Management: flutter_bloc + hydrated_bloc
- Persistence: hive + hive_flutter
- HTTP & AI: http + Gemini REST API via flutter_dotenv
- JSON Ser: json_serializable (I didn't generate anything but i would if i had a local db to save chat, tasks, etc.. )

## Trade-offs & Limitations

- app only uses local hive storage, no cloud sync
- ai calls depends on google gemeni key, u need .env file
- you need to have a chat longer then the screen size for search to work otherwise the screen wont move 

## Known Issues

 blank screen if .env missing

