import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:permission_handler/permission_handler.dart';

class QRCreatePage extends StatefulWidget {
  @override
  _QRCreatePageState createState() => _QRCreatePageState();
}

class _QRCreatePageState extends State<QRCreatePage> {
  late TextEditingController _controller;
  late GlobalKey _globalKey;
  late WidgetsToImageController controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _globalKey = GlobalKey();
    controller = WidgetsToImageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Generator"),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, TextEditingValue value, __) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetsToImage(
                      key: _globalKey,
                      controller: controller,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: QrImageView(
                          data: _controller.text.trim(),
                          foregroundColor: Colors.black,
                          size: 200,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Enter your secret data",
                        suffixIcon: IconButton(
                          onPressed: _captureAndShareImage,
                          icon: Icon(
                            Icons.share,
                            color: _controller.value.text.isNotEmpty
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onBackground,
                          ),
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _captureAndShareImage() async {
    Uint8List? bytes = await controller.capture();
    if (bytes != null) {
      try {
        final permissionStatus = await Permission.storage.status;
        await Permission.storage.request();

        if (permissionStatus.isDenied) {
          await Permission.storage.request();

          if (permissionStatus.isDenied) {
            await openAppSettings();
          }
        } else if (permissionStatus.isPermanentlyDenied) {
          await openAppSettings();
        } else {
          final directory = await getTemporaryDirectory();
          final file = File('${directory.path}/image.png');
          final savedFile = await file.writeAsBytes(bytes);

          await Share.shareXFiles(
            [
              XFile(savedFile.path),
            ],
          );
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }
}
