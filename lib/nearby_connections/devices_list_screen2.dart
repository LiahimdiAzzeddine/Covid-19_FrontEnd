import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:db_qr_code/views/Home.dart';
import 'package:db_qr_code/views/info.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
class DevicesListScreen extends StatefulWidget {
  @override
  _DevicesListScreenState createState() => _DevicesListScreenState();
}
class _DevicesListScreenState extends State<DevicesListScreen> {
  List<Device> devices = [];
  late Device envoyer;
  List<Device> connectedDevices = [];
  late NearbyService nearbyService;
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;
  bool isInit = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    subscription.cancel();
    receivedDataSubscription.cancel();
    nearbyService.stopBrowsingForPeers();
    nearbyService.stopAdvertisingPeer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anti Covid Projet',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(

        primarySwatch: Colors.teal,
    ),
    home: const HomePage(),
    );
  }

  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "disconnected";
      case SessionState.connecting:
        return "waiting";
      default:
        return "connected";
    }
  }
  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return "Connect";
      default:
        return "Disconnect";
    }
  }
  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.black;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }
  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return Colors.green;
      default:
        return Colors.red;
    }
  }
  _onTabItemListener(Device device) {
    if (device.state == SessionState.connected) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            final myController = TextEditingController();
            return AlertDialog(
              title: Text("Send message"),
              content: TextField(controller: myController),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Send"),
                  onPressed: () {
                    nearbyService.sendMessage(
                        device.deviceId, myController.text);
                    myController.text = '';
                  },
                )
              ],
            );
          });
    }
  }
  int getItemCount() {
    return devices.length;
  }
  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        nearbyService.invitePeer(
          deviceID: device.deviceId,
          deviceName: device.deviceName,
        );

        break;
      case SessionState.connected:
        nearbyService.disconnectPeer(deviceID: device.deviceId);
        break;
      case SessionState.connecting:
        break;
    }
  }
  void init() async {

    nearbyService = NearbyService();
    String devInfo ='';
    String androidId='';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      devInfo = androidInfo.device;
      androidId = androidInfo.androidId;
      print("---------------------------------------------------------- devinfo ----------------------------------------------------------");
      print("---------------------------------------------------------- ------- ----------------------------------------------------------");
      print("devinfo " + devInfo);
      print("---------------------------------------------------------- Username ----------------------------------------------------------");
      print("---------------------------------------------------------- ------- ----------------------------------------------------------");
      print("androidId " + androidId);
      print("---------------------------------------------------------- ------- ----------------------------------------------------------");
      print("---------------------------------------------------------- ------- ----------------------------------------------------------");
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      devInfo = iosInfo.localizedModel;
    }

    await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: devInfo,
        strategy: Strategy.P2P_CLUSTER,
        callback: (isRunning) async {
          if (isRunning) {
            try {
              print("--------------------------------------------------------------------------------------------------------");
              print("commencer à parcourir les device");
              print("--------------------------------------------------------------------------------------------------------");
              await nearbyService.stopAdvertisingPeer();
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(Duration(microseconds: 200));
              nearbyService.startAdvertisingPeer();
              await nearbyService.startBrowsingForPeers();
            } catch (e) {
              print("Error:" + e.toString());
            }
          }



        });
    print("--------------------------------------------------------------------------------------------------------");
    subscription =
        nearbyService.stateChangedSubscription(callback: (devicesList) {
          devicesList.forEach((element) {
            print(
                " deviceId: ${element.deviceId} | deviceName: ${element.deviceName} | state: ${element.state}");
            if (Platform.isAndroid) {
              if (element.state == SessionState.connected) {
              } else {
                nearbyService.startBrowsingForPeers();
              }
            }
          });
          print("--------------------------------------------------------------------------------------------------------");

          setState(() {
            devices.clear();
            devices.addAll(devicesList);
            connectedDevices.clear();
            connectedDevices.addAll(devicesList
                .where((d) => d.state == SessionState.connected)
                .toList());
          });
        });
    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
          print("dataReceivedSubscription: ${jsonEncode(data)}");
          showToast(jsonEncode(data),
              context: context,
              axis: Axis.horizontal,
              alignment: Alignment.center,
              position: StyledToastPosition.bottom);
        });


  }
}
