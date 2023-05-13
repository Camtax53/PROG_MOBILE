import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/auth.dart';
import 'package:flutter_application_1/tuto/multigameWifi.dart';
import 'dart:io';

import 'dart:async';

import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

int counterA = 13;
int counterAtoB = 0;
bool isReceive = false;
_MultiGameState? _multiGameState;

class MultiGame extends StatefulWidget {
  MultiGame({Key? key}) : super(key: key);

  @override
  State<MultiGame> createState() => _MultiGameState();

  static Future<void> receiveCount(int count) async {
    // Utilisez la valeur `_count` comme vous le souhaitez
    print('Received count from CounterPage: $count');
    counterA = count;
    isReceive = true;
    _multiGameState?.connectToSocketFromReceiveCount();

    // Effectuez d'autres opérations avec la valeur `_count` ici
  }

  static _MultiGameState? of(BuildContext context) {
    final state = context.findAncestorStateOfType<_MultiGameState>();
    _multiGameState = state;
    return state;
  }
}

class _MultiGameState extends State<MultiGame> with WidgetsBindingObserver {
  final TextEditingController msgText = TextEditingController();
  final _flutterP2pConnectionPlugin = FlutterP2pConnection();
  List<DiscoveredPeers> peers = [];
  WifiP2PInfo? wifiP2PInfo;
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;
  bool areConnected = false;
  bool isSocketOpen = false;

  Future connectToSocketFromReceiveCount() async {
    sendMessageToOther("CounterA: $counterA");
  }

  @override
  void initState() {
    super.initState();
    _flutterP2pConnectionPlugin.unregister();
    _flutterP2pConnectionPlugin.removeGroup();
    _flutterP2pConnectionPlugin.closeSocket();
    peers.clear();
    wifiP2PInfo = null;
    WidgetsBinding.instance.addObserver(this);

    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // _streamWifiInfo?.cancel();
    // _streamPeers?.cancel();

    super.dispose();
  }

  Future<bool> discover() async {
    bool? discovering = await _flutterP2pConnectionPlugin.discover();
    snack("discovering $discovering");
    return discovering;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _flutterP2pConnectionPlugin.unregister();
    } else if (state == AppLifecycleState.resumed) {
      _flutterP2pConnectionPlugin.register();
    }
  }

  void _init() async {
    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    _streamWifiInfo =
        _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      setState(() {
        wifiP2PInfo = event;
      });
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      setState(() {
        peers = event;
      });
    });

    await discover();
  }

  Future startSocket() async {
    if (wifiP2PInfo != null) {
      bool started = await _flutterP2pConnectionPlugin.startSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 2,
        deleteOnError: true,
        onConnect: (name, address) {
          snack("$name connected to socket with address: $address");
          setState(() {
            areConnected = true;
          });

          _flutterP2pConnectionPlugin
              .sendStringToSocket(isSocketOpen.toString());
        },
        transferUpdate: (transfer) {
          if (transfer.completed) {
            snack(
                "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
          }
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req) async {
          if (req.startsWith("CounterA:")) {
            counterAtoB = int.parse(req.substring(10));
            CounterPage.receiveCount(counterAtoB);
          }
          //snack(req);
        },
      );
      setState(() {
        isSocketOpen = true;
      });
      snack("open socket: $started");
    }
  }

  Future connectToSocket() async {
    if (wifiP2PInfo != null) {
      await _flutterP2pConnectionPlugin.connectToSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 3,
        deleteOnError: true,
        onConnect: (address) {
          areConnected = true;
          snack("connected to socket: $address");
        },
        transferUpdate: (transfer) {
          // if (transfer.count == 0) transfer.cancelToken?.cancel();
          if (transfer.completed) {
            snack(
                "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
          }
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req) async {
          if (req == "START") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CounterPage()),
            );
          }
          if (req == "true") {
            isSocketOpen = true;
          }

          if (req.startsWith("CounterA:")) {
            counterAtoB = int.parse(req.substring(10));
            CounterPage.receiveCount(counterAtoB);
          }

          //snack(req + " received");
        },
      );
    }
  }

  Future closeSocketConnection() async {
    bool closed = _flutterP2pConnectionPlugin.closeSocket();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "closed: $closed",
        ),
      ),
    );
  }

  Future sendMessage() async {
    _flutterP2pConnectionPlugin.sendStringToSocket(msgText.text);
  }

  Future sendMessageToOther(String message) async {
    _flutterP2pConnectionPlugin.sendStringToSocket(message);
  }

  void snack(String msg) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          msg,
        ),
      ),
    );
  }

  String? receivedValue; // Valeur reçue

  @override
  Widget build(BuildContext context) {
    _multiGameState = this;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter p2p connection plugin'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "IP: ${wifiP2PInfo == null ? "null" : wifiP2PInfo?.groupOwnerAddress}"),
            wifiP2PInfo != null
                ? Text(
                    "connected: ${wifiP2PInfo?.isConnected}, isGroupOwner: ${wifiP2PInfo?.isGroupOwner}, groupFormed: ${wifiP2PInfo?.groupFormed}, groupOwnerAddress: ${wifiP2PInfo?.groupOwnerAddress}, clients: ${wifiP2PInfo?.clients}, areConnected: $areConnected")
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            const Text("PEERS:"),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: peers.length,
                itemBuilder: (context, index) => Center(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Center(
                          child: AlertDialog(
                            content: SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("name: ${peers[index].deviceName}"),
                                  Text(
                                      "address: ${peers[index].deviceAddress}"),
                                  Text(
                                      "isGroupOwner: ${peers[index].isGroupOwner}"),
                                  Text(
                                      "isServiceDiscoveryCapable: ${peers[index].isServiceDiscoveryCapable}"),
                                  Text(
                                      "primaryDeviceType: ${peers[index].primaryDeviceType}"),
                                  Text(
                                      "secondaryDeviceType: ${peers[index].secondaryDeviceType}"),
                                  Text("status: ${peers[index].status}"),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();

                                  bool? bo = await _flutterP2pConnectionPlugin
                                      .connect(peers[index].deviceAddress);

                                  snack("connected: $bo");
                                },
                                child: const Text("connect"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          peers[index]
                              .deviceName
                              .toString()
                              .characters
                              .first
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (wifiP2PInfo != null &&
                wifiP2PInfo!.isGroupOwner &&
                !areConnected)
              ElevatedButton(
                onPressed: () async {
                  startSocket();
                  await _flutterP2pConnectionPlugin.stopDiscovery();
                },
                child: const Text("Open a socket"),
              ),
            if (wifiP2PInfo != null &&
                !wifiP2PInfo!.isGroupOwner &&
                !areConnected &&
                wifiP2PInfo?.isConnected == true)
              ElevatedButton(
                onPressed: () async {
                  connectToSocket();
                  await _flutterP2pConnectionPlugin.stopDiscovery();
                },
                child: const Text("Connect to socket"),
              ),
            if (wifiP2PInfo != null &&
                wifiP2PInfo!.isGroupOwner &&
                areConnected)
              ElevatedButton(
                onPressed: () async {
                  closeSocketConnection();
                },
                child: const Text("close socket"),
              ),
            if (areConnected && wifiP2PInfo!.isGroupOwner)
              ElevatedButton(
                onPressed: () async {
                  _flutterP2pConnectionPlugin.sendStringToSocket('START');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CounterPage()),
                  );
                },
                child: const Text("Jouer"),
              ),
          ],
        ),
      ),
    );
  }
}
