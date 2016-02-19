//
//  ShowPeripheralViewController.m
//  DarkBlue
//
//  Created by chenee on 14-3-26.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import "ServicesViewController.h"
#import "BTServer.h"
#import "bleServices.h"

@interface ServicesViewController ()<UITableViewDataSource,UITableViewDelegate,BTServerDelegate>
@property(strong,nonatomic)BTServer *defaultBTServer;
@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ServicesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

//=====================================================================
//              uiViewController callbacks

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.defaultBTServer = [BTServer defaultBTServer];
    self.defaultBTServer.delegate = (id)self;
    self.lbName.text = self.defaultBTServer.selectPeripheral.name;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"SVC willAppear");
}

-(void)viewDidAppear:(BOOL)animated
{
    // self.defaultBTServer.delegate = self;
    NSLog(@"SVC viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"SVC viewWillDisappear");
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"SVC viewDidlDisappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"SVC didReceiveMemoryWarning");
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

//-----------------------------------------------------------------------------

-(void)didDisconnect
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
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

-(void) tableViewReloadTimer:(NSTimer *)timer
{
    NSLog(@"tableViewData updated!");
    [self.tableView reloadData];
}

-(void)pvcUpdateTable
{
    dispatch_async
    (
        dispatch_get_main_queue(), ^
        {
//        [NSTimer scheduledTimerWithTimeInterval: 0.001
//                                         target: self
//                                       selector: @selector(tableViewReloadTimer:)
//                                       userInfo: nil
//                                        repeats: NO];
           [self performSelector:  @selector(tableViewReloadTimer:)
                      withObject: nil
                      afterDelay: 0.001
           ];
        }
    );
}

- (IBAction)goBack:(id)sender
{
    // [ProgressHUD dismiss];
    
    [self.defaultBTServer disConnect];

    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"going back to CSVC");
}
#pragma mark -- table delegate

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
    unsigned long retVal = 0;
    
    if ([self.defaultBTServer getServiceState] == KSUCCESS)
    {
        unsigned long n = [self.defaultBTServer.selectPeripheral.services count];
        NSLog(@"Nomber of Discovered Services: %ld", n);
        // done = true;
        retVal = n;
    }
    else
    {
        NSLog(@"Ghost Services");
        retVal = 0;
    }
    
    return retVal;
}

- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"ServiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                      reuseIdentifier: MyIdentifier];
    }
    
    CBService* ser = self.defaultBTServer.selectPeripheral.services[indexPath.row];
    
    NSString *uuid = [ser.UUID UUIDString];
    
    cell.detailTextLabel.text = uuid;
    
    if ( [ uuid isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_DEVICE_INFORMATION_SERVICE] ] )
    {
        cell.textLabel.text = @"Device Information";
    }
    else if ( [ uuid isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_BATTERY_SERVICE] ] )
    {
        cell.textLabel.text = @"Battery";
    }
    else if ( [ uuid isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_SIMPLE_BLE_PERIPHERAL_SERVICE] ] )
    {
        cell.textLabel.text = @"Simple BLE Peripheral";
    }
    else if ( [uuid isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_LINK_LOSS_SERVICE] ] )
    {
        cell.textLabel.text = @"Link Loss";
    }
    else if ( [uuid isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_IMMEDIATE_ALERT_SERVICE] ] )
    {
        cell.textLabel.text = @"Immediate Alert";
    }
    else if ( [uuid isEqualToString: [NSString stringWithFormat: @"%X", BLE_UUID_TX_POWER_SERVICE] ] )
    {
        cell.textLabel.text = @"Tx Power";
    }
    else if ( [uuid isEqualToString: BLE_UUID_ITORQ_SERVICE_LONG] )
    {
        cell.textLabel.text = @"InteliTorq";
    }
    else if( [uuid isEqualToString: BLE_UUID_IR_TEMP_SENSOR_SERVICE_LONG])
    {
        cell.textLabel.text = @"Contactless IR Temp Sensor";
    }
    else if( [uuid isEqualToString: BLE_UUID_ACCELEROMETER_SERVICE_LONG])
    {
        cell.textLabel.text = @"Accelerometer";
    }
    else if ( [uuid isEqualToString: BLE_UUID_HUMIDITY_SENSOR_SERVICE_LONG] )
    {
        cell.textLabel.text = @"Humidity Sensor";
    }
    else if( [uuid isEqualToString: BLE_UUID_MAGNETOMETER_SERVICE_LONG])
    {
        cell.textLabel.text = @"Magnetometer";
    }
    else if( [uuid isEqualToString: BLE_UUID_BAROMETER_SENSOR_SERVICE_LONG])
    {
        cell.textLabel.text = @"Barometric Pressure Sensor";
    }
    else if( [uuid isEqualToString: BLE_UUID_GYROSCOPE_SERVICE_LONG])
    {
        cell.textLabel.text = @"Gyroscope";
    }
    else if( [uuid isEqualToString: BLE_UUID_TEST_SERVICE_LONG])
    {
        cell.textLabel.text = @"Test";
    }
    else if( [uuid isEqualToString: BLE_UUID_RANGE_TEST_SERVICE_LONG])
    {
        cell.textLabel.text = @"Range Test";
    }
    else if ( [uuid isEqualToString: BLE_UUID_OPTICAL_SENSOR_SERVICE_LONG] )
    {
        cell.textLabel.text = @"Luxometer";
    }
    else if( [uuid isEqualToString: BLE_UUID_MOVEMENT_SENSOR_SERVICE_LONG])
    {
        cell.textLabel.text = @"Movement Sensor";
    }
    else if( [uuid isEqualToString: [NSString stringWithFormat: @"%X",BLE_UUID_SIMPLE_KEYS_SERVICE] ])
    {
        cell.textLabel.text = @"Simple Keys";
    }
    else if( [uuid isEqualToString: BLE_UUID_OAD_SERVICE_LONG])
    {
        cell.textLabel.text = @"Over Air Dowload";
    }
    else if( [uuid isEqualToString: BLE_UUID_IO_SERVICE_LONG])
    {
        cell.textLabel.text = @"Input Output";
    }
    else if( [uuid isEqualToString: BLE_UUID_CONNECTION_SERVICE_LONG])
    {
        cell.textLabel.text = @"Connection";
    }
    else if( [uuid isEqualToString: BLE_UUID_REGISTER_SERVICE_LONG])
    {
        cell.textLabel.text = @"Register Service";
    }
    
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"UUID:%@", uuid];
    }

    return cell;
}


-         (void)tableView: (UITableView *)tableView
  didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSLog(@"PVC tableView Clicked at :%ld", (long)indexPath.row);
    
    CBService* ser = self.defaultBTServer.selectPeripheral.services[indexPath.row];
    [self.defaultBTServer discoverService: ser];
    
    [self performSegueWithIdentifier:@"getCharacteristic" sender: self];
}


@end
