library html_messages;

export 'package:html_messages/src/html_messages_nonweb.dart'
    if (dart.library.html) 'package:html_messages/src/html_messages.dart';
