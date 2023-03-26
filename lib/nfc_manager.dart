import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:typed_data';

class NfcReder extends StatefulWidget {
  NfcReder({super.key});

  @override
  State<NfcReder> createState() => _NfcRederState();
}

class _NfcRederState extends State<NfcReder> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _tagRead();
  }

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
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.all(4),
                          constraints: BoxConstraints.expand(),
                          decoration: BoxDecoration(border: Border.all()),
                          child: SingleChildScrollView(
                            child: ValueListenableBuilder<dynamic>(
                              valueListenable: result,
                              builder: (context, value, _) => Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Center(child: Text("${value ?? ' '}")),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 12,
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child:
                                        const Text("Silahkan tempelkan kartu")),
                              ],
                            )
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
      // print('tag : ${tag.data}');
      String identifier = tag.data['nfca']['identifier']
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join(':');
      // print(identifier);
      result.value = identifier;
      await NfcManager.instance.stopSession();
      _tagRead();
    });
  }
}
