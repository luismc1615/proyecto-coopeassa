import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/imagesPlacesDTO.dart';
import 'package:mobile_project/src/pages/menu/admin_menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacesGalleryForm extends StatefulWidget {
  static const String ROUTE = "/PlacesGalleryForm";
  var name;
  PlacesGalleryForm(this.name);
  @override
  _PlacesGalleryFormState createState() => _PlacesGalleryFormState();
}

class _PlacesGalleryFormState extends State<PlacesGalleryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late List<ImagesPlacesDTO>itemsImagesPlaces = <ImagesPlacesDTO>[];
  String placeId = '';
  String name = '';
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
    name = widget.name;
    super.initState();
    _onLoading();
  }

  static loadPreferences() async {
    SharedPreferences _placeId = await SharedPreferences.getInstance();
    var placeImages = await ConectionMongodb.getPlaceImages(
        _placeId.getString('placeId'));
    return placeImages;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen(0)));
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true, title: const Text("Galería de:")),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Nota: Doble toque para eliminar imágenes',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center),
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
                          itemsImagesPlaces.isEmpty
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
                                                Text('Seleccionar imagen'),
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
                                                Text('Tomar foto'),
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
                                Text('Añadir imagen'),
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
          task = uploadFile('imagesPlaces/${image.name}', File(image.path));
          if (task == null) return;
          final snapshot = await task.whenComplete(() {});
          urlPath = await snapshot.ref.getDownloadURL();
          SharedPreferences _placeId = await SharedPreferences.getInstance();
          await ConectionMongodb.changeCollection("tbl_images_places");
          await ConectionMongodb.insert({
            'img': urlPath,
            'placeId': _placeId.getString('placeId').toString(),
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
          task = uploadFile('imagesPlaces/${image.name}', File(image.path));
          if (task == null) return;
          final snapshot = await task.whenComplete(() {});
          urlPath = await snapshot.ref.getDownloadURL();
          SharedPreferences _placeId = await SharedPreferences.getInstance();
          await ConectionMongodb.changeCollection("tbl_images_places");
          await ConectionMongodb.insert({
            'img': urlPath,
            'placeId': _placeId.getString('placeId').toString(),
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

  UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  void _onLoading() async {
    itemsImagesPlaces = [];
    List<Map<String, dynamic>> myPlaceImages = await loadPreferences();
    myPlaceImages.forEach((element) {
      itemsImagesPlaces.add(ImagesPlacesDTO(
          element['_id'], element['img'], element['placeId']));
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
                        child: const Text("¿Desea eliminar la imagen?",
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
                                      'tbl_images_places');
                                  await ConectionMongodb.delete(
                                      itemsImagesPlaces[index].imgPlaceId);
                                  _onLoading();
                                  SmartDialog.dismiss();
                                },
                                child: const Text("Sí")),
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
                itemsImagesPlaces[index].img!,
                fit: BoxFit.scaleDown, // Fixes border issues
              ),
            );
          },
          itemCount: itemsImagesPlaces.length,
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
