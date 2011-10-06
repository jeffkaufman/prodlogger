// File: args.m
// Compile with: gcc -o args args.m -framework Foundation
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSEnumerator *running = [[[NSWorkspace sharedWorkspace]
			     runningApplications]
			    objectEnumerator];

  NSRunningApplication *app;
  while ((app = [running nextObject])) {
    if (app.active) {
      NSLog(@"%0.0f %@", [[NSDate date] timeIntervalSince1970], app.localizedName);
    }
  }

  [pool release];
  return 0;
}
