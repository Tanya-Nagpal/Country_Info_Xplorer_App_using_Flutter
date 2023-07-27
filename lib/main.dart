// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'first.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Set the AppBar background to transparent
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
    ),
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  String _country = '';
  Future<Map<String, dynamic>>? _countryData;


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Remove the shadow below the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the second screen when back arrow is clicked
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
        title: Row( // Use Row to arrange the Text and Icon horizontally
          mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
          children: [
            const Text(
              'Country Information   ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
            Icon(Icons.public), // Icon representing the Earth or globe
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade300,
        toolbarHeight: 60,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade300, Colors.white60, Colors.purple.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 35),
                SizedBox(
                  height: 100,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _country = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Enter name of a Country",
                      labelStyle: TextStyle(
                        color: Color(0xFF440169),
                        // color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        shadows: [
                          BoxShadow(
                            color: Colors.grey.shade600,
                            blurRadius: 7.0,
                            spreadRadius: 5.0,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black), // Set the desired border color when focused
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: height*0.07,
                  width: width*0.85,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 20,
                      backgroundColor: Colors.deepPurple.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Button border radius
                      ),
                    ),
                    child: Text(
                      'Get Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          BoxShadow(
                            color: Colors.grey.shade900,
                            blurRadius: 7.0,
                            spreadRadius: 5.0,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    onPressed: (){
                      if (_country.trim().isEmpty) {
                        // If the user didn't enter a country name, show an error message.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter a country name")),
                        );
                      } else {
                        // If the user entered a country name, fetch the data.
                        setState(() {
                          _countryData = _fetchCountryData(_country);
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: 25),
                FutureBuilder<Map<String,dynamic>>(
                    future: _countryData,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.deepPurpleAccent),
                        );
                      } else if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data;
                        // print(data); // Debug statement to log the API response
                        // print(data['flags']['png']); // Debug statement to log the flag image URL
                        return Expanded(
                            child: ListView(
                              children: <Widget>[
                                Container(
                                  color: Colors.purple.shade200,
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Country Name',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff5f0591),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add some vertical spacing between the title and subtitle
                                      ],
                                    ),
                                    subtitle: Text(
                                      data['name'],
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.purple.shade200,
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Capital City',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff5f0591),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add some vertical spacing between the title and subtitle
                                      ],
                                    ),
                                    subtitle: Text(
                                      data['capital'],
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.purple.shade200,
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      'Country Flag',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff5f0591),
                                          fontWeight: FontWeight.bold
                                      ),),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5), // Add some vertical spacing between the title and flag
                                        Center(
                                          child: CachedNetworkImage(
                                            imageUrl: data['flags']['png'],
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                            width: 150,
                                            height: 150,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.purple.shade200,
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Population',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff5f0591),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add space between the title and subtitle
                                      ],
                                    ),
                                    subtitle: Text(
                                      NumberFormat('#,##,###').format(data['population']),
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.purple.shade200,
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Languages',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff5f0591),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10), // Add some vertical spacing between title and subtitle
                                      ],
                                    ),
                                    subtitle: Text(
                                      data['languages']
                                          .map((lang) => lang['name'])
                                          .join(', '),
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.purple.shade200,
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      'Currency',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff5f0591),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10), // Add some vertical spacing between the title and subtitle
                                        Text(
                                          data['currencies']
                                              .map((currency) => '${currency['name']} (${currency['symbol']})')
                                              .join(', '),
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.purple.shade200,
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      'Continent',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff5f0591),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5), // Add some vertical spacing between the title and subtitle
                                        Text(
                                          data['region'],
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.purple.shade200,
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      'Calling Code',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff5f0591),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '+${data['callingCodes'][0]}',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                        );
                      } else if (_countryData == null) {
                        return Text("Enter a country name and tap 'Get Information'");
                      }
                      else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Container();
                    }
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchCountryData(String country) async {
    final response = await http.get(
      Uri.parse('https://restcountries.com/v2/name/$country'),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result[0];
    } else {
      throw Exception('Failed to load country data');
    }
  }
}