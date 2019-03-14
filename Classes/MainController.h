#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GameController.h"

@interface MainController : UIViewController {
	IBOutlet UILabel *levelLabel;
	IBOutlet UIButton *previousButton;
	IBOutlet UIButton *nextButton;
	IBOutlet UIButton *startButton;
	IBOutlet UIButton *soundButton;
	GameController *gameController;
	int level;
	int maxLevel;
	NSUserDefaults *defaults;
	BOOL isSound;
}

@property (nonatomic, retain) GameController *gameController;

- (IBAction)nextLevel;
- (IBAction)previousLevel;
- (IBAction)start;
- (IBAction)nextDown;
- (IBAction)previousDown;
- (IBAction)startDown;
- (IBAction)changeSound;

@end
