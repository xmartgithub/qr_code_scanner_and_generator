import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCreatePage extends StatefulWidget {
  @override
  _QRCreatePageState createState() => _QRCreatePageState();
}

class _QRCreatePageState extends State<QRCreatePage> {
  final controller = TextEditingController();

  // final GlobalKey globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QR Code Generator",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xFF1139a0),
      ),
      backgroundColor: Color(0xff00298a),
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF1139a0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: QrImage(
                    data: controller.text,
                    foregroundColor: Colors.white,
                    size: 200,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                // IconButton(onPressed: _captureAndSharePng,icon: Icon(Icons.share,color: Colors.white,)),
                buildTextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField() {
    return TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      controller: controller,
      decoration: InputDecoration(
        hintText: "Enter your secret data",
        hintStyle: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {});
          },
          icon: Icon(Icons.check),
          color: Theme.of(context).accentColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.teal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 2.0),
        ),
      ),
    );
  }

// Future<void> _captureAndSharePng() async {
//   try {
//     RenderRepaintBoundary? boundary = globalKey.currentContext!
//         .findRenderObject() as RenderRepaintBoundary?;
//     var image = await boundary!.toImage();
//     ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
//     Uint8List pngBytes = byteData!.buffer.asUint8List();
//
//     final tempDir = await getTemporaryDirectory();
//     final file = await new File('${tempDir.path}/image.png').create();
//     await file.writeAsBytes(pngBytes);
//
//     await FlutterShare.shareFile(
//         title: controller.text,
//         filePath: file.path.toString(),
//         fileType: 'image/png');
//   } catch (e) {
//     print(e.toString());
//   }
// }
}
