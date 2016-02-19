//
//  bleServices.h
//  DarkBlue
//
//  Created by Administrator on 11/19/15.
//  Copyright (c) 2015 chenee. All rights reserved.
//

#ifndef DarkBlue_bleServices_h
#define DarkBlue_bleServices_h

/*  https://developer.bluetooth.org/gatt/services/Pages/ServicesHome.aspx

 Generic Access		              0x1800
 Generic Attribute		          0x1801
 Immediate Alert                  0x1802
 Link Loss	                      0x1803
 Tx Power                         0x1804
 Current Time Service	          0x1805
 Reference Time Update            0x1806
 Next DST Change Service          0x1807
 Glucose	                      0x1808
 Health Thermometer	              0x1809
 Device Information		          0x180A

 Heart Rate	                      0x180D
 Phone Alert Status               0x180E
 Battery Service                  0x180F
 Blood Pressure	        	      0x1810
 Alert Notification               0x1811
 Human Interface Device           0x1812
 Scan Parameters                  0x1813
 Running Speed and Cadence        0x1814
 Automation IO	                  0x1815
 Cycling Speed and Cadence	      0x1816
 
 Cycling Power	                  0x1818
 Location and Navigation          0x1819
 Environmental Sensing	          0x181A
 Body Composition	    	      0x181B
 User Data                        0x181C
 Weight Scale	                  0x181D
 Bond Management	    	      0x181E
 Continuous Glucose Monitoring    0x181F
 Internet Protocol Support	      0x1820
 Indoor Positioning               0x1821
 Pulse Oximeter	                  0x1822
 HTTP Proxy	                      0x1823
 Transport Discovery              0x1824
 Object Transfer                  0x1825

*/

//------------- common services definitions -----------------------------
#define 	BLE_UUID_GENERIC_ACCESS_SERVICE           0x1800
#define 	BLE_UUID_GENERIC_ATTRIBUTE_SERVICE        0x1801
#define 	BLE_UUID_IMMEDIATE_ALERT_SERVICE          0x1802
#define 	BLE_UUID_LINK_LOSS_SERVICE                0x1803
#define 	BLE_UUID_TX_POWER_SERVICE                 0x1804
#define 	BLE_UUID_CURRENT_TIME_SERVICE             0x1805
#define 	BLE_UUID_REFERENCE_TIME_UPDATE_SERVICE    0x1806
#define 	BLE_UUID_NEXT_DST_CHANGE_SERVICE          0x1807
#define 	BLE_UUID_GLUCOSE_SERVICE                  0x1808
#define 	BLE_UUID_HEALTH_THERMOMETER_SERVICE       0x1809
#define 	BLE_UUID_DEVICE_INFORMATION_SERVICE       0x180A

#define 	BLE_UUID_HEART_RATE_SERVICE               0x180D
#define 	BLE_UUID_PHONE_ALERT_STATUS_SERVICE       0x180E
#define 	BLE_UUID_BATTERY_SERVICE                  0x180F
#define 	BLE_UUID_BLOOD_PRESSURE_SERVICE           0x1810
#define 	BLE_UUID_ALERT_NOTIFICATION_SERVICE       0x1811
#define 	BLE_UUID_HUMAN_INTERFACE_DEVICE_SERVICE   0x1812
#define 	BLE_UUID_SCAN_PARAMETERS_SERVICE          0x1813
#define 	BLE_UUID_RUNING_SPEED_AND_CADENCE_SERVICE 0x1814
#define 	BLE_UUID_AUTOMATION_IO_SERVICE            0x1815
#define 	BLE_UUID_CYCLING_SPEED_AND_CADENCE_SERVICE  0x1816
#define 	BLE_UUID_CYCLING_POWER_SERVICE            0x1818
#define 	BLE_UUID_LOCATION_AND_NAVIGATION_SERVICE  0x1819
#define 	BLE_UUID_ENVIRONMENTAL_SENSING_SERVICE    0x181A
#define 	BLE_UUID_BODY_COMPOSITION_SERVICE         0x181B
#define 	BLE_UUID_USER_DATA_SERVICE                0x181C
#define 	BLE_UUID_WEIGHT_SCALE_SERVICE             0x181D
#define 	BLE_UUID_BOND_MANAGEMENT_SERVICE          0x181E
#define 	BLE_UUID_CONTINUOUS_GLUCOSE_MONITORING_SERVICE  0x181F

#define     BLE_UUID_INTERNET_PROTOCOL_SUPPORT_SERVICE 0x1820
#define     BLE_UUID_INDOOR_POSITIONING_SERVICE       0x1821
#define     BLE_UUID_PULSE_OXIMETER_SERVICE           0x1822
#define     BLE_UUID_HTTP_PROXY_SERVICE               0x1823
#define     BLE_UUID_TRANSPORT_DISCOVERY_SERVICE      0x1824
#define     BLE_UUID_OBJECT_TRANSFER_SERVICE          0x1825

#define     BLE_UUID_iTAG_PROPRIETARY_SERVICE         0x18F0

// ---- custom services ------------------------------------
#define     BLE_UUID_IR_TEMP_SENSOR_SERVICE           0xAA00
#define     BLE_UUID_ACCELEROMETER_SERVICE            0xAA10
#define     BLE_UUID_IR_HUMIDITY_SENSOR_SERVICE       0xAA20
#define     BLE_UUID_MAGNETOMETER_SERVICE             0xAA30
#define     BLE_UUID_BAROMETER_SERVICE                0xAA40
#define     BLE_UUID_GYROSCOPE_SERVICE                0xAA50
#define     BLE_UUID_TEST_SERVICE                     0xAA60
#define     BLE_UUID_IO_SERVICE                       0xAA64
#define     BLE_UUID_OPTICAL_SENSOR_SERVICE           0xAA70
#define     BLE_UUID_MOVEMENT_SENSOR_SERVICE          0xAA80
#define     BLE_UUID_GPIO_SERVICE                     0xAAA0
#define     BLE_UUID_RANGE_TEST_SERVICE               0xAAB0
#define     BLE_UUID_REGISTER_SERVICE                 0xAC00
#define     BLE_UUID_OAD_SERVICE                      0xFFC0
#define     BLE_UUID_LED_SERVICE                      0xFFD0
#define     BLE_UUID_TEMPERATURE_SERVICE              0xFFE0
#define     BLE_UUID_SIMPLE_KEYS_SERVICE              0xFFE0
#define     BLE_UUID_SIMPLE_BLE_PERIPHERAL_SERVICE    0xFFF0

#define     BLE_UUID_ITORQ_SERVICE_LONG               @"4B366F28-40B9-4F87-8851-81535BF799E4"

#define     BLE_UUID_IR_TEMP_SENSOR_SERVICE_LONG      @"F000AA00-0451-4000-B000-000000000000"
#define     BLE_UUID_ACCELEROMETER_SERVICE_LONG       @"F000AA10-0451-4000-B000-000000000000"
#define     BLE_UUID_HUMIDITY_SENSOR_SERVICE_LONG     @"F000AA20-0451-4000-B000-000000000000"
#define     BLE_UUID_MAGNETOMETER_SERVICE_LONG        @"F000AA30-0451-4000-B000-000000000000"
#define     BLE_UUID_BAROMETER_SENSOR_SERVICE_LONG    @"F000AA40-0451-4000-B000-000000000000"
#define     BLE_UUID_GYROSCOPE_SERVICE_LONG           @"F000AA50-0451-4000-B000-000000000000"
#define     BLE_UUID_TEST_SERVICE_LONG                @"F000AA60-0451-4000-B000-000000000000"
#define     BLE_UUID_IO_SERVICE_LONG                  @"F000AA64-0451-4000-B000-000000000000"
#define     BLE_UUID_OPTICAL_SENSOR_SERVICE_LONG      @"F000AA70-0451-4000-B000-000000000000"
#define     BLE_UUID_MOVEMENT_SENSOR_SERVICE_LONG     @"F000AA80-0451-4000-B000-000000000000"
#define     BLE_UUID_GPIO_SERVICE_LONG                @"F000AAA0-0451-4000-B000-000000000000"
#define     BLE_UUID_RANGE_TEST_SERVICE_LONG          @"F000AAB0-0451-4000-B000-000000000000"
#define     BLE_UUID_REGISTER_SERVICE_LONG            @"F000AC00-0451-4000-B000-000000000000"
#define     BLE_UUID_CONNECTION_SERVICE_LONG          @"F000CCC0-0451-4000-B000-000000000000"
#define     BLE_UUID_OAD_SERVICE_LONG                 @"F000FFC0-0451-4000-B000-000000000000"

//------------- common characteristics definitions ----------------------
#define 	BLE_UUID_BATTERY_LEVEL_CHAR                            0x2A19
#define 	BLE_UUID_BATTERY_LEVEL_STATE_CHAR                      0x2A1B
#define 	BLE_UUID_BATTERY_POWER_STATE_CHAR                      0x2A1A
#define 	BLE_UUID_REMOVABLE_CHAR                                0x2A3A
#define 	BLE_UUID_SERVICE_REQUIRED_CHAR                         0x2A3B
#define 	BLE_UUID_ALERT_CATEGORY_ID_CHAR                        0x2A43
#define 	BLE_UUID_ALERT_CATEGORY_ID_BIT_MASK_CHAR               0x2A42
#define 	BLE_UUID_ALERT_LEVEL_CHAR                              0x2A06
#define 	BLE_UUID_ALERT_NOTIFICATION_CONTROL_POINT_CHAR         0x2A44
#define 	BLE_UUID_ALERT_STATUS_CHAR                             0x2A3F
#define 	BLE_UUID_BLOOD_PRESSURE_FEATURE_CHAR                   0x2A49
#define 	BLE_UUID_BLOOD_PRESSURE_MEASUREMENT_CHAR               0x2A35
#define 	BLE_UUID_BODY_SENSOR_LOCATION_CHAR                     0x2A38
#define 	BLE_UUID_BOOT_KEYBOARD_INPUT_REPORT_CHAR               0x2A22
#define 	BLE_UUID_BOOT_KEYBOARD_OUTPUT_REPORT_CHAR              0x2A32
#define 	BLE_UUID_BOOT_MOUSE_INPUT_REPORT_CHAR                  0x2A33
#define 	BLE_UUID_CURRENT_TIME_CHAR                             0x2A2B
#define 	BLE_UUID_DATE_TIME_CHAR                                0x2A08
#define 	BLE_UUID_DAY_DATE_TIME_CHAR                            0x2A0A
#define 	BLE_UUID_DAY_OF_WEEK_CHAR                              0x2A09
#define 	BLE_UUID_DST_OFFSET_CHAR                               0x2A0D
#define 	BLE_UUID_EXACT_TIME_256_CHAR                           0x2A0C
#define 	BLE_UUID_FIRMWARE_REVISION_STRING_CHAR                 0x2A26
#define 	BLE_UUID_GLUCOSE_FEATURE_CHAR                          0x2A51
#define 	BLE_UUID_GLUCOSE_MEASUREMENT_CHAR                      0x2A18
#define 	BLE_UUID_GLUCOSE_MEASUREMENT_CONTEXT_CHAR              0x2A34
#define 	BLE_UUID_HARDWARE_REVISION_STRING_CHAR                 0x2A27
#define 	BLE_UUID_HEART_RATE_CONTROL_POINT_CHAR                 0x2A39
#define 	BLE_UUID_HEART_RATE_MEASUREMENT_CHAR                   0x2A37
#define 	BLE_UUID_HID_CONTROL_POINT_CHAR                        0x2A4C
#define 	BLE_UUID_HID_INFORMATION_CHAR                          0x2A4A
#define 	BLE_UUID_IEEE_REGULATORY_CERTIFICATION_DATA_LIST_CHAR  0x2A2A
#define 	BLE_UUID_INTERMEDIATE_CUFF_PRESSURE_CHAR               0x2A36
#define 	BLE_UUID_INTERMEDIATE_TEMPERATURE_CHAR                 0x2A1E
#define 	BLE_UUID_LOCAL_TIME_INFORMATION_CHAR                   0x2A0F
#define 	BLE_UUID_MANUFACTURER_NAME_STRING_CHAR                 0x2A29
#define 	BLE_UUID_MEASUREMENT_INTERVAL_CHAR                     0x2A21
#define 	BLE_UUID_MODEL_NUMBER_STRING_CHAR                      0x2A24
#define 	BLE_UUID_UNREAD_ALERT_CHAR                             0x2A45
#define 	BLE_UUID_NEW_ALERT_CHAR                                0x2A46
#define 	BLE_UUID_PNP_ID_CHAR                                   0x2A50
#define 	BLE_UUID_PROTOCOL_MODE_CHAR                            0x2A4E
#define 	BLE_UUID_RECORD_ACCESS_CONTROL_POINT_CHAR              0x2A52
#define 	BLE_UUID_REFERENCE_TIME_INFORMATION_CHAR               0x2A14
#define 	BLE_UUID_REPORT_CHAR                                   0x2A4D
#define 	BLE_UUID_REPORT_MAP_CHAR                               0x2A4B
#define 	BLE_UUID_RINGER_CONTROL_POINT_CHAR                     0x2A40
#define 	BLE_UUID_RINGER_SETTING_CHAR                           0x2A41
#define 	BLE_UUID_SCAN_INTERVAL_WINDOW_CHAR                     0x2A4F
#define 	BLE_UUID_SCAN_REFRESH_CHAR                             0x2A31
#define 	BLE_UUID_SERIAL_NUMBER_STRING_CHAR                     0x2A25
#define 	BLE_UUID_SOFTWARE_REVISION_STRING_CHAR                 0x2A28
#define 	BLE_UUID_SUPPORTED_NEW_ALERT_CATEGORY_CHAR             0x2A47
#define 	BLE_UUID_SUPPORTED_UNREAD_ALERT_CATEGORY_CHAR          0x2A48
#define 	BLE_UUID_SYSTEM_ID_CHAR                                0x2A23
#define 	BLE_UUID_TEMPERATURE_MEASUREMENT_CHAR                  0x2A1C
#define 	BLE_UUID_TEMPERATURE_TYPE_CHAR                         0x2A1D
#define 	BLE_UUID_TIME_ACCURACY_CHAR                            0x2A12
#define 	BLE_UUID_TIME_SOURCE_CHAR                              0x2A13
#define 	BLE_UUID_TIME_UPDATE_CONTROL_POINT_CHAR                0x2A16
#define 	BLE_UUID_TIME_UPDATE_STATE_CHAR                        0x2A17
#define 	BLE_UUID_TIME_WITH_DST_CHAR                            0x2A11
#define 	BLE_UUID_TIME_ZONE_CHAR                                0x2A0E
#define 	BLE_UUID_TX_POWER_LEVEL_CHAR                           0x2A07
#define 	BLE_UUID_CSC_FEATURE_CHAR                              0x2A5C
#define 	BLE_UUID_CSC_MEASUREMENT_CHAR                          0x2A5B
#define 	BLE_UUID_RSC_FEATURE_CHAR                              0x2A54
#define 	BLE_UUID_RSC_MEASUREMENT_CHAR                          0x2A53
#define 	CGM_MEASUREMENT_CHAR                                   0x2A6C
#define 	CGM_FEATURES_CHAR                                      0x2A6D
#define 	CGM_STATUS_CHAR                                        0x2A6E
#define 	CGM_SESSION_START_TIME_CHAR                            0x2A6F
#define 	CGM_APPLICATION_SECURITY_POINT_CHAR                    0x2A70
#define 	CGM_SPECIFIC_OPS_CONTROL_POINT_CHAR                    0x2A71
#define 	BLE_UUID_EXTERNAL_REPORT_REF_DESCR                     0x2907
#define 	BLE_UUID_REPORT_REF_DESCR                              0x2908

// ---- propriety characteristics  --------------------------------------
#define     BLE_UUID_SIMPLE_KEY_PRESS_STATE_CHAR   0xFFE1
#define     BLE_UUID_iTAG_PROPRIETARY_CHAR         0xFFE2

// ---- custom characteristics for Simple BLE Peripheral service --------
#define     BLE_UUID_CHAR_1_CHAR                   0xFFF1
#define     BLE_UUID_CHAR_2_CHAR                   0xFFF2
#define     BLE_UUID_CHAR_3_CHAR                   0xFFF3
#define     BLE_UUID_CHAR_4_CHAR                   0xFFF4
#define     BLE_UUID_CHAR_5_CHAR                   0xFFF5

// ---- custom characteristics for iTorq service -------------------------
#define     BLE_UUID_CALIBRATION_CMD_CHAR          0xFFF3
#define     BLE_UUID_YELLOW_LED_SET_POINT_CHAR     0xFFF4
#define     BLE_UUID_RED_LED_SET_POINT_CHAR        0xFFF5
#define     BLE_UUID_SHAKER_SET_POINT_CHAR         0xFFF6
#define     BLE_UUID_EVENT_COUNTER_THRESHOLD_CHAR  0xFFF7
#define     BLE_UUID_EVENT_COUNTER_CHAR            0xFFF8
#define     BLE_UUID_PGW_FW_REVISION_CHAR          0xFFF9
#define     BLE_UUID_INITIATE_FW_UPDATE_CHAR       0xFFFA
#define     BLE_UUID_CURRENT_TORQUE_CHAR           0xFFFB
#define     BLE_UUID_BUZZER_SET_POINT_CHAR         0xFFFC
#define     BLE_UUID_DIRECTION_CHAR                0xFFFE

//------------- custom characteristics definitions ----------------------
#define     BLE_UUID_IR_TEMP_SENSOR_DATA_CHAR_LONG        @"F000AA01-0451-4000-B000-000000000000"
#define     BLE_UUID_IR_TEMP_SENSOR_CONFIG_CHAR_LONG      @"F000AA02-0451-4000-B000-000000000000"
#define     BLE_UUID_IR_TEMP_SENSOR_PERIOD_CHAR_LONG      @"F000AA03-0451-4000-B000-000000000000"

#define     BLE_UUID_ACCELEROMETER_DATA_CHAR_LONG         @"F000AA11-0451-4000-B000-000000000000"
#define     BLE_UUID_ACCELEROMETER_CONFIG_CHAR_LONG       @"F000AA12-0451-4000-B000-000000000000"
#define     BLE_UUID_ACCELEROMETER_PERIOD_CHAR_LONG       @"F000AA13-0451-4000-B000-000000000000"

#define     BLE_UUID_HUMIDITY_SENSOR_DATA_CHAR_LONG       @"F000AA21-0451-4000-B000-000000000000"
#define     BLE_UUID_HUMIDITY_SENSOR_CONFIG_CHAR_LONG     @"F000AA22-0451-4000-B000-000000000000"
#define     BLE_UUID_HUMIDITY_SENSOR_PERIOD_CHAR_LONG     @"F000AA23-0451-4000-B000-000000000000"

#define     BLE_UUID_MAGNETOMETER_DATA_CHAR_LONG          @"F000AA31-0451-4000-B000-000000000000"
#define     BLE_UUID_MAGNETOMETER_CONFIG_CHAR_LONG        @"F000AA32-0451-4000-B000-000000000000"
#define     BLE_UUID_MAGNETOMETER_PERIOD_CHAR_LONG        @"F000AA33-0451-4000-B000-000000000000"

#define     BLE_UUID_BAROMETER_DATA_CHAR_LONG             @"F000AA41-0451-4000-B000-000000000000"
#define     BLE_UUID_BAROMETER_CONFIG_CHAR_LONG           @"F000AA42-0451-4000-B000-000000000000"
#define     BLE_UUID_BAROMETER_PERIOD_CHAR_LONG           @"F000AA43-0451-4000-B000-000000000000"
#define     BLE_UUID_BAROMETER_CALIBRATION_CHAR_LONG      @"F000AA44-0451-4000-B000-000000000000"

#define     BLE_UUID_GYROSCOPE_DATA_CHAR_LONG             @"F000AA51-0451-4000-B000-000000000000"
#define     BLE_UUID_GYROSCOPE_CONFIG_CHAR_LONG           @"F000AA52-0451-4000-B000-000000000000"
#define     BLE_UUID_GYROSCOPE_PERIOD_CHAR_LONG           @"F000AA53-0451-4000-B000-000000000000"

#define     BLE_UUID_TEST_DATA_CHAR_LONG                  @"F000AA61-0451-4000-B000-000000000000"
#define     BLE_UUID_TEST_CONFIG_CHAR_LONG                @"F000AA62-0451-4000-B000-000000000000"

#define     BLE_UUID_IO_DATA_CHAR_LONG                    @"F000AA65-0451-4000-B000-000000000000"
#define     BLE_UUID_IO_CONFIG_CHAR_LONG                  @"F000AA66-0451-4000-B000-000000000000"

#define     BLE_UUID_OAD_IMAGE_IDENTIFY_CHAR_LONG         @"F000FFC1-0451-4000-B000-000000000000"
#define     BLE_UUID_OAD_IMAGE_BLOCK_CHAR_LONG            @"F000FFC2-0451-4000-B000-000000000000"

#define     BLE_UUID_OPTICAL_SENSOR_DATA_CHAR_LONG        @"F000AA71-0451-4000-B000-000000000000"
#define     BLE_UUID_OPTICAL_SENSOR_CONFIG_CHAR_LONG      @"F000AA72-0451-4000-B000-000000000000"
#define     BLE_UUID_OPTICAL_SENSOR_PERIOD_CHAR_LONG      @"F000AA73-0451-4000-B000-000000000000"

#define     BLE_UUID_MOVEMENT_SENSOR_DATA_CHAR_LONG       @"F000AA81-0451-4000-B000-000000000000"
#define     BLE_UUID_MOVEMENT_SENSOR_CONFIG_CHAR_LONG     @"F000AA82-0451-4000-B000-000000000000"
#define     BLE_UUID_MOVEMENT_SENSOR_PERIOD_CHAR_LONG     @"F000AA83-0451-4000-B000-000000000000"

#define     BLE_UUID_RANGE_TEST_RSSI_CHAR_LONG            @"F000AAB1-0451-4000-B000-000000000000"
#define     BLE_UUID_RANGE_TEST_PACKET_ID_CHAR_LONG       @"F000AAB2-0451-4000-B000-000000000000"

#define     BLE_UUID_CONNECTION_PARAMS_CHAR_LONG          @"F000CCC1-0451-4000-B000-000000000000"
#define     BLE_UUID_CONNECTION_PARAMS_REQ_CHAR_LONG      @"F000CCC2-0451-4000-B000-000000000000"
#define     BLE_UUID_CONNECTION_DISCONNECT_REQ_CHAR_LONG  @"F000CCC3-0451-4000-B000-000000000000"

#define     BLE_UUID_REGISTER_DATA_CHAR_LONG              @"F000AC01-0451-4000-B000-000000000000"
#define     BLE_UUID_REGISTER_CONFIG_CHAR_LONG            @"F000AC02-0451-4000-B000-000000000000"
#define     BLE_UUID_REGISTER_PERIOD_CHAR_LONG            @"F000AC03-0451-4000-B000-000000000000"




#endif
