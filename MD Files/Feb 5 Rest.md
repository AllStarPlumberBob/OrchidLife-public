# Feb 5 Rest — Real Lux Meter Implementation

## Status: PAUSED — All tasks pending

## Task List

| # | Task | Status |
|---|------|--------|
| 1 | Replace `sensors_plus` with `light_sensor` in pubspec.yaml | Pending |
| 2 | Create `LightSensorService` wrapper | Pending |
| 3 | Register `LightSensorService` in main.dart Provider | Pending |
| 4 | Replace simulated lux stream with real sensor in tools_screen.dart | Pending |
| 5 | Run `flutter analyze lib/` to verify zero errors | Pending |

---

## What This Does

Replace the simulated light meter (random numbers via `Stream.periodic`) with real Android ambient light sensor hardware data using the `light_sensor` package. Add graceful handling when a device lacks a sensor.

## Package: `light_sensor` v3.0.2

- `LightSensor.hasSensor()` — `Future<bool>`
- `LightSensor.luxStream()` — `Stream<int>`
- Android-only (matches project scope)
- No manifest permissions needed
- No native code changes needed

## Files to Change

### 1. `pubspec.yaml` — MODIFY

**Remove line 39:**
```yaml
  sensors_plus: ^4.0.0
```

**Replace with:**
```yaml
  # Lux Meter - ambient light sensor (Android)
  light_sensor: ^3.0.2
```

Then run `flutter pub get`.

`sensors_plus` is not imported anywhere in Dart code — safe to remove.

---

### 2. `lib/services/light_sensor_service.dart` — NEW FILE

```dart
import 'package:light_sensor/light_sensor.dart';

class LightSensorService {
  bool? _hasSensor;

  /// Returns true if device has an ambient light sensor. Cached after first call.
  Future<bool> hasSensor() async {
    _hasSensor ??= await LightSensor.hasSensor();
    return _hasSensor!;
  }

  /// Stream of lux values as doubles.
  /// Maps int->double for compatibility with DB (RealColumn) and existing UI (double _currentLux).
  Stream<double> luxStream() {
    return LightSensor.luxStream().map((int lux) => lux.toDouble());
  }
}
```

---

### 3. `lib/main.dart` — MODIFY

**Add import (after line 4):**
```dart
import 'services/light_sensor_service.dart';
```

**Add to providers list (after line 27, inside the `providers:` array):**
```dart
Provider<LightSensorService>.value(value: LightSensorService()),
```

Full providers list becomes:
```dart
providers: [
  Provider<AppDatabase>.value(value: database),
  Provider<NotificationService>.value(value: notificationService),
  Provider<LightSensorService>.value(value: LightSensorService()),
],
```

---

### 4. `lib/screens/tools_screen.dart` — MODIFY `_LuxMeterScreenState`

#### 4a. Add import (after line 9):
```dart
import '../services/light_sensor_service.dart';
```

#### 4b. Add state fields (after line 133 `bool _isReading = false;`):
```dart
bool? _hasSensor;      // null = checking, true/false = result
String? _sensorError;  // non-null if sensor unavailable or stream errored
```

#### 4c. Add initState (between line 134 and `dispose()`):
```dart
@override
void initState() {
  super.initState();
  _checkSensor();
}

Future<void> _checkSensor() async {
  final service = Provider.of<LightSensorService>(context, listen: false);
  try {
    final available = await service.hasSensor();
    if (mounted) setState(() => _hasSensor = available);
  } catch (e) {
    if (mounted) {
      setState(() {
        _hasSensor = false;
        _sensorError = 'Could not access light sensor: $e';
      });
    }
  }
}
```

#### 4d. Replace `_startReading` (lines 141-155):

**Remove the old simulated version:**
```dart
void _startReading() {
  setState(() => _isReading = true);
  // Note: sensors_plus doesn't have a direct lux sensor on all devices
  // This is a placeholder - in production you'd use platform channels
  // or a package like light_sensor for actual lux readings
  // For demo, we'll simulate readings
  _luxSubscription = Stream.periodic(const Duration(milliseconds: 500)).listen((_) {
    // Simulate varying light readings
    setState(() {
      _currentLux = 500 + (DateTime.now().millisecond % 1000);
    });
  });
}
```

**Replace with:**
```dart
void _startReading() {
  final service = Provider.of<LightSensorService>(context, listen: false);
  setState(() {
    _isReading = true;
    _sensorError = null;
  });

  _luxSubscription = service.luxStream().listen(
    (double lux) {
      if (mounted) setState(() => _currentLux = lux);
    },
    onError: (error) {
      if (mounted) {
        setState(() {
          _isReading = false;
          _sensorError = 'Sensor error: $error';
        });
      }
    },
  );
}
```

`_stopReading` stays unchanged.

#### 4e. Add sensor-unavailable UI in `build()`

Insert before the lux display circle (before the `Container` at line 209), inside the `Expanded` > `Column` > `children`:

```dart
// Sensor status banners
if (_hasSensor == null)
  const Padding(
    padding: EdgeInsets.only(bottom: 16),
    child: LinearProgressIndicator(),
  ),
if (_hasSensor == false)
  Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _sensorError ?? 'This device does not have an ambient light sensor.',
                style: TextStyle(color: Colors.orange.shade900),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
if (_sensorError != null && _hasSensor == true)
  Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _sensorError!,
                style: TextStyle(color: Colors.red.shade900),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
```

#### 4f. Disable Start button when no sensor

**Change the Start/Stop button `onPressed` (line 268):**

From:
```dart
onPressed: _isReading ? _stopReading : _startReading,
```

To:
```dart
onPressed: _hasSensor == true
    ? (_isReading ? _stopReading : _startReading)
    : null,
```

---

## What Does NOT Change

- Lux display UI (circle, value, level text, color coding)
- Light level thresholds and orchid recommendations
- Save reading flow (database insert)
- Light guide card
- `database.dart`
- `AndroidManifest.xml` (no permissions needed)
- `MainActivity.kt`

## Behavioral Changes

| Aspect | Before (simulated) | After (real sensor) |
|--------|--------------------|--------------------|
| Data source | `Stream.periodic` + random math | `LightSensor.luxStream()` hardware |
| Value range | Always 500-1500 | 0 to ~120,000+ (real ambient) |
| Update rate | Fixed 500ms | Hardware-driven (~200ms, varies) |
| No-sensor handling | Not handled | Warning banner, button disabled |
| Stream errors | Not handled | Error banner displayed |

## Verification Checklist

- [ ] `flutter analyze lib/` — zero errors
- [ ] `flutter build apk --debug` — builds successfully
- [ ] **Physical device:** Open Tools > Light Meter > Start > see real lux values
- [ ] **Physical device:** Cover sensor > value drops near 0
- [ ] **Physical device:** Save reading > stored in database
- [ ] **Emulator:** Warning banner shows, Start button grayed out

## Notes

- Android emulators lack a physical light sensor — `hasSensor()` returns false. Full testing requires a real device.
- The light sensor is extremely low-power; no battery concern.
- The `_getLightLevel()` thresholds (500, 1000, 5000, 10000 lux) are appropriate for real sensor data and orchid care guidance.
