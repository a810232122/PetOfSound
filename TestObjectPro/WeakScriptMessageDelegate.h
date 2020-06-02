//
//  WeakScriptMessageDelegate.h
//  TestObjectPro
//
//  Created by 小七 on 2020/3/2.
//  Copyright © 2020 com.czcb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeakScriptMessageDelegate : NSObject

- (id)getSecretKey:(id)jsonString;

- (id)openUrl:(id)jsonString;

+ (WeakScriptMessageDelegate *)sharedInstance;

- (void)runTests;

- (id)showShare:(id)jsonString;

- (id)getCurrentAppVersion:(id)jsonString;

@end

NS_ASSUME_NONNULL_END
