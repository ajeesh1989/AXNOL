import 'package:axnol_machinetask/screens/camera_page.dart';
import 'package:axnol_machinetask/screens/const.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: Center(
        child: Container(
          height: 60,
          width: 140,
          decoration: BoxDecoration(
            border: Border.all(
              color: blackColor,
              width: 5,
            ),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraPage()),
              );
            },
            child: const Text(
              'START',
              style: TextStyle(
                  color: blackColor, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
