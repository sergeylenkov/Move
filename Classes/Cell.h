#import <Foundation/Foundation.h>

@interface Cell : NSObject {
	id object;
	int x;
	int y;
}

@property (nonatomic, retain) id object;
@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;

@end
