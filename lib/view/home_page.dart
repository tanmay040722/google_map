import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goole_map_config/view/home_page_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  HomePageControlleer homeController = Get.put(HomePageControlleer());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageControlleer>(
        builder: (controller) => Scaffold(
              body: GoogleMap(
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: homeController.initialCameraPosition,
                onMapCreated: (mapcontroller) =>
                    homeController.googleMapController = mapcontroller,
                markers: {
                  if (homeController.origin != null) homeController.origin!,
                  if (homeController.destination != null)
                    homeController.destination!
                },
                onLongPress: homeController.onLongPressButton,
                polylines: {
                   Polyline(
                    polylineId: PolylineId("rout"),
                    points: homeController.polylineCordinate,
                  ),
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => homeController.onPressedButton(),
                child: Icon(Icons.maps_ugc_outlined),
              ),
            ));
  }
}
