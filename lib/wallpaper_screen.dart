import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpap/models/api_funtions.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dio/dio.dart';

class fullScreenWallPaper extends StatelessWidget {
  fullScreenWallPaper({@required this.index, @required this.no});
  int index;
  int no;
  _save() async {
    await _askPermission();
    var response = await Dio().get(
        no == 1 ? jsonList[index] : searchList[index],
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: "image_${no}_${index}");
    print(result);
  }

  _askPermission() async {
    Permission.storage.request();
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      print('hey');
      await Permission.storage.request();
    } else if (!status.isGranted) {
      print('hi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: Stack(children: [
          Container(
            height: double.infinity,
            color: Colors.red,
            child: FittedBox(
              fit: BoxFit.cover,
              child:
                  Image.network(no == 1 ? jsonList[index] : searchList[index]),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    _save();
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Download Image To Gallery',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
