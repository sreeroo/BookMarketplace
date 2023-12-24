import 'dart:convert';
import 'package:flutter/material.dart';

MemoryImage? imageFromBase64String(String base64String) {
  if (base64String.isNotEmpty) {
    return MemoryImage(
      base64Decode(base64String),
    );
  }
  return null;
}
