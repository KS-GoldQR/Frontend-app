import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grit_qr_scanner/features/sales/service/sales_service.dart';
import 'package:grit_qr_scanner/models/sales_model.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/global_variables.dart';
import '../../../utils/widgets/loader.dart';
import '../../reusable components/module_details_screen.dart';

class SalesScreen extends StatefulWidget {
  static const String routeName = '/sold-items-screen';
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final GlobalKey _circularProgressIndicatorKey = GlobalKey();
  List<SalesModel>? soldProducts;
  final SalesService _salesService = SalesService();
  GlobalKey _modalProgressHudSalesScreenKey = GlobalKey();
  late List<PlutoColumn> columns;
  bool _isDeleting = false;

  Future<void> getSoldItems() async {
    soldProducts = await _salesService.viewSoldItems(context);
    setState(() {});
  }

  double getSoldProductTotalPrice(SalesModel sale) {
    double totalPrice = 0;
    for (int i = 0; i < sale.products!.length; i++) {
      totalPrice += sale.products![i].amount;
    }
    return totalPrice;
  }

  double getSoldOldProductTotalPrice(SalesModel sale) {
    double totalPrice = 0;
    for (int i = 0; i < sale.oldProducts!.length; i++) {
      totalPrice += sale.oldProducts![i].price;
    }
    return totalPrice;
  }

  Future<void> deleteSale(String saleId, BuildContext context) async {
    setState(() {
      _isDeleting = true;
    });
    bool isDeleted = await _salesService.deleteSoldProduct(
        context: context, salesId: saleId);
    debugPrint(isDeleted.toString());

    if (isDeleted) {
      soldProducts!.removeWhere((element) => element.id == saleId);
    }
    setState(() {
      _isDeleting = false;
    });
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
        title: AppLocalizations.of(context)!.soldDate,
        field: 'created_at',
        type: PlutoColumnType.date(),
        width: width / 4,
        readOnly: true,
        sort: PlutoColumnSort.ascending,
      ),
      PlutoColumn(
        title: AppLocalizations.of(context)!.price,
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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getSoldItems);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isDeleting,
      key: _modalProgressHudSalesScreenKey,
      progressIndicator: const SpinKitDoubleBounce(color: blueColor),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.soldItems),
          centerTitle: false,
        ),
        body: soldProducts == null
            ? Center(
                child: Loader(
                  circularIndicatiorKey: _circularProgressIndicatorKey,
                ),
              )
            : soldProducts!.isEmpty
                ? const Center(
                    child: Text("No products sold yet!"),
                  )
                : PlutoGrid(
                    configuration: const PlutoGridConfiguration(
                      columnSize: PlutoGridColumnSizeConfig(
                        autoSizeMode: PlutoAutoSizeMode.scale,
                      ),
                    ),
                    mode: PlutoGridMode.selectWithOneTap,
                    columns: columns,
                    rows: soldProducts!.map((sale) {
                      final totalSoldProductPrice =
                          getSoldProductTotalPrice(sale);
                      final totalSoldOldProductPrice =
                          getSoldOldProductTotalPrice(sale);

                      return PlutoRow(cells: {
                        'customer_name': PlutoCell(value: sale.customerName),
                        'created_at': PlutoCell(value: sale.createdAt),
                        'amount': PlutoCell(
                            value: totalSoldProductPrice -
                                totalSoldOldProductPrice),
                        'action': PlutoCell(value: "Action")
                      });
                    }).toList(),
                    onSelected: (event) {
                      if (event.cell!.column.field == 'action') {
                        final rowSale = soldProducts!.elementAt(event.rowIdx!);
                        double totalSoldProductPrice =
                            getSoldProductTotalPrice(rowSale);
                        double totalSoldOldProductPrice =
                            getSoldOldProductTotalPrice(rowSale);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModuleDetailsScreen(
                              module: rowSale,
                              totalModulePrice: totalSoldProductPrice,
                              totalOldModulePrice: totalSoldOldProductPrice,
                              isSales: true,
                              deleteModule: () async {
                                await deleteSale(rowSale.id, context);
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
      ),
    );
  }
}
