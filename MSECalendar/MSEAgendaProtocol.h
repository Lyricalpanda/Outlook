//
//  MSEAgendaProtocol.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

@protocol MSEAgendaProtocol <NSObject>

@optional

- (void) dateScrolled:(NSDate *)date;
- (void) decrementedDate;
- (void) incrementedDate;
@end
