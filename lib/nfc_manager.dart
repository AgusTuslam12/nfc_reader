import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:typed_data';
import 'package:number_system/number_system.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcReder extends StatefulWidget {
  NfcReder({super.key});

  @override
  State<NfcReder> createState() => _NfcRederState();
}

class _NfcRederState extends State<NfcReder> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  String _identifier = 'Waiting for NFC tag...';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('NfcManager Plugin Example')),
        body: SafeArea(
          child: FutureBuilder<bool>(
            future: NfcManager.instance.isAvailable(),
            builder: (context, ss) => ss.data != true
                ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
                : Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.vertical,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.all(4),
                          constraints: BoxConstraints.expand(),
                          decoration: BoxDecoration(border: Border.all()),
                          child: SingleChildScrollView(
                            child: ValueListenableBuilder<dynamic>(
                              valueListenable: result,
                              builder: (context, value, _) =>
                                  Text("${value ?? ' '}"),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: GridView.count(
                          padding: EdgeInsets.all(4),
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          children: [
                            ElevatedButton(
                                child: Text('Tag Read'), onPressed: _tagRead),
                            ElevatedButton(
                                child: Text('test'), onPressed: _test),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      // result.value = tag.data.toString();
      print('tag : ${tag.data}');
      String identifier = tag.data['nfca']['identifier']
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join(':');
      print(identifier);
      result.value = identifier;

      NfcManager.instance.stopSession();
    });
  }

  void _test() {
    print('object');
  }
}
