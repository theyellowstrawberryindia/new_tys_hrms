import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> mockMontserrat(TestDefaultBinaryMessenger messenger) async {
  const codec = StandardMessageCodec();
  // Supply a bundled font to keep widget rendering independent of HTTP.
  final font = await rootBundle.load('fonts/MaterialIcons-Regular.otf');
  final manifest =
      codec.decodeMessage(await rootBundle.load('AssetManifest.bin'))
          as Map<Object?, Object?>;
  const fontAssets = [
    'Montserrat-Regular.ttf',
    'Montserrat-SemiBold.ttf',
    'Montserrat-Bold.ttf',
  ];
  for (final asset in fontAssets) {
    manifest[asset] = [
      {'asset': asset},
    ];
  }
  messenger.setMockMessageHandler('flutter/assets', (message) async {
    final asset = const StringCodec().decodeMessage(message);
    if (asset == 'AssetManifest.bin') return codec.encodeMessage(manifest);
    if (fontAssets.contains(asset)) return font;
    return messenger.delegate.send('flutter/assets', message);
  });
}

void clearMockMontserrat(TestDefaultBinaryMessenger messenger) {
  messenger.setMockMessageHandler('flutter/assets', null);
}
