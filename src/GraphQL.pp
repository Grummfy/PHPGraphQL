// TODO we should also skip comment line (line tat start with "#")
%skip   ignored         [\xfeff\x20\x09\x0a\x0d]+

%token  query			query 		
%token  mutation		mutation
%token  fragment		fragment
%token  subscription    subscription
%token	on				on
%token  quote           "
%token  name            ([_A-Za-z][_0-9A-Za-z]*)
%token  brace_          {
%token _brace           }
%token  bracket_        \[
%token _bracket         \]
%token  parenthesis_    \(
%token _parenthesis     \)
%token  pipe            '|'
%token  colon           :
%token  dollar			\$
%token  exclamation		!
%token  equals			=
%token  comma			,
%token  at				@
%token  threeDots		\.\.\.
%token  space           [\u0009\u0020]
%token  endLine         [\u000A\u000D]
%token  anchor          #
%token  true            true
%token  false           false
%token  null			null
%token  number          \-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][\+\-]?[0-9]+)?
%token  character       [\u0009\u000A\u000D\u0020-\uFFFF]

#Document:
	Definition()* | Comment()

#Definition:
	OperationDefinition() | FragmentDefinition() | Comment()

#OperationDefinition:
	OperationType() Name()? VariableDefinitions()? Directives()? SelectionSet() | SelectionSet()

OperationType:
	<query> | <mutation> | <subscription>


#VariableDefinitions:
	::parenthesis_:: VariableDefinition()* ::_parenthesis::

#VariableDefinition:
	Variable() ::colon:: Type() DefaultValue()?

#DefaultValue:
	::equals:: Value()

#Type:
	Name() | ListType() | NonNullType()

#Variable:
	::dollar:: Name()

#ListType:
	::bracket_:: Type() ::_bracket::

#NonNullType:
	Name() ::exclamation:: | ListType() ::exclamation::


#Value:
	Variable() | Number() | StringValue() | BooleanValue() | StringValue() | NullValue() | EnumValue() | ListValue() | ObjectValue()

BooleanValue:
	<true> | <false>

NullValue:
	<null>

#StringValue:
	::quote:: ::quote:: | StringCharacter()*

StringCharacter:
	Name()

#EnumValue:
	Name()*
// TODO help on this one but not null, true or false => http://facebook.github.io/graphql/#EnumValue

#ListValue:
	::bracket_:: ::_bracket:: | ::bracket_:: Value()* ::_bracket::

#ObjectValue:
	::brace_:: ::_brace:: | ::brace_:: ObjectField()* ::_brace::

#ObjectField:
	Name() ::colon:: Value()


#Directives:
	Directive()*

#Directive:
	::at:: Name() Arguments()?

#Arguments:
	::parenthesis_:: Argument()* ::_parenthesis::

#Argument:
	Name() ::colon:: Value()



#SelectionSet:
	::brace_:: Selection()* ::_brace::

#Selection:
	Comment() | Field() | FragmentSpread() | InlineFragment()

#FragmentSpread:
	::threeDots:: FragmentName() Directives()?

#InlineFragment:
	::threeDots:: TypeCondition()? Directives()? SelectionSet()

#TypeCondition:
	::on:: NamedType()

#FragmentDefinition:
	::fragment:: FragmentName() TypeCondition() Directives()? SelectionSet()

#FragmentName:
	Name()
// TODO help on this one Name but not "on"

#Field:
	Comment() | Alias()? Name() Arguments()? Directives()? SelectionSet()?

#Alias:
	Name() ::colon::



NamedType:
	Name()

Number:
	<number>

Name:
	<name>

Punctuator:
	::exclamation:: | ::dollar:: | ::parenthesis_:: | ::_parenthesis:: | ::threeDots:: | ::colon:: | ::equals:: | ::at:: | ::bracket_:: | ::_bracket:: | ::brace_:: | ::pipe:: | ::_brace::

#Comment:
	::anchor:: SourceCharacter()? <endLine>

WhiteSpace:
	<space>*

SourceCharacter:
	<character>*
