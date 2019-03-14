#import <Foundation/Foundation.h>
#import "Box.h"
#import "Cell.h"

@interface MovingCell : NSObject {
	CALayer *layer;
	UIImage *image;
	Box *box;
	Cell *parent;
}

@property (nonatomic, retain) CALayer *layer;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) Box *box;
@property (nonatomic, retain) Cell *parent;

- (id)initWithImage:(UIImage *)img;

@end