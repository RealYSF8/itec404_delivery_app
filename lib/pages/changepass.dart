import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Changepass extends StatelessWidget {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        backgroundColor: const Color(0xff3a57e8),
    appBar: AppBar(
    elevation: 0,
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    title: const Text(
    'Change Password',
    style: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: Colors.white,
    ),
    ),
    leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.of(context).pop(),
    ),
    ),
    body: Stack(
    children: [
    Align(
    alignment: Alignment.center,
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Image.network(
    'https://cdn4.iconfinder.com/data/icons/seo-and-marketing-icons-1-1/129/56-128.png',
    height: 100,
    width: 140,
    fit: BoxFit.contain,
    ),
    const Padding(
    padding: EdgeInsets.symmetric(vertical: 30),
    child: Text(
    'Want To Change Your Password?',
    textAlign: TextAlign.center,
    style: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 24,
    color: Colors.white,
    ),
    ),
    ),
    const Text(
    'Just enter your old password and the new one you want to use',
    textAlign: TextAlign.center,
    style: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: const Color(0xffd2d2d2),
    ),
    ),
    const SizedBox(height: 10),
    TextField(
    controller: oldPasswordController,
    obscureText: true,
    decoration: InputDecoration(
    hintText: 'Type Your Previous Password',
    filled: true,
    fillColor: const Color(0xffe2e0e0),
    contentPadding: const EdgeInsets.symmetric(
    vertical: 8, horizontal: 12),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: Colors.transparent, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: Colors.transparent, width: 1),
    ),
    ),
    ),
    const SizedBox(height: 10),
    TextField(
    controller: newPasswordController,
    obscureText: true,
    decoration: InputDecoration(
    hintText: 'Type Your New Password',
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
    vertical: 8, horizontal: 12),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: Colors.transparent, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
    color: Colors.transparent, width: 1),
    ),
    ),
    ),
      ],

    ),
    ),
    ),
      Positioned(
        bottom: 0,
        right: 0,
        child: MaterialButton(
          onPressed: () async {
            try {
              // Verify the old password
              final credential = EmailAuthProvider.credential(
                  email: user?.email ?? '',
                  password: oldPasswordController.text.trim());
              await user?.reauthenticateWithCredential(credential);

              // Update the password to the new one
              await user?.updatePassword(newPasswordController.text.trim());

              // Display debugging information


              // Display a success message and close the dialog
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Success'),
                      content: Text('Password has been updated.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        )
                      ],
                    );
                  });
            } on FirebaseAuthException catch (e) {
              if (e.code == 'wrong-password') {
                debugPrint('User ${user?.uid ?? ''} entered wrong password');

                // Display an error message
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Old password is incorrect.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          )
                        ],
                      );
                    });
              }
            }
          },
          color: const Color(0xffe96053),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            side:
            const BorderSide(color: const Color(0xff808080), width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Change',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              fontStyle: FontStyle.normal,
            ),
          ),
          textColor: Colors.white,
          height: 50,
          minWidth: 150,
        ),
      ),
    ],
    ),
    );
  }
}

