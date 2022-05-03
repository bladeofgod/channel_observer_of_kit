

import 'package:flutter/services.dart';

class TestChannel{

  static const MethodChannel _channel = MethodChannel('test_channel');

  static Future<String?> get testInt async {
    final String? result = await _channel.invokeMethod('test_int');
    return result;
  }

  static Future<String?> get testNull async {
    final String? result = await _channel.invokeMethod('test_null');
    return result;
  }


}