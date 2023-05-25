import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
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
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_maps_webservice/places.dart';
import 'dart:math';


class MakeOrderPage extends StatefulWidget {
  final TextEditingController controller;
  MakeOrderPage({required this.controller});

  @override
  State<MakeOrderPage> createState() => _Order();
}

class _Order extends State<MakeOrderPage> with TickerProviderStateMixin {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _downloadUrl;
  File? _imageFile; // Added variable to store the uploaded image
  final places = GoogleMapsPlaces(apiKey: 'AIzaSyCKGOQLEf3OZpG77XTfScdkzWIlyNc2rcI');

  @override
  void dispose() {
    // Dispose the GoogleMapsPlaces instance when no longer needed
    places.dispose();
    super.dispose();
  }

  // Function to handle the location autofill
  Future<void> _autofillLocation(TextEditingController controller) async {
    // Show the autocomplete overlay
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: 'AIzaSyCKGOQLEf3OZpG77XTfScdkzWIlyNc2rcI',
      language: 'en',
      mode: Mode.overlay,
      components: [Component(Component.country, 'cy')], // Adjust the country code if needed
    );

    // Update the controller with the selected location
    if (prediction != null) {
      PlacesDetailsResponse detailsResponse = await places.getDetailsByPlaceId(prediction.placeId!);
      String location = detailsResponse.result!.formattedAddress!;
      controller.text = location;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<String?> _uploadImage(File? imageFile) async {
    if (imageFile == null) return null;

    final String fileName = Path.basename(imageFile.path);
    final firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance.ref('uploads/$fileName');

    firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      _downloadUrl = downloadUrl;
    });
    return downloadUrl;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController fromLocation = TextEditingController();
  final TextEditingController toLocation = TextEditingController();
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

  String? _category;

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    super.initState();
    getNameFromSharedPreferences();
    _getUserData();
    getCategoryFromSharedPreferences();
  }

  void getCategoryFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _category = prefs.getString("category") ?? "";
    });
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

  Future<void> _createOrder(String? downloadUrl) async {
    // Get the data from the input fields
    String? from = fromLocation.text;
    String? to = toLocation.text;
    String? length = lengthController.text;
    String? width = widthController.text;
    String? height = heightController.text;
    Random random = Random();
    int randomOrder = random.nextInt(10000);
    // Upload the images before creating the order

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
      'orderNumber': randomOrder,
    });
    orderRef.update({'imageUrls': _downloadUrl});

    // Update the order document with the image URLs

    // Clear the input fields
    fromLocation.clear();
    toLocation.clear();
    lengthController.clear();
    widthController.clear();
    heightController.clear();

    // Clear the selected images
    setState(() {
      _imageFile = null;
      _downloadUrl = null;
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            children: [
              Text(
                "Category: $_category",
                textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  // color: Color(0xffffffff),
                ),
              ),
              TextFormField(
                controller: fromLocation,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'From',
                  suffixIcon: Icon(Icons.navigation_sharp),
                  suffix: Text('Source'),
                ),
                onTap: () {
                  _autofillLocation(fromLocation);
                },
              ),
              TextFormField(
                controller: toLocation,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'To',
                  suffixIcon: Icon(Icons.assistant_navigation),
                  suffix: Text('Destination'),
                ),
                onTap: () {
                  _autofillLocation(toLocation);
                },
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
              TextFormField(
                controller: heightController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Price',
                  suffixIcon: Icon(Icons.price_check),
                  suffix: Text('TL'),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
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
                            'Select your file 1',
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
              if (_imageFile != null)
                kIsWeb
                    ? Image.network(_imageFile!.path)
                    : Image.file(_imageFile!),
              Container(),
              ElevatedButton(
                onPressed: () async {
                  String? downloadUrl = await _uploadImage(_imageFile);
                  _createOrder(downloadUrl);
                },
                child: Text('Create Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}