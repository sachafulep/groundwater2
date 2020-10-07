import "package:flutter/material.dart";
import "package:groundwater/utils/colors.dart";
import "package:groundwater/utils/strings.dart";

typedef void NextClickedCallback();
typedef void SelectLocationCallback(String location);
typedef void MapImageBuiltCallback();

class MapDisplay extends StatelessWidget {
  MapDisplay({
    this.nextClickedCallback,
    this.selectLocationCallback,
    this.mapImageBuiltCallback,
    this.location,
    this.mapImage,
    this.mapImageBuilt,
  });

  final NextClickedCallback nextClickedCallback;
  final SelectLocationCallback selectLocationCallback;
  final MapImageBuiltCallback mapImageBuiltCallback;
  final String location;
  final AssetImage mapImage;
  final bool mapImageBuilt;

  static final GlobalKey imageKey = GlobalKey<ImageState>();

  Text _title() {
    return Text(
      Strings.decisionTreeMapTitle,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }

  Padding _subtitle() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: 16,
        right: 16,
        bottom: 10,
      ),
      child: Text(
        location,
        style: TextStyle(
          color: GroundColor.subText,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Container _locationButton(
    double x,
    double y,
    double width,
    double height,
    String type,
    String text,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: x,
        top: y,
      ),
      child: GestureDetector(
        key: Key(type),
        onTap: () {
          selectLocationCallback(text);
        },
        child: Container(
          /// Possible bug: GestureDetector does not detect tap unless the Container
          /// child has a background color.
          /// Workaround for now is to make the background transparent.
          decoration: BoxDecoration(color: GroundColor.transparent, boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(
                  50,
                  50,
                  50,
                  99,
                ),
                blurRadius: 3.0,
                offset: Offset(3, 3))
          ]),
          width: width,
          height: height,
          child: CustomPaint(
            foregroundPainter: Painter(
              width: width,
              height: height,
              text: text,
            ),
          ),
        ),
      ),
    );
  }

  Size getImageSize() {
    final State state = imageKey.currentState;
    RenderBox renderBox = state.context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    return size;
  }

  Stack buildButtons(BuildContext context) {
    // TODO: Try to implement this version.
    // Using the dimensions of the map instead of the entire screen probably
    // gives more accurate placements for the buttons.

    // Problem: callback is called before widget is rendered, returning 0, 0 as its height and width.
    // Possible solution: call callback only once entire layout is rendered.
    // However this has given me problems with context returning null from the globalkey.

    // Size mapSize = getImageSize();
    // double mapHeight = mapSize.height;
    // double mapWidth = mapSize.width;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        _locationButton(
          screenWidth * 0.10,
          screenHeight * 0.3,
          95,
          30,
          Strings.west,
          Strings.locationWest,
        ),
        _locationButton(
          screenWidth * 0.43,
          screenHeight * 0.21,
          95,
          20,
          Strings.middle,
          Strings.locationMiddle,
        ),
        _locationButton(
          screenWidth * 0.66,
          screenHeight * 0.13,
          82,
          20,
          Strings.east,
          Strings.locationEast,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          top: 18,
          right: 16,
        ),
        child: Column(
          children: <Widget>[
            _title(),
            _subtitle(),
            Stack(
              children: <Widget>[
                MyImage(
                  mapImageBuiltCallback: mapImageBuiltCallback,
                  key: imageKey,
                  mapImage: AssetImage("assets/EnschedeBase.png"),
                ),
                Image(image: mapImage),
                if (mapImageBuilt) buildButtons(context),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyImage extends StatefulWidget {
  const MyImage({
    this.mapImageBuiltCallback,
    this.key,
    this.mapImage,
  }) : super(key: key);

  final MapImageBuiltCallback mapImageBuiltCallback;
  final GlobalKey key;
  final AssetImage mapImage;

  @override
  State<StatefulWidget> createState() => ImageState(
        mapImageBuiltCallback: mapImageBuiltCallback,
        mapImage: mapImage,
      );
}

class ImageState extends State<MyImage> {
  ImageState({
    this.mapImageBuiltCallback,
    this.mapImage,
  });

  final MapImageBuiltCallback mapImageBuiltCallback;
  final AssetImage mapImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => mapImageBuiltCallback());
  }

  @override
  Widget build(BuildContext context) {
    return Image(image: mapImage);
  }
}

class Painter extends CustomPainter {
  String text;
  double width;
  double height;

  Painter({
    this.width,
    this.height,
    this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = GroundColor.primary
      ..strokeWidth = 10;

    double rectWidth = width;
    double rectHeight = height;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, rectWidth, rectHeight),
          Radius.circular(5.0),
        ),
        paint);

    canvas.drawPath(
      createTriangle(
        size,
        rectWidth / 2,
        rectHeight,
      ),
      paint,
    );

    drawText(canvas);
  }

  void drawText(Canvas canvas) {
    List<String> strings;
    List<Offset> offsets;

    if (text != Strings.locationWest) {
      strings = [text];
      offsets = [
        Offset(
          15.0,
          6.0,
        )
      ];
    } else {
      strings = [
        text.substring(0, 13),
        text.substring(14),
      ];
      offsets = [
        Offset(20.0, 6.0),
        Offset(23.0, 16.0),
      ];
    }

    for (int i = 0; i < strings.length; i++) {
      TextSpan span = TextSpan(
        style: TextStyle(
          color: GroundColor.subText,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
        text: strings[i],
      );

      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );

      tp.layout();
      tp.paint(canvas, offsets[i]);
    }
  }

  Path createTriangle(
    Size size,
    double horizontalMiddleOfRect,
    double verticalBottomOfRect,
  ) {
    Path path = Path();

    double x = horizontalMiddleOfRect;
    double y = verticalBottomOfRect;

    path.addPolygon(
      [
        Offset(x - 7.5, y - 1),
        Offset(x + 7.5, y + 0),
        Offset(x, y + 10),
      ],
      true,
    );

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
