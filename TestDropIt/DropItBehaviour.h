//
//  DropItBehaviour.h
//  DropIt
//
//  Created by Priyanjana Bengani on 21/12/2013.
//  Copyright (c) 2013 anothercookiecrumbles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropItBehaviour : UIDynamicBehavior

- (void) addItem:(id <UIDynamicItem>) item;
- (void) removeItem:(id <UIDynamicItem>) item;

@end
