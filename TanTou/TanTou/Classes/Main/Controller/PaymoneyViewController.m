//
//  PaymoneyViewController.m
//  TanTou
//
//  Created by Sharon on 2017/8/22.
//  Copyright © 2017年 bailing. All rights reserved.
//打赏页面
#import "PaymoneyViewController.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
@interface PaymoneyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property(assign)BOOL isHaveDian;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaobtn;
@property (nonatomic,copy)NSString *payType; //支付的方法
@property (weak, nonatomic) IBOutlet UIImageView *jieshao;
@property (weak, nonatomic) IBOutlet UIButton *weixinbtn;
@end
@implementation PaymoneyViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"支持";
}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    _jieshao.hidden=YES;
//    _weixinbtn.selected=YES;
////    _zhifubaobtn.selected=YES;
////    [_weixinbtn setBackgroundImage:[UIImage imageNamed:@"weixin+"] forState:UIControlStateSelected];
//    self.payType=@"1";
//    self.view.backgroundColor=[UIColor whiteColor];
//    [self createnav];
//    //输入框中是否有个叉号，在什么时候显示，用于编辑时出现删除
//    self.moneyTF.clearButtonMode =
//    UITextFieldViewModeWhileEditing;
////    数字键盘 有数字和小数点
//    _moneyTF.keyboardType=UIKeyboardTypeDecimalPad;
//    _moneyTF.delegate=self;
//    _moneyTF.tag=1;
//
//
//    self.messageTF.clearButtonMode =
//    UITextFieldViewModeWhileEditing;
//    //return键变成什么键
//    _messageTF.returnKeyType =UIReturnKeyDone;
//    _messageTF.tag=2;
//    _messageTF.delegate=self;
//
//
//
//
//}
//-(void)createnav
//{
//    self.navigationController.navigationBar.hidden=NO;
//    self.title=@"支持";
////    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
////        self.edgesForExtendedLayout = UIRectEdgeNone;
////    }
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
//       NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    UIImage* image=[UIImage imageNamed:@"导航栏"];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setImage:[UIImage imageNamed:@"左-1"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"左-1"] forState:UIControlStateHighlighted];
//    [backBtn sizeToFit];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//
//}
//
//-(void)back
//{
//    [self.navigationController popViewControllerAnimated:YES];
//
//}
//
//- (IBAction)quedingAction:(UIButton *)sender {
//    sender.selected=!sender.selected;
//
//    NSLog(@"点击确定");
//    if(_moneyTF.text.length==0)
//    {
//        [MBProgressHUD showError:@"请输入金额!"];
//        return;
//    }
//    NSString*moneg=[NSString stringWithFormat:@"%@",_moneyTF.text];
//    NSLog(@"==========----====%@",moneg) ;
//    NSString*message=[NSString stringWithFormat:@"%@",_messageTF.text];
//    NSLog(@"==========----====%@",message) ;
//    NSLog(@"zhifufangshi    %@",self.payType);
//    __weak typeof(self) weakSelf = self;
//    if ([weakSelf.payType isEqualToString:@"1"])
//    {
//        if ([[[DDUtil shareUtil]getcurrentStatus] isEqualToString:@"NotNet"]) {
//            [MBProgressHUD showError:@"网络未连接"];
//            return;
//        }
//          NSLog(@"维信支付");
//        NSMutableDictionary *param = [NSMutableDictionary dictionary];
//        param[@"way"]=@"wxpay";
//        param[@"money"]=moneg;
//        param[@"note"]=message;
//
//        [[DDNetworkTool sharedNetworkTool]POST:[NSString stringWithFormat:@"%@/Tantou/Reward/unifiedOrder",DDBasicUrl] parameters:param success:^(id responseObject) {
//            NSMutableDictionary*dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//            NSLog(@"-------------%@",dict);
//            NSString*msg=[dict objectForKey:@"msg"];
//            NSLog(@"=============%@",msg);
//            NSNumber*stamp=dict[@"result"][@"data"][@"timestamp"];
//            NSLog(@"999999999      %@",stamp);
//            if([msg isEqualToString:@"已生成预支付订单"])
//            {
//                PayReq *request = [[PayReq alloc] init];
//                request.partnerId=[[[dict valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"partnerid"];
//                request.prepayId= [[[dict valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"prepayid"];
//                request.package = @"Sign=WXPay";
//                request.nonceStr= [[[dict valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"noncestr"];
//                request.timeStamp= [[[[dict valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"timestamp"] intValue];
//                request.sign= [[[dict valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"sign"];
//                [WXApi sendReq:request];
//            }else
//            {
//                NSLog(@"生成订单失败");
//            }
//
//        } failure:^(NSError *error) {
//             [MBProgressHUD showError:@"请求失败"];
//        }];
//
//    }else{
//        if ([[[DDUtil shareUtil]getcurrentStatus] isEqualToString:@"NotNet"]) {
//            [MBProgressHUD showError:@"网络未连接"];
//            return;
//        }
//
//         NSLog(@"支付宝支付");
//             NSMutableDictionary *param = [NSMutableDictionary dictionary];
//        param[@"way"]=@"alipay";
//        param[@"money"]=moneg;
//        param[@"note"]=message;
//        [[DDNetworkTool sharedNetworkTool]POST:[NSString stringWithFormat:@"%@/Tantou/Reward/unifiedOrder",DDBasicUrl] parameters:param success:^(id responseObject) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//            NSLog(@"----------=======----hehe%@",dict);
//            NSString *msg = dict[@"msg"];
//              NSLog(@"---------haha%@",msg);
//            if([msg isEqualToString:@"发起支付成功"])
//            {
//                NSMutableDictionary *param = [NSMutableDictionary dictionary];
//                NSString*order_id=dict[@"order_id"];
//                param[@"order_id"]=order_id;
//                NSString* str=dict[@"result"][@"data"];
//                [[AlipaySDK defaultService]payOrder:str fromScheme:@"tantou" callback:^(NSDictionary *resultDic) {
//
//                    NSLog(@"resultDic:%@",resultDic);
//
//                }];
//
//                        }else
//            {
//                NSLog(@"发起支付失败");
//            }
//        } failure:^(NSError *error) {
//            [MBProgressHUD showError:@"请求失败"];
//
//
//        }];
//    }
//
//}
//
//- (IBAction)zhichiAction:(UIButton *)sender {
//
//    sender.selected=!sender.selected;
//    if(sender.selected){
//
//        _jieshao.hidden=NO;
//        }else
//    {
//        _jieshao.hidden=YES;
//    }
//
//
//}
//
//- (IBAction)pay:(UIButton *)sender {
//    sender.selected=!sender.selected;
//  if(sender.selected)
//  {
////      NSLog(@"-----%@",sender.tag);
//      if(sender.tag==1)
//      {
//          UIButton*btn=[self.view viewWithTag:2];
//          btn.selected=NO;
//          self.payType=@"1";
//          NSLog(@"=================%@",self.payType);
//
//      }else
//      {
//           UIButton*btn=[self.view viewWithTag:1];
//          btn.selected=NO;
//           self.payType=@"2";
//          NSLog(@"=================%@",self.payType);
//
//      }
//
//  }
//}
//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    [super touchesBegan:touches withEvent:event];
//    [self.view endEditing:YES];
//}
//
//
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if(textField.tag==2)
//    {
//    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
//    return YES;
//    }
//    return YES;
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//
//    /*
//     * 不能输入.0-9以外的字符。
//     * 设置输入框输入的内容格式
//     * 只能有一个小数点
//     * 小数点后最多能输入两位
//     * 如果第一位是.则前面加上0.
//     * 如果第一位是0则后面必须输入点，否则不能输入。
//     */
//    if(textField.tag==1)
//    {
//    // 判断是否有小数点
//    if ([textField.text containsString:@"."]) {
//        self.isHaveDian = YES;
//    }else{
//        self.isHaveDian = NO;
//    }
//
//    if (string.length > 0) {
//
//        //当前输入的字符
//        unichar single = [string characterAtIndex:0];
//        NSLog(@"single = %c",single);
//
//        // 不能输入.0-9以外的字符
//        if (!((single >= '0' && single <= '9') || single == '.'))
//        {
//          [MBProgressHUD showError:@"您的输入格式不正确"];
//            return NO;
//        }
//
//        // 只能有一个小数点
//        if (self.isHaveDian && single == '.') {
//              [MBProgressHUD showError:@"最多只能输入一个小数点"];
//
//            return NO;
//        }
//
//        // 如果第一位是.则前面加上0.
//        if ((textField.text.length == 0) && (single == '.')) {
//            textField.text = @"0";
//        }
//
//        // 如果第一位是0则后面必须输入点，否则不能输入。
//        if ([textField.text hasPrefix:@"0"]) {
//            if (textField.text.length > 1) {
//                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
//                if (![secondStr isEqualToString:@"."]) {
//                      [MBProgressHUD showError:@"第二个字符需要是小数点"];
//                    return NO;
//                }
//            }else{
//                if (![string isEqualToString:@"."]) {
//                   [MBProgressHUD showError:@"第二个字符需要是小数点"];
//                    return NO;
//                }
//            }
//        }
//
//        // 小数点后最多能输入两位
//        if (self.isHaveDian) {
//            NSRange ran = [textField.text rangeOfString:@"."];
//            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
//            if (range.location > ran.location) {
//                if ([textField.text pathExtension].length > 1) {
//                  [MBProgressHUD showError:@"小数点后最多有两位小数"];
//                    return NO;
//                }
//            }
//        }
//        NSLog(@"------=======%@",textField.text);
//    }
//        return YES;
//}else
//
//    NSLog(@"------=======%@",textField.text);
//    return YES;
//}
@end
