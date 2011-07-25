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

unit PagoIVAF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DataModule, DB, ComCtrls,
  IBCustomDataSet, IBQuery, OleCtrls, SHDocVw;

type
  TPagoIVAForm = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Panel2: TPanel;
    AceptarBitBtn: TBitBtn;
    SalirBitBtn: TBitBtn;
    CalcularBitBtn: TBitBtn;
    DesdeDateTimePicker: TDateTimePicker;
    HastaDateTimePicker: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CreditoEdit: TEdit;
    DebitoEdit: TEdit;
    SaldoEdit: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    QTemp: TIBQuery;
    Q: TIBQuery;
    procedure AceptarBitBtnClick(Sender: TObject);
    procedure CalcularBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  fecha:string;
    { Public declarations }
  end;

var
  PagoIVAForm: TPagoIVAForm;

implementation


{$R *.dfm}

procedure TPagoIVAForm.AceptarBitBtnClick(Sender: TObject);
var i,c:integer;
begin
     Fecha := (FormatDateTime('mm/dd/yyyy hh:mm:ss', now));

// Iniciar la Transaccion

//CONTABILIDAD++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 //Insertar en la tabla LibroDiario
        //obtener el numero de asiento
        q.SQL.Text := 'Select Max(ASIENTO) From "LibroDiario"';
        q.Open;
        i := q.Fields[0].AsInteger+1;
        q.Close;

//LIQUIDACION DE IVA

        // renglon  - IVA DEBITO FISCAL
        q.SQL.Text:='select * from "Cuenta" where CODIGO='+dm.ConfigQuery.FieldByName('CtaIVADebitoFiscal').AsString;
        q.Open;
        c:=c+1;
        QTemp.SQL.Text := 'Insert Into "LibroDiario" (ASIENTO, FECHA, LEYENDA, JERARQUIA, CUENTA, DEBE, HABER, OCULTO)'+
        ' Values '+
        '( '+IntToStr(i)+', '+QuotedStr(Fecha)+', ''LIQUIDACION DE IVA'', '+QuotedStr(q.FieldByName('Jerarquia').AsString)+', '+QuotedStr(q.FieldByName('DESCRIPCION').AsString)+', '+DebitoEdit.Text+', 0, '+QuotedStr(Oculto)+
        ' )';
        QTemp.ExecSQL;

        if StrToFloat(SaldoEdit.Text) < 0 then
        begin// renglon  - IVA REMANENTE
        q.SQL.Text:='select * from "Cuenta" where "Cuenta".CODIGO='+dm.ConfigQuery.FieldByName('CtaIVARemanente').AsString;
        q.Open;
        c:=c+1;
        QTemp.SQL.Text := 'Insert Into "LibroDiario" (ASIENTO, FECHA, LEYENDA, JERARQUIA, CUENTA, DEBE, HABER, OCULTO)'+
        ' Values '+
        '( '+IntToStr(i)+', '+QuotedStr(Fecha)+', ''LIQUIDACION DE IVA'', '+QuotedStr(q.FieldByName('Jerarquia').AsString)+', '+QuotedStr(q.FieldByName('DESCRIPCION').AsString)+', '+ FloatToStr(abs(StrToFloat(SaldoEdit.Text)))+', 0, '+QuotedStr(Oculto)+
        ' )';
        QTemp.ExecSQL;
        end;

        // renglon  - IVA CREDITO FISCAL
        q.SQL.Text:='select * from "Cuenta" where "Cuenta".CODIGO='+dm.ConfigQuery.FieldByName('CtaIVACreditoFiscal').AsString;
        q.Open;
        c:=c+1;
        QTemp.SQL.Text := 'Insert Into "LibroDiario" (ASIENTO, FECHA, LEYENDA, JERARQUIA, CUENTA, DEBE, HABER, OCULTO)'+
        ' Values '+
        '( '+IntToStr(i)+', '+QuotedStr(Fecha)+', ''LIQUIDACION DE IVA'', '+QuotedStr(q.FieldByName('Jerarquia').AsString)+', '+QuotedStr(q.FieldByName('DESCRIPCION').AsString)+', 0, '+CreditoEdit.Text+', '+QuotedStr(Oculto)+
        ' )';
        QTemp.ExecSQL;

        if StrToFloat(SaldoEdit.Text) > 0 then
        begin// renglon  - IVA A PAGAR
        q.SQL.Text:='select * from "Cuenta" where "Cuenta".CODIGO='+dm.ConfigQuery.FieldByName('CtaIVAAPagar').AsString;
        q.Open;
        c:=c+1;
        QTemp.SQL.Text := 'Insert Into "LibroDiario" (ASIENTO, FECHA, LEYENDA, JERARQUIA, CUENTA, DEBE, HABER, OCULTO)'+
        ' Values '+
        '( '+IntToStr(i)+', '+QuotedStr(Fecha)+', ''LIQUIDACION DE IVA'', '+QuotedStr(q.FieldByName('Jerarquia').AsString)+', '+QuotedStr(q.FieldByName('DESCRIPCION').AsString)+', 0, '+SaldoEdit.Text+', '+QuotedStr(Oculto)+
        ' )';
        QTemp.ExecSQL;

//PAGO DE IVA
        // renglon  - IVA A PAGAR
        q.SQL.Text:='select * from "Cuenta" where "Cuenta".CODIGO='+dm.ConfigQuery.FieldByName('CtaIVAAPagar').AsString;
        q.Open;
        c:=c+1;
        QTemp.SQL.Text := 'Insert Into "LibroDiario" (ASIENTO, FECHA, LEYENDA, JERARQUIA, CUENTA, DEBE, HABER, OCULTO)'+
        ' Values '+
        '( '+IntToStr(i)+', '+QuotedStr(Fecha)+', ''PAGO DE IVA'', '+QuotedStr(q.FieldByName('Jerarquia').AsString)+', '+QuotedStr(q.FieldByName('DESCRIPCION').AsString)+', '+SaldoEdit.Text+', 0, '+QuotedStr(Oculto)+
        ' )';
        QTemp.ExecSQL;

        // renglon  - CAJA
        q.SQL.Text:='select * from "Cuenta" where "Cuenta".CODIGO='+dm.ConfigQuery.FieldByName('CtaCaja').AsString;
        q.Open;
        c:=c+1;
        QTemp.SQL.Text := 'Insert Into "LibroDiario" (ASIENTO, FECHA, LEYENDA, JERARQUIA, CUENTA, DEBE, HABER, OCULTO)'+
        ' Values '+
        '( '+IntToStr(i)+', '+QuotedStr(Fecha)+', ''PAGO DE IVA'', '+QuotedStr(q.FieldByName('Jerarquia').AsString)+', '+QuotedStr(q.FieldByName('DESCRIPCION').AsString)+', 0, '+SaldoEdit.Text+', '+QuotedStr(Oculto)+
        ' )';
        QTemp.ExecSQL;
        end;

//CONTABILIDAD------------------------------------------------------------------------------

// Completa la Transaccion
       QTemp.Transaction.CommitRetaining;
Close;
end;

procedure TPagoIVAForm.CalcularBitBtnClick(Sender: TObject);
begin
//DEBITO
QTemp.SQL.Text:=
'SELECT '+
'  "LibroIVAventa".IVA1,'+
'  "LibroIVAventa".IVA2, '+
'  "LibroIVAventa".FECHA '+
' FROM '+
'  "LibroIVAventa"  '+
' WHERE '+
'  ("LibroIVAventa".FECHA >= '+QuotedStr( DateToStr(DesdeDateTimePicker.Date))+' ) AND'+
'  ("LibroIVAventa".FECHA <= '+QuotedStr( DateToStr(HastaDateTimePicker.Date))+' )'+
'';
QTemp.Open;
while QTemp.Eof = False do
begin
DebitoEdit.Text:=FloatToStr(StrToFloat(DebitoEdit.Text)+QTemp.FieldByName('IVA1').AsFloat+QTemp.FieldByName('IVA2').AsFloat);
QTemp.Next;
end;

//CREDITO
QTemp.SQL.Text:=
'SELECT '+
'  "LibroIVAcompra".IVA1,'+
'  "LibroIVAcompra".IVA2, '+
'  "LibroIVAcompra".FECHA '+
' FROM '+
'  "LibroIVAcompra"  '+
' WHERE '+
'  ("LibroIVAcompra".FECHA >= '+QuotedStr( DateToStr(DesdeDateTimePicker.Date))+' ) AND'+
'  ("LibroIVAcompra".FECHA <= '+QuotedStr( DateToStr(HastaDateTimePicker.Date))+' )'+
'';
QTemp.Open;
while QTemp.Eof = False do
begin
CreditoEdit.Text:=FloatToStr(StrToFloat(DebitoEdit.Text)+QTemp.FieldByName('IVA1').AsFloat+QTemp.FieldByName('IVA2').AsFloat);
QTemp.Next;
end;

SaldoEdit.Text:=FloatToStr(StrToFloat(DebitoEdit.Text)-StrToFloat(CreditoEdit.Text));
end;

procedure TPagoIVAForm.FormCreate(Sender: TObject);
begin
DM:=TDM.Create(Self);
end;

end.
