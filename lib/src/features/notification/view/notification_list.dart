import 'package:cmms/src/features/notification/bloc/update/notification_update_bloc.dart';
import 'package:cmms/src/features/notification/bloc/update/notification_update_event.dart';
import 'package:cmms/src/features/pendingresponsedetails/model/SubmitResponseModel.dart';
import 'package:cmms/src/helpers/utils/appcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../api/api_service.dart';
import '../../../helpers/utils/utils.dart';
import '../bloc/notification_list_bloc.dart';
import '../bloc/notification_list_event.dart';
import '../bloc/notification_list_state.dart';
import '../bloc/update/notification_update_state.dart';
import '../model/notification_list_model.dart';

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider to provide multiple BLoCs
      providers: [
        BlocProvider<NotificationListBloc>(
          create: (context) =>
              NotificationListBloc(RepositoryProvider.of<ApiService>(context)),
        ),
        BlocProvider<NotificationUpdateBloc>(
          create: (context) => NotificationUpdateBloc(
              RepositoryProvider.of<ApiService>(context)),
        ),
      ],
      child: NotificationListWidgetContent(),
    );
  }
}

class NotificationListWidgetContent extends StatefulWidget {
  @override
  _NotificationListWidgetContentState createState() =>
      _NotificationListWidgetContentState();
}

class _NotificationListWidgetContentState
    extends State<NotificationListWidgetContent> {

  late NotificationListBloc notificationListBloc;
  late NotificationUpdateBloc notificationUpdateBloc;
  List<NotificationItem> allListData = [];
  int? tappedNotificationId;
  int selectedTabIndex = 0; // 0 = Unread, 1 = Read

  @override
  void initState() {
    super.initState();
    notificationListBloc = BlocProvider.of<NotificationListBloc>(context);
    notificationUpdateBloc = BlocProvider.of<NotificationUpdateBloc>(context);
    notificationListBloc.add(NotificationListLoadEvent());
    notificationUpdateBloc.add(NotificationLoadUpdateEvent());
  }

  @override
  void dispose() {
    notificationListBloc.close();
    notificationUpdateBloc.close();
    super.dispose();
  }

  void fetchNotifications({bool reset = true}) {
    if (reset) {
      allListData.clear();
    }
    notificationListBloc.add(NotificationListLoadEvent());
  }

  String formatDate(String? datetime) {
    if (datetime == null || datetime.isEmpty) return "";
    try {
      final dt = DateFormat("yy-MM-dd HH:mm:ss").parse(datetime);
      return DateFormat("hh:mm a").format(dt); // e.g. 06:57 AM
    } catch (e) {
      return "";
    }
  }

  String formatTitle(String key) {
    if (key.toLowerCase() == 'today') {
      return 'Today';
    } else if (key.toLowerCase() == 'yesterday') {
      return 'Yesterday';
    } else {
      try {
        final inputFormat = DateFormat('yyyy-MM-dd');
        final outputFormat = DateFormat('dd-MM-yyyy');
        final date = inputFormat.parse(key);
        return outputFormat.format(date);
      } catch (e) {
        return key; // fallback if the date parsing fails
      }
    }
  }

  List<Widget> groupedCardsByDate() {
    final Map<String, List<NotificationItem>> grouped = {};

    for (var item in allListData) {
      if (item.isHeader) {
        grouped[item.header] = [];
      } else {
        final lastKey = grouped.keys.last;
        grouped[lastKey]?.add(item);
      }
    }

    return grouped.entries.map((entry) {
      final title = formatTitle(entry.key);
      final items = entry.value;

      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Color(0xFF14144C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 12),
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
            // List of notifications
            ...items.map((item) {
              final isRead = item.nread == 1;
              return GestureDetector(
                onTap: isRead
                    ? null
                    : () {
                        setState(() {
                          tappedNotificationId = item.id;
                        });
                        notificationUpdateBloc
                            .add(NotificationListUpdateEvent(item.id));
                      },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: 8.0, top: 4.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isRead ? Color(0xFFF2F6FC) : Colors.white,
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      border: Border.all(
                        // Border color and width
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.data,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isRead ? FontWeight.bold : FontWeight.normal,
                            color:
                                isRead ? Color(0xFFAEADB6) : Color(0xFF5F6394),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              formatDate(item.createdAt),
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFFAEADB6)),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              isRead ? Icons.done_all : Icons.done,
                              size: 16,
                              color: isRead
                                  ? Color(0xFF003CAE)
                                  : Color(0xFFD9D9D9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, "/dashboard");
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, "/dashboard"),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/ic_back.png',
                      width: 25, height: 25, color: Colors.black),
                ),
              ),
           /*   Spacer(),
              Image.asset('assets/images/ecms_logo.png',
                  width: 100, height: 20),*/
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/dashboard'),
                child: Image.asset('assets/images/ic_home.png',
                    width: 20, height: 20, color: Colors.black),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<NotificationListBloc, NotificationListState>(
              listener: (context, state) {
                if (state is NotificationListErrorState) {
                  Utils.showInSnackBar(context, state.error, ToastType.Error);
                }

                if (state is NotificationListLoadedState) {
                  allListData.clear();

                  if (state.notificationList.isEmpty) {
                    setState(() {
                      allListData = [];
                    });
                  } else {
                    final List<NotificationItem> filteredAndFlattened = [];

                    state.notificationList.forEach((header, items) {
                      final filteredItems = items
                          .where((item) =>
                              item.countRead !=
                                  1 && // exclude if count_read is 1
                              (selectedTabIndex == 0
                                  ? item.nread == 0
                                  : item.nread == 1))
                          .toList();

                      if (filteredItems.isNotEmpty) {
                        filteredAndFlattened
                            .add(NotificationItem.asHeader(header));
                        filteredAndFlattened.addAll(filteredItems);
                      }
                    });

                    setState(() {
                      allListData = filteredAndFlattened;
                    });
                  }
                }
              },
            ),
            BlocListener<NotificationListBloc, NotificationListState>(
              listenWhen: (previous, current) =>
                  current is NotificationClearLoadingState ||
                  current is NotificationClearSuccessState ||
                  current is NotificationClearErrorState,
              listener: (context, state) {
                if (state is NotificationClearLoadingState) {
                  // Optional: show loader
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is NotificationClearSuccessState) {
                  Navigator.pop(context); // Close dialog
                  Utils.showInSnackBar(
                      context, state.message, ToastType.Success);
                }

                if (state is NotificationClearErrorState) {
                  Navigator.pop(context); // Close dialog
                  Utils.showInSnackBar(context, state.error, ToastType.Error);
                }
              },
            ),
            BlocListener<NotificationUpdateBloc, NotificationUpdateState>(
              listener: (context, state) async {
                if (state is NotificationUpdateInitialState) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      content: ListTile(
                        leading: CircularProgressIndicator(),
                        title: Text('Loading...'),
                      ),
                    ),
                  );
                } else if (state is NotificationUpdateLoadedState) {
                  Navigator.pop(context);
                  if (state.submitResponseModel.status!) {
                   /* Utils.showInSnackBar(context,
                        state.submitResponseModel.message!, ToastType.Success);*/
                    final index = allListData
                        .indexWhere((item) => item.id == tappedNotificationId);
                    if (index != -1) {
                      setState(() {
                        allListData.removeAt(index);

                        // Check if the header above has no more children
                        if (index - 1 >= 0 && allListData[index - 1].isHeader) {
                          final headerIndex = index - 1;
                          final isNextHeaderOrEnd =
                              (headerIndex + 1 >= allListData.length) ||
                                  allListData[headerIndex + 1].isHeader;

                          if (isNextHeaderOrEnd) {
                            allListData.removeAt(headerIndex);
                          }
                        }
                      });
                    }
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<NotificationListBloc, NotificationListState>(
            builder: (context, state) {
              final bool isLoading = state is NotificationListInitialState;

              return Stack(
                children: [
                  Column(
                    children: [
                      // Info Banner
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFCBD4F4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: Color(0xFF003CAE), size: 20),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  "Notifications will only be shown for the last 7 days.",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF003CAE),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Tabs
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedTabIndex != 0) {
                                    setState(() {
                                      selectedTabIndex = 0;
                                      allListData.clear();
                                    });
                                    notificationListBloc
                                        .add(NotificationListLoadEvent());
                                  }
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selectedTabIndex == 0
                                        ? const Color(0xFF0A2647)
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Unread",
                                    style: TextStyle(
                                      color: selectedTabIndex == 0
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedTabIndex != 1) {
                                    setState(() {
                                      selectedTabIndex = 1;
                                      allListData.clear();
                                    });
                                    notificationListBloc
                                        .add(NotificationListLoadEvent());
                                  }
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selectedTabIndex == 1
                                        ? const Color(0xFF0A2647)
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Read",
                                    style: TextStyle(
                                      color: selectedTabIndex == 1
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // List or Empty Message or Loader
                      Expanded(
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : allListData.isEmpty
                                ? Center(
                                    child: Text(
                                      "No new notifications",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600),
                                    ),
                                  )
                                : ListView(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.all(12),
                                    children: groupedCardsByDate(),
                                  ),
                      ),
                    ],
                  ),
                  if (allListData.any((item) => !item.isHeader))
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(

                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  content: const Text("Are you sure you want to clear all notifications?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        notificationListBloc.add(
                                          NotificationClearEvent(selectedTabIndex == 0 ? 0 : 1),
                                        );
                                      },
                                      child: Text("Clear", style: TextStyle(color: Colors.black)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.clear_all, size: 18),
                            label: const Text("Clear All" ,  style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(8.0),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ),

                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
