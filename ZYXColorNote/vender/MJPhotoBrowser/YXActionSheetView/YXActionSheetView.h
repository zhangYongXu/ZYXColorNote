//
//  YXActionSheetView.h
//  BoBo
//
//  Created by BZBY on 15/7/24.
//  Copyright (c) 2015年 bzby. All rights reserved.
//

typedef void (^HandleBlock)(void);
typedef NS_ENUM(NSInteger, SheetViewItemType) {
    SheetViewItemTypeNormal = -1,
    SheetViewItemTypeCancel = 0,
    SheetViewItemTypeSave = 1,
    SheetViewItemTypeConfrim =2,
    SheetViewItemTypeReport =3
};
typedef NS_ENUM(NSInteger, SheetViewStatus) {
    SheetViewItemTypeShowing = 0,
    SheetViewItemTypeHidden = 1
};
@interface YXActionSheetView : RootCustomView

@property (assign,nonatomic,readonly) SheetViewStatus actionSheetViewStatus;

-(void)addSheetItemWithItemType:(SheetViewItemType)sheetViewItemType HandleBlock:(HandleBlock)handleBlock;
-(void)addSheetItemWithTitle:(NSString*)title HandleBlock:(HandleBlock)handleBlock;
-(void)removeAllSheetItem;

-(void)showActionSheetView:(BOOL)isAnimation;
-(void)hiddenActionSheetView:(BOOL)isAnimation;

-(void)setActionSheetViewDismissCompleteHandleBlock:(HandleBlock)handleBlock;

@end

@interface YXActionSheetViewItem : RootModel
@property (copy,nonatomic) NSString * title;
@property (assign,nonatomic) SheetViewItemType sheetViewItmeType;
@property (copy,nonatomic)HandleBlock handleBlock;

+(YXActionSheetViewItem*)cancelItem;
@end
