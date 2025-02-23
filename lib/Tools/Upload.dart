import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as IMG;
import 'package:image_picker/image_picker.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

late Image gimage;

class Upload {
  static List<int> memStream = [];
  static late Uint8List? memImage;
  static late var image;

  static Future pickerCamera(String imagepath, VoidCallback onSetState) async {
    print("UploadFilePicker A $imagepath");
    final picker = ImagePicker();
    print("UploadFilePicker B");

    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 400,
      maxHeight: 400,
    );

    if (pickedImage == null) return;
    var streamthumbnail = await pickedImage.readAsBytes();
    IMG.Image? image = IMG.decodeImage(streamthumbnail);
    memStream = IMG.encodePng(image!);

    print("UploadFilePicker memStream.lenght ${memStream.length}");

    Srv_DbTools.setSrvToken();
    String wPath = Srv_DbTools.SrvUrl;
    var uri = Uri.parse(wPath.toString());
    var request = http.MultipartRequest("POST", uri);
    request.fields.addAll({
      'tic12z': Srv_DbTools.SrvToken,
      'zasq': 'uploadphoto',
      'imagepath': imagepath,
    });

    var multipartFile = http.MultipartFile.fromBytes('uploadfile', memStream, filename: basename("xxx.jpg"));
    request.files.add(multipartFile);
    var response = await request.send();
    print("uploadfile statusCode ${response.statusCode}");

    response.stream.transform(utf8.decoder).listen((value) {
      print("value $value");
      print("Fin $imagepath");
      onSetState();
      print("Fin Fin" );
    });
  }

  static Future SaveMem(String imagepath, Uint8List wImageByte) async {
    IMG.Image? image = IMG.decodeImage(wImageByte);
    IMG.Image thumbnail = IMG.copyResize(
      image!,
      width: 300,
      height: 300,
    );
    memStream = IMG.encodePng(thumbnail);
    Srv_DbTools.setSrvToken();
    String wPath = Srv_DbTools.SrvUrl;
    var uri = Uri.parse(wPath.toString());
    var request = http.MultipartRequest("POST", uri);
    request.fields.addAll({
      'tic12z': Srv_DbTools.SrvToken,
      'zasq': 'uploadphoto',
      'imagepath': imagepath,
    });

    var multipartFile = http.MultipartFile.fromBytes('uploadfile', memStream, filename: basename("xxx.jpg"));
    request.files.add(multipartFile);
    var response = await request.send();
    print("uploadfile statusCode ${response.statusCode}");

    response.stream.transform(utf8.decoder).listen((value) {
      print("value $value");
      print("Fin $imagepath");
    });
  }


  static Future SaveMem400(String imagepath, Uint8List wImageByte) async {
    IMG.Image? image = IMG.decodeImage(wImageByte);
    IMG.Image thumbnail = IMG.copyResize(
      image!,
      width: 400,
      height: 400,
    );
    memStream = IMG.encodePng(thumbnail);
    Srv_DbTools.setSrvToken();
    String wPath = Srv_DbTools.SrvUrl;
    var uri = Uri.parse(wPath.toString());
    var request = http.MultipartRequest("POST", uri);
    request.fields.addAll({
      'tic12z': Srv_DbTools.SrvToken,
      'zasq': 'uploadphoto',
      'imagepath': imagepath,
    });

    var multipartFile = http.MultipartFile.fromBytes('uploadfile', memStream, filename: basename("xxx.jpg"));
    request.files.add(multipartFile);
    var response = await request.send();
    print("uploadfile statusCode ${response.statusCode}");

    response.stream.transform(utf8.decoder).listen((value) {
      print("value $value");
      print("Fin $imagepath");
    });
  }
/*

  static Future<void> UploadFilePicker(String imagepath, VoidCallback onSetState) async {
    print("UploadFilePicker $imagepath");

    String wImgPath = Srv_DbTools.SrvImg + imagepath;
    PaintingBinding.instance.imageCache.clear();
    imageCache.clear();
    imageCache.clearLiveImages();
    await DefaultCacheManager().emptyCache(); //clears all data in cache.
    await DefaultCacheManager().removeFile(wImgPath);

    PlatformFilePicker().startWebFilePicker((files) async {
      Srv_DbTools.setSrvToken();
      print("Deb");
      print("imagepath $imagepath");
      FlutterWebFile file = files[0];
      print("file " + file.file.name);
      var stream = file.fileBytes;

      String wPath = Srv_DbTools.SrvUrl;
      var uri = Uri.parse(wPath.toString());
      var request = new http.MultipartRequest("POST", uri);
      request.fields.addAll({
        'tic12z': Srv_DbTools.SrvToken,
        'zasq': 'uploadphoto',
        'imagepath': imagepath,
      });

      var multipartFile = new http.MultipartFile.fromBytes('uploadfile', stream, filename: basename("xxx.jpg"));
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print("value " + value);
        print("Fin");

        Srv_DbTools.notif.BroadCast();
        onSetState();

      });
    });
  }
  static Future<void> UploadDocPicker(String imagepath, VoidCallback onSetState) async {
    print("UploadDocPicker $imagepath");

    String wImgPath = Srv_DbTools.SrvImg + imagepath;
    PaintingBinding.instance.imageCache.clear();
    imageCache.clear();
    imageCache.clearLiveImages();
    await DefaultCacheManager().emptyCache(); //clears all data in cache.
    await DefaultCacheManager().removeFile(wImgPath);

    PlatformFilePicker().startWebDocPicker((files) async {
      Srv_DbTools.setSrvToken();
      print("Deb");
      print("imagepath $imagepath");
      FlutterWebFile file = files[0];
      print("file " + file.file.name);
      var stream = file.fileBytes;

      String wPath = Srv_DbTools.SrvUrl;
      var uri = Uri.parse(wPath.toString());
      var request = new http.MultipartRequest("POST", uri);
      request.fields.addAll({
        'tic12z': Srv_DbTools.SrvToken,
        'zasq': 'uploadphoto',
        'imagepath': imagepath,
      });

      var multipartFile = new http.MultipartFile.fromBytes('uploadfile', stream, filename: basename("xxx.jpg"));
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print("value " + value);
        print("Fin");
        Srv_DbTools.notif.BroadCast();
        onSetState();

      });
    });
  }

*/
}
