//==============================================================================
//  ShowServiceViewController.m
//  DarkBlue
//
//  Created by chenee on 14-3-27.
//  Copyright (c) 2014年 chenee. All rights reserved.
//
//  Modified by Leonid Yerukhimov
//------------------------------------------------------------------------------
#import "BTServer.h"
#import "CharacteristicsViewController.h"
#import "ProgressHUD.h"
#import "bleServices.h"

@interface CharacteristicsViewController ()<UITableViewDataSource,UITableViewDelegate,BTServerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbPeripheral;
@property (weak, nonatomic) IBOutlet UILabel *lbService;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong,nonatomic) BTServer *defaultBTServer;
@end

@implementation CharacteristicsViewController
{
    BOOL readLock;
}

- (id)initWithNibName: (NSString *)nibNameOrNil
               bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

//===================================================================================
// - (void)viewDidLoad is called exactly once, when the view controller is first
//   loaded into memory.
//   This is where you want to instantiate any instance variables and build any views
//   that live for the entire lifecycle of this view controller.
//   However, the view is usually not yet visible at this point.
//------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.defaultBTServer = [BTServer defaultBTServer];
    self.defaultBTServer.delegate = (id)self;
    self.lbPeripheral.text = self.defaultBTServer.selectPeripheral.name;
    
    readLock = false;
    NSLog(@"CVC viewDidLoad");
}

/// This is where you do your clean-up and release of stuff,
//  but this is handled automatically so not much you really need to do here.
-(void)ViewDidlUnload
{
    NSLog(@"CVC ViewDidlUnload");
}
//------------------------------------------------------------------------------

//==============================================================================
/// Called right before your view appears, good for hiding/showing fields or
/// any operations that you want to happen every time before the view is visible.
/// Because you might be going back and forth between views, this will be called
/// every time your view is about to appear on the screen.


// This event notifies the the view controller whenever the view appears on the screen.
// In this step the view has bounds that are defined but the orientation is not set.
-(void)viewWillAppear:(BOOL)animated
{
//    self.defaultBTServer.delegate = self;
    NSLog(@"CVC viewWillAppear");
}

-(void)ViewWillDisappear:(BOOL)animated
{
    NSLog(@"CVC ViewWillDisappear");
}

///  Called after the view appears - great place to start an animations or
///  the loading of external data from an API.
//   event fires after the view is presented on the screen.
//   A good place to get data from a backend service or database.

//   called when the view is actually visible, and can be called multiple times
//   during the lifecycle of a View Controller (for instance, when a Modal View
//   Controller is dismissed and the view becomes visible again). This is where
//   you want to perform any layout actions or do any drawing in the UI -
//   for example, presenting a modal view controller.
//   However, anything you do here should be repeatable.
//   It's best not to retain things here, or else you'll get memory leaks if
//   you don't release them when the view disappears.
-(void)viewDidAppear:(BOOL)animated
{
    // self.defaultBTServer.delegate = self;
    NSLog(@"CVC viewDidAppear");
}

-(void)ViewDidlDisappear:(BOOL)animated
{
    NSLog(@"CVC ViewDidlDisappear");
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
//------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"CVC didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

-(void)ViewDidDispose
{
    NSLog(@"CVC ViewDidDispose");
}
//------------------------------------------------------------------------------

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
    
    NSLog(@"CVC is going back to PVC ...");

}

-(void)didDisconnect
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.navigationController popToRootViewControllerAnimated: YES];
    });
}
-(void)didReadvalue
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        readLock = false;
        // [ProgressHUD dismiss];
        [self performSegueWithIdentifier: @"readValue"
                                  sender: self];
        
        NSLog(@"CVC didReadvalue");
    });
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
#pragma mark -- table delegate

-(void) tableViewReloadTimer:(NSTimer *)timer
{
    NSLog(@"CVC TableViewData updated!");
    [self.myTableView reloadData];
}

-(void)svcUpdateTable
{
    dispatch_async
    (
     dispatch_get_main_queue(), ^
     {
         [self performSelector:  @selector(tableViewReloadTimer:)
                    withObject: nil
                    afterDelay: 0.001
         ];
     }
     );
}

-   (NSInteger)tableView: (UITableView *)tableView
   numberOfRowsInSection: (NSInteger)section
{
    unsigned long retVal = 0;
    
    if ([self.defaultBTServer getCharacteristicState] == KSUCCESS)
    {
        unsigned long n = [self.defaultBTServer.discoveredSevice.characteristics count];
        NSLog(@"CVC has Discovered %ld Characteristics", n);
        // done = true;
        retVal = n;
    }
    else
    {
        NSLog(@"CVC has Discovered a Ghost Characteristic");
        retVal = 0;
    }
    
    return retVal;
}

-       (void)tableView: (UITableView *)tableView
didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    CBCharacteristic* ch = self.defaultBTServer.discoveredSevice.characteristics[indexPath.row];
    
    NSLog(@"CVC tableview row index: %ld", (long)indexPath.row);
    
    [self performSegueWithIdentifier: @"readValue"
                              sender: self];
    
    readLock = true;
    
    [self.defaultBTServer readValue: ch
                                idx: (long)indexPath.row
    ];

}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"CharacteristicCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    NSString *srvStr = [self.defaultBTServer.discoveredSevice.UUID UUIDString];
    
    CBCharacteristic* ch = self.defaultBTServer.discoveredSevice.characteristics[indexPath.row];
    
    
    // cell.textLabel.text = [ch.UUID UUIDString];
    //---------------------------------------------------------
    NSString *uuidStr = [ch.UUID UUIDString];
    
    if ( [srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BATTERY_SERVICE]] )
    {
        self.lbService.text = @"Battery";
        if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BATTERY_LEVEL_CHAR ]] )
        {
            cell.textLabel.text = @"Level";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BATTERY_LEVEL_STATE_CHAR] ] )
        {
            cell.textLabel.text = @"Level State";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BATTERY_POWER_STATE_CHAR] ] )
        {
            cell.textLabel.text = @"Power State";
        }
    }
    else if ( [ srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SIMPLE_KEYS_SERVICE] ] )
    {
        self.lbService.text = @"Simple Keys";
        if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SIMPLE_KEY_PRESS_STATE_CHAR] ] )
        {
            cell.textLabel.text = @"Press State";
        }
    }
    else if ( [srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_LINK_LOSS_SERVICE]] )
    {
        self.lbService.text = @"Link Loss";
        if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_ALERT_LEVEL_CHAR] ] )
        {
            cell.textLabel.text = @"LL Alert Level";
        }
    }
    else if ( [srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_IMMEDIATE_ALERT_SERVICE]] )
    {
        self.lbService.text = @"Immediate Alert";
        if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_ALERT_LEVEL_CHAR ]] )
        {
            cell.textLabel.text = @"IA Level";
        }
    }
    else if ( [srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_TX_POWER_SERVICE]] )
    {
        self.lbService.text = @"Tx Power";
        if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_TX_POWER_LEVEL_CHAR] ] )
        {
            cell.textLabel.text = @"Level";
        }
    }
    else if ( [srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_DEVICE_INFORMATION_SERVICE]] )
    {
        self.lbService.text = @"Device Information";
        
        if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SYSTEM_ID_CHAR]] )
        {
            cell.textLabel.text = @"System ID String";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_MODEL_NUMBER_STRING_CHAR]] )
        {
            cell.textLabel.text = @"Model Number String";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SERIAL_NUMBER_STRING_CHAR ]] )
        {
            cell.textLabel.text = @"Serial Number String";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_FIRMWARE_REVISION_STRING_CHAR] ] )
        {
            cell.textLabel.text = @"Firmware Revision String";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_HARDWARE_REVISION_STRING_CHAR] ] )
        {
            cell.textLabel.text = @"Hardware Revision String";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SOFTWARE_REVISION_STRING_CHAR] ] )
        {
            cell.textLabel.text = @"Software Revision String";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_MANUFACTURER_NAME_STRING_CHAR] ] )
        {
            cell.textLabel.text = @"Manufacturer Name String";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_IEEE_REGULATORY_CERTIFICATION_DATA_LIST_CHAR] ] )
        {
            cell.textLabel.text = @"Regulatory Certification Data List";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_PNP_ID_CHAR] ] )
        {
            cell.textLabel.text = @"PnP ID";
        }
    }
    else if ( [srvStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SIMPLE_BLE_PERIPHERAL_SERVICE] ] )
    {
        self.lbService.text = @"Simple BLE Peripheral";
        
        if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CHAR_1_CHAR] ] )
        {
            cell.textLabel.text = @"Characteristic_1";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CHAR_2_CHAR] ] )
        {
            cell.textLabel.text = @"Characteristic_2";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CHAR_3_CHAR] ] )
        {
            cell.textLabel.text = @"Characteristic_3";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CHAR_4_CHAR] ] )
        {
            cell.textLabel.text = @"Characteristic_4";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CHAR_5_CHAR] ] )
        {
            cell.textLabel.text = @"Characteristic_5";
        }
    }
    else if ( [srvStr isEqualToString: BLE_UUID_ITORQ_SERVICE_LONG] )
    {
        self.lbService.text = @"Intelitorq";
        
        if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BATTERY_LEVEL_CHAR] ] )
        {
            cell.textLabel.text = @"Battery Level";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CALIBRATION_CMD_CHAR] ] )
        {
            cell.textLabel.text = @"Calibration Cmd";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_YELLOW_LED_SET_POINT_CHAR] ] )
        {
            cell.textLabel.text = @"Yellow LED Set Point";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_RED_LED_SET_POINT_CHAR] ] )
        {
            cell.textLabel.text = @"Red LED Set Point";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SHAKER_SET_POINT_CHAR] ] )
        {
            cell.textLabel.text = @"Shaker Set Point";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_EVENT_COUNTER_THRESHOLD_CHAR] ] )
        {
            cell.textLabel.text = @"Event Counter Threshold";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_EVENT_COUNTER_CHAR] ] )
        {
            cell.textLabel.text = @"Event Counter";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_PGW_FW_REVISION_CHAR] ] )
        {
            cell.textLabel.text = @"PGW FW Rev";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_INITIATE_FW_UPDATE_CHAR] ] )
        {
            cell.textLabel.text = @"Initiate FW Update";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_CURRENT_TORQUE_CHAR] ] )
        {
            cell.textLabel.text = @"Torque Value";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BUZZER_SET_POINT_CHAR] ] )
        {
            cell.textLabel.text = @"Buzzer Set Point";
        }
        else if ( [uuidStr isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_DIRECTION_CHAR] ] )
        {
            cell.textLabel.text = @"Direction";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_IR_TEMP_SENSOR_SERVICE_LONG] )
    {
        self.lbService.text = @"IR Temperature Sensor";
        
        if ( [uuidStr isEqualToString: BLE_UUID_IR_TEMP_SENSOR_DATA_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Data";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_IR_TEMP_SENSOR_CONFIG_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Configuration";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_IR_TEMP_SENSOR_PERIOD_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Period";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_ACCELEROMETER_SERVICE_LONG] )
    {
        self.lbService.text = @"Accelerometer";
        
        if ( [uuidStr isEqualToString: BLE_UUID_ACCELEROMETER_DATA_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Data";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_ACCELEROMETER_CONFIG_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Configuration";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_ACCELEROMETER_PERIOD_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Period";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_HUMIDITY_SENSOR_SERVICE_LONG] )
    {
        self.lbService.text = @"Humidity";
        
        if ( [uuidStr isEqualToString: BLE_UUID_HUMIDITY_SENSOR_DATA_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Data";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_HUMIDITY_SENSOR_CONFIG_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Configuration";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_HUMIDITY_SENSOR_PERIOD_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Period";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_BAROMETER_SENSOR_SERVICE_LONG] )
    {
        self.lbService.text = @"Barometer";
        
        if ( [uuidStr isEqualToString: BLE_UUID_BAROMETER_DATA_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Data";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_BAROMETER_CONFIG_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Configuration";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_BAROMETER_PERIOD_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Period";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_BAROMETER_CALIBRATION_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Calibration";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_GYROSCOPE_SERVICE_LONG] )
    {
        self.lbService.text = @"Gyroscope";
        
        if ( [uuidStr isEqualToString: BLE_UUID_GYROSCOPE_DATA_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Data";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_GYROSCOPE_CONFIG_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Configuration";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_GYROSCOPE_PERIOD_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Period";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_MAGNETOMETER_SERVICE_LONG] )
    {
        self.lbService.text = @"Magnetometer";
        
        if ( [uuidStr isEqualToString: BLE_UUID_MAGNETOMETER_DATA_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Data";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_MAGNETOMETER_CONFIG_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Configuration";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_MAGNETOMETER_PERIOD_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Period";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_OPTICAL_SENSOR_SERVICE_LONG] )
    {
        self.lbService.text = @"Luxometer";
        
        if ( [uuidStr isEqualToString: BLE_UUID_OPTICAL_SENSOR_DATA_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Data";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_OPTICAL_SENSOR_CONFIG_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Configuration";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_OPTICAL_SENSOR_PERIOD_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Period";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_MOVEMENT_SENSOR_SERVICE_LONG] )
    {
        self.lbService.text = @"Movement";
        
        if ( [uuidStr isEqualToString: BLE_UUID_MOVEMENT_SENSOR_DATA_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Data";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_MOVEMENT_SENSOR_CONFIG_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Configuration";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_MOVEMENT_SENSOR_PERIOD_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Period";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_CONNECTION_SERVICE_LONG] )
    {
        self.lbService.text = @"Connection";
        
        if ( [uuidStr isEqualToString: BLE_UUID_CONNECTION_PARAMS_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Parameters";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_CONNECTION_PARAMS_REQ_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Params Request";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_CONNECTION_DISCONNECT_REQ_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Disconnect Request";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_REGISTER_SERVICE_LONG] )
    {
        self.lbService.text = @"Register";
        
        if ( [uuidStr isEqualToString: BLE_UUID_REGISTER_DATA_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Data";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_REGISTER_CONFIG_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Configuration";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_REGISTER_PERIOD_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Period";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_TEST_SERVICE_LONG] )
    {
        self.lbService.text = @"Test";
        
        if ( [uuidStr isEqualToString: BLE_UUID_TEST_DATA_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Data";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_TEST_CONFIG_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Configuration";
        }
    }
    
    else if ( [srvStr isEqualToString: BLE_UUID_IO_SERVICE_LONG] )
    {
        self.lbService.text = @"Input / Output";
        
        if ( [uuidStr isEqualToString: BLE_UUID_IO_DATA_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Data";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_IO_CONFIG_CHAR_LONG ] )
        {
            cell.textLabel.text = @"Config";
        }
    }
    else if ( [srvStr isEqualToString: BLE_UUID_OAD_SERVICE_LONG] )
    {
        self.lbService.text = @"Over Air Download";
        
        if ( [uuidStr isEqualToString: BLE_UUID_OAD_IMAGE_IDENTIFY_CHAR_LONG ] )
        {
            cell.textLabel.text = @"OAD Image Identify";
        }
        else if ( [uuidStr isEqualToString: BLE_UUID_OAD_IMAGE_BLOCK_CHAR_LONG ] )
        {
            cell.textLabel.text = @"OAD Image Block";
        }
    }
    
    else
    {
        self.lbService.text = [NSString stringWithFormat:@"UUID:%@", srvStr];
        // self.lbService.text = @"<Not In Database>";
        cell.textLabel.text = uuidStr;
    }
    //---------------------------------------------------------

    NSString *s = [self.defaultBTServer getPropertiesString: ch.properties];

    cell.detailTextLabel.text = [NSString stringWithFormat: @"Props: %@", s];

    return cell;
}

@end
