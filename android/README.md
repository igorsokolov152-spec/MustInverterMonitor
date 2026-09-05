# MUST Inverter Monitor - Android Version

Android приложение для мониторинга MUST инверторов (PV18-6248 ECO) по WiFi.

## Технологии
- **Язык**: Kotlin
- **UI Framework**: Jetpack Compose
- **Navigation**: Compose Navigation
- **Min SDK**: 24 (Android 7.0)
- **Target SDK**: 34 (Android 14)

## Структура проекта
```
android/
├── app/
│   ├── src/main/
│   │   ├── java/com/mustinverter/monitor/
│   │   │   ├── MainActivity.kt
│   │   │   ├── ui/
│   │   │   │   ├── theme/
│   │   │   │   │   ├── Theme.kt
│   │   │   │   │   ├── Color.kt
│   │   │   │   │   └── Type.kt
│   │   │   │   └── screens/
│   │   │   │       ├── AppNavigation.kt
│   │   │   │       ├── DevicesListScreen.kt
│   │   │   │       ├── DeviceDashboardScreen.kt
│   │   │   │       └── SettingsScreen.kt
│   │   │   └── data/
│   │   │       └── model/
│   │   │           └── Inverter.kt
│   │   ├── res/
│   │   │   ├── values/
│   │   │   │   ├── strings.xml
│   │   │   │   └── themes.xml
│   │   │   └── mipmap/
│   │   └── AndroidManifest.xml
│   ├── build.gradle.kts
│   └── proguard-rules.pro
├── build.gradle.kts
├── settings.gradle.kts
├── gradle.properties
└── README.md
```

## Функциональность

### Реализовано
- ✅ Список устройств (добавление/удаление)
- ✅ Дашборд устройства с метриками (напряжение/ток/мощность/температура)
- ✅ Экран настроек
- ✅ Навигация между экранами
- ✅ Material 3 дизайн

### Предстоит реализовать
- [ ] Реальная интеграция UDP/HTTP
- [ ] Локальное сохранение данных (SharedPreferences/DataStore)
- [ ] Обновление данных в реальном времени
- [ ] Экспорт CSV
- [ ] Аутентификация

## Запуск

### Требования
- Android Studio 2023.1+
- Android SDK 34
- Kotlin 1.9+

### Шаги
1. Открыть `File -> Open` и выбрать папку `android/`
2. Дождаться синхронизации Gradle
3. Выбрать устройство/эмулятор
4. Нажать `Run -> Run 'app'` или Shift+F10

## Тестирование

### Встроенные тесты
```bash
./gradlew test           # Unit тесты
./gradlew connectedAndroidTest  # UI тесты
```

### Ручное тестирование
1. Запустить приложение
2. Добавить устройство (IP адрес)
3. Открыть устройство и проверить метрики
4. Проверить навигацию между экранами

## API интеграция

Для подключения к реальным устройствам MUST PV18-6248 ECO, необходимо реализовать UDP/HTTP протокол согласно спецификации.

```kotlin
// TODO: Добавить InverterService для работы с API
```

## Структура данных

```kotlin
data class Inverter(
    val id: String,
    val name: String,
    val ipAddress: String,
    val voltage: Double,        // Напряжение (V)
    val current: Double,        // Ток (A)
    val power: Double,          // Мощность (W)
    val temperature: Double     // Температура (°C)
)
```
