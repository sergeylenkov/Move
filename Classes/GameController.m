#import "GameController.h"
#import "MoveAppDelegate.h"

#define MAX_LEVEL 30

@implementation GameController

@synthesize levelIndex;
@synthesize maxLevel;

- (void)viewDidLoad {
	defaults = [NSUserDefaults standardUserDefaults];
	
	level = [[NSMutableArray alloc] init];
	numbers = [[NSMutableArray alloc] init];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 40)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
	CGRect frame = CGRectMake(0, 0, 480, 320);
	self.view.frame = frame;
	
	background = [CALayer layer];
	background.frame = self.view.frame;
	background.contents = (id)[[UIImage imageNamed:@"Background.png"] CGImage];
	[self.view.layer addSublayer:background];
	
	levelComplteteSound = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SK8" ofType:@"wav"]];
	blockCompleteSound = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CFC_0040" ofType:@"wav"]];
	blockMoveSound = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SK12" ofType:@"wav"]];	
}

- (void)viewWillAppear:(BOOL)animated {
	isSound = [[defaults objectForKey:@"Sound"] boolValue];

	if (isSound) {
		[levelComplteteSound play];
	}
	
	moving = NO;
	[self loadLevel:levelIndex];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event { 
	if (pause) {
		return;
	}

	UITouch *touch = [touches anyObject];	
	CGPoint position = [self touchCell:[touch locationInView:self.view]];
	
	touchedCell = [[level objectAtIndex:position.y] objectAtIndex:position.x];

	if ([touchedCell.object isKindOfClass:[Box class]]) {
		if (moving) {
			if (movedCell.x > 0) {
				int x = movedCell.x;
				
				while (x > 0) {
					Cell *cell = [[level objectAtIndex:movedCell.y] objectAtIndex:x - 1];
				
					if ([cell.object isKindOfClass:[MovingCell class]]) {
						MovingCell *movingCell = cell.object;
						[movingCell.layer removeFromSuperlayer];
					
						Cell *emptyCell = [Cell alloc];
						emptyCell.x = x - 1;
						emptyCell.y = movedCell.y;
					
						[[level objectAtIndex:emptyCell.y] replaceObjectAtIndex:emptyCell.x withObject:emptyCell];
					
						[emptyCell release];
					}
					
					x = x - 1;
				}
			}
			
			if (movedCell.x < 14) {
				int x = movedCell.x;
				
				while (x < 14) {
					Cell *cell = [[level objectAtIndex:movedCell.y] objectAtIndex:x + 1];
				
					if ([cell.object isKindOfClass:[MovingCell class]]) {
						MovingCell *movingCell = cell.object;
						[movingCell.layer removeFromSuperlayer];
					
						Cell *emptyCell = [Cell alloc];
						emptyCell.x = x + 1;
						emptyCell.y = movedCell.y;
					
						[[level objectAtIndex:emptyCell.y] replaceObjectAtIndex:emptyCell.x withObject:emptyCell];
					
						[emptyCell release];
					}
					
					x = x + 1;
				}
			}
			
			moving = NO;
		} else {		
			movedCell = touchedCell;
			Box *box = movedCell.object;
		
			if (movedCell.x > 0) {
				int x = position.x;
				
				while (x > 0) {
					Cell *leftCell = [[level objectAtIndex:position.y] objectAtIndex:x - 1];

					if (leftCell.object == nil) {
						MovingCell *movingCell = [[MovingCell alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", box.color]]];
						movingCell.layer.position = CGPointMake((x - 1) * 32 + 16, position.y * 32 + 16);
						movingCell.layer.opacity = 0.5;
						
						[self.view.layer addSublayer:movingCell.layer];
						
						Cell *cell = [Cell alloc];
						cell.x = x - 1;
						cell.y = position.y;
						cell.object = movingCell;
						
						NSMutableArray *line = [level objectAtIndex:position.y];
						[line replaceObjectAtIndex:x - 1 withObject:cell];
						
						[cell release];
						[movingCell release];
					} else {
						break;
					}
					
					Cell *downCell = [[level objectAtIndex:position.y + 1] objectAtIndex:x - 1];
					
					if (downCell.object == nil) {
						break;
					} else {
						if ([downCell.object isKindOfClass:[Box class]]) {
							Box *box = downCell.object;
							Box *movedBox = movedCell.object;			
							
							if (box.color == movedBox.color && box.color < 9) {
								break;
							}
						}
					}
					
					x = x - 1;
				}
			}
			
			if (movedCell.x < 14) {
				int x = position.x;
				
				while (x < 14) {
					Cell *leftCell = [[level objectAtIndex:position.y] objectAtIndex:x + 1];

					if (leftCell.object == nil) {
						MovingCell *movingCell = [[MovingCell alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", box.color]]];
						movingCell.layer.position = CGPointMake((x + 1) * 32 + 16, position.y * 32 + 16);
						movingCell.layer.opacity = 0.5;
						
						[self.view.layer addSublayer:movingCell.layer];
						
						Cell *cell = [Cell alloc];
						cell.x = x + 1;
						cell.y = position.y;
						cell.object = movingCell;
						
						NSMutableArray *line = [level objectAtIndex:position.y];
						[line replaceObjectAtIndex:x + 1 withObject:cell];
						
						[cell release];
						[movingCell release];
					} else {
						break;
					}
					
					Cell *downCell = [[level objectAtIndex:position.y + 1] objectAtIndex:x + 1];
					
					if (downCell.object == nil) {
						break;
					} else {
						if ([downCell.object isKindOfClass:[Box class]]) {
							Box *box = downCell.object;
							Box *movedBox = movedCell.object;			
						
							if (box.color == movedBox.color && box.color < 9) {
								break;
							}
						}
					}
					
					x = x + 1;
				}
			}
			
			moving = YES;
		}		
	}
	
	if ([touchedCell.object isKindOfClass:[MovingCell class]]) {		
		MovingCell *cell = touchedCell.object;
		Box *box = movedCell.object;
		
		CGPoint from = CGPointMake(movedCell.x, movedCell.y);
		CGPoint to = CGPointMake(touchedCell.x, touchedCell.y);
		CGPoint fromPosition = box.layer.position;
		box.layer.position = cell.layer.position;
		
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
		animation.duration = 0.5;
		animation.fromValue = [NSNumber numberWithInt:fromPosition.x];
		animation.toValue = [NSNumber numberWithInt:cell.layer.position.x];
		animation.delegate = self;
		animation.removedOnCompletion = NO;
		
		[box.layer addAnimation:animation forKey:@"position"];

		movedCell.x = to.x;
		movedCell.y = to.y;
		
		[cell.layer removeFromSuperlayer];
		[[level objectAtIndex:from.y] exchangeObjectAtIndex:to.x withObjectAtIndex:from.x];
		
		Cell *emptyCell = [Cell alloc];
		
		[[level objectAtIndex:from.y] replaceObjectAtIndex:from.x withObject:emptyCell];
		[emptyCell release];

		if (from.x > 0) {
			int x = from.x;
			
			while (x > 0) {
				Cell *leftCell = [[level objectAtIndex:from.y] objectAtIndex:x - 1];
			
				if ([leftCell.object isKindOfClass:[MovingCell class]]) {
					MovingCell *temp = leftCell.object;
					Cell *emptyCell = [[Cell alloc] init];
				
					[temp.layer removeFromSuperlayer];
					[[level objectAtIndex:from.y] replaceObjectAtIndex:x - 1 withObject:emptyCell];
					[emptyCell release];
				}
				
				x = x - 1;
			}
		}

		if (from.x < 14) {
			int x = from.x;
			
			while (x < 14) {
				Cell *rightCell = [[level objectAtIndex:from.y] objectAtIndex:x + 1];		
				
				if ([rightCell.object isKindOfClass:[MovingCell class]]) {
					MovingCell *temp = rightCell.object;
					Cell *emptyCell = [Cell alloc];
					
					[temp.layer removeFromSuperlayer];
					[[level objectAtIndex:from.y] replaceObjectAtIndex:x + 1 withObject:emptyCell];
					[emptyCell release];
				}
				
				x = x + 1;
			}			
		}
		
		pause = YES;
		moving = NO;
		
		if (isSound) {
			[blockMoveSound play];
		}
	}
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
	if ([self checkFall:movedCell]) {
		return;
	}
	
	if ([self checkTwin:movedCell]) {
		blockCount = blockCount - 2;
		
		if (isSound) {
			[blockCompleteSound play];
		}
	}

	for (int i = 0; i < [level count]; i++) {	
		for (int j = 0; j < 15; j++) {		
			Cell *cell = [[level objectAtIndex:i] objectAtIndex:j];
			
			if ([cell.object isKindOfClass:[Box class]]) {
				if (cell.y < 9) {
					Cell *temp = [[level objectAtIndex:i + 1] objectAtIndex:j];

					if (temp.object == nil) {
						movedCell = cell;
						[self animationDidStop:nil finished:YES];	
						return;
					}
					
				}				
			}
		}
	}
		
	if (blockCount == 0) {		
		completeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 480, 50)];
		
		if (levelIndex == MAX_LEVEL) {
			completeImage.image = [UIImage imageNamed:@"Over.png"];
		} else {
			completeImage.image = [UIImage imageNamed:@"Complete.png"];
		}
		
		[self.view addSubview:completeImage];
		[completeImage release];
		
		if (isSound) {
			[levelComplteteSound play];
		}		
		
		waitTimer = [[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(nextLevel) userInfo:nil repeats:NO] retain];
		[[NSRunLoop currentRunLoop] addTimer:waitTimer forMode:NSDefaultRunLoopMode];
		
		pause = YES;
	}

	pause = NO;
}

- (BOOL)checkFall:(Cell *)cell {
	if (cell.y < 9) {
		Cell *downCell = [[level objectAtIndex:cell.y + 1] objectAtIndex:cell.x];
		
		if (downCell.object == nil) {
			int i;
			
			for (i = cell.y + 1; i < 10; i++) {
				downCell = [[level objectAtIndex:i] objectAtIndex:cell.x];
				
				if (downCell.object != nil) {
					break;
				}
			}				
			
			CGPoint from = CGPointMake(cell.x, cell.y);
			CGPoint to = CGPointMake(downCell.x, i - 1);
			
			Box *box = cell.object;
			
			CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
			animation.duration = 0.2;
			animation.fromValue = [NSValue valueWithCGPoint:box.layer.position];
			animation.toValue = [NSValue valueWithCGPoint:CGPointMake(box.layer.position.x, i * 32 - 16)];
			animation.delegate = self;
			
			[box.layer addAnimation:animation forKey:@"animationPosition"];		
			box.layer.position = CGPointMake(box.layer.position.x, i * 32 - 16);			

			cell.x = to.x;
			cell.y = to.y;
			
			[[level objectAtIndex:to.y] replaceObjectAtIndex:to.x withObject:cell];
								
			Cell *emptyCell = [Cell alloc];
			
			[[level objectAtIndex:from.y] replaceObjectAtIndex:from.x withObject:emptyCell];
			[emptyCell release];
			
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)checkTwin:(Cell *)cell {
	if (cell.y > 0) {
		Cell *upCell = [[level objectAtIndex:cell.y - 1] objectAtIndex:cell.x];
		
		if ([upCell.object isKindOfClass:[Box class]]) {
			Box *box = upCell.object;
			Box *movedBox = cell.object;			
			
			if (box.color == movedBox.color && box.color < 9) {
				Cell *emptyCell = [Cell alloc];
				
				[movedBox.layer removeFromSuperlayer];
				[[level objectAtIndex:cell.y] replaceObjectAtIndex:cell.x withObject:emptyCell];
				[emptyCell release];
				
				emptyCell = [Cell alloc];
				
				[box.layer removeFromSuperlayer];
				[[level objectAtIndex:upCell.y] replaceObjectAtIndex:upCell.x withObject:emptyCell];
				[emptyCell release];
				
				return YES;
			}
		}
	}
	
	if (cell.y < 9) {
		Cell *downCell = [[level objectAtIndex:cell.y + 1] objectAtIndex:cell.x];
		
		if ([downCell.object isKindOfClass:[Box class]]) {
			Box *box = downCell.object;
			Box *movedBox = cell.object;			
			
			if (box.color == movedBox.color && box.color < 9) {
				Cell *emptyCell = [Cell alloc];
				
				[movedBox.layer removeFromSuperlayer];
				[[level objectAtIndex:cell.y] replaceObjectAtIndex:cell.x withObject:emptyCell];
				[emptyCell release];
				
				emptyCell = [Cell alloc];
				
				[box.layer removeFromSuperlayer];
				[[level objectAtIndex:downCell.y] replaceObjectAtIndex:downCell.x withObject:emptyCell];
				[emptyCell release];
				
				return YES;
			}
		}
	}
	
	if (cell.x > 0) {
		Cell *leftCell = [[level objectAtIndex:cell.y] objectAtIndex:cell.x - 1];
		
		if ([leftCell.object isKindOfClass:[Box class]]) {
			Box *box = leftCell.object;
			Box *movedBox = cell.object;			
			
			if (box.color == movedBox.color && box.color < 9) {
				Cell *emptyCell = [Cell alloc];
				
				[movedBox.layer removeFromSuperlayer];
				[[level objectAtIndex:cell.y] replaceObjectAtIndex:cell.x withObject:emptyCell];
				[emptyCell release];
				
				emptyCell = [Cell alloc];
				
				[box.layer removeFromSuperlayer];
				[[level objectAtIndex:leftCell.y] replaceObjectAtIndex:leftCell.x withObject:emptyCell];
				[emptyCell release];
				
				return YES;
			}
		}
	}
	
	if (cell.x < 14) {
		Cell *rightCell = [[level objectAtIndex:cell.y] objectAtIndex:cell.x + 1];
		
		if ([rightCell.object isKindOfClass:[Box class]]) {
			Box *box = rightCell.object;
			Box *movedBox = cell.object;		
			
			if (box.color == movedBox.color && box.color < 9) {
				Cell *emptyCell = [Cell alloc];
				
				[movedBox.layer removeFromSuperlayer];
				[[level objectAtIndex:cell.y] replaceObjectAtIndex:cell.x withObject:emptyCell];
				[emptyCell release];
				
				emptyCell = [Cell alloc];
				
				[box.layer removeFromSuperlayer];
				[[level objectAtIndex:rightCell.y] replaceObjectAtIndex:rightCell.x withObject:emptyCell];
				[emptyCell release];
				
				return YES;
			}
		}
	}
	
	return NO;
}

- (CGPoint)touchCell:(CGPoint)point {
	CGPoint cell;
	cell.x = ceil(point.x / 32);
	cell.y = ceil(point.y / 32);
	
	if (cell.x < 1) {
		cell.x = 1;
	}
	
	if (cell.x > 15) {
		cell.x = 15;
	}
	
	if (cell.y < 1) {
		cell.y = 1;
	}
	
	if (cell.y > 10) {
		cell.y = 10;
	}
	
	cell.x = cell.x - 1;
	cell.y = cell.y - 1;
	
	return cell;
}

- (void)nextLevel {
	levelIndex = levelIndex + 1;
	[completeImage removeFromSuperview];
	[self destroyTimer];
	
	if (levelIndex > MAX_LEVEL) {
		[self.view removeFromSuperview];
		return;
	}
	
	if (levelIndex >= maxLevel) {
		[defaults setInteger:levelIndex forKey:@"Max Level"];
	}
	
	[self loadLevel:levelIndex];
}

- (void)startLevel{
	[startImage removeFromSuperview];
	
	for (int i = 0; i < [numbers count]; i++) {
		UIImageView *view = [numbers objectAtIndex:i];
		[view removeFromSuperview];
	}
	
	[numbers removeAllObjects];
	
	[self destroyTimer];
	pause = NO;
	
	[resetLevelButton setHidden:NO];
}

- (void)loadLevel:(int)index {
	[resetLevelButton setHidden:YES];
	
	pause = YES;
	blockCount = 0;
	
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSString *txt = [[NSString alloc] initWithContentsOfFile:[mainBundle pathForResource:[NSString stringWithFormat:@"%d", index] ofType:@"level"]];
	
	NSMutableArray *lines = [[NSMutableArray alloc] init];
	NSMutableArray *blocks = [[NSMutableArray alloc] init];
	
	[lines addObjectsFromArray:[txt componentsSeparatedByString:@"\n"]];
	[txt release];
	
	for (int i = 0; i < [level count]; i++) {
		for (int j = 0; j < 15; j++) {
			Cell *cell = [[level objectAtIndex:i] objectAtIndex:j];
			
			if ([cell.object isKindOfClass:[Box class]]) {
				Box *box = cell.object;
				[box.layer removeFromSuperlayer];
			}
			
			if ([cell.object isKindOfClass:[Item class]]) {
				Item *item = cell.object;
				[item.layer removeFromSuperlayer];
			}
		}
	}
	
	[level removeAllObjects];
	
	for (int i = 0; i < [lines count]; i++) {		
		NSMutableArray *line = [[NSMutableArray alloc] initWithCapacity:0];
		
		[blocks removeAllObjects];
		[blocks addObjectsFromArray:[[lines objectAtIndex:i] componentsSeparatedByString:@","]];
		
		for (int j = 0; j < [blocks count]; j++) {
			Cell *cell = [Cell alloc];
			cell.x = j;
			cell.y = i;
			cell.object = nil;			
			NSString *block = [blocks objectAtIndex:j];
			
			if ([block intValue] > 0 && [block intValue] < 10) {
				Box *box = [[Box alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", block]]];
				box.color = [block intValue];
				box.layer.position = CGPointMake(j * 32 + 16, i * 32 + 16);
				
				[self.view.layer addSublayer:box.layer];
				
				cell.object = box;
				[box release];
				
				if (box.color < 9) {
					blockCount = blockCount + 1;
				}
			}
			
			if ([block intValue] > 9) {
				Item *item = [[Item alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", block]]];
				item.layer.position = CGPointMake(j * 32 + 16, i * 32 + 16);
				
				[self.view.layer addSublayer:item.layer];
				
				cell.object = item;
				[item release];
			}
			
			[line addObject:cell];
			[cell release];
		}
		
		[level addObject:line];
		[line release];
	}
	
	[lines release];
	[blocks release];
	
	startImage = [[UIImageView alloc] initWithFrame:CGRectMake(170, 50, 100, 50)];
	startImage.image = [UIImage imageNamed:@"Level.png"];
	
	[self.view addSubview:startImage];
	[startImage release];
	
	if (levelIndex < 10) {
		UIImageView *number = [[UIImageView alloc] initWithFrame:CGRectMake(250, 50, 50, 50)];
		number.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number%d.png", levelIndex]];
		
		[self.view addSubview:number];
		[numbers addObject:number];
		
		[number release];
	} else {
		int i = (levelIndex / 10) % 10;

		UIImageView *number = [[UIImageView alloc] initWithFrame:CGRectMake(250, 50, 50, 50)];
		number.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number%d.png", i]];
		
		[self.view addSubview:number];
		[numbers addObject:number];
		
		[number release];
		
		i = levelIndex - i * 10;
		number = [[UIImageView alloc] initWithFrame:CGRectMake(265, 50, 50, 50)];
		number.image = [UIImage imageNamed:[NSString stringWithFormat:@"Number%d.png", i]];
		
		[self.view addSubview:number];
		[numbers addObject:number];
		
		[number release];
	}
	
	[self.view addSubview:resetLevelButton];
	
	waitTimer = [[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(startLevel) userInfo:nil repeats:NO] retain];
	[[NSRunLoop currentRunLoop] addTimer:waitTimer forMode:NSDefaultRunLoopMode];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	const float violence = 1.5;
	static BOOL beenhere;
	
	if (beenhere) return;
	
	beenhere = YES;
	
	if (acceleration.x > violence * 2.0 || acceleration.x < (-2.0 * violence)) {
		shake = YES;
	} else if (acceleration.y > violence * 2.0 || acceleration.y < (-2.0 * violence)) {
		shake = YES;
	} else if (acceleration.z > violence * 1.5 || acceleration.z < (-1.5 * violence)) {
		shake = YES;
	} else {
		shake = NO;
	}
	
	if (shake && shakeTimer == nil) {		
		shakeTimer = [[NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(shakeCounter) userInfo:nil repeats:YES] retain];
		[[NSRunLoop currentRunLoop] addTimer:shakeTimer forMode:NSDefaultRunLoopMode];
		
		[self loadLevel:levelIndex];
	} 
	
	beenhere = FALSE;
}

- (void)shakeCounter {
	if (!shake) {		
		[shakeTimer invalidate];
		shakeTimer = nil;		
	}
}

- (void)destroyTimer {
	[waitTimer invalidate];
	[waitTimer release];
	waitTimer = nil;
}

- (IBAction)resetLevel {
	[self loadLevel:levelIndex];
}

- (void)dealloc {
    [level release];	
	[numbers release];
	[startImage release];
	[completeImage release];
	[self destroyTimer];
    [super dealloc];
}

@end
