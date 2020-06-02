//
//  WeakScriptMessageDelegate.m
//  TestObjectPro
//
//  Created by 小七 on 2020/3/2.
//  Copyright © 2020 com.czcb. All rights reserved.
//

#import "WeakScriptMessageDelegate.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "ViewController.h"

@implementation WeakScriptMessageDelegate

+ (WeakScriptMessageDelegate *)sharedInstance
{
    static WeakScriptMessageDelegate *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[WeakScriptMessageDelegate alloc] init];
        }
    });
    
    return instance;
}

- (id)getSecretKey:(id)jsonString {
    NSLog(@"jsonString %@",jsonString);
    
    
    NSDictionary *dataDic;
    dataDic = @{@"key":@"m53TzVkpa0OB4+zAawoUDxf+gYmPfy77/5HYbJ6oKHEKcZ264wPVjw==",@"userId":@"CZ1000200202002"};
    
    return [self convertToJsonData:dataDic];
}

- (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

- (id)openUrl:(id)jsonString {
    NSLog(@"%@",jsonString);
    
    
    NSArray *dataArr = [NSArray arrayWithArray:jsonString];
    NSString *url = dataArr[0];
    BOOL islogined = [dataArr[1] boolValue];
    NSLog(@"url %@  islogined %ld",url,islogined);
    dispatch_async(dispatch_get_main_queue(), ^{
        ViewController *vc = [[ViewController alloc] init];
        NSString *encodedString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
        vc.currentUrl = encodedString;
        UIViewController *vc1 = [self getCurrentVC];
        [vc1.navigationController pushViewController:vc animated:YES];
    });
    
    return nil;
    
}

- (id)getCurrentAppVersion:(id)jsonString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (id)showShare:(id)jsonString {
    
    return nil;
}

 //MARK:- 获取当前控制器
//static func getCurrentVC() -> UIViewController {
//
//    var vc = UIApplication.shared.keyWindow?.rootViewController
//
//    while(true) {
//        if (vc?.isKind(of: UITabBarController.self))! {
//            vc = (vc as! UITabBarController).selectedViewController
//        }else if (vc?.isKind(of: UINavigationController.self))!{
//            vc = (vc as! UINavigationController).visibleViewController
//        }else if ((vc?.presentedViewController) != nil){
//            vc =  vc?.presentedViewController
//        } else {
//            break
//        }
//    }
//
//    return vc!
//}
//获取到当前显示界面的controller
- (UIViewController *)getCurrentVC{
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];

    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}
- (void)runTests
{
    unsigned int count;
    Method *methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);

//        if ([name hasPrefix:@"test"])
//        NSLog(@"方法 名字 ==== %@",name);
//        if (name)
//        {
//            //avoid arc warning by using c runtime
//            objc_msgSend(self, selector);
//        }
        NSLog(@"functionName  %@", name);
    }
    free(methods);
}

@end
