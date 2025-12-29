import 'package:deliber/core/design/color_pallette.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title:  Text('We Chat',style: TextStyle(fontWeight: FontWeight.w700,color: const Color.fromARGB(255, 240, 240, 240))),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Pallete.gradient1,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){},
      backgroundColor: Pallete.gradient3,
      hoverColor: Pallete.gradient1,
      child: Icon(Icons.add_comment,size: 30,),
      ),
    );
  }
}