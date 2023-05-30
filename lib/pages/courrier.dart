import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'dart:async';
import 'package:flutter/services.dart';

class Courrier extends StatefulWidget {
  @override
  _CourrierState createState() => _CourrierState();
}

class _CourrierState extends State<Courrier> with TickerProviderStateMixin{
  late TextEditingController textEditingController;
  late bool isDarkMode;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _selectedImage;
  String? _userId;
  String? _Name;

  String _image = 'https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png';
  late AnimationController loadingController;

  List<File?> _file = [];
  List<PlatformFile?> _platformFile = [];


  // late final file;
  selectFile() async {
    // file = null;
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
        allowMultiple: true
    );
    _platformFile = [];
    _file = [];
    if (file != null) {

      for (int i = 0; i < file.files.length; i++) {
        setState(() {
          _file.add(File(file.files[i].path!));
          _platformFile.add(file.files[i]);
        });
        await _uploadImage();
      }
    }

    loadingController.forward();
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() { setState(() {}); });
    super.initState();
    super.initState();
    textEditingController = TextEditingController();
    getThemeMode();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }




  Future<String> _uploadImage() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage.refFromURL('gs://itec404deliveryapp.appspot.com');
      String fileName = Path.basename(_selectedImage!.path);
      Reference imageReference = storageReference.child('images/$fileName');
      UploadTask uploadTask = imageReference.putFile(_selectedImage!);

      TaskSnapshot taskSnapshot = await uploadTask;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      print("Image uploaded successfully. Download URL: $imageUrl");

      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw e; // Re-throw the error to be handled by the caller
    }
  }



  Future<void> _pickImage() async {
    try {
      PickedFile? pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
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
        'status': 'pending',
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Application Submitted'),
            content: Text('Your application has been submitted successfully.'),
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
                padding: const EdgeInsets.only(top:30,bottom: 15),
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
                    fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: selectFile,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                          color: Colors.blue.shade50.withOpacity(.3),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.folder_open, color: Colors.blue, size: 35,),
                          const SizedBox(height: 5),
                          Text('Select your file', style: TextStyle(fontSize: 15, color: Colors.grey.shade400),),
                          Text('File should be jpg, png', style: TextStyle(fontSize: 10, color: Colors.grey.shade500),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _platformFile.isNotEmpty
                  ? Container(
                // padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: const EdgeInsets.only(left:10, top:0, right:10, bottom:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected File',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 15, ),),
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                                spreadRadius: 2,
                              )
                            ]
                        ),
                        child:_platformFile.isNotEmpty?
                        ListView.builder(
                            physics:const NeverScrollableScrollPhysics(),
                            shrinkWrap:true,
                            itemCount: _platformFile.length,
                            itemBuilder: (context, index){
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(_file[index]!, width: 80, height: 60, fit: BoxFit.fill,)
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(_platformFile[index]!.name,
                                            style: const TextStyle(fontSize: 13, color: Colors.black),),
                                          const SizedBox(height: 5,),
                                          Text('${(_platformFile[index]!.size / 1024).ceil()} KB',
                                            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                                          ),
                                          const SizedBox(height: 5,),
                                          Container(
                                              height: 5,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.blue.shade50,
                                              ),
                                              child: LinearProgressIndicator(
                                                value: loadingController.value,
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                  ],
                                ),
                              );
                            }
                        )
                            : Container(),
                      ),
                    ],
                  ))
                  : Container(),
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
