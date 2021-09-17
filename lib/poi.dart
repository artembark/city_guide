import 'package:flutter/cupertino.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:panorama/panorama.dart';

class POI {
  int id;
  String name;
  LatLng coordinate;
  String description;
  String imageName;
  List<PoiHotspot> poiHotspots;

  POI(
      {this.id,
      this.name,
      this.coordinate,
      this.description,
      this.imageName,
      this.poiHotspots});
}

class PoiHotspot {
  double latitude;
  double longitude;
  double width;
  double height;
  String label;
  IconData icon;
  int nextPanoId;

  PoiHotspot(
      {this.latitude,
      this.longitude,
      this.width,
      this.height,
      this.label,
      this.icon,
      this.nextPanoId});
}
