// Emacs Client: a tiny Cocoa app that forwards Finder/Spotlight/Dock/URL
// requests to the running Emacs daemon via emacsclient.
//
// Cocoa because macOS delivers "Open With", drag & drop, Spotlight/Dock and
// org-protocol:// requests as AppleEvents, which a shell script can't receive.
//
// EMACSCLIENT (the absolute path to emacsclient) is injected at build time, so
// it always points at the Emacs the daemon runs.

#import <Cocoa/Cocoa.h>

#ifndef EMACSCLIENT
#error "EMACSCLIENT must be defined to the absolute path of emacsclient"
#endif

#ifndef EMACS_BUNDLE_ID
#define EMACS_BUNDLE_ID @"org.gnu.Emacs"
#endif

// Bundle identifier of the real Emacs.app the daemon runs from. Used to bring
// the daemon's frames to the front after forwarding a request.
static NSString *const kEmacsBundleID = EMACS_BUNDLE_ID;
static NSString *const kEmacsClientPath = EMACSCLIENT;

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (nonatomic) BOOL didOpenSomething;
@property (nonatomic) NSUInteger clientCount;
@end

@implementation AppDelegate

- (void)runEmacsclient:(NSArray<NSString *> *)arguments {
  NSTask *task = [[NSTask alloc] init];
  task.executableURL = [NSURL fileURLWithPath:kEmacsClientPath];
  task.arguments = arguments;
  NSError *error = nil;
  if (![task launchAndReturnError:&error]) {
    NSLog(@"Emacs Client: failed to run %@: %@", kEmacsClientPath, error);
    return;
  }
  // emacsclient -n returns quickly; wait so the request is delivered before we
  // exit.
  [task waitUntilExit];
}

// No files/URLs: ask the daemon for a fresh frame (starting it if needed).
- (void)openNewFrame {
  [self runEmacsclient:@[ @"-c", @"-a", @"", @"-n" ]];
  self.didOpenSomething = YES;
}

// Open a file. The first request creates a frame, later ones reuse it.
- (void)openFile:(NSString *)path {
  // AppKit may hand us a file:// URL where a path is expected; decode it.
  if ([path hasPrefix:@"file:"]) {
    NSURL *fileURL = [NSURL URLWithString:path];
    if (fileURL.isFileURL) {
      path = fileURL.path;
    }
  }

  // Any remaining scheme (e.g. org-protocol://) is not a file, so forward it as
  // a URL. A colon after the first slash is part of the path, not a scheme.
  NSRange colon = [path rangeOfString:@":"];
  NSRange slash = [path rangeOfString:@"/"];
  if (colon.location != NSNotFound &&
      (slash.location == NSNotFound || colon.location < slash.location)) {
    [self openURL:path];
    return;
  }

  NSArray<NSString *> *args = self.clientCount == 0
    ? @[ @"-c", @"-a", @"", @"-n", path ]
    : @[ @"-a", @"", @"-n", path ];
  self.clientCount += 1;
  [self runEmacsclient:args];
  self.didOpenSomething = YES;
}

// org-protocol:// and friends. -r reuses a frame, creating one only if none is
// visible, so captures land in the current frame.
- (void)openURL:(NSString *)url {
  [self runEmacsclient:@[ @"-r", @"-a", @"", @"-n", url ]];
  self.didOpenSomething = YES;
}

- (void)activateEmacs {
  NSArray<NSRunningApplication *> *instances =
    [NSRunningApplication runningApplicationsWithBundleIdentifier:kEmacsBundleID];
  for (NSRunningApplication *instance in instances) {
    [instance activateWithOptions:NSApplicationActivateIgnoringOtherApps];
  }
}

// Open an empty frame if nothing was forwarded, then raise Emacs and quit.
- (void)finish {
  if (!self.didOpenSomething) {
    [self openNewFrame];
  }
  [self activateEmacs];
  [NSApp terminate:nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  // LaunchServices delivers openFiles/openURLs AppleEvents while launching, but
  // give any stragglers a moment before deciding whether to open an empty frame.
  [NSTimer scheduledTimerWithTimeInterval:0.4
                                   target:self
                                 selector:@selector(finish)
                                 userInfo:nil
                                  repeats:NO];
}

- (void)application:(NSApplication *)application openFiles:(NSArray<NSString *> *)filenames {
  for (NSString *filename in filenames) {
    [self openFile:filename];
  }
  [application replyToOpenOrPrint:NSApplicationDelegateReplySuccess];
}

- (void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls {
  for (NSURL *url in urls) {
    // Finder passes files here as file:// URLs; unwrap those to real paths and
    // forward only custom schemes (e.g. org-protocol://) as URLs.
    if (url.isFileURL) {
      [self openFile:url.path];
    } else {
      [self openURL:url.absoluteString];
    }
  }
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)application
                    hasVisibleWindows:(BOOL)hasVisibleWindows {
  if (!hasVisibleWindows) {
    [self openNewFrame];
  }
  return YES;
}

@end

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    NSApplication *application = [NSApplication sharedApplication];
    AppDelegate *delegate = [[AppDelegate alloc] init];
    application.delegate = delegate;
    [application run];
  }
  return 0;
}
