//
//  Person.h
//  TestObjectPro
//
//  Created by 小七 on 2019/12/25.
//  Copyright © 2019 com.czcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isSpecial;

@end

NS_ASSUME_NONNULL_END
