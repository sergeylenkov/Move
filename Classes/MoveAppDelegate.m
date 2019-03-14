#import "MoveAppDelegate.h"

@implementation MoveAppDelegate

@synthesize window;
@synthesize mainController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[application setStatusBarHidden:YES animated:NO];
	[application setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
	[application setIdleTimerDisabled:YES];
	
    [window addSubview:mainController.view];
    [window makeKeyAndVisible];
}

- (NSData *)applicationDataFromFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *myData = [[[NSData alloc] initWithContentsOfFile:appFile] autorelease];
    return myData;
}

- (id)applicationPlistFromFile:(NSString *)fileName {
    NSData *retData;
    NSString *error;
    id pList;
    NSPropertyListFormat format;
	
    retData = [self applicationDataFromFile:fileName];
    if (!retData) {
        NSLog(@"Data file not returned.");
        return nil;
    }
	
    pList = [NSPropertyListSerialization propertyListFromData:retData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    if (!pList){
        NSLog(@"Plist not returned, error: %@", error);
        [error release];
    }
	
    return pList;
}

- (BOOL)writeApplicationList:(id)pList toFile:(NSString *)fileName {
    NSString *error;
    NSData *pData = [NSPropertyListSerialization dataFromPropertyList:pList format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
    if (!pData) {
        NSLog(@"%@", error);
        [error release];
        return NO;
    }
	
    return [self writeApplicationData:pList toFile:fileName];
}

- (BOOL)writeApplicationData:(NSData *)fileData toFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
	
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([fileData writeToFile:appFile atomically:YES]);
}

- (void)dealloc {
    [window release];
	[mainController release];
    [super dealloc];
}

@end
