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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return totalPrice;
  }

  double getOldJwelleryTotalPrice(Order order) {
    double totalPrice = 0;
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
                      final orderId = order.id;
                      final totalOrderPrice = getOrderTotalPrice(order);
                      final totalOldJwelleryPrice =
                          getOldJwelleryTotalPrice(order);
                      order.copyWith(
                          remaining_payment: totalOrderPrice -
                              totalOldJwelleryPrice -
                              order.advanced_payment);
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
                        // final orderId = event.row!.cells['order_number']!.value;
                        // _showChoiceDialog(orderId, context);
                        // debugPrint(event.row!.cells.toString());
                      }

                      if (event.cell!.column.field == 'action') {
                        final ordere = event.row!.cells;

                        debugPrint(ordere.toString());
                        debugPrint(event.rowIdx!.toString());
                        debugPrint(orders!.elementAt(event.rowIdx!).toString());
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
