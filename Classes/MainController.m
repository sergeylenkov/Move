#import "MainController.h"
#import "MoveAppDelegate.h"

@implementation MainController

@synthesize gameController;

- (void)viewDidLoad {
	defaults = [NSUserDefaults standardUserDefaults];

	maxLevel = 1;
	
	if ([defaults objectForKey:@"Max Level"] != nil) {
		maxLevel = [[defaults objectForKey:@"Max Level"] intValue];
	}

	isSound = YES;
	
	if ([defaults objectForKey:@"Sound"] != nil) {
		isSound = [[defaults objectForKey:@"Sound"] intValue];
	}
	
	if (isSound) {
		[soundButton setImage:[UIImage imageNamed:@"SoundOn.png"] forState:UIControlStateNormal];		 
	} else {
		[soundButton setImage:[UIImage imageNamed:@"SoundOff.png"] forState:UIControlStateNormal];
	}
	
	level = maxLevel;
	
	levelLabel.font = [UIFont fontWithName:@"Marker Felt" size:24];	
	levelLabel.text = [NSString stringWithFormat:@"%d", level];
	
	[previousButton setImage:[UIImage imageNamed:@"Previous.png"] forState:UIControlStateNormal];
	[nextButton setImage:[UIImage imageNamed:@"Next.png"] forState:UIControlStateNormal];
	[startButton setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {	
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {		
		return YES;
	}
	
    return NO;
}

- (IBAction)nextLevel {
	level = level + 1;
	
	if (level > maxLevel) {
		level = maxLevel;
	}
	
	levelLabel.text = [NSString stringWithFormat:@"%d", level];
	[nextButton setImage:[UIImage imageNamed:@"Next.png"] forState:UIControlStateNormal];
}

- (IBAction)previousLevel {
	level = level - 1;
	
	if (level < 1) {
		level = 1;
	}
	
	levelLabel.text = [NSString stringWithFormat:@"%d", level];
	[previousButton setImage:[UIImage imageNamed:@"Previous.png"] forState:UIControlStateNormal];
}

- (IBAction)start {
	GameController *controller = [self gameController];
	controller.levelIndex = level;
	controller.maxLevel = maxLevel;
	
	[self.view addSubview:controller.view];
	[controller viewWillAppear:YES];
	
	[startButton setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
}

- (IBAction)previousDown {
	[previousButton setImage:[UIImage imageNamed:@"PreviousDown.png"] forState:UIControlStateNormal];
}

- (IBAction)nextDown {
	[nextButton setImage:[UIImage imageNamed:@"NextDown.png"] forState:UIControlStateNormal];
}

- (IBAction)startDown {
	[startButton setImage:[UIImage imageNamed:@"StartDown.png"] forState:UIControlStateNormal];
}

- (IBAction)changeSound {
	isSound = !isSound;
	
	[defaults setBool:isSound forKey:@"Sound"];
	
	if (isSound) {
		[soundButton setImage:[UIImage imageNamed:@"SoundOn.png"] forState:UIControlStateNormal];		 
	} else {
		[soundButton setImage:[UIImage imageNamed:@"SoundOff.png"] forState:UIControlStateNormal];		 
	}
}

- (GameController *)gameController {
	if (gameController == nil) {
		gameController = [[GameController alloc] initWithNibName:@"GameView" bundle:nil];
	}
	
	return gameController;
}

- (void)dealloc {
	[levelLabel release];
    [super dealloc];
}

@end
