import 'package:aakriti_inteligence/models/product_details_model.dart';
import 'package:aakriti_inteligence/models/product_price_list_model.dart';
import 'package:aakriti_inteligence/models/update_price_model.dart';
import 'package:aakriti_inteligence/utils/api_service.dart';
import 'package:aakriti_inteligence/utils/app_string.dart';
import 'package:aakriti_inteligence/utils/colors.dart';
import 'package:aakriti_inteligence/utils/constant.dart';
import 'package:aakriti_inteligence/utils/my_utitlity.dart';
import 'package:aakriti_inteligence/widgets/custom_btn.dart';
import 'package:aakriti_inteligence/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyLineChart extends StatefulWidget {
  const MyLineChart({
    super.key,
    required this.productId,
    required this.currentPrice,
  });
  final int productId;
  final String currentPrice;

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  List<ProductsData> productsPriceList = [];
  // List<double> prices = [];
  // List<double> dates = [];
  bool pageLoading = true;
  bool isDetailScreen = true;
  bool isLogsScreen = false;
  String? htmlData;
  String noDataFound = '''<center><p>No data found </p></center>''';
  TextEditingController currentPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  bool isButtonClicked = false;

  setLoading(bool value) {
    setState(() {
      pageLoading = value;
    });
  }

  getproductsPrice(int productId) async {
    setLoading(true);
    var data = {"product_id": productId};
    try {
      final response = await ApiService.postApi(
        endpoint: AppStrings.productsPriceApi,
        body: data,
        context: context,
      );
      // debugPrint('productsPrice Res: ${response.statusCode} ${response.body}');
      productsPriceList = [];
      if (response.statusCode == 200) {
        var res = productPriceListModelFromJson(response.body.toString());
        productsPriceList = [];
        if (res.status == 200) {
          productsPriceList = res.productsData;
          // int maxCount =
          //     productsPriceList.length > 7 ? 7 : productsPriceList.length;
          // for (int i = 0; i < maxCount; i++) {
          //   setState(() {
          //     // Price List
          //     prices.add(productsPriceList[i].price);
          //     DateTime date = productsPriceList[i].date;
          //     String ecoTimeStamp = "${date.millisecondsSinceEpoch}";
          //     // Dates List
          //     dates.add(double.parse(ecoTimeStamp));
          //   });
          // }
        } else {
          if (context.mounted) {
            Utility.showCustomSnackbar(context, res.message ?? "Fail", false);
          }
        }
      } else {
        debugPrint("Error = ${response.statusCode} message = ${response.body}");
      }
    } catch (e) {
      debugPrint('Exception Caught: $e');
    } finally {
      setLoading(false);
    }
  }

  getDiscription(int productId) async {
    var data = {"product_id": productId};
    try {
      final response = await ApiService.postApi(
        endpoint: AppStrings.productDiscriptionApi,
        body: data,
        context: context,
      );
      debugPrint('getDiscription Res: ${response.statusCode} ${response.body}');
      htmlData = null;
      if (response.statusCode == 200) {
        var res = productDetailsModleFromJson(response.body.toString());
        if (res.status == 200) {
          if (context.mounted) {
            htmlData = res.data.description;
          }
        } else {
          if (context.mounted) {
            Utility.showCustomSnackbar(
                context, res.message ?? "Error Caught", false);
          }
        }
      } else {
        debugPrint("Error = ${response.statusCode} message = ${response.body}");
      }
    } catch (e) {
      debugPrint('Exception Caught: $e');
    }
  }

  updatePrice({required int productId, required String price}) async {
    var data = {
      "product_id": productId,
      "price": price,
    };
    try {
      final response = await ApiService.postApi(
        endpoint: AppStrings.updatePriceApi,
        body: data,
        context: context,
      );
      debugPrint('updatePrice Res: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var res = updatePriceModleFromJson(response.body.toString());
        if (res.status == 200) {
          if (context.mounted) {
            currentPriceController.clear();
            newPriceController.clear();
            Utility.showCustomSnackbar(context, res.message ?? "Success", true);
            setState(() {
              refereshData();
            });
          }
        } else {
          if (context.mounted) {
            Utility.showCustomSnackbar(
                context, res.message ?? "Error Caught", false);
          }
        }
      } else {
        debugPrint("Error = ${response.statusCode} message = ${response.body}");
      }
    } catch (e) {
      debugPrint('Exception Caught: $e');
    }
  }

  showMyDialog(BuildContext context, String currentPrice) async {
    currentPriceController.text = 'Rs.$currentPrice /-';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: CustomTextWidget(
                  text: "Update Price",
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(),
            TextField(
              readOnly: true,
              controller: currentPriceController,
              decoration: const InputDecoration(labelText: 'Current Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: newPriceController,
              decoration: const InputDecoration(
                labelText: 'Add Price',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomElevatedButton(
                  child: const Text('Proceed'),
                  onPressed: () {
                    updatePrice(
                      productId: widget.productId,
                      price: newPriceController.text,
                    );
                    Navigator.pop(context);
                  },
                ),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: AppColors.kaccentColor,
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  bool admin = false;
  refereshData() async {
    debugPrint("Product--id===> ${widget.productId}");
    setLoading(true);
    getDiscription(widget.productId);
    getproductsPrice(widget.productId);
    admin = await Utility.getAdminStatus();
  }

  // Function to get the day name from the weekday index
  String getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  @override
  void initState() {
    refereshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ProductsData> latestData = productsPriceList.length > 7
        ? productsPriceList.sublist(productsPriceList.length - 7)
        : productsPriceList;
    return Scaffold(
      appBar: AppBar(
        title: const CustomTextWidget(
          text: "Chart View",
          fontSize: headerFontSize,
        ),
      ),
      body: pageLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: CustomTextWidget(
                            text: 'Price History Chart',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        admin == true
                            ? CustomElevatedButton(
                                child: const CustomTextWidget(
                                  text: 'Modify Price',
                                  color: AppColors.kwhiteColor,
                                ),
                                onPressed: () {
                                  showMyDialog(
                                    context,
                                    productsPriceList.isEmpty
                                        ? widget.currentPrice
                                        : productsPriceList.first.price
                                            .toString(),
                                  );
                                },
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      height: 0.5.sh,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: AppColors.kwhiteColor,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 24, bottom: 16, left: 20, right: 16),
                          child: productsPriceList.isEmpty
                              ? const Center(
                                  child: Text("No Data Found"),
                                )
                              : SfCartesianChart(
                                  primaryXAxis: DateTimeAxis(isVisible: true),
                                  primaryYAxis: NumericAxis(),
                                  series: <ChartSeries>[
                                    LineSeries<ProductsData, DateTime>(
                                      dataSource: latestData,
                                      xValueMapper: (ProductsData entry, _) =>
                                          entry.date,
                                      yValueMapper: (ProductsData entry, _) =>
                                          entry.price,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                        isVisible: true,
                                      ),
                                    ),
                                  ],
                                ),
                          // LineChart(
                          //     LineChartData(
                          //       gridData: const FlGridData(show: true),
                          //       titlesData: const FlTitlesData(
                          //         show: true,
                          //         topTitles: AxisTitles(
                          //             sideTitles: SideTitles(
                          //                 reservedSize: 30,
                          //                 showTitles: false)),
                          //         rightTitles: AxisTitles(
                          //             sideTitles: SideTitles(
                          //           // getTitlesWidget: (value, meta) {
                          //           //   return
                          //           // },
                          //           reservedSize: 44,
                          //           showTitles: false,
                          //         )),
                          //       ),
                          //       borderData: FlBorderData(
                          //         show: true,
                          //         border: const Border(
                          //           left: BorderSide(
                          //             color: Color(0xff37434d),
                          //             width: 1,
                          //           ),
                          //           bottom: BorderSide(
                          //             color: Color(0xff37434d),
                          //             width: 1,
                          //           ),
                          //           right: BorderSide(
                          //             color: Color(0xff37434d),
                          //             width: 1,
                          //           ),
                          //         ),
                          //       ),
                          //       minX: dates.isNotEmpty ? dates.first : 0.0,
                          //       maxX: dates.isNotEmpty ? dates.last : 0.0,
                          //       minY: prices.isNotEmpty
                          //           ? prices.reduce((a, b) => a < b ? a : b)
                          //           : 0.0,
                          //       maxY: prices.isNotEmpty
                          //           ? prices.reduce((a, b) => a > b ? a : b)
                          //           : 0.0,
                          //       lineBarsData: [
                          //         LineChartBarData(
                          //           spots: List.generate(
                          //             dates.isNotEmpty ? dates.length : 0,
                          //             (index) => FlSpot(
                          //               dates.isNotEmpty ? dates[index] : 0,
                          //               prices.isNotEmpty
                          //                   ? prices[index]
                          //                   : 0,
                          //             ),
                          //           ),
                          //           isCurved: true,
                          //           belowBarData: BarAreaData(
                          //             show: true,
                          //             color: AppColors.kChartAreaColor,
                          //           ),
                          //           shadow: const Shadow(
                          //               color: Colors.transparent),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.12.sh,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: CustomElevatedButton(
                                      backgroundColor: isDetailScreen
                                          ? AppColors.kbuttonColor
                                          : AppColors.kprimaryColor
                                              .withOpacity(0.5),
                                      child: const CustomTextWidget(
                                          text: 'Description',
                                          color: AppColors.kwhiteColor),
                                      onPressed: () {
                                        setState(() {
                                          isDetailScreen = true;
                                          isLogsScreen = false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: CustomElevatedButton(
                                      backgroundColor: isLogsScreen
                                          ? AppColors.kbuttonColor
                                          : AppColors.kprimaryColor
                                              .withOpacity(0.5),
                                      child: const CustomTextWidget(
                                        text: 'Price History',
                                        color: AppColors.kwhiteColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isDetailScreen = false;
                                          isLogsScreen = true;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isLogsScreen == true) ...[
                      productsPriceList.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              height: 0.8.sh,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: productsPriceList.length,
                                itemBuilder: (context, index) {
                                  final historyItem = productsPriceList[index];
                                  final price = historyItem.price;
                                  final date = historyItem.date;
                                  return Card(
                                    elevation: 5,
                                    margin: const EdgeInsets.all(8),
                                    child: ListTile(
                                      title: CustomTextWidget(
                                        text: 'Price: Rs.$price /-',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      subtitle: CustomTextWidget(
                                        text:
                                            'Date: ${DateFormat('dd-MMM-yyyy').format(date)}',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                    if (isDetailScreen == true) ...[
                      htmlData == null
                          ? SizedBox(
                              height: 0.2.sh,
                              child: const Center(
                                child: CustomTextWidget(
                                  text: "No Data Found",
                                ),
                              ),
                            )
                          : SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: globalPadding,
                                  vertical: 2,
                                ),
                                child: HtmlWidget(
                                  htmlData ?? noDataFound,
                                  renderMode: RenderMode.column,
                                  textStyle: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                    ],
                  
                  ],
                ),
              ),
            ),
    );
  }
}

class SalesData {
  SalesData(this.day, this.price);
  final DateTime day;
  final double price;
}
