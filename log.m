// gcc -o log log.m -framework Foundation -framework AppKit -framework IOKit -Wall
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#include <IOKit/IOKitLib.h>
#include "idler.h"

int main(int argc, char *argv[]) {
  NSFileManager *fileManager;
  NSRunningApplication *app;
  NSEnumerator *running;

  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSString *log_fname = [[NSString stringWithString:@"~/.prodlog"]
			  stringByExpandingTildeInPath];
  NSString *newline = [NSString stringWithString:@"\n"];
  NSString *space = [NSString stringWithString:@" "];



  fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:log_fname]) {
    [fileManager createFileAtPath:log_fname contents:nil attributes:nil];
  }

  NSFileHandle *output = [NSFileHandle fileHandleForWritingAtPath:log_fname];


  running = [[[NSWorkspace sharedWorkspace] runningApplications] objectEnumerator];
  while ((app = [running nextObject])) {
    if (app.active) {
      NSString *now = [NSString stringWithFormat:@"%0.0f",
				[[NSDate date] timeIntervalSince1970]];
      NSString *idle = [NSString stringWithFormat:@"%0.0f",
				 system_idle_time()];
      
      [output seekToEndOfFile];
      [output writeData:[now dataUsingEncoding:NSUTF8StringEncoding]];
      [output writeData:[space dataUsingEncoding:NSUTF8StringEncoding]];
      [output writeData:[idle dataUsingEncoding:NSUTF8StringEncoding]];
      [output writeData:[space dataUsingEncoding:NSUTF8StringEncoding]];
      [output writeData:[app.localizedName dataUsingEncoding:NSUTF8StringEncoding]];
      [output writeData:[newline dataUsingEncoding:NSUTF8StringEncoding]];
    }
  }

  [pool release];
  return 0;
}
