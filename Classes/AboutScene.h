//
//  AboutScene.h
//  Perm and Comb
//
//  Created by Matt Bilker on 12/18/11.
//  Copyright (c) 2011 mbilker. All rights reserved.
//

#import "cocos2d.h"

@interface AboutLayer : CCLayerColor {
    
}

@end

@interface AboutScene : CCScene {
    AboutLayer  *_layer;
}
@property (nonatomic, retain) AboutLayer *layer;
@end
