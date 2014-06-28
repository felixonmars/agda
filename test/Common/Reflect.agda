
module Common.Reflect where

open import Common.Level
open import Common.Prelude renaming (Nat to ℕ)

postulate Float : Set
{-# BUILTIN FLOAT Float #-}

postulate QName : Set
{-# BUILTIN QNAME QName #-}
primitive primQNameEquality : QName → QName → Bool

data Hiding : Set where
  hidden visible instance : Hiding

{-# BUILTIN HIDING   Hiding   #-}
{-# BUILTIN HIDDEN   hidden   #-}
{-# BUILTIN VISIBLE  visible  #-}
{-# BUILTIN INSTANCE instance #-}

-- relevant    the argument is (possibly) relevant at compile-time
-- irrelevant  the argument is irrelevant at compile- and runtime
data Relevance : Set where
  relevant irrelevant : Relevance

{-# BUILTIN RELEVANCE  Relevance  #-}
{-# BUILTIN RELEVANT   relevant   #-}
{-# BUILTIN IRRELEVANT irrelevant #-}

data ArgInfo : Set where
  arginfo : Hiding → Relevance → ArgInfo

data Arg A : Set where
  arg : ArgInfo → A → Arg A

{-# BUILTIN ARGINFO    ArgInfo #-}
{-# BUILTIN ARG        Arg     #-}
{-# BUILTIN ARGARG     arg     #-}
{-# BUILTIN ARGARGINFO arginfo #-}

data Literal : Set where
  nat   : ℕ → Literal
  float : Float → Literal
  char  : Char → Literal
  string : String → Literal
  qname : QName → Literal

{-# BUILTIN AGDALITERAL Literal #-}
{-# BUILTIN AGDALITNAT nat #-}
{-# BUILTIN AGDALITFLOAT float #-}
{-# BUILTIN AGDALITCHAR char #-}
{-# BUILTIN AGDALITSTRING string #-}
{-# BUILTIN AGDALITQNAME qname #-}

mutual

  Args : Set

  data Type : Set
  data Sort : Set

  data Term : Set where
    var     : ℕ → Args → Term
    con     : QName → Args → Term
    def     : QName → Args → Term
    lam     : Hiding → Term → Term
    pi      : Arg Type → Type → Term
    sort    : Sort → Term
    lit     : Literal → Term
    unknown : Term

  Args = List (Arg Term)

  data Type where
    el : Sort → Term → Type

  data Sort where
    set     : Term → Sort
    lit     : ℕ → Sort
    unknown : Sort

{-# BUILTIN AGDASORT            Sort    #-}
{-# BUILTIN AGDATERM            Term    #-}
{-# BUILTIN AGDATYPE            Type    #-}
{-# BUILTIN AGDATERMVAR         var     #-}
{-# BUILTIN AGDATERMCON         con     #-}
{-# BUILTIN AGDATERMDEF         def     #-}
{-# BUILTIN AGDATERMLAM         lam     #-}
{-# BUILTIN AGDATERMPI          pi      #-}
{-# BUILTIN AGDATERMSORT        sort    #-}
{-# BUILTIN AGDATERMLIT         lit     #-}
{-# BUILTIN AGDATERMUNSUPPORTED unknown #-}
{-# BUILTIN AGDATYPEEL          el      #-}
{-# BUILTIN AGDASORTSET         set     #-}
{-# BUILTIN AGDASORTLIT         lit     #-}
{-# BUILTIN AGDASORTUNSUPPORTED unknown #-}

data Pattern : Set where
  con : QName → List (Arg Pattern) → Pattern
  dot : Pattern
  var : Pattern
  lit : Literal → Pattern
  proj : QName → Pattern

{-# BUILTIN AGDAPATTERN Pattern #-}
{-# BUILTIN AGDAPATCON con #-}
{-# BUILTIN AGDAPATDOT dot #-}
{-# BUILTIN AGDAPATVAR var #-}
{-# BUILTIN AGDAPATLIT lit #-}
{-# BUILTIN AGDAPATPROJ proj #-}

data Clause : Set where
  clause : List (Arg Pattern) → Term → Clause

{-# BUILTIN AGDACLAUSE Clause #-}
{-# BUILTIN AGDACLAUSECON clause #-}

data FunDef : Set where
  funDef : Type → List Clause → FunDef

{-# BUILTIN AGDAFUNDEF    FunDef #-}
{-# BUILTIN AGDAFUNDEFCON funDef #-}

postulate
  DataDef   : Set
  RecordDef : Set

{-# BUILTIN AGDADATADEF         DataDef #-}
{-# BUILTIN AGDARECORDDEF       RecordDef #-}

data Definition : Set where
  funDef          : FunDef    → Definition
  dataDef         : DataDef   → Definition
  recordDef       : RecordDef → Definition
  dataConstructor : Definition
  axiom           : Definition
  prim            : Definition

{-# BUILTIN AGDADEFINITION                Definition      #-}
{-# BUILTIN AGDADEFINITIONFUNDEF          funDef          #-}
{-# BUILTIN AGDADEFINITIONDATADEF         dataDef         #-}
{-# BUILTIN AGDADEFINITIONRECORDDEF       recordDef       #-}
{-# BUILTIN AGDADEFINITIONDATACONSTRUCTOR dataConstructor #-}
{-# BUILTIN AGDADEFINITIONPOSTULATE       axiom           #-}
{-# BUILTIN AGDADEFINITIONPRIMITIVE       prim            #-}

primitive
  primQNameType         : QName → Type
  primQNameDefinition   : QName → Definition
--primFunClauses        : FunDef → List Clause
  primDataConstructors  : DataDef   → List QName
--primRecordConstructor : RecordDef → QName
--primRecordFields      : RecordDef → List QName
