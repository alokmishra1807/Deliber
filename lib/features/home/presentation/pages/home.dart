import 'package:deliber/features/home/presentation/widget/bottomsheet.dart';
import 'package:deliber/features/home/presentation/widget/sendparcel.dart';
import 'package:deliber/features/location/presentation/bloc/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}


class HomepageState extends State<Homepage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _defaultCamera = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
         
          BlocListener<LocationBloc, LocationState>(
            listener: (context, state) async {
              if (state is LocationGranted) {
                final controller = await _controller.future;
                await controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        state.location.latitude!,
                        state.location.longitude!,
                      ),
                      zoom: 15,
                    ),
                  ),
                );
              }
            },
            child: GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: _defaultCamera,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
            ),
          ),

          
         Positioned.fill(
  child: BottomSheetWidget(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const Sendparcel(),
      );
    },
  ),
),

        ],
      ),
    );
  }
}
