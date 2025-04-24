import 'package:flutter/material.dart';
import 'package:flutter_application_10/pags/welcom_screen.dart';
import 'package:flutter_application_10/pags/my_botton.dart';

class ChatScreen extends StatefulWidget {
  static const String chatScreenRout = 'chat_secreen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // String? MassegeText;
  // late String massegeText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset(
              'images/كلية الطب .png',
              height: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text('Massage'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: MyButton(
                color: Colors.yellow[800]!,
                title: 'Sin In',
                onPressed: () {
                  Navigator.pushNamed(context, WelcomScreen.welcomScreenRout);
                }),
            iconSize: 20,
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              // child: Text(massegeText!),
              ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.orange, width: 2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    // controller: massegaTextController,
                    onChanged: (val) {
                      // MassegeText = val;
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        hintText: 'Write Your massega',
                        border: InputBorder.none),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      // massegeText = MassegeText;
                    },
                    child: Icon(Icons.send)
                    // Text(
                    //   'Send',
                    //   style: TextStyle(
                    //       color: Colors.blue[400],
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 18),
                    // ),
                    )
              ],
            ),
          )
        ],
      )),
    );
  }
}

// class MassegaStreemBuilder extends StatelessWidget {
//   const MassegaStreemBuilder({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(stream:_fi, builder: builder);
//   }
// }

class MassegLine extends StatelessWidget {
  const MassegLine({this.text, this.sender, super.key});
  final String? sender;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$sender',
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Colors.blue[800],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
