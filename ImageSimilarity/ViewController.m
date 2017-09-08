//
//  ViewController.m
//  ImageSimilarity
//
//  Created by Blavtes on 2017/8/9.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "ViewController.h"
#import "ImageSimilarityTool.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *a;
@property (weak, nonatomic) IBOutlet UIImageView *b;

@property (weak, nonatomic) IBOutlet UIImageView *c;
@property (weak, nonatomic) IBOutlet UIImageView *sa;
@property (weak, nonatomic) IBOutlet UIImageView *sb;
@property (weak, nonatomic) IBOutlet UIImageView *sc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *a = [UIImage imageNamed:@"12.png"];
    UIImage *b = [UIImage imageNamed:@"13.png"];
    UIImage *c = [UIImage imageNamed:@"c.png"];
 
    NSString *r1 = [ImageSimilarityTool compareImage:a source:b];
    NSString *r2 = [ImageSimilarityTool compareImage:a source:c];
    NSString *r3 = [ImageSimilarityTool compareImage:b source:c];
    NSLog(@"r1 %@ r2 %@ r3 %@",r1,r2,r3);
//    _a.image =  [ImageSimilarityTool covertToGrayScale:a source:b];
    _a.image =  [ImageSimilarityTool getGrayImage:a origin:b];
}


@end
