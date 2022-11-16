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

  static Future<bool> userExist(Map<String, Object> data) async {
    await ConectionMongodb.changeCollection('user');
    var d = await _userCollection?.findOne({'username': data['username']});
    if (d != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> placeExist(String? name) async {
    await ConectionMongodb.changeCollection('tbl_places');
    var d = await _userCollection?.findOne({'name': name});
    if (d != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> profileExist(String? name) async {
    await ConectionMongodb.changeCollection('tbl_profiles');
    var d = await _userCollection?.findOne({'name': name});
    if (d != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> userNameExist(String? username) async {
    await ConectionMongodb.changeCollection('user');
    var d = await _userCollection?.findOne({'username': username});
    if (d != null) {
      return true;
    } else {
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
    final profiles = await _userCollection?.find().toList();
    return profiles;
  }

  static Future<List<Map<String, dynamic>>?> getUsers() async {
    await ConectionMongodb.changeCollection('user');
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
}
