//
//  BTServer.h
//  DarkBlue
//
//  Created by chenee on 14-3-26.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PeriperalInfo.h"

#define UUIDPrimaryService   @"0xFF00"
#define UUIDPrimaryService2  @"0xFFA0"
//#define UUIDDeviceInfo       @"0xFF01"
//#define UUIDRealTimeDate     @"0xFF02"
//#define UUIDControlPoint     @"0xFF03"
//#define UUIDData             @"0xFF04"
//#define UUIDFirmwareData     @"0xFF05"
//#define UUIDDebugData        @"0xFF06"
//#define UUIDBLEUserInfo      @"0xFF07"

#define AUTO_CANCEL_CONNECT_TIMEOUT 10

typedef void (^eventBlock)(CBPeripheral *peripheral,
                                   BOOL status,
                                NSError *error);

typedef enum
{
    IDLE = 0,
    KING = 1,
    KSUCCESS = 2,
    KFAILED = 3,
}myStatus;

@protocol BTServerDelegate

@optional
-(void)didStopScan;
-(void)didFoundPeripheral;
-(void)didReadvalue;
-(void)didWritevalue;

-(void)errorWritingValue;

-(void)pvcUpdateTable;
-(void)svcUpdateTable;

@required
-(void)didDisconnect;

@end

@interface BTServer : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>
+(BTServer*)defaultBTServer;
@property(weak, nonatomic) id<BTServerDelegate> delegate;

//
@property (strong,nonatomic)NSMutableArray *discoveredPeripherals;
@property (strong,nonatomic)CBPeripheral* selectPeripheral;
@property (strong,nonatomic)CBService* discoveredSevice;
@property (strong,nonatomic)CBCharacteristic *selectCharacteristic;

//
-(void)startScan;
-(void)startScan: (NSInteger)forLastTime;
-(void)stopScan;
-(void)stopScan: (BOOL)withOutEvent;
-(void)connect: (PeriperalInfo *) peripheralInfo
  withFinishCB: (eventBlock) callback;
-(void)disConnect;
-(void)discoverService: (CBService*)service;

-(void)readValue: (CBCharacteristic*)characteristic
             idx: (long)idx;

-(NSString*)getPropertiesString: (CBCharacteristicProperties)properties;

//state
-(NSInteger)getScanState;
-(NSInteger)getDiscoveryState;
-(NSInteger)getConnectState;
-(NSInteger)getServiceState;
-(NSInteger)getCharacteristicState;

-(long) getIdx;

@end
