object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 266
  ClientWidth = 241
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 12
  object lblWidth: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 12
    Caption = 'Width:'
  end
  object lblHeight: TLabel
    Left = 8
    Top = 32
    Width = 33
    Height = 12
    Caption = 'Height:'
  end
  object lblXmin: TLabel
    Left = 8
    Top = 56
    Width = 29
    Height = 12
    Caption = 'X min:'
  end
  object lblXmax: TLabel
    Left = 8
    Top = 80
    Width = 31
    Height = 12
    Caption = 'X max:'
  end
  object lblYmin: TLabel
    Left = 8
    Top = 104
    Width = 29
    Height = 12
    Caption = 'Y min:'
  end
  object lblYmax: TLabel
    Left = 8
    Top = 128
    Width = 31
    Height = 12
    Caption = 'Y max:'
  end
  object lblMaxIterations: TLabel
    Left = 8
    Top = 152
    Width = 65
    Height = 12
    Caption = 'Max iterations:'
  end
  object lblCr: TLabel
    Left = 8
    Top = 176
    Width = 15
    Height = 12
    Caption = 'Cr:'
  end
  object lblCi: TLabel
    Left = 8
    Top = 200
    Width = 13
    Height = 12
    Caption = 'Ci:'
  end
  object edtWidth: TEdit
    Left = 80
    Top = 8
    Width = 67
    Height = 20
    Hint = 'Width in pixels of the image box to render (and to save to PNG)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = '400'
  end
  object edtHeight: TEdit
    Left = 80
    Top = 32
    Width = 67
    Height = 20
    Hint = 'Height in pixels of the image box to render (and to save to PNG)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Text = '400'
  end
  object edtXmin: TEdit
    Left = 80
    Top = 56
    Width = 67
    Height = 20
    Hint = 
      'Minimum X coordinate (note that no points belong to the set outs' +
      'ide -2 to +2 interval)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Text = '-2'
  end
  object edtXmax: TEdit
    Left = 80
    Top = 80
    Width = 67
    Height = 20
    Hint = 
      'Maximum X coordinate (note that no points belong to the set outs' +
      'ide -2 to +2 interval)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Text = '1'
  end
  object edtYmin: TEdit
    Left = 80
    Top = 104
    Width = 67
    Height = 20
    Hint = 
      'Minimum Y coordinate (note that no points belong to the set outs' +
      'ide -2 to +2 interval)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Text = '-1.5'
  end
  object edtYmax: TEdit
    Left = 80
    Top = 128
    Width = 67
    Height = 20
    Hint = 
      'Maximum Y coordinate (note that no points belong to the set outs' +
      'ide -2 to +2 interval)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Text = '1.5'
  end
  object edtMaxIterations: TEdit
    Left = 80
    Top = 152
    Width = 67
    Height = 20
    Hint = 'From 3 to 255; lower values quicker but render less details'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = '90'
  end
  object btnOK: TButton
    Left = 8
    Top = 232
    Width = 61
    Height = 25
    Hint = 'Accept changes'
    Caption = 'OK'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 88
    Top = 232
    Width = 61
    Height = 25
    Hint = 'Discard changes'
    Caption = 'Cancel'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = btnCancelClick
  end
  object edtCr: TEdit
    Left = 80
    Top = 176
    Width = 67
    Height = 20
    Hint = 'Julia set real increment'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    Text = '1.5'
  end
  object edtCi: TEdit
    Left = 80
    Top = 200
    Width = 67
    Height = 20
    Hint = 'Julia set imaginary increment'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    Text = '90'
  end
  object btnColour1: TButton
    Left = 160
    Top = 8
    Width = 73
    Height = 33
    Hint = 'Set extreme colour for a 3 colour gradient'
    Caption = 'Colour 1'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    OnClick = btnColour1Click
  end
  object btnColour2: TButton
    Left = 160
    Top = 48
    Width = 73
    Height = 33
    Hint = 'Set medium colour for a 3 colour gradient'
    Caption = 'Colour 2'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
    OnClick = btnColour2Click
  end
  object btnColour3: TButton
    Left = 160
    Top = 88
    Width = 73
    Height = 33
    Hint = 'Set other extreme colour for a 3 colour gradient'
    Caption = 'Colour 3'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    OnClick = btnColour3Click
  end
  object chkUseFire: TCheckBox
    Left = 160
    Top = 136
    Width = 73
    Height = 25
    Hint = 'If checked, fire colour will be used and colours 123 ignored'
    Caption = 'Fire colours'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
  end
  object chkDrawMandelbrot: TCheckBox
    Left = 160
    Top = 168
    Width = 73
    Height = 25
    Hint = 
      'If checked, Cr and Ci will be ignored and a Mandelbrot set will ' +
      'be drawn instead'
    Caption = 'Mandelbrot'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
  end
  object dlgColour: TColorDialog
    Left = 160
    Top = 232
  end
end
