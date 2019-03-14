#import <Foundation/Foundation.h>

@interface Box : NSObject {
	CALayer *layer;
	UIImage *image;
	NSInteger color;
}

@property (nonatomic, retain) CALayer *layer;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) NSInteger color;

- (id)initWithImage:(UIImage *)img;

@end
