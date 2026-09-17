unit Unit2;

interface

uses
  SysUtils, Classes, Controls, Forms, StdCtrls, Unit1, Dialogs, ExtCtrls;

type
  TForm2 = class(TForm)
    lblWidth: TLabel;
    edtWidth: TEdit;
    lblHeight: TLabel;
    edtHeight: TEdit;
    lblXmin: TLabel;
    edtXmin: TEdit;
    lblXmax: TLabel;
    edtXmax: TEdit;
    lblYmin: TLabel;
    edtYmin: TEdit;
    lblYmax: TLabel;
    edtYmax: TEdit;
    lblCr: TLabel;
    edtCr: TEdit;
    lblCi: TLabel;
    edtCi: TEdit;
    edtMaxIterations: TEdit;
    lblMaxIterations: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    dlgColour: TColorDialog;
    btnColour1: TButton;
    btnColour2: TButton;
    btnColour3: TButton;
    chkUseFire: TCheckBox;
    chkDrawMandelbrot: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnColour1Click(Sender: TObject);
    procedure btnColour2Click(Sender: TObject);
    procedure btnColour3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btnColour1Click(Sender: TObject);
begin
  //dlgColour.Color := Form1.Colour1;
  dlgColour.Execute();
  Form1.Colour1 := dlgColour.Color;
end;

procedure TForm2.btnColour2Click(Sender: TObject);
begin
  //dlgColour.Color := Form1.Colour2;
  dlgColour.Execute();
  Form1.Colour2 := dlgColour.Color;
end;

procedure TForm2.btnColour3Click(Sender: TObject);
begin
  //dlgColour.Color := Form1.Colour3;
  dlgColour.Execute();
  Form1.Colour3 := dlgColour.Color;
end;

procedure TForm2.btnCancelClick(Sender: TObject);
begin
  Form2.Close;
end;

procedure TForm2.btnOKClick(Sender: TObject);
begin
  Form1.CanvasWidth := StrToInt(edtWidth.Text);
  Form1.CanvasHeight := StrToInt(edtHeight.Text);
  Form1.Xmin := StrToFloat(edtXmin.Text);
  Form1.Xmax := StrToFloat(edtXmax.Text);
  Form1.Ymin := StrToFloat(edtYmin.Text);
  Form1.Ymax := StrToFloat(edtYmax.Text);
  Form1.Cr := StrToFloat(edtCr.Text);
  Form1.Ci := StrToFloat(edtCi.Text);
  Form1.MaxIterations := StrToInt(edtMaxIterations.Text);
  if Form1.MaxIterations < 3 then
  begin
    Form1.MaxIterations := 3;
    ShowMessage('Max iterations cannot be less than 3!' + #13#10 + 'Setting it to 3.');
  end;
  if Form1.MaxIterations > 255 then
  begin
    Form1.MaxIterations := 255;
    ShowMessage('Max iterations cannot be more than 255!' + #13#10 + 'Setting it to 255.');
  end;
  Form1.UseFire := chkUseFire.Checked;
  Form1.DrawMandelbrot := chkDrawMandelbrot.Checked;
  Form2.Close;
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
  edtWidth.Text := IntToStr(Form1.CanvasWidth);
  edtHeight.Text := IntToStr(Form1.CanvasHeight);
  edtXmin.Text := FloatToStr(Form1.Xmin);
  edtXmax.Text := FloatToStr(Form1.Xmax);
  edtYmin.Text := FloatToStr(Form1.Ymin);
  edtYmax.Text := FloatToStr(Form1.Ymax);
  edtCr.Text := FloatToStr(Form1.Cr);
  edtCi.Text := FloatToStr(Form1.Ci);
  edtMaxIterations.Text := IntToStr(Form1.MaxIterations);
  chkUseFire.Checked := Form1.UseFire;
  chkDrawMandelbrot.Checked := Form1.DrawMandelbrot;
end;

end.

