//
//  QJUIUtil.m
//  QJWeibo
//
//  Created by ShaoJun on 2017/5/28.
//  Copyright © 2017年 ShaoJun. All rights reserved.
//

#import "QJUIUtil.h"
#import "MBProgressHUD.h"

@implementation QJUIUtil

+(void)showToast:(NSString *)text inView:(UIView *)view{
    if(!text || !view){
        return;
    }
   
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    [hud hide:YES afterDelay:1.5];
}

@end
