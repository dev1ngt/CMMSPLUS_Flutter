import 'package:cmms/src/constants/app_sizes.dart';
import 'package:cmms/src/features/checkin_out/bloc/report/report_event.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../api/api_service.dart';
import '../bloc/report/report_bloc.dart';
import '../bloc/report/report_state.dart';
import '../model/report_response_model.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime selectedDate = DateTime.now();

  TextEditingController _monthController = TextEditingController();
  TextEditingController _yearController = TextEditingController();

  ScrollController _scrollController = ScrollController();
  int page = 0;
  bool _isLoadingMore = true;
  bool _isListEnd = false;
  late ReportBloc reportBloc;
  List<Report> allData = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    String monthString = DateFormat('MMMM').format(selectedDate);
    _monthController.text = monthString;
    _yearController.text = selectedDate.year.toString();

    reportBloc = ReportBloc(RepositoryProvider.of<ApiService>(context))
      ..add(FetchReportDetails(
          month: selectedDate.month.toString(),
          year: _yearController.text,
          pageNo: '0'));
  }

  void _onScroll() {
    if (!_isListEnd) {
      if (_isLoadingMore &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent) {
        setState(() {
          _isLoadingMore = true;
          page++;
        });
        reportBloc.add(FetchReportDetails(
            month: selectedDate.month.toString(),
            year: _yearController.text,
            pageNo: page.toString()));
      }
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _MonthPickerDialog(
          selectedDate: selectedDate,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String monthString = DateFormat('MMMM').format(selectedDate);
        _monthController.text = monthString;
        allData.clear();
        reportBloc.add(FetchReportDetails(
            month: selectedDate.month.toString(),
            year: _yearController.text,
            pageNo: '0'));
      });
    }
  }

  Future<void> _selectYear(BuildContext context) async {
    final int? picked = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return _YearPickerDialog(
          selectedYear: selectedDate.year,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateTime(picked, selectedDate.month);
        String yearString = selectedDate.year.toString();
        _yearController.text = yearString;
        allData.clear();
        reportBloc.add(FetchReportDetails(
            month: selectedDate.month.toString(),
            year: _yearController.text,
            pageNo: '0'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    String formattedMonth = DateFormat('MMMM').format(selectedDate);
    String formattedYear = DateFormat('yyyy').format(selectedDate);

    return BlocProvider(
      create: (context) => reportBloc,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final ppmlist =
                        await Navigator.pushNamed(context, '/checkIn');
                    Navigator.pop(context, ppmlist);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/ic_back.png',
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                /*Spacer(),
                Image.asset(
                  'assets/images/ecms_logo.png', // replace with your image path
                  width: 100,
                  height: 20,
                ),*/
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                  child: Image.asset(
                    'assets/images/ic_home.png', // replace with your image path
                    width: 20,
                    height: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,

          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ATTENDANCE',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                gapH10,
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Month TextField
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            _selectMonth(context);
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: _monthController,
                              decoration: InputDecoration(
                                labelText: 'Month',
                                suffixIcon: Icon(Icons.calendar_month),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors.grey), // Border color
                                ),
                              ),
                              readOnly: true,
                            ),
                          ),
                        ),
                      ),
                      gapW10,
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _selectYear(context);
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: _yearController,
                              decoration: InputDecoration(
                                labelText: 'Year',
                                suffixIcon: Icon(Icons.calendar_month),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors.grey), // Border color
                                ),
                              ),
                              readOnly: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                gapH10,
                Expanded(
                  child: BlocBuilder<ReportBloc, ReportState>(
                    builder: (context, state) {
                      if (state is ReportLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is ReportLoaded) {
                        List<Report> list = state.reportDetails.report;
                        print(list.length);
                        if (list.isEmpty || list.length < 10) {
                          _isListEnd = true;
                        }
                        allData.addAll(list);
                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: allData.length,
                            itemBuilder: (context, index) {
                              if (index == allData.length) {
                                print(_isLoadingMore.toString());
                                // Otherwise, return the CircularProgressIndicator
                                if (_isLoadingMore) {
                                  return Container();
                                } else {
                                  return ListTile(
                                    title: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              } else {
                                final report = allData[index];
                                String name = report.name.toString();
                                String dutyType = report.dutyName.toString();
                                String date = report.date.toString();
                                String checkinTime = report.checkIn.toString();
                                String propertyName = report.propertyName.toString();
                                String regionName = report.regionName.toString();
                                String checkoutTime =
                                    report.checkOut.toString();
                                String workingHours =
                                    report.totalWorkingHours.toString();
                                return Card(
                                  color: Colors.white,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        gapH4,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'assets/images/user.png',
                                              width: 20,
                                            ),
                                            gapW4,
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Name",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                ""
                                                ": $name",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        gapH4,
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'assets/images/building.png',
                                              width: 20,
                                            ),
                                            gapW4,
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Region",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                ""
                                                    ": $regionName",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        gapH4,
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'assets/images/building.png',
                                              width: 20,
                                            ),
                                            gapW4,
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Property Name",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                ""
                                                    ": $propertyName",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        gapH4,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'assets/images/dutytype.png',
                                              width: 20,
                                            ),
                                            gapW4,
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Duty Type",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                ": $dutyType",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        gapH4,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'assets/images/calendar.png',
                                              width: 20,
                                            ),
                                            gapW4,
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Date",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                ": $date",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        gapH4,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'assets/images/checkin.png',
                                              width: 20,
                                            ),
                                            gapW4,
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Check In Time",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                ": $checkinTime",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        gapH4,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'assets/images/checkout.png',
                                              width: 20,
                                            ),
                                            gapW4,
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Check Out Time",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                ": $checkoutTime",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        gapH4,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'assets/images/workinghour.png',
                                              width: 20,
                                            ),
                                            gapW4,
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Working Hours",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                ": $workingHours",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        gapH4,
                                      ],
                                    ),
                                  ),
                                );
                              }
                            });
                      } else if (state is ReportError) {
                        return Center(child: Text(state.message));
                      } else {
                        return Center(child: Text(''));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthPickerDialog extends StatelessWidget {
  final DateTime selectedDate;

  const _MonthPickerDialog({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      child: Container(
        height: 360,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Select Month',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.5),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final month = DateTime(0, index + 1);
                    final isSelected = selectedDate.month == month.month;

                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(
                            context, DateTime(selectedDate.year, month.month));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          DateFormat('MMMM').format(month),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Year Picker Dialog
class _YearPickerDialog extends StatefulWidget {
  final int selectedYear;

  const _YearPickerDialog({required this.selectedYear});

  @override
  _YearPickerDialogState createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<_YearPickerDialog> {
  late int selectedYear;
  final int minYear = 2000;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.selectedYear;
  }

  @override
  Widget build(BuildContext context) {
    final int maxYear = DateTime.now().year;
    Color customColor1 = Color(0xFFCBD4F4);
    Color customColor2 = Color(0xFFF7D9E3);

    return Dialog(
      backgroundColor: AppColors.whiteColor,
      child: Container(
        height: 350,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Select Year',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.5),
                  itemCount: maxYear - minYear + 1,
                  itemBuilder: (context, index) {
                    final year = maxYear - index;
                    final isSelected = selectedYear == year;

                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, year);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            year.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
