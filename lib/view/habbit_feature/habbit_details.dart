import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/view/alarm_feature/alarm_details.dart';
import 'package:habbits_manager/view/qr_code_feature/qr_code_get.dart';

class HabbitDetails extends StatelessWidget {
  final Habbit habbit;

  HabbitDetails(this.habbit);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        const Color(0xFFfdb561),
                        const Color(0xFF481550),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(
                        MediaQuery.of(context).size.width,
                        120.0,
                      ),
                      bottom: Radius.elliptical(
                        MediaQuery.of(context).size.width,
                        120.0,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.8),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    habbit.name,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.40),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    habbit.description,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.6),
                child: AlarmDetails(habbit.alarm),
              )
            ],
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: FloatingActionButton.extended(
                backgroundColor: Color(0xFFfdb561),
                onPressed: () {
                  _onShowQRCode(habbit, context);
                },
                label: const Text('Download QR code'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _onShowQRCode(Habbit habbit, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRCodeDownload(habbit);
      },
    );
  }
}
