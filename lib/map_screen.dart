import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController controller;
  final List<GeoPoint> location = [
    GeoPoint(latitude: 35.5394, longitude: 6.1590),
    GeoPoint(latitude: 35.5307, longitude: 6.1686),
    GeoPoint(latitude: 35.5319, longitude: 6.1888),
  ];
  GeoPoint? geoPoint = null;
  @override
  void initState() {
    controller = MapController(initMapWithUserPosition: true);

    super.initState();
  }

  Future<void> traceAnyPoints() async {
    GeoPoint c = await controller.myLocation();
    List<MultiRoadConfiguration> configs = [];
    location.insert(0, c);

    for (var i = 0; i < location.length; i++) {
      if (i + 1 == location.length) break;
      configs.add(MultiRoadConfiguration(
          startPoint: location[i], destinationPoint: location[i + 1]));
    }
    await controller.drawMultipleRoad(
      configs,
      commonRoadOption: const MultiRoadOption(roadColor: Colors.red),
    );
  }

  void generalMap() {
    for (var i = 0; i < location.length; i++) {
      if (i > 1) {
        controller.addMarker(
          location[i]!,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              color: Colors.blue,
              size: 100,
            ),
          ),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    checkLocationPermission();

    super.didChangeDependencies();
  }

  void checkLocationPermission() async {
    if (await Permission.location.isGranted) {
      print('permission is ok ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          children: [
            Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 35,
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                  onPressed: () async {
                    var address =
                        "En face Kasser el Adala( à coté de l'université, Rte de Biskra, Batna 05000";
                    List<Location> locations =
                        await locationFromAddress(address);
                  },
                  child: Text('address')),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 35,
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                  onPressed: () async {
                    await controller.removeAllShapes();
                    await controller.drawRect(RectOSM(
                        key: 'secound c',
                        centerPoint:
                            GeoPoint(latitude: 35.5319, longitude: 6.1888),
                        distance: 900,
                        color: Colors.redAccent.shade200,
                        strokeWidth: 1));
                  },
                  child: Text('Rect')),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 35,
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                  onPressed: () async {
                    await controller.removeAllShapes();
                    await controller.drawCircle(CircleOSM(
                        key: 'first c',
                        centerPoint:
                            GeoPoint(latitude: 35.5307, longitude: 6.1686),
                        radius: 900,
                        color: Colors.indigoAccent.shade200,
                        strokeWidth: 1));
                  },
                  child: Text('Circle')),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                  onPressed: () async {
                    await controller.zoomIn();
                  },
                  child: Text('+')),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                  onPressed: () async {
                    await controller.zoomOut();
                  },
                  child: Text('-')),
            ),
            FloatingActionButton(
                child: Icon(Icons.location_pin),
                onPressed: () async {
                  try {
                    geoPoint = await controller.myLocation();
                    await controller.addMarker(geoPoint!,
                        markerIcon: MarkerIcon(
                          icon: Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 70,
                          ),
                        ));

                    print(geoPoint);
                  } catch (e) {
                    print(e);
                  }
                }),
          ],
        ),
        appBar: AppBar(
          title: const Text('Flutter love Map'),
        ),
        body: OSMFlutter(
          initZoom: 13,
          showZoomController: true,
          controller: controller,
          onMapIsReady: (_) async {
            await controller.enableTracking();
            await traceAnyPoints();
            generalMap();
            // print('map is ready');
            // await controller.currentLocation();
            // controller.myLocation();
          },
        ));
  }
}
