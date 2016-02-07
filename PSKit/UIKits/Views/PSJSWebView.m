//
//  PSJSWebView.m
//  PSKit
//
//  Created by PoiSon on 15/10/14.
//  Copyright © 2015年 yerl. All rights reserved.
//

#import "PSJSWebView.h"
#import "PSFoudation.h"
#import "PSAspect.h"
#import <objc/message.h>

#pragma mark - private interface
@interface UIWebView()<UIWebViewDelegate>
@property (nonatomic, readonly, retain) NSMutableDictionary *ps_javascriptInterfaces;
@end

#pragma mark - @implementation
@implementation UIWebView (PSJSWebView)
PSAssociatedKey(PS_PRINT_LOGS_KEY);
- (BOOL)ps_printLogs{
    return [[self ps_associatedObjectForKey:PS_PRINT_LOGS_KEY] boolValue];
}
- (void)setPs_printLogs:(BOOL)ps_printLogs{
    [self ps_setAssociatedObject:@(ps_printLogs) forKey:PS_PRINT_LOGS_KEY];
}

- (NSMutableDictionary *)ps_javascriptInterfaces{
    PSAssociatedKeyAndNotes(PS_JAVASCRIPT_INTERFACES_KEY, "Store the javascript interfaces.");
    return [self ps_associatedObjectForKey:PS_JAVASCRIPT_INTERFACES_KEY storeProlicy:PSStoreUsingRetainNonatomic setDefault:^id{
        return [NSMutableDictionary new];
    }];
}

- (void)ps_addJavascriptInterface:(id)interface withJSObjectName:(NSString *)name{
    PSAssert(name.length, @"JSObjectName不能为空");
    PSAssert(![name ps_isEqualsIgnoreCase:@"console"], @"JSObjectName不能为console");
    PSAssert(![self.ps_javascriptInterfaces ps_containsKey:name], format(@"JSObject:%@ 已被注册", name));
    
    if (self.ps_javascriptInterfaces.count) {
        [self ps_aspect_method];
    }
    
    [self.ps_javascriptInterfaces setObject:interface forKey:name];
}

- (void)ps_aspect_method{
    //拦截webView:didFirstLayoutInFrame:方法
    //在此方法中将JS脚本注入到HTML
    [PSAspect interceptSelector:NSSelectorFromString(@"webView:didFirstLayoutInFrame:")
                     inInstance:self
                withInterceptor:interceptor(^(NSInvocation *invocation) {
        
        if (self.ps_printLogs) {
            //添加console指令
            //see PSWebViewConsoleScript.js
            NSString *consoleJs = @"(function(){\n   function log(info){\n      var schemaStr = \'PSWEBSCHEMA://console_@_log\';\n      if(info != null){\n         schemaStr += \'_@_\' + JSON.stringify([info]);\n      }\n      alert(schemaStr);\n   }\n   window.console = {\n      log: log\n   }\n})();";
            [invocation.target stringByEvaluatingJavaScriptFromString:consoleJs];
        }
        
        //添加JavascriptInterface
        //@see PSWebViewScript.js
        NSString *js = @"(function(){\n   if (window.${JSObject}){return}\n   function execute(func, args){\n      var schemaStr = \'PSWEBSCHEMA://${JSObject}_@_\' + func ;\n      if(args != null){\n         schemaStr += \'_@_\' + JSON.stringify([args]);\n      }\n      alert(schemaStr);\n   }\n   window.${JSObject} = {\n      execute: execute\n   }\n})();";
        for (NSString *JSObjectName in [[invocation.target ps_javascriptInterfaces] allKeys]) {
            NSString *replacedJs = [js stringByReplacingOccurrencesOfString:@"${JSObject}" withString:JSObjectName];
            [invocation.target stringByEvaluatingJavaScriptFromString:replacedJs];
        }
        [invocation invoke];
    })];
    //拦截webview的alert方法
    //如果alert的内容符合协议格式，则将此alert拦截下来进行处理
    [PSAspect interceptSelector:NSSelectorFromString(@"webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:")
                     inInstance:self
                withInterceptor:interceptor(^(NSInvocation *invocation) {
        __unsafe_unretained NSString *message;
        [invocation getArgument:&message atIndex:3];
        
        if ([message hasPrefix:@"PSWEBSCHEMA://"]) {
            NSArray *infos = [message componentsSeparatedByString:@"_@_"];
            NSString *interfaceName = [infos[0] stringByReplacingOccurrencesOfString:@"PSWEBSCHEMA://" withString:@""];
            
            if ([interfaceName isEqualToString:@"console"]) {
                //同步处理console指令
                NSString *log = @"";
                if (infos.count > 2) {
                    log = [infos[2] ps_jsonArray][0];
                }
                
                PSPrintf(@"%@ Javascript Interface [Console]:\n%@\n\n", [[NSDate new] ps_toString:@"yyyy-MM-dd HH:mm:ss.SSS"], log);
            }else{
                [self ps_performBlockAsync:^{
                    //异步处理常规指令
                    id interface = [[invocation.target ps_javascriptInterfaces] objectForKey:interfaceName];
                    NSString *selectorStr = infos[1];
                    id params = nil;
                    if (infos.count > 2) {
                        selectorStr = [selectorStr stringByAppendingString:@":"];
                        params = [infos[2] ps_jsonArray][0];
                    }
                    if ([interface respondsToSelector:NSSelectorFromString(selectorStr)]){
                        ((void (*)(id, SEL, id))objc_msgSend)(interface, NSSelectorFromString(selectorStr), params);
                    }else{
                        PSPrintf(@"%@ Javascript Interface [Warning]:\n在[%@]中没有找到[%@]方法\n", [[NSDate new] ps_toString:@"yyyy-MM-dd HH:mm:ss.SSS"], interface, selectorStr);
                    }
                }];
            }
        }else{
            [invocation invoke];
        }
    })];
}
@end
