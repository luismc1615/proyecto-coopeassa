import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/imagesPlacesDTO.dart';
import 'package:mobile_project/src/pages/menu/client_menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryPlace extends StatefulWidget {
  static const String ROUTE = "/GalleryPlace";
  var name;
  GalleryPlace(this.name);
  @override
  _GalleryPlaceState createState() => _GalleryPlaceState();
}

class _GalleryPlaceState extends State<GalleryPlace> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late List<ImagesPlacesDTO> itemsImagesPlaces = <ImagesPlacesDTO>[];
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
    var placeImages =
        await ConectionMongodb.getPlaceImages(_placeId.getString('placeId'));
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
            appBar: AppBar(centerTitle: true, title: const Text("Galería de:")),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }

  void _onLoading() async {
    itemsImagesPlaces = [];
    List<Map<String, dynamic>> myPlaceImages = await loadPreferences();
    myPlaceImages.forEach((element) {
      itemsImagesPlaces.add(
          ImagesPlacesDTO(element['_id'], element['img'], element['placeId']));
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
