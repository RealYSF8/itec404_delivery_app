import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:universal_html/html.dart' as html;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:async';

class MakeOrderPage extends StatefulWidget {
  final TextEditingController controller;
  MakeOrderPage({required this.controller});

  @override
  State<MakeOrderPage> createState() => _Order();
}

class _Order extends State<MakeOrderPage> with TickerProviderStateMixin {
  Future<String?> _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('address');
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _downloadUrl;
  final places =
  GoogleMapsPlaces(apiKey: 'AIzaSyCoCj0Is0Nq4_AFta4srPt_fxpNmXKTOTY');
  List<String> placePredictions = [];
  List<String> toPlacePredictions = [];

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image
    final PickedFile? pickedFile;
    if (kIsWeb) {
      html.FileUploadInputElement input = html.FileUploadInputElement();
      input.accept = 'image/*';
      input.click();

      final completer = Completer<html.File>();
      input.onChange.listen((e) {
        final files = input.files;
        if (files != null && files.isNotEmpty) {
          completer.complete(files[0]);
        } else {
          completer.completeError('No file selected');
        }
      });

      try {
        final file = await completer.future;
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        await reader.onLoad.first;

        final fileName = file.name;
        final fileSize = file.size;
        final url = reader.result as String;

        firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('uploads/$fileName');
        firebase_storage.UploadTask uploadTask = ref.putString(
          url,
          format: firebase_storage.PutStringFormat.dataUrl,
        );
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        final fileSizeInBytes = fileSize;
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024); // Convert to MB

        setState(() {
          _downloadUrl = downloadUrl;
          _selectedFileName = fileName;
          _selectedFileSize = fileSizeInMB.toStringAsFixed(2) + ' MB'; // Display size with 2 decimal places
        });
      } catch (e) {
        print('Error selecting image: $e');
      }
    } else {
      XFile? pickedFile =
      await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) return;

      File file = File(pickedFile.path);
      String compressedPath = await convertImageToWebP(
          file.path); // Compress the image
      File compressedFile = File(compressedPath);

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('uploads/${file.path.split('/').last}');
      firebase_storage.UploadTask uploadTask =
      ref.putFile(compressedFile); // Upload the compressed image
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        _downloadUrl = downloadUrl;
        _selectedFileName = file.path.split('/').last;
        _selectedFileSize = file.lengthSync().toString();
      });
    }
  }


  Future<List<String>> fetchToPlacePredictions(String input) async {
    if (kIsWeb) {
      final response = await http.get(
        Uri.parse(
            'https://us-central1-itec404deliveryapp.cloudfunctions.net/getPlaceAutocomplete?input=$input'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['predictions']
            .map<String>((prediction) => prediction['description'])
            .toList();
      } else {
        throw Exception('Failed to load predictions');
      }
    } else {
      final response = await places.autocomplete(input, types: []);
      if (response.isOkay) {
        return response.predictions
            .map((prediction) => prediction.description!)
            .toList();
      } else {
        throw response.errorMessage!;
      }
    }
  }

  Future<List<String>> fetchPlacePredictions(String input) async {
    if (kIsWeb) {
      final response = await http.get(
        Uri.parse(
            'https://us-central1-itec404deliveryapp.cloudfunctions.net/getPlaceAutocomplete?input=$input'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['predictions']
            .map<String>((prediction) => prediction['description'])
            .toList();
      } else {
        throw Exception('Failed to load predictions');
      }
    } else {
      final response = await places.autocomplete(input, types: []);
      if (response.isOkay) {
        return response.predictions
            .map((prediction) => prediction.description!)
            .toList();
      } else {
        throw response.errorMessage!;
      }
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

  bool _isImageSelected = false;
  String _selectedFileName = '';
  String _selectedFileSize = '';

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
    _getAddress().then((value) => fromLocation.text = value ?? '');
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
                onChanged: (input) {
                  if (input.isNotEmpty) {
                    fetchPlacePredictions(input).then((predictions) {
                      setState(() {
                        placePredictions = predictions;
                      });
                    }).catchError((error) {
                      // Handle the error if fetching predictions fails
                    });
                  } else {
                    setState(() {
                      placePredictions = [];
                    });
                  }
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: placePredictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(placePredictions[index]),
                    onTap: () {
                      fromLocation.text = placePredictions[index];
                      setState(() {
                        placePredictions = [];
                      });
                    },
                  );
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
                onChanged: (input) {
                  if (input.isNotEmpty) {
                    fetchToPlacePredictions(input).then((predictions) {
                      setState(() {
                        toPlacePredictions = predictions;
                      });
                    }).catchError((error) {
                      // Handle the error if fetching predictions fails
                    });
                  } else {
                    setState(() {
                      toPlacePredictions = [];
                    });
                  }
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: toPlacePredictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(toPlacePredictions[index]),
                    onTap: () {
                      toLocation.text = toPlacePredictions[index];
                      setState(() {
                        toPlacePredictions = [];
                      });
                    },
                  );
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
                  uploadImage();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                            'Select your file',
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
                          color: Colors.white,
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      _downloadUrl!,
                                      height: 75,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'File Name: $_selectedFileName',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                  ),
                                  Text(
                                    'File Size: $_selectedFileSize',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                  ),
                                  SizedBox(height: 5),
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
              ElevatedButton(
                onPressed: () => _createOrder(_downloadUrl),
                child: Text('Create Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
