import 'package:flutter/material.dart';
class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _Account();
}

class _Account extends State<Account> {

  String name="Foad";
  String lname="Farahbod";
  String email="foad@yahoo.com";
  String phone = "05391142425";
  String address="Famagusta/Emu";
  //TextEditingController userInput = TextEditingController();
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Row(
            children: <Widget>[
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
              Text("Account",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 22,
                  color: Color(0xfffba808),
                ),
              ),
            ]
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {

          });
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.grey[800],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Center(
            child: CircleAvatar(
                backgroundImage: AssetImage('assets/ninja.png'),
                radius: 40.0,
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.grey[700],
            ),
            Container(
              margin: EdgeInsets.all(7),
              child: TextFormField(
                initialValue: '$email',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) {
                  setState(() {
                    //userInput.text = value.toString();
                  });
                },
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  //add prefix icon
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.grey,
                  hintText: "Email/Username",
                  //make hint text
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "verdana_regular",
                    fontWeight: FontWeight.w400,
                  ),
                  //create lable
                  labelText: 'Email/Username',
                  //lable style
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: "verdana_regular",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(7),
              child: TextFormField(
                initialValue: '$name',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) {
                  setState(() {
                    //userInput.text = value.toString();
                  });
                },
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  //add prefix icon
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.grey,
                  hintText: "Name",
                  //make hint text
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "verdana_regular",
                    fontWeight: FontWeight.w400,
                  ),
                  //create lable
                  labelText: 'Name',
                  //lable style
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: "verdana_regular",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(7),
              child: TextFormField(
                initialValue: '$lname',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) {
                  setState(() {
                    //userInput.text = value.toString();
                  });
                },
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  //add prefix icon
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.grey,
                  hintText: "Surname",
                  //make hint text
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "verdana_regular",
                    fontWeight: FontWeight.w400,
                  ),
                  //create lable
                  labelText: 'Surname',
                  //lable style
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: "verdana_regular",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(7),
              child: TextFormField(
                initialValue: '$phone',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) {
                  setState(() {
                    //userInput.text = value.toString();
                  });
                },
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  //add prefix icon
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.grey,
                  hintText: "Phone number",
                  //make hint text
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "verdana_regular",
                    fontWeight: FontWeight.w400,
                  ),
                  //create lable
                  labelText: 'Phone number',
                  //lable style
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: "verdana_regular",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(7),
              child: TextFormField(
                initialValue: '$address',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) {
                  setState(() {
                    //userInput.text = value.toString();
                  });
                },
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  //add prefix icon
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.grey,
                  hintText: "Address",
                  //make hint text
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "verdana_regular",
                    fontWeight: FontWeight.w400,
                  ),
                  //create lable
                  labelText: 'Address',
                  //lable style
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "verdana_regular",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//       Padding(
//         padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Center(
//               child: CircleAvatar(
//                 backgroundImage: AssetImage('assets/ninja.png'),
//                 radius: 40.0,
//               ),
//             ),
//             Divider(
//               height: 60.0,
//               color: Colors.grey[700],
//             ),
//             Text(
//               'NAME',
//               style: TextStyle(
//                 color: Colors.grey,
//                 letterSpacing: 2.0,//pixels betwwen each letter to make it more readable when text it's small
//               ),
//             ),
//             //SizedBox(height: 10.0),//puts an invisible box between two texts
//             TextFormField(
//               //'$name',
//               initialValue: '$name',
//               style: TextStyle(
//                 color: Color(0xfffba808),
//                 letterSpacing: 2.0,
//                 fontSize: 24.0,//in pixelsd
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 25.0),
//             Text(
//               'LAST NAME',
//               style: TextStyle(
//                 color: Colors.grey,
//                 letterSpacing: 2.0,//pixels betwwen each letter to make it more readable when text it's small
//               ),
//             ),
//             //SizedBox(height: 10.0),
//             TextFormField(
//               initialValue: '$lname',
//               style: TextStyle(
//                 color: Color(0xfffba808),
//                 letterSpacing: 2.0,
//                 fontSize: 24.0,//in pixels
//                 fontWeight: FontWeight.bold,
//               ),
//             ),SizedBox(height: 30.0),
//             Row(
//               children: <Widget>[
//                 Icon(
//                   Icons.email,
//                   color: Colors.grey[400],
//                 ),
//                 SizedBox(width: 10.0),
//                 Text(
//                   '$email',
//                   style: TextStyle(
//                     color: Colors.grey[400],
//                     fontSize: 18.0,
//                     letterSpacing: 1.0,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 30.0),
//             Row(
//               children: <Widget>[
//                 Icon(
//                   Icons.call,
//                   color: Colors.grey[400],
//                 ),
//                 SizedBox(width: 10.0),
//                 Text(
//                   '$phone',
//                   style: TextStyle(
//                     color: Colors.grey[400],
//                     fontSize: 18.0,
//                     letterSpacing: 1.0,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 30.0),
//             Row(
//               children: <Widget>[
//                 Icon(
//                   Icons.home,
//                   color: Colors.grey[400],
//                 ),
//                 SizedBox(width: 10.0),
//                 Text(
//                   '$address',
//                   style: TextStyle(
//                     color: Colors.grey[400],
//                     fontSize: 18.0,
//                     letterSpacing: 1.0,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }