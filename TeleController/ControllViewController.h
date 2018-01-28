//
//  ControllViewController.h
//  TeleController
//
//  Created by wujiang on 2018/1/28.
//  Copyright © 2018年 wujiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControllViewController : UIViewController
{
@public
    BabyBluetooth *baby;
}
@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@end
