//******************************************************************************
//* DeGsoft GeN                                                                *
//* ===========                                                                *
//* GeN(tm) : ERP Software (http://www.degsoft.com.ar/sistemas/GeN)            *
//* Copyright (c) 2002-2011 by the Degsoft                                     *
//* For more information visit: http://www.degsoft.com.ar                      *
//* This program is free software. You can redistribute it and/or modify       *
//* it under the terms of the GNU General Public License as published by       *
//* the Free Software Foundation; either version 3 of the License.             *
//******************************************************************************

unit BuscarPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Buttons, Grids, DBGrids, DataModule, ExtCtrls,
  IBCustomDataSet, IBQuery, jpeg, ImprimirDM;

type
  TBuscarPlanForm = class(TForm)
    DBGrid1: TDBGrid;
    DataSource: TDataSource;
    Panel1: TPanel;
    Label2: TLabel;
    NombreEdit: TEdit;
    Panel2: TPanel;
    SiBitBtn: TBitBtn;
    Tabla: TIBQuery;
    Image1: TImage;
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure SiBitBtnClick(Sender: TObject);
    procedure NoBitBtnClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BuscarPlanForm: TBuscarPlanForm;

implementation

{$R *.dfm}

procedure TBuscarPlanForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if not DbGrid1.Focused = True then
 begin
 Tabla.SQL.Text:=' select * from "Plan" where ("Plan".NOMBRE LIKE '+QuotedStr(NombreEdit.Text+'%')+')';
 Tabla.Open;
 end;
end;

procedure TBuscarPlanForm.DBGrid1DblClick(Sender: TObject);
begin
SiBitBtnClick(DBGrid1);
end;

procedure TBuscarPlanForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   IF Key = VK_DOWN then
   DbGrid1.SetFocus;
end;

procedure TBuscarPlanForm.FormShow(Sender: TObject);
begin
Tabla.Open;
end;

procedure TBuscarPlanForm.Image1Click(Sender: TObject);
begin
 ImprimirDataModule := TImprimirDataModule.Create(self);
 ImprimirDataModule.CSV(Tabla.SQL.Text,'PLAN');
 ImprimirDataModule.Free;
end;

procedure TBuscarPlanForm.NoBitBtnClick(Sender: TObject);
begin
   Close;
end;

procedure TBuscarPlanForm.SiBitBtnClick(Sender: TObject);
begin
   Close;
end;

end.
