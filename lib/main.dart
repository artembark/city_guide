import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:panorama/panorama.dart';
import 'package:priozersk_guide/poi_data.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWeatherApp(),
    );
  }
}

class MyWeatherApp extends StatefulWidget {
  @override
  _MyWeatherAppState createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  var latitude = 0.0;
  var longitude = 0.0;
  int id = 0;

  Circle _selectedCircle;

  GlobalKey _keyMapContainer = GlobalKey();

  double heightMapContainer = 600;

  _getSizes() {
    final RenderBox renderBoxRed =
        _keyMapContainer.currentContext.findRenderObject();
    double newHeightMapContainer = renderBoxRed.size.height;
    setState(() {
      if (newHeightMapContainer > 100) {
        heightMapContainer = newHeightMapContainer;
      }
    });
    print("Height of keyMapContainer: $heightMapContainer");
  }

  MapboxMapController mapController;
  final snappingSheetController = SnappingSheetController();

  getCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((Position position) {
      setState(() {
        mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 17.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  void _onCircleTapped(Circle circle) async {
    if (_selectedCircle != null) {
      _updateSelectedCircle(
        const CircleOptions(circleRadius: 8),
      );
    }
    setState(() {
      _selectedCircle = circle;
    });
    _updateSelectedCircle(
      CircleOptions(
        circleRadius: 16,
        circleColor: '#FF0000',
      ),
    );

    snappingSheetController.snapToPosition(SnapPosition(positionFactor: 0.5));

    LatLng latLng = await mapController.getCircleLatLng(_selectedCircle);

    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 17.0,
        ),
      ),
    );

    for (var i in poiList) {
      if (i.coordinate == latLng) {
        setState(() {
          id = i.id;
        });
        break;
      }
    }
  }

  void _updateSelectedCircle(CircleOptions changes) {
    mapController.updateCircle(_selectedCircle, changes);
  }

  double _lon = 0;
  double _lat = 0;
  double _tilt = 0;

  void onViewChanged(longitude, latitude, tilt) {
    setState(() {
      _lon = longitude;
      _lat = latitude;
      _tilt = tilt;
    });
  }

  Widget hotspotButton({String text, IconData icon, VoidCallback onPressed}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(CircleBorder()),
            backgroundColor: MaterialStateProperty.all(Colors.black38),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Icon(icon),
          onPressed: onPressed,
        ),
        text != null
            ? Container(
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Center(child: Text(text)),
              )
            : Container(),
      ],
    );
  }

  List<Hotspot> generateHotspots() {
    List<Hotspot> hotspotList = [];
    if (poiList[id].poiHotspots != null) {
      for (var i in poiList[id].poiHotspots) {
        Hotspot hotspot = Hotspot(
            latitude: i.latitude,
            longitude: i.longitude,
            height: i.height,
            width: i.width,
            widget:
                hotspotButton(text: i.label, icon: i.icon, onPressed: () {}));
        hotspotList.add(hotspot);
      }

      return hotspotList;
    } else
      return null;
  }

  panoramaOrNo() {
    if (poiList[id].imageName != null) {
      return Stack(
        children: [
          ClipRect(
            child: Panorama(
                sensitivity: 2.0,
                onViewChanged: onViewChanged,
                child: Image.asset('assets/${poiList[id].imageName}'),
                hotspots: generateHotspots()),
          ),
          Text(
              '${_lon.toStringAsFixed(3)}, ${_lat.toStringAsFixed(3)}, ${_tilt.toStringAsFixed(3)}'),
        ],
      );
    } else
      return Container(
        alignment: Alignment.topCenter,
        child: Text('Нет панорамы для данной точки'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Путеводитель'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.navigation),
            tooltip: 'По GPS',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Получаем текущее положение по GPS')));
              getCurrentLocation();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: heightMapContainer,
            child: MapboxMap(
              accessToken: 'token',
              initialCameraPosition: CameraPosition(
                zoom: 13.0,
                target: LatLng(61.04, 30.13),
              ),
              trackCameraPosition: true,
              rotateGesturesEnabled: false,
              onMapCreated: (MapboxMapController controller) async {
                mapController = controller;
                controller.onCircleTapped.add(_onCircleTapped);
                for (var i in poiList) {
                  mapController.addCircle(
                    CircleOptions(
                      circleBlur: 0.1,
                      circleStrokeWidth: 1,
                      circleStrokeColor: '#FF0000',
                      circleRadius: 12.0,
                      circleColor: '#006992',
                      circleOpacity: 0.8,
                      geometry: i.coordinate,
                      draggable: false,
                    ),
                  );
                }
                snappingSheetController.snapToPosition(SnapPosition(
                    positionFactor:
                        0.5)); //надо найти способ обновлять зону жестов карты
              },
              onMapClick: (Point<double> point, LatLng coordinates) {
                print('(${coordinates.latitude},${coordinates.longitude})');
              },
            ),
          ),
          SnappingSheet(
            child: Container(),
            sheetBelow: SnappingSheetContent(
                child: panoramaOrNo(),
                draggable: false,
                heightBehavior: SnappingSheetHeight.fixed()),
            grabbing: Container(
                alignment: Alignment.center,
                height: 5.0,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15.0),
                      topRight: const Radius.circular(15.0),
                    )),
                child: Container(
                  width: 50,
                  child: Divider(
                    color: Colors.grey[500],
                    thickness: 2,
                  ),
                )),
            grabbingHeight: 25,
            sheetAbove: SnappingSheetContent(
              child: Container(
                key: _keyMapContainer,
              ),
              heightBehavior: SnappingSheetHeight.fit(),
            ),
            onSnapEnd: () {
              _getSizes();
            },
            snappingSheetController: snappingSheetController,
            snapPositions: [
              SnapPosition(
                  positionFactor: 0.1,
                  snappingCurve: Curves.ease,
                  snappingDuration: Duration(milliseconds: 300)),
              SnapPosition(
                  positionFactor: 0.5,
                  snappingCurve: Curves.ease,
                  snappingDuration: Duration(milliseconds: 300)),
              SnapPosition(
                  positionFactor: 1.0,
                  snappingCurve: Curves.ease,
                  snappingDuration: Duration(milliseconds: 300)),
            ],
            initSnapPosition: SnapPosition(positionFactor: 0.5),
          ),
        ],
      ),
    );
  }
}
