#import "MovingCell.h"

@implementation MovingCell

@synthesize layer;
@synthesize image;
@synthesize box;
@synthesize parent;

- (id)initWithImage:(UIImage *)img {	
	if (self == [super init]) {
		self.image = img;
		layer = [CALayer layer];
		layer.frame = CGRectMake(0, 0, 32, 32);
		layer.contents = (id)[self.image CGImage];
	}
	
	return self;
}

- (void)dealloc {
	[image release];
	[box release];
	[parent release];
    [super dealloc];
}

@end
