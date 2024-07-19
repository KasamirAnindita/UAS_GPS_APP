// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:location/location.dart' as locationv2;
// import 'package:trust_location/trust_location.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geocoding/geocoding.dart';

// class GeoMapPage extends StatefulWidget {
//   const GeoMapPage({Key? key}) : super(key: key);

//   @override
//   State<GeoMapPage> createState() => _GeoMapPageState();
// }

// class _GeoMapPageState extends State<GeoMapPage> {
//   locationv2.Location lokasi = locationv2.Location();
//   double _latitude = 0;
//   double _longitude = 0;
//   String? _address;
//   bool isLoading = true;
//   final MapController _mapController = MapController();

//   @override
//   void initState() {
//     super.initState();
//     requestPermission();
//     getLocation();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Flutter Map"),
//       ),
//       body: Container(
//         color: Colors.white,
//         child: Stack(
//           children: [
//             Container(
//               margin: const EdgeInsets.all(0),
//               height: screenSize.height / 1.5,
//               child: displayMap(),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: screenSize.height / 4,
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(15),
//                 margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 5,
//                       blurRadius: 7,
//                       offset: const Offset(0, 3), // changes position of shadow
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       Visibility(
//                         visible: isLoading,
//                         child: const CircularProgressIndicator(
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       isLoading
//                           ? const Text("Sedang mencari lokasi ...")
//                           : Text(
//                               "Lokasi anda adalah \n: Lat : $_latitude \nLong : $_longitude"),
//                       Text("Alamat : \n$_address", textAlign: TextAlign.center),
//                       const SizedBox(height: 20),
//                       Visibility(
//                         visible: !isLoading,
//                         child: ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             primary: Colors.lightBlue,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               isLoading = true;
//                               _address = "";
//                             });
//                             getLocation();
//                           },
//                           icon: const Icon(Icons.my_location_outlined),
//                           label: const Padding(
//                             padding: EdgeInsets.all(15.0),
//                             child: Text("Refres Lokasi",
//                                 style: TextStyle(fontSize: 16)),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Future<bool> requestPermission() async {
//     bool serviceEnabled;
//     locationv2.PermissionStatus permissionGranted;

//     serviceEnabled = await lokasi.serviceEnabled();
//     // Check service
//     if (!serviceEnabled) {
//       serviceEnabled = await lokasi.requestService();
//       if (!serviceEnabled) {
//         return false;
//       }
//     }
//     // Check permission
//     permissionGranted = await lokasi.hasPermission();
//     if (permissionGranted == locationv2.PermissionStatus.denied) {
//       permissionGranted = await lokasi.requestPermission();
//       if (permissionGranted != locationv2.PermissionStatus.granted) {
//         return false;
//       }
//     }
//     return true;
//   }

//   Future<void> getLocation() async {
//     final hasPermission = await requestPermission();
//     if (!hasPermission) {
//       return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Permission Denied'),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: const [
//                   Text(
//                     "Tanpa izin penggunaan lokasi aplikasi ini tidak dapat digunakan dengan baik.\nApa anda yakin menolak izin pengaktifan lokasi?",
//                     style: TextStyle(fontSize: 18.0),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 child: const Text('COBA LAGI'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   requestPermission();
//                 },
//               ),
//               TextButton(
//                 child: const Text('SAYA YAKIN'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       // Get Location
//       TrustLocation.start(5);
//       try {
//         TrustLocation.onChange.listen((values) {
//           var mockStatus = values.isMockLocation;
//           if (mockStatus == true) {
//             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//               content: Text(
//                   'Fake GPS terdeteksi. Mohon non aktifkan fitur Fake GPS Anda'),
//             ));
//             TrustLocation.stop();
//             return;
//           }
//           if (mounted) {
//             setState(() {
//               isLoading = false;
//               _latitude = double.parse(values.latitude.toString());
//               _longitude = double.parse(values.longitude.toString());
//               _mapController.move(LatLng(_latitude, _longitude), 13);
//               getPlace();
//             });
//           }
//         });
//       } on PlatformException catch (e) {
//         debugPrint('PlatformException $e');
//       }
//     }
//   }

//   Future<void> getPlace() async {
//     // This function should use the _latitude and _longitude to get the place information.
//     // Example using the geocoding package:
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(_latitude, _longitude);
//     if (placemarks.isNotEmpty) {
//       Placemark place = placemarks[0];
//       setState(() {
//         _address = "${place.street}, ${place.locality}, ${place.country}";
//       });
//     }
//   }

//   Widget displayMap() {
//     return FlutterMap(
//       mapController: _mapController,
//       options: MapOptions(
//         onTap: LatLng(_latitude, _longitude),
//         maxZoom: 13.0,
//       ),
//       layers: [
//         TileLayerOptions(
//           urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//           subdomains: ['a', 'b', 'c'],
//         ), MarkerLayerOptions(
//           markers: [
//             Marker(
//               width: 80.0,
//               height: 80.0,
//               point: LatLng(_latitude, _longitude),
//               child: (ctx) => const Icon(Icons.location_on, color: Colors.red, size: 40),
//             ),
//           ],
//         ),
//       ], children: [],
//     );
//   }
// }
