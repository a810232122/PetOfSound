//
//  ViewController.m
//  TestObjectPro
//
//  Created by 小七 on 2019/12/9.
//  Copyright © 2019 com.czcb. All rights reserved.
//

#import "ViewController.h"
#import "BMChineseSort.h"
#import "Person.h"
#import <WebKit/WebKit.h>
#import "WeakScriptMessageDelegate.h"
#import <UserNotifications/UNNotificationRequest.h>

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *weWebView;

@end

@implementation ViewController

//创建一个控制器，在控制器的ViewDidLoad方法中我们写在如下代码
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.weWebView];
    // 此处加载的是本地HTML文件
    
    //https://test.tamp.com.cn/czcb_web/czcb/#/index?merchantId=8850e6bedd9e46319beb1cb40579f39f
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"];
//
//
//
//    if (path) {
//        NSURL *fileURL = [NSURL fileURLWithPath:path];
//        [self.weWebView loadRequest:[NSURLRequest requestWithURL:fileURL]];
//    }
    
    NSURL *url = [NSURL URLWithString:@"https://test.tamp.com.cn/czcb_web/czcb/#/index?merchantId=8850e6bedd9e46319beb1cb40579f39f"];
    if (self.currentUrl) {
        url = [NSURL URLWithString:self.currentUrl];
    }
    [self.weWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"123123" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(gotoNextView) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 22, 22);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.weWebView.configuration.userContentController addScriptMessageHandler:self name:@"call"];
    
    
}

- (void)gotoNextView {
//    NSArray *array = [NSArray array];
//
//    NSLog(@"%@",array[1]);
    
    
    
    
    
    
}

// 懒加载创建一个WKWebView
- (WKWebView *)weWebView {
    if (!_weWebView) {
        // 进行配置控制器
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        // 初始化WKWebView
        _weWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, 375, 667) configuration:configuration];
        _weWebView.navigationDelegate = self;
        _weWebView.UIDelegate = self;
        
    }
    return _weWebView;
}
// 获取js 里面的提示
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// js 信息的交流
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 交互。可输入的文本。
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    NSLog(@"%@---%@",prompt,defaultText);
    
    NSData *jsonData = [prompt dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    NSString *methodName = [NSString stringWithFormat:@"%@:",[dic objectForKey:@"methodName"]];
    NSString *params = [dic objectForKey:@"params"];
    WeakScriptMessageDelegate *delegate = [WeakScriptMessageDelegate sharedInstance];
//    [delegate runTests];
    SEL functionName = NSSelectorFromString(methodName);
    if ([delegate respondsToSelector:functionName]) {
        id result = [delegate performSelector:functionName withObject:params];
        if (result) {
            completionHandler(result);//这里就是要返回给JS的返回值
        } else {
            completionHandler(nil);
        }
        
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
    NSString *url = navigationAction.request.URL.absoluteString;
//    [self.weWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    NSLog(@"%@",url);
    
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    // 页面开始加载时调用
    //jsApi的注册，同时H5的页面显示也依赖这段代码
    NSString *jsFile = @"WKBridge";
    NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:jsFile ofType:@"js"];
    NSString *jsStr = [[NSString alloc] initWithContentsOfFile:jsFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *methodList = @[@"getSecretKey",@"openUrl",@"showShare",@"getCurrentAppVersion"];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:methodList options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsStr = [jsStr stringByReplacingOccurrencesOfString:@"window.callableMethods" withString:jsonString];
    [webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    }];
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
    
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    //设置页面title
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        self.title = (NSString *)result;
    }];
    
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{

}


@end
