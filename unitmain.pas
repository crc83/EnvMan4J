unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ListFilterEdit, SynHighlighterHTML,
  SynExportHTML, SynMemo, Forms, Controls, Graphics, Dialogs, ExtCtrls, ValEdit,
  StdCtrls, EditBtn, FileCtrl, Grids, CheckLst, ActnList;

type

  { TformMain }

  TformMain = class(TForm)
    actSelectDirectory: TAction;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    edtNewVar: TLabeledEdit;
    mainActionList: TActionList;
    Button1: TButton;
    Button2: TButton;
    edtPath: TLabeledEdit;
    listBoxEnvVars: TListBox;
    selDir: TSelectDirectoryDialog;
    StaticText1: TStaticText;
    procedure actSelectDirectoryExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure listBoxEnvVarsDblClick(Sender: TObject);
    procedure listBoxEnvVarsKeyPress(Sender: TObject; var Key: char);
    procedure listBoxEnvVarsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure FillEnvVariables;
    procedure ChangeEnvVariable;
    { private declarations }
  public
    { public declarations }
    constructor Create(TheOwner: TComponent); override;
  end;

var
  formMain: TformMain;

implementation
uses
  EnvVarSave;
{$R *.lfm}

procedure TformMain.listBoxEnvVarsDblClick(Sender: TObject);
begin
  ChangeEnvVariable;
end;

procedure TformMain.ChangeEnvVariable;
var
  selName,value :String;
begin
  //save env variable
  listBoxEnvVars.Items.GetNameValue(listBoxEnvVars.ItemIndex,
      selName, value);
  SetGlobalEnvironment(selName,edtPath.Text,false);
  //fill model
  FillEnvVariables;
end;


procedure TformMain.listBoxEnvVarsKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TformMain.listBoxEnvVarsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13then
     ChangeEnvVariable;
end;

procedure TformMain.actSelectDirectoryExecute(Sender: TObject);
begin
    if selDir.Execute then
      edtPath.Text:= selDir.FileName;
end;

procedure TformMain.FormShow(Sender: TObject);
begin
  listBoxEnvVars.SetFocus;
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
  edtPath.Text := Path;
  //Add environment variables to listbox
  FillEnvVariables;
end;

end.
