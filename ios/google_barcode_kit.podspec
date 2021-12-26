#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint google_barcode_kit.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'google_barcode_kit'
  s.version          = '0.6.0'
  s.summary          = 'Flutter Plugin for ML Kit'
  s.description      = <<-DESC
flutter plugin for google ml kit
                       DESC
  s.homepage         = 'https://github.com/hugobrancowb/google_barcode_kit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Hugo Branco' => 'hugpbrancowb@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'GoogleMLKit/BarcodeScanning', '~> 2.2.0'
  s.platform                = :ios, '10.0'
  s.ios.deployment_target   = '10.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
