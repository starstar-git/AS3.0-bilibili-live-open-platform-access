AS3.0 bilibili live open platform access. 
I wrote it myself, but there are many errors that can not be accessed, and can only provide ideas. 
There is a pit, will point out, hope to have the big guy perfect.

AS3.0 bilibili直播开放平台接入。
自己写了下但是有很多错误无法接入，只能提供思路。有坑，会指出，希望有大佬完善。

坑1：
项目内MD5编码错误的。这里需要32位小写。请自己处理。
com.adobe.crypto.MD5;MD5.hash()这个函数。结果错误。

坑2（可能）：
AS3.0无发发送POST，JSON。导致服务器不接受，报2032错误。[IOErrorEvent type="ioError" bubbles=false cancelable=false eventPhase=2 text="Error #2032: Stream Error. URL: app:/live-open.biliapi.com/v2/app/start" errorID=2032]
如果发送URLVariables，发送数据和服务器的数据不匹配，导致无法连接？（可能）

Bx_danmu.rar为项目压缩包，VSCODE

注意：本项目纯属个人储存代码，无法直接运行，清自行斟酌
