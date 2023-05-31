import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewPage extends StatefulWidget {
  final String documentId;

  const ReviewPage({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double? _ratingValue;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    fetchRating();
  }

  Future<void> fetchRating() async {
    DocumentSnapshot orderSnapshot =
    await firestore.collection('orders').doc(widget.documentId).get();
    setState(() {
      _ratingValue = orderSnapshot['rating'] ?? 0.0;
      _hasRated = _ratingValue != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: <Widget>[
            Text(
              "Review",
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
              "Page",
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
        padding: const EdgeInsets.all(100),
        child: Center(
          child: Column(
            children: [
              if (_hasRated)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Rated Order',
                    style: TextStyle(fontSize: 25),
                  ),
                )
              else
                const Text(
                  'Rate Your Order',
                  style: TextStyle(fontSize: 25),
                ),
              const SizedBox(height: 25),
              if (!_hasRated)
                RatingBar.builder(
                  initialRating: _ratingValue ?? 0.0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
                  onRatingUpdate: (value) async {
                    if (!_hasRated) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                    'Confirm Rating',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Are you sure you want to submit this rating?',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24.0),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.grey[300],
                                          onPrimary: Colors.black,
                                        ),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _ratingValue = value;
                                            _hasRated = true;
                                          });

                                          // Retrieve the acceptedBy email from the orders table
                                          DocumentSnapshot orderSnapshot =
                                          await firestore
                                              .collection('orders')
                                              .doc(widget.documentId)
                                              .get();
                                          String acceptedByEmail =
                                          orderSnapshot['acceptedBy'];

                                          // Update the rating in the orders table
                                          firestore
                                              .collection('orders')
                                              .doc(widget.documentId)
                                              .update({
                                            'rating': value,
                                          });

                                          // Update the rating in the users table
                                          QuerySnapshot userSnapshot = await firestore
                                              .collection('users')
                                              .where('email',
                                              isEqualTo: acceptedByEmail)
                                              .get();
                                          if (userSnapshot.docs.isNotEmpty) {
                                            String userId =
                                                userSnapshot.docs[0].id;
                                            firestore
                                                .collection('users')
                                                .doc(userId)
                                                .update({
                                              'ratings':
                                              FieldValue.arrayUnion([value]),
                                            });
                                          }
                                        },
                                        child: const Text('Submit'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              const SizedBox(height: 25),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xfffba808),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _ratingValue != null ? _ratingValue.toString() : 'Rate it!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
