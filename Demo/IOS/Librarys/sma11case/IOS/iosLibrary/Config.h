//
//  Config.h
//  sma11case
//
//  Created by sma11case on 9/12/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "../../Common/ShareClass/ShareClass.h"

#define NVC_TYPE_SYS 1
#define NVC_TYPE_SC  2

#define NVC_TYPE NVC_TYPE_SYS

#if (NVC_TYPE == NVC_TYPE_SYS)
#define USE_SYS_NVC 1
#endif

#if (NVC_TYPE == NVC_TYPE_SC)
#define USE_SC_NVC     1
#endif

