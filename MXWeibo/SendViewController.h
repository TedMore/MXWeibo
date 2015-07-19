//
//  SendViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/14/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"
#import "MXFaceScrollView.h"

@interface SendViewController : BaseViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
{
    NSMutableArray *_buttons;
    UIImageView *_fullImageView; //图片的全屏视图
    MXFaceScrollView *_faceView;
}
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UIView *editorBarView;
@property (nonatomic, copy) NSString *longitude; //经度
@property (nonatomic, copy) NSString *latitude; //维度
@property (nonatomic, retain) UIView *placeView;
@property (nonatomic, retain) UILabel *placeLabel;
@property (nonatomic, copy) UIImage *sendImage;
//缩略图按钮
@property(nonatomic,retain)UIButton *sendImageButton;

@end
