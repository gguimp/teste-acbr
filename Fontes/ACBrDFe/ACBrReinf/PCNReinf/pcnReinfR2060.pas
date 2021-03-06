{******************************************************************************}
{ Projeto: Componente ACBrReinf                                                }
{  Biblioteca multiplataforma de componentes Delphi para envio de eventos do   }
{ Reinf                                                                        }

{ Direitos Autorais Reservados (c) 2017 Leivio Ramos de Fontenele              }
{                                                                              }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }


{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Leivio Ramos de Fontenele  -  leivio@yahoo.com.br                            }
{******************************************************************************}
{******************************************************************************
|* Historico
|*
|* 04/12/2017: Renato Rubinho
|*  - Implementados registros que faltavam e isoladas as respectivas classes
*******************************************************************************}

{$I ACBr.inc}

unit pcnReinfR2060;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnGerador, ACBrUtil,
  pcnCommonReinf, pcnConversaoReinf, pcnGeradorReinf;

type
  TR2060Collection = class;
  TR2060CollectionItem = class;
  TevtCPRB = class;

  {Classes espec�ficas deste evento}
  TinfoCPRB = class;
  TideEstab = class;
  TtipoCodCollection = class;
  TtipoCodCollectionItem = class;
  TtipoAjusteCollection = class;
  TtipoAjusteCollectionItem = class;
  TinfoProcCollection = class;
  TinfoProcCollectionItem = class;

  TR2060Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TR2060CollectionItem;
    procedure SetItem(Index: Integer; Value: TR2060CollectionItem);
  public
    function Add: TR2060CollectionItem;
    property Items[Index: Integer]: TR2060CollectionItem read GetItem write SetItem; default;
  end;

  TR2060CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FevtCPRB: TevtCPRB;
    procedure setevtCPRB(const Value: TevtCPRB);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property evtCPRB: TevtCPRB read FevtCPRB write setevtCPRB;
  end;

  TevtCPRB = class(TReinfEvento) //Classe do elemento principal do XML do evento!
  private
    FIdeEvento: TIdeEvento2;
    FideContri: TideContri;
    FACBrReinf: TObject;
    FinfoCPRB: TinfoCPRB;

    {Geradores espec�ficos desta classe}
    procedure GerarideEstab;
    procedure GerartipoCod(Lista: TtipoCodCollection);
    procedure GerartipoAjuste(Lista: TtipoAjusteCollection);
    procedure GerarinfoProc(Lista: TinfoProcCollection);
  public
    constructor Create(AACBrReinf: TObject); overload;
    destructor  Destroy; override;

    function GerarXML: Boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property ideEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property ideContri: TideContri read FideContri write FideContri;
    property infoCPRB: TinfoCPRB read FinfoCPRB write FinfoCPRB;
  end;

  { TinfoCPRB }
  TinfoCPRB = class(TPersistent)
  private
    FideEstab: TideEstab;
  public
    constructor Create;
    destructor Destroy; override;

    property ideEstab: TideEstab read FideEstab write FideEstab;
  end;

  { TideEstab }
  TideEstab = class(TPersistent)
  private
    FtpInscEstab: TtpInsc;
    FnrInscEstab: string;
    FvlrRecBrutaTotal: double;
    FvlrCPApurTotal: double;
    FvlrCPRBSuspTotal: double;
    FtipoCod: TtipoCodCollection;
  public
    constructor Create;
    destructor Destroy; override;

    property tpInscEstab: TtpInsc read FtpInscEstab write FtpInscEstab default tiCNPJ;
    property nrInscEstab: string read FnrInscEstab write FnrInscEstab;
    property vlrRecBrutaTotal: double read FvlrRecBrutaTotal write FvlrRecBrutaTotal;
    property vlrCPApurTotal: double read FvlrCPApurTotal write FvlrCPApurTotal;
    property vlrCPRBSuspTotal: double read FvlrCPRBSuspTotal write FvlrCPRBSuspTotal;
    property tipoCod: TtipoCodCollection read FtipoCod write FtipoCod;
  end;

  TtipoCodCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TtipoCodCollectionItem;
    procedure SetItem(Index: Integer; Value: TtipoCodCollectionItem);
  public
    constructor create(AOwner: TideEstab);
    function Add: TtipoCodCollectionItem;
    property Items[Index: Integer]: TtipoCodCollectionItem read GetItem write SetItem; default;
  end;

  TtipoCodCollectionItem = class(TCollectionItem)
  private
    FcodAtivEcon: string;
    FvlrRecBrutaAtiv: double;
    FvlrExcRecBruta: double;
    FvlrAdicRecBruta: double;
    FvlrBcCPRB: double;
    FvlrCPRBapur: double;
    FtipoAjuste: TtipoAjusteCollection;
    FinfoProc: TinfoProcCollection;
  public
    constructor create; reintroduce;
    destructor Destroy; override;

    property codAtivEcon: string read FcodAtivEcon write FcodAtivEcon;
    property vlrRecBrutaAtiv: double read FvlrRecBrutaAtiv write FvlrRecBrutaAtiv;
    property vlrExcRecBruta: double read FvlrExcRecBruta write FvlrExcRecBruta;
    property vlrAdicRecBruta: double read FvlrAdicRecBruta write FvlrAdicRecBruta;
    property vlrBcCPRB: double read FvlrBcCPRB write FvlrBcCPRB;
    property vlrCPRBapur: double read FvlrCPRBapur write FvlrCPRBapur;
    property tipoAjuste: TtipoAjusteCollection read FtipoAjuste write FtipoAjuste;
    property infoProc: TinfoProcCollection read FinfoProc write FinfoProc;
  end;

  TtipoAjusteCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TtipoAjusteCollectionItem;
    procedure SetItem(Index: Integer; Value: TtipoAjusteCollectionItem);
  public
    constructor create(); reintroduce;
    function Add: TtipoAjusteCollectionItem;
    property Items[Index: Integer]: TtipoAjusteCollectionItem read GetItem write SetItem; default;
  end;

  TtipoAjusteCollectionItem = class(TCollectionItem)
  private
    FtpAjuste: TtpAjuste;
    FcodAjuste: TcodAjuste;
    FvlrAjuste: double;
    FdescAjuste: string;
    FdtAjuste: string;
  public
    property tpAjuste: TtpAjuste read FtpAjuste write FtpAjuste;
    property codAjuste: TcodAjuste read FcodAjuste write FcodAjuste;
    property vlrAjuste: double read FvlrAjuste write FvlrAjuste;
    property descAjuste: string read FdescAjuste write FdescAjuste;
    property dtAjuste: string read FdtAjuste write FdtAjuste;
  end;

  TinfoProcCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TinfoProcCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfoProcCollectionItem);
  public
    constructor create(); reintroduce;
    function Add: TinfoProcCollectionItem;
    property Items[Index: Integer]: TinfoProcCollectionItem read GetItem write SetItem; default;
  end;

  TinfoProcCollectionItem = class(TCollectionItem)
  private
    FtpProc: TtpProc;
    FnrProc: String;
    FcodSusp: String;
    FvlrCPRBSusp: double;
  public
    property tpProc: TtpProc read FtpProc write FtpProc;
    property nrProc: String read FnrProc write FnrProc;
    property codSusp: String read FcodSusp write FcodSusp;
    property vlrCPRBSusp: double read FvlrCPRBSusp write FvlrCPRBSusp;
  end;

implementation

uses
  IniFiles,
  ACBrReinf, ACBrDFeUtil;

{ TR2060Collection }

function TR2060Collection.Add: TR2060CollectionItem;
begin
  Result := TR2060CollectionItem(inherited Add);
end;

function TR2060Collection.GetItem(Index: Integer): TR2060CollectionItem;
begin
  Result := TR2060CollectionItem(inherited GetItem(Index));
end;

procedure TR2060Collection.SetItem(Index: Integer; Value: TR2060CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TR2060CollectionItem }

procedure TR2060CollectionItem.AfterConstruction;
begin
  inherited;
  FTipoEvento := teR2060;
  FevtCPRB := TevtCPRB.Create(Collection.Owner);
end;

procedure TR2060CollectionItem.BeforeDestruction;
begin
  inherited;
  FevtCPRB.Free;
end;

procedure TR2060CollectionItem.setevtCPRB(const Value: TevtCPRB);
begin
  FevtCPRB.Assign(Value);
end;

{ TevtCPRB }

constructor TevtCPRB.Create(AACBrReinf: TObject);
begin
  inherited;

  FACBrReinf := AACBrReinf;

  FideContri := TideContri.create;
  FIdeEvento := TIdeEvento2.create;
  FinfoCPRB  := TinfoCPRB.Create;
end;

destructor TevtCPRB.Destroy;
begin
  FideContri.Free;
  FIdeEvento.Free;
  FinfoCPRB.Free;

  inherited;
end;

{ TinfoCPRB }

constructor TinfoCPRB.Create;
begin
  FideEstab := TideEstab.Create;
end;

destructor TinfoCPRB.Destroy;
begin
  FideEstab.Free;

  inherited;
end;

{ TideEstab }

constructor TideEstab.Create;
begin
  FtipoCod := TtipoCodCollection.create(Self);
end;

destructor TideEstab.Destroy;
begin
  FtipoCod.Free;

  inherited;
end;

{ TtipoCodCollection }

function TtipoCodCollection.Add: TtipoCodCollectionItem;
begin
  Result := TtipoCodCollectionItem(inherited add());
  Result.Create;
end;

constructor TtipoCodCollection.create(AOwner: TideEstab);
begin
  Inherited create(TtipoCodCollectionItem);
end;

function TtipoCodCollection.GetItem(
  Index: Integer): TtipoCodCollectionItem;
begin
  Result := TtipoCodCollectionItem(inherited GetItem(Index));
end;

procedure TtipoCodCollection.SetItem(Index: Integer;
  Value: TtipoCodCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TtipoCodCollectionItem }

constructor TtipoCodCollectionItem.create;
begin
  FtipoAjuste := TtipoAjusteCollection.Create;
  FinfoProc   := TinfoProcCollection.Create;
end;

destructor TtipoCodCollectionItem.Destroy;
begin
  FtipoAjuste.Free;
  FinfoProc.Free;

  inherited;
end;

{ TtipoAjusteCollection }

function TtipoAjusteCollection.Add: TtipoAjusteCollectionItem;
begin
  Result := TtipoAjusteCollectionItem(inherited add());
//  Result.Create;
end;

constructor TtipoAjusteCollection.create;
begin
  Inherited create(TtipoAjusteCollectionItem);
end;

function TtipoAjusteCollection.GetItem(
  Index: Integer): TtipoAjusteCollectionItem;
begin
  Result := TtipoAjusteCollectionItem(inherited GetItem(Index));
end;

procedure TtipoAjusteCollection.SetItem(Index: Integer;
  Value: TtipoAjusteCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TinfoProcCollection }

function TinfoProcCollection.Add: TinfoProcCollectionItem;
begin
  Result := TinfoProcCollectionItem(inherited add());
//  Result.Create;
end;

constructor TinfoProcCollection.create;
begin
  Inherited create(TinfoProcCollectionItem);
end;

function TinfoProcCollection.GetItem(
  Index: Integer): TinfoProcCollectionItem;
begin
  Result := TinfoProcCollectionItem(inherited GetItem(Index));
end;

procedure TinfoProcCollection.SetItem(Index: Integer;
  Value: TinfoProcCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TevtCPRB.GerarideEstab;
begin
  Gerador.wGrupo('ideEstab');

  Gerador.wCampo(tcStr, '', 'tpInscEstab',      1,  1, 1, TpInscricaoToStr(Self.FinfoCPRB.ideEstab.tpInscEstab));
  Gerador.wCampo(tcStr, '', 'nrInscEstab',      1, 14, 1, Self.FinfoCPRB.ideEstab.nrInscEstab);
  Gerador.wCampo(tcDe2, '', 'vlrRecBrutaTotal', 1, 14, 1, Self.FinfoCPRB.ideEstab.vlrRecBrutaTotal);
  Gerador.wCampo(tcDe2, '', 'vlrCPApurTotal',   1, 14, 1, Self.FinfoCPRB.ideEstab.vlrCPApurTotal);
  Gerador.wCampo(tcDe2, '', 'vlrCPRBSuspTotal', 1, 14, 0, Self.FinfoCPRB.ideEstab.vlrCPRBSuspTotal);

  GerartipoCod(Self.FinfoCPRB.ideEstab.tipoCod);

  Gerador.wGrupo('/ideEstab');
end;

procedure TevtCPRB.GerartipoCod(Lista: TtipoCodCollection);
var
  item: TtipoCodCollectionItem;
  i: Integer;
begin
  for i := 0 to Lista.Count - 1 do
  begin
    Item := Lista.Items[i];

    Gerador.wGrupo('tipoCod');

    Gerador.wCampo(tcStr, '', 'codAtivEcon',     1,  8, 1, item.codAtivEcon);
    Gerador.wCampo(tcDe2, '', 'vlrRecBrutaAtiv', 1, 14, 1, item.vlrRecBrutaAtiv);
    Gerador.wCampo(tcDe2, '', 'vlrExcRecBruta',  1, 14, 1, item.vlrExcRecBruta);
    Gerador.wCampo(tcDe2, '', 'vlrAdicRecBruta', 1, 14, 1, item.vlrAdicRecBruta);
    Gerador.wCampo(tcDe2, '', 'vlrBcCPRB',       1, 14, 1, item.vlrBcCPRB);
    Gerador.wCampo(tcDe2, '', 'vlrCPRBapur',     1, 14, 0, item.vlrCPRBapur);

    GerartipoAjuste(item.tipoAjuste);
    GerarinfoProc(item.infoProc);

    Gerador.wGrupo('/tipoCod');
  end;

  if Lista.Count > 999 then
    Gerador.wAlerta('', 'tipoCod', 'Lista de Tipos de C�digos de Atividade', ERR_MSG_MAIOR_MAXIMO + '999');
end;

procedure TevtCPRB.GerartipoAjuste(Lista: TtipoAjusteCollection);
var
  item: TtipoAjusteCollectionItem;
  i: Integer;
begin
  for i := 0 to Lista.Count - 1 do
  begin
    Item := Lista.Items[i];

    Gerador.wGrupo('tipoAjuste');

    Gerador.wCampo(tcStr, '', 'tpAjuste',   1,  1, 1, tpAjusteToStr(item.tpAjuste));
    Gerador.wCampo(tcStr, '', 'codAjuste',  1,  2, 1, codAjusteToStr(item.codAjuste));
    Gerador.wCampo(tcDe2, '', 'vlrAjuste',  1, 14, 1, item.vlrAjuste);
    Gerador.wCampo(tcStr, '', 'descAjuste', 1, 20, 1, item.descAjuste);
    Gerador.wCampo(tcStr, '', 'dtAjuste',   7,  7, 1, item.dtAjuste);

    Gerador.wGrupo('/tipoAjuste');
  end;

  if Lista.Count > 999 then
    Gerador.wAlerta('', 'tipoAjuste', 'Lista de Tipos de Ajustes', ERR_MSG_MAIOR_MAXIMO + '999');
end;

procedure TevtCPRB.GerarinfoProc(Lista: TinfoProcCollection);
var
  item: TinfoProcCollectionItem;
  i: Integer;
begin
  for i := 0 to Lista.Count - 1 do
  begin
    Item := Lista.Items[i];

    Gerador.wGrupo('infoProc');

    Gerador.wCampo(tcStr, '', 'tpProc',      1,  1, 1, TpProcToStr( item.tpProc ));
    Gerador.wCampo(tcStr, '', 'nrProc',      1, 21, 1, item.nrProc);
    Gerador.wCampo(tcStr, '', 'codSusp',     1, 14, 0, item.codSusp);
    Gerador.wCampo(tcDe2, '', 'vlrCPRBSusp', 1, 14, 1, item.vlrCPRBSusp);

    Gerador.wGrupo('/infoProc');
  end;

  if Lista.Count > 50 then
    Gerador.wAlerta('', 'infoProc', 'Lista de Informa��es de Processos', ERR_MSG_MAIOR_MAXIMO + '50');
end;

function TevtCPRB.GerarXML: Boolean;
begin
  try
    Self.VersaoDF := TACBrReinf(FACBrReinf).Configuracoes.Geral.VersaoDF;

    Self.Id := GerarChaveReinf(now, self.ideContri.NrInsc, self.Sequencial);

    GerarCabecalho('evtInfoCPRB');
    Gerador.wGrupo('evtCPRB id="' + Self.Id + '"');

    GerarIdeEvento2(Self.IdeEvento);
    GerarideContri(Self.ideContri);

    Gerador.wGrupo('infoCPRB');

    GerarideEstab;

    Gerador.wGrupo('/infoCPRB');
    Gerador.wGrupo('/evtCPRB');

    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtCPRB');

    Validar(schevtInfoCPRB);
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '');
end;

function TevtCPRB.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  Ok: Boolean;
  sSecao, sFim: String;
  I, J: Integer;
begin
  Result := False;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with Self do
    begin
      sSecao := 'evtCPRB';
      Id         := INIRec.ReadString(sSecao, 'Id', '');
      Sequencial := INIRec.ReadInteger(sSecao, 'Sequencial', 0);

      sSecao := 'ideEvento';
      ideEvento.indRetif := StrToIndRetificacao(Ok, INIRec.ReadString(sSecao, 'indRetif', '1'));
      ideEvento.NrRecibo := INIRec.ReadString(sSecao, 'nrRecibo', EmptyStr);
      ideEvento.perApur  := INIRec.ReadString(sSecao, 'perApur', EmptyStr);
      ideEvento.TpAmb    := StrTotpAmbReinf(Ok, INIRec.ReadString(sSecao, 'tpAmb', '1'));
      ideEvento.ProcEmi  := StrToProcEmiReinf(Ok, INIRec.ReadString(sSecao, 'procEmi', '1'));
      ideEvento.VerProc  := INIRec.ReadString(sSecao, 'verProc', EmptyStr);

      sSecao := 'ideContri';
      ideContri.OrgaoPublico := (TACBrReinf(FACBrReinf).Configuracoes.Geral.TipoContribuinte = tcOrgaoPublico);
      ideContri.TpInsc       := StrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInsc', '1'));
      ideContri.NrInsc       := INIRec.ReadString(sSecao, 'nrInsc', EmptyStr);

      sSecao := 'ideEstab';
      infoCPRB.ideEstab.tpInscEstab       := StrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInscEstab', '1'));
      infoCPRB.ideEstab.nrInscEstab       := INIRec.ReadString(sSecao, 'nrInscEstab', EmptyStr);
      infoCPRB.ideEstab.vlrRecBrutaTotal  := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrRecBrutaTotal', ''), 0);
      infoCPRB.ideEstab.vlrCPApurTotal    := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrCPApurTotal', ''), 0);
      infoCPRB.ideEstab.vlrCPRBSuspTotal  := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrCPRBSuspTotal', ''), 0);

      with infoCPRB.ideEstab do
      begin
        I := 1;
        while true do
        begin
          // de 001 at� 999
          sSecao := 'tipoCod' + IntToStrZero(I, 3);
          sFim   := INIRec.ReadString(sSecao, 'codAtivEcon', 'FIM');

          if (sFim = 'FIM') or (Length(sFim) <= 0) then
            break;

          with tipoCod.Add do
          begin
            codAtivEcon := sFim;
            vlrRecBrutaAtiv := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrRecBrutaAtiv', ''), 0);
            vlrExcRecBruta  := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrExcRecBruta', ''), 0);
            vlrAdicRecBruta := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrAdicRecBruta', ''), 0);
            vlrBcCPRB       := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrBcCPRB', ''), 0);
            vlrCPRBapur     := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrCPRBapur', ''), 0);

            J := 1;
            while true do
            begin
              // de 001 at� 999
              sSecao := 'tipoAjuste' + IntToStrZero(I, 3) + IntToStrZero(J, 3);
              sFim   := INIRec.ReadString(sSecao, 'tpAjuste', 'FIM');

              if (sFim = 'FIM') or (Length(sFim) <= 0) then
                break;

              with tipoAjuste.Add do
              begin
                tpAjuste   := StrTotpAjuste(Ok, sFim);
                codAjuste  := StrTocodAjuste(Ok, INIRec.ReadString(sSecao, 'codAjuste', ''));
                vlrAjuste  := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrAjuste', ''), 0);
                descAjuste := INIRec.ReadString(sSecao, 'descAjuste', '');
                dtAjuste   := INIRec.ReadString(sSecao, 'dtAjuste', '');
              end;

              Inc(J);
            end;

            J := 1;
            while true do
            begin
              // de 00 at� 50
              sSecao := 'infoProc' + IntToStrZero(I, 3) + IntToStrZero(J, 2);
              sFim   := INIRec.ReadString(sSecao, 'tpProc', 'FIM');

              if (sFim = 'FIM') or (Length(sFim) <= 0) then
                break;

              with infoProc.Add do
              begin
                tpProc      := StrToTpProc(Ok, sFim);
                nrProc      := INIRec.ReadString(sSecao, 'nrProc', '');
                codSusp     := INIRec.ReadString(sSecao, 'codSusp', '');
                vlrCPRBSusp := StringToFloatDef(INIRec.ReadString(sSecao, 'vlrCPRBSusp', ''), 0);
              end;

              Inc(J);
            end;
          end;

          Inc(I);
        end;
      end;
    end;

    GerarXML;

    Result := True;
  finally
     INIRec.Free;
  end;
end;

end.
