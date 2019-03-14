#import <Foundation/Foundation.h>

@interface Item : NSObject {
	CALayer *layer;
	UIImage *image;
}

@property (nonatomic, retain) CALayer *layer;
@property (nonatomic, retain) UIImage *image;

- (id)initWithImage:(UIImage *)img;

@end
