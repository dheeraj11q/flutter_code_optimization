import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TextToSpeak extends StatefulWidget {
  const TextToSpeak({Key? key}) : super(key: key);

  @override
  State<TextToSpeak> createState() => _TextToSpeakState();
}

class _TextToSpeakState extends State<TextToSpeak> {
  String paragraph =
      '''Lorem Ipsum is simply dummy text of the printing and typesetting industry.''';
  String activeText = "";

  FlutterTts flutterTts = FlutterTts();

  //<< Todo for listner
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  void _startListening() async {
    await _speechToText.listen(
        // listenFor: const Duration(minutes: 1),
        cancelOnError: false,
        partialResults: true,
        listenMode: ListenMode.dictation,
        onResult: (v) {
          log("Heres is ... ${v.recognizedWords}");
        });
    setState(() {});
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  //>>

  @override
  void initState() {
    _initSpeech();
    super.initState();
  }

  Future<void> speak(String text) async {
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.speak(text);
    var textList = text.split(" ");

    flutterTts.setProgressHandler((text, start, end, word) {
      print("Here word $text  $start  $end $word");

      activeText = word;
      setState(() {});
    });
  }

  void run() async {
    var wordList = paragraph.split(" ");

    var sString = "";

    for (int i = 0; i < wordList.length; i++) {
      sString += "${wordList[i]} ";
      // Todo word
      await speak(wordList[i]);
      await Future.delayed(const Duration(seconds: 1));

      // Todo 4 word
      // if ((i + 1) % 4 == 0) {
      //   await speak(sString);
      //   await Future.delayed(const Duration(seconds: 3));
      //   sString = "";
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Wrap(children: [
            for (int i = 0; i < paragraph.split(" ").length; i++)
              Text(
                "${paragraph.split(" ")[i]} ",
                style: activeText == paragraph.split(" ")[i]
                    ? const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        decoration: TextDecoration.underline)
                    : null,
              )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // _startListening();
          run();
          // await flutterTts.setVolume(1.0);
          // // await flutterTts.setPitch(0.5);
          // await flutterTts.setSpeechRate(0.4);
          // await flutterTts
          //     .setVoice({"name": "yue-HK-Standard-B", "locale": "yue-HK"});
          // _speak();
        },
        child: Icon(Icons.volume_up_rounded),
      ),
    );
  }
}
