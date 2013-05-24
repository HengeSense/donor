//
//  HSStationInfoTest.m
//  Donor
//
//  Created by Sergey Seroshtan on 24.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationInfoTest.h"

#import "HSStationInfo.h"

@implementation HSStationInfoTest

- (void) test_archivingUnarchiving {
    // PFObject properties base values
    NSString * const kPFObject_objectId = @"ydSf45HGsdF835";

    // HSStationInfo properties base values
    NSNumber * const kBaseStationInfo_localDistance = @3.56;
    NSDate * const kBaseStationInfo_localCreatedAt = [NSDate date];
    NSDate * const kBaseStationInfo_localUpdatedAt =
            [NSDate dateWithTimeInterval:1 * 60 * 60 sinceDate:kBaseStationInfo_localCreatedAt];
    NSString * const kBaseStationInfo_address = @"Some address";
    NSNumber * const kBaseStationInfo_district_id = @22;
    NSString * const kBaseStationInfo_district_name = @"District name";
    NSNumber * const kBaseStationInfo_lat = @33.35663;
    NSNumber * const kBaseStationInfo_lon = @46.35454;
    NSString * const kBaseStationInfo_name = @"Station name";
    NSNumber * const kBaseStationInfo_region_id = @11;
    NSString * const kBaseStationInfo_region_name = @"Region name";
    NSString * const kBaseStationInfo_shortaddress = @"Short address";
    NSString * const kBaseStationInfo_site = @"Site";
    NSString * const kBaseStationInfo_town = @"Town";
    NSString * const kBaseStationInfo_work_time = @"Work time";
    NSString * const kBaseStationInfo_phone = @"Phone";
    NSString * const kBaseStationInfo_chief = @"Chief";

    
    HSStationInfo *baseStationInfo = [[HSStationInfo alloc] init];
    // PFObject properties
    baseStationInfo.objectId = kPFObject_objectId;
    
    // HSStationInfo local properties
    baseStationInfo.distance = kBaseStationInfo_localDistance;
    baseStationInfo.createdAt = kBaseStationInfo_localCreatedAt;
    baseStationInfo.updatedAt = kBaseStationInfo_localUpdatedAt;

    // HSStationInfo remote properties
    baseStationInfo.address = kBaseStationInfo_address;
    baseStationInfo.district_id = kBaseStationInfo_district_id;
    baseStationInfo.district_name = kBaseStationInfo_district_name;
    baseStationInfo.lat = kBaseStationInfo_lat;
    baseStationInfo.lon = kBaseStationInfo_lon;
    baseStationInfo.name = kBaseStationInfo_name;
    baseStationInfo.region_id = kBaseStationInfo_region_id;
    baseStationInfo.region_name = kBaseStationInfo_region_name;
    baseStationInfo.shortaddress = kBaseStationInfo_shortaddress;
    baseStationInfo.site = kBaseStationInfo_site;
    baseStationInfo.town = kBaseStationInfo_town;
    baseStationInfo.work_time = kBaseStationInfo_work_time;
    baseStationInfo.phone = kBaseStationInfo_phone;
    baseStationInfo.chief = kBaseStationInfo_chief;
    
    // Archiving
    NSString * const kBaseStationInfo_PersistantKey = @"baseStationInfo";
    NSData *baseStationInfoData = [NSKeyedArchiver archivedDataWithRootObject:baseStationInfo];
    [[NSUserDefaults standardUserDefaults] setObject:baseStationInfoData forKey:kBaseStationInfo_PersistantKey];
    
    BOOL setKeySyncResult = [[NSUserDefaults standardUserDefaults] synchronize];
    STAssertTrue(setKeySyncResult, @"User defaults syncronization should be success");
    
    // Unarchiving
    NSData *uutStationInfoData = [[NSUserDefaults standardUserDefaults] objectForKey:kBaseStationInfo_PersistantKey];
    HSStationInfo *uutStationInfo = [NSKeyedUnarchiver unarchiveObjectWithData:uutStationInfoData];
    
    // Validating
    STAssertEqualObjects(uutStationInfo.objectId, kPFObject_objectId,
            @"Property 'objectId' is invalid");
    
    STAssertEqualObjects(uutStationInfo.distance, kBaseStationInfo_localDistance,
            @"Property 'localDistance' is invalid");
    STAssertEqualObjects(uutStationInfo.createdAt, kBaseStationInfo_localCreatedAt,
            @"Property 'localCreatedAt' is invalid");
    STAssertEqualObjects(uutStationInfo.updatedAt, kBaseStationInfo_localUpdatedAt,
            @"Property 'localUpdatedAt' is invalid");
    STAssertEqualObjects(uutStationInfo.address, kBaseStationInfo_address,
            @"Property 'address' is invalid");
    STAssertEqualObjects(uutStationInfo.district_id, kBaseStationInfo_district_id,
            @"Property 'district_id' is invalid");
    STAssertEqualObjects(uutStationInfo.district_name, kBaseStationInfo_district_name,
            @"Property 'ditrict_name' is invalid");
    STAssertEqualObjects(uutStationInfo.lat, kBaseStationInfo_lat,
            @"Property 'lat' is invalid");
    STAssertEqualObjects(uutStationInfo.lon, kBaseStationInfo_lon,
            @"Property 'lon' is invalid");
    STAssertEqualObjects(uutStationInfo.name, kBaseStationInfo_name,
            @"Property 'name' is invalid");
    STAssertEqualObjects(uutStationInfo.region_id, kBaseStationInfo_region_id,
            @"Property 'region_id' is invalid");
    STAssertEqualObjects(uutStationInfo.region_name, kBaseStationInfo_region_name,
            @"Property 'region_name' is invalid");
    STAssertEqualObjects(uutStationInfo.shortaddress, kBaseStationInfo_shortaddress,
            @"Property 'shortaddress' is invalid");
    STAssertEqualObjects(uutStationInfo.site, kBaseStationInfo_site,
            @"Property 'site' is invalid");
    STAssertEqualObjects(uutStationInfo.town, kBaseStationInfo_town,
            @"Property 'town' is invalid");
    STAssertEqualObjects(uutStationInfo.work_time, kBaseStationInfo_work_time,
            @"Property 'work_time' is invalid");
    STAssertEqualObjects(uutStationInfo.phone, kBaseStationInfo_phone,
            @"Property 'phone' is invalid");
    STAssertEqualObjects(uutStationInfo.chief, kBaseStationInfo_chief,
            @"Property 'chief' is invalid");
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBaseStationInfo_PersistantKey];
    BOOL removeKeySyncResult = [[NSUserDefaults standardUserDefaults] synchronize];
    STAssertTrue(removeKeySyncResult, @"User defaults syncronization should be success");   
}

@end
