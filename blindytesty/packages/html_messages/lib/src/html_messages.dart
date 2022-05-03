import 'dart:html';

class HtmlMessages {
  static Future<void> registerOnMessage(
    String messageHandler,
    void Function(MessageEvent) function,
  ) async {
    if (!window.sessionStorage.containsKey(messageHandler)) {
      window.sessionStorage.addAll({messageHandler: 'true'});
      window.onMessage.listen(function);
    }
  }
}
