import 'dart:async';
import 'dart:io' show Platform;
import 'package:camera/camera.dart';
import 'package:light_sensor/light_sensor.dart';

class LightSensorService {
  bool? _hasSensor;

  // ── Camera fields (iOS) ──────────────────────────────────────
  CameraController? _cameraController;
  StreamController<double>? _cameraLuxController;
  double _smoothedLux = 0;
  DateTime _lastEmit = DateTime(0);
  static const _emitInterval = Duration(milliseconds: 250); // 4 Hz max
  static const _smoothingFactor = 0.3;

  /// Whether lux values are estimates (camera) vs hardware sensor.
  bool get isEstimated => !Platform.isAndroid;

  /// Exposes the camera controller so the UI can show a preview on iOS.
  CameraController? get cameraController => _cameraController;

  /// Returns true if device can provide lux readings.
  /// Android: hardware ambient light sensor. iOS: camera (always available).
  Future<bool> hasSensor() async {
    if (Platform.isAndroid) {
      _hasSensor ??= await LightSensor.hasSensor();
      return _hasSensor!;
    }
    // iOS — camera is always available on real devices
    return true;
  }

  /// Stream of lux values as doubles.
  /// Android: hardware sensor stream. iOS: camera-derived stream.
  Stream<double> luxStream() {
    if (Platform.isAndroid) {
      return LightSensor.luxStream().map((int lux) => lux.toDouble());
    }
    // iOS — return the broadcast stream fed by camera frames
    _cameraLuxController ??= StreamController<double>.broadcast();
    return _cameraLuxController!.stream;
  }

  // ── Camera lifecycle (iOS) ───────────────────────────────────

  /// Initialize the back camera for lux estimation.
  /// Returns null on success, or an error message string.
  Future<String?> initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return 'No cameras available on this device.';

      // Prefer back camera
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();
      return null;
    } catch (e) {
      return 'Could not access camera: $e';
    }
  }

  /// Start streaming camera frames and emitting lux estimates.
  void startCameraStream() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    // Guard against double-start — startImageStream throws if already streaming
    if (_cameraController!.value.isStreamingImages) return;
    _cameraLuxController ??= StreamController<double>.broadcast();
    _smoothedLux = 0;
    _lastEmit = DateTime(0);

    _cameraController!.startImageStream((CameraImage image) {
      final lux = _calculateLux(image);
      if (lux == null) return;

      // Exponential moving average smoothing
      _smoothedLux = _smoothedLux == 0
          ? lux
          : _smoothedLux * (1 - _smoothingFactor) + lux * _smoothingFactor;

      // Throttle to 4 Hz
      final now = DateTime.now();
      if (now.difference(_lastEmit) >= _emitInterval) {
        _lastEmit = now;
        final clamped = _smoothedLux.clamp(0.0, 200000.0);
        _cameraLuxController?.add(clamped);
      }
    });
  }

  /// Stop the camera image stream.
  void stopCameraStream() {
    try {
      if (_cameraController != null &&
          _cameraController!.value.isInitialized &&
          _cameraController!.value.isStreamingImages) {
        _cameraController!.stopImageStream();
      }
    } catch (_) {
      // Ignore errors during teardown
    }
  }

  /// Release camera resources.
  Future<void> disposeCamera() async {
    stopCameraStream();
    await _cameraController?.dispose();
    _cameraController = null;
    await _cameraLuxController?.close();
    _cameraLuxController = null;
    _smoothedLux = 0;
  }

  // ── Lux calculation from camera metadata ─────────────────────

  /// Calculate lux from camera exposure metadata.
  /// Formula: Lux = 250 * (f² / (exposureTime_sec * ISO))
  double? _calculateLux(CameraImage image) {
    final aperture = image.lensAperture;
    final exposureTimeNs = image.sensorExposureTime;
    final iso = image.sensorSensitivity;

    if (aperture == null || exposureTimeNs == null || iso == null) return null;
    if (exposureTimeNs <= 0 || iso <= 0) return null;

    final exposureTimeSec = exposureTimeNs / 1000000000.0;
    final lux = 250.0 * (aperture * aperture) / (exposureTimeSec * iso);

    return lux.isFinite ? lux : null;
  }
}
