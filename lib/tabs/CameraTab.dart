import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_clone/constants/colors.dart';
import '../main.dart';
import '../random_image_url.dart';

class CameraTab extends StatefulWidget {
  final bool needScaffold;

  CameraTab({this.needScaffold = true});

  @override
  _CameraTabState createState() => _CameraTabState();
}

class _CameraTabState extends State<CameraTab> with TickerProviderStateMixin {
  CameraController controller;
  int _cameraIndex = 0;
  bool _cameraNotAvailable = false;
  String videoPath;
  bool _isVideo = false;

  AnimationController _animationController;
  Animation _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  AnimationController _flashAnimationController;
  Animation _flashAnimation;
  AnimationStatus _flashAnimationStatus = AnimationStatus.dismissed;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void _initCamera(int index) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameras[index], ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        _showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {
        _cameraIndex = index;
      });
    }
  }

  void _onSwitchCamera() {
    if (_animationStatus == AnimationStatus.dismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture) {
      return;
    }
    final newIndex = _cameraIndex + 1 == cameras.length ? 0 : _cameraIndex + 1;
    _initCamera(newIndex);
  }


  void _onRecordButtonPressed(){
    setState(() {
      this._isVideo = true;
    });
    print("Hello video clicked");
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {
        Fluttertoast.showToast(
            msg: 'Recording video started',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white
        );
      }
    });
  }

  Future<String> _startVideoRecording() async{
    if(!controller.value.isInitialized){
      Fluttertoast.showToast(
        msg: 'Please wait...',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white
      );
      return null;
    }

    // If recoring is in progress
    if(controller.value.isRecordingVideo){
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/$currentTime.mp4';

    try {
      await controller.startVideoRecording(filePath);
      videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;

  }

  void _onStopButtonPressed(res){
    print('Video Captured!!');
    _stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      Fluttertoast.showToast(
          msg: 'Video recorded to $videoPath',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white
      );
    });
  }

  Future<void> _stopVideoRecording() async {
    this._isVideo = false;
    if (!controller.value.isRecordingVideo) {
      return null;
    }
 
    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _onTakePictureButtonPress() {
    _takePicture().then((filePath) {
      if (filePath != null) {
        // _showInSnackBar('Picture saved to $filePath');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.crop_rotate),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.insert_emoticon),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.text_fields),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
            body: Container(
              color: Colors.black,
              child: Center(
                child: Image.file(File(filePath)),
              ),
            ),
          );
        }));
      }
    });
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> _takePicture() async {
    if (!controller.value.isInitialized || controller.value.isTakingPicture) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/whatsapp_clone';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.jpg';

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    // _showInSnackBar('Error: ${e.code}\n${e.description}');

    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);
  
    Fluttertoast.showToast(
        msg: 'Error: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );
    
  }

  Widget _buildGalleryBar() {
    final barHeight = 90.0;
    final vertPadding = 10.0;

    return Container(
      height: barHeight,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: vertPadding),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int _) {
          return Container(
            padding: EdgeInsets.only(right: 5.0),
            width: 70.0,
            height: barHeight - vertPadding * 2,
            child: Image(
              image: randomImageUrl(),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Transform(
          transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateX(2 * pi * _flashAnimation.value.toDouble()),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: primaryColor,
              onTap: (){
                print("Flash light changed");
                if (_flashAnimationStatus == AnimationStatus.dismissed) {
                    _flashAnimationController.forward();
                  } else {
                    _flashAnimationController.reverse();
                  }
              },
              child: Icon(
                _flashAnimation.value <= 0.5 ? Icons.flash_auto : Icons.flash_on,
                color: Colors.white,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _onTakePictureButtonPress,
          onLongPress:  _onRecordButtonPressed,
          onLongPressEnd: (res) => _onStopButtonPressed(res),
          child: AnimatedContainer(
            height: _isVideo ? 100 : 80.0,
            width: _isVideo ? 100 : 80.0,
            duration: Duration(milliseconds: 50),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              color: _isVideo ? Colors.red : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 5.0,
              ),
            ),
          ),
        ),
        Transform(
          // alignment: FractionalOffset.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(2 * pi * _animation.value.toDouble()),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: primaryColor,
              onTap: _onSwitchCamera,
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.switch_camera) ,
                onPressed: _onSwitchCamera,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (cameras == null || cameras.isEmpty) {
      setState(() {
        _cameraNotAvailable = true;
      });
    }
    _initCamera(_cameraIndex);

    _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 50));
      _animation = Tween(end: 1.0, begin: 0.0).animate(_animationController)
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          _animationStatus = status;
        });
    
     _flashAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 80));
      _flashAnimation = Tween(end: 1.0, begin: 0.0).animate(_flashAnimationController)
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          _flashAnimationStatus = status;
        });

  }

  @override
  Widget build(BuildContext context) {
    if (_cameraNotAvailable) {
      final center = Center(
        child: Text('Camera not available /_\\'),
      );

      if (widget.needScaffold) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Hello"),
          ),
          body: center,
        );
      }

      return center;
    }

    final stack = Stack(
      children: <Widget>[
        Container(
          color: Colors.black,
          child: Center(
            child: controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  )
                : Text('Loading camera...'),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildGalleryBar(),
            _buildControlBar(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Hold for Video, tap for photo',
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.white),
              ),
            )
          ],
        )
      ],
    );

    if (widget.needScaffold) {
      return Scaffold(
        body: stack,
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      body: stack,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) {
      controller.dispose();
    }
  }
}

