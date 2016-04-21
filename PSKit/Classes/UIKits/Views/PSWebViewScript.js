/* 
  PSWebViewScript.js
  PSKit

  Created by PoiSon on 15/9/23.
  Copyright (c) 2015年 yerl. All rights reserved.
*/
(function(){
   if (window.${JSObject}){return}
 
   function execute(func, args){
      var schemaStr = 'PSWEBSCHEMA://${JSObject}_@_' + func ;
      if(args != null){
         schemaStr += '_@_' + JSON.stringify([args]);
      }
      alert(schemaStr);
   }
 
   window.${JSObject} = {
      execute: execute
   }
})();