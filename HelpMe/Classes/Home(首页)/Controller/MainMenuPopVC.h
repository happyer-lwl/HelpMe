//
//  MainMenuPopVC.h
//  HelpMe
//
//  Created by 刘伟龙 on 16/2/2.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMenuTableViewVCWidth (kScreenWidth * 2.0 / 3.0)

@protocol MainPopMenuVCDelegate <NSObject>

-(void)popMenuDidSelected:(NSIndexPath *)indexPath;

@end

@interface MainMenuPopVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<MainPopMenuVCDelegate> delegate;

@end
