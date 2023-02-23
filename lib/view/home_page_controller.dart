import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goole_map_config/controller/app_base_controller.dart';
import 'package:goole_map_config/services/direction_repository.dart';

import '../.env.dart';
import '../model/direction_model.dart';

class HomePageControlleer extends AppBaseController {
  Marker? origin;
  Marker? destination;
  LatLng? origiLatlong;
  List<LatLng> polylineCordinate = [];

  LatLng? destinationLatlong;

  final initialCameraPosition =
      const CameraPosition(target: LatLng(22.719568, 75.857727), zoom: 11.5);
  late GoogleMapController googleMapController;

  onLongPressButton(LatLng pos) async {
    if (origin == null || (origin != null && destination != null)) {
      origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'originMarker'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos);
      update();
      origiLatlong = pos;
    } else {
      destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos);
      destinationLatlong = pos;
      getPolyPoint();
      update();

      print("sdhfjkhsjkfsff$polylineCordinate");

      /*final direction = await DirectionsRepository().getDirections(
          origin: origin!.position, destination: destination!.position);*/

    }
  }

  void getPolyPoint() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(origiLatlong!.latitude, origiLatlong!.longitude),
      PointLatLng(destinationLatlong!.latitude, destinationLatlong!.longitude),
    );

    print("++++++++++++++++${origiLatlong!.latitude}");
    print("+++++++++++++res +++${result.status}");
    if (result.points.isNotEmpty) {


      result.points.forEach(
        (PointLatLng point) {
          polylineCordinate.add(
            LatLng(point.latitude, point.longitude)

          );
          print("++++++++++++++++${polylineCordinate}");

        },
      );
      update();
    }
  }

  onPressedButton() {
    return googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition));
  }
}
