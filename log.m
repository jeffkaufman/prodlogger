// gcc -o log log.m -framework Foundation -framework AppKit -framework IOKit -Wall
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#include <IOKit/IOKitLib.h>
#include "idler.h"

int main(int argc, char *argv[]) {
  NSRunningApplication *app;
  NSEnumerator *running;

  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  running = [[[NSWorkspace sharedWorkspace] runningApplications] objectEnumerator];
  while ((app = [running nextObject])) {
    if (app.active) {
      NSString *now = [NSString stringWithFormat:@"%0.0f",
				[[NSDate date] timeIntervalSince1970]];
      NSString *idle = [NSString stringWithFormat:@"%0.0f",
				 system_idle_time()];

      printf("%s %s %s\n", 
	     [now UTF8String], 
	     [idle UTF8String], 
	     [app.localizedName UTF8String]);
    }
  }

  [pool release];
  return 0;
}
