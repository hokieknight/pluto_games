import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget? handleSnapshot(
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
    String name) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  if (!snapshot.hasData) {
    return Center(
      child: Text('$name not found.'),
    );
  }

  if (snapshot.hasError) {
    return const Center(
      child: Text('Something went wrong...'),
    );
  }
  return null;
}
