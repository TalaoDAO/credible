#import "DownloadsPathPlugin.h"

@implementation DownloadsPathPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"downloads_path"
            binaryMessenger:[registrar messenger]];
  DownloadsPathPlugin* instance = [[DownloadsPathPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"getDownloadsDirectory"]) {
    result([self getDownloadsDirectory]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSString*)getDownloadsDirectory {
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
  return paths.firstObject;
}

@end
