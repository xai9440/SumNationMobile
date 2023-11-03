import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modernlogintute/summarization_api.dart';
import 'package:logger/logger.dart';

// class HomePage extends StatelessWidget {
//   HomePage({super.key});

//   final user = FirebaseAuth.instance.currentUser!;

//   void signUserOut() {
//     FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
//         ],
//       ),
//       body: Center(
//           child: Text(
//         "Logged in as: ${user.email!}",
//         style: const TextStyle(fontSize: 20),
//       )),
//     );
//   }
// }

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);

class SummarizationApp extends StatelessWidget {
  const SummarizationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Summarization App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.comfortable,
        primarySwatch: Colors.blueGrey,
      ),
      home: StatefulBuilder(
        builder: (context, setState) {
          return const SummarizationPage();
        },
      ),
    );
  }
}

class SummarizationPage extends StatefulWidget {
  const SummarizationPage({super.key});

  @override
  State<SummarizationPage> createState() => _SummarizationPageState();
}

class _SummarizationPageState extends State<SummarizationPage> {
  final _textController = TextEditingController();

  String _summary = '';
  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void _summarizeText() async {
    final inputText = _textController.text;

    try {
      final summary = await SummarizationApi.fetchSummary(inputText);
      setState(() {
        _summary = summary;
      });
    } catch (e) {
      logger.e('Error: $e');
      setState(() {
        _summary = 'Error: Failed to fetch summary.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(179, 192, 192, 192),
      appBar: AppBar(
        title: const Text('Summarization Nation'),
        backgroundColor: const Color.fromARGB(255, 2, 48, 71),
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Enter text',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Color.fromARGB(255, 2, 48, 71)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Color.fromARGB(255, 2, 48, 71)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  // TextFormField(
                  //   controller: _textController,
                  //   decoration: const InputDecoration(
                  //     labelText: "Enter text",
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   expands: true,
                  //   maxLines: null,
                  // ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _summarizeText();
                      (context as Element)
                          .markNeedsBuild(); // Force rebuild to update summary
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 183, 3),
                      foregroundColor: Colors.white70,
                      minimumSize: const Size(200, 40),
                    ),
                    child: const Text(
                      'Summarize',
                      style: TextStyle(
                          fontFamily: AnsiColor.ansiEsc,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Summary:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height: 450,
                    width: 375,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        child: Text(
                          _summary,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
