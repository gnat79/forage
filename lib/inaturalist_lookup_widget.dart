import 'package:flutter/material.dart';
import 'assets/custom_icons.dart';
import 'testquery.dart';

//import 'query_results_widget.dart';

class InaturalistLookupWidget extends StatefulWidget {
  @override
  _InatStateWidget createState() => _InatStateWidget();
}

class _InatStateWidget extends State<InaturalistLookupWidget> {
  final query_controller = TextEditingController();
  @override
  void dispose() {
    query_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search iNaturalist"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestQuery(
                query: query_controller.text,
              ),
            ),
          );
        },
        label: Text('Search iNaturalist'),
        icon: Icon(CustomIcons.inaturalist),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(48),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'iNaturalist taxon query text',
          ),
          controller: query_controller,
        ),
      ),
    );
  }
}
