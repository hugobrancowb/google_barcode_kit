# Google's ML Kit Barcode Flutter Plugin

[![Pub Version](https://img.shields.io/pub/v/google_barcode_kit)](https://pub.dev/packages/google_barcode_kit)

A Barcode Flutter plugin to use [Google's standalone ML Kit](https://developers.google.com/ml-kit) for Android and iOS.

## Requirements

### iOS

- Minimum iOS Deployment Target: 10.0
- Xcode 12 or newer
- Swift 5
- ML Kit only supports 64-bit architectures (x86_64 and arm64). Check this [list](https://developer.apple.com/support/required-device-capabilities/) to see if your device has the required device capabilities.

Since ML Kit does not support 32-bit architectures (i386 and armv7) ([Read mode](https://developers.google.com/ml-kit/migration/ios)), you need to exclude amrv7 architectures in Xcode in order to run `flutter build ios` or `flutter build ipa`.

Go to Project > Runner > Building Settings > Excluded Architectures > Any SDK > armv7

![](https://github.com/bharat-biradar/Google-Ml-Kit-plugin/blob/master/ima/build_settings_01.png)

Then your Podfile should look like this:

```
# add this line:
$iOSVersion = '10.0'

post_install do |installer|
  # add these lines:
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=*]"] = "armv7"
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
  end
  
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    # add these lines:
    target.build_configurations.each do |config|
      if Gem::Version.new($iOSVersion) > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
      end
    end
    
  end
end
```

Notice that the minimum `IPHONEOS_DEPLOYMENT_TARGET` is 10.0, you can set it to something newer but not older.

### Android

- minSdkVersion: 21
- targetSdkVersion: 29

## Usage

Add this plugin as dependency in your pubspec.yaml.

- In your project-level build.gradle file, make sure to include Google's Maven repository in both your buildscript and allprojects sections(for all api's).
- Configure your application to download the model to your device automatically from play store by adding the following to your app's `AndroidManifest.xml`, if not configured the respective models will be downloaded when the API's are invoked for the first time. 

  ```xml
  <meta-data
          android:name="com.google.mlkit.vision.DEPENDENCIES"
          android:value="ocr" />
  ```

#### 1. Create an InputImage

From path:

```dart
final inputImage = InputImage.fromFilePath(filePath);
```

From file:

```dart
final inputImage = InputImage.fromFile(file);
```

From bytes:

```dart
final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
```

From CameraImage (if you are using the camera plugin):

```dart
final camera; // your camera instance
final WriteBuffer allBytes = WriteBuffer();
for (Plane plane in cameraImage.planes) {
  allBytes.putUint8List(plane.bytes);
}
final bytes = allBytes.done().buffer.asUint8List();

final Size imageSize = Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

final InputImageRotation imageRotation =
    InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
        InputImageRotation.Rotation_0deg;

final InputImageFormat inputImageFormat =
    InputImageFormatMethods.fromRawValue(cameraImage.format.raw) ??
        InputImageFormat.NV21;

final planeData = cameraImage.planes.map(
  (Plane plane) {
    return InputImagePlaneMetadata(
      bytesPerRow: plane.bytesPerRow,
      height: plane.height,
      width: plane.width,
    );
  },
).toList();

final inputImageData = InputImageData(
  size: imageSize,
  imageRotation: imageRotation,
  inputImageFormat: inputImageFormat,
  planeData: planeData,
);

final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
```

#### 2. Create an instance of detector

```dart
final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
```

#### 3. Call the corresponding method

```dart
final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
```

#### 4. Extract data from response.

```dart
for (Barcode barcode in barcodes) {
  final BarcodeType type = barcode.type;
  final Rect boundingBox = barcode.value.boundingBox;
  final String displayValue = barcode.value.displayValue;
  final String rawValue = barcode.value.rawValue;

  // See API reference for complete list of supported types
  switch (type) {
    case BarcodeType.wifi:
      BarcodeWifi barcodeWifi = barcode.value;
      break;
    case BarcodeValueType.url:
      BarcodeUrl barcodeUrl = barcode.value;
      break;
  }
}
```

#### 5. Release resources with `close()`.

```dart
barcodeScanner.close();
```

## Contributing

Contributions are welcome.
In case of any problems open an issue.
Create a issue before opening a pull request for non trivial fixes.
In case of trivial fixes open a pull request directly.

## License

[MIT](https://choosealicense.com/licenses/mit/)
