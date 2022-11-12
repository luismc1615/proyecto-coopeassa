import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/src/pages/menu/admin_menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/connection_mongodb.dart';
import '../../models/photosCuriosityDTO.dart';

class GalleryCuriosity extends StatefulWidget {
  static const String ROUTE = "/galleryCuriosity";
  var title;
  GalleryCuriosity(this.title);
  @override
  _GalleryCuriositylState createState() => _GalleryCuriositylState();
}

class _GalleryCuriositylState extends State<GalleryCuriosity> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late List<PhotosCuriosityDTO> itemsImageCuriosity = <PhotosCuriosityDTO>[];
  String curiositylId = '';
  String title = '';
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
    title = widget.title;
    super.initState();
    _onLoading();
  }

  static loadPreferences() async {
    SharedPreferences _curiosityId = await SharedPreferences.getInstance();
    var photosCuriosity = await ConectionMongodb.getImagesPetCuriosity(
        _curiosityId.getString('curiosityId'));
    return photosCuriosity;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen(2)));
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true, title: const Text("Gallery curiosity to")),
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
                  child: Text(title,
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
                          itemsImageCuriosity.isEmpty
                              ? const Center()
                              : Container(child: _swiper()),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 3, 72, 201)),
                            onPressed: () {
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
          task = uploadFile('curiosityGallery/${image.name}', File(image.path));
          if (task == null) return;
          final snapshot = await task.whenComplete(() {});
          urlPath = await snapshot.ref.getDownloadURL();
          SharedPreferences _curiosityId =
              await SharedPreferences.getInstance();
          await ConectionMongodb.changeCollection("photoscuriosity");
          await ConectionMongodb.insert({
            'photo': urlPath,
            'curiosity_id': _curiosityId.getString('curiosityId').toString(),
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
    itemsImageCuriosity = [];
    List<Map<String, dynamic>> myPhotosCuriosity = await loadPreferences();
    myPhotosCuriosity.forEach((element) {
      itemsImageCuriosity.add(PhotosCuriosityDTO(
          element['_id'], element['photo'], element['curiosity_id']));
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
                                      'photoscuriosity');
                                  await ConectionMongodb.delete(
                                      itemsImageCuriosity[index]
                                          .photoCuriositylId);
                                  _onLoading();
                                  SmartDialog.dismiss();
                                },
                                child: const Text("Yes")),
                            const SizedBox(width: 10),
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
              }, // Image tapped
              child: Image.network(
                itemsImageCuriosity[index].photo!,
                fit: BoxFit.scaleDown, // Fixes border issues
              ),
            );
          },
          itemCount: itemsImageCuriosity.length,
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
