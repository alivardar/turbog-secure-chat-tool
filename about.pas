unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, StdCtrls;

type

  { Tformabout }

  Tformabout = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  formabout: Tformabout;

implementation

{$R *.lfm}

{ Tformabout }

procedure Tformabout.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.

