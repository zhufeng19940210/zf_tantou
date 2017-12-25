//
//  FeedbackViewController1.m
//  The  probe
//
//  Created by Sharon on 2017/8/7.
//  Copyright © 2017年 daodian. All rights reserved.
//反馈页面
#import "FeedbackViewController1.h"
#import "YJTComposeView.h"
#define  bannerH  ScreenH/10
@interface FeedbackViewController1 ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet YJTComposeView *suggestionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end
@implementation FeedbackViewController1
- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"Banner viewWillDisappear");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"反馈";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"当前系统版本:%@",app_Version];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.suggestionView.placeholder = @"请留下宝贵的意见和建设,并留下你的联系方式，我们将不断努力改进(不少于5个字)";
    self.suggestionView.delegate = self;
    self.suggestionView.layer.cornerRadius = 10.0f;
    self.suggestionView.layer.masksToBounds = YES;
    self.suggestionView.returnKeyType = UIReturnKeyDone;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (IBAction)btnAction:(UIButton *)sender {
    [self.suggestionView resignFirstResponder];
    NSString *suggestionStr = self.suggestionView.text;
    if (suggestionStr.length ==0 || [suggestionStr isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入反馈内容" toView:self.view];
        return;
    }
    if (suggestionStr.length<5) {
        [MBProgressHUD showError:@"反馈内容不能少于5个字" toView:self.view];
        return;
    }
    NSMutableDictionary *pararm = [NSMutableDictionary dictionary];
    pararm[@"action"] =@"complain";
    pararm[@"complain"] = suggestionStr;
    __weak typeof(self) WeakSelf = self;
    [MBProgressHUD showMessage:@"提交中..." toView:self.view];
    [[ZXSNetworkTool sharedNetworkTool]POST:[NSString stringWithFormat:@"%@/Api/Users/tantou",ZXSBasicURL] parameters:pararm success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"dict:%@",dict);
        NSString *msg = dict[@"msg"];
        if ([msg isEqualToString:@"反馈成功"]) {
                 [MBProgressHUD showSuccess:@"反馈成功" toView:WeakSelf.view];
                WeakSelf.suggestionView.text = @"";
                WeakSelf.suggestionView.placeholder = @"请留下宝贵的意见和建设,并留下你的联系方式，我们将不断努力改进(不少于5个字)";
            }else{
                [MBProgressHUD showError:@"反馈失败"toView:WeakSelf.view];
                return;
            }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请求失败" toView:self.view];
    }];
}
@end
