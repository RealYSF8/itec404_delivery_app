import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class MakeOrderPage extends StatefulWidget {
  @override
  State<MakeOrderPage> createState() => _Order();
}

class _Order extends State<MakeOrderPage> with TickerProviderStateMixin {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<File?> _selectedImages = List.generate(3, (_) => null);

  Future<void> _uploadImages() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference =
      storage.refFromURL('gs://itec404deliveryapp.appspot.com');

      for (int i = 0; i < _selectedImages.length; i++) {
        File? selectedImage = _selectedImages[i];
        if (selectedImage != null) {
          String fileName = Path.basename(selectedImage.path);

          // Convert image to WebP format
          String compressedPath = await convertImageToWebP(selectedImage.path);

          Reference imageReference =
          storageReference.child('images/$fileName.webp');

          // Upload the converted image
          UploadTask uploadTask = imageReference.putFile(File(compressedPath));

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            double progress =
                (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
            print("Upload progress: $progress%");
          }, onError: (Object e) {
            print("Error during upload: $e");
          });

          TaskSnapshot taskSnapshot = await uploadTask;

        }
      }
    } catch (e) {
      print("Error uploading images: $e");
    }
  }

  Future<String> convertImageToWebP(String imagePath) async {
    // Compressed image file path
    final compressedPath =
        (await getTemporaryDirectory()).path + '/compressed.webp';

    // Compress the image to WebP format
    await FlutterImageCompress.compressAndGetFile(
      imagePath,
      compressedPath,
      quality: 90,
      format: CompressFormat.webp,
    );

    return compressedPath;
  }


  Future<void> _pickImage(int index) async {
    try {
      PickedFile? pickedFile =
      await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImages[index] = File(pickedFile.path);
        });
        print("Selected image $index: ${_selectedImages[index]}");
      }
    } on PlatformException catch (e) {
      print('Error picking image: $e');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String? _userId;
  String? _Name;
  String? _Email;


  String _image =
      'https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png';
  late AnimationController loadingController;

  File? _file;
  PlatformFile? _platformFile;

  selectFile() async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);

    if (file != null) {
      setState(() {
        _file = File(file.files.single.path!);
        _platformFile = file.files.first;
      });
    }

    loadingController.forward();
  }

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
    getNameFromSharedPreferences();
    _getUserData();
  }

  void getNameFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _Name = prefs.getString("name") ?? "";
      _Email = prefs.getString("email") ?? "";

    });
  }

  Future<void> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  Future<void> _createOrder() async {
    // Get the data from the input fields
    String? from = fromController.text;
    String? to = toController.text;
    String? length = lengthController.text;
    String? width = widthController.text;
    String? height = heightController.text;

    // Upload the images before creating the order
    await _uploadImages();

    // Get the current date and time
    Timestamp now = Timestamp.now();

    // Create a new order document with the data and timestamp
    DocumentReference orderRef = await _db.collection('orders').add({
      'createdBy': _Email,
      'userId': _userId,
      'Name': _Name,
      'from': from,
      'to': to,
      'length': length,
      'width': width,
      'height': height,
      'status': 'pending',
      'createdAt': now,
    });

    // Update the order document with the image URLs
    for (int i = 0; i < _selectedImages.length; i++) {
      File? selectedImage = _selectedImages[i];
      if (selectedImage != null) {
        String fileName = Path.basename(selectedImage.path);
        String imageUrl = await _uploadImageToFirebaseStorage(selectedImage, fileName);
        orderRef.update({'imageUrls.$i': imageUrl});
      }
    }

    // Clear the input fields
    fromController.clear();
    toController.clear();
    lengthController.clear();
    widthController.clear();
    heightController.clear();

    // Clear the selected images
    setState(() {
      _selectedImages = List.generate(3, (_) => null);
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Created'),
          content: Text('Your order has been created.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String> _uploadImageToFirebaseStorage(File imageFile, String fileName) async {
    try {
      String compressedPath = await convertImageToWebP(imageFile.path);
      Reference storageReference = _storage.ref().child('images/$fileName.webp');
      UploadTask uploadTask = storageReference.putFile(File(compressedPath));
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw e;
    }
  }



  int _selectedIndex = 1;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home Page',
      style: optionStyle,
    ),
    Text(
      'Order Page',
      style: optionStyle,
    ),
    Text(
      'Account',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/mainPage');
        break;
      case 1:
        Navigator.pushNamed(context, '/order');
        break;
      case 2:
        Navigator.pushNamed(context, '/more');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(children: <Widget>[
          Text(
            "My",
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
            "Orders",
            textAlign: TextAlign.start,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 22,
              color: Color(0xfffba808),
            ),
          ),
        ]),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            children: [
              TextFormField(
                controller: fromController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'From',
                  suffixIcon: Icon(Icons.navigation_sharp),
                  suffix: Text('Source'),
                ),
              ),
              TextFormField(
                controller: toController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'To',
                  suffixIcon: Icon(Icons.assistant_navigation),
                  suffix: Text('Destination'),
                ),
              ),
              TextFormField(
                controller: lengthController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Length',
                  suffixIcon: Icon(Icons.straighten),
                  suffix: Text('CM'),
                ),
              ),
              TextFormField(
                controller: widthController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Width',
                  suffixIcon: Icon(Icons.straighten),
                  suffix: Text('CM'),
                ),
              ),
              TextFormField(
                controller: heightController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Height',
                  suffixIcon: Icon(Icons.straighten),
                  suffix: Text('CM'),
                ),
              ),
              SizedBox(height: 10),
              for (int i = 0; i < _selectedImages.length; i++)
                GestureDetector(
                  onTap: () => _pickImage(i),
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10),
                      dashPattern: [10, 4],
                      strokeCap: StrokeCap.round,
                      color: Colors.blue.shade400,
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.folder_open,
                              color: Colors.blue,
                              size: 35,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Select your file ${i + 1}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey.shade400),
                            ),
                            Text(
                              'File should be jpg, png',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              for (int i = 0; i < _selectedImages.length; i++)
                _selectedImages[i] != null
                    ? Image.file(_selectedImages[i]!, width: 150, height: 150)
                    : Container(),
              ElevatedButton(
                onPressed: _createOrder,
                child: Text('Create Order'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}