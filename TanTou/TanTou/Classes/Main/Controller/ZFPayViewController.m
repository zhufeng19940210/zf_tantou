//
//  ZFPayViewController.m
//  TanTou
//
//  Created by bailing on 2017/12/14.
//  Copyright © 2017年 bailing. All rights reserved.
//
#import "ZFPayViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "ZXSUtil.h"
#import "ZXSNetworkTool.h"
@interface ZFPayViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UIButton *wenxinBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *myAlterView;
@property (nonatomic,copy)  NSString *payTag;
@property (nonatomic,assign)BOOL isHaveDian;
@end
@implementation ZFPayViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支持";
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //默认是微信
    self.payTag = @"1";
    self.moneyTF.clearButtonMode =
    UITextFieldViewModeWhileEditing;
    self.moneyTF.keyboardType=UIKeyboardTypeDecimalPad;
    self.moneyTF.delegate=self;
    self.moneyTF.tag=1;
    self.messageTF.clearButtonMode =
    UITextFieldViewModeWhileEditing;
    self.messageTF.returnKeyType =UIReturnKeyDone;
    self.messageTF.tag=2;
    self.messageTF.delegate=self;
}
//微信
- (IBAction)onClickWenxinBtn:(UIButton *)sender {
    [self.wenxinBtn setImage:[UIImage imageNamed:@"weixin+"] forState:UIControlStateNormal];
    [self.zhifubaoBtn setImage:[UIImage imageNamed:@"zhifubao-"] forState:UIControlStateNormal];
    self.payTag = @"1";
}
//支付宝
- (IBAction)onClickZhifubaoBtn:(UIButton *)sender {
    [self.wenxinBtn setImage:[UIImage imageNamed:@"weixin-"] forState:UIControlStateNormal];
    [self.zhifubaoBtn setImage:[UIImage imageNamed:@"zhifubao+"] forState:UIControlStateNormal];
    self.payTag = @"2";
}
//显示详情
- (IBAction)onClickShowDetailBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.myAlterView.hidden = NO;
    }else{
        self.myAlterView.hidden = YES;
    }
}
// 支付
- (IBAction)onClickPayOKBtn:(UIButton *)sender {
    NSString *money = self.moneyTF.text;
    NSLog(@"money:%@",money);
    NSString *message = self.messageTF.text;
    if ([money isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入金额!"];
        return;
    }
    //支付的方式
    if ([self.payTag isEqualToString:@"1"]) {
        //微信支付
        if (![[[ZXSUtil shareUtil]getcurrentStatus] isEqualToString:@"NotNet"]) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"way"]=@"wxpay";
            param[@"money"]=money;
            param[@"note"]=message;
            [[ZXSNetworkTool sharedNetworkTool]POST:[NSString stringWithFormat:@"%@/Tantou/Reward/unifiedOrder",ZXSBasicURL] parameters:param success:^(id responseObject) {
                NSMutableDictionary*dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                NSLog(@"-------------%@",dict);
                NSString*msg=[dict objectForKey:@"msg"];
                NSLog(@"=============%@",msg);
                NSNumber*stamp=dict[@"result"][@"data"][@"timestamp"];
                NSLog(@"999999999      %@",stamp);
                if([msg isEqualToString:@"已生成预支付订单"])
                {
                    PayReq *request = [[PayReq alloc] init];
                    request.partnerId=[[[dict valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"partnerid"];
                    request.prepayId= [[[dict valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"prepayid"];
                    request.package = @"Sign=WXPay";
                    request.nonceStr= [[[dict valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"noncestr"];
                    request.timeStamp= [[[[dict valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"timestamp"] intValue];
                    request.sign= [[[dict valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"sign"];
                    [WXApi sendReq:request];
                }else
                {
                    [MBProgressHUD showError:@"生成订单失败" toView:self.view];
                    return;
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"请求失败"];
                return ;
            }];
        }else{
            [MBProgressHUD showError:@"网络未连接" toView:self.view];
            return;
        }
    }else{
        //支付宝支付
        if (![[[ZXSUtil shareUtil]getcurrentStatus] isEqualToString:@"NotNet"]) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"way"]=@"alipay";
            param[@"money"]=money;
            param[@"note"]=message;
            [[ZXSNetworkTool sharedNetworkTool]POST:[NSString stringWithFormat:@"%@/Tantou/Reward/unifiedOrder",ZXSBasicURL] parameters:param success:^(id responseObject) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                NSLog(@"----------=======----hehe%@",dict);
                NSString *msg = dict[@"msg"];
                NSLog(@"---------haha%@",msg);
                if ([msg isEqualToString:@"发起支付成功"]) {
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    NSString*order_id=dict[@"order_id"];
                    param[@"order_id"]=order_id;
                    NSString* str=dict[@"result"][@"data"];
                    [[AlipaySDK defaultService]payOrder:str fromScheme:@"tantou" callback:^(NSDictionary *resultDic) {
                        NSLog(@"resultDic:%@",resultDic);
                    }];
                }else{
                    [MBProgressHUD showError:@"发起支付失败" toView:self.view];
                    return;
                }
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"请求失败"];
                return;
            }];
        }else{
            [MBProgressHUD showError:@"网络未连接" toView:self.view];
            return;
        }
    }
}
#pragma mark 取消第一响应者
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
#pragma mark - uitextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag==2)
    {
        [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
        return YES;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    if(textField.tag==1)
    {
        // 判断是否有小数点
        if ([textField.text containsString:@"."]) {
            self.isHaveDian = YES;
        }else{
            self.isHaveDian = NO;
        }
        if (string.length > 0) {
            
            //当前输入的字符
            unichar single = [string characterAtIndex:0];
            NSLog(@"single = %c",single);
            
            // 不能输入.0-9以外的字符
            if (!((single >= '0' && single <= '9') || single == '.'))
            {
                [MBProgressHUD showError:@"您的输入格式不正确"];
                return NO;
            }
            
            // 只能有一个小数点
            if (self.isHaveDian && single == '.') {
                [MBProgressHUD showError:@"最多只能输入一个小数点"];
                
                return NO;
            }
            
            // 如果第一位是.则前面加上0.
            if ((textField.text.length == 0) && (single == '.')) {
                textField.text = @"0";
            }
            
            // 如果第一位是0则后面必须输入点，否则不能输入。
            if ([textField.text hasPrefix:@"0"]) {
                if (textField.text.length > 1) {
                    NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                    if (![secondStr isEqualToString:@"."]) {
                        [MBProgressHUD showError:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        [MBProgressHUD showError:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }
            }
            
            // 小数点后最多能输入两位
            if (self.isHaveDian) {
                NSRange ran = [textField.text rangeOfString:@"."];
                // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
                if (range.location > ran.location) {
                    if ([textField.text pathExtension].length > 1) {
                        [MBProgressHUD showError:@"小数点后最多有两位小数"];
                        return NO;
                    }
                }
            }
            NSLog(@"------=======%@",textField.text);
        }
        return YES;
    }else
        
        NSLog(@"------=======%@",textField.text);
    return YES;
}
@end
