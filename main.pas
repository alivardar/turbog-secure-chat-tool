unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, StdCtrls, DCPdes, DCPsha1;

type

  { TMyThread }
TMyThread = class(TThread)

  private
    fStatusText: string;
    procedure ShowStatus;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean);
  end;

  { Tmainform }

  Tmainform = class(TForm)
    DCP_des1: TDCP_des;
    DCP_sha1_1: TDCP_sha1;
    Edit1: TEdit;
    Edit2: TEdit;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }

  end; 

var
  mainform: Tmainform;
  MyThread : TMyThread;
  DESkey : String='12345678';
  portnumber: String='80';
  portnumberchanged: Boolean=False;


implementation

uses preferences, about, blcksock;

{$R *.lfm}


{ TMyThread }

procedure TMyThread.Execute;
var
  Sock:TUDPBlockSocket;
  size:integer;
  buf:string;
begin
//UDP Server listening
 Sock:=TUDPBlockSocket.Create;
  try
    sock.bind('0.0.0.0', portnumber);
    if sock.LastError>0 then
      begin
      mainform.Memo1.Lines.Add('Server can not bind....'+chr(13));
      exit;
      end;

    while True do
    begin
        if terminated then
          begin
          mainform.Memo1.Lines.Add('Terminated..'+chr(13));
          break;
          end;

          buf := sock.RecvPacket(100);
	  if buf<>'' then
	  begin
          mainform.Memo1.Font.Style:=mainform.Memo1.Font.Style+[fsbold];
          mainform.Memo1.Lines.Add('enc -> ' + buf+chr(13));

          mainform.DCP_des1.Initstr(Deskey, TDCP_sha1);
          mainform.memo1.Lines.Add('clear -> ' + mainform.DCP_des1.DecryptString(buf));
          mainform.Memo1.Font.Style:=mainform.Memo1.Font.Style-[fsbold];
          end;

        if portnumberchanged then break;
        sleep(1);
    end;
    sock.CloseSocket;
  finally
    sock.free;
  end;

if portnumberchanged then Execute;

end;


constructor TMyThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TMyThread.ShowStatus;
begin
  mainform.StatusBar1.SimpleText := 'Status';
end;

//------------------------------------------------------

{ Tmainform }

procedure Tmainform.MenuItem1Click(Sender: TObject);
begin

end;

procedure Tmainform.MenuItem10Click(Sender: TObject);
begin
  Application.CreateForm(Tformabout, formabout);
  formabout.showmodal;
end;

procedure Tmainform.FormShow(Sender: TObject);
begin
MyThread := TMyThread.Create(True);
 if Assigned(MyThread.FatalException) then raise MyThread.FatalException;
MyThread.Resume;
end;


procedure Tmainform.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=13 then ToolButton2Click(Sender);
end;



procedure Tmainform.MenuItem6Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure Tmainform.MenuItem7Click(Sender: TObject);
begin
  Memo1.SelectAll;
end;

procedure Tmainform.MenuItem8Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure Tmainform.MenuItem9Click(Sender: TObject);
begin
  Application.CreateForm(Tformpref, formpref);
  formpref.ShowModal;
end;

procedure Tmainform.ToolButton2Click(Sender: TObject);
var
Sock:TUDPBlockSocket;
Sendmessage:String;
begin

 Memo1.Font.Style:=mainform.Memo1.Font.Style-[fsbold];
 Memo1.Lines.Add('me -->' + Edit2.Text);

 //Encyrpt with DES and sha1 hash
 DCP_des1.Initstr(Deskey, TDCP_sha1);
 Sendmessage:=DCP_des1.EncryptString(Edit2.Text);

 try
 Sock:=TUdpBlockSocket.create;
 //IP control routine must be have
 Sock.Connect(Edit1.Text, portnumber);
 if sock.LastError>0 then Memo1.Lines.Add(chr(13)+'Can not connect!'+chr(13));
 Sock.SendString(sendmessage);
 Sock.CloseSocket;
 except
   Memo1.Lines.Add(chr(13)+'Can not send your message!'+chr(13));
 end;
end;

end.

