//
//  main.m
//  osxCMD
//
//  Created by lianlian on 8/28/16.
//
//

#import <Foundation/Foundation.h>
#import "../Librarys/sma11case/OSX/osxLibrary/staticLibrary_OSX.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        // insert code here...
        
        MLog(@"startup");
        
        NSString *path = @"/tmp/sss.sqlite";
        
        FMDatabase *db = [FMDatabase databaseWithPath:path];
        
        [db open];
        [db createTable:@"test" fromTypeList:@{@"text":kDBColumnTypeText}];
        
        id root = NewClass(NSObject);
        
        {
            WeakArray *wa = [[WeakArray alloc] initWithCapacity:8];
            [wa addObject:root autoRemove:YES];
        }
        
        WeakArray *wa = [[WeakArray alloc] initWithCapacity:8];
        
        [wa removeAssociatedObjects];
        
        [wa addDeallocBlock:^{
            BreakPointHere;
        }];
        
        {
            id o1 = NewClass(NSObject);
            [wa addObject:o1 autoRemove:YES];
            [wa addObject:o1 autoRemove:YES];
            [wa addObject:o1 autoRemove:YES];
            
            id o2 = NewClass(NSObject);
            [wa addObject:o2 autoRemove:YES];
            
            LogAnything(wa);
            BreakPointHere;
        }
        
        LogAnything(wa);
        BreakPointHere;
        
    }
    
    return 0;
}
