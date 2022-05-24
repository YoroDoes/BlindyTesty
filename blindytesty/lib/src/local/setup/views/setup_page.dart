import 'dart:io';

import 'package:blindytesty/src/local/setup/bloc/local_setup_bloc.dart';
import 'package:blindytesty/src/platform/platform.dart';
import 'package:blindytesty/src/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalSetupView extends StatefulWidget {
  const LocalSetupView({Key? key}) : super(key: key);

  @override
  State<LocalSetupView> createState() => _LocalSetupViewState();
}

String formatMessage =
    'Format of your files with the input fields <in-between chevrons> (e.g. "<SongName> - <ArtistName>").';
List<String> extensions = [
  // video
  'mp4',
  'webm',
  'mpeg',
  'mpv',
  'ogv',
  'wmv',
  'mov',
  'm4v',
  'mkv',
  //audio
  'aac',
  'avi',
  'mp3',
  'm4a',
  'mka',
  'flac',
  'ogg',
  'oga',
  'wav',
  'wma',
];

class _LocalSetupViewState extends State<LocalSetupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        fullTitle: const Text('Local Files'),
        backArrowAction: () {
          context.read<PlatformBloc>().add(PlatformUnset());
        },
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Tooltip(
                triggerMode: TooltipTriggerMode.longPress,
                waitDuration: const Duration(milliseconds: 500),
                message: formatMessage,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: formatMessage,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FilePicker.platform.getDirectoryPath().then(
                  (dir) async {
                    if (dir == null) return;
                    Directory dirObj = Directory.fromUri(
                        Uri.directory(dir, windows: Platform.isWindows));
                    File file;
                    try {
                      file = await dirObj.list().firstWhere(
                            (element) =>
                                FileSystemEntity.isFileSync(element.path) &&
                                extensions.any(
                                    (ext) => //Looks for an audio file extension
                                        element.uri.pathSegments.last
                                            .split('.')
                                            .last
                                            .toLowerCase()
                                            .compareTo(ext) ==
                                        0),
                          ) as File;
                    } catch (e) {
                      if (kDebugMode) {
                        print('No audio or video file in this directory.');
                      }
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                                'No audio or video file in this directory.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                    String testFormat = '<ArtistName> - <SongName>';
                    List<String> fields = RegExp(r'<(?<FieldName>\w+)>')
                        .allMatches(testFormat)
                        .map((e) => e.namedGroup('FieldName') ?? '')
                        .toList();
                    String fileNameRegexp =
                        '^${testFormat.replaceAll(RegExp(r'<\w+>'), '(.+)')}\$';
                    String exampleFile = file.uri.pathSegments.last;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Format confirmation'),
                          content: Builder(builder: (context) {
                            var match = RegExp(fileNameRegexp).firstMatch(
                                exampleFile.replaceFirst(
                                    RegExp(r'\.[^.]+$'), ''));
                            List<String> fieldsExampleStrings = match
                                    ?.groups(
                                      List.generate(match.groupCount,
                                          (index) => index + 1),
                                    )
                                    .where((element) => element != null)
                                    .map((e) => e ?? '') // bit odd but meh
                                    .toList() ??
                                [];
                            List<InlineSpan> fieldsExample = [];
                            for (var i = 0;
                                i < fieldsExampleStrings.length;
                                i++) {
                              fieldsExample.add(
                                TextSpan(
                                  text: '\n${fields.elementAt(i)}: '
                                      '${fieldsExampleStrings.elementAt(i)}',
                                ),
                              );
                            }

                            return RichText(
                              text: TextSpan(
                                text:
                                    'The file format would consider the following '
                                    'file "$exampleFile", as:\n',
                                children: fieldsExample,
                              ),
                            );
                          }),
                          actions: [
                            TextButton(
                              onPressed: () {
                                context
                                    .read<LocalSetupBloc>()
                                    .add(ChangeFields(text: testFormat));
                                // Navigator.of(context).push(Test.route());

                                // var player = Player.file('$dir/the_turdis.mp4')
                                //   ..play()
                                //   ..volume = 0.5;
                              },
                              child: const Text('Proceed'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: const Text('Locate your folder.'),
            ),
          ],
        ),
      ),
    );
  }
}

class LocalSetupPage extends StatelessWidget {
  const LocalSetupPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const LocalSetupPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocalSetupBloc(),
      child: const LocalSetupView(),
    );
  }
}
