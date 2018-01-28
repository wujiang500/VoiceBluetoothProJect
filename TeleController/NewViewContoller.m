//
//  NewViewContoller.m
//  TeleController
//
//  Created by wujiang on 2018/1/20.
//  Copyright © 2018年 wujiang. All rights reserved.
//

#import "NewViewContoller.h"
#import "ControllViewController.h"
@interface NewViewContoller ()<IFlySpeechRecognizerDelegate>
{
    CBMutableService *service;
}

@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;  //语音识别类
@property (nonatomic,strong)NSString * resultStr;// 接受语音识别结果的字符串


@end


#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define channelOnPeropheralView @"peripheralView"


@implementation NewViewContoller

//退出时断开连接
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化
    self.services = [[NSMutableArray alloc]init];
    [self babyDelegate];
    
    //开始扫描设备
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    [SVProgressHUD showInfoWithStatus:@"准备连接设备"];
    
   
    
    // 发送蓝牙数据
    //[self makeService];
    
}

- (void)makeService{
    //配置第一个服务s1
    service = makeCBService(@"FFF0");
    //配置s1的3个characteristic
    makeCharacteristicToService(service, @"FFF1", @"r", @"hello1");//读
    makeCharacteristicToService(service, @"FFF2", @"w", @"hello2");//写
//    makeCharacteristicToService(service, genUUID(), @"rw", @"hello3");//读写,自动生成uuid
//    makeCharacteristicToService(service, @"FFF4", nil, @"hello4");//默认读写字段
//    makeCharacteristicToService(service, @"FFF5", @"n", @"hello5");//notify字段
   
    //实例化baby
   // baby = [BabyBluetooth shareBabyBluetooth];
    //配置委托
    //添加服务和启动外设
    baby.bePeripheral().addServices(@[service]).startAdvertising();
    
}





// 停止语音识别按键
- (void)stopListen{
    // 停止语音识别
    NSLog(@"stop listening");
    
    [self.iFlySpeechRecognizer stopListening];
    
    
}
#pragma blueDelegate
//babyDelegate
-(void)babyDelegate{
    
    
    /*----------------------------------------以下是扫描蓝牙代理----------------------------------------------------*/
    
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        
        // 链接成功后， 跳转到操作页面！
        
        ControllViewController * controlVC = [[ControllViewController alloc] init];
        controlVC.currPeripheral = peripheral;
        controlVC->baby = self->baby;
        [weakSelf presentViewController:controlVC animated:NO completion:nil];
        
        
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"wujiang设备：%@--连接成功",peripheral.name]];
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"wujiang设备：%@--连接失败",peripheral.name]];
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"wujiang设备：%@--断开失败",peripheral.name]];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            
            // 注释掉了向tableView中加入数据   wujiang  0120
            
            
            ///插入section到tableview
         //   [weakSelf insertSectionToTableView:s];
        }
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        
        
         // 注释掉了向tableView中加入数据       wujiang  0120
        
        
        //插入row到tableview
      //  [weakSelf insertRowToTableView:service];
        
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //读取rssi的委托
    [baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];
    
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    
}

-(void)loadData{
    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    //    baby.connectToPeripheral(self.currPeripheral).begin();
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
