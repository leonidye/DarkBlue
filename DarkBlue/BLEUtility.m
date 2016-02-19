/*
 *  bleUtility.m
 *
 * Created by Ole Andreas Torvmark on 10/2/12.
 * Copyright (c) 2012 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 */

#import "BLEUtility.h"
#import "BTServer.h"

@implementation BLEUtility

///==========================================================================================
///------------------------------ write methods ---------------------------------------------
+(void)writeCharacteristic: (CBPeripheral *)peripheral
                     sUUID: (NSString *)sUUID
                     cUUID: (NSString *)cUUID
                      data: (NSData *)data
{
    // Sends data to BLE peripheral to process HID and send EHIF command to PC
    for ( CBService *service in peripheral.services )
    {
        if ([service.UUID isEqual: [CBUUID UUIDWithString: sUUID]])
        {
            for ( CBCharacteristic *characteristic in service.characteristics )
            {
                if ([characteristic.UUID isEqual: [CBUUID UUIDWithString: cUUID]])
                {
                    /* EVERYTHING IS FOUND, WRITE characteristic ! */
                    [peripheral writeValue: data
                         forCharacteristic: characteristic
                                      type: CBCharacteristicWriteWithResponse];
                    
                }
            }
        }
    }
}

+(void)writeCharacteristic:(CBPeripheral *)peripheral
                   sCBUUID:(CBUUID *)sCBUUID
                   cCBUUID:(CBUUID *)cCBUUID
                      data:(NSData *)data
{
    // Sends data to BLE peripheral to process HID and send EHIF command to PC
    for ( CBService *service in peripheral.services )
    {
        if ([service.UUID isEqual:sCBUUID])
        {
            for ( CBCharacteristic *characteristic in service.characteristics )
            {
                if ([characteristic.UUID isEqual: cCBUUID])
                {
                    /* EVERYTHING IS FOUND, WRITE characteristic ! */
                    [peripheral writeValue: data
                         forCharacteristic: characteristic
                                      type: CBCharacteristicWriteWithResponse];
                    
                }
            }
        }
    }
}
//---------------------------------------------------------------------------------------

///==========================================================================================
//------------------------------ read methods -----------------------------------------------
+(void)readCharacteristic: (CBPeripheral *)peripheral
                    sUUID: (NSString *)sUUID
                    cUUID: (NSString *)cUUID
{
    for ( CBService *service in peripheral.services )
    {
        if([service.UUID isEqual: [CBUUID UUIDWithString: sUUID]])
        {
            for ( CBCharacteristic *characteristic in service.characteristics )
            {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString: cUUID]])
                {
                    /* Everything is found, read characteristic ! */
                    [peripheral readValueForCharacteristic: characteristic];
                }
            }
        }
    }
}

+(void)readCharacteristic: (CBPeripheral *)peripheral
                  sCBUUID: (CBUUID *)sCBUUID
                  cCBUUID: (CBUUID *)cCBUUID
{
    for ( CBService *service in peripheral.services )
    {
        if([service.UUID isEqual: sCBUUID])
        {
            for ( CBCharacteristic *characteristic in service.characteristics )
            {
                if ([characteristic.UUID isEqual:cCBUUID])
                {
                    /* Everything is found, read characteristic ! */
                    [peripheral readValueForCharacteristic:characteristic];
                }
            }
        }
    }
}
//------------------------------------------------------------------------------


///=============================================================================
//------------------------------ notification methods --------------------------
+(void)setNotificationForCharacteristic: (CBPeripheral *)peripheral
                                  sUUID: (NSString *)sUUID
                                  cUUID: (NSString *)cUUID
                                 enable: (BOOL)enable
{
    for ( CBService *service in peripheral.services )
    {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]])
        {
            for (CBCharacteristic *characteristic in service.characteristics )
            {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]])
                {
                    /* Everything is found, set notification ! */
                    [peripheral setNotifyValue: enable
                             forCharacteristic: characteristic];
                }
            }
        }
    }
}

+(void)setNotificationForCharacteristic: (CBPeripheral *)peripheral
                                sCBUUID: (CBUUID *)sCBUUID
                                cCBUUID: (CBUUID *)cCBUUID
                                 enable: (BOOL)enable
{
    for ( CBService *service in peripheral.services )
    {
        if ([service.UUID isEqual:sCBUUID])
        {
            for (CBCharacteristic *characteristic in service.characteristics )
            {
                if ([characteristic.UUID isEqual:cCBUUID])
                {
                    /* Everything is found, set notification ! */
                    [peripheral setNotifyValue:enable forCharacteristic:characteristic];
                    
                }
            }
        }
    }
}

+(bool) isCharacteristicNotifiable:(CBPeripheral *)peripheral
                           sCBUUID:(CBUUID *)sCBUUID
                           cCBUUID:(CBUUID *)cCBUUID
{
    bool retVal = NO;
    
    for ( CBService *service in peripheral.services )
    {
        if ([service.UUID isEqual: sCBUUID])
        {
            for (CBCharacteristic *characteristic in service.characteristics )
            {
                if ([characteristic.UUID isEqual: cCBUUID])
                {
                    if (characteristic.properties & CBCharacteristicPropertyNotify)
                    {
                        retVal = YES;
                    }
                }
            }
        }
    }
    return retVal;
}
//------------------------------------------------------------------------------

/// Function to expand a TI 16-bit UUID to TI 128-bit UUID
+(CBUUID *) expandToTIUUID:(CBUUID *)sourceUUID
{
    #define NUM_EXPAND_UUID_BYTES   16
    #define NUM_SOURCE_UUID_BYTES   2
    
    CBUUID *expandedUUID = [CBUUID UUIDWithString:TI_BASE_LONG_UUID];
    
    unsigned char expandedUUIDBytes[NUM_EXPAND_UUID_BYTES];
    unsigned char sourceUUIDBytes[NUM_SOURCE_UUID_BYTES];
 
      // getBytes was deprecated in iOS8
//    [expandedUUID.data getBytes:expandedUUIDBytes];
//    [sourceUUID.data getBytes:sourceUUIDBytes];
    
    [expandedUUID.data getBytes:expandedUUIDBytes length:sizeof(expandedUUIDBytes)];
    [sourceUUID.data getBytes:sourceUUIDBytes length:sizeof(sourceUUIDBytes)];
    
    expandedUUIDBytes[2] = sourceUUIDBytes[0];
    expandedUUIDBytes[3] = sourceUUIDBytes[1];
    expandedUUID = [CBUUID UUIDWithData:[NSData dataWithBytes: expandedUUIDBytes length: 16]];
    return expandedUUID;
}

/// Function to convert an CBUUID to NSString
+(NSString *) CBUUIDToString:(CBUUID *)inUUID
{
    unsigned char i[16];
    
    // getBytes was deprecated in iOS8
//  [inUUID.data getBytes:i];
    [inUUID.data getBytes:i length:(sizeof(i))];
    
    if (inUUID.data.length == 2)
    {
        return [NSString stringWithFormat:@"%02hhx%02hhx",i[0],i[1]];
    }
    else
    {
        uint32_t g1 = ( (i[0] << 24) | (i[1] << 16) | (i[2] << 8) | i[3] );
        uint16_t g2 = ((i[4] << 8) | (i[5]));
        uint16_t g3 = ((i[6] << 8) | (i[7]));
        uint16_t g4 = ((i[8] << 8) | (i[9]));
        uint16_t g5 = ((i[10] << 8) | (i[11]));
        uint32_t g6 = ((i[12] << 24) | (i[13] << 16) | (i[14] << 8) | i[15]);
        
        return [NSString stringWithFormat:@"%08x-%04hx-%04hx-%04hx-%04hx%08x",g1,g2,g3,g4,g5,g6];
    }
    return nil;
}
  
@end
