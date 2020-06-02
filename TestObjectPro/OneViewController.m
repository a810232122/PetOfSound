//
//  OneViewController.m
//  TestObjectPro
//
//  Created by 小七 on 2019/12/9.
//  Copyright © 2019 com.czcb. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)testF {
    NSLog(@"12312312");
    
}

- (void)testDF:(NSString *)st string:(NSString *)tf {
    NSLog(@"12312312  %@   %@",st,tf);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
