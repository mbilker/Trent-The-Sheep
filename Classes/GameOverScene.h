//
//  GameOverScene.h
//  Perm and Comb
//
//  Created by mbilker on 12/9/11.
//  Copyright 2011 mbilker. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayer {
	CCLabelTTF *_label;
    CCSprite *_background;
}
@property (nonatomic, retain) CCLabelTTF *label;
@end

@interface GameOverScene : CCScene {
	GameOverLayer *_layer;
}
@property (nonatomic, retain) GameOverLayer *layer;
@end
