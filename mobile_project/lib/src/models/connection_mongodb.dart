import 'dart:developer';
import 'package:mobile_project/src/utils/Toast.dart';
import 'package:mobile_project/src/utils/aes.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConectionMongodb {
  static final ConectionMongodb _instance = ConectionMongodb._instance;
  static Db? _db;
  static DbCollection? _userCollection;

  static connect() async {
    _db = await Db.create(_getUrlConection());
    await _db!.open();
    inspect(_db);
  }

  static String _getUrlConection() {
    return "mongodb+srv://andres7xd:andreslol1098@cluster0.aj0ig.mongodb.net/bd_home_pets?authSource=admin&replicaSet=atlas-111d23-shard-0&w=majority&readPreference=primary&retryWrites=true&ssl=true";
  }

  static changeCollection(String nameCollection) {
    _userCollection = _db!.collection(nameCollection);
  }

  static closeConection() {
    _db!.close();
  }

  static insert(Map<String, Object> data) {
    _userCollection!.insert(data);
  }

  static delete(ObjectId? id) async {
    await _userCollection!.remove(where.id(id!));
  }

  static update(Map<String, Object> id, Map<String, Object> data) async {
    await _userCollection!.update(id, data);
  }

  static Future<bool> userExist(Map<String, Object> data) async {
    await ConectionMongodb.changeCollection('user');
    var d = await _userCollection?.findOne({'username': data['username']});
    if (d != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> placeExist(Map<String, Object> data) async {
    await ConectionMongodb.changeCollection('user');
    var d = await _userCollection?.findOne({'username': data['username']});
    if (d != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> login(Map<String, Object> data) async {
    var d = await _userCollection?.findOne({'username': data['username']});
    if (d != null) {
      if (Aes.mtdecrypt(d['password']) == data['password']) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString('id', d['_id'].toString());
        print(d);
        return true;
      } else {
        ToastType.error("Contraseña incorrecta");
        return false;
      }
    } else {
      ToastType.error("Usuario no encontrado");
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>?> getPlaces() async {
    await ConectionMongodb.changeCollection('tbl_places');
    final places = await _userCollection?.find().toList();
    return places;
  }

  static Future<List<Map<String, dynamic>>?> getPlaceImages(
      String? placeId) async {
    await ConectionMongodb.changeCollection('tbl_images_places');
    final d = await _userCollection?.find({'placeId': placeId}).toList();
    return d;
  }

  static Future<List<Map<String, dynamic>>?> getProfiles() async {
    await ConectionMongodb.changeCollection('tbl_profiles');
    final users = await _userCollection?.find().toList();
    return users;
  }

  static Future<List<Map<String, dynamic>>?> getReservations() async {
    await ConectionMongodb.changeCollection('tbl_reservations');
    final reservations = await _userCollection?.find().toList();
    return reservations;
  }

  static Future<List<Map<String, dynamic>>?> getMessages() async {
    await ConectionMongodb.changeCollection('tbl_messages');
    final users = await _userCollection?.find().toList();
    return users;
  }

  ///////////////////////////////////////////////////////////////////////////

  static Future<List<Map<String, dynamic>>?> getPets(String? userId) async {
    await ConectionMongodb.changeCollection('pets');
    final d = await _userCollection?.find({'user_id': userId}).toList();
    return d;
  }

  static Future<List<Map<String, dynamic>>?> getPetsWalk(String? userId) async {
    await ConectionMongodb.changeCollection('petwalk');
    final d = await _userCollection?.find({'user_id': userId}).toList();
    return d;
  }

  static Future<List<Map<String, dynamic>>?> getPetsCuriosity(
      String? userId) async {
    await ConectionMongodb.changeCollection('curiositiespet');
    final d = await _userCollection?.find({'user_id': userId}).toList();
    return d;
  }

  static Future<List<Map<String, dynamic>>?> getImagesPetWalks(
      String? travelId) async {
    await ConectionMongodb.changeCollection('photostravel');
    final d = await _userCollection?.find({'travel_id': travelId}).toList();
    return d;
  }

  static Future<List<Map<String, dynamic>>?> getImagesPetCuriosity(
      String? curiosityId) async {
    await ConectionMongodb.changeCollection('photoscuriosity');
    final d =
        await _userCollection?.find({'curiosity_id': curiosityId}).toList();
    return d;
  }

  static Future<List<Map<String, dynamic>>?> getRelationshipsPets(
      String? petId) async {
    await ConectionMongodb.changeCollection('relationshipspets');
    final d = await _userCollection?.find({'pet_id': petId}).toList();
    return d;
  }
}
