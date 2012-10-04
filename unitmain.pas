unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ListFilterEdit, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, ValEdit, StdCtrls, EditBtn, FileCtrl, Grids, CheckLst;

type

  { TformMain }

  TformMain = class(TForm)
    Button1: TButton;
    edtPath: TLabeledEdit;
    listBoxEnvVars: TListBox;
    memoLog: TMemo;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure listBoxEnvVarsDblClick(Sender: TObject);
  private
    procedure FillEnvVariables;
    { private declarations }
  public
    { public declarations }
    constructor Create(TheOwner: TComponent); override;
  end;

var
  formMain: TformMain;

implementation

{$R *.lfm}

procedure TformMain.listBoxEnvVarsDblClick(Sender: TObject);
begin
  memoLog.Append('cliked on ::' + listBoxEnvVars.GetSelectedText);
  //save env variable
  SetEnvironmentVariable('ROO_HOME','EEE');
  //fill model
  FillEnvVariables;
end;

procedure TformMain.FillEnvVariables;
var
  EnvVarName: string;
  I: integer;
begin
  listBoxEnvVars.Clear;
  for I := 0 to GetEnvironmentVariableCount - 1 do
  begin
    EnvVarName := GetEnvironmentString(I);
    //filter only JAVA related variables
    if pos('_HOME', EnvVarName) > 0 then
      listBoxEnvVars.AddItem(EnvVarName, TObject(GetEnvironmentVariable(
        EnvVarName)));
  end;
end;

constructor TformMain.Create(TheOwner: TComponent);
var
  Path: string;
  Variable: string;
begin
  inherited;
  //Add path from command line

  Path := Application.GetOptionValue('p', 'path');
  Variable := Application.GetOptionValue('v', 'var');
  memoLog.Append('path ::' + Path);
  memoLog.Append('var  ::' + Variable);
  edtPath.Text := Path;
  //Add environment variables to listbox
  FillEnvVariables;
end;

end.
