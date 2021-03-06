unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, ShellAPI, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, Datasnap.DBClient;

type
  TForm1 = class(TForm)
    ButtonExportToCSVClick: TButton;
    ButtonExportToHTMLClick: TButton;
    Products: TLabel;
    DBGrid1: TDBGrid;
    StatusBar: TStatusBar;
    DataSource1: TDataSource;
    Table: TClientDataSet;
    TableProductID: TIntegerField;
    TableProductName: TStringField;
    TableSupplierID: TIntegerField;
    TableCategoryID: TIntegerField;
    TableQuantityPerUnit: TStringField;
    TableUnitPrice: TBCDField;
    TableUnitsInStock: TSmallintField;
    TableUnitsOnOrder: TSmallintField;
    TableReorderLevel: TSmallintField;
    TableDiscontinued: TBooleanField;
    procedure ButtonExportToCSVClickClick(Sender: TObject);
    procedure ButtonExportToHTMLClickClick(Sender: TObject);
    procedure TableAfterOpen(DataSet: TDataSet);
    procedure TableAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ButtonExportToCSVClickClick(Sender: TObject);
var
 I: Integer;
 L: TStringList;
 S, FileName: String;
 Bookmark: TBookmark;
begin
 L := TStringList.Create();
 for I := 0 to Table.FieldCount - 1 do
 begin
 S := S + Table.Fields.Fields[I].FieldName + ';';
 end;
 L.Add(S);
 Bookmark := Table.GetBookmark();
 Table.DisableControls();
 Table.First();
 while not Table.Eof do
 begin
 S := '';
 for I := 0 to Table.FieldCount - 1 do
 begin
 S := S + Table.Fields.Fields[I].AsString + ';';
 end;
 L.Add(S);
 Table.Next();
 end;
 Table.GotoBookmark(Bookmark);
 Table.FreeBookmark(Bookmark);
 Table.EnableControls();
 FileName :=
 ExtractFilePath(Application.ExeName) + 'ExportFileName.csv';
 L.SaveToFile(FileName);
 L.Free;
 ShellExecute(Self.Handle, 'open', PWideChar(FileName), nil, nil, 0);
end;

procedure TForm1.ButtonExportToHTMLClickClick(Sender: TObject);
var
 I: Integer;
 L: TStringList;
 S, FileName: String;
 Bookmark: TBookmark;
begin
 L := TStringList.Create();
 L.Add('<html>');
 L.Add('<head><title>TableName</title></head>');
 L.Add('<body>');
 L.Add('<h3>TableName</h3>');
 L.Add('<table border=1>');
 L.Add('<tr>');
 for I := 0 to Table.FieldCount - 1 do
 begin
 L.Add('<th>' + Table.Fields.Fields[I].FieldName + '</th>');
 end;
 L.Add('</tr>');
 Bookmark := Table.GetBookmark();
 Table.DisableControls();
 Table.First();
 while not Table.Eof do
 begin
 L.Add('<tr>');
 for I := 0 to Table.FieldCount - 1 do
 begin
 L.Add('<td>' + Table.Fields.Fields[I].AsString + '</td>');
 end;
 L.Add('</tr>');
 Table.Next();
 end;
 L.Add('</table>');
 L.Add('</body>');
 L.Add('</html>');
 Table.GotoBookmark(Bookmark);
 Table.FreeBookmark(Bookmark);
 Table.EnableControls();
 FileName :=
 ExtractFilePath(Application.ExeName) + 'ExportFileName.html';
 L.SaveToFile(FileName);
 L.Free;
 ShellExecute(Self.Handle, 'open', PWideChar(FileName), nil, nil, 0);
end;


procedure TForm1.TableAfterOpen(DataSet: TDataSet);
begin
  StatusBar.Panels.Items[0].Text :=
  ' Record Count = ' + IntToStr(Table.RecordCount);
end;

procedure TForm1.TableAfterScroll(DataSet: TDataSet);
begin
  StatusBar.Panels.Items[1].Text := ' Products: ' +
  TableProductName.AsString + ' - Price: ' +
  FloatToStrF(TableUnitPrice.AsFloat, ffCurrency, 15, 2);
end;

end.
