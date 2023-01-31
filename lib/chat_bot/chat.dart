import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  Map messagesData = {
    "hi": "Hi",
    "how are you": "doing well!, what about you?",
  };

  List<Map<String, String>> messages = [
    // {"userId": "1234", "msg": "How are you?"},
    // {"userId": "12345", "msg": "I am ok!, You say."},
    // {"userId": "1234", "msg": "Hi"},
    // {"userId": "12345", "msg": "Hi"},
  ];

  TextEditingController myMessageCtrl = TextEditingController();

  String myId = "12345";
  String botId = "1234";
  bool botTyping = false;

  void loadMessages() {}

  void messageSend({required String id, required String message}) async {
    messages.insert(0, {"userId": id, "msg": message});

    setState(() {});
    await Future.delayed(const Duration(seconds: 4));
    botMessageReply(message: message);
  }

  void botMessageReply({
    required String message,
  }) async {
    botTyping = true;
    setState(() {});

    await Future.delayed(const Duration(seconds: 4));

    if (messagesData.containsKey(message)) {
      messages.insert(0, {"userId": botId, "msg": messagesData[message]});
    } else {
      messages.insert(0, {"userId": botId, "msg": "don't know"});
    }

    botTyping = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return messages[index]["userId"] == myId
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: size.height * 0.008),
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${messages[index]["msg"]}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * 0.05),
                              ))
                          : Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.symmetric(
                                  vertical: size.height * 0.008),
                              child: Text(
                                "${messages[index]["msg"]}",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: size.width * 0.05),
                              ));
                    }),
              ),
              if (botTyping)
                Container(
                    margin: EdgeInsets.only(
                      top: size.height * 0.02,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Typing...",
                      style: TextStyle(
                          color: Colors.grey, fontSize: size.width * 0.04),
                    )),
              SizedBox(
                height: size.height * 0.05,
              )
            ],
          ),
        ),
        bottomSheet: TextField(
          controller: myMessageCtrl,
          decoration: InputDecoration(
              filled: true,
              hintText: "Type Here...",
              suffixIcon: IconButton(
                onPressed: () {
                  messageSend(id: myId, message: myMessageCtrl.text);
                  myMessageCtrl.clear();
                },
                icon: const Icon(Icons.send),
              )),
        ),
      ),
    );
  }
}
