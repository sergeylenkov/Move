#import "Item.h"

@implementation Item

@synthesize layer;
@synthesize image;

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
    [super dealloc];
}

@end
