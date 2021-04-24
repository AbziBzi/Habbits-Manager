import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

class QRCodeDownload extends StatelessWidget {
  final Habbit habbit;

  QRCodeDownload(this.habbit);

  @override
  Widget build(BuildContext context) {
    final String qrData = _getQRCodeData(habbit);
    return AlertDialog(
      content: Container(
        width: 150,
        height: 310,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImage(
              data: qrData,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: FloatingActionButton(
                backgroundColor: Color(0xFFfdb561),
                onPressed: () {
                  _onSave(qrData, context);
                },
                child: Icon(
                  Icons.download_rounded,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getQRCodeData(Habbit habbit) {
    return '${habbit.id}';
  }

  Future<String> createQrPicture(String qr) async {
    final qrValidationResult = QrValidator.validate(
      data: qr,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode;

      final painter = QrPainter.withQr(
        qr: qrCode,
        color: const Color(0xFFFFFFFF),
        gapless: true,
        embeddedImageStyle: null,
        embeddedImage: null,
      );

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      String path = '$tempPath/$ts.png';

      final picData =
          await painter.toImageData(2048, format: ImageByteFormat.png);
      await writeToFile(picData, path);
      return path;
    }
    return null;
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  _onSave(String qrData, BuildContext context) async {
    if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    } else if (await Permission.storage.request().isGranted) {
      String path = await createQrPicture(qrData);

      await Share.shareFiles([path],
          mimeTypes: ["image/png"],
          subject: 'My QR code',
          text: 'Please scan me');
      Navigator.pop(context);
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]);
    }
  }
}
