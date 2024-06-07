import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled34/project/home.dart';

class Admins extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Admins> {
  List<dynamic>? _profileData;
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final url = Uri.parse('http://127.0.0.1:8000/api/show-admins-Info');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Response: $jsonResponse'); // Log the response
        if (jsonResponse['status'] == true) {
          setState(() {
            _profileData = jsonResponse['data'];
            _message = jsonResponse['message'];
          });
        } else {
          setState(() {
            _message = 'Failed to retrieve profile data.';
          });
        }
      } else {
        setState(() {
          _message = 'هذا مخصص فقط للشخص المسؤول : ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error fetching profile data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  Future<void> _deleteAdmin(int id) async {
    var token = await getToken();

    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/delete-admin/$id'),  // تعديل هنا
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true) {
        setState(() {
          _profileData!.removeWhere((profile) => profile['id'] == id);
          _message = jsonResponse['message'];
        });
      } else {
        setState(() {
          _message = 'Failed to delete admin.';
        });
      }
    } else {
      setState(() {
        _message = 'Failed to delete admin. Status code: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 829;
    final isDesk = MediaQuery.of(context).size.width >= 1470;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isDesktop)
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(12)),
                      height: 40,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notification_important,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(12)),
                      height: 40,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.forward_to_inbox,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(12)),
                      height: 40,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.home,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => Login()),
                                    (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 280),
                ],
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12)),
                width: 230,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "                                       بحث  ",
                    hoverColor: Colors.cyan,
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search_rounded,
                        color: Colors.black12,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _profileData != null
          ? ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _profileData!.length,
        itemBuilder: (context, index) {
          final profile = _profileData![index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(' ${profile['first_name']} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 23),),
                      Text(' ${profile['last_name']} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 23),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(' ${profile['email']} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 17),),
                      Text(" : الأيميل  ", style: TextStyle(fontSize: 20,color: Colors.blue),),
                      Icon(Icons.email,color: Colors.blueGrey,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(' ${profile['role']} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 17),),
                      Text(" : الدور  ", style: TextStyle(fontSize: 20,color: Colors.blue),),
                      Icon(Icons.accessibility_new_sharp,color: Colors.blueGrey,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(' ${profile['phone_no']} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 17),),
                      Text(" : رقم الهاتف  ", style: TextStyle(fontSize: 20,color: Colors.blue),),
                      Icon(Icons.phone,color: Colors.blueGrey,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(' ${profile['created_at']} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 17),),
                      Text(" : تاريخ الانشاء  ", style: TextStyle(fontSize: 20,color: Colors.blue),),
                      Icon(Icons.date_range_outlined,color: Colors.blueGrey,),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        child: Container(
                            width: 170,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("   تعديل المعلومات ", style: TextStyle(color: Colors.black, fontSize: 16),),
                                SizedBox(width: 4,),
                                Icon(Icons.edit, color: Colors.blue, size: 15,),
                              ],
                            )),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _deleteAdmin(profile['id']);
                        },
                        icon: Icon(Icons.delete, color: Colors.white),
                        label: Text("حذف", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Center(child: Text(_message)),
    );
  }
}
