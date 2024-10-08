//#include <lib_helpers.mqh>

#define WS_TIMEOUT 30
#define WS_HEST_BEAT 45

#property version   "1.00"
#property strict

#import "mt4-common.dll"
   int Init( int id, const uchar &url[], int timeout, int heatBeatPeriod);
   int SetHeader( int id, const uchar &key[], const uchar &value[]);
   int GetCommand(int id, uchar &data[]);
//   int httpSendPost(const uchar &url[], const uchar &in[], int timeout, uchar &output[]);
   int WSGetLastError(int id, uchar &data[]);   
   int SendCommand(int id, const uchar &command[]);
   void Deinit(int id);
   int CreateWS();
#import

class WebSocketsProcessor 
///: public SendHandler  
{

private:
  bool _isInited;
  string _host;
  int _timeout;;
  int _heatBeatPeriod;
  int _id;
public:
  
  WebSocketsProcessor(string host_, int timeout_, int heatBeatPeriod_) {
    _host = host_;
    _timeout = timeout_;
    _heatBeatPeriod = heatBeatPeriod_;
    _id = ::CreateWS();
  }

  void Send(string message) {
    if(!_isInited)
      return;
  
    SendCommand( _id, message );
  }
  
  string Get() {
    if(!_isInited) {
      Print("not inited");
      return "";
      }
  
    return GetCommand( _id );
  }
  
  void ReInit() {
    Deinit(_id);
      
    _isInited = ws_Init( _id, _host, _timeout, _heatBeatPeriod);
    
  }

  void DeInit() {    
    Deinit(_id);
  }
    
  int Init() {
    _isInited = ws_Init( _id, _host, _timeout, _heatBeatPeriod);
    
    return IsInited();
  }
  
  bool IsInited() {
    return _isInited;
  }
  
  string GetLastError() {
    return WS_GetLastError(_id);
  }

  void SetHeader(string _key, string _value) {
    //if(!_isInited)
    //  return;
  
    ws_SetHeader( _id, _key, _value );
  }

  static int ws_Init(int _id, string _host, int _timeout, int _heatBeatPeriod) {
   uchar __host[];
   StringToCharArray(_host, __host);
   
   return ::Init(_id, __host, _timeout, _heatBeatPeriod);
}

  static void ws_SetHeader(int _id, string _key, string _value) {
    uchar __key[], __value[];  
    StringToCharArray(_key, __key);
    StringToCharArray(_value, __value);
   
    ::SetHeader(_id, __key, __value);
  }


  static string WS_GetLastError(int _id) {
    uchar _error[8048];
  
    WSGetLastError( _id, _error );
          
    return CharArrayToString( _error );
  }

  static string GetCommand(int _id) {
    uchar _command[260480];
    
    int r = 0;
    r = ::GetCommand( _id, _command );
   
    if(r == 1) {
      return CharArrayToString( _command );
    }
   
    return "";
  }
  
  static void SendCommand(int _id, string command) {
   uchar __command[];
   StringToCharArray(command, __command);

   ::SendCommand(_id, __command);
  }
};
