(*
 * $Id: tabfile.pas,v 1.2 2004/09/16 12:56:37 Hitech Exp $
 *)

(**
 * @TITLE TabFile
 * @AUTHOR Jean Lacoste
 * @COPYRIGHT 2001-2002
 * Freeware
 *)

unit tabfile;

interface

uses windows, sysutils, classes;

type
   (**
    * Modes d'acc�s pour les TabFiles (lecture seule ou lecture �criture).
    *)
   TAccessMode = (amReadOnly, amReadWrite);

   (**
    * La classe des exceptions g�n�r�es sp�cifiquement par les membres
    * de la classe TTabFile
    * @INHERITS_FROM Exception
    *)
   ETabFileError = class(Exception)
   end;

   (**
    * La classe des exceptions g�n�r�es sp�cifiquement par les membres
    * de la classe TTabStringsFile
    * @INHERITS_FROM Exception
    *)
   ETabStringsFileError = class(ETabFileError)
   end;

   (**
    * Interface de d�finition des TabFiles<P>
    * But : permet d'utiliser un fichier comme un tableau.<P>
    * L'impl�mentation est faite par la classe TTabFile qui fonctionne par
    * comptage de r�f�rence.
    * C'est par l'interm�diaire de cette interface que les objets TTabFile sont
    * manipul�s.<P>Les
    * tableaux sont cr��s par les constructeurs de la classe TTabFile et sont
    * manipul�s par une variable de type ITabFile.<P>
    *     La classe propose 2 constructeurs :
    * <ul>
    *   <li>
    *    <B>Open</B> : cr�e un tableau sur un fichier existant</li>
    *   <li><B>CreateNew</B> : cr�e un tableau sur un fichier cr�� pour l'occasion</li>
    * </ul>
    *  <P>
    *    Les propri�t�s essentielles de l'interface sont :
    * <ul>
    *   <li><b>Size</b> : taille du tableau (indices de 0 � Size-1). <b>Attention</b>, on peut
    *      �galement modifier Size pour changer la taille du tableau et donc,
    *      du fichier qui est associ�.</li>
    *   <li><b>Ptr</b> : pointeur PChar sur le d�but du tableau.</li>
    *   <li><b>Content[pos]</b> : propri�t� indic�e permettant l'acc�s direct � n'importe
    *      quel �l�ment du tableau, c'est la propri�t� par d�faut et donc,
    *      il n'est pas n�cessaire de saisir son nom.</li>
    *   <li><b>StringAccess[pos]</b> : acc�de � la cha�ne plac�e � la position indiqu�e
    *      et permet de placer une cha�ne � cet endroit.</li>
    *   <li><b>ReadOnly</b> :  indique s'il est possible d'acc�der ou non au tableau en
    *      �criture.</li>
    * </ul>
    * <p>Exemple d'utilisation :</p>
    *     <pre><b>var</b>
    *  ft: ITabFile; <font color="#008000">// la variable contenant le tableau</font>
    *  i: integer;
    * <b>begin</b>
    *  <font color="#008000">// cr�ation du tableau sur le fichier indiqu�</font>
    *  ft := TTabFile.Open('test1.txt');
    *  <font color="#008000">// parcourir tous les �l�ments du tableau</font>
    *  <b>for</b> i:=0 <b>to</b> ft.Size-1 <b>do</b>
    *    <font color="#008000">// mettre chaque �l�ment du tableau en majuscule</font>
    *    ft[i]:=UpCase(ft[i]);
    * <b>end</b>;</pre>
    * <p>Note : Les objets TTabFile manipul�s par l'interm�diaire de cette interface
    * sont g�r�s par comptage de r�f�rence. Il n'est donc pas n�cessaire de
    * d�truire le tableau lorsqu'il n'est plus utile (il ne faut pas le lib�rer par
    * Free ou Destroy). Toutefois, pour fermer le tableau, si cela s'av�re
    * n�cessaire (pour lib�rer le fichier), il suffit d'affecter la valeur Nil � la
    * variable.</p>
    *)
   ITabFile = interface
      (**
       * Retourne un pointeur PChar sur le d�but de la m�moire mapp�e. Ce pointeur
       * peut �tre utilis� pour acc�der � n'importe quel caract�re du fichier par
       * d�r�f�rencement.
       *)
      function GetPtr: PChar;
      (**
       * Retourne l'adresse de l'offset indiqu� en param�tre
       * Permet de faire pointer un record � cette adresse
       *)
      function Offset(offset: LongWord): Pointer;
      (**
       * Retourne la taille du fichier mapp�.
       *)
      function GetSize: LongWord;
      (**
       * Modifie la taille du fichier. Le dernier indice du tableau devient alors
       * la taille du fichier -1 (la num�rotation commence � 0).
       * @PARAM v Taille du fichier
       *)
      procedure SetSize(v: LongWord);
      (**
       * Retourne le caract�re � la position indiqu�e
       * @PARAM pos Position du caract�re dans le fichier (de 0 � GetSize-1)
       *)
      function GetContent(pos: LongWord): Char;
      (**
       * Modifie le caract�re � la position indiqu�e
       * @PARAM pos Position du caract�re dans le fichier (de 0 � GetSize-1)
       * @PARAM value Caract�re � placer dans le fichier � la position indiqu�e
       *)
      procedure SetContent(pos: LongWord; const Value: Char);
      (**
       * Retourne une cha�ne de caract�res d�butant � la position indiqu�e. La
       * cha�ne se termine � la fin du fichier sur un s�parateur (CR ou LF)
       * @PARAM pos Position du caract�re dans le fichier (de 0 � GetSize-1)
       *)
      function GetStringAccess(pos: LongWord): String;
      (**
       * Place la cha�ne indiqu�e dans le fichier � la position indiqu�e
       * @PARAM pos Position du caract�re dans le fichier (de 0 � GetSize-1)
       * @PARAM Value Cha�ne de caract�res � placer dans le fichier
       *)
      procedure SetStringAccess(pos: LongWord; const Value: String);
      (**
       * Ouvre le fichier indiqu� dans le mode pr�cis�. Si un fichier �tait ouvert
       * il est ferm�.
       * @PARAM fileName Nom du fichier � ouvrir
       * @PARAM accessMode Mode d'ouverture du fichier (par d�faut amReadWrite)
       *)
      procedure OpenFile(fileName: TFileName; accessMode: TAccessMode=amReadWrite);
      (**
       * Cr�e et ouvre le fichier indiqu� avec la taille pr�cis�e. Si un fichier �tait ouvert
       * il est ferm�. Un fichier portant le m�me nom est �ventuellement �cras� pendant
       * l'op�ration.
       * @PARAM fileName Nom du fichier � ouvrir
       * @PARAM tabSize Taille du fichier (en octets)
       * @PARAM bOverwrite Boolean autorisant l'�crasement d'un �ventuel fichier portant le m�me nom
       * (par d�faut true)
       *)
      procedure CreateFile(fileName: TFileName; tabSize: LongWord; bOverwrite: boolean=true);
      (**
       * Ferme le fichier associ� au tableau.
       *)
      procedure CloseFile;
      (**
       * Retourne True si le tableau est en mode lecture seule.
       *)
      function IsReadOnly: boolean;
      (**
       * Ins�re un certain nombre d'octets � une position quelconque du tableau
       * @PARAM pos Position o� l'insertion est effectu�e (de 0 � GetSize). Si la position
       * est �gale � GetSize, alors le fonctionnement est similaire � la proc�dure Append
       * @PARAM sizebloc Taille du bloc � ins�rer (en octets)
       * @PARAM fill Caract�re utilis� pour le remplissage de la zone ins�r�e (par d�faut 0)
       *)
      procedure Insert(pos: LongWord; sizebloc: LongWord; fill: byte=0);
      (**
       * Ajoute un certain nombre d'octets � la fin du tableau.
       * @PARAM sizebloc Taille du bloc � ajouter (en octets)
       * @PARAM fill Caract�re utilis� pour le remplissage de la zone ajout�e (par d�faut 0)
       *)
      procedure Append(sizebloc: LongWord; fill: byte=0);
      (**
       * Efface une partie du tableau (la taille du tableau est r�duite)
       * @PARAM pos Position o� la suppression est effectu�e (de 0 � GetSize-1)
       * @PARAM sizebloc Taille du bloc � effacer (en octets)
       *)
      procedure Delete(pos: LongWord; sizebloc: LongWord);
      (**
       * Taille du tableau (et du fichier associ�). Note, cette propri�t� fonctionne en
       * lecture / �criture.
       * @TYPE LongWord
       *)
      property Size: LongWord read GetSize write SetSize;
      (**
       * Retourne un pointeur sur le premier caract�re du fichier (dans la m�moire mapp�e).
       * @TYPE PChar
       *)
      property Ptr: PChar read GetPtr;
      (**
       * Acc�de � n'importe quel caract�re du fichier par son indice. C'est la propri�t� par
       * d�faut et il n'est donc pas n�cessaire de pr�ciser le nom Content pour y acc�der.<P>
       * Si le mode le permet, cette propri�t� fonctionne en mode lecture / �criture.<P>
       * Equivalent aux m�thodes GetContent et SetContent.
       * @TYPE Char
       * @PARAM pos Position du caract�re dans le tableau (de 0 � GetSize-1)
       *)
      property Content[pos: LongWord]: Char read GetContent write SetContent; default;
      (**
       * Acc�de � n'importe quel endroit du tableau sous la forme d'une chaine de caract�res.<P>
       * Si le mode le permet, cette propri�t� fonctionne en mode lecture / �criture.<P>
       * Equivalent aux m�thodes GetStringAccess et SetStringAccess.
       * @TYPE String
       * @PARAM pos Position du caract�re dans le tableau (de 0 � GetSize-1)
       *)
      property StringAccess[pos: LongWord]: String read GetStringAccess write SetStringAccess;
      (**
       * Propri�t� en lecture seule indiquant si l'�criture est autoris�e.
       * @TYPE Boolean
       *)
      property ReadOnly: boolean read IsReadOnly;
   end;

   (**
    * L'interface de d�finition des TabStringsFiles<P>
    * C'est par l'interm�diaire de cette interface que les objets TTabStringsFile sont
    * manipul�s.
    *)
   ITabStringsFile = interface
      (**
       * Retourne la taille du fichier contenant le tableau (en octets).
       *)
      function GetFileSize: LongWord;
      (**
       * Retourne une cha�ne de caract�res contenant la totalit� du fichier texte.<P>
       * Le s�parateur de lignes est laiss� entre chaque cha�ne de caract�res du tableau.
       *)
      function GetTextStr: string;
      (**
       * Remplace la totalit� du fichier (et du tableau) par le contenu de la cha�ne de
       * caract�res transmise. Le nouveau contenu du fichier est examin� pour trouver
       * les s�parateurs et ainsi former les lignes du tableau.
       * @PARAM Value Nouvelle cha�ne de caract�res
       *)
      procedure SetTextStr(const Value: string);
      (**
       * Retourne la cha�ne de caract�res se trouvant � l'index indiqu�.
       * @PARAM Index Indice dans le tableau
       *)
      function Get(Index: LongWord): string;
      (**
       * Remplace la cha�ne de caract�res se trouvant � l'index indiqu� par celle qui est
       * transmise.
       * @PARAM Index Indice dans le tableau
       * @PARAM s Cha�ne de caract�res � placer dans le tableau
       *)
      procedure Put(Index: LongWord; const S: string);
      (**
       * Retourne le nombre de lignes dans le tableau (en commen�ant � 0)
       *)
      function GetCount: LongWord;
      (**
       * Ajoute une cha�ne de caract�res � la fin du tableau.
       * @PARAM s Cha�ne de caract�res � placer dans le tableau
       *)
      function Add(const S: string): LongWord;
      (**
       * Ajoute les cha�nes contenues dans Strings � la fin du tableau.
       * @PARAM Strings Objet TStrings contenant les cha�nes � ajouter
       *)
      procedure AddStrings(Strings: TStrings); overload;
      (**
       * Ajoute les cha�nes contenues dans Strings � la fin du tableau.
       * @PARAM Strings Objet ITabStringsFile contenant les cha�nes � ajouter
       *)
      procedure AddStrings(Strings: ITabStringsFile); overload;
      (**
       * Ajoute les cha�nes contenues dans le stream � la fin du tableau.
       * @PARAM Strings Objet TStream contenant les cha�nes � ajouter
       *)
      // procedure AddStrings(Strings: TStream); overload; // delphi n'a m�me pas une fonction pour lire une cha�ne dans un stream !
      (**
       * Efface le contenu du tableau et r�duit la taille du fichier � 0 octet
       *)
      procedure Clear;
      (**
       * Efface la cha�ne se trouvant � l'indice pr�cis�. Les cha�nes suivantes sont
       * d�cal�es pour utiliser la place lib�r�e.
       * @PARAM Index Indice de la cha�ne dans le tableau
       *)
      procedure Delete(Index: DWord);
      (**
       * Compare le tableau avec celui transmis. La comparaison donne un r�sultat
       * True si les deux tableaux comportent le m�me nombre d'�l�m�nts et que
       * ceux-ci sont identiques.
       * @PARAM Strings Tableau de type ITabStringsFile � comparer
       *)
      function Equals(Strings: ITabStringsFile): Boolean;
      (**
       * Echange les cha�nes se trouvant aux indices indiqu�s.
       * @PARAM Index1 Indice de la premi�re cha�ne
       * @PARAM Index2 Indice de la deuxi�me cha�ne
       *)
      procedure Exchange(Index1, Index2: LongWord);
      (**
       * Alloue et retourne un buffer de type PChar contenant la totalit� du fichier texte.<P>
       * <I>Note : Il est de la responsabilit� de l'appelant de lib�rer la m�moire allou�e pour
       * le tableau retourn�</I><P>
       * Le s�parateur de lignes est laiss� entre chaque cha�ne de caract�res du tableau.
       *)
      function GetText: PChar;
      (**
       * Retourne l'index de la premi�re occurence de la cha�ne dans le tableau.
       * @PARAM S Cha�ne de caract�res � rechercher
       *)
      function IndexOf(const S: string): LongWord;
      (**
       * Retourne l'index de la premi�re cha�ne contenant la cha�ne recherch�e
       * en utilisant une recherche BM
       * @PARAM Index Position � partir de laquelle la recherche commence
       * @PARAM S Cha�ne de caract�res � rechercher
       *)
      function Search(const S: string; Index: LongWord=0): LongWord;
      (**
       * Recherche l'index de la ligne dans laquelle se trouve l'offset
       * @PARAM offset Offset dans le fichier de la position recherch�e
       *)
      function OffsetIndex(offset: LongWord): LongWord;
      (**
       * Ins�re la cha�ne de caract�res � l'indice indiqu�. Les cha�nes de caract�res
       * suivantes sont d�cal�es pour permettre � la cha�ne transmise d'�tre ins�r�e.
       * @PARAM Index Position � laquelle doit �tre plac�e la cha�ne dans le tableau
       * @PARAM S Cha�ne de caract�re � ins�rer
       *)
      procedure Insert(Index: LongWord; const S: string);
      (**
       * Remplace le contenu du tableau par le contenu du fichier indiqu�. Une fois
       * les donn�es plac�es dans le fichier, elles sont examin�es pour retrouver
       * les �ventuels s�parateurs de lignes.
       * @PARAM FileName Nom du fichier contenant les donn�es � importer
       *)
      procedure LoadFromFile(const FileName: string);
      (**
       * Remplace le contenu du tableau par le contenu du stream indiqu�. Une fois
       * les donn�es plac�es dans le fichier, elles sont examin�es pour retrouver
       * les �ventuels s�parateurs de lignes.
       * @PARAM Stream TStream contenant les donn�es � importer
       *)
      procedure LoadFromStream(Stream: TStream);
      procedure Move(CurIndex, NewIndex: LongWord);
      (**
       * Enregistre l'ensemble du fichier contenant les cha�nes dans un nouveau
       * fichier (cr�� pour l'occasion).
       * @PARAM FileName Nom du fichier de destination
       *)
      procedure SaveToFile(const FileName: string);
      (**
       * Enregistre l'ensemble du fichier contenant les cha�nes dans le stream
       * indiqu�. C'est en fait une copie du fichier vers le stream.<P>
       * Les donn�es sont copi�es par bloc.
       * @PARAM Stream TStream dans lequel les donn�es sont plac�es
       *)
      procedure SaveToStream(Stream: TStream);
      (**
       * Remplace le contenu du fichier par le contenu de la cha�ne de caract�re
       * point�e par Text. Une fois la cha�ne plac�e dans le fichier, elle
       * est examin�e pour retrouver les �ventuels s�parateurs de lignes.
       * @PARAM Text Pointeur PChar sur la cha�ne � placer dans le fichier
       *)
      procedure SetText(Text: PChar);
      (**
       * Propri�t� indiquant le nombre de lignes dans le tableau (en commen�ant � 0)
       * @TYPE LongWord
       *)
      property Count: LongWord read GetCount;
      (**
       * Acc�de � n'importe quelle cha�ne de caract�res du tableau. C'est la propri�t� par
       * d�faut et il n'est donc pas n�cessaire de pr�ciser le nom Strings pour y acc�der.<P>
       * Si le mode le permet, cette propri�t� fonctionne en mode lecture / �criture.<P>
       * Equivalent aux m�thodes Get et Put.
       * @TYPE String
       * @PARAM Index Indice dans le tableau
       *)
      property Strings[Index: LongWord]: string read Get write Put; default;
      (**
       * Acc�de � l'ensemble du fichier sous la forme d'une cha�ne de caract�re<P>
       * Si le mode le permet, cette propri�t� fonctionne en mode lecture / �criture.<P>
       * Equivalent aux m�thodes GetTextStr et SetTextStr.
       * @TYPE String
       *)
      property Text: string read GetTextStr write SetTextStr;
      (**
       * Propri�t� en lecture seule indiquant la taille du fichier
       * dans lequel est contenu l'ensemble des cha�nes en octets.
       * @TYPE LongWord
       *)
      property FileSize: LongWord read GetFileSize;
   end;

   (**
    * La classe de base pour les classes TTabFile et TTabStringFiles.<P>
    * C'est une classe qui est bas�e sur TInterfacedObject pour la gestion
    * du comptage de r�f�rence.<P>
    * Elle d�finit la plupart des m�thodes utiles en protected. Les classes
    * qui en d�rivent doivent les rendre publique le cas �ch�ant.
    *
    * @INHERITS_FROM TInterfacedObject
    *)
   TInternalTabFile = class(TInterfacedObject)
   private
      FFileHandle: THandle;
      FMap: THandle;
      FPtr: PChar;
      FAccessMode: TAccessMode;
      FSize: LongWord;

   protected
      procedure CheckBounds(pos: LongWord);
      procedure CheckReadOnly;
      procedure CheckOpen;
      function GetPtr: PChar;
      function GetSize: LongWord;
      procedure SetSize(v: LongWord);
      procedure InternalSetSize(v: LongWord);
      function GetContent(pos: LongWord): Char;
      procedure SetContent(pos: LongWord; const Value: Char);
      function GetStringAccess(pos: LongWord): String;
      procedure SetStringAccess(pos: LongWord; const Value: String);
      procedure MapFileToTab;
      procedure UnmapFile;
      procedure CalcFileSize;
      procedure OpenFile(fileName: TFileName; accessMode: TAccessMode=amReadWrite); virtual;
      procedure CreateFile(fileName: TFileName; tabSize: LongWord; bOverwrite: boolean=true); virtual;
      procedure CloseFile; virtual;

      // 17/5/2002
      procedure Insert(pos: LongWord; sizebloc: LongWord; fill: byte=0);
      procedure Append(sizebloc: LongWord; fill: byte=0);
      procedure Delete(pos: LongWord; sizebloc: LongWord);

      function IsReadOnly: boolean;
      property Size: LongWord read GetSize write SetSize;
      property Content[pos: LongWord]: Char read GetContent write SetContent; default;
      property StringAccess[pos: LongWord]: String read GetStringAccess write SetStringAccess;

   public
      destructor Destroy; override;
   end;

   (**
    * C'est la classe qui d�finissant l'objet TTabFile. Elle impl�mente l'interface
    * ITabFile pour pouvoir acc�der � ses fonctions.<P>
    * Elle propose deux constructeur pour la cr�ation des objets qui sont ensuite
    * utilis�s via l'interface ITabFile.
    *
    * @INHERITS_FROM TInternalTabFile
    * @IMPLEMENTS ITabFile
    *)
   TTabFile = class(TInternalTabFile, ITabFile)
   public
      constructor Open(fileName: TFileName; accessMode: TAccessMode=amReadWrite);
      constructor CreateNew(fileName: TFileName; tabSize: LongWord; bOverwrite: boolean=true);
      function Offset(off: longWord): pointer;
   end;

   (**
    * Types des s�parateurs de lignes reconnus. lsUndef est utilis� � l'ouverture d'un
    * fichier, lorsque le s�parateur n'est pas encore d�fini.
    *)
   TLineSeparator = (lsUndef, lsCR, lsLF, lsCRLF);

   (**
    * C'est la classe qui d�finissant l'objet TTabStringsFile. Elle impl�mente l'interface
    * ITabStringsFile pour pouvoir acc�der � ses fonctions.<P>
    * Toutes les op�rations concernant la taille du fichier suite aux modifications
    * des cha�nes se trouvant aux indices indiqu�s sont g�r�es automatiquement.
    * Elle propose deux constructeur pour la cr�ation des objets qui sont ensuite
    * utilis�s via l'interface ITabStringFile.
    *
    * @INHERITS_FROM TInternalTabFile
    * @IMPLEMENTS ITabStringsFile
    *)
   TTabStringsFile = class(TInternalTabFile, ITabStringsFile)
   private
      FLines: TList;
      FLineSeparator: TLineSeparator;
      FLineSeparatorStr: PChar;
      FLineSeparatorSize: longword;
      FLastLineSeparator: Boolean;
      procedure SetLineSeparator(const Value: TLineSeparator);

      procedure CheckTabBounds(index: Longword);
      (**
       * Retourne des informations sur la cha�ne se trouvant � l'indice pr�cis�.<P>
       * Le r�sultat est plac� dans les variables pass�es en r�f�rence.
       * @PARAM index Indice de la ligne
       * @PARAM pos Position physique dans le fichier (en octets)
       * @PARAM len Longueur de la cha�ne (sans le s�parateur)
       *)
      procedure GetLineInfos(index: Longword; var pos: Longword; var len: Longword);
      (**
       * Retourne des informations sur la cha�ne se trouvant � l'indice pr�cis�.
       * La fonction prend en compte le s�parateur de cha�ne s'il est pr�sent (il
       * peut ne pas �tre pr�sent en fin de fichier, pour la derni�re cha�ne)<P>
       * Le r�sultat est plac� dans les variables pass�es en r�f�rence.
       * @PARAM index Indice de la ligne
       * @PARAM pos Position physique dans le fichier (en octets)
       * @PARAM len Longueur de la cha�ne (avec le s�parateur)
       *)
      procedure GetLineInfosSep(index: Longword; var pos: Longword; var len: Longword);

      function GetFileSize: LongWord;
      function Search(const S: string; Index: LongWord=0): LongWord;
      function OffsetIndex(offset: LongWord): LongWord;

      //
      function GetTextStr: string;
      procedure SetTextStr(const Value: string);
      function Get(Index: LongWord): string;
      procedure Put(Index: LongWord; const S: string);
      function GetCount: LongWord;
      //////////////////////////////
      function Add(const S: string): LongWord;
      procedure AddStrings(Strings: TStrings); overload;
      procedure AddStrings(Strings: ITabStringsFile); overload;
      procedure Clear;
      procedure Delete(Index: DWord);
      function Equals(Strings: ITabStringsFile): Boolean;
      procedure Exchange(Index1, Index2: LongWord);
      function GetText: PChar;
      function IndexOf(const S: string): LongWord;
      procedure Insert(Index: LongWord; const S: string);
      procedure LoadFromFile(const FileName: string);
      procedure LoadFromStream(Stream: TStream);
      procedure Move(CurIndex, NewIndex: LongWord);
      procedure SaveToFile(const FileName: string);
      procedure SaveToStream(Stream: TStream);
      procedure SetText(Text: PChar);

      (**
       * Initialisation interne de l'objet
       *)
      procedure Init;
      (**
       * Initialisation du tableau<P>
       * Recherche le s�parateur.<P>
       * Contruit le tableau contenant les offsets des lignes dans le fichier.
       *)
      procedure InitLignes;

   public
      constructor Open(fileName: TFileName; accessMode: TAccessMode=amReadWrite);
      constructor CreateNew(fileName: TFileName; ls: TLineSeparator; bOverwrite: boolean=true);
      destructor Destroy; override;

      (**
       * Propri�t� permettant de conna�tre ou de pr�ciser le s�parateur de lignes.
       * @TYPE TLineSeparator
       *)
      property LineSeparator: TLineSeparator read FLineSeparator write SetLineSeparator;
   end;

implementation


{$DEFINE BMSEARCH}

{$IFDEF BMSEARCH}
uses bmsearch;
{$ENDIF}

{ TTabFile }

//
// fonction utilitaire (manque op�rateur ?: )
function DWChoose(cond: Boolean; dw1, dw2: DWord): DWord;
begin
   if cond then result := dw1 else result := dw2;
end;

//
// Constructeur :
// Cr�e un tableau en ouvrant le fichier dans le mode indiqu�
//
constructor TTabFile.Open(fileName: TFileName;
   accessMode: TAccessMode=amReadWrite);
begin
   inherited Create;
   OpenFile(fileName, accessMode);
end;

//
// Constructeur :
// Cr�e un fichier de la taille indiqu�e et ouvre le tableau
// sur ce fichier, overwrite permet de contr�ler l'�crasement
// d'un ancien fichier
//
constructor TTabFile.CreateNew(fileName: TFileName; tabSize: LongWord; bOverwrite: boolean=true);
begin
   inherited Create;
   CreateFile(fileName, tabSize, bOverwrite);
end;

//
// Destructeur
//
destructor TInternalTabFile.Destroy;
begin
   CloseFile;
   inherited;
end;

//
//
function TInternalTabFile.IsReadOnly: boolean;
begin
   result := FAccessMode = amReadOnly;
end;

//
//
function TInternalTabFile.GetContent(pos: LongWord): Char;
begin
   result := FPtr[pos];
end;

//
//
procedure TInternalTabFile.SetContent(pos: LongWord; const Value: Char);
begin
   FPtr[pos] := Value;
end;

//
//
function TInternalTabFile.GetSize: LongWord;
begin
   result := FSize;
end;

//
//
function TInternalTabFile.GetPtr: PChar;
begin
   result := FPtr;
end;

//
// G�n�re une exception sur la position est hors limites
//
procedure TInternalTabFile.CheckBounds(pos: LongWord);
begin
   if pos>=FSize then
      raise ETabFileError.CreateFmt('Indice %d hors limites', [pos]);
end;

procedure TInternalTabFile.CheckReadOnly;
begin
   if IsReadOnly then
      raise ETabFileError.Create('Impossible de changer la taille d''un tableau en lecture seule');
end;

//
//
procedure TInternalTabFile.OpenFile(fileName: TFileName; accessMode: TAccessMode);
begin
   CloseFile;
   FAccessMode := accessMode;

   // ouvrir le fichier physiquement
   FFileHandle := Windows.CreateFile(PChar(fileName),
      DWChoose(IsReadOnly, GENERIC_READ, GENERIC_READ Or GENERIC_WRITE),
      FILE_SHARE_READ, NIL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
   if FFileHandle=INVALID_HANDLE_VALUE then
      raise ETabFileError.CreateFmt('Erreur [%x] � l''ouverture de %s', [GetLastError, fileName]);

   // taille du fichier (et donc du tableau)
   CalcFileSize;

   // ouvre le mapping
   MapFileToTab;
end;

//
//
procedure TInternalTabFile.CloseFile;
begin
   UnmapFile;
   if FFileHandle<>0 then
      CloseHandle(FFileHandle);
   FFileHandle := 0;
end;

//
//
procedure TInternalTabFile.MapFileToTab;
begin
   CheckOpen;
   if FSize<>0 then
      try
         FMap := CreateFileMapping(FFileHandle, NIL,
            DWChoose(IsReadOnly, PAGE_READONLY, PAGE_READWRITE),
            0, 0, NIL);
         if FMap=0 then
            raise ETabFileError.CreateFmt('Erreur [%x] avec CreateFileMapping', [GetLastError]);

         FPtr := MapViewOfFile(FMap,
            DWChoose(IsReadOnly, FILE_MAP_READ, FILE_MAP_ALL_ACCESS),
            0, 0, 0);
         if FPtr=Nil then
            raise ETabFileError.CreateFmt('Erreur [%x] avec MapViewOfFile', [GetLastError]);
      except
         UnmapFile;
         raise;
      end;
end;

//
//
procedure TInternalTabFile.UnmapFile;
begin
   if FPtr<>Nil then
      UnmapViewOfFile(FPtr);
   FPtr := Nil;
   if FMap<>0 then
      CloseHandle(FMap);
   FMap := 0;
end;

//
//
procedure TInternalTabFile.CalcFileSize;
begin
   // note : pointeur 32 bits, pascal object ne g�re pas
   // les pointeurs sur 64 bits
   FSize := GetFileSize(FFileHandle, Nil);
   if FSize=$FFFFFFFF then
      raise ETabFileError.CreateFmt('Erreur [%x] avec GetFileSize', [GetLastError]);
end;


//
//
procedure TInternalTabFile.InternalSetSize(v: LongWord);
begin
   SetFilePointer(FFileHandle, v, Nil, FILE_BEGIN);
   SetEndOfFile(FFileHandle);
   CalcFileSize;
end;

//
//
procedure TInternalTabFile.SetSize(v: LongWord);
begin
   CheckReadOnly;
   UnmapFile;
   InternalSetSize(v);
   MapFileToTab;
end;

//
// G�n�re une exception si le fichier n'est pas ouvert
//
procedure TInternalTabFile.CheckOpen;
begin
   if FFileHandle=0 then
      raise ETabFileError.Create('Fichier non ouvert');
end;


//
//
procedure TInternalTabFile.CreateFile(fileName: TFileName; tabSize: LongWord; bOverwrite: boolean);
begin
   CloseFile;
   FAccessMode := amReadWrite;

   // ouvrir le fichier physiquement
   FFileHandle := Windows.CreateFile(PChar(fileName),
      DWChoose(IsReadOnly, GENERIC_READ, GENERIC_READ Or GENERIC_WRITE),
      FILE_SHARE_READ, NIL,
      DWChoose(bOverwrite, CREATE_ALWAYS, CREATE_NEW),
      FILE_ATTRIBUTE_NORMAL, 0);
   if FFileHandle=INVALID_HANDLE_VALUE then
      raise ETabFileError.CreateFmt('Erreur [%x] � l� cr�ation de %s', [GetLastError, fileName]);

   // taille du fichier (et donc du tableau)
   InternalSetSize(tabSize);

   // ouvre le mapping
   MapFileToTab;
end;

//
// retourne la cha�ne se trouvant � la position P
// elle se termine sur un 0D ou 0A ou fin de fichier
function TInternalTabFile.GetStringAccess(pos: LongWord): String;
var
   i: DWord;
begin
   CheckBounds(pos);

   i := Pos;
   while (i<FSize) And (FPtr[i]<>#$d) And (FPtr[i]<>#$a) do
      inc(i);
   SetString(Result, FPtr+pos, i-pos);
end;

//
// place une cha�ne de caract�res � une position du fichier
// (le 0 de fin n'est pas copi�)
procedure TInternalTabFile.SetStringAccess(pos: LongWord; const Value: String);
begin
   CheckBounds(pos+LongWord(Length(Value)));
   MoveMemory(FPtr+Pos, PChar(Value), Length(Value));
end;

procedure TInternalTabFile.Insert(pos, sizebloc: LongWord; fill: byte);
var
   oldsize: LongWord;
begin
   CheckReadOnly;

   if pos=FSize then
      Append(sizebloc, fill)
   else
   begin
      CheckBounds(pos);

      oldsize := Size;
      Size := oldsize + sizebloc;
      MoveMemory(FPtr + pos +sizebloc, FPtr + pos, oldsize-pos);
      FillMemory(FPtr + pos, sizebloc, fill);
   end;
end;

procedure TInternalTabFile.Append(sizebloc: LongWord; fill: byte);
var
   oldsize: LongWord;
begin
   CheckReadOnly;

   oldsize := Size;
   Size := oldsize + sizebloc;
   FillMemory(FPtr + oldsize, sizebloc, fill);
end;

procedure TInternalTabFile.Delete(pos, sizebloc: LongWord);
begin
   CheckReadOnly;
   CheckBounds(pos);

   // si la taille d�borde sur la fin, ajuster la taille du bloc
   if (pos+sizebloc)>FSize then
      sizebloc := FSize-pos;

   // ne copier que si n�cessaire
   if FSize>(pos+sizebloc) then
      MoveMemory(FPtr + pos, FPtr + pos + sizebloc, FSize - (pos+sizebloc));
   Size := FSize - sizebloc;
end;

(*
 * TTabStringsFile
 *)

function TTabStringsFile.Add(const S: string): LongWord;
var
   old: Longword;
   l: integer;
begin
   old := FSize;
   l := Length(s);
   // s'il n'y a pas de s�parateur pour la derni�re ligne
   // ajouter de la place pour le placer
   if not FLastLineSeparator then
      inc(old, FLineSeparatorSize);
   Size := old + LongWord(l) + FLineSeparatorSize;
   // s'il n'y a pas de s�parateur pour la derni�re ligne
   // l'ajouter
   if not FLastLineSeparator then
      CopyMemory(Fptr+old-FLineSeparatorSize, PChar(FLineSeparatorStr), FLineSeparatorSize);
   // si la cha�ne n'�tait pas vide, l'ajouter
   if l>0 then
      CopyMemory(Fptr+old, PChar(s), l);
   // puis placer le s�parateur de ligne
   CopyMemory(Fptr+old+l, PChar(FLineSeparatorStr), FLineSeparatorSize);
   FLastLineSeparator := true;
   result := FLines.Add(Pointer(old));
end;

procedure TTabStringsFile.AddStrings(Strings: TStrings);
var
   i: integer;
begin
   for i:= 0 to Strings.Count-1 do
      Add(Strings[i]);
end;

procedure TTabStringsFile.AddStrings(Strings: ITabStringsFile);
var
   l: LongWord;
begin
   for l:= 0 to Strings.Count-1 do
      Add(Strings[l]);
end;

procedure TTabStringsFile.CheckTabBounds(index: Longword);
begin
   if index>=LongWord(FLines.Count) then
      raise ETabStringsFileError.CreateFmt('Indice %d hors limites', [index]);
end;

procedure TTabStringsFile.Clear;
begin
   FLines.Clear;
   FLastLineSeparator := true;
   Size := 0;
end;

constructor TTabStringsFile.CreateNew(fileName: TFileName;
  ls: TLineSeparator; bOverwrite: boolean);
begin
   inherited Create;
   CreateFile(fileName, 0, bOverwrite);
   Init;
   InitLignes;
   LineSeparator := ls;
end;

procedure TTabStringsFile.Delete(Index: DWord);
var
   pos, len: Longword;
   i: integer;
begin
   CheckTabBounds(index);
   GetLineInfosSep(index, pos, len);
   inherited Delete(pos, len);
   // si on a effac� la derni�re ligne, alors il y a forcemment un s�parateur
   if integer(Index+1)=FLines.Count then
      FLastLineSeparator := true;
   FLines.Delete(index);
   // remettre � jour les positions � partir de la ligne
   for i:=index to LongWord(FLines.Count-1) do
      FLines.Items[i] := Pointer(LongWord(FLines.Items[i]) - len);
end;


destructor TTabStringsFile.Destroy;
begin
   FLines.Free;
   inherited;
end;

function TTabStringsFile.Equals(Strings: ITabStringsFile): Boolean;
var
   l, c: LongWord;
begin
   Result := False;
   c := GetCount;
   if c <> Strings.Count then
      exit;
   for l := 0 to c-1 do
      if Get(l) <> Strings.Get(l) then
         exit;
   result := True;
end;

procedure TTabStringsFile.Exchange(Index1, Index2: LongWord);
var
   tmp: string;
begin
   tmp := Get(Index1);
   Put(Index1, Get(Index2));
   Put(Index2, tmp);
end;

function TTabStringsFile.Get(Index: LongWord): string;
var
   pos, len: Longword;
begin
   CheckTabBounds(index);
   GetLineInfos(index, pos, len);
   SetString(Result, FPtr+pos, len);
end;

function TTabStringsFile.GetCount: LongWord;
begin
   result := FLines.Count;
end;

function TTabStringsFile.GetFileSize: LongWord;
begin
   result := FSize;
end;

procedure TTabStringsFile.GetLineInfos(index: Longword; var pos, len: Longword);
var
   i: Longword;
begin
   // position du d�but de la ligne
   pos := Longword(FLines.items[Index]);
   // si on est sur la derni�re ligne
   if (Index+1)=LongWord(FLines.Count) then
   begin
      // alors la fin de la ligne est la fin du fichier
      i := FSize;
      if FLastLineSeparator then
         dec(i, FLineSeparatorSize);
   end
   else
      i := Longword(FLines.items[integer(Index+1)]) - FLineSeparatorSize;
   len := i - pos;
end;


// retourne la taille incluant le s�parateur s'il est l�
procedure TTabStringsFile.GetLineInfosSep(index: Longword; var pos,
  len: Longword);
begin
   // position du d�but de la ligne
   pos := Longword(FLines.items[Index]);
   // si on est sur la derni�re ligne
   if integer(Index+1)=FLines.Count then
      len := FSize-pos
   else
      len := Longword(FLines.items[integer(Index+1)])-pos;
end;

function TTabStringsFile.GetText: PChar;
begin
   result := AllocMem(Size+1);
   MoveMemory(result, GetPtr, Size);
   result[size] := #0;
end;

function TTabStringsFile.GetTextStr: string;
begin
   SetString(Result, nil, Size);
   MoveMemory(@result[1], GetPtr, Size);
end;

function TTabStringsFile.IndexOf(const S: string): LongWord;
begin
   for Result := 0 to GetCount - 1 do
      if AnsiCompareText(Get(Result), S) = 0 then Exit;
   Result := $FFFFFFFF;
end;

procedure TTabStringsFile.Init;
begin
   FLines := TList.Create;
   LineSeparator := lsUndef;
end;

procedure TTabStringsFile.InitLignes;
var
   i, j: Longword;
begin
   FLines.Clear;

   // si le fichier a une taille non nulle
   if FSize<>0 then
   begin
      // trouver le s�parateur
      for i:=0 to FSize-1 do
      begin
         if FPtr[i]=#13 then
         begin
            LineSeparator := lsCR;
            if i+1<FSize then
               if FPtr[i+1]=#10 then
                  LineSeparator := lsCRLF;
            break;
         end;
         if FPtr[i]=#10 then
         begin
            LineSeparator := lsLF;
            break;
         end;
      end;
      // s'il n'y a pas de s�parateur, utiliser CRLF
      if LineSeparator = lsUndef then
         LineSeparator := lsCRLF;

      FLastLineSeparator := false;

      // trouver les lignes
      i := 0;
      FLines.Add(Pointer(i));
      repeat
         j := 0;
         while (i+j<FSize) And (FLineSeparatorStr[j]<>#0) do
         begin
            if FPtr[i+j]<>FLineSeparatorStr[j] then
               break;
            inc(j);
         end;
         // si on est sur un s�parateur (tous les caract�res du s�parateur ont �t� lus)
         if FLineSeparatorStr[j]=#0 then
         begin
            inc(i, j);  // i est sur le d�but de la cha�ne suivant le s�parateur
            // n'ajouter la cha�ne que si elle n'est pas vide
            if i<FSize then
               FLines.Add(Pointer(i))
            else
               FLastLineSeparator := true;
         end
         else
            inc(i);
      until i >= FSize;
   end
   else
      FLastLineSeparator := true;

   // s'il n'y a pas de s�parateur, utiliser CRLF
   if LineSeparator = lsUndef then
      LineSeparator := lsCRLF;
end;

procedure TTabStringsFile.Insert(Index: LongWord; const S: string);
var
   pos: LongWord;
   len: LongWord;
   i: longWord;
begin
   CheckReadOnly;

   if Index=LongWord(FLines.Count) then
      Add(s)
   else
   begin
      CheckBounds(index);

      len := Length(s);
      pos := LongWord(FLines.Items[index]);
      inherited Insert(pos, len + FLineSeparatorSize);

      MoveMemory(FPtr + pos, @s[1], len);
      MoveMemory(FPtr + pos + len, FLineSeparatorStr, FLineSeparatorSize);

      FLines.Insert(Index, Pointer(pos));

      // remettre � jour les positions � partir de la ligne
      for i:=index+1 to LongWord(FLines.Count-1) do
         FLines.Items[i] := Pointer(LongWord(FLines.Items[i]) + len + FLineSeparatorSize);
   end;
end;

procedure TTabStringsFile.LoadFromFile(const FileName: string);
var
   str: TFileStream;
begin
   str := TFileStream.Create(FileName, fmOpenRead);
   try
      LoadFromStream(str);
   finally
      str.Free;
   end;
end;

procedure TTabStringsFile.LoadFromStream(Stream: TStream);
var
   offset: integer;
   n: integer;
const
   blocsize = 4096;
begin
   offset := 0;
   Size := 0;
   repeat
      Size := Size + blocsize;
      n := Stream.Read((FPtr+offset)^, blocsize);
      inc(offset, n);   // prochaine lecture
   until n<>blocsize;
   Size := offset;
   InitLignes;
end;

procedure TTabStringsFile.Move(CurIndex, NewIndex: LongWord);
var
   tmp: string;
begin
   if CurIndex <> NewIndex then
   begin
      tmp := Get(CurIndex);
      Delete(CurIndex);
      Insert(NewIndex, tmp);
   end;
end;

(*
 * Recherche dichotomique de la ligne dans laquelle se trouve l'offset indiqu�
 *)
function TTabStringsFile.OffsetIndex(offset: LongWord): LongWord;
var
   low, high: LongWord;
   i: Longword;
   inddeb, indfin: Longword;
begin
   Result := $FFFFFFFF;
   low := 0;
   high := FLines.Count-1;

   while low <= high do
   begin
      // couper en 2
      i := low + ((high - low) shr 1);

      // rechercher les bornes de la ligne
      inddeb := Longword(FLines.items[i]);
      if (i+1)=LongWord(FLines.Count) then
         // alors la fin de la ligne est la fin du fichier
         indfin := FSize
      else
         indfin := Longword(FLines.items[integer(i+1)]);


      if offset < inddeb then
         high := i-1
      else if offset >= indfin then
         low := i+1
      else
      begin
         Result := i;
         break;
      end;
   end;
end;

constructor TTabStringsFile.Open(fileName: TFileName;
  accessMode: TAccessMode);
begin
   inherited Create;
   OpenFile(fileName, accessMode);
   Init;
   InitLignes;
end;

procedure TTabStringsFile.Put(Index: LongWord; const S: string);
var
   pos, len: Longword;
   l: Longword;
   p: Longword;
   off, i: integer;
begin
   CheckTabBounds(index);
   GetLineInfos(index, pos, len);

   l := Length(s);
   p := LongWord(FLines.Items[index]);

   off := integer(l)-integer(len); // d�calage

   if off>0 then
      Inherited Insert(p, l-len)
   else if off<0 then
      Inherited Delete(p, len-l);
   MoveMemory(FPtr + p, @s[1], l);

   // remettre � jour les positions � partir de la ligne
   for i:=index+1 to LongWord(FLines.Count-1) do
      FLines.Items[i] := Pointer(Integer(FLines.Items[i]) + off);
end;

procedure TTabStringsFile.SaveToFile(const FileName: string);
var
   f: TFileStream;
begin
   f := TFileStream.Create(FileName, fmOpenWrite);
   try
      SaveToStream(f);
   finally
      f.Free;
   end;
end;

procedure TTabStringsFile.SaveToStream(Stream: TStream);
const
   blocsize=4096; // une page
var
   i: longword;
begin
   i := 0;
   while Stream.Write(FPtr[i], blocsize)=blocsize do
      inc(i, blocsize);
end;

function TTabStringsFile.Search(const S: string; Index: LongWord=0): LongWord;
var
   bms: IBMSearch;
   pos: LongWord;
begin
   CheckBounds(index);
   // pas de recherche de cha�ne vide
   if Length(s)=0 then
   begin
      Result := $FFFFFFFF;
      exit;
   end;

   // recherche d'une cha�ne dans le tableau
   bms:= TBMSearch.Create(s);
   Result := bms.Search(FPtr, Size, Longword(FLines.items[Index]));
   // si la cha�ne est trouv�e
   if Result<>$FFFFFFFF then
   begin
      // position du d�but de la ligne
      result := OffsetIndex(Result);
   end;
end;

procedure TTabStringsFile.SetLineSeparator(const Value: TLineSeparator);
begin
   FLineSeparator := Value;
   case FLineSeparator of
      lsUndef: FLineSeparatorStr := '';
      lsCR:    FLineSeparatorStr := #13;
      lsLF:    FLineSeparatorStr := #10;
      lsCRLF:  FLineSeparatorStr := #13#10;
   end;
   FLineSeparatorSize := StrLen(FLineSeparatorStr);
end;

procedure TTabStringsFile.SetText(Text: PChar);
begin
   Size := StrLen(Text);
   MoveMemory(FPtr, text, FSize);
   InitLignes;
end;

procedure TTabStringsFile.SetTextStr(const Value: string);
begin
   SetText(PChar(Value));
end;



   (**
    * Fonction comparant 2 cha�nes pour le tri
    *)
//type   TCompareTabStrings = function(l, h: integer; tsf: TTabStringsFile): integer;




{procedure QuickSort(var tab: array of integer; l, r: Integer; SCompare: TListSortCompare);
var
  i, j: Integer;
  p, t: Pointer;
begin
  repeat
    i := l;
    j := r;
    p := SortList^[(l + r) shr 1];
    repeat
      while SCompare(SortList^[I], P) < 0 do
        Inc(I);
      while SCompare(SortList^[J], P) > 0 do
        Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(SortList, L, J, SCompare);
    L := I;
  until I >= R;
end;
}

{
procedure TTabStringsFile.SortToStream(str: TStream);
var
   i: integer;
   ti: Array of integer;

begin
   SetLength(ti, FLines.Count);
   for i:=low(ti) to high(ti) do
      ti[i]:=i;
end;
}

function TTabFile.Offset(off: longWord): pointer;
begin
   result := FPtr + off;
end;

end.
