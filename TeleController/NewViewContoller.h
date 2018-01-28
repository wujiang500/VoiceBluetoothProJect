//
//  NewViewContoller.h
//  TeleController
//
//  Created by wujiang on 2018/1/20.
//  Copyright © 2018年 wujiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PeripheralInfo.h"

@interface NewViewContoller : UIViewController
{
@public
    BabyBluetooth *baby;
}
@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;

//@property(strong,nonatomic)BabyBluetooth *baby;

@end
