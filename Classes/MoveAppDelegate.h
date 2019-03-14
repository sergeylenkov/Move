#import <UIKit/UIKit.h>

@interface MoveAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
	IBOutlet UIViewController *mainController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIViewController *mainController;

- (NSData *)applicationDataFromFile:(NSString *)fileName;
- (id)applicationPlistFromFile:(NSString *)fileName;
- (BOOL)writeApplicationList:(id)pList toFile:(NSString *)fileName;
- (BOOL)writeApplicationData:(NSData *)fileData toFile:(NSString *)fileName;

@end

