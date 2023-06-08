import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:file_picker/file_picker.dart' as file_picker;


class Courrier extends StatefulWidget {
  @override
  _CourrierState createState() => _CourrierState();
}

class _CourrierState extends State<Courrier> with TickerProviderStateMixin {
  final TextEditingController textEditingController = TextEditingController();

  late bool isDarkMode;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _selectedImage;
  String? _userId;
  String? _Name;
  String? _downloadUrl;

  String _image =
      'https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png';
  late AnimationController loadingController;

  List<File?> _file = [];
  List<PlatformFile?> _platformFile = [];

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
      setState(() {});
    });
    super.initState();
    super.initState();
    getThemeMode();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    if (kIsWeb) {
      final result = await file_picker.FilePicker.platform.pickFiles();

      if (result != null) {
        final file = result.files.first;

        final fileName = file.name;
        final fileSize = file.size;
        final bytes = file.bytes!;

        firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('uploads/$fileName');
        firebase_storage.UploadTask uploadTask = ref.putData(bytes);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        final fileSizeInBytes = fileSize;
        final fileSizeInMB = fileSizeInBytes / 1048576;

        setState(() {
          _downloadUrl = downloadUrl;
          _selectedFileName = fileName;
          _selectedFileSize = fileSizeInMB.toStringAsFixed(2) +
              ' MB';
        });
      } else {

      }
    } else {

      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) return;

      File file = File(pickedFile.path);
      String compressedPath = await convertImageToWebP(file.path);
      File compressedFile = File(compressedPath);

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('uploads/${file.path.split('/').last}');
      firebase_storage.UploadTask uploadTask = ref.putFile(compressedFile);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      int fileSizeInBytes = compressedFile.lengthSync();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      setState(() {
        _downloadUrl = downloadUrl;
        _selectedFileName = file.path.split('/').last;
        _selectedFileSize = fileSizeInMB.toStringAsFixed(2);
      });

    }
  }

  Future<String> convertImageToWebP(String imagePath) async {
    final compressedPath =
        (await getTemporaryDirectory()).path + '/compressed.webp';

    await FlutterImageCompress.compressAndGetFile(
      imagePath,
      compressedPath,
      quality: 90,
      format: CompressFormat.webp,
    );

    return compressedPath;
  }

  String _selectedFileName = '';
  String _selectedFileSize = '';

  Future<void> _pickImage() async {
    try {
      PickedFile? pickedFile =
      await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        print("Selected image: $_selectedImage");
      }
    } on PlatformException catch (e) {
      print('Error picking image: $e');
    }
  }

  void saveApplication() async {
    String? reason = textEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? name = prefs.getString('name');
    String? phoneNumber = prefs.getString('phone_number');

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('applications')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Duplicate Application'),
            content: Text('An application with this email already exists.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      FirebaseFirestore.instance.collection('applications').add({
        'email': email,
        'name': name,
        'phone_number': phoneNumber,
        'status': 'Pending',
        'imageUrls': _downloadUrl,
        'reason': reason,
      });
      textEditingController.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Application Submitted'),
            content:
            Text('Your application has been submitted successfully.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: <Widget>[
            Text(
              "Courier",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 22,
                color: Color(0xffffffff),
              ),
            ),
            Text(
              "Application",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 22,
                color: Color(0xfffba808),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 15),
                child: Text(
                  "Become a Courier",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: isDarkMode ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
              Text(
                "Tell us about yourself and why you want to become a rider:",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.grey[700],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: textEditingController,
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: "Enter Text",
                    filled: true,
                    fillColor:
                    isDarkMode ? Colors.grey[700] : Colors.grey[200],
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Upload Document",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.grey[700],
                ),
              ),
              GestureDetector(
                onTap: () {
                  uploadImage();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [10, 4],
                    strokeCap: StrokeCap.round,
                    color: Colors.blue.shade400,
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                          color:
                          Colors.blue.shade50.withOpacity(.3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.folder_open,
                            color: Colors.blue,
                            size: 35,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Select your file',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade400),
                          ),
                          Text(
                            'File should be jpg, png',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_downloadUrl != null)
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected File',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:  isDarkMode ? Colors.grey[700] : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              offset: Offset(0, 1),
                              blurRadius: 3,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        _downloadUrl!,
                                        height: 75,
                                        width: 70,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Flexible(
                                      child: Text(
                                        'File Name: $_selectedFileName\n' +
                                            'File Size: $_selectedFileSize MB',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:  isDarkMode ? Colors.white : Colors.grey[700]
                                        ),
                                      ),
                                    ),
                                  ]),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 5,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.blue.shade50,
                                    ),
                                    child: LinearProgressIndicator(
                                      value: loadingController.value,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              MaterialButton(
                onPressed: saveApplication,
                color: isDarkMode ? const Color(0xfff80707) : const Color(0xff3a57e8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  "APPLY NOW!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                height: 50,
                minWidth: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
