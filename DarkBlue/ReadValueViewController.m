//
//  ReadValueViewController.m
//  DarkBlue
//
//  Created by chenee on 14-3-27.
//  Copyright (c) 2014年 chenee. All rights reserved.
//
//  Modified by Leonid Yerukhimov

#import "ReadValueViewController.h"
#import "BTServer.h"
#import "utils.h"

#import "bleServices.h"

#import "BLEUtility.h"

@interface ReadValueViewController ()<BTServerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbPeripheral;
@property (weak, nonatomic) IBOutlet UILabel *lbService;
@property (weak, nonatomic) IBOutlet UILabel *lbCharacteristic;
@property (weak, nonatomic) IBOutlet UILabel *lbDataType;
@property (weak, nonatomic) IBOutlet UILabel *lbASCII;
@property (weak, nonatomic) IBOutlet UILabel *lbHex;
@property (weak, nonatomic) IBOutlet UILabel *lbDecimal;

@property (weak, nonatomic) IBOutlet UIButton *btnRead;
@property (weak, nonatomic) IBOutlet UIButton *btnWrite;
@property (weak, nonatomic) IBOutlet UIButton *btnNotify;

@property (strong,nonatomic) BTServer *defaultBTServer;

@end

@implementation ReadValueViewController
{
    BOOL readState;
    BOOL writeState;
    bool notifState;
}

- (id)initWithNibName: (NSString *)nibNameOrNil
               bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    NSLog(@"RVVC didLoad");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"RVVC willAppear");
    
    self.defaultBTServer = [BTServer defaultBTServer];
    self.defaultBTServer.delegate = (id)self;
    self.lbPeripheral.text = self.defaultBTServer.selectPeripheral.name;
    
    [self getCharValue];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"RVVC viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"RVVC viewWillDisappear");
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"RVVC viewDidlDisappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"RVVC didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

-(void) willRotateToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
                                duration: (NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        NSLog(@"Landscape left");
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"Landscape right");
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        NSLog(@"Portrait");
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"Upside down");
    }
}
//---------------------------------------------------------------
     
-(void) getCharValue
{
    CBCharacteristic* ch;
    NSString *srvStr = [self.defaultBTServer.discoveredSevice.UUID UUIDString];
    NSString *selCharStr = [self.defaultBTServer.selectCharacteristic.UUID UUIDString];
    
    if ( [ srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BATTERY_SERVICE ] ] )
    {
        self.lbService.text = @"Battery";
       
        if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BATTERY_LEVEL_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Level";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BATTERY_LEVEL_STATE_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Level State";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BATTERY_POWER_STATE_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Power State";
        }
    }
    
    else if ( [ srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SIMPLE_KEYS_SERVICE] ] )
    {
        self.lbService.text = @"Simple Keys";
        
        if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SIMPLE_KEY_PRESS_STATE_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Press State";
        }
    }
    else if ( [ srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_TX_POWER_SERVICE] ] )
    {
        self.lbService.text = @"Tx Power";
        
        if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_TX_POWER_LEVEL_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Level";
        }
    }
    
    else if ( [ srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_IMMEDIATE_ALERT_SERVICE ] ] )
    {
        self.lbService.text = @"Immediate Alert";
        
        if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_ALERT_LEVEL_CHAR] ] )
        {
            self.lbCharacteristic.text = @"IA Level";
        }
    }
    
    else if ( [srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_LINK_LOSS_SERVICE]] )
    {
        self.lbService.text = @"Link Loss";
        if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_ALERT_LEVEL_CHAR] ] )
        {
            self.lbCharacteristic.text = @"LL Level";
        }
    }
    else if ( [ srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_DEVICE_INFORMATION_SERVICE] ] )
    {
        self.lbService.text = @"Device Information";
        
        // unsigned long n = [self.defaultBTServer.discoveredSevice.characteristics count];
        {
            if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SYSTEM_ID_CHAR] ] )
            {
                self.lbCharacteristic.text = @"System ID String";
            }
            else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_MODEL_NUMBER_STRING_CHAR] ] )
            {
                self.lbCharacteristic.text = @"Model Number String";
            }
            else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SERIAL_NUMBER_STRING_CHAR] ] )
            {
                self.lbCharacteristic.text = @"Serial Number String";
            }
            else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_FIRMWARE_REVISION_STRING_CHAR] ] )
            {
                self.lbCharacteristic.text = @"Firmware Revision String";
            }
            else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_HARDWARE_REVISION_STRING_CHAR] ] )
            {
                self.lbCharacteristic.text = @"Hardware Revision String";
            }
            else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SOFTWARE_REVISION_STRING_CHAR] ] )
            {
                self.lbCharacteristic.text = @"Software Revision String";
            }
            else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_MANUFACTURER_NAME_STRING_CHAR] ] )
            {
                self.lbCharacteristic.text = @"Manufacturer Name String";
            }
            else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_IEEE_REGULATORY_CERTIFICATION_DATA_LIST_CHAR] ] )
            {
//                self.lbCharacteristic.text = @"IEEE Certification String";
                self.lbCharacteristic.text = @"Regulatory Certification Data List";
            }
            else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_PNP_ID_CHAR] ] )
            {
                self.lbCharacteristic.text = @"PnP ID";
            }
        }
    }
    
    else if ([srvStr isEqualToString: BLE_UUID_ITORQ_SERVICE_LONG])
    {
        self.lbService.text = @"Intelitorq";
        
        if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BATTERY_LEVEL_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Battery Level";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CALIBRATION_CMD_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Calibration Cmd";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_YELLOW_LED_SET_POINT_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Yellow LED Set Point";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_RED_LED_SET_POINT_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Red LED Set Point";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SHAKER_SET_POINT_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Shaker Set Point";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_EVENT_COUNTER_THRESHOLD_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Event Counter Threshold";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_EVENT_COUNTER_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Event Counter";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_PGW_FW_REVISION_CHAR] ] )
        {
            self.lbCharacteristic.text = @"PGW FW Rev";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_INITIATE_FW_UPDATE_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Initiate FW Update";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CURRENT_TORQUE_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Torque Value";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BUZZER_SET_POINT_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Buzzer Set Point";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_DIRECTION_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Direction";
        }
    }
    else if ( [ srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SIMPLE_BLE_PERIPHERAL_SERVICE] ] )
    {
        self.lbService.text = @"Simple BLE Peripheral";
        
        if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CHAR_1_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Characteristic_1";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CHAR_2_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Characteristic_2";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CHAR_3_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Characteristic_3";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CHAR_4_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Characteristic_4";
        }
        else if ( [selCharStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CHAR_5_CHAR] ] )
        {
            self.lbCharacteristic.text = @"Characteristic_5";
        }
    }
    else if ([srvStr isEqualToString: BLE_UUID_IR_TEMP_SENSOR_SERVICE_LONG])
    {
        self.lbService.text = @"IR Temperature Sensor";
        
        if ( [selCharStr isEqualToString: BLE_UUID_IR_TEMP_SENSOR_DATA_CHAR_LONG] )
        {
            self.lbCharacteristic.text = @"Data";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_IR_TEMP_SENSOR_CONFIG_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Configuration";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_IR_TEMP_SENSOR_PERIOD_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Update Period";
        }
    }
    else if ([srvStr isEqualToString: BLE_UUID_ACCELEROMETER_SERVICE_LONG])
    {
        self.lbService.text = @"Accelerometer";
        
        if ( [selCharStr isEqualToString: BLE_UUID_ACCELEROMETER_DATA_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Data";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_ACCELEROMETER_CONFIG_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Configuration";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_ACCELEROMETER_PERIOD_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Update Period";
        }
    }
    else if ([srvStr isEqualToString: BLE_UUID_HUMIDITY_SENSOR_SERVICE_LONG])
    {
        self.lbService.text = @"Humidity";
        
        if ( [selCharStr isEqualToString: BLE_UUID_HUMIDITY_SENSOR_DATA_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Data";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_HUMIDITY_SENSOR_CONFIG_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Configuration";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_HUMIDITY_SENSOR_PERIOD_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Update Period";
        }
    }
    else if ([srvStr isEqualToString: BLE_UUID_MAGNETOMETER_SERVICE_LONG])
    {
        self.lbService.text = @"Magnetometer";
        
        if ( [selCharStr isEqualToString: BLE_UUID_MAGNETOMETER_DATA_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Data";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_MAGNETOMETER_CONFIG_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Configuration";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_MAGNETOMETER_PERIOD_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Update Period";
        }
    }
    
    else if ([srvStr isEqualToString: BLE_UUID_BAROMETER_SENSOR_SERVICE_LONG])
    {
        self.lbService.text = @"Barometer";
        
        if ( [selCharStr isEqualToString: BLE_UUID_BAROMETER_DATA_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Data";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_BAROMETER_CONFIG_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Configuration";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_BAROMETER_CALIBRATION_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Calibration";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_BAROMETER_PERIOD_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Update Period";
        }
    }
    else if ([srvStr isEqualToString: BLE_UUID_GYROSCOPE_SERVICE_LONG])
    {
        self.lbService.text = @"Gyroscope";

        if ( [selCharStr isEqualToString: BLE_UUID_GYROSCOPE_DATA_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Data";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_GYROSCOPE_CONFIG_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Configuration";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_GYROSCOPE_PERIOD_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Update Period";
        }
    }
    else if ([srvStr isEqualToString: BLE_UUID_TEST_SERVICE_LONG])
    {
        self.lbService.text = @"Test";
        
        if ( [selCharStr isEqualToString: BLE_UUID_TEST_DATA_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Data";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_TEST_CONFIG_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Configuration";
        }
    }
    else if ([srvStr isEqualToString: BLE_UUID_IO_SERVICE_LONG])
    {
        self.lbService.text = @"Input / Output";
        
        if ( [selCharStr isEqualToString: BLE_UUID_IO_DATA_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Data";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_IO_CONFIG_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Configuration";
        }
    }
    else if ([srvStr isEqualToString: BLE_UUID_OAD_SERVICE_LONG])
    {
        self.lbService.text = @"Over Air Download";
        
        if ( [selCharStr isEqualToString: BLE_UUID_OAD_IMAGE_IDENTIFY_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Image Identity";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_OAD_IMAGE_BLOCK_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Image Block";
        }
    }
    else if ([srvStr isEqualToString: BLE_UUID_OPTICAL_SENSOR_SERVICE_LONG])
    {
        self.lbService.text = @"Luxometer";

        if ( [selCharStr isEqualToString: BLE_UUID_OPTICAL_SENSOR_DATA_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Data";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_OPTICAL_SENSOR_CONFIG_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Configuration";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_OPTICAL_SENSOR_PERIOD_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Update Period";
        }
    }
    
    else if ([srvStr isEqualToString: BLE_UUID_REGISTER_SERVICE_LONG])
    {
        self.lbService.text = @"Register";
        
        if ( [selCharStr isEqualToString: BLE_UUID_REGISTER_DATA_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Data";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_REGISTER_CONFIG_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Configuration";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_REGISTER_PERIOD_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Update Period";
        }
    }
    
    else if ([srvStr isEqualToString: BLE_UUID_MOVEMENT_SENSOR_SERVICE_LONG])
    {
        self.lbService.text = @"Movement";
        
        if ( [selCharStr isEqualToString: BLE_UUID_MOVEMENT_SENSOR_DATA_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Data";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_MOVEMENT_SENSOR_CONFIG_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Configuration";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_MOVEMENT_SENSOR_PERIOD_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Update Period";
        }
    }
    
    else if ([srvStr isEqualToString: BLE_UUID_CONNECTION_SERVICE_LONG])
    {
        self.lbService.text = @"Connection";
        
        if ( [selCharStr isEqualToString: BLE_UUID_CONNECTION_PARAMS_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Parameters";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_CONNECTION_PARAMS_REQ_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Params Request";
        }
        else if ( [selCharStr isEqualToString: BLE_UUID_CONNECTION_DISCONNECT_REQ_CHAR_LONG ] )
        {
            self.lbCharacteristic.text = @"Disconnect Request";
        }
    }
    
    else // if no info, just show the corresponding uuids
    {
        self.lbService.text = srvStr;
        self.lbCharacteristic.text = selCharStr;
    }
    
    // m = [self.defaultBTServer getIdx];  // index of a chosen tableview row was saved in BTServer
    ch = self.defaultBTServer.discoveredSevice.characteristics[[self.defaultBTServer getIdx]] ;
    self.lbDataType.text = [self.defaultBTServer getPropertiesString: ch.properties];
    

    
    NSLog(@"RVVC got Property: %@", self.lbDataType.text);
    
    //------------------------
    if ( [ self.lbDataType.text isEqualToString: @" Read" ] )
    {
        self.btnRead.enabled = true;
    }
    
    if ( [ self.lbDataType.text isEqualToString: @" Write" ] )
    {
        self.btnWrite.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" Notify" ] )
    {
        self.btnNotify.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" Read Notify" ] )
    {
        self.btnRead.enabled = true;
        self.btnNotify.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" Read Notify Indicate" ] )
    {
        self.btnRead.enabled = true;
        self.btnNotify.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" Read Write" ] )
    {
        self.btnRead.enabled = true;
        self.btnWrite.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" Read WriteWithoutResponse" ] )
    {
        self.btnRead.enabled = true;
        self.btnWrite.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" Read WriteWithoutResponse Write" ] )
    {
        self.btnRead.enabled = true;
        self.btnWrite.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" Read WriteWithoutResponse Write AuthenticatedSignedWrites" ] )
    {
        self.btnRead.enabled = true;
        self.btnWrite.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" Read WriteWithoutResponse Write Notify Indicate AuthenticatedSignedWrites" ] )
    {
        self.btnRead.enabled = true;
        self.btnWrite.enabled = true;
        self.btnNotify.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" Read Write Notify" ] )
    {
        self.btnRead.enabled = true;
        self.btnWrite.enabled = true;
        self.btnNotify.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" Write Notify" ] )
    {
        self.btnWrite.enabled = true;
        self.btnNotify.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" Write Notify Indicate" ] )
    {
        self.btnWrite.enabled = true;
        self.btnNotify.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" WriteWithoutResponse Write Notify" ] )
    {
        self.btnWrite.enabled = true;
        self.btnNotify.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" WriteWithoutResponse Write AuthenticatedSignedWrites" ] )
    {
        self.btnWrite.enabled = true;
    }
    if ( [ self.lbDataType.text isEqualToString: @" WriteWithoutResponse" ] )
    {
        self.btnWrite.enabled = true;
    }

    //------------------------
    
    readState = false;
    notifState = false;
    
    [self readAction];
    
    NSLog(@"RVVC is reading ...");
}
//-------------------------------------------------------------------------

-(void)didDisconnect
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

-(NSString*)intToHexString:(NSInteger)value
{
    return [[NSString alloc] initWithFormat:@"%lX", (long)value];
}

-(void)didReadvalue
{
    dispatch_async
    (
        dispatch_get_main_queue(), ^
        {
            readState = false;
            
            NSData *d = self.defaultBTServer.selectCharacteristic.value;

            NSString *s = [d hexval];

            NSLog(@"%@", d);
            self.lbHex.text = [@"0x" stringByAppendingString: s];
            
            // converting NSString * s = @"68656C6C6F"; to 'hello'
            // http://stackoverflow.com/questions/6421282/how-to-convert-hex-to-nsstring-in-objective-c?lq=1

            NSMutableString * newString = [[NSMutableString alloc] init] ;

            int i = 0;
            
            while (i < [s length])
            {
                NSString * hexChar = [s substringWithRange: NSMakeRange(i, 2)];
                
                int value = 0;
                sscanf([hexChar cStringUsingEncoding: NSASCIIStringEncoding], "%x", &value);
                
                [newString appendFormat:@"%c", (char)value];
                i+=2;
            }
            
            self.lbASCII.text = newString;
            
            unsigned long long  dec;
            
            NSScanner* scanner = [NSScanner scannerWithString: s];
            [scanner scanHexLongLong: &dec];
            
            self.lbDecimal.text = [NSString stringWithFormat: @"%lld", dec];
        }
    );
    
    NSLog(@"RVVC didRead value");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)goBack: (id)sender
{
    if (notifState == true)
    {
        notifState = false;
        NSLog(@"RVVC stops notification");
        
        [BLEUtility
         setNotificationForCharacteristic: self.defaultBTServer.selectPeripheral
                                    sUUID: [self.defaultBTServer.discoveredSevice.UUID UUIDString]
                                    cUUID: [self.defaultBTServer.selectCharacteristic.UUID UUIDString]
                                   enable: NO
         ];
    }
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"going back to CVC ...");
}

-(void)readAction
{
    if (readState == true)
    {
        NSLog(@"RVVC is busy reading ...");
        return;
    }
    
    readState = true;
    
    // [self.defaultBTServer readValue: nil];
    
    //=============
    
     NSString *sUUID = [self.defaultBTServer.discoveredSevice.UUID UUIDString];
     NSString *cUUID = [self.defaultBTServer.selectCharacteristic.UUID UUIDString];
    [BLEUtility
     readCharacteristic: self.defaultBTServer.selectPeripheral
                  sUUID: sUUID
                  cUUID: cUUID
    ];
    //-------------
}

- (IBAction)readData: (id)sender
{
    [self readAction];
}

- (IBAction)notify: (id)sender
{
    if (notifState == false)
    {
        notifState = true;
        NSLog(@"RVVC is notifying ...");
        
        [self.btnNotify setTitle: (@"Stop Listening ...")
                        forState: UIControlStateNormal];
        
        [BLEUtility
         setNotificationForCharacteristic: self.defaultBTServer.selectPeripheral
                                    sUUID: [self.defaultBTServer.discoveredSevice.UUID UUIDString]
                                    cUUID: [self.defaultBTServer.selectCharacteristic.UUID UUIDString]
                                   enable: YES
        ];
    }
    else
    {
        notifState = false;
        NSLog(@"RVVC stops notification");
        
        [self.btnNotify setTitle: (@"Listen for Notifications") forState: UIControlStateNormal];
        
        [BLEUtility
         setNotificationForCharacteristic: self.defaultBTServer.selectPeripheral
                                    sUUID: [self.defaultBTServer.discoveredSevice.UUID UUIDString]
                                    cUUID: [self.defaultBTServer.selectCharacteristic.UUID UUIDString]
                                   enable: NO
         ];
    }
}

// switcing to wvvc
- (IBAction)write: (id)sender
{
    NSLog(@"RVVC is switching to WVVC...");
    [self performSegueWithIdentifier: @"writeValue" // wvvc address
                              sender: self];
}

@end
