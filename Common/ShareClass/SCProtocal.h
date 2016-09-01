//
//  SCProtocal.h
//  sma11case
//
//  Created by sma11case on 10/10/15.
//  Copyright © 2015 sma11case. All rights reserved.
//

#import "Config.h"

@protocol SCSetEnumeration <NSObject>
@required
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
@end

@protocol SCArrayEnumeration <NSObject>
@required
- (id)objectAtIndexedSubscript: (NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
@end

@protocol SCDictionaryEnumeration <NSObject>
@required
- (id)objectForKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
@end


