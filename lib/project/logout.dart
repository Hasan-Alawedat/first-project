import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiButton extends StatefulWidget {
  @override
  _ApiButtonState createState() => _ApiButtonState();
}

class _ApiButtonState extends State<ApiButton> {

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }
  String _responseMessage = '';

  Future<void> _makeApiCall() async {
    var token = await getToken();
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/logout/admin'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _responseMessage = 'Status: ${data['status']}, Message: ${data['message']}';
      });
    } else {
      setState(() {
        _responseMessage = 'Request failed with status: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _makeApiCall,
          child: Text('اضغط هنا'),
        ),
        SizedBox(height: 20),
        Text(_responseMessage),
      ],
    );
  }
}