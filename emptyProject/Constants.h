//
//  Constants.h
//  emptyProject
//
//  Created by Katushka Mazalova on 2/23/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <Foundation/Foundation.h>

/* API commands*/
#define serverURL @"http://grope.io/"
#define placesCommand @"api/places.php"
#define circumferenceEarth 40075160
#define mapRadius 13
#define inchMetres 0.0254
#define arcConvert 0.000277777778

@interface Constants : NSObject
+(NSDictionary*)getConstDictionary;
@end
