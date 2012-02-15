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
#import "cocos2d.h"

#import "Achievements.h"
#import "DDGameKitHelper.h"
#import "Perm_and_CombAppDelegate.h"

#import <GameKit/GameKit.h>

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
    NSUInteger bottom = n - r;
    NSUInteger bottom1 = RRFactorial(bottom);
    NSUInteger output = (n1 / bottom1);
    //NSLog(@"Numbers: n=%d r=%d bottom=%lu n1=%lu bottom1=%lu output=%lu",n,r,(unsigned long)bottom,(unsigned long)n1,(unsigned long)bottom1,(unsigned long)output);
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
    NSUInteger bottom = n - r;
    NSUInteger bottom1 = RRFactorial(bottom);
    NSUInteger output = (r1 * (n1 / bottom1));
    //NSLog(@"Numbers: n=%d r=%d bottom=%lu n1=%lu r1=%lu bottom1=%lu output=%lu",n,r,(unsigned long)bottom,(unsigned long)n1,(unsigned long)r1,(unsigned long)bottom1,(unsigned long)output);
    return output;
}

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
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
@synthesize delegate;

-(CCSprite *)spriteWithColor:(ccColor4F)bgColor textureSize:(float)textureSize {
    
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:bgColor.r g:bgColor.g b:bgColor.b a:bgColor.a];
    
    // 3: Draw into the texture
    CCSprite *noise = [CCSprite spriteWithFile:@"Noise.png"];
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureSize/2, textureSize/2);
    [noise visit];
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
    
}

- (ccColor4F)randomBrightColor {
    
    while (true) {
        float requiredBrightness = 200;
        ccColor4B randomColor = 
        ccc4(arc4random() % 255,
             arc4random() % 255, 
             arc4random() % 255, 
             255);
        if (randomColor.r > requiredBrightness || 
            randomColor.g > requiredBrightness ||
            randomColor.b > requiredBrightness) {
            return ccc4FFromccc4B(randomColor);
        }        
    }
    
}

- (void)genBackground {
    
    [_background removeFromParentAndCleanup:YES];
    
    ccColor4F bgColor = [self randomBrightColor];
    _background = [self spriteWithColor:bgColor textureSize:512];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _background.position = ccp(winSize.width/2, winSize.height/2);        
    [self addChild:_background z:-1];
    
}

-(id) init
{
	if( (self=[super init] )) {
        
        self.delegate = (Perm_and_CombAppDelegate*) [[UIApplication sharedApplication] delegate];
		self.isTouchEnabled = YES;
        
        [self genBackground];
		
		_targets = [[NSMutableArray alloc] init];
		_projectiles = [[NSMutableArray alloc] init];
        
        // Sprite Sheets
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Targets.plist"];
		
        // Setup Player
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		//_player = [[CCSprite spriteWithFile:@"Player.png"] retain];
        _player = [[CCSprite spriteWithFile:@"TrentSheep.small.png"] retain];
		_player.position = ccp(_player.contentSize.width/2, winSize.height/2);
		[self addChild:_player z:0];
        
        // Setup menu
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"about.png" selectedImage:@"about.png" target:self selector:@selector(aboutButtonTapped:)];
        aboutMenuItem.position = ccp((winSize.width - 20),(winSize.height - 20));
        
        CCMenuItem *gameCenterButton = [CCMenuItemImage itemWithNormalImage:@"gamecenter.png" selectedImage:@"gamecenter.png" target:self selector:@selector(gameCenterButtonTapped:)];
        gameCenterButton.position = ccp((winSize.width - 52),(winSize.height - 20));
        
        CCMenuItem *gameCenterLeaderboardButton = [CCMenuItemImage itemWithNormalImage:@"gamecenter.png" selectedImage:@"gamecenter.png" target:self selector:@selector(gameCenterLeaderboardButtonTapped:)];
        gameCenterLeaderboardButton.position = ccp((winSize.width - 86),(winSize.height - 20));
        
        CCMenu *Menu = [CCMenu menuWithItems:gameCenterLeaderboardButton, gameCenterButton, aboutMenuItem, nil];
        Menu.position = CGPointZero;
        [self addChild:Menu];
		
		// Set up score and score label
        _oldScore = -1;
        self.scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %d\nPossible Targeting Choices:\n0", delegate.score] dimensions:CGSizeMake(400, 100) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:28];
        _scoreLabel.position = ccp(winSize.width - _scoreLabel.contentSize.width/2, _scoreLabel.contentSize.height/2);
        _scoreLabel.color = ccc3(0,0,0);
        [self addChild:_scoreLabel z:0];
		
        // Max Score
		_maxScore = 20;
		
		// Health
		_health = 100;
        
        // Health Bar
        CCSprite *healthImage = [CCSprite spriteWithFile:@"health.png"];
        self.healthBar = [CCProgressTimer progressWithSprite:healthImage];
        _healthBar.scale = 0.35;
        _healthBar.type = kCCProgressTimerTypeBar;
        _healthBar.midpoint = ccp(0,healthImage.contentSize.height/2);
        _healthBar.position = ccp(100,45);
        _healthBar.percentage = _health;
        [self addChild:_healthBar z:0];
        
		// Off Screen Projectiles
        _projectileOffScreen = 0;
        
        _pauseScreenUp = FALSE;
        CCMenuItem *pauseMenuItem = [CCMenuItemImage
                                     itemWithNormalImage:@"gamecenter.png" selectedImage:@"gamecenter.png"
                                     target:self selector:@selector(PauseButtonTapped:)];
        pauseMenuItem.position = ccp(100, 65);
        CCMenu *upgradeMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
        upgradeMenu.position = CGPointZero;
        [self addChild:upgradeMenu z:2];
        
        // Game Logic
		[self schedule:@selector(gameLogic:) interval:1.0];
		[self schedule:@selector(update:)];
        
        //[[DDGameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
	}
	return self;
}

-(void)PauseButtonTapped:(id)sender
{
    if(_pauseScreenUp == FALSE)
    {
        _pauseScreenUp = TRUE;
        //if you have music uncomment the line bellow
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        [[CCDirector sharedDirector] pause];
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        pauseLayer = [CCLayerColor layerWithColor: ccc4(150, 150, 150, 125) width: s.width height: s.height];
        pauseLayer.position = CGPointZero;
        [self addChild: pauseLayer z:8];
        
        _pauseScreen = [[CCSprite spriteWithFile:@"pauseBackground.gif"] retain];
        _pauseScreen.position = ccp(250,150);
        [self addChild:_pauseScreen z:8];
        
        CCMenuItem *ResumeMenuItem = [CCMenuItemImage
                                      itemWithNormalImage:@"gamecenter.png" selectedImage:@"gamecenter.png"
                                      target:self selector:@selector(ResumeButtonTapped:)];
        ResumeMenuItem.position = ccp(250, 190);
        
        _pauseScreenMenu = [CCMenu menuWithItems:ResumeMenuItem, nil];
        _pauseScreenMenu.position = CGPointZero;
        [self addChild:_pauseScreenMenu z:10];
    }
}

-(void)ResumeButtonTapped:(id)sender{
    [self removeChild:_pauseScreen cleanup:YES];
    [self removeChild:_pauseScreenMenu cleanup:YES];
    [self removeChild:pauseLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    _pauseScreenUp = FALSE;
}

- (void) checkAchievements
{
	NSString* identifier= NULL;
    NSString* info= NULL;
	double percentComplete= 0;
	switch(_projectilesDestroyed)
	{
		case 1:
		{
			identifier= kAchievementOneHit;
            info= @"One Hit";
			percentComplete= 100.0;
			break;
		}
		case 2:
		{
			identifier= kAchievementFiveHit;
            info= @"Five Hits";
			percentComplete= 40.0;
			break;
		}
        case 3:
		{
			identifier= kAchievementFiveHit;
            info= @"Five Hits";
			percentComplete= 60.0;
			break;
		}
        case 4:
		{
			identifier= kAchievementFiveHit;
            info= @"Five Hits";
			percentComplete= 80.0;
			break;
		}
        case 5:
		{
			identifier= kAchievementFiveHit;
            info= @"Five Hits";
			percentComplete= 100.0;
			break;
		}
        case 6:
		{
			identifier= kAchievementTenHit;
            info= @"Ten Hits";
			percentComplete= 60.0;
			break;
		}
        case 7:
		{
			identifier= kAchievementTenHit;
            info= @"Ten Hits";
			percentComplete= 70.0;
			break;
		}
        case 8:
		{
			identifier= kAchievementTenHit;
            info= @"Ten Hits";
			percentComplete= 80.0;
			break;
		}
        case 9:
		{
			identifier= kAchievementTenHit;
            info= @"Ten Hits";
			percentComplete= 90.0;
			break;
		}
        case 10:
		{
			identifier= kAchievementTenHit;
            info= @"Ten Hits";
			percentComplete= 100.0;
			break;
		}
        case 11:
		{
			identifier= kAchievementFifthteenHit;
            info= @"Fifthteen Hits";
			percentComplete= 73.0;
			break;
		}
        case 12:
		{
			identifier= kAchievementFifthteenHit;
            info= @"Fifthteen Hits";
			percentComplete= 80.0;
			break;
		}
        case 13:
		{
			identifier= kAchievementFifthteenHit;
            info= @"Fifthteen Hits";
			percentComplete= 86.0;
			break;
		}
        case 14:
		{
			identifier= kAchievementFifthteenHit;
            info= @"Fifthteen Hits";
			percentComplete= 93.0;
			break;
		}
        case 15:
		{
			identifier= kAchievementFifthteenHit;
            info= @"Fifthteen Hits";
			percentComplete= 100.0;
			break;
        }
        case 16:
        {
            identifier= kAchievementFifthteenHit;
            info= @"Thirty Hits";
			percentComplete= 53.3;
			break;
        }
        case 17:
        {
            identifier= kAchievementFifthteenHit;
            info= @"Thirty Hits";
			percentComplete= 56.6;
			break;
        }
        case 18:
        {
            identifier= kAchievementFifthteenHit;
            info= @"Thirty Hits";
			percentComplete= 60.0;
			break;
        }
        case 19:
        {
            identifier= kAchievementFifthteenHit;
            info= @"Thirty Hits";
			percentComplete= 63.3;
			break;
        }
		case 20:
		{
			identifier= kAchievementThirtyHit;
            info= @"Thirty Hits";
			percentComplete= 66.0;
			break;
		}
		case 25:
		{
			identifier= kAchievementThirtyHit;
            info= @"Thirty Hits";
			percentComplete= 83.0;
			break;
		}
		case 27:
		{
			identifier= kAchievementThirtyHit;
            info= @"Thirty Hits";
			percentComplete= 90.0;
			break;
		}
		case 30:
		{
			identifier= kAchievementThirtyHit;
            info= @"Thirty Hits";
			percentComplete= 100.0;
			break;
		}
			
	}
	if(identifier!= NULL)
	{
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:identifier percentComplete:percentComplete];
	}
}

- (void)aboutButtonTapped:(id)sender {
    //NSLog(@"About Button Tapped");
    _projectileOffScreen = 0;
    delegate.score = 0;
    AboutScene *aboutlayer = [AboutLayer node];
    [[CCDirector sharedDirector] replaceScene:aboutlayer];
}

- (void)gameCenterButtonTapped:(id)sender {
    //NSLog(@"Opening Achievements");
    [[DDGameKitHelper sharedGameKitHelper] showAchievements];
}

- (void) gameCenterLeaderboardButtonTapped:(id)sender {
    //NSLog(@"Opening Leaderboards");
    //[[DDGameKitHelper sharedGameKitHelper] showLeaderboard];
    //[[DDGameKitHelper sharedGameKitHelper] resetAchievements];
    GKLeaderboardViewController* leaderboardVC = [[[GKLeaderboardViewController alloc] init] autorelease];
    if (leaderboardVC != nil)
    {
        leaderboardVC.leaderboardDelegate = self;
        [[CCDirector sharedDirector] pause];
        [[CCDirector sharedDirector] stopAnimation];
        Perm_and_CombAppDelegate *app = (Perm_and_CombAppDelegate*) [[UIApplication sharedApplication] delegate];
        [[app navController] presentModalViewController:leaderboardVC animated:YES];
    }
}

- (void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)viewController
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
    Perm_and_CombAppDelegate *app = (Perm_and_CombAppDelegate*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
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
    
    [_healthBar release];
    _healthBar = nil;
    
    // Crashes App
    //[_background release];
    //_background = nil;
	
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
			GameOverScene *gameOverScene = [GameOverScene node];
			[gameOverScene.layer.label setString:[NSString stringWithFormat:@"You Lose\nScore: %d",delegate.score]];
            [[DDGameKitHelper sharedGameKitHelper] submitScore:(int64_t)delegate.score category:kEasyLeaderboardID];
            delegate.score = 0;
            _projectileOffScreen = 0;
			[[CCDirector sharedDirector] replaceScene:gameOverScene];
		}
	} else if (sprite.tag == 2) { // projectile
        _projectileOffScreen ++;
        //NSLog(@"Project Off Screen: %d",_projectileOffScreen);
		[_projectiles removeObject:sprite];
        if(_projectileOffScreen == 50) {
            GameOverScene *gameOverScene = [GameOverScene node];
			[gameOverScene.layer.label setString:[NSString stringWithFormat:@"You Lose\n%d projectiles went offscreen",_projectileOffScreen]];
            [[DDGameKitHelper sharedGameKitHelper] submitScore:(int64_t)delegate.score category:kEasyLeaderboardID];
            delegate.score = 0;
            _projectileOffScreen = 0;
			[[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
	}
	
}

-(void)addTarget {
    
	//nPr(_projectileOffScreen, _score);
	//CCSprite *target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)]; 
	Monster *target = nil;
	if ((arc4random() % 2) == 0) {
		target = [WeakAndFastMonster monster];
	} else {
	//	target = [StrongAndSlowMonster monster];
        target = [Pig monster];
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
    if (target.animation == nil) {
        [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    } else {
        CCAction *animate = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:target.animation]];
        [target runAction:animate];
        [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    }
	
	target.tag = 1;
	[_targets addObject:target];
}

//-(void)onEnterTransitionDidFinish {
//    
//}

-(void)gameLogic:(ccTime)dt {
    NSUInteger r = RRFactorial(2);
    NSUInteger permutation = RRFactorial(_projectileOffScreen);
    //NSLog(@"%d %d",permutation,r);
    if (permutation == 1 || permutation >= r) {
        [self addTarget];
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _number++;
    if (_number == 9) {
        [self genBackground];
        _number = 0;
    }
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
    _nextProjectile.position = ccp(60, winSize.height/2);
	
    // Determine offset of location to projectile
    int offX = location.x - _nextProjectile.position.x;
    int offY = location.y - _nextProjectile.position.y;
	
    // Bail out if we are shooting down or backwards
    if (offX <= 0) return;
	
    // Play a sound!
    //[[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew.caf"];
	
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

-(void)checkWave {
    GameOverScene *gameOverScene = [GameOverScene node];
    if (delegate.wave >= 10)
    {
        _projectilesDestroyed = 0;
        [[DDGameKitHelper sharedGameKitHelper] submitScore:(int64_t)delegate.score category:kEasyLeaderboardID];
        [gameOverScene.layer.label setString:[NSString stringWithFormat:@"Game Complete!\n\nScore: %d", delegate.score]];
        delegate.wave = 0;
        delegate.score = 0;
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    } else {
        _projectilesDestroyed = 0;
        delegate.wave += 1;
        [[DDGameKitHelper sharedGameKitHelper] submitScore:delegate.score category:kEasyLeaderboardID];
        [gameOverScene.layer.label setString:[NSString stringWithFormat:@"Wave %d Complete!\nScore: %d", delegate.wave, delegate.score]];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
}

- (void)update:(ccTime)dt {
	
	NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
	for (Projectile *projectile in _projectiles) {
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
					delegate.score += monster.points;
                    _targetsDestroyed++;
					[self checkAchievements];
					[targetsToDelete addObject:target];
				}
				break;				
			}
		}
		
		for (CCSprite *target in targetsToDelete) {
			[_targets removeObject:target];
			[self removeChild:target cleanup:YES];
			_projectilesDestroyed++;
			if (_projectilesDestroyed >= _maxScore) {
				[self checkWave];
			}
		}
		
        if (monsterHit) {
            [projectilesToDelete addObject:projectile];
            [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.caf"];
        }
		[targetsToDelete release];
	}
	
	for (CCSprite *projectile in projectilesToDelete) {
		[_projectiles removeObject:projectile];
		[self removeChild:projectile cleanup:YES];
	}
	[projectilesToDelete release];
	
	// Update score only when it changes for efficiency
	if (delegate.score != _oldScore) {
        _oldScore = delegate.score;
        if (nCr(delegate.score, _targetsDestroyed) == 4294967295) {
            [_scoreLabel setString:[NSString stringWithFormat:@"Score: %d\nPossible Targeting Choices:\nOver 4 Million", delegate.score]];
        } else {
            [_scoreLabel setString:[NSString stringWithFormat:@"Score: %d\nPossible Targeting Choices:\n%u", delegate.score, nCr(delegate.score, _targetsDestroyed)]];
        }
	}
}

#pragma mark -

@end
