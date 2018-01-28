//
//  ControllViewController.m
//  TeleController
//
//  Created by wujiang on 2018/1/28.
//  Copyright © 2018年 wujiang. All rights reserved.
//

#import "ControllViewController.h"

@interface ControllViewController ()<IFlySpeechRecognizerDelegate>
{
    CBMutableService *service;
}

@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;  //语音识别类
@property (nonatomic,strong)NSString * resultStr;// 接受语音识别结果的字符串

@end


#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define channelOnPeropheralView @"peripheralView"

@implementation ControllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 语音识别初始化
    [self initRecognizer];
    
    
     [self createUI];
    
}
- (void)createUI{
    
    // 前进
    UIButton * goForward = [UIButton buttonWithType:UIButtonTypeCustom];
    goForward.frame = CGRectMake(100, 70, 80, 80);
    [goForward setTitle:@"前进" forState:UIControlStateNormal];
    [goForward setBackgroundColor:[UIColor lightGrayColor]];
    [goForward addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goForward];
    goForward.layer.cornerRadius = 40.0;
    goForward.layer.borderColor = [UIColor lightGrayColor].CGColor;
    goForward.layer.borderWidth = 1.0f;
    
    
    // 后退
    UIButton * goBack = [UIButton buttonWithType:UIButtonTypeCustom];
    goBack.frame = CGRectMake(100, 200, 80, 80);
    [goBack setTitle:@"后退" forState:UIControlStateNormal];
    [goBack setBackgroundColor:[UIColor lightGrayColor]];
    [goBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBack];
    goBack.layer.cornerRadius = 40.0;
    goBack.layer.borderColor = [UIColor lightGrayColor].CGColor;
    goBack.layer.borderWidth = 1.0f;
    
    
    // 左转
    UIButton * turnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    turnLeft.frame = CGRectMake(screenWidth-200, 70, 80, 80);
    [turnLeft setTitle:@"左转" forState:UIControlStateNormal];
    [turnLeft setBackgroundColor:[UIColor lightGrayColor]];
    [turnLeft addTarget:self action:@selector(turnLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:turnLeft];
    turnLeft.layer.cornerRadius = 40.0;
    turnLeft.layer.borderColor = [UIColor lightGrayColor].CGColor;
    turnLeft.layer.borderWidth = 1.0f;
    
    
    // 右转
    UIButton * turnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    turnRight.frame = CGRectMake(screenWidth-200, 200, 80, 80);
    [turnRight setTitle:@"右转" forState:UIControlStateNormal];
    [turnRight setBackgroundColor:[UIColor lightGrayColor]];
    [turnRight addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:turnRight];
    turnRight.layer.cornerRadius = 40.0;
    turnRight.layer.borderColor = [UIColor lightGrayColor].CGColor;
    turnRight.layer.borderWidth = 1.0f;
    
    // 语音控制
    UIButton * startListen = [UIButton buttonWithType:UIButtonTypeCustom];
    startListen.frame = CGRectMake((screenWidth-150)/2, 100, 150, 45);
    [startListen setTitle:@"语音控制" forState:UIControlStateNormal];
    [startListen setBackgroundColor:[UIColor lightGrayColor]];
    [startListen addTarget:self action:@selector(startListen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startListen];
    startListen.layer.cornerRadius = 10.0;
    startListen.layer.borderColor = [UIColor lightGrayColor].CGColor;
    startListen.layer.borderWidth = 1.0f;
    
    
    // 语音控制停止
    UIButton * stopListen = [UIButton buttonWithType:UIButtonTypeCustom];
    stopListen.frame = CGRectMake((screenWidth-150)/2, 200, 150, 45);
    [stopListen setTitle:@"结束语音控制" forState:UIControlStateNormal];
    [stopListen setBackgroundColor:[UIColor lightGrayColor]];
    [stopListen addTarget:self action:@selector(stopListen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopListen];
    stopListen.layer.cornerRadius = 10.0;
    stopListen.layer.borderColor = [UIColor lightGrayColor].CGColor;
    stopListen.layer.borderWidth = 1.0f;
    
}



#pragma mark --------buttonClicks------------
// 前进
- (void)goForward{
    // 按照规定的蓝牙协议发送前进数据，
    
    //0xAA 0x12 0x00 0xFC
    //配置第一个服务s1
    service = makeCBService(@"FFF0");
    //配置s1的3个characteristic
    // makeCharacteristicToService(service, @"FFF1", @"0x00", @"0xFC");//读
    //makeCharacteristicToService(service, @"0x12", @"0x00", @"0xFC");//写
    //  makeCharacteristicToService(service, @"FFF2", @"0x00", @(0x12x120x0000FC).stringValue);//写
    makeCharacteristicToService(service, @"FFF2", @"rw", @"AA1200FC");//写

    //实例化baby
    //baby = [BabyBluetooth shareBabyBluetooth];
    //配置委托
    [self babyDelegate];
    
    //添加服务和启动外设
    baby.bePeripheral().addServices(@[service]).startAdvertising();
    
}

// 后退
- (void)goBack{
    
}

// 左转
- (void)turnLeft{
    
}

// 右转
- (void)turnRight{
    
    
}

#pragma mark --------VoiceDelegate------------
- (void)initRecognizer{
    
    //创建语音识别对象
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    //设置识别参数
    
    //set timeout of recording
    [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    //set VAD timeout of end of speech(EOS)
    [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
    //set VAD timeout of beginning of speech(BOS)
    [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
    //set network timeout
    [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
    
    //set sample rate, 16K as a recommended option
    [_iFlySpeechRecognizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //set language
    [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
    //set accent
    [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
    
    //set whether or not to show punctuation in recognition results
    [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
    
    
    
    //设置为听写模式
    [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
    [_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //启动识别服务
    
    [_iFlySpeechRecognizer setDelegate:self];
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_STREAM forKey:@"audio_source"];
}


// 开始识别语音按钮时间
- (void)startListen{
    // 识别语音
    NSLog(@"start listening");
    
    [_iFlySpeechRecognizer cancel];
    
    //Set microphone as audio source
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //Set result type
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //Set the audio name of saved recording file while is generated in the local storage path of SDK,by default in library/cache.
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    
}


-(void)babyDelegate{
    
    /*----------------------------------------以下是蓝牙发送数据代理----------------------------------------------*/
    //设置添加service委托 | set didAddService block
    [baby peripheralModelBlockOnPeripheralManagerDidUpdateState:^(CBPeripheralManager *peripheral) {
        NSLog(@"PeripheralManager trun status code: %ld",(long)peripheral.state);
    }];
    
    //设置添加service委托 | set didAddService block
    [baby peripheralModelBlockOnDidStartAdvertising:^(CBPeripheralManager *peripheral, NSError *error) {
        NSLog(@"didStartAdvertising !!!");
    }];
    
    //设置添加service委托 | set didAddService block
    [baby peripheralModelBlockOnDidAddService:^(CBPeripheralManager *peripheral, CBService *service, NSError *error) {
        NSLog(@"Did Add Service uuid: %@ ",service.UUID);
    }];
    
    //设置添加service委托 | set didAddService block
    [baby peripheralModelBlockOnDidReceiveReadRequest:^(CBPeripheralManager *peripheral,CBATTRequest *request) {
        NSLog(@"request characteristic uuid:%@",request.characteristic.UUID);
        //判断是否有读数据的权限
        if (request.characteristic.properties & CBCharacteristicPropertyRead) {
            NSData *data = request.characteristic.value;
            [request setValue:data];
            //对请求作出成功响应
            [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
        }else{
            //错误的响应
            [peripheral respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
        }
    }];
    
    //设置添加service委托 | set didAddService block
    [baby peripheralModelBlockOnDidReceiveWriteRequests:^(CBPeripheralManager *peripheral,NSArray *requests) {
        NSLog(@"didReceiveWriteRequests");
        CBATTRequest *request = requests[0];
        //判断是否有写数据的权限
        if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
            //需要转换成CBMutableCharacteristic对象才能进行写值
            CBMutableCharacteristic *c =(CBMutableCharacteristic *)request.characteristic;
            c.value = request.value;
            [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
        }else{
            [peripheral respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
        }
    }];
    
    __block NSTimer *timer;
    //设置添加service委托 | set didAddService block
    [baby peripheralModelBlockOnDidSubscribeToCharacteristic:^(CBPeripheralManager *peripheral, CBCentral *central, CBCharacteristic *characteristic) {
        NSLog(@"订阅了 %@的数据",characteristic.UUID);
        //每秒执行一次给主设备发送一个当前时间的秒数
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendData:) userInfo:characteristic  repeats:YES];
    }];
    
    //设置添加service委托 | set didAddService block
    [baby peripheralModelBlockOnDidUnSubscribeToCharacteristic:^(CBPeripheralManager *peripheral, CBCentral *central, CBCharacteristic *characteristic) {
        NSLog(@"peripheralManagerIsReadyToUpdateSubscribers");
        [timer fireDate];
    }];
    
    
    
    
    
    
}



#pragma mark -------------语音识别代理

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    
    self.resultStr = @"";
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    NSLog(@"dic -> %@",dic);
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    // 字符串转化为字典
    NSString *requestTmp = [NSString stringWithString: resultString];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];  //解析
    
    // 处理结果字典，获取所需数据：
    NSMutableArray * tmpArr = [[NSMutableArray alloc] init];
    NSArray * muArr = [resultDic objectForKey:@"ws"];
    for(int i = 0; i<muArr.count; i++){
        NSString * str = [[[[muArr objectAtIndex:i] objectForKey:@"cw"] objectAtIndex:0] objectForKey:@"w"];
        NSLog(@"str -> %@",str);
        [tmpArr addObject:str];
        // resultStr = [resultStr stringByAppendingFormat:@"%@",str];
    }
    for (NSString  * str  in tmpArr){
        self.resultStr =  [self.resultStr  stringByAppendingFormat:@"%@",str];
    }
    
    //    if(self.resultStr){
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您说的内容：" message:self.resultStr  preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    //        [alertController addAction:okAction];
    //        [self presentViewController:alertController animated:YES completion:nil];
    //    }
    NSLog(@"resultStr -> %@",self.resultStr );
    
    [self dealResultStringWithString:self.resultStr];
}
//识别会话结束返回代理
- (void)onError: (IFlySpeechError *) error{
    NSString * str = [NSString stringWithFormat:@"%@",error.errorDesc];
    NSLog(@"str ->%@",str);
}
//停止录音回调
- (void) onEndOfSpeech{
    
}

//开始录音回调
- (void) onBeginOfSpeech{
    // NSLog(@"开始识别");
}

// 处理语音结果
- (void)dealResultStringWithString:(NSString *)str{
    // 发送蓝牙前进指令
    // 0xAA 0x12 0x00 0xFC
    if([str isEqualToString:@"前进"]){
        
        service = nil;
        //0xAA 0x12 0x00 0xFC
        //配置第一个服务s1
        service = makeCBService(@"0xAA");
        //配置s1的3个characteristic
        // makeCharacteristicToService(service, @"FFF1", @"0x00", @"0xFC");//读
        makeCharacteristicToService(service, @"0x12", @"0x00", @"0xFC");//写
        //实例化baby
        //baby = [BabyBluetooth shareBabyBluetooth];
        //配置委托
        [self babyDelegate];
        
        //添加服务和启动外设
        baby.bePeripheral().addServices(@[service]).startAdvertising();
        
    }else if([str isEqualToString:@"后退"]){
        
        service = nil;
        // 0xAA 0x23 0x15 0xFC
        //配置第一个服务s1
        service = makeCBService(@"0xAA");
        //配置s1的3个characteristic
        // makeCharacteristicToService(service, @"FFF1", @"0x00", @"0xFC");//读
        makeCharacteristicToService(service, @"0x23", @"0x15", @"0xFC");//写
        //实例化baby
        //baby = [BabyBluetooth shareBabyBluetooth];
        //配置委托
        [self babyDelegate];
        
        //添加服务和启动外设
        baby.bePeripheral().addServices(@[service]).startAdvertising();
        
    }else if([str isEqualToString:@"左转"]){
        
        
    }else if([str isEqualToString:@"右转"]){
        
        
    }else{
        // 非机器人命令，不作处理，做出异常提示即可
        if(self.resultStr){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请您输入正确的命令"  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}


//发送数据，发送当前时间的秒数
-(BOOL)sendData:(NSTimer *)t {
    CBMutableCharacteristic *characteristic = t.userInfo;
    NSDateFormatter *dft = [[NSDateFormatter alloc]init];
    [dft setDateFormat:@"ss"];
    //    NSLog(@"%@",[dft stringFromDate:[NSDate date]]);
    //执行回应Central通知数据
    return  [baby.peripheralManager updateValue:[[dft stringFromDate:[NSDate date]] dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:(CBMutableCharacteristic *)characteristic onSubscribedCentrals:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
