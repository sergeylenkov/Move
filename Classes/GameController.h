#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Box.h"
#import "Item.h"
#import "Cell.h"
#import "MovingCell.h"
#import "SoundEffect.h"

@interface GameController : UIViewController <UIAccelerometerDelegate> {
	IBOutlet UIButton *resetLevelButton;
	CALayer *background;
	UIImageView *startImage;
	UIImageView *completeImage;
	NSMutableArray *level;
	Cell *touchedCell;
	Cell *movedCell;	
	int levelIndex;
	int maxLevel;
	int blockCount;
	NSTimer *waitTimer;
	NSTimer *shakeTimer;
	SoundEffect *blockCompleteSound;
	SoundEffect *blockMoveSound;
	SoundEffect *levelComplteteSound;
	BOOL pause;
	BOOL shake;
	BOOL moving;
	NSMutableArray *numbers;
	BOOL isSound;
	NSUserDefaults *defaults;
}

@property (nonatomic, assign) int levelIndex;
@property (nonatomic, assign) int maxLevel;

- (void)loadLevel:(int)index;
- (CGPoint)touchCell:(CGPoint)point;
- (void)nextLevel;
- (void)startLevel;
- (void)destroyTimer;
- (void)shakeCounter;
- (BOOL)checkFall:(Cell *)cell;
- (BOOL)checkTwin:(Cell *)cell;
- (IBAction)resetLevel;

@end