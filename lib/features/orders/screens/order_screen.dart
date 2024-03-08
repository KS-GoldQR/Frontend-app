import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../models/order_model.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/widgets/loader.dart';
import '../../reusable%20components/module_details_screen.dart';
import '../services/order_service.dart';
import 'create_order_screen.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = '/order-screen';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order>? orders;
  final GlobalKey _modalProgressHUDKeyOrderScreen = GlobalKey();
  final OrderService _orderService = OrderService();
  final GlobalKey _circularProgressIndicatorKey = GlobalKey();
  late List<PlutoColumn> columns;
  bool _isDeleting = false;

  Future<void> getAllOrders() async {
    debugPrint("hello yadava");
    orders = await _orderService.getAllOrders(context);
    setState(() {});
    debugPrint("hellow niesh");
    debugPrint(orders.toString());
  }

  Future<void> deleteOrder(String orderId, BuildContext context) async {
    setState(() {
      _isDeleting = true;
    });
    bool isDeleted =
        await _orderService.deleteOrder(context: context, orderId: orderId);
    if (isDeleted) {
      orders!.removeWhere((element) => element.id == orderId);
    }
    setState(() {
      _isDeleting = false;
    });
  }

  double getOrderTotalPrice(Order order) {
    double totalPrice = 0;
    for (int i = 0; i < order.ordered_items!.length; i++) {
      totalPrice += order.ordered_items![i].totalPrice;
    }
    return totalPrice;
  }

  double getOldJwelleryTotalPrice(Order order) {
    double totalPrice = 0;
    for (int i = 0; i < order.old_jwellery!.length; i++) {
      totalPrice += order.old_jwellery![i].price;
    }
    return totalPrice;
  }

  // double getOldJwelleryCharge(Order order) {
  //   double totalPrice = 0;
  //   for (int i = 0; i < order.old_jwellery!.length; i++) {
  //     totalPrice += (order.old_jwellery![i].charge ?? 0.0);
  //   }
  //   return totalPrice;
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getAllOrders);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    columns = _buildColumns();
  }

  List<PlutoColumn> _buildColumns() {
    final width = MediaQuery.sizeOf(context).width;
    return columns = [
      PlutoColumn(
        title: AppLocalizations.of(context)!.name,
        field: 'customer_name',
        type: PlutoColumnType.text(),
        width: width / 4,
        readOnly: true,
      ),
      PlutoColumn(
        title: AppLocalizations.of(context)!.deadline,
        field: 'deadline',
        type: PlutoColumnType.date(),
        width: width / 4,
        readOnly: true,
        sort: PlutoColumnSort.ascending,
      ),
      PlutoColumn(
        title: AppLocalizations.of(context)!.remaining,
        field: 'amount',
        formatter: (value) => NumberFormat('#,##,###.00').format(value),
        type: PlutoColumnType.number(
          allowFirstDot: true,
        ),
        width: width / 4,
        readOnly: true,
      ),
      PlutoColumn(
        title: AppLocalizations.of(context)!.action,
        field: "action",
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return const Icon(
            Icons.remove_red_eye,
          );
        },
        width: width / 10,
        readOnly: true,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      key: _modalProgressHUDKeyOrderScreen,
      inAsyncCall: _isDeleting,
      progressIndicator: const SpinKitDoubleBounce(color: blueColor),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.orders,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: orders == null
            ? Center(
                child: Loader(
                  circularIndicatiorKey: _circularProgressIndicatorKey,
                ),
              )
            : orders!.isEmpty
                ? const Center(
                    child: Text("No Orders Yet!"),
                  )
                : PlutoGrid(
                    configuration: const PlutoGridConfiguration(
                      columnSize: PlutoGridColumnSizeConfig(
                        autoSizeMode: PlutoAutoSizeMode.scale,
                      ),
                    ),
                    mode: PlutoGridMode.selectWithOneTap,
                    columns: columns,
                    rows: orders!.map((order) {
                      final totalOrderPrice = getOrderTotalPrice(order);
                      final totalOldJwelleryPrice =
                          getOldJwelleryTotalPrice(order);

                      return PlutoRow(cells: {
                        'customer_name': PlutoCell(value: order.customer_name),
                        'deadline': PlutoCell(value: order.expected_deadline),
                        'amount': PlutoCell(
                            value: totalOrderPrice -
                                totalOldJwelleryPrice -
                                order.advanced_payment),
                        'action': PlutoCell(value: "Action")
                      });
                    }).toList(),
                    onSelected: (event) {
                      if (event.cell!.column.field == 'action') {
                        final rowOrder = orders!.elementAt(event.rowIdx!);
                        double totalOrderedPrice = getOrderTotalPrice(rowOrder);
                        double totalOldJwelleryPrice =
                            getOldJwelleryTotalPrice(rowOrder);
                        // double totalOldJwelleryCharge =
                        //     getOldJwelleryCharge(rowOrder);

                        // Update the order with copyWith
                        final updatedOrder = rowOrder.copyWith(
                            remaining_payment: totalOrderedPrice -
                                totalOldJwelleryPrice -
                                rowOrder.advanced_payment
                            //  -totalOldJwelleryCharge
                            );

                        //if you want to get updates orders list
                        /*
                        // Find the index of the order in the list
                        final index = orders!
                            .indexWhere((order) => order.id == updatedOrder.id);

                        if (index != -1) {
                          // Create a new list with the updated order
                          final updatedOrders = List<Order>.from(orders!);
                          updatedOrders[index] = updatedOrder;

                          // Assign the updated list back to 'orders'
                          orders = updatedOrders;
                        }
                        */

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModuleDetailsScreen(
                              module: updatedOrder,
                              totalModulePrice: totalOrderedPrice,
                              totalOldModulePrice: totalOldJwelleryPrice,
                              // totalOldJwelleryCharge: totalOldJwelleryCharge,
                              isSales: false,
                              deleteModule: () async {
                                await deleteOrder(updatedOrder.id, context);
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, CreateOrderScreen.routeName);
          },
          label: Text(
            AppLocalizations.of(context)!.createOrder,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: blueColor,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
