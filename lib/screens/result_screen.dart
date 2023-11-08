import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  static const String routeName = '/result-screen';
  final Map<String, dynamic> args;
  const ResultScreen({
    super.key,
    required this.args,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Scan QR Again?'),
            content: const Text('All Progress Will Be Lost!'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  widget.args['callback']();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              widget.args['callback']();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("Result Page"),
        ),
        body: Center(
          child: Column(
            children: [
              const Text("rEsult scrreen"),
              Text(widget.args['data']),
            ],
          ),
        ),
      ),
    );
  }
}
