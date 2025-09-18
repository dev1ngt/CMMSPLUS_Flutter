import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/utils/app_shared_preference.dart';

class LatLongListScreen extends StatefulWidget {
  @override
  _LatLongListScreenState createState() => _LatLongListScreenState();
}

class _LatLongListScreenState extends State<LatLongListScreen> {
  bool isLoading = false;
  int currentPage = 0;
  bool hasMoreData = true;
  List<Datum> list = [];
  late Timer timer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    condition();
  }

  Future<void> condition() async {
    final prefs = await SharedPreferences.getInstance();
    bool isCheckIN = prefs.getBool('checkinFlag') ?? false;
    if(isCheckIN) {
      fetchLocations();

      // Add a listener to detect when the user scrolls to the bottom
      /*_scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
            !isLoading &&
            hasMoreData) {
          fetchLocations();
        }
      });*/

      timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
        refreshPage();
      });
    }
  }

  Future<void> refreshPage() async {
    // Reset data and page number to refresh the list
    setState(() {
      list.clear();
      currentPage = 0;
      hasMoreData = true;
    });

    // Fetch data again
    await fetchLocations();
  }

  Future<Map<String, String>> getHeader() async {
    return {
      'Content-type': 'application/json',
      'X-Project-Code': await getContractCode(),
    };
  }

  Future<String> getContractCode() async {
    return await AppSharedPrefs.getContractCode();
  }

  Future<void> fetchLocations() async {
    if (isLoading) return; // Prevent multiple API calls simultaneously
    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = await getHeader();
    String baseUrl = await AppSharedPrefs.getBaseUrl();
    String userId = await AppSharedPrefs.getUserID();
    final prefs = await SharedPreferences.getInstance();
    String? propertyId = prefs.getString('checkInPropertyId') ?? '';

    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);

    final url = Uri.parse("${baseUrl}get_attendance_log?"
        "property_id=$propertyId"
        "&user_id=$userId"
        "&created_date=$formattedDate"
        "&page=$currentPage");

    print('no');
    try {
      final response = await get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final sampleModel = SampleModel.fromJson(jsonResponse);
        print('yes');
        setState(() {
          if (sampleModel.data.isNotEmpty) {
            list.addAll(sampleModel.data); // Append new data to the list
            currentPage++; // Increment the page number
          } else {
            hasMoreData = false; // No more data to fetch
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching locations: $e');
    }finally {
      setState(() {
        isLoading = false; // Reset the loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latitude & Longitude'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              //controller: _scrollController,
              itemCount: list.length + 1, // Add an extra item for the loader
              itemBuilder: (context, index) {
                if (index < list.length) {
                  final location = list[index];
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latitude: ${location.latitude}',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Longitude: ${location.longitude}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  );
                } /*else {
                  // Show a loader at the bottom of the list
                  return hasMoreData
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink();
                }*/
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    timer.cancel();
    super.dispose();
  }
}


class SampleModel {
  SampleModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<Datum> data;

  factory SampleModel.fromJson(Map<String, dynamic> json){
    return SampleModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}

class Datum {
  Datum({
    required this.userName,
    required this.propertyName,
    required this.latitude,
    required this.longitude,
    required this.createdDateTime,
  });

  final String? userName;
  final String? propertyName;
  final String? latitude;
  final String? longitude;
  final DateTime? createdDateTime;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      userName: json["user_name"],
      propertyName: json["property_name"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      createdDateTime: DateTime.tryParse(json["created_date_time"] ?? ""),
    );
  }

}
