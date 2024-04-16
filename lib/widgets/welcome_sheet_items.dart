import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Widget Function({Key? incomingKey})> welcomeWidgets = [
  ({Key? incomingKey}) {
    return Column(
      key: incomingKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(
          height: 48,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Image(image: AssetImage('assets/icon/icon.png')),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Welcome to Beam',
          style: TextStyle(
            color: Color.fromARGB(195, 0, 0, 0),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          'Beam is a global, digital wallet that lets you send money to anyone, anywhere, instantly. As easy as cash, but over the internet.',
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  },
  ({Key? incomingKey}) {
    return Column(
      key: incomingKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(
          height: 48,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Image(image: AssetImage('assets/icon/icon.png')),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Allow Notifications',
          style: TextStyle(
            color: Color.fromARGB(195, 0, 0, 0),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          "Allow notifications to receive valuable tips and insights directly to your device, keeping you informed",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  },
  ({Key? incomingKey}) {
    return Column(
      key: incomingKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(
          height: 48,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Image(image: AssetImage('assets/icon/icon.png')),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Allow Camera',
          style: TextStyle(
            color: Color.fromARGB(195, 0, 0, 0),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          "Grant camera access to easily scan payment QR codes and simplify your transactions. Enable now for smooth payment experiences and enhanced convenience.",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  },
  ({Key? incomingKey}) {
    return Column(
      key: incomingKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Happy Beaming',
          style: TextStyle(
            color: Color.fromARGB(195, 0, 0, 0),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          'Start beaming, to send and receive cash instantly',
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Center(
          child: SizedBox(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image(image: AssetImage('assets/icon/icon.png')),
            ),
          ),
        ),
      ],
    );
  },
];

List<Widget Function({Function? nextCard, Function? closeCards})>
    welcomeWidgetsButtons = [
  ({Function? nextCard, Function? closeCards}) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(48)),
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 51, 112, 255)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.transparent;
            }
            if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.pressed)) {
              return Colors.transparent;
            }
            return null; // Defer to the widget's default.
          },
        ),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      onPressed: () {
        nextCard!();
      },
      child: const Text(
        'Get started',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  },
  ({Function? nextCard, Function? closeCards}) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(48)),
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 51, 112, 255)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.transparent;
            }
            if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.pressed)) {
              return Colors.transparent;
            }
            return null; // Defer to the widget's default.
          },
        ),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      onPressed: () {
        nextCard!();
      },
      child: const Text(
        'Continue',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  },
  ({Function? nextCard, Function? closeCards}) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(48)),
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 51, 112, 255)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.transparent;
            }
            if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.pressed)) {
              return Colors.transparent;
            }
            return null; // Defer to the widget's default.
          },
        ),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      onPressed: () async {
        await Permission.camera.request();
        nextCard!();
      },
      child: const Text(
        'Continue',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  },
  ({Function? nextCard, Function? closeCards}) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(48)),
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 51, 112, 255)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.transparent;
            }
            if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.pressed)) {
              return Colors.transparent;
            }
            return null; // Defer to the widget's default.
          },
        ),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      onPressed: () async {
        closeCards!();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString('seenWelcomeSheet', "true");
      },
      child: const Text(
        'Done',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  },
];
