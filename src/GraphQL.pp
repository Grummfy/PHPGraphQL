// TODO we should also skip  line (line tat start with "#")
%skip   ignored         [\x{feff}\x20\x09\x0a\x0d]+|#.+|#

%token  query			query
%token  mutation		mutation
%token  fragment		fragment
%token  subscription    subscription
%token	on				on
%token  name            ([_A-Za-z][_0-9A-Za-z]*)
%token  brace_          {
%token _brace           }
%token  bracket_        \[
%token _bracket         \]
%token  parenthesis_    \(
%token _parenthesis     \)
// %token  pipe            \x7c
%token  colon           :
%token  dollar			\$
%token  exclamation		!
%token  equals			=
%token  at				@
%token  threeDots		\.\.\.
%token  true            true
%token  false           false
%token  null			null
%token  number          \-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][\+\-]?[0-9]+)?
%token  character       "([\x0009\x000A\x000D\x0020-\xFFFF]*)"
%token  quote           "

#Document:
	Definition()*

#Definition:
	OperationDefinition() | FragmentDefinition()

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
	StringValue() | Variable() | Number() | BooleanValue() | NullValue() | EnumValue() | ListValue() | ObjectValue()

BooleanValue:
	<true> | <false>

NullValue:
	<null>

#StringValue:
	::quote:: ::quote:: | ::character:: | ::quote:: Number() ::quote::

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
	Field() | FragmentSpread() | InlineFragment()

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
	Alias()? Name() Arguments()? Directives()? SelectionSet()?

#Alias:
	Name() ::colon::



NamedType:
	Name()

Number:
	<number>

Name:
	<name>

//Punctuator:
//	::exclamation:: | ::dollar:: | ::parenthesis_:: | ::_parenthesis:: | ::threeDots:: | ::colon:: | ::equals:: | ::at:: | ::bracket_:: | ::_bracket:: | ::brace_:: | ::pipe:: | ::_brace::
