
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Menus, IdHTTP, IdSocks, IdIOHandlerStack; // Include IdIOHandlerStack unit

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    IdHTTP1: TIdHTTP;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    StatusBar1: TStatusBar;
    ToggleBox1: TToggleBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

uses
  fpjson;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Name:= 'aaa';
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  HTTP: TIdHTTP;
  Response: string;
  JSON: TJSONObject;
  SocksInfo: TIdSocksInfo;
  IOHandlerStack: TIdIOHandlerStack;
begin
  HTTP := TIdHTTP.Create(nil);
  SocksInfo := TIdSocksInfo.Create(nil);
  IOHandlerStack := TIdIOHandlerStack.Create(HTTP);
  try
    SocksInfo.Host := '127.0.0.1';
    SocksInfo.Port := 9050;
    IOHandlerStack.TransparentProxy := SocksInfo;
    HTTP.IOHandler := IOHandlerStack;

    try
      Response := HTTP.Get('http://ipinfo.io/json'); 
      JSON := TJSONObject(GetJSON(Response));
      try
        ShowMessage('Location: ' + JSON.Get('city', '') + ', ' + JSON.Get('country', ''));
      finally
        JSON.Free;
      end;
    except
      on E: Exception do
        ShowMessage('Failed to retrieve location: ' + E.Message);
    end;
  finally
    HTTP.Free;
    SocksInfo.Free;
    IOHandlerStack.Free;
  end;
end;

end.              
