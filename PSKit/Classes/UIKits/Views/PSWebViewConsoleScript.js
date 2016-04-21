/* 
  PSWebViewConsoleScript.js
  PSKit
 
  Created by PoiSon on 15/9/23.
  Copyright (c) 2015年 yerl. All rights reserved.
*/
(function(){
   function log(info){
      var schemaStr = 'PSWEBSCHEMA://console_@_log';
      if(info != null){
         schemaStr += '_@_' + JSON.stringify([info]);
      }
      alert(schemaStr);
   }
 
   window.console = {
      log: log
   }
})();