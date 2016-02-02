//
//  AppDelegate.h
//  HelpMe
//
//  Created by 刘伟龙 on 16/2/2.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BMKMapManager *_mapManager;
}

@property (strong, nonatomic) UIWindow *window;


@end

