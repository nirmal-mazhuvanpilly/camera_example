// ignore_for_file: avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sample_camera_project/main.dart';

class OpenCamera extends StatefulWidget {
  const OpenCamera({super.key});

  @override
  State<OpenCamera> createState() => _OpenCameraState();
}

class _OpenCameraState extends State<OpenCamera> {
  CameraController? controller;
  late List<CameraDescription> _cameras;
  final ValueNotifier<bool> isVideoRecording = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    initialiseCamera();
  }

  initialiseCamera() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            print(e.description);
            break;
          default:
            // Handle other errors here.
            print(e.description);
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(controller?.value.isInitialized ?? false)) {
      return const Center(child: CircularProgressIndicator());
    }
    return WillPopScope(
      onWillPop: () async {
        return !isVideoRecording.value;
      },
      child: CameraPreview(
        controller!,
        child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ValueListenableBuilder<bool>(
                    valueListenable: isVideoRecording,
                    builder: (context, value, child) {
                      return !value
                          ? GestureDetector(
                              onTap: () {
                                controller?.startVideoRecording(
                                  onAvailable: (image) {},
                                );
                                isVideoRecording.value = true;
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Center(
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                isVideoRecording.value = false;
                                final file =
                                    await controller?.stopVideoRecording();
                                print(file?.path);
                                if (!mounted) return;
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomeCamera()),
                                  (route) {
                                    return route.settings.name == "/";
                                  },
                                );
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                    border: Border.all(
                                        color: Colors.white, width: 3)),
                              ),
                            );
                    }),
              ],
            )),
      ),
    );
  }
}
