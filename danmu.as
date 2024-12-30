package 
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequestHeader;
	import com.adobe.crypto.HMAC;
	import com.adobe.crypto.SHA256;
	import flash.events.IOErrorEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import com.adobe.crypto.MD5;
	import flash.utils.ByteArray;
	
	public class danmu extends Sprite
	{
		private var tx:TextField=new TextField;
		public function danmu(){
			super();

			danmu_fc();
			add_text();
		}
		public function danmu_fc():void{
			var params:Object={"code":"主播身份码","app_id":"项目ID"};
			var url:String="live-open.biliapi.com/v2/app/start";


			var _request:URLRequest=new URLRequest();
			var datereq:URLVariables=new URLVariables();
			datereq.code="主播身份码";
			datereq.app_id="项目ID";

			//错误代码1
			//无法传输JSON，查过资料。如果不使用URLVariables，数据会自动以get方法发送，2032错误。但是使用，其数据结构服务器不会通过验证
			_request.data=datereq;
			
			var headersArr:Array=new Array

			//签名
			var accesskeyidValue:String="签名";
			
			var date:Date=new Date();
			var timestamp:Number=Math.floor(date.time/1000);
			var signatureNonceValue:String=Math.floor(Math.random()*100000000)+""+timestamp;
			
			//错误代码2

			// 官方给的API出的数据是错误的
			var data_md5:String=MD5.hash(JSON.stringify(params));

			// 数据
			var dataToEncode:String = "x-bili-accesskeyid:"+accesskeyidValue  + "\n" +
										"x-bili-content-md5:"+data_md5 + "\n" +
										"x-bili-signature-method:HMAC-SHA256" + "\n" +
										"x-bili-signature-nonce:"+signatureNonceValue + "\n" +
										"x-bili-signature-version:1.0"+"\n" +
										"x-bili-timestamp:"+timestamp  ;
			// 密钥
			var secretKey:String = "密钥";
								
			var signature:String=HMAC.hash(secretKey,dataToEncode,SHA256);
			
			headersArr.push(new URLRequestHeader("Accept","application/json"));
			headersArr.push(new URLRequestHeader("Content-Type","application/json"));
			headersArr.push(new URLRequestHeader("x-bili-content-md5",data_md5));
			headersArr.push(new URLRequestHeader("x-bili-timestamp",""+timestamp));
			headersArr.push(new URLRequestHeader("x-bili-signature-method","HMAC-SHA256"));
			headersArr.push(new URLRequestHeader("x-bili-signature-nonce",signatureNonceValue));
			headersArr.push(new URLRequestHeader("x-bili-accesskeyid",accesskeyidValue));
			headersArr.push(new URLRequestHeader("x-bili-signature-version","1.0"));
			headersArr.push(new URLRequestHeader("Authorization",signature));
			
			_request.requestHeaders=headersArr;
			_request.method=URLRequestMethod.POST;
			_request.contentType="application/json";
			_request.url=url;

			for each(var value:Object in headersArr)
			{
				trace(value.name+":"+value.value+",");
			}
			trace(_request.data)
			var loader:URLLoader=new URLLoader;
			loader.addEventListener(Event.COMPLETE,completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,err_fc)
			loader.load(_request);

			//备用代码，报废
			function getMD5Hash(input:String):String {
				// 创建一个ByteArray对象
				var byteArray:ByteArray = new ByteArray();
				// 将输入字符串写入ByteArray
				byteArray.writeUTFBytes(input);
				// 创建一个MD5对象
				// 计算MD5哈希
				MD5.hashBinary(byteArray);
				var hash:ByteArray=MD5.digest;

				// 将哈希转换为32进制字符串
				var hashString:String = "";
				for (var i:uint = 0; i < hash.length; i++) {
					// 确保每个字节转换为两位16进制数
					hashString += hash[i].toString(32);
				}
				
				return hashString;
			}
		}
		public function err_fc(e:IOErrorEvent):void{
			trace(e)
			tx.text=tx.text+"\n"+e;
			tx.scrollV=tx.textHeight;
		}
		public function completeHandler(evt:Event):void{
			trace(evt.target.data);
			tx.text=tx.text+"\n"+evt.target.data;
			tx.scrollV=tx.textHeight;
		}

		public function add_text():void{

			addChild(tx);

			tx.text="请求开始"
			tx.width=500;
			tx.height=500;
			tx.border=true;
			tx.wordWrap=true;
			
		}
	}
}