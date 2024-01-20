import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grit_qr_scanner/features/orders/screens/create_order_screen.dart';
import 'package:grit_qr_scanner/features/orders/services/order_service.dart';
import 'package:grit_qr_scanner/models/order_model.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/widgets/loader.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pluto_grid/pluto_grid.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = '/order-screen';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order>? orders;
  final OrderService _orderService = OrderService();
  late List<PlutoColumn> columns;
  bool _isDeleting = false;

  Future<void> getAllOrders() async {
    orders = await _orderService.getAllOrders(context);
    setState(() {});
  }

  Future<void> _showChoiceDialog(String orderId, BuildContext context) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'Delete Order',
      desc: 'deleteing order is irreversible action!',
      btnOkText: 'Yes',
      btnCancelText: 'No',
      btnOkColor: Colors.green,
      btnCancelColor: Colors.red,
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        setState(() {
          _isDeleting = true;
        });
        await _orderService.deleteOrder(context: context, orderId: orderId);
        orders!.removeWhere((element) => element.id == orderId);
        setState(() {
          _isDeleting = false;
        });
      },
    ).show();
  }

  double getOrderTotalPrice(Order order) {
    double totalPrice = 0;
    for (int i = 0; i < order.ordered_items!.length; i++) {
      totalPrice += order.ordered_items![i].totalPrice;
    }

    for (int i = 0; i < order.old_jwellery!.length; i++) {
      totalPrice += order.old_jwellery![i].price;
    }
    return totalPrice;
  }

  @override
  void initState() {
    super.initState();
    getAllOrders();
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
        title: 'Order No.',
        field: 'order_number',
        type: PlutoColumnType.text(),
        width: width / 6,
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Customer Name',
        field: 'customer_name',
        type: PlutoColumnType.text(),
        width: width / 6,
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Deadline',
        field: 'deadline',
        type: PlutoColumnType.date(),
        width: width / 6,
        readOnly: true,
        sort: PlutoColumnSort.ascending,
      ),
      PlutoColumn(
        title: 'Remaining Amount',
        field: 'amount',
        type: PlutoColumnType.number(
          allowFirstDot: true,
          negative: false,
        ),
        width: width / 6,
        readOnly: true,
      ),
      PlutoColumn(
        title: 'See Details',
        field: 'see_details',
        type: PlutoColumnType.text(),
        width: width / 6,
        readOnly: true,
      ),
      PlutoColumn(
        title: "Delete",
        field: "delete",
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return const Icon(
            Icons.delete,
            color: Colors.red,
          );
        },
        width: width / 6,
        readOnly: true,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isDeleting,
      progressIndicator: const SpinKitDoubleBounce(color: blueColor),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Orders",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blueColor,
            ),
          ),
        ),
        body: orders == null
            ? const Center(
                child: Loader(),
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
                      final totalPrice = getOrderTotalPrice(order);
                      order.copyWith(
                          remaining_payment:
                              totalPrice - order.advanced_payment);
                      return PlutoRow(cells: {
                        'order_number': PlutoCell(value: order.id),
                        'customer_name': PlutoCell(value: order.customer_name),
                        'deadline': PlutoCell(value: order.expected_deadline),
                        'amount': PlutoCell(
                            value: totalPrice - order.advanced_payment),
                        'see_details': PlutoCell(value: 'See Details'),
                        'delete': PlutoCell(value: "delete")
                      });
                    }).toList(),
                    onSelected: (event) {
                      if (event.cell!.column.field == 'delete') {
                        final orderId = event.row!.cells['order_number']!.value;
                        _showChoiceDialog(orderId, context);
                        debugPrint(orderId);
                      }

                      if (event.cell!.column.field == 'see_details') {
                        final order = event.row!.cells;
                        debugPrint(order.toString());
                        // TODO(dhiraj): implement invoice after requestion an api
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Scaffold(
                                      body: Center(
                                        child: Text("To Be Implemented"),
                                      ),
                                    )));
                      }
                    },
                  ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, CreateOrderScreen.routeName);
          },
          label: const Text(
            "Create Order",
            style: TextStyle(
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
