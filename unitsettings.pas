unit unitSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, XMLConf, FileUtil, Forms, Controls, Graphics, Dialogs,
  INIFiles, ExtCtrls, CheckLst, StdCtrls, ComCtrls, XMLPropStorage;

type

  TSettingsRecord = record
    filterList: TStringList;
    closeOnEnter : Boolean;
    addNewVarToPath : Boolean;
    useHardcodedPathes : Boolean;
  end;


  { TfrmSettings }

  TfrmSettings = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    checkOnChange: TCheckGroup;
    edtFilter: TLabeledEdit;
  private
    { private declarations }
    function SetFilterListText(S: String):TStringList;
  public
    { public declarations }
    function loadSettings:TSettingsRecord;
    function getSettingsFromUI:TSettingsRecord;
    procedure setSettingsToUI(settings:TSettingsRecord);
    procedure saveSettings(settings:TSettingsRecord);
  end;
const
  GENERAL : String = 'General';
    FILTER_LIST         : String = 'filterList';
    ADD_NEW_VAR_TO_PATH : String = 'addNewVarToPath';
    CLOSE_ON_ERROR      : String = 'closeOnEnter';
    USE_HARDCODED_PATHES: String = 'useHardcodedPathes';
  SETTINGS_FN:String='EnvMan4j.ini';
var
  frmSettings: TfrmSettings;

implementation

{$R *.lfm}

function TfrmSettings.SetFilterListText(S: String):TStringList;
begin
     Result := TStringList.Create;
     Result.Delimiter:=';';
     Result.DelimitedText:= S;

end;

function TfrmSettings.loadSettings:TSettingsRecord;
var
   ini : TINIFile;
begin
     ini := TINIFile.Create(SETTINGS_FN);

     Result.filterList := SetFilterListText(ini.ReadString(GENERAL,FILTER_LIST,'_HOME;_WORK'));

     Result.addNewVarToPath:=ini.ReadBool(GENERAL,ADD_NEW_VAR_TO_PATH,true);
     Result.closeOnEnter:=ini.ReadBool(GENERAL,CLOSE_ON_ERROR,true);
     Result.useHardcodedPathes:=ini.ReadBool(GENERAL,USE_HARDCODED_PATHES,false);
end;

function TfrmSettings.getSettingsFromUI:TSettingsRecord;
begin
     Result.filterList := SetFilterListText(edtFilter.Text);

     Result.closeOnEnter:=checkOnChange.Checked[0];
     Result.addNewVarToPath:=checkOnChange.Checked[1];
     Result.useHardcodedPathes:=checkOnChange.Checked[2];
end;

procedure TfrmSettings.setSettingsToUI(settings:TSettingsRecord);
begin
     edtFilter.Text := settings.filterList.DelimitedText;
     checkOnChange.Checked[0]:=settings.closeOnEnter;
     checkOnChange.Checked[1]:=settings.addNewVarToPath;
     checkOnChange.Checked[2]:=settings.useHardcodedPathes;
end;

procedure TfrmSettings.saveSettings(settings:TSettingsRecord);
var
   ini : TINIFile;
   filterListString : String;
begin
     ini := TINIFile.Create(SETTINGS_FN);
     ini.WriteString(GENERAL,FILTER_LIST,settings.filterList.DelimitedText);
     ini.WriteBool(GENERAL,ADD_NEW_VAR_TO_PATH,settings.addNewVarToPath);
     ini.WriteBool(GENERAL,CLOSE_ON_ERROR,settings.closeOnEnter);
     ini.WriteBool(GENERAL,USE_HARDCODED_PATHES,settings.useHardcodedPathes);
end;

end.

