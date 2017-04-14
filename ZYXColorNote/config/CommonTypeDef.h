//
//  CommonTypeDef.h
//  LuNengHotel
//
//  Created by 极客天地 on 16/3/28.
//  Copyright © 2016年 极客天地. All rights reserved.
//

#ifndef CommonTypeDef_h
#define CommonTypeDef_h


#endif /* CommonTypeDef_h */


#define STR_IS_NIL(key) (([@"<null>" isEqualToString:(key)] || [@"" isEqualToString:(key)] || key == nil || [key isKindOfClass:[NSNull class]]) ? 1: 0)

#define ARRAY_IS_EMPTY(array) ((!array || [array isKindOfClass:[NSNull class]] ||[array count] == 0)? 1: 0)
#define DICTIONARY_IS_EMPTY(dictionary) ((!dictionary || [dictionary isKindOfClass:[NSNull class]] ||[dictionary count] == 0 )? 1: 0)

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_WIDTH_TO375_PROPERTION (SCREEN_WIDTH/375.0)

#define SCREEN_SCALE [UIScreen mainScreen].scale
#define SCREEN_HEIGHT_PX ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale)
#define SCREEN_WIDTH_PX  ([UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale)

#ifndef __OPTIMIZE__
//#define NSLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define NSLog(format, ...) NSLog((format @" -->line:%d fun:%s"  ),##__VA_ARGS__,__LINE__, __FUNCTION__  )
#else
#define NSLog(...){}
#endif


typedef NS_ENUM(NSInteger,CommonEnumSexTypes) {
    CommonEnumSexTypeMale = 1, //男
    CommonEnumSexTypeFemale = 2 //女
};

#define APPDelegate ((AppDelegate*)[[UIApplication sharedApplication]delegate])

#define AppBaseBackgroundColor 0xE4564A
//#define APPNetImageDowningPlaceHolder @"noImage"
#define APPNetImageDowningPlaceHolder @"network_image_default"

#define AppViewCommonColor 0xffbc44

#define AppViewBottomLineColor 0x999999
#define AppViewBottomLineWidth 0.3f
/**
 *  自定义通知
 *
 */
//app进入前台/后台
#define Notification_Name_AppEnterForeground @"Notification_Name_AppEnterForeground"
#define Notification_Name_AppEnterBackground @"Notification_Name_AppEnterBackground"
//用户登录/退出
#define Notification_Name_UserLogin @"Notification_Name_UserLogin"
#define Notification_Name_UserLogout @"Notification_Name_UserLogout"
//用户修改密码/修改手机号/基本信息
#define Notification_Name_UserChangePassword @"Notification_Name_UserChangePassword"
#define Notification_Name_UserChangeMobile @"Notification_Name_UserChangeMobile"
#define Notification_Name_UserChangeBaseInfo @"Notification_Name_UserChangeBaseInfo"

//手动添加书成功
#define Notification_Name_InputAddBookSuccess @"Notification_Name_InputAddBookSuccess"
//Appdelegate获取地理位置成功通知
#define Notification_Name_AppDelegeteGetlocationSuccess @"Notification_Name_AppDelegeteGetlocationSuccess"
//圈子发布补丁成功通知
#define Notification_Name_PatchSendSuccess @"Notification_Name_PatchSendSuccess"
//圈子添加评论成功通知
#define Notification_Name_PatchAddCommentSuccess @"Notification_Name_PatchAddCommentSuccess"
//添加书友成功通知
#define Notification_Name_AddBookFriendSuccess @"Notification_Name_AddBookFriendSuccess"
//加入书友会成功通知
#define Notification_Name_AttendBookClubSuccess @"Notification_Name_AttendBookClubSuccess"

//环信 聊天会话改变
#define Notification_Name_ChatConversationChanged @"Notification_Name_ChatConversationChanged"

//消息 用户通知消息改变
#define Notification_Name_UserNoticeChanged @"Notification_Name_UserNoticeChanged"

//消息 用户通知消息请求数据完成
#define Notification_Name_UserNoticeRequestFinish @"Notification_Name_UserNoticeRequestFinish"

//消息 个推收到远程通知
#define Notification_Name_GeTuiRemoteNotification @"Notification_Name_GeTuiRemoteNotification"

//消息 加入群成功
#define Notification_Name_AddGroupSuccess @"Notification_Name_AddGroupSuccess"

//群组活动 用户已查看群组活动
#define Notification_Name_GroupEventNoticeSuccess @"Notification_Name_GroupEventNoticeSuccess"

#define UseTestData 1

/**
 *  服务器地址
 *
 */
//测试
#define APPBaseURL @"http://cloud.bmob.cn/71012d2d4ea6a177/"

//#define APPBaseURL @"http://192.168.254.156:8080/qmyd_app/"
/**
 *  发送短信
 *
 */

#define user_sendsms @"user/sendsms"


/**
 *  注册检测用户名和验证码
 *
 */

#define checkusername @"checkusername"

/**
 *  注册
 *
 */

#define user_registUser @"registUser"

/**
 *  注册 请求标签数据
 *
 */
#define user_reg_selectBookType @"selectBookType"

/**
 *  登录
 *
 */
/*
 userpwd   2323
 username  15801347041
 */
#define user_login @"login"
/**
 *  请求验证码
 * phone
 */
#define user_sendPhoneMessage @"sendPhoneMessage"
/**
 *  验证手机验证码
 * phone,verificationcode
 */
#define user_verificationPhone @"verificationPhone"

/**
 *  修改用户信息
 *
 */

#define member_update_member_info @"member/update_member_info"

/**
 *  上传头像
 *
 */
#define member_upload_pic @"member/upload_pic"

/**
 *  修改密码
 *
 */
#define member_modifypwd @"member/modifypwd"

/**
 *  获取首页数据
 *
 */
#define home_getMainPaper @"getMainPaper"
//首页 更多最热
#define home_getMoreHotThreeBook @"getMoreHotThreeBook"
//首页 更多最新
#define home_getMoreThreebycreateBook @"getMoreThreebycreateBook"
//首页 更多附近
#define home_getMoreNearBook @"getMoreNearBook"
//首页 更多最多
#define home_getMoreMostDownUser @"getMoreMostDownUser"
//首页 更多活动
#define home_getMoreAllEvent @"getMoreAllEvent"


/**
 *  按书籍名称搜索
 *
 */
#define home_selectBook @"selectBook"
/**
 *  搜索 近期好评书籍
 *
 */
#define home_getNearDayBook @"getNearDayBook"
/**
 *  书籍详情
 *
 */
#define home_getBookDetail @"getBookDetail"

/**
 *   书籍详情，获取更多评论
 *
 */
#define home_getMoreBookComment @"getMoreBookComment"
/**
 *   书籍详情，获取更多看过的人
 *
 */
#define home_getMoreFriendsCount @"getMoreFriendsCount"

/**
 *   书籍详情，书籍补丁
 *
 */
#define home_getMorePatchByBookId @"getMorePatchByBookId"
/**
 *   书籍评论点赞
 *
 */
#define home_comment_addGood @"addGood"
/**
 *  添加书籍评论
 *
 */
#define home_addComment @"addComment"
/**
 *  添加书籍评论 回复
 *
 */
#define home_addOtherComment @"addOtherComment"
/**
 *  查询评论回复
 *
 */
#define selectAllotherComment @"selectAllotherComment"
/**
 *  添加书架 case_name，user_id，user_lat，user_lon，bookcase_pic
 *
 */
#define mine_addbookcase @"addbookcase"

/**
 *  查询我的书架
 *
 */
#define mine_selectbookcasebyid @"selectbookcasebyid"
/**
 *  添加书籍 bookid，case_id，bookcount，booksource，bookstate
 *
 */
#define insertBookToBookCase @"insertBookToBookCase"

/**
 *  从已有书籍 这个是从图书详情添加书架
 *
 */
/*
 booknumber 图书数量
 userid 用户ID
 case_id 添加到书架ID
 book_id 图书ID
 bookisdefault 是否是默认书架
 borrow_state 是否可被借阅
 islook 是否可以被看见
 
 islook(默认可见),bookcontent,case_id(如果选择书架，传数值，否则为0),bookisdefault(如果是默认书架为1，选择的书架为0)
 
 */
#define insertBookToBookCaseByOursBook @"insertBookToBookCaseByOursBook"


//借阅

//borrowBook	点击借阅	bookid，changeid：这个参数为识别是否有改变指定的userid，没有为0	 1，查询成功；2，失败
/**
 *  借阅 查询书友信息 默认传
 *
 */
#define borrow_borrowBook @"borrowBook"


/**
 *  借阅 全部书友
 *
 */
#define borrow_chooseborrowuser @"chooseborrowuser"

/**
 *  借阅 查看漂流
 *
 */
#define borrow_lookthefloat @"lookthefloat"

/**
 *  借阅 插入漂流记录
 *
 */
#define borrow_insertFloat @"insertFloat"

/**
 *  借阅 （from_userid，to_userid，book_id,messages.）
 *
 */
#define borrow_borrowsucsess @"borrowsucsess"

/**
 *  借阅 提交推送ClientID
 *
 */
#define push_addClientID @"addClientID"
/**
 *  借阅 移除推送ClientID
 *
 */
#define push_removeClientID @"removeClientID"

/**
 *  补丁添加补丁
 *图片，userid，bookid，patch_content，patch_address	1，查询成功；2，失败
 */
#define patch_addPatch @"addPatch"
/**
 *  补丁 选择书籍
 *
 */
#define patch_getMyBookcaseBook @"getMyBookcaseBook"

/**
 *  补丁 查询所有补丁
 *
 */
#define patch_getallpath @"getallpath"
/**
 *  补丁 查询好友补丁
 *
 */
#define patch_getallpathbyfriends @"getallpathbyfriends"

//addpatchGood (userid,patchid)
/**
 *  补丁 点赞
 *
 */
#define patch_addpatchGood @"addpatchGood"
/**
 *  补丁 评论
 *
 */
/*
 patchid 朋友圈ID
 book_id 书ID
 from_user 从谁进行的评论
 to_user 对谁的评论
 to_patchcom 对那条评论的评论
 com_content评论内容
 */
#define patch_addPatchCom @"addPatchCom"
/**
 *  补丁 评论列表
 *
 */
#define patch_selectPatchOtherCom @"selectPatchOtherCom"

//读客
/**
 *  读客 我的读客
 *
 */
#define reader_selectFriends @"selectFriends"

//selectNearFriends	查找附近用户	user_lat，user_lon	1，成功；2，失败
/**
 *  读客 添加好友/群组 附近好友
 *
 */
#define reader_selectNearFriends @"selectNearFriends"

/**
 *  读客 添加好友/群组 搜索
 *
 */
#define reader_selectUserBynickname @"selectUserBynickname"


/**
 *  读客 添加好友/群组
 *
 */
//addFriend	添加好友	userid，friendid	1，成功；2，失败
#define reader_addFriend @"addFriend"
/**
 *  读客 书友详情
 *
 */
#define reader_persiondetail @"persiondetail"

/**
 *  读客 附近书籍
 *
 */
#define reader_selectNearBooks @"selectNearBooks"

/**
 *  读客 书友会/群组 详情
 *
 */
#define reader_selectGroupDetail @"selectGroupDetail"

/**
 *  读客 书友会/群组 详情
 *
 */
#define reader_addGroupUser @"addGroupUser"

/**
 *  读客 书友会/群组 详情 成员列表
 *
 */
#define reader_selectGroupUserList @"selectGroupUserList"

/**
 *  读客 书友会/群组 详情 退出群组
 *
 */
#define reader_delGroupUser @"delGroupUser"

/**
 *  读客 书友会/群组 详情 变更组长
 *
 */
#define reader_moveGroupleader @"moveGroupleader"
/**
 *  读客 查询书架所有书
 *
 */
#define reader_selectbooksbycaseid @"selectbooksbycaseid"

//活动

/**
 *  活动 查询活动详情
 *
 */
#define event_getEventDetail @"getEventDetail"
/**
 *  活动 选择参与活动书籍
 *
 */
#define event_getMyBookcaseBookByBooktype @"getMyBookcaseBookByBooktype"

/**
 *  活动 参与活动
 *
 */
#define event_addEnteBook @"addEnteBook"



//我的
/**
 *  我的 我的书评
 *
 */
#define mine_getmybookcomment @"getmybookcomment"

/**
 *  我的 我的活动
 *
 */
#define mine_getMyEvent @"getMyEvent"

/**
 *  我的 查询个人信息
 *
 */
#define mine_selectPersionMessage @"selectPersionMessage"

/**
 *  我的 更新书架
 *  参数case_name case_id user_id
 */
#define mine_updatebookcase @"updatebookcase"
/**
 *  我的 书架详情 按类别书籍列表
 *
 */
#define mine_selectBookFromBookcaseBycaseId @"selectBookFromBookcaseBycaseId"

/**
 *  我的 书架详情 搜索书通过书名，从我的书架
 *  case_id word
 */
#define mine_selectBookFromMyBookcase @"selectBookFromMyBookcase"

/**
 *  我的 书架详情 归类
 *  bookid,user_id,case_id,classfy_id
 */
#define mine_classifybook @"classifybook"

/**
 *  我的 书架详情 所有归类
 *
 */
#define mine_selectBookcaseType @"selectBookcaseType"

/**
 *  我的 书架详情 更新书籍
 * case_id,islook,isborrow,book_id,booknumber
 */
#define mine_updateBook @"updateBook"


//消息

/**
 *  消息 根据环信列表获取书友列表
 *
 */
#define message_getUserByUserHxId @"getUserByUserHxId"

/**
 *  消息 根据环信列表获取读书会
 * group_Hx_idList
 */
#define message_getGroupByHx @"getGroupByHx"

/**
 *  消息 获取用户通知消息
 * 
 */
#define message_getUserNotice @"getUserNotice"
/**
 *  消息 更新用户通知消息的状态
 *
 */
#define message_UpdateUserNotice @"UpdateUserNotice"
/**
 *  消息 根据id获取补丁信息
 * patchid
 */
#define message_getpatchbypatchid @"getpatchbypatchid"
/**
 *  消息 根据ID获取书评
 *  
 */
#define message_getBookCommentBycomid @"getBookCommentBycomid"

/**
 *  消息 申请漂流
 *
 */
#define message_floatdone @"floatdone"

/**
 *  书+ 摇一摇 开始摇一摇换书活动
 * 参数：event_id
 */
#define event_beginShake @"beginShake"

/**
 *  书+ 摇一摇 组员点击参加摇一摇
 * 参数：eventid，userid
 */
#define event_joinShake @"joinShake"
/**
 *  书+ 摇一摇 获取结果
 * 参数：event_id
 */
#define event_overShake @"overShake"
/**
 *  书+ 摇一摇 结果 是否同意换书
 * 参数：event_id user_id isagree
 */
#define event_shakeIsAgree @"shakeIsAgree"
/**
 *
 * 参数：event_id
 */
#define event_getEventByGroup @"getEventByGroup"
/**
 *
 * 参数：user_id event_id
 */
#define event_insertEventNotice @"insertEventNotice"

