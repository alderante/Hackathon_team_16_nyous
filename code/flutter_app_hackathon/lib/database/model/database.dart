// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:developer';

class Database {
  static String? _newsId;
  static String? _body;

  static String? get newsId => _newsId;
  static String? get body => _body;

  Database._();

  static String? setNewsId({String? newsId}) {
    _newsId = newsId ?? _newsId;
    return newsId;
  }

  //* Get the body from hack_news using newsId
  static Future<String>? getBodyById({String? newsId}) {
    _newsId = newsId ?? _newsId;

    if (_newsId == null) {
      return null;
    }
    // log('NewsId: $_newsId');

    return FirebaseFirestore.instance
      .collection('hack_news')
      .doc(newsId).get()
      .then((data) {
        _body = data['body'];
        // News body on Success
        return data['body'];
      },
      // Error Management
      onError: (e) {
        return 'Error DB: $e';
      }
    );
  }
}