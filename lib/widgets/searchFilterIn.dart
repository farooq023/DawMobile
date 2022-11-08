import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../providers/inboxFilterPro.dart';

class SearchFilterIn extends StatefulWidget {
  const SearchFilterIn({super.key});

  @override
  State<SearchFilterIn> createState() => _SearchFilterInState();
}

class _SearchFilterInState extends State<SearchFilterIn> {
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();

  TextEditingController reqNoCtrl = TextEditingController();
  TextEditingController subjectCtrl = TextEditingController();

  // String reqNoCtrl = '';
  // String subjectCtrl = '';

  @override
  void initState() {
    callProviders();
  }

  void callProviders() {
    reqNoCtrl.text = InFilterProvider.reqNo;
    subjectCtrl.text = InFilterProvider.subject;

    startDateCtrl.text = InFilterProvider.startDate;
    endDateCtrl.text = InFilterProvider.endDate;

    setState(() {});
  }

  void search() {
    if (reqNoCtrl.text != '' ||
        subjectCtrl.text != '' ||
        startDateCtrl.text != '' ||
        endDateCtrl.text != '') {
      Provider.of<InFilterProvider>(context, listen: false).setFilterToTrue(
        reqNoCtrl.text,
        subjectCtrl.text,
        startDateCtrl.text,
        endDateCtrl.text,
      );
      Navigator.pushReplacementNamed(context, '/inbox');
    } else {
      Navigator.pop(context);
    }
  }

  void clearFilter() {
    if (InFilterProvider.filter) {
      InFilterProvider.setFilterToFalse();
      Navigator.pushReplacementNamed(context, '/inbox');
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    final mHeight = mSize.height;
    final mWidth = mSize.width;

    return Container(
      height: mHeight * 0.75,
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.all(10), 
      child: SingleChildScrollView(
        //SingleChildScrollView

        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  AppLocalizations.of(context)!.searchFilter,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.numbers),
                    Container(
                      width: mWidth * 0.82,
                      child: TextFormField(
                        controller: reqNoCtrl,
                        // initialValue: reqNoCtrl.text,
                        // style: TextStyle(fontSize: 10.0, height: 2.0, color: Colors.black),
                        // onChanged: (val) {
                        //   reqNoCtrl = val;
                        // },
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          // hintText: AppLocalizations.of(context)!.search,
                          labelText: AppLocalizations.of(context)!.reqNo,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          suffixIcon: reqNoCtrl.text != ''
                              ? IconButton(
                                  onPressed: () {
                                    // setState(() {
                                    //   reqNoCtrl.clear();
                                    // });
                                    reqNoCtrl.clear();
                                  },
                                  icon: const Icon(Icons.clear),
                                )
                              : null,
                        ),
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.subject),
                    Container(
                      width: mWidth * 0.82,
                      child: TextFormField(
                        controller: subjectCtrl,
                        // initialValue: subjectCtrl.text,
                        // style: TextStyle(fontSize: 10.0, height: 2.0, color: Colors.black),
                        // onChanged: (val) {
                        //   subjectCtrl = val;
                        // },
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          // hintText: AppLocalizations.of(context)!.search,
                          labelText: AppLocalizations.of(context)!.subject,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          suffixIcon: subjectCtrl.text != ''
                              ? IconButton(
                                  onPressed: () {
                                    subjectCtrl.clear();
                                    // setState(() {
                                    //   subjectCtrl.clear();
                                    // });
                                  },
                                  icon: const Icon(Icons.clear),
                                )
                              : null,
                        ),
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.calendar_month),
                    Container(
                      width: mWidth * 0.82,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: mWidth * 0.4,
                            child: TextField(
                              // onChanged: (val) {
                              //   // searchText = val.toLowerCase();
                              //   // searchMail();
                              // },
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                // hintText: AppLocalizations.of(context)!.search,
                                labelText: "Start Date",
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                suffixIcon: startDateCtrl.text != ''
                                    ? IconButton(
                                        onPressed: () {
                                          // setState(() {
                                          //   startDateCtrl.clear();
                                          //   endDateCtrl.clear();
                                          // });
                                          startDateCtrl.clear();
                                          endDateCtrl.clear();
                                        },
                                        icon: const Icon(Icons.clear),
                                      )
                                    : null,
                              ),
                              textInputAction: TextInputAction.search,
                              controller: startDateCtrl,
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    String formattedDate =
                                        DateFormat("dd/MM/yyyy")
                                            .format(pickedDate);
                                    startDateCtrl.text = formattedDate;
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            width: mWidth * 0.4,
                            child: TextField(
                              enabled: startDateCtrl.text != '',
                              // onChanged: (val) {
                              //   // searchText = val.toLowerCase();
                              //   // searchMail();
                              // },
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                // hintText: AppLocalizations.of(context)!.search,
                                labelText: "End Date",
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                suffixIcon: endDateCtrl.text != ''
                                    ? IconButton(
                                        onPressed: () {
                                          endDateCtrl.clear();

                                          // setState(() {
                                          //   endDateCtrl.clear();
                                          // });
                                        },
                                        icon: const Icon(Icons.clear),
                                      )
                                    : null,
                                // icon: Icon(Icons.calendar_month)
                              ),
                              textInputAction: TextInputAction.search,
                              controller: endDateCtrl,
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateFormat('dd/MM/yyyy')
                                      .parse(startDateCtrl.text),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    String formattedDate =
                                        DateFormat("dd/MM/yyyy")
                                            .format(pickedDate);
                                    endDateCtrl.text = formattedDate;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // Container()
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       ElevatedButton(
              //         onPressed: clearFilter,
              //         child: Text(
              //           'Clear',
              //         ),
              //       ),
              //       ElevatedButton(
              //         onPressed: search,
              //         child: Text(
              //           AppLocalizations.of(context)!.search,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: mWidth * 0.4,
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     color: Colors.black,
                  //     width: 1,
                  //   ),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: clearFilter,
                        child: Text(
                          AppLocalizations.of(context)!.clear,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: search,
                        child: Text(
                          AppLocalizations.of(context)!.search,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
