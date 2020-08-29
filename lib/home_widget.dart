import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'inaturalist_lookup_widget.dart';
import 'placeholder_widget.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  GoogleMapController _controller;

  final LatLng _hampden = const LatLng(39.327588, -76.630449);
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forage'),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        //mapType: MapType.hybrid,
        compassEnabled: true,
        //onTap: _addItem,  -- Can I use this to add an item?
        initialCameraPosition: CameraPosition(
          target: _hampden,
          zoom: 11.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = (controller);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        child: Row(
          children: <Widget>[
            SizedBox(width: 50),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InaturalistLookupWidget()));
              },
              heroTag: null,
              mini: true,
              tooltip: 'Add a new item',
              child: Icon(Icons.add),
            ),
            SizedBox(width: 50),
            FloatingActionButton(
              heroTag: null,
              onPressed: _search,
              mini: true,
              tooltip: 'Search your forage records',
              child: Icon(Icons.search),
            ),
          ],
        ),
      ),
    );
  }

  void _search() {
    debugPrint('Search pressed');
  }

  void _add() {
    debugPrint('Add pressed');
  }
}
