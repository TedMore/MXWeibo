//
//  SendViewController.m
//  MXWeibo
//
//  Created by TedChen on 7/14/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "SendViewController.h"
#import "UIFactory.h"
#import "NearbyViewController.h"
#import "BaseNavigationController.h"
#import "MXDataService.h"

@interface SendViewController ()

@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        self.isBackButton = NO;
        self.isCancelButton = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     //Do any additional setup after loading the view from its nib.
    self.title = @"发布新微博";
    _buttons = [[NSMutableArray alloc] initWithCapacity:6];
    UIButton *endButton = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"发布" target:self action:@selector(sendAction)];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:endButton];
        self.navigationItem.rightBarButtonItem = [sendItem autorelease];
    [self _initViews];
}

- (void)_initViews {
    //工具栏中的按钮
    NSArray *images = [NSArray arrayWithObjects:
                       @"compose_locatebutton_background.png",
                       @"compose_camerabutton_background.png",
                       @"compose_trendbutton_background.png",
                       @"compose_mentionbutton_background.png",
                       @"compose_emoticonbutton_background.png",
                       @"compose_keyboardbutton_background.png",
                       nil];
    NSArray *highlightedImages = [NSArray arrayWithObjects:
                                  @"compose_locatebutton_background_highlighted.png",
                                  @"compose_camerabutton_background_highlighted.png",
                                  @"compose_trendbutton_background_highlighted.png",
                                  @"compose_mentionbutton_background_highlighted.png",
                                  @"compose_emoticonbutton_background_highlighted.png",
                                  @"compose_keyboardbutton_background_highlighted.png",
                                  nil];
    
    for (int i=0; i<images.count; i++) {
        NSString *imageName = [images objectAtIndex:i];
        NSString *highlightedName = [highlightedImages objectAtIndex:i];
        UIButton *button=[UIFactory createButton:imageName highlighted:highlightedName];
        //选中状态下的按钮图片
        [button setImage:[UIImage imageNamed:highlightedName] forState:UIControlStateSelected];
        button.tag = (10+i);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(20+75*i, 25, 23, 19);
        [self.editorBarView addSubview:button];
        [_buttons addObject:button];
        if (i == 5) {
            button.hidden = YES;
            button.left -= 75;
        }
    }
    
    //显示键盘
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    
    //显示坐标的视图，默认隐藏
    self.placeView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 30)] autorelease];
    self.placeView.hidden = YES;
    [self.editorBarView addSubview:self.placeView];
    UIImageView *placeBackgroundView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 230, 23)] autorelease];
    UIImage *image = [UIImage imageNamed:@"compose_placebutton_background.png"];
    placeBackgroundView.image = [image stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    [self.placeView addSubview:placeBackgroundView];
    self.placeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 0, 160, 23)] autorelease];
    self.placeLabel.backgroundColor = [UIColor clearColor];
    [self.placeView addSubview:self.placeLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)sendAction {
    [self doSendData];
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 10) {
        //定位
        [self location];
    }
    else if (button.tag == 11)
    {
        //相册、摄像头
        [self selectImage];
    }
    else if (button.tag == 12){
        //显示话题
        
    }
    else if (button.tag == 13){
        //显示AT用户
        
    }
    else if (button.tag == 14){
        //显示表情
        [self showFaceView];
    }
    else if (button.tag == 15){
        //显示键盘
        [self showKeyboard];
    }
}

//全屏放大图片
- (void)imageAction:(UIButton *)button {
    //放大图片。用UIImageView（加在window上）全屏显示。
    if (_fullImageView == nil) {
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _fullImageView.backgroundColor = [UIColor blackColor];
        _fullImageView.userInteractionEnabled = YES;
        //不拉伸
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //添加手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageAction:)];
        [_fullImageView addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        //创建删除按钮
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
        deleteButton.frame = CGRectMake(280, 40, 20, 26);
        deleteButton.tag = 100;
        //隐藏删除按钮，防止它也有动画效果
        deleteButton.hidden = YES;
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [_fullImageView addSubview:deleteButton];
    }
    
    //键盘消失
    [self.textView resignFirstResponder];
    
    //如果没有父视图
    if (![_fullImageView superview]) {
        _fullImageView.image = self.sendImage;
        //加载window上
        [self.view.window addSubview:_fullImageView];
        //动画效果
        _fullImageView.frame = CGRectMake(5, ScreenHeight-268, 20, 20);
        [UIView animateWithDuration:0.4 animations:^{
            _fullImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        } completion:^(BOOL finished) {
            //隐藏状态栏
            [UIApplication sharedApplication].statusBarHidden = YES;
            UIButton *deleteButton = (UIButton *)[_fullImageView viewWithTag:100];
            deleteButton.hidden = NO;
        }];
    }
}

//单击缩小图片
- (void)scaleImageAction:(UITapGestureRecognizer *)tapGesture {
    //隐藏删除按钮，防止它也有动画效果
    UIButton *deleteButton = (UIButton *)[_fullImageView viewWithTag:100];
    deleteButton.hidden = YES;
    
    //图片缩小
    [UIView animateWithDuration:0.4 animations:^{
        _fullImageView.frame = CGRectMake(5, ScreenHeight-268, 20, 20);
    } completion:^(BOOL finished) {
        [_fullImageView removeFromSuperview];
    }];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.textView becomeFirstResponder];
}

//取消图片
- (void)deleteAction:(UIButton *)deleteButton {
    //缩小图片
    [self scaleImageAction:nil];
    //移除缩略图按钮
    [self.sendImageButton removeFromSuperview];
    //把sendImage
    self.sendImage = nil;
    //恢复位置
    UIButton *button1 = [_buttons objectAtIndex:0];
    UIButton *button2 = [_buttons objectAtIndex:1];
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        //使用transform，对比frame来说有个好处，方法CGAffineTransformIdentity可以直接恢复移动之前的坐标。
        button1.transform = CGAffineTransformIdentity;
        button2.transform = CGAffineTransformIdentity;
    }];
}

- (void)dealloc {
    [_textView release];
    [_editorBarView release];
    [_placeView release];
    [_placeLabel release];
    [super dealloc];
}

#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    //显示键盘
    [self showKeyboard];
    return YES;
}


#pragma mark - UIActionSheet Deletage
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //声明一个枚举变量
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        //是否有摄像头
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //显示UIAlertView
            [alertView show];
            [alertView release];
            return;
        }
        //拍照
        sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    else if(buttonIndex == 1){
        //相册
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if(buttonIndex == 2){
        //取消
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    //通过模态视图弹出
    [self presentViewController:imagePicker animated:YES completion:nil];
//    [self presentModalViewController:imagePicker animated:YES];
}

#pragma mark -UIImagePickerController Deletate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //得到原始大小的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.sendImage = image;
    if (self.sendImageButton == nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //圆角
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.frame = CGRectMake(5, 20, 25, 25);
        [button addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
        self.sendImageButton = button;
    }
    
    [self.sendImageButton setImage:image forState:UIControlStateNormal];
    [self.editorBarView addSubview:self.sendImageButton];
    //移动按钮空出位置
    UIButton *button1 = [_buttons objectAtIndex:0];
    UIButton *button2 = [_buttons objectAtIndex:1];
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        //使用transform，对比frame来说有个好处，方法CGAffineTransformIdentity可以直接恢复移动之前的坐标。
        button1.transform = CGAffineTransformTranslate(button1.transform, 20, 0);
        button2.transform = CGAffineTransformTranslate(button2.transform, 5, 0);
    }];
    
    //关闭窗口
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - NSNotification
- (void)keyboardShowNotification:(NSNotification *)notification {
    NSLog(@"%@",notification.userInfo);
    //得到键盘frame信息
    NSValue *keyboardVale = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [keyboardVale CGRectValue];
    //得到键盘高度
    float height = frame.size.height;
    //调整工具栏位置
    self.editorBarView.bottom = ScreenHeight-height-44-20;
    //调整textview高度
    self.textView.height = self.editorBarView.top;
}

#pragma mark - Data
- (void)doSendData {
    [super showStatusTip:YES title:@"发送中..."];
    NSString *text = self.textView.text;
    if (text.length == 0) {
        NSLog(@"微博内容为空");
        return;
    }
    //发布普通微博
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    if (self.longitude.length > 0) {
        [params setObject:self.longitude forKey:@"long"];
    }
    if (self.latitude.length > 0) {
        [params setObject:self.latitude forKey:@"lat"];
    }
    if (self.sendImage == nil) {
        //不带图片
        [self.sinaweibo requestWithURL:URL_UPDATE
                                params:params
                            httpMethod:@"POST" block:^(id result) {
            //在状态栏（其实是一个单独的window）显示label
            [super showStatusTip:NO title:@"发送成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    else {
        //带图片
        //将图片转换为data,并压缩质量
        NSData *data = UIImageJPEGRepresentation(self.sendImage, 0.3);
        [params setObject:data forKey:@"pic"];
//        [self.sinaweibo requestWithURL:@"statuses/upload.json"
//                                params:params
//                            httpMethod:@"POST" block:^(id result) {
//                                NSLog(@"%@", result);
//                                [super showStatusTip:NO title:@"发送成功"];
//                                [self dismissViewControllerAnimated:YES completion:nil];
//                            }];
        [MXDataService requestWithURL:URL_UPLOAD
                               params:params
                           httpMethod:@"POST" completeBlock:^(id result) {
            [super showStatusTip:NO title:@""];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

//定位
- (void)location {
    NearbyViewController *nearbyCtrl = [[NearbyViewController alloc] init];
    BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:nearbyCtrl];
    nearbyCtrl.selectBlock = ^(NSDictionary *result){
        
        //记录坐标
        self.latitude = [result objectForKey:@"lat"];
        self.longitude = [result objectForKey:@"lon"];
        NSString *address = [result objectForKey:@"address"];
        if ([address isKindOfClass:[NSNull class]] || address.length == 0) {
            address = [result objectForKey:@"title"];
        }
        self.placeLabel.text = address;
        self.placeView.hidden = NO;
        
        //按钮的状态
        UIButton *locationBtn = [_buttons objectAtIndex:0];
        locationBtn.selected = YES;
    };
    [self presentViewController:baseNav animated:YES completion:nil];
    [nearbyCtrl release];
    [baseNav release];
}

//使用相片
- (void)selectImage {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"用户相册", nil];
    //显示UIActionSheet
    [actionSheet showInView:self.view];
    [actionSheet release];
}

//显示表情
- (void)showFaceView {
    //收起键盘
    [self.textView resignFirstResponder];
    if (_faceView == nil)
    {
        __block SendViewController *this = self;
        _faceView = [[MXFaceScrollView alloc] initWithSelectBlock:^(NSString *faceName) {
            //追加表情到输入框
            //注：此处用到了self，需要避免循环引用。
            NSString *text = this.textView.text;
            NSString *appendText = [text stringByAppendingString:faceName];
            this.textView.text = appendText;
        }];
        //创建完后才知道faceView的高度
        _faceView.top = ScreenHeight-20-44-_faceView.height;
        //x坐标不用移动,y坐标移出屏幕,为了点击后出现显示的动画效果
        _faceView.transform = CGAffineTransformTranslate(_faceView.transform, 0, ScreenHeight);
        [self.view addSubview:_faceView];
    }
    
    //动画效果
    UIButton *faceButton = [_buttons objectAtIndex:4];
    UIButton *keyboard = [_buttons objectAtIndex:5];
    faceButton.alpha = 1;
    keyboard.alpha = 0;
    keyboard.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        //faceView恢复原始状态
        _faceView.transform = CGAffineTransformIdentity;
        //表情按钮消失
        faceButton.alpha = 0;
        //调整textView,editorBarView的Y坐标
        float height = _faceView.height;
        self.editorBarView.bottom = ScreenHeight-height-20-44;
        self.textView.height = self.editorBarView.top;
    } completion:^(BOOL finished) {
        //键盘按钮显示
        [UIView animateWithDuration:0.3 animations:^{
            keyboard.alpha = 1;
        }];
    }];
}

//显示键盘
- (void)showKeyboard {
//    [self.textView becomeFirstResponder];
    //动画
    UIButton *faceButton = [_buttons objectAtIndex:4];
    UIButton *keyboard = [_buttons objectAtIndex:5];
    faceButton.alpha = 0;
    keyboard.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        _faceView.transform = CGAffineTransformTranslate(_faceView.transform, 0, ScreenHeight);
        keyboard.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            faceButton.alpha = 1;
        }];
    }];
}

@end
