#import "Cell.h"

@implementation Cell

@synthesize object;
@synthesize x;
@synthesize y;

- (void)dealloc {
	[object release];
    [super dealloc];
}

@end
