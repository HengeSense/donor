//
//  StationsDefs.h
//  Donor
//
//  Created by Eugine Korobovsky on 12.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#ifndef Donor_StationsDefs_h
#define Donor_StationsDefs_h

#define PRINT_FRAME(str, frame) NSLog(@"%@: %.0f, %.0f, %.0f, %.0f", str, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
#define PRINT_SIZE(str, size)   NSLog(@"%@: %.0fx%.0f", str, size.width, size.height)

#define RGBA_COLOR(r, g, b, a) [UIColor colorWithRed:((float)r)/255.0 green:((float)g)/255.0 blue:((float)b)/255.0 alpha:(float)a]
#define DONOR_RED_COLOR RGBA_COLOR(173, 31, 2, 1.0)
#define DONOR_GREEN_COLOR RGBA_COLOR(10, 97, 103, 1.0)
#define DONOR_TEXT_COLOR RGBA_COLOR(95, 90, 86, 1.0)
#define DONOR_STATIONS_SEPARATOR_TEXT_COLOR RGBA_COLOR(202, 177, 162, 1.0)
#define DONOR_SEARCH_FIELD_TEXT_COLOR RGBA_COLOR(136, 105, 81, 1.0)

#define FONT_WITH_SIZE(x) [UIFont fontWithName:@"Helvetica" size:x]
#define BOLD_FONT_WITH_SIZE(x) [UIFont fontWithName:@"Helvetica-Bold" size:x]

#endif
