unit unithelp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, SynHighlighterHTML, Forms, Controls,
  Graphics, Dialogs, StdCtrls;

type

  { TformHelp }

  TformHelp = class(TForm)
    btnOk: TButton;
    synHtml: TSynHTMLSyn;
    helpMemo: TSynMemo;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  formHelp: TformHelp;

implementation

{$R *.lfm}

{ TformHelp }

procedure TformHelp.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TformHelp.FormShow(Sender: TObject);
begin
    btnOk.SetFocus;
end;

end.

