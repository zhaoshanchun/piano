//
//  NoteDetialViewController.m
//  NoteBook
//
//  Created by zx_06 on 15/5/26.
//  Copyright (c) 2015年 sunshilong. All rights reserved.
//

#import "NoteDetialViewController.h"

@interface NoteDetialViewController ()

@end

@implementation NoteDetialViewController
@synthesize detialContent,detialName,detialTime,detialType;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithRed:97.0/255.0 green:69.0/255.0 blue:49.0/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self initUI];
    [self initDetialLabels];
}

-(void)initUI{
    detialName = [UILabel new];
    detialName.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:detialName];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detialName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:topBarheight+8]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detialName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.detialName.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    
    detialType = [UILabel new];
    detialType.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:detialType];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detialType attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detialName attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detialType attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:30]];
    
    
    detialTime = [UILabel new];
    detialTime.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:detialTime];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detialTime attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detialName attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detialTime attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-30]];
    
    
    detialContent = [UITextView new];
    detialContent.editable = NO;
    detialContent.translatesAutoresizingMaskIntoConstraints = NO;
    //self.detialContent.backgroundColor = [UIColor colorWithRed:97.0/255.0 green:69.0/255.0 blue:49.0/255.0 alpha:1.0];
    self.detialContent.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:detialContent];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detialContent attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.detialTime attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detialContent attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:30]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detialContent attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-30]];
    
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detialContent attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-80]];
}

- (void)initDetialLabels{
    //名字
    NSDictionary *attributesName = @{NSForegroundColorAttributeName:[UIColor redColor],
                                  NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:18.0]};
    NSAttributedString *attributedTextName = [[NSAttributedString alloc] initWithString:self.detialNoteBook.noteName attributes:attributesName];
    detialName.attributedText = attributedTextName;
    
    //类型
    NSDictionary *attributeStyle = @{NSForegroundColorAttributeName:[UIColor greenColor],
                                     NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    NSAttributedString *attributeTextStyle = [[NSAttributedString alloc] initWithString:self.detialNoteBook.noteStyle attributes:attributeStyle];
    detialType.attributedText = attributeTextStyle;
    
    //时间
    NSDictionary *attributeTime = @{NSForegroundColorAttributeName:[UIColor greenColor],
                                     NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    NSAttributedString *attributeTextTime = [[NSAttributedString alloc] initWithString:self.detialNoteBook.noteTime attributes:attributeTime];
    detialTime.attributedText = attributeTextTime;
    
    //内容
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentJustified;
    paragraph.firstLineHeadIndent = 20.0;
    paragraph.paragraphSpacingBefore = 10.0;
    paragraph.lineSpacing = 10;
    paragraph.hyphenationFactor = 5.0;
    
    NSDictionary *attributeNoteContent = @{NSForegroundColorAttributeName:[UIColor blackColor],
//                                           NSBackgroundColorAttributeName:[UIColor brownColor],
                                           NSParagraphStyleAttributeName:paragraph,
                                           NSFontAttributeName:[UIFont fontWithName:@"TrebuchetMS-Bold" size:16.0]
                                           };
    
    NSAttributedString *attributeText = [[NSAttributedString alloc] initWithString:self.detialNoteBook.noteContent attributes:attributeNoteContent];
    detialContent.attributedText = attributeText;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
