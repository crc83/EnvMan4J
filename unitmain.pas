unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ListFilterEdit, SynHighlighterHTML,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, EditBtn, Grids, ActnList, Menus, ComCtrls, unitSettings;

type

  { TformMain }

  TformMain = class(TForm)
    actUssage: TAction;
    actNewVar: TAction;
    actOptions: TAction;
    actSelectDirectory: TAction;
    edtNewVar: TLabeledEdit;
    mainActionList: TActionList;
    edtPath: TLabeledEdit;
    listBoxEnvVars: TListBox;
    mainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    miChagePath: TMenuItem;
    miHelp: TMenuItem;
    miOptions: TMenuItem;
    pnlTop: TPanel;
    pnlLeftBottom: TPanel;
    pnlBottom: TPanel;
    selDir: TSelectDirectoryDialog;
    StatusBar1: TStatusBar;
    procedure actNewVarExecute(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure actSelectDirectoryExecute(Sender: TObject);
    procedure actUssageExecute(Sender: TObject);
    procedure edtNewVarKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormShow(Sender: TObject);
    procedure listBoxEnvVarsDblClick(Sender: TObject);
    procedure listBoxEnvVarsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    settings :TSettingsRecord;
    procedure FillEnvVariables;
    procedure ChangeEnvVariable;
    procedure AddEnvVariable(variable,value :String);
    { private declarations }
  public
    { public declarations }
    constructor Create(TheOwner: TComponent); override;
  end;


  function RemoveTrailingSlashes(S: String):String;

var
  formMain: TformMain;

implementation
uses
  EnvVarSave, unithelp;
{$R *.lfm}

procedure TformMain.listBoxEnvVarsDblClick(Sender: TObject);
begin
  ChangeEnvVariable;
end;

//changes value of env variable
procedure TformMain.ChangeEnvVariable;
var
  variable,oldValue, newValue :String;
  path:String;
begin
  //save env variable
  listBoxEnvVars.Items.GetNameValue(listBoxEnvVars.ItemIndex,
      variable, oldValue);
  newValue := RemoveTrailingSlashes(edtPath.Text);
  SetGlobalEnvironment(variable,newValue,settings.userVariables);
  //update path
  if settings.useHardcodedPathes then begin
    oldValue := RemoveTrailingSlashes(oldValue);
    path := GetEnvironmentVariable('PATH');
    path := StringReplace(path,oldValue,newValue, [rfReplaceAll, rfIgnoreCase]);
    SetGlobalEnvironment('PATH',path,settings.userVariables);
  end;
  //fill model
  FillEnvVariables;
end;

//let's add nev variable
procedure TformMain.AddEnvVariable(variable,value :String);
var
   path :String;
begin
  SetGlobalEnvironment(variable,value,settings.userVariables);
  if settings.addNewVarToPath then
  begin
    //add new variable to path
    path := GetEnvironmentVariable('PATH')+';';
    if settings.useHardcodedPathes then
      path := path+value
    else
      path := path+'%'+variable+'%';
    path:=path+'\bin';
    SetGlobalEnvironment('PATH',path,settings.userVariables);
  end;
  //fill model
  FillEnvVariables;
end;

//Set's new value to variable in a list
procedure TformMain.listBoxEnvVarsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then begin
     ChangeEnvVariable;
     if settings.closeOnEnter then
       Application.Terminate;
  end;
end;

procedure TformMain.actSelectDirectoryExecute(Sender: TObject);
begin
    if selDir.Execute then
      edtPath.Text:= selDir.FileName;
end;


procedure TformMain.actOptionsExecute(Sender: TObject);
begin
  //Loads settings into form
  frmSettings.setSettingsToUI(settings);
  frmSettings.ShowModal;
  if frmSettings.ModalResult = mrOK then begin
     //get's changed settings
     settings := frmSettings.getSettingsFromUI;
     //and saves it
     frmSettings.saveSettings(settings);
     //list should be filled again, because filter may have been changed
     FillEnvVariables;
  end;
end;

procedure TformMain.actNewVarExecute(Sender: TObject);
begin
    edtNewVar.Visible:=true;
    edtNewVar.SetFocus;
end;

procedure TformMain.actUssageExecute(Sender: TObject);
begin
    formHelp.ShowModal;
end;

//Add new variable on Enter key
procedure TformMain.edtNewVarKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key = 13 then begin
        AddEnvVariable(edtNewVar.Text, edtPath.Text);
        if settings.closeOnEnter then
          Application.Terminate;
     end;
end;

procedure TformMain.FormShow(Sender: TObject);
begin
  listBoxEnvVars.SetFocus;
end;

//Fills list with environment variables name,value pairs
procedure TformMain.FillEnvVariables;
var
  EnvVarName: string;
  I, J: integer;
begin
  listBoxEnvVars.Clear;
  for I := 0 to GetEnvironmentVariableCount - 1 do
  begin
    EnvVarName := GetEnvironmentString(I);
    //filter only JAVA related variables
    for J:=0 to settings.filterList.Count-1 do begin
        if pos(settings.filterList.Strings[J], EnvVarName) > 0 then
              listBoxEnvVars.AddItem(EnvVarName, TObject(GetEnvironmentVariable(
                                                 EnvVarName)));

    end;
  end;
end;

constructor TformMain.Create(TheOwner: TComponent);
var
  Path: string;
  Variable: string;
  AStrList:TStringList;
begin
  inherited;
  //load settings
  settings := frmSettings.loadSettings;
  //Add path from command line
  if Application.HasOption('p', 'path') then
    Path := RemoveTrailingSlashes(Application.GetOptionValue('p', 'path'));

  edtPath.Text := Path;
  //Add environment variables to listbox
  FillEnvVariables;
end;

function RemoveTrailingSlashes(S: String):String;
var
  S1: String;
begin
  S1 :=S[Length(S)];
  if (S[Length(S)] = '\') or (S[Length(S)] = '/') then begin
     Result := LeftStr(S,Length(S)-1);
  end else
      Result := s;
end;

end.
