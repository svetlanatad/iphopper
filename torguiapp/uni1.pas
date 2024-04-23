unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  IdHTTP, IdAuthentication;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    StatusBar1: TStatusBar;
    IdHTTP1: TIdHTTP;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;

implementation
uses fpjson, IdSSL, IdSSLOpenSSL, IdTCPClient, IdIOHandlerStack, IdGlobal, IdSocks;


{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
    HTTP: TIdHTTP;
    Response, city, country: string;
    JSON: TJSONObject;
    SocksInfo: TIdSocksInfo;
    SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
    IOHandlerStack: TIdIOHandlerStack;
begin

  HTTP := TIdHTTP.Create(nil);
    SocksInfo := TIdSocksInfo.Create(nil);
    IOHandlerStack := TIdIOHandlerStack.Create(nil);
    try
      SocksInfo.Host := '127.0.0.1';
      SocksInfo.Port := 9050;
      SocksInfo.Version := svSocks5;

      IOHandlerStack.TransparentProxy := SocksInfo;
      // for http
      //IOHandlerStack.Handler := SocksInfo;
      // for https
      // SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      // IOHandlerStack.Handler := SSLHandler;
      // SSLHandler.TransparentProxy := SocksInfo;

      HTTP.IOHandler := IOHandlerStack;

      HTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36';

    // Optionally set other headers
    //HTTP.Request.Accept := 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8';
    //HTTP.Request.AcceptLanguage := 'en-US,en;q=0.5';
    //HTTP.Request.AcceptEncoding := 'gzip, deflate';
    //HTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36';
    //HTTP.Request.Accept := 'application/json'; // Since you're expecting JSON response
    //HTTP.Request.Connection := 'keep-alive';

      try
        //Response := HTTP.Get('http://ipinfo.io/json?token=YOURTOKEN');
        //Response := HTTP.Get('http://ipinfo.io/46.3?token=YOURTOKEN');
        Response := HTTP.Get('http://ipinfo.io?token=REPLACE WITH YOUR TOKEN AFTER REGISTERING');
        JSON := TJSONObject(GetJSON(Response));
        try
          ShowMessage('Location: ' + JSON.Get('city', '') + ', ' + JSON.Get('country', ''));
          city := JSON.Get('city', ''); country := JSON.Get('country', '');
          //StatusBar1.Caption := 'Location: ' + city + ', ' + country;
          StatusBar1.Panels[0].Text := 'Location: ' + city + ', ' + country ;

        finally
          JSON.Free;
        end;
      except
        on E: Exception do
          ShowMessage('Failed to retrieve location: ' + E.Message);
      end;
    finally
      HTTP.Free;
      IOHandlerStack.Free;
      SocksInfo.Free;

    end;
end;

procedure RenewTorCircuit;
var
  TCPClient: TIdTCPClient;
begin
  TCPClient := TIdTCPClient.Create(nil);
  try
    TCPClient.Host := '127.0.0.1';
    TCPClient.Port := 9051; 
    TCPClient.Connect;
    try
      TCPClient.IOHandler.WriteLn('AUTHENTICATE "REPLACE WITH YOUR PASSWORD"');
      TCPClient.IOHandler.WriteLn('SIGNAL NEWNYM');
    finally
      TCPClient.Disconnect;
    end;
  finally
    TCPClient.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  RenewTorCircuit
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Button1.Caption:= 'check';
  Button2.Caption:= 'change tor exit node';
  if StatusBar1.Panels.Count = 0 then
  begin
    with StatusBar1.Panels.Add do
    begin
      Width := 200; 
      Text := '';   
    end;
  end;
end;
end.


