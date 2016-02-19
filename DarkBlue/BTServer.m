//
//  BTServer.m
//  DarkBlue
//
//  Created by chenee on 14-3-26.
//  Copyright (c) 2014年 chenee. All rights reserved.
//
// Modified by Leonid Yerukhimov

#import "BTServer.h"

@interface BTServer()


@end


@implementation BTServer
{
    BOOL inited;
    CBCentralManager *myCentralManager;
    
    //state
    NSInteger scanState;
    NSInteger discoveryState;
    NSInteger connectState;
    NSInteger serviceState;
    NSInteger characteristicState;
    NSInteger readState;
    NSInteger writeState;
    
    long readIdx;

    eventBlock connectBlock;
}

static BTServer* _defaultBTServer = nil;

-(NSInteger)getScanState
{
    return scanState;
}

-(NSInteger)getDiscoveryState
{
    return discoveryState;
}

-(NSInteger)getConnectState
{
    return connectState;
}
-(NSInteger)getServiceState
{
    return serviceState;
}
-(NSInteger)getCharacteristicState
{
    return characteristicState;
}
-(NSInteger)getReadState
{
    return readState;
}

-(long) getIdx
{
    return readIdx;
}


-(NSString*)getPropertiesString: (CBCharacteristicProperties)properties
{
    // number of invocations is equal to the number of rows in [ visible] UITableView
    // each row calls this method once
    NSMutableString *s = [[NSMutableString alloc]init];
    
    [s appendString:@""];
    
    if ((properties & CBCharacteristicPropertyBroadcast) == CBCharacteristicPropertyBroadcast)
    {
        [s appendString:@" Broadcast"];
    }
    if ((properties & CBCharacteristicPropertyRead) == CBCharacteristicPropertyRead)
    {
        [s appendString:@" Read"];
    }
    if ((properties & CBCharacteristicPropertyWriteWithoutResponse) == CBCharacteristicPropertyWriteWithoutResponse)
    {
        [s appendString:@" WriteWithoutResponse"];
    }
    if ((properties & CBCharacteristicPropertyWrite) == CBCharacteristicPropertyWrite)
    {
        [s appendString:@" Write"];
    }
    if ((properties & CBCharacteristicPropertyNotify) == CBCharacteristicPropertyNotify)
    {
        [s appendString:@" Notify"];
    }
    if ((properties & CBCharacteristicPropertyIndicate) == CBCharacteristicPropertyIndicate)
    {
        [s appendString:@" Indicate"];
    }
    if ((properties & CBCharacteristicPropertyAuthenticatedSignedWrites) == CBCharacteristicPropertyAuthenticatedSignedWrites)
    {
        [s appendString:@" AuthenticatedSignedWrites"];
    }
    if ((properties & CBCharacteristicPropertyExtendedProperties) == CBCharacteristicPropertyExtendedProperties)
    {
        [s appendString:@" ExtendedProperties"];
    }
    if ((properties & CBCharacteristicPropertyNotifyEncryptionRequired) == CBCharacteristicPropertyNotifyEncryptionRequired)
    {
        [s appendString:@" NotifyEncryptionRequired"];
    }
    if ((properties & CBCharacteristicPropertyIndicateEncryptionRequired) == CBCharacteristicPropertyIndicateEncryptionRequired)
    {
        [s appendString:@" IndicateEncryptionRequired"];
    }
    
    if ([s length] < 2)
    {
        [s appendString: @"BTS char property is unknown"];
    }
    
    NSLog(@"BTS Char's Property:%@", s);
    return s;
}


+(BTServer*)defaultBTServer
{
    if (nil == _defaultBTServer)
    {
        _defaultBTServer = [[BTServer alloc]init];
        
        [_defaultBTServer initBLE];
    }
    
    return _defaultBTServer;
}

-(void)initBLE
{
    if (inited)
    {
        return;
    }
    inited = TRUE;
    self.delegate = nil;
    self.discoveredPeripherals = [NSMutableArray array];
    self.selectPeripheral = nil;
    connectState = IDLE;
    connectBlock = nil;
    
    discoveryState = IDLE;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerOptionShowPowerAlertKey, @"zStrapRestoreIdentifier",CBCentralManagerOptionRestoreIdentifierKey,nil];

    myCentralManager = [[CBCentralManager alloc]
                           initWithDelegate:self
                           queue:dispatch_queue_create("com.myBLEQueue", NULL)
                           options:options]; // TODO: options
    
    NSLog(@"init bt server ........");

}
-(void)finishBLE
{
    //??
}

#pragma mark -- APIs
-(void)startScan
{
    [self startScan:10];
}

-(void)startScan: (NSInteger)forLastTime
{
    [self.discoveredPeripherals removeAllObjects];
    scanState = KING;
    
    discoveryState = KING;
    
    NSArray *atmp = [NSArray arrayWithObjects: [CBUUID UUIDWithString: UUIDPrimaryService],
                       [CBUUID UUIDWithString: UUIDPrimaryService2],
                       nil];
    NSArray *retrivedArray = [myCentralManager retrieveConnectedPeripheralsWithServices: atmp];
    NSLog(@"BTServer retrived scan Array:\n%@", retrivedArray);

    for (CBPeripheral* peripheral in retrivedArray)
    {
        [self addPeripheral:peripheral advertisementData:nil  RSSI:nil];
    }

    [myCentralManager scanForPeripheralsWithServices:nil options:nil];
    
    if (forLastTime > 0)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget: self
                                                 selector: @selector(stopScan)
                                                   object: nil];
        [self performSelector: @selector(stopScan)
                   withObject: nil
                   afterDelay: forLastTime];
    }
}

-(void)stopScan:(BOOL)withOutEvent
{

    if (scanState != KING)
    {
        return;
    }
    
    NSLog(@"BTServer stops scan");

    scanState = KSUCCESS;
    [myCentralManager stopScan];
    
    if(withOutEvent)
        return;
    
    if (self.delegate)
    {
        if([(id)self.delegate respondsToSelector:@selector(didStopScan)])
        {
            [self.delegate didStopScan];
        }
    }
}
-(void)stopScan
{
    [self stopScan:FALSE];
}

-(void)cancelConnect
{
    if (myCentralManager && self.selectPeripheral)
    {
        if(self.selectPeripheral.state == CBPeripheralStateConnecting)
        {
            NSLog(@"BTServer: timeout cancel connect to peripheral:%@", self.selectPeripheral.name);

            [myCentralManager cancelPeripheralConnection:self.selectPeripheral];
            connectState = IDLE;
        }
    }
}
-(void)connect:(PeriperalInfo *)peripheralInfo
{
    NSLog(@"BTServer: connecting to peripheral:%@ ...", peripheralInfo.peripheral.name);
    
    [myCentralManager connectPeripheral: peripheralInfo.peripheral
                                options: @{
                                                CBConnectPeripheralOptionNotifyOnConnectionKey: @YES,
                                             CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES,
                                              CBConnectPeripheralOptionNotifyOnNotificationKey: @YES
                                          }
    ];

    self.selectPeripheral = peripheralInfo.peripheral;
    connectState = KING;

    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(cancelConnect)
                                               object:nil];
    [self performSelector: @selector(stopScan)
               withObject: nil
               afterDelay: AUTO_CANCEL_CONNECT_TIMEOUT];
}

-(void)connect: (PeriperalInfo *)peripheralInfo
  withFinishCB: (eventBlock)callback
{
    [self connect: peripheralInfo];
    connectBlock = callback;
}
-(void)disConnect
{
    if(myCentralManager && self.selectPeripheral)
    {
        [myCentralManager cancelPeripheralConnection: self.selectPeripheral];
    }
}
-(void)discoverService: (CBService*)service
{
    if(self.selectPeripheral)
    {
        characteristicState = KING;
        self.discoveredSevice = service;
        [self.selectPeripheral discoverCharacteristics: nil
                                            forService: service];
        NSLog(@"BTServer: discoverCharacteristics for selectPeripheral ...");
    }

}

-(void)readValue: (CBCharacteristic*)characteristic
             idx: (long)idx
{
    if (readState == KING)
    {
        NSLog(@"BTServer: should wait read over");
        return;
    }
    
    if (characteristic != nil)
    {
        self.selectCharacteristic = characteristic;
        readIdx = idx;
    }
    readState = KING;
    [self.selectPeripheral readValueForCharacteristic: self.selectCharacteristic];
}

#pragma mark CBCentralManagerDelegate
-(void)addPeripheralInfo: (PeriperalInfo *)peripheralInfo
{
    for(int i = 0; i < self.discoveredPeripherals.count; i++)
    {
        PeriperalInfo *pi = self.discoveredPeripherals[i];
        
        if([peripheralInfo.uuid isEqualToString: pi.uuid])
        {
            [self.discoveredPeripherals replaceObjectAtIndex:i withObject:peripheralInfo];
            return;
        }
    }
    
    [self.discoveredPeripherals addObject: peripheralInfo];
    
    if (self.delegate)
    {
        if([(id)self.delegate respondsToSelector:@selector(didFoundPeripheral)])
        {
            [self.delegate didFoundPeripheral];
            
            discoveryState = KSUCCESS;
        }
    }
}
-(void)addPeripheral: (CBPeripheral*)peripheral
   advertisementData: (NSDictionary*)advertisementData
                RSSI: (NSNumber*)RSSI
{
    PeriperalInfo *pi = [[PeriperalInfo alloc]init];
    
    pi.peripheral = peripheral;
    pi.uuid = [peripheral.identifier UUIDString];
    pi.name = peripheral.name;
    
    switch (peripheral.state)
    {
        case CBPeripheralStateDisconnected:
            pi.state = @"disConnected";
            break;
            
        case CBPeripheralStateConnecting:
            pi.state = @"connecting";
            break;
            
        case CBPeripheralStateConnected:
            pi.state = @"connected";
            break;
            
        default:
            break;
    }
    
    if (advertisementData)
    {
        pi.localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
        NSArray *array = [advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey];
        pi.serviceUUIDS = [array componentsJoinedByString:@"; "];
        
        // ----- L.Y.
        pi.manufactureData = [advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
        // ---------
    }
    
    if (RSSI)
    {
        pi.RSSI = RSSI;
    }
    
    [self addPeripheralInfo: pi];
}

-   (void)centralManager: (CBCentralManager *)central
   didDiscoverPeripheral: (CBPeripheral *)peripheral
       advertisementData: (NSDictionary *)advertisementData
                    RSSI: (NSNumber *)RSSI
{
    NSLog(@"BTServer didDiscoverPeripheral: %@; RSSI: %@", peripheral.name, RSSI);
    
    [self addPeripheral: peripheral
      advertisementData: advertisementData
                   RSSI: RSSI];

    
}
- (void)centralManager: (CBCentralManager *)central
  didConnectPeripheral: (CBPeripheral *)peripheral
{
    NSLog(@"BTServer didConnectPeripheral: %@",peripheral.name);

    connectState = KSUCCESS;
    if (connectBlock)
    {
        connectBlock(peripheral,true,nil);
        connectBlock = nil;
    }
    
    self.selectPeripheral = peripheral;
    self.selectPeripheral.delegate = self;
    serviceState = KING;
    [self.selectPeripheral discoverServices:nil];
    
    NSLog(@"BTServer will discoverServices for '%@' peripheral ...",peripheral.name);
   //  [ProgressHUD dismiss];
}

- (void)centralManager: (CBCentralManager *)central
didDisconnectPeripheral: (CBPeripheral *)peripheral
                 error: (NSError *)error
{
    NSLog(@"BTServer didDisconnectedPeripheral: %@",peripheral.name);

    connectState = KFAILED;
    if (connectBlock)
    {
        connectBlock(peripheral,false,nil);
        connectBlock = nil;
    }

    if (self.delegate)
    {
        if([(id)self.delegate respondsToSelector: @selector(didDisconnect)])
        {
            [self.delegate didDisconnect]; // delegates a message to a root UIViewController
            
            NSLog(@"BTServer didDisconnectPeripheral");
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"BTServer DidFailToConnectPeripheral .....");
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"BTServer retrive connected peripheral %@", peripherals);
}

- (void)centralManager: (CBCentralManager *)central
didRetrievePeripherals: (NSArray *)peripherals
{
    NSLog(@"BTServer retrive %@", peripherals);

}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff)
    {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
    }
    else if ([central state] == CBCentralManagerStateUnauthorized)
    {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown)
    {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported)
    {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }

}

- (void)centralManager:(CBCentralManager *)central
      willRestoreState:(NSDictionary *)dict
{
    NSLog(@"BTServer willRestoreState ....");
}


#pragma mark CBPeripheralDelegate

-    (void)peripheral: (CBPeripheral *)peripheral
  didDiscoverServices: (NSError *)error
{
    if (nil == error)
    {
        serviceState = KSUCCESS;
        NSLog(@"BTServer didDiscoverServices:\n%@ for peripheral '%@'", peripheral.services, peripheral.name);
        
        if (self.delegate)
        {
            if([(id)self.delegate respondsToSelector: @selector(pvcUpdateTable)])
            {
                [self.delegate pvcUpdateTable];
            }
        }
    }
    else
    {
        serviceState = KFAILED;
        NSLog(@"BTServer didFailDiscoverServices:%@ for peripheral '%@'", error, peripheral.name);
    }
}

-                      (void)peripheral: (CBPeripheral *)peripheral
  didDiscoverIncludedServicesForService: (CBService *)service
                                  error: (NSError *)error
{
    NSLog(@"BTServer didDiscoverIncludedServicesForService: %@", error);
}

-                     (void)peripheral: (CBPeripheral *)peripheral
  didDiscoverCharacteristicsForService: (CBService *)service
                                 error: (NSError *)error
{
    if (nil == error)
    {
        characteristicState = KSUCCESS;
        self.discoveredSevice = service;
        
        if (self.delegate)
        {
            if([(id)self.delegate respondsToSelector: @selector(svcUpdateTable)])
            {
                [self.delegate svcUpdateTable];
            }
        }
        
        NSLog(@"BTServer didDiscoverCharacteristicsForService: %@",error);
    }
    else
    {
        characteristicState = KFAILED;
        self.discoveredSevice = nil;
        NSLog(@"BTServer discover characteristic failed:%@",error);
    }
    
}

-                         (void)peripheral: (CBPeripheral *)peripheral
   didDiscoverDescriptorsForCharacteristic: (CBCharacteristic *)characteristic
                                     error: (NSError *)error
{
        NSLog(@"BTServer didDiscoverDescriptorsForCharacteristic: %@ with error %@", characteristic.UUID, error);
}

-                 (void)peripheral: (CBPeripheral *)peripheral
   didUpdateValueForCharacteristic: (CBCharacteristic *)characteristic
                             error: (NSError *)error
{
    if (error)
    {
        readState = KFAILED;
        NSLog(@"BTServer Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    readState = KSUCCESS;
    self.selectCharacteristic = characteristic;
    
    if ( self.delegate && [ (id)self.delegate respondsToSelector: @selector(didReadvalue) ] )
    {
        [self.delegate didReadvalue];
    }

    NSLog(@"BTServer didUpdateValueForCharacteristic: %@", characteristic.UUID);
}

-          (void)peripheral: (CBPeripheral *)peripheral
didUpdateValueForDescriptor: (CBDescriptor *)descriptor
                      error: (NSError *)error
{
    NSLog(@"BTServer didUpdateValueForDescriptor: %@", descriptor.UUID);
}

-             (void)peripheral: (CBPeripheral *)peripheral
didWriteValueForCharacteristic: (CBCharacteristic *)characteristic
                         error: (NSError *)error
{
    if (error)
    {
        NSLog(@"BTServer Error writing characteristic value: %@",
              [error localizedDescription]);
        
        // [ProgressHUD showError: @"The value's length is invalid"];  // [error localizedDescription]];
        [self.delegate errorWritingValue];
    }
    else
    {
        NSLog(@"BTServer didWriteValueForCharacteristic: %@", characteristic.UUID);
        
       [self.delegate didWritevalue];
    }
}

-           (void)peripheral: (CBPeripheral *)peripheral
  didWriteValueForDescriptor: (CBDescriptor *)descriptor
                       error: (NSError *)error
{
        NSLog(@"BTServer didWriteValueForDescriptor: %@", descriptor.UUID);
}

-                            (void)peripheral: (CBPeripheral *)peripheral
  didUpdateNotificationStateForCharacteristic: (CBCharacteristic *)characteristic
                                        error: (NSError *)error
{
    if (error)
    {
        NSLog(@"BTServer Error updating notification state: %@", [error localizedDescription]);
    }
    else
    {
        NSLog(@"BTServer didUpdateNotificationStateForCharacteristic: %@", characteristic.UUID);
    }
}

- (void)peripheralDidUpdateRSSI: (CBPeripheral *)peripheral
                          error: (NSError *)error
{
    if (error != nil)
    {
        NSLog(@"Error updating RSSI. Error = %@", [error localizedDescription]);
    }
    else
    {
        NSLog(@"BTServer peripheralDidUpdateRSSI for: '%@'"  , peripheral.name);
    }
}

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
        NSLog(@"BTServer peripheralDidUpdateName for: '%@'"  , peripheral.name);
}

-  (void)peripheral: (CBPeripheral *)peripheral
  didModifyServices: (NSArray *)invalidatedServices
{
        NSLog(@"BTServer didModifyServices for: '%@' peripheral"  , peripheral.name);
}

@end
