import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:priozersk_guide/poi.dart';

List<POI> poiList = [
  POI(
      id: 0,
      name: 'Крепость Корела',
      coordinate: LatLng(61.02983083277181, 30.122644006394296),
      description: 'Описание'),
  POI(
      id: 1,
      name: 'Новый арсенал',
      coordinate: LatLng(61.03003682287837, 30.12268097898709),
      description: 'Описание'),
  POI(
      id: 2,
      name: 'Старый арсенал',
      coordinate: LatLng(61.029900158782795, 30.122103971628206),
      description: 'Описание'),
  POI(
      id: 3,
      name: 'Старый арсенал',
      coordinate: LatLng(61.03011923851216, 30.122162103149265),
      description: 'Описание'),
  POI(
    id: 4,
    name: 'Школа спереди',
    coordinate: LatLng(61.040539641469934, 30.135894464339685),
    description: 'Описание',
    imageName: 'school1_front.jpg',
    poiHotspots: [
      PoiHotspot(
          latitude: -15.0,
          longitude: -129.0,
          width: 90,
          height: 75,
          label: "Next scene",
          icon: Icons.open_in_browser,
          nextPanoId: 5),
      PoiHotspot(
          latitude: -42.0,
          longitude: -46.0,
          width: 60.0,
          height: 60.0,
          label: "Search",
          icon: Icons.search,
          nextPanoId: 5),
      PoiHotspot(
          latitude: -33.0,
          longitude: 123.0,
          width: 60.0,
          height: 60.0,
          label: "Search",
          icon: Icons.arrow_upward,
          nextPanoId: 5),
    ],
  ),
  POI(
      id: 5,
      name: 'Школа справа спереди',
      coordinate: LatLng(61.04107709772825, 30.135408682413413),
      description: 'Описание',
      imageName: 'panorama.jpg'),
  POI(
      id: 6,
      name: 'Школа слева спереди',
      coordinate: LatLng(61.03997409918475, 30.13617599691713),
      description: 'Описание'),
  POI(
      id: 7,
      name: 'Школа слева сзади',
      coordinate: LatLng(61.03977087571255, 30.134704850738473),
      description: 'Описание'),
  POI(
      id: 8,
      name: 'Школа сзади',
      coordinate: LatLng(61.04027090974273, 30.134254950470535),
      description: 'Описание'),
  POI(
      id: 9,
      name: 'Школа справа сзади',
      coordinate: LatLng(61.04087655541389, 30.134100383468592),
      description: 'Описание'),
];
