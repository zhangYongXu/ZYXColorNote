//
//  LayoutViewController.m
//  TourNote
//
//  Created by 极客天地 on 17/1/13.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "LayoutViewController.h"
#import "GWLayoutScorllView.h"

#import "GWLayoutElementViewImage.h"
#import "GWLayoutElementViewLabel.h"
#import "GWLayoutElementViewPaster.h"


#import "PasterSelectViewController.h"
#import "BackgroundSelectViewController.h"
#import "TemplateSelectViewController.h"
#import "StrokeSelectViewController.h"
#import "StrokeBrushSizeView.h"

#import "YXNetWork.h"

#import "YXMaskProgressView.h"


#import "PasterSelectViewController.h"



#define SingleScreenHeight (SCREEN_HEIGHT-45-53)
#define AddOrReducePageHeight (SingleScreenHeight/2.0)

@interface LayoutViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topHandleDefaultView;
@property (weak, nonatomic) IBOutlet UIView *topHandleRanksView;
@property (weak, nonatomic) IBOutlet UIView *topHandleStrokeView;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *insertStroke;
@property (weak, nonatomic) IBOutlet UIButton *insertViewElementText;
@property (weak, nonatomic) IBOutlet UIButton *insertViewElementImage;
@property (weak, nonatomic) IBOutlet UIButton *addPaper;
@property (weak, nonatomic) IBOutlet UIButton *reducePaper;

@property (weak, nonatomic) IBOutlet UIView *layoutContentView;
@property (weak, nonatomic) IBOutlet GWLayoutScorllView *layoutScrollView;

@property (strong,nonatomic)NSMutableArray* elmentViewArray;
@property (strong,nonatomic)GWLayoutElementView * currentFocusedElementView;

@property (strong,nonatomic) YXMaskProgressView *progressViewMask;

@property (strong,nonatomic) StrokeBrushSizeView * strokeBrushSizeView;


@property (strong,nonatomic) StrokeBrushModel * selectedStrokeBrushModel;
@end

@implementation LayoutViewController
-(YXMaskProgressView *)progressViewMask{
    if(nil == _progressViewMask){
        _progressViewMask =  [YXMaskProgressView progressViewWithMask];
    }
    return _progressViewMask;
}
-(StrokeBrushSizeView *)strokeBrushSizeView{
    if(nil == _strokeBrushSizeView){
        _strokeBrushSizeView = [StrokeBrushSizeView loadFromXib];
        _strokeBrushSizeView.width = self.view.width;
        _strokeBrushSizeView.hidden = YES;
        _strokeBrushSizeView.bottom = self.bottomView.top;
        __weak typeof(self) weakSelf = self;
        [_strokeBrushSizeView setStrokeBrushSizeDidSelectedBlock:^{
            weakSelf.selectedStrokeBrushModel.StrokeBrushSize = weakSelf.strokeBrushSizeView.strokeBrushSize;
        }];
        [_strokeBrushSizeView setStrokeBrushSizeStyleClickedBlock:^{
            [weakSelf showStrokeSelectVc];
        }];
        
        [_strokeBrushSizeView setStrokeBrushSizeUpOrDownClickedBlock:^(StrokeBrushSizeView *view, UIButton *button) {
            if(button.selected){
                view.top = weakSelf.bottomView.top;
            }else{
                view.bottom = weakSelf.bottomView.top;
            }
        }];
    }
    return _strokeBrushSizeView;
}
-(NSMutableArray *)elmentViewArray{
    if(nil == _elmentViewArray){
        _elmentViewArray = [[NSMutableArray alloc] init];
    }
    return _elmentViewArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    
}


-(void)uploadDataToServer{
    GWLayoutModel * layoutModel = self.layoutScrollView.layoutViewModel.layoutModel;
    NSLog(@"layoutScrollView layoutModel :%@",layoutModel);
    NSDictionary * dict = [layoutModel propertyList:YES];
    NSString * jsonString = [NSString jsonStringWithDictionary:dict];
    NSData * fileData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * fileName = [NSString stringWithFormat:@"%@_layout.json",@([[[NSDate alloc] init] timeIntervalSince1970])];
    NSLog(@"jsonString :%@",jsonString);
    [self.progressViewMask showProgressView];
    [YXNetWork uploadFileWithFileData:fileData FileName:fileName showProgress:YES ProgressBlock:^(CGFloat progress) {
        [self.progressViewMask setProgressValue:progress/2.0];
        NSString* text = [NSString stringWithFormat:@"已上传:%.2f%%",progress*100/2.0];
        [self.progressViewMask setProgressLabelText:text];
    } sucess:^(BmobFile * file) {
        UIImage * image = [UIImage convertToImageWithScrollView:self.layoutScrollView];
        [YXNetWork uploadImage:image showProgress:YES ProgressBlock:^(CGFloat progress) {
            [self.progressViewMask setProgressValue:progress/2.0+0.5];
            NSString* text = [NSString stringWithFormat:@"已上传:%.2f%%",progress*100/2.0 + 50];
            [self.progressViewMask setProgressLabelText:text];
        } sucess:^(BmobFile * imageFile) {
            NSString * fileUrl = file.url;
            NSString * imageUrl = imageFile.url;
            
            NSString * userObjectId = APPDelegate.userViewModel.localCacheUserModel.objectId;
            NSDictionary * parameters = @{@"layoutJsonDataString":@"",@"layoutPicImageUrl":imageUrl,@"layouJsonUrl":fileUrl};
            BmobHttpApiAddItem * item = [[BmobHttpApiAddItem alloc] init];
            item.tableName = @"LayoutModel";
            item.dataDict = parameters;
            BmobHttpApiAddItemPoint * point = [[BmobHttpApiAddItemPoint alloc] init];
            point.pointFeildName = @"publishUserPoint";
            point.tableName = @"LayoutUserModel";
            point.objectId = userObjectId;
            item.pointArray = @[point];
            [BmobHttpApiPost addDataWithBmobHttpApiAddItem:item showProgress:NO sucess:^(NSDictionary *dictionary) {
                [self.progressViewMask dismissProgressView];
                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                self.navigationController.tabBarController.selectedIndex = 0;
                [self.navigationController popViewControllerAnimated:YES];
            } failed:^(NSString *errorMsg) {
                [self.progressViewMask dismissProgressView];
            }];
        } failed:^(NSString *errorMsg) {
            [self.progressViewMask dismissProgressView];
        }];
    } failed:^(NSString *errorMsg) {
        [self.progressViewMask dismissProgressView];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initData{
    [self refreshLayoutModelData];
}
-(void)refreshLayoutModelData{
    GWLayoutModel * layoutModel = self.layoutScrollView.layoutViewModel.layoutModel;
    layoutModel.layoutWidth = [NSString stringWithFormat:@"%.2f",self.layoutScrollView.contentSize.width*SCREEN_SCALE];
    layoutModel.layoutHeight = [NSString stringWithFormat:@"%.2f",self.layoutScrollView.contentSize.height*SCREEN_SCALE];
    UIImage * image = [UIImage convertToImageWithView:self.layoutScrollView.strokeView];
    layoutModel.strokeViewImageBase64String = [UIImage base64StringWithImage:image];
    
}




-(void)initUI{
    self.layoutScrollView.contentSize = CGSizeMake(self.layoutScrollView.width, SingleScreenHeight);
    [self.bottomView drawBorderSolidLineWithPosition:BorderLinePositionTop Color:[UIColor colorWithHex:AppViewBottomLineColor] Width:AppViewBottomLineWidth];
    self.scrollView.contentSize = CGSizeMake(470, self.scrollView.height);
    [self.layoutScrollView addSingleTapGetureWithBlock:^(UITapGestureRecognizer *tapGeture) {
        self.currentFocusedElementView.isFocusing = NO;
        if(!self.topHandleRanksView.hidden){
            [self showTopHandleDefaultView];
        }
    }];
    
    if(self.existLayoutModel){
        [self refreshLayoutUIWithExistLayoutModel:self.existLayoutModel];
    }
    [self.view insertSubview:self.strokeBrushSizeView belowSubview:self.bottomView];
    
    [self showTopHandleDefaultView];
    
}

//根据已存在的布局数据刷新布局
-(void)refreshLayoutUIWithExistLayoutModel:(GWLayoutModel*)layoutModel{
    [self.layoutScrollView clearAllElementViews];
    CGFloat percent = layoutModel.toCurrentScrrenPercent;
    CGFloat width = ([layoutModel.layoutWidth floatValue] * percent)/SCREEN_SCALE;
    CGFloat height = ([layoutModel.layoutHeight floatValue] * percent)/SCREEN_SCALE;
    self.layoutScrollView.contentSize = CGSizeMake(width, height);
    NSString * backgroundName = layoutModel.backgroundName;
    BackgroundModel * backgroundModel = [BackgroundViewModel backgroundModelWithBackgroundName:backgroundName];
    self.layoutScrollView.backgroundModel = backgroundModel;
    
    
    if(!STR_IS_NIL(layoutModel.strokeViewImageBase64String)){
        UIImage * strokeImage = [UIImage imageFromBase64String:layoutModel.strokeViewImageBase64String];
        self.layoutScrollView.strokeView.backgroundImage = strokeImage;
    }
    
    for(GWElementModel *eModel in layoutModel.elementArray){
        
        if([eModel.elementType integerValue] == GWLayoutElementViewTypeLabel){
            GWLayoutElementViewLabel * eLabel = (GWLayoutElementViewLabel*)[self createNewElementViewWithClass:[GWLayoutElementViewLabel class]];
            [eLabel refreshWithElementModel:eModel LyoutModel:layoutModel];
            [self insertNewElementView:eLabel];
        }else if([eModel.elementType integerValue] == GWLayoutElementViewTypeImage){
            GWLayoutElementViewLabel * eImage = (GWLayoutElementViewLabel*)[self createNewElementViewWithClass:[GWLayoutElementViewImage class]];
            [eImage refreshWithElementModel:eModel LyoutModel:layoutModel];
            [self insertNewElementView:eImage];
        }else if([eModel.elementType integerValue] == GWLayoutElementViewTypePaster){
            GWLayoutElementViewPaster * ePaster = (GWLayoutElementViewPaster*)[self createNewElementViewWithClass:[GWLayoutElementViewPaster class]];
            [ePaster refreshWithElementModel:eModel LyoutModel:layoutModel];
            [self insertNewElementView:ePaster];
        }
    }
}
- (IBAction)insertTemplate:(id)sender {
    TemplateSelectViewController * templateSelectVc = [[TemplateSelectViewController alloc] init];
    [templateSelectVc setTemplateDidSelectedBlock:^(TemplateModel *templateModel) {
        NSData * layoutJsonData = [NSData dataWithContentsOfFile:templateModel.templateLayoutJsonPath];
        if(layoutJsonData){
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:layoutJsonData options:NSJSONReadingMutableContainers error:nil];
            GWLayoutModel * layoutModel = [[GWLayoutModel alloc] init];
            [layoutModel setValuesForKeysWithDictionary:dict];
            UIAlertView * alertView = [UIAlertView alertViewWithTitle:@"温馨提示" message:@"使用模板会覆盖您当前手杖，确定要使用么?" cancelButtonTitle:@"确认" handleBlock:^{
                [self refreshLayoutUIWithExistLayoutModel:layoutModel];
            }];
            [alertView addButtonWithTitle:@"取消" handleBlock:^{
                
            }];
            [alertView show];
        }else{
            [SVProgressHUD showErrorWithStatus:@"数据已损坏"];
        }
        
    }];
    [self.navigationController pushViewController:templateSelectVc animated:YES];
}
- (IBAction)insertBackground:(id)sender {
    BackgroundSelectViewController * backgrounSelectVc = [[BackgroundSelectViewController alloc] init];
    [backgrounSelectVc setBackgroundDidSelectedBlock:^(BackgroundModel *backgroundModel) {
        self.layoutScrollView.backgroundModel = backgroundModel;
    }];
    [self.navigationController pushViewController:backgrounSelectVc animated:YES];
    
}
- (IBAction)insertPaster:(id)sender {
    [self closeStrokeSelectVc];
    PasterSelectViewController * pasterSelectVc = [[PasterSelectViewController alloc] init];
    [pasterSelectVc setPasterDidSelectedBlock:^(PasterModel *pasterModel) {
        GWLayoutElementViewPaster * ePaster = (GWLayoutElementViewPaster*)[self createNewElementViewWithClass:[GWLayoutElementViewPaster class]];
        ePaster.pasterModel = pasterModel;
        [self insertNewElementView:ePaster];
    }];
    [self.navigationController pushViewController:pasterSelectVc animated:YES];
}
- (IBAction)insertStroke:(id)sender {
    if(self.strokeBrushSizeView.hidden){
        [self showStrokeSelectVc];
    }else{
        [self closeStrokeSelectVc];
    }
}
- (void)closeStrokeSelectVc{
    if(self.strokeBrushSizeView.hidden){
        return;
    }
    self.insertStroke.selected = NO;
    self.strokeBrushSizeView.hidden = YES;
    [self showTopHandleDefaultView];
    self.selectedStrokeBrushModel = nil;
    self.layoutScrollView.strokeBrushModel = nil;
}
- (void)showStrokeSelectVc{
   
    StrokeSelectViewController * strokeSelectVc = [[StrokeSelectViewController alloc] init];
    [strokeSelectVc setStrokeBrushDidSelectedBlock:^(StrokeBrushModel *strokeBrushModel) {
        [self.view insertSubview:self.strokeBrushSizeView belowSubview:self.bottomView];
         self.insertStroke.selected = YES;
        self.strokeBrushSizeView.hidden = NO;
        self.currentFocusedElementView.isFocusing = NO;
        [self showTopHandleStrokeView];
        self.selectedStrokeBrushModel = strokeBrushModel;
        self.selectedStrokeBrushModel.StrokeBrushSize = self.strokeBrushSizeView.strokeBrushSize;
        self.layoutScrollView.strokeBrushModel = self.selectedStrokeBrushModel;
    }];
    [self.navigationController pushViewController:strokeSelectVc animated:YES];
}

- (IBAction)insertViewElementText:(UIButton *)sender {
    [self closeStrokeSelectVc];
    GWLayoutElementViewLabel * eLabel = (GWLayoutElementViewLabel*)[self createNewElementViewWithClass:[GWLayoutElementViewLabel class]];
    [eLabel setDoubleTapGestureBlock:^(GWLayoutElementView *elementView, UITapGestureRecognizer *doubleTapGesture) {
    }];
    [eLabel setElementViewDidEditedTextBlock:^(GWLayoutElementViewLabel *elementViewLabel) {
        [self insertNewElementView:elementViewLabel];
    }];
    [eLabel showInputText];
}
- (IBAction)insertViewElementImage:(UIButton *)sender {
    [self closeStrokeSelectVc];
    GWLayoutElementViewImage * eImage = (GWLayoutElementViewImage*)[self createNewElementViewWithClass:[GWLayoutElementViewImage class]];
    [eImage setDoubleTapGestureBlock:^(GWLayoutElementView *elementView, UITapGestureRecognizer *doubleTapGesture) {
        
    }];
    [eImage setElementViewDidSelectedImageBlock:^(GWLayoutElementViewImage *elementViewImage, UIImage *selectedImage) {
        [self insertNewElementView:elementViewImage];
    }];
    [eImage selectImage];
}

//根据class创建布局元素
- (GWLayoutElementView*)createNewElementViewWithClass:(Class)elementClass{
    
    self.currentFocusedElementView.isFocusing = NO;
    
    GWLayoutElementView* elementView = [elementClass loadFromXib];
    elementView.enableEditing = YES;
    __weak typeof(self) weakSelf = self;
    [elementView setCloseBtnClickedBlock:^(GWLayoutElementView *elementView, UIButton *button) {
        [weakSelf.elmentViewArray removeObject:elementView];
        [weakSelf.layoutScrollView.layoutViewModel.layoutModel.elementArray removeObject:elementView.elementModel];
        [elementView removeFromSuperview];
    }];
    [elementView setSingleTapGestureBlock:^(GWLayoutElementView *elementView, UITapGestureRecognizer *singleTapGesture) {
        if(weakSelf.strokeBrushSizeView.hidden){
            weakSelf.currentFocusedElementView.isFocusing = NO;
            weakSelf.currentFocusedElementView = elementView;
            elementView.isFocusing = YES;
            [elementView.superview bringSubviewToFront:elementView];
            [weakSelf showTopHandleRankView];
        }else{
            elementView.isFocusing = NO;
        }
    }];
    elementView.centerX = self.layoutScrollView.contentSize.width/2.0;
    elementView.centerY = SingleScreenHeight/2.0 + self.layoutScrollView.contentOffset.y;
 
    return elementView;
}
//插入一个新的布局元素
- (void)insertNewElementView:(GWLayoutElementView*)newElementView{
    
    GWLayoutElementView* elementView  = newElementView;
    
    [self.layoutScrollView addSubview:elementView];
    
    self.currentFocusedElementView = elementView;
    
    [self.layoutScrollView.layoutViewModel.layoutModel.elementArray addObject:elementView.elementModel];
    [self.elmentViewArray addObject:elementView];
}

- (IBAction)addPaper:(id)sender {
    CGSize size = self.layoutScrollView.contentSize;
    size.height = size.height + AddOrReducePageHeight;
    if(size.height > self.layoutScrollView.maxLayoutHeight){
        [SVProgressHUD showErrorWithStatus:@"已达到纸最大高度"];
        return;
    }
    self.layoutScrollView.contentSize = size;
    CGRect rect = CGRectMake(0, size.height - SingleScreenHeight, self.layoutScrollView.width, size.height);
    [self.layoutScrollView scrollRectToVisible:rect animated:YES];
}
- (IBAction)reducePaper:(id)sender {
    CGSize size = self.layoutScrollView.contentSize;
    if(size.height >= (SingleScreenHeight + AddOrReducePageHeight)){
        size.height = size.height - AddOrReducePageHeight;
        self.layoutScrollView.contentSize = size;
        CGRect rect = CGRectMake(0, size.height - SingleScreenHeight, self.layoutScrollView.width, size.height);
        [self.layoutScrollView scrollRectToVisible:rect animated:YES];
    }
}

//topView
- (void)showTopHandleDefaultView{
    self.topHandleDefaultView.hidden = NO;
    self.topHandleRanksView.hidden = YES;
    self.topHandleStrokeView.hidden = YES;
}
- (void)showTopHandleRankView{
    self.topHandleDefaultView.hidden = YES;
    self.topHandleRanksView.hidden = NO;
    self.topHandleStrokeView.hidden = YES;
}
- (void)showTopHandleStrokeView{
    self.topHandleDefaultView.hidden = YES;
    self.topHandleRanksView.hidden = YES;
    self.topHandleStrokeView.hidden = NO;
}
- (IBAction)backBtnClicked:(id)sender {
    UIAlertView * alertView = [UIAlertView alertViewWithTitle:@"是否保存草稿？" message:nil cancelButtonTitle:@"确认" handleBlock:^{
        [self refreshLayoutModelData];
        [self saveToDraft];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView addButtonWithTitle:@"取消" handleBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView show];
    
}
- (IBAction)saveBtnClicked:(id)sender {
    if(!APPDelegate.isUserHasLogin){
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    UIAlertView * alertView = [UIAlertView alertViewWithTitle:@"确认发布？" message:nil cancelButtonTitle:@"确认" handleBlock:^{
        [self refreshLayoutModelData];
        [self uploadDataToServer];
    }];
    [alertView addButtonWithTitle:@"取消" handleBlock:^{
        
    }];
    [alertView show];
    
}
//获取当前草稿箱当前的路径
-(NSString*)getCurrentDraftDirWithDirName:(NSString*)dirName{
    NSString * currentDraftDirPath = [APPDelegate.draftDir stringByAppendingPathComponent:dirName];
    NSFileManager * FM = [NSFileManager defaultManager];
    NSError * error = nil;
    if([FM fileExistsAtPath:currentDraftDirPath]){
        return currentDraftDirPath;
    }else{
        if ([FM createDirectoryAtPath:currentDraftDirPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            return currentDraftDirPath;
        }else{
            return nil;
        }
    }
    return currentDraftDirPath;
}
-(void)saveToDraft{
    GWLayoutModel * layoutModel = self.layoutScrollView.layoutViewModel.layoutModel;
    NSLog(@"layoutScrollView layoutModel :%@",layoutModel);
    NSDictionary * dict = [layoutModel propertyList:YES];
    NSString * jsonString = [NSString jsonStringWithDictionary:dict];
    NSData * fileData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    UIImage * image = [UIImage convertToImageWithScrollView:self.layoutScrollView];
    
    NSDate * todayDate = [[NSDate alloc] init];
    NSString * dateStr = [todayDate stringWithFormat:@"yyyy_mm_dd"];
    NSString * draftKey = [NSString stringWithFormat:@"%@(%@)",dateStr,@((NSInteger)[todayDate timeIntervalSince1970])];
    NSString * fileName = [NSString stringWithFormat:@"%@.json",draftKey];
    NSString * imageName = [NSString stringWithFormat:@"%@.png",draftKey];
    
    NSString * currentDraftDir = [self getCurrentDraftDirWithDirName:draftKey];
    
    NSString * filePath = [currentDraftDir stringByAppendingPathComponent:fileName];
    NSString * imagePath = [currentDraftDir stringByAppendingPathComponent:imageName];
    
    [SVProgressHUD showWithStatus:@"保存草稿..." maskType:SVProgressHUDMaskTypeGradient];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isSuccess = [fileData writeToFile:filePath atomically:YES];
        NSData * imageData = UIImagePNGRepresentation(image);
        BOOL isImageSuccess = [imageData writeToFile:imagePath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if(isSuccess){
                NSLog(@"保存草稿成功");
            }else{
                NSLog(@"保存草稿失败");
            }
        });
    });
    
}
- (IBAction)strokeRevokeBtnClicked:(id)sender {
    [self.layoutScrollView strokeRevoke];
}
- (IBAction)strokeRecoveryBtnClicked:(id)sender {
    [self.layoutScrollView strokeRecovery];
}
- (IBAction)elementLayerTopBtnClicked:(id)sender {
    GWLayoutElementView *elementView = self.currentFocusedElementView;
    if(!elementView.isFocusing){
        return;
    }
    [self.layoutScrollView sendToTopLayerWithElementView:elementView];
}
- (IBAction)elementLayerUpBtnClicked:(id)sender {
    GWLayoutElementView *elementView = self.currentFocusedElementView;
    if(!elementView.isFocusing){
        return;
    }
    [self.layoutScrollView sendToUpLayerWithElementView:elementView];
}
- (IBAction)elementLayerDownBtnClicked:(id)sender {
    GWLayoutElementView *elementView = self.currentFocusedElementView;
    if(!elementView.isFocusing){
        return;
    }
    [self.layoutScrollView sendToDownLayerWithElementView:elementView];
}
- (IBAction)elementLayerBottomBtnClicked:(id)sender {
    GWLayoutElementView *elementView = self.currentFocusedElementView;
    if(!elementView.isFocusing){
        return;
    }
    [self.layoutScrollView sendToBottomLayerWithElementView:elementView];
}


@end
