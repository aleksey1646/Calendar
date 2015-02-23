//
//  ClockProtocol.h
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#ifndef emptyProject_ClockProtocol_h
#define emptyProject_ClockProtocol_h

@protocol ClockProtocol <NSObject>

- (void)setHours:(int)hours minutes:(int)minutes seconds:(int)seconds;

@end

#endif
