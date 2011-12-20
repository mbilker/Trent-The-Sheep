//
//  HelloWorldLayer.m
//  Perm and Comb
//
//  Created by mbilker on 12/9/11.
//  Copyright mbilker 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"
#import "Monster.h"
#import "Projectile.h"
#import "AboutScene.h"

NSUInteger RRFactorial(NSUInteger n)
{
    // Use preprocessor macros to determine the maximum value of n computable
    // within the limits prescribed by NSUInteger, whose bit-width depends on
    // architecture: either 64 or 32 bits.
#if __LP64__ || NS_BUILD_32_LIKE_64
#define N 20 // 20! = 2,432,902,008,176,640,000
#else
#define N 12 // 12! = 479,001,600
#endif
    if (n > N) return NSUIntegerMax;
    static NSUInteger f[N + 1];
    static NSUInteger i = 0;
    if (i == 0)
    {
        f[0] = 1;
        i = 1;
    }
    while (i <= n)
    {
        f[i] = i * f[i - 1];
        i++;
    }
    return f[n];
}

NSUInteger nPr(NSUInteger n, NSUInteger r)
{
#if __LP64__ || NS_BUILD_32_LIKE_64
#define N 20 // 20! = 2,432,902,008,176,640,000
#else
#define N 12 // 12! = 479,001,600
#endif
    if (n > N) return NSUIntegerMax;
    if (r > N) return NSUIntegerMax;
    NSUInteger n1 = RRFactorial(n);
    NSUInteger bottom = n1 - r;
    NSUInteger bottom1 = RRFactorial(bottom);
    float output = (n1 / bottom1);
    NSLog(@"Numbers: n=%d r=%d bottom=%lu n1=%lu bottom1=%lu output=%f",n,r,(unsigned long)bottom,(unsigned long)n1,(unsigned long)bottom1,(float)output);
    return output;
}

NSUInteger nCr(NSUInteger n, NSUInteger r)
{
#if __LP64__ || NS_BUILD_32_LIKE_64
#define N 20 // 20! = 2,432,902,008,176,640,000
#else
#define N 12 // 12! = 479,001,600
#endif
    if (n > N) return NSUIntegerMax;
    if (r > N) return NSUIntegerMax;
    NSUInteger n1 = RRFactorial(n);
    NSUInteger r1 = RRFactorial(r);
    NSUInteger bottom = n1 - r;
    NSUInteger bottom1 = RRFactorial(bottom);
    float output = (r1 * (n1 / bottom1));
    NSLog(@"Numbers: n=%d r=%d bottom=%lu n1=%lu r1=%lu bottom1=%lu output=%f",n,r,(unsigned long)bottom,(unsigned long)n1,(unsigned long)r1,(unsigned long)bottom1,(float)output);
    return output;
}

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	[[CCDirector sharedDirector] setDisplayFPS:NO];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
@synthesize scoreLabel = _scoreLabel;
@synthesize nextProjectile = _nextProjectile;
@synthesize healthBar = _healthBar;

-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        
		self.isTouchEnabled = YES;
		
		_targets = [[NSMutableArray alloc] init];
		_projectiles = [[NSMutableArray alloc] init];
		
        // Setup Player
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		_player = [[CCSprite spriteWithFile:@"Player.png"] retain];
		_player.position = ccp(_player.contentSize.width/2, winSize.height/2);
		[self addChild:_player z:0];
        
        // Setup about window
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemFromNormalImage:@"about.png" selectedImage:@"about.png" target:self selector:@selector(aboutButtonTapped:)];
        aboutMenuItem.position = ccp((winSize.width - 20),(winSize.height - 20));
        CCMenu *aboutMenu = [CCMenu menuWithItems:aboutMenuItem, nil];
        aboutMenu.position = CGPointZero;
        [self addChild:aboutMenu];
		
		// Set up score and score label
        _score = 0;
        _oldScore = -1;
        self.scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" dimensions:CGSizeMake(175, 50) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:32];
        _scoreLabel.position = ccp(winSize.width - _scoreLabel.contentSize.width/2, _scoreLabel.contentSize.height/2);
        _scoreLabel.color = ccc3(0,0,0);
        [self addChild:_scoreLabel z:0];
		
        // Max Score
		_maxScore = 30;
		
		// Health
		_health = 100;
        
        // Health Bar
        self.healthBar = [CCProgressTimer progressWithFile:@"health.png"];
        _healthBar.scale = 0.35;
        _healthBar.type = kCCProgressTimerTypeHorizontalBarLR;
        _healthBar.position = ccp(100,45);
        _healthBar.percentage = _health;
        [self addChild:_healthBar z:0];
        
		// Off Screen Projectiles
        _projectileOffScreen = 0;
        
        // Game Logic
		[self schedule:@selector(gameLogic:) interval:1.0];
		[self schedule:@selector(update:)];
        //[self schedule:@selector(initOpenFeint:) interval:3.0];
		
        // Background Music
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
	}
	return self;
}

- (void)aboutButtonTapped:(id)sender {
    //NSLog(@"About Button Tapped");
    AboutScene *aboutlayer = [AboutLayer node];
    [[CCDirector sharedDirector] replaceScene:aboutlayer];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	[_targets release];
	_targets = nil;
	[_projectiles release];
	_projectiles = nil;
	[_player release];
	_player = nil;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void)spriteMoveFinished:(id)sender {

	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
	if (sprite.tag == 1) { // target
		[_targets removeObject:sprite];
		_health -= 25;
        [_healthBar setPercentage:_health];
		//NSLog(@"%d",_health);
		if (_health == 0) {
            _projectileOffScreen = 0;
			GameOverScene *gameOverScene = [GameOverScene node];
			[gameOverScene.layer.label setString:[NSString stringWithFormat:@"You Lose\nScore: %d",_score]];
			[[CCDirector sharedDirector] replaceScene:gameOverScene];
		}
	} else if (sprite.tag == 2) { // projectile
        _projectileOffScreen ++;
        //NSLog(@"Project Off Screen: %d",_projectileOffScreen);
		[_projectiles removeObject:sprite];
        if(_projectileOffScreen == 30) {
            GameOverScene *gameOverScene = [GameOverScene node];
			[gameOverScene.layer.label setString:[NSString stringWithFormat:@"You Lose\n%d projectiles went offscreen",_projectileOffScreen]];
            _projectileOffScreen = 0;
			[[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
	}
	
}

-(void)addTarget {
    
	//nPr(_projectileOffScreen, _score);
    nCr(_projectileOffScreen, _score);
	//CCSprite *target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)]; 
	Monster *target = nil;
	if ((arc4random() % 2) == 0) {
		target = [WeakAndFastMonster monster];
	} else {
		target = [StrongAndSlowMonster monster];
	}
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = target.contentSize.height/2;
	int maxY = winSize.height - target.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = target.minMoveDuration;
	int maxDuration = target.maxMoveDuration;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	target.tag = 1;
	[_targets addObject:target];
}

//-(void)onEnterTransitionDidFinish {
//    
//}

-(void)gameLogic:(ccTime)dt {
	[self addTarget];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    if (_nextProjectile != nil) return;
	
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
	
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //self.nextProjectile = [[CCSprite spriteWithFile:@"Projectile.png"] retain];
	self.nextProjectile = [[[Projectile alloc] initWithFile:@"Projectile.png"] autorelease];
    _nextProjectile.position = ccp(20, winSize.height/2);
	
    // Determine offset of location to projectile
    int offX = location.x - _nextProjectile.position.x;
    int offY = location.y - _nextProjectile.position.y;
	
    // Bail out if we are shooting down or backwards
    if (offX <= 0) return;
	
    // Play a sound!
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
	
    // Determine where we wish to shoot the projectile to
    int realX = winSize.width + (_nextProjectile.contentSize.width/2);
    float ratio = (float) offY / (float) offX;
    int realY = (realX * ratio) + _nextProjectile.position.y;
    CGPoint realDest = ccp(realX, realY);
	
    // Determine the length of how far we're shooting
    int offRealX = realX - _nextProjectile.position.x;
    int offRealY = realY - _nextProjectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
	
    // Determine angle to face
    float angleRadians = atanf((float)offRealY / (float)offRealX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * angleDegrees;
    float rotateSpeed = 0.5 / M_PI; // Would take 0.5 seconds to rotate 0.5 radians, or half a circle
    float rotateDuration = fabs(angleRadians * rotateSpeed);    
    [_player runAction:[CCSequence actions:
						[CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
						[CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
						nil]];
	
    // Move projectile to actual endpoint
    [_nextProjectile runAction:[CCSequence actions:
								[CCMoveTo actionWithDuration:realMoveDuration position:realDest],
								[CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
								nil]];
	
    // Add to projectiles array
    _nextProjectile.tag = 2;
	
}

-(void)finishShoot {
	
    // Ok to add now - we've finished rotation!
    [self addChild:_nextProjectile];
    [_projectiles addObject:_nextProjectile];
	
    // Release
    [_nextProjectile release];
    _nextProjectile = nil;
	
}

- (void)update:(ccTime)dt {
	
	NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
	for (CCSprite *projectile in _projectiles) {
		CGRect projectileRect = CGRectMake(
										   projectile.position.x - (projectile.contentSize.width/2), 
										   projectile.position.y - (projectile.contentSize.height/2), 
										   projectile.contentSize.width, 
										   projectile.contentSize.height);
		
		BOOL monsterHit = FALSE;
		NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
		for (CCSprite *target in _targets) {
			CGRect targetRect = CGRectMake(
										   target.position.x - (target.contentSize.width/2), 
										   target.position.y - (target.contentSize.height/2), 
										   target.contentSize.width, 
										   target.contentSize.height);
			
			if (CGRectIntersectsRect(projectileRect, targetRect)) {
				
				if (![projectile shouldDamageMonster:target]) continue;
				
				//[targetsToDelete addObject:target];	
				monsterHit = TRUE;
				Monster *monster = (Monster *)target;
				monster.hp--;
				//NSLog(@"%d",monster.hp);
				if (monster.hp <= 0) {
					_score ++;
					[targetsToDelete addObject:target];
				}
				break;				
			}
		}
		
		for (CCSprite *target in targetsToDelete) {
			[_targets removeObject:target];
			[self removeChild:target cleanup:YES];
			_projectilesDestroyed++;
			if (_projectilesDestroyed > _maxScore) {
				GameOverScene *gameOverScene = [GameOverScene node];
				_projectilesDestroyed = 0;
				[gameOverScene.layer.label setString:[NSString stringWithFormat:@"You Win!\nScore: %d", _score]];
				[[CCDirector sharedDirector] replaceScene:gameOverScene];
			}
		}
		
		//if (targetsToDelete.count > 0) {
		//	[projectilesToDelete addObject:projectile];
        if (monsterHit) {
            [projectilesToDelete addObject:projectile];
            [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.caf"];
        }
		//}
		[targetsToDelete release];
	}
	
	for (CCSprite *projectile in projectilesToDelete) {
		[_projectiles removeObject:projectile];
		[self removeChild:projectile cleanup:YES];
	}
	[projectilesToDelete release];
	
	// Update score only when it changes for efficiency
	if (_score != _oldScore) {
		_oldScore = _score;
		[_scoreLabel setString:[NSString stringWithFormat:@"Score: %d", _score]];
	}
}

@end
