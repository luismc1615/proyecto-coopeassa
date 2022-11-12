import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/src/models/photosTravelDTO.dart';
import 'package:mobile_project/src/pages/menu/admin_menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../models/connection_mongodb.dart';

class GalleryTravel extends StatefulWidget {
  static const String ROUTE = "/galleryTravel";
  var place;
  GalleryTravel(this.place);
  @override
  _GalleryTravelState createState() => _GalleryTravelState();
}

class _GalleryTravelState extends State<GalleryTravel> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late List<PhotosTravelDTO> itemsImageTravel = <PhotosTravelDTO>[];
  String travelId = '';
  String place = '';
  String urlPath = '';
  final ImagePicker _imagePicker = ImagePicker();
  final storage =
      FirebaseStorage.instanceFor(bucket: 'gs://homepets-c02ac.appspot.com')
          .ref();

  void setUrlPath(String urlPathInfo) {
    urlPath = urlPathInfo;
  }

  @override
  void initState() {
    place = widget.place;
    super.initState();
    _onLoading();
  }

  static loadPreferences() async {
    SharedPreferences _travelId = await SharedPreferences.getInstance();
    var photosTravel = await ConectionMongodb.getImagesPetWalks(
        _travelId.getString('travelId'));
    return photosTravel;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen(1)));
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true, title: const Text("Gallery travel to")),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text('Note: Press twice to delete the image',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(place,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          itemsImageTravel.isEmpty
                              ? const Center()
                              : Container(child: _swiper()),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 3, 72, 201)),
                            onPressed: () async {
                              SmartDialog.show(builder: (context) {
                                return Container(
                                  height: 107,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          ElevatedButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        25, 150, 125, 1)),
                                            onPressed: () {
                                              openGalery();
                                              SmartDialog.dismiss();
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text('Select photo'),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Icon(
                                                  Icons.image,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        25, 150, 125, 1)),
                                            onPressed: () {
                                              openCamera();
                                              SmartDialog.dismiss();
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text('Take photo'),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.camera,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                );
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Add'),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.image,
                                  size: 24.0,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }

  Future openGalery() async {
    urlPath = '';
    UploadTask? task;
    if (await Permission.storage.request().isGranted) {
      XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        SmartDialog.showLoading();
        try {
          task = uploadFile('travelsGallery/${image.name}', File(image.path));
          if (task == null) return;
          final snapshot = await task.whenComplete(() {});
          urlPath = await snapshot.ref.getDownloadURL();
          SharedPreferences _travelId = await SharedPreferences.getInstance();
          await ConectionMongodb.changeCollection("photostravel");
          await ConectionMongodb.inserData({
            'photo': urlPath,
            'travel_id': _travelId.getString('travelId').toString(),
          });
          setState(() {
            _onLoading();
          });
          // ignore: empty_catches
        } catch (error) {}
        SmartDialog.dismiss();
      }
    } else {
      Permission.storage.request();
    }
  }

  Future openCamera() async {
    UploadTask? task;
    if (await Permission.camera.request().isGranted) {
      XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        SmartDialog.showLoading();
        try {
          task = uploadFile('image/${image.name}', File(image.path));
          if (task == null) return;
          final snapshot = await task.whenComplete(() {});
          urlPath = await snapshot.ref.getDownloadURL();
          setState(() {});
        } catch (error) {
          print('Error-> $error');
        }
        SmartDialog.dismiss();
      }
    } else {
      Permission.storage.request();
    }
  }

  UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  void _onLoading() async {
    itemsImageTravel = [];
    List<Map<String, dynamic>> myPhotosWalk = await loadPreferences();
    myPhotosWalk.forEach((element) {
      itemsImageTravel.add(PhotosTravelDTO(
          element['_id'], element['photo'], element['travel_id']));
    });
    if (mounted) setState(() {});
  }

  Widget _swiper() {
    return SizedBox(
      width: double.infinity,
      height: 500.0,
      child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onDoubleTap: () async {
                SmartDialog.show(builder: (context) {
                  return Container(
                    height: 120,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Column(children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: const Text("Do you want to delete the image?",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                                style: TextButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(25, 150, 125, 1)),
                                onPressed: () async {
                                  await ConectionMongodb.changeCollection(
                                      'photostravel');
                                  await ConectionMongodb.delete(
                                      itemsImageTravel[index].photoTravelId);
                                  _onLoading();
                                  SmartDialog.dismiss();
                                },
                                child: const Text("Yes")),
                            SizedBox(width: 10),
                            ElevatedButton(
                                style: TextButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 252, 1, 1)),
                                onPressed: () {
                                  SmartDialog.dismiss();
                                },
                                child: const Text("No")),
                          ],
                        ),
                      ),
                    ]),
                  );
                });
              },
              child: Image.network(
                itemsImageTravel[index].photo!,
                fit: BoxFit.scaleDown, // Fixes border issues
              ),
            );
          },
          itemCount: itemsImageTravel.length,
          scale: 0.9,
          viewportFraction: 0.8,
          pagination: const SwiperPagination(),
          control: const SwiperControl(),
          loop: false,
          autoplay: false,
          index: 0),
    );
  }
}
