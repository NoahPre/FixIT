// bildAufnahme.dart
import 'package:fixit/imports.dart';
import "package:path/path.dart" show join;
import "package:path_provider/path_provider.dart";

class BildAufnahme extends StatelessWidget {
  final Function pfadZumBild;
  final CameraController controller;
  BildAufnahme({
    @required this.pfadZumBild,
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData thema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Kamera"),
        backgroundColor: thema.colorScheme.primary,
      ),
      floatingActionButton: Builder(
        builder: (BuildContext currentContext) => FloatingActionButton(
          child: Icon(Icons.camera_alt),
          // Provide an onPressed callback.
          onPressed: () async {
            // Take the Picture in a try / catch block. If anything goes wrong,
            // catch the error.
            try {
              // Construct the path where the image should be saved using the path
              // package.
              final path = join(
                // Store the picture in the temp directory.
                // Find the temp directory using the `path_provider` plugin.
                (await getTemporaryDirectory()).path,
                '${DateTime.now()}.png',
              );

              // Attempt to take a picture and log where it's been saved.
              XFile photo = await controller.takePicture();
              photo.saveTo(path);

              Navigator.pop(context);

              pfadZumBild(photo.path);
            } catch (error) {
              // If an error occurs, log the error to the console.
              print(error);
              zeigeSnackBarNachricht(
                nachricht: error.toString(),
                context: currentContext,
                istError: true,
              );
            }
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
        ],
      ),
    );
  }
}
