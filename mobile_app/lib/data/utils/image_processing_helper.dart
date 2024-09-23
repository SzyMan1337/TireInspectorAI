import 'dart:io';
import 'package:image/image.dart' as img;

class ImageProcessingHelper {
  // Method to process an image into a list of normalized float values
  static Future<List<double>> processImage(String imageUrl) async {
    File imageFile = File(imageUrl);
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    if (image == null) {
      throw Exception('Unable to decode image.');
    }

    // Resize the image to 224x224
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    // Convert the resized image to a list of normalized values
    return _imageToFloatList(resizedImage);
  }

  // Private method to convert an image to a list of normalized float values
  static List<double> _imageToFloatList(img.Image image) {
    List<double> input = [];

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        img.Pixel pixel = image.getPixel(x, y);

        int r = pixel.r.toInt();
        int g = pixel.g.toInt();
        int b = pixel.b.toInt();

        // Normalize RGB values to the range [0, 1]
        input.add(r / 255.0);
        input.add(g / 255.0);
        input.add(b / 255.0);
      }
    }

    return input;
  }
}
