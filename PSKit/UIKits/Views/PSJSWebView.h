//
//  PSJSWebView.h
//  PSKit
//
//  Created by PoiSon on 15/10/14.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView(PSJSWebView)
@property (nonatomic, assign) BOOL ps_printLogs;/**< 重写Javascript的Console.log方法，在xcode的日志中输出 */
/**
 *  向WebView插入一个脚本，以支持Js与Native交互
 *  已支持Json的基本数据类型(仅支持OC对象)
 *
 *  @param interface Javascript对象
 *  @param name      Javascript对象名称
 *
 *  使用方法：
 *  HTML:  ${name}.execute("doSomething",
 *                         {arg1: "arg1",
 *                          arg2: "arg2"
 *                         });
 *  将会调用Native端: [${interface} doSomething:(NSDictionary *)args];
 *
 *  【注意】：JS调用Native使用异步线程，如果需要更新UI，请在主线程进行
 */
- (void)ps_addJavascriptInterface:(id)interface withJSObjectName:(NSString *)name;
@end