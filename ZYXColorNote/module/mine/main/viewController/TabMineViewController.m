//
//  TabMineViewController.m
//  AllPeopleReading
//
//  Created by 极客天地 on 16/8/3.
//  Copyright © 2016年 极客天地. All rights reserved.
//

#import "TabMineViewController.h"

@interface TabMineViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation TabMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)initData{
    
}

-(void)initUI{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, 902);
}
- (IBAction)draftBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"MineToDraftSegue" sender:nil];
}

@end
