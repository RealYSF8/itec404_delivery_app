import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class MakeOrderPage extends StatefulWidget {
  final TextEditingController controller;
  MakeOrderPage({required this.controller});

  @override
  State<MakeOrderPage> createState() => _Order();
}

class _Order extends State<MakeOrderPage> with TickerProviderStateMixin {
  late bool isDarkMode;

  Future<void> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<String?> _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('address');
  }

  String? _downloadUrl;
  String? _selectedImage;

  final places =
  GoogleMapsPlaces(apiKey: 'AIzaSyCoCj0Is0Nq4_AFta4srPt_fxpNmXKTOTY');

  List<String> placePredictions = [];
  List<String> toPlacePredictions = [];

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();

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

        setState(() {
          _selectedImage = url;
        });

        firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('uploads/$fileName');
        firebase_storage.UploadTask uploadTask = ref.putString(
          url,
          format: firebase_storage.PutStringFormat.dataUrl,
        );
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        final fileSizeInBytes = fileSize;
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        setState(() {
          _downloadUrl = downloadUrl;
          _selectedFileName = fileName;
          _selectedFileSize = fileSizeInMB.toStringAsFixed(2) + ' MB';
        });
      } catch (e) {
        print('Error selecting image: $e');
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
      setState(() {
        _selectedImage = file.path;
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController fromLocation = TextEditingController();
  final TextEditingController toLocation = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController priceController =
  TextEditingController(text: '0.00');

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
    getThemeMode();
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
      setState(() {});
    });
    super.initState();
    lengthController.addListener(calculatePrice);
    widthController.addListener(calculatePrice);
    heightController.addListener(calculatePrice);
    getNameFromSharedPreferences();
    _getUserData();
    getCategoryFromSharedPreferences();
    _getAddress().then((value) => fromLocation.text = value ?? '');
  }

  void calculatePrice() {
    double length = double.tryParse(lengthController.text) ?? 0;
    double width = double.tryParse(widthController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0;

    double price = (length * width * height) / 2000;
    priceController.text = price.toStringAsFixed(2);
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
    String? from = fromLocation.text;
    String? to = toLocation.text;
    String? length = lengthController.text;
    String? name = nameController.text;
    String? width = widthController.text;
    String? height = heightController.text;
    String? price = priceController.text;
    Random random = Random();
    int randomOrder = random.nextInt(10000);

    Timestamp now = Timestamp.now();

    if (from == null ||
        to == null ||
        length == null ||
        width == null ||
        height == null ||
        price == null ||
        downloadUrl == null ||
        from.isEmpty ||
        to.isEmpty ||
        length.isEmpty ||
        width.isEmpty ||
        height.isEmpty ||
        price.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Incomplete Order'),
            content: Text('Please fill all the required fields.'),
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
      return;
    }

    DocumentReference orderRef = await _db.collection('orders').add({
      'createdBy': _Email,
      'userId': _userId,
      'Name': _Name,
      'from': from,
      'to': to,
      'length': length,
      'width': width,
      'height': height,
      'price': price,
      'status': 'Pending',
      'productName': name,
      'createdAt': now,
      'orderNumber': randomOrder,
    });
    orderRef.update({'imageUrls': _downloadUrl});

    fromLocation.clear();
    toLocation.clear();
    lengthController.clear();
    nameController.clear();
    widthController.clear();
    heightController.clear();
    priceController.clear();

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
                Navigator.pushNamed(context, '/orderdetail',
                    arguments: orderRef.id);
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
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Product Name',
                  suffixIcon: Icon(Icons.label),
                  suffix: Text('Name'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product Name is required';
                  }
                  return null;
                },
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
                    }).catchError((error) {});
                  } else {
                    setState(() {
                      placePredictions = [];
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'From location is required';
                  }
                  return null;
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
                    }).catchError((error) {});
                  } else {
                    setState(() {
                      toPlacePredictions = [];
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'To location is required';
                  }
                  return null;
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
                keyboardType: TextInputType.number,
                controller: lengthController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Length',
                  suffixIcon: Icon(Icons.straighten),
                  suffix: Text('CM'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Length is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: widthController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Width',
                  suffixIcon: Icon(Icons.straighten),
                  suffix: Text('CM'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Width is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: heightController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Height',
                  suffixIcon: Icon(Icons.straighten),
                  suffix: Text('CM'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Height is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Price',
                  suffixIcon: Icon(Icons.price_check),
                  suffix: Text('TL'),
                ),
                enabled: false,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  uploadImage();
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
              if (_selectedImage != null)
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
                          color: isDarkMode ? Colors.grey[700] : Colors.white,
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
                                      child: kIsWeb
                                          ? Image.network(
                                        _selectedImage!,
                                        height: 75,
                                        width: 70,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.file(
                                        File(_selectedImage!),
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
                                          color: isDarkMode ? Colors.white : Colors.grey[700],
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
              ElevatedButton(
                onPressed: () {
                  if (_validateFormFields(context)) {
                    _createOrder(_downloadUrl);
                  }
                },
                child: Text('Create Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateFormFields(BuildContext context) {
    bool isValid = true;

    if (nameController.text.isEmpty) {
      _showErrorSnackBar(context, 'Product name is required');
      isValid = false;
    }

    if (fromLocation.text.isEmpty) {
      _showErrorSnackBar(context, 'From location is required');
      isValid = false;
    }

    if (toLocation.text.isEmpty) {
      _showErrorSnackBar(context, 'To location is required');
      isValid = false;
    }

    if (lengthController.text.isEmpty) {
      _showErrorSnackBar(context, 'Length is required');
      isValid = false;
    }

    if (widthController.text.isEmpty) {
      _showErrorSnackBar(context, 'Width is required');
      isValid = false;
    }

    if (heightController.text.isEmpty) {
      _showErrorSnackBar(context, 'Height is required');
      isValid = false;
    }

    if (_downloadUrl == null) {
      _showErrorSnackBar(context, 'Image is required');
      return false;
    }

    return isValid;
  }

  void _showErrorSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }
}
