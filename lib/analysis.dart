import 'dart:js' as js;

class FirebaseAnalyticsWeb {
  static void logEvent(String name, Map<String, dynamic> parameters) {
    final analytics = js.context['analytics'];
    if (analytics != null) {
      analytics.callMethod('logEvent', [name, js.JsObject.jsify(parameters)]);
    } else {
      print('⚠️ analytics object not found in JS context');
    }
  }
}
