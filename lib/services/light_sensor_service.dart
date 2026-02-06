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
