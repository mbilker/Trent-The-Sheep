//
//  GameOverScene.h
//  Perm and Comb
//
//  Created by System Administrator on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
	CCLabelTTF *_label;
}
@property (nonatomic, retain) CCLabelTTF *label;
@end

@interface GameOverScene : CCScene {
	GameOverLayer *_layer;
}
@property (nonatomic, retain) GameOverLayer *layer;
@end
