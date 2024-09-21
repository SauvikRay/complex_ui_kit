import 'package:flutter/material.dart';

class MyFirstScreen extends StatefulWidget {
  const MyFirstScreen({super.key, this.appbarName});

  final String? appbarName;

  @override
  State<MyFirstScreen> createState() => _MyFirstScreenState();
}

class _MyFirstScreenState extends State<MyFirstScreen> {
  late int initValue;
  @override
  void initState() {
    initValue = 0;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant MyFirstScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _increment() {
    initValue++;
    setState(() {});
  }

_decrement(){
     initValue--;
    setState(() {});
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appbarName ?? 'First Scrren'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _increment();
                  },
                  icon: Icon(Icons.add),
                ),
                SizedBox(
                  width: 20,
                ),
                Text('$initValue'),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () {
                    _decrement();
                  },
                  icon: Icon(Icons.remove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
