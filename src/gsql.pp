// we should also skip comment line (line tat start with "#")
%skip   ignored         [\xfeff\x20\x09\x0a\x0d]+

%token  name            ([_A-Za-z][_0-9A-Za-z]*)
%token  brace_          {
%token _brace           }
%token  bracket_        \[
%token _bracket         \]
%token  number          \-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][\+\-]?[0-9]+)?
%token  parenthesis_    \(
%token _parenthesis     \)
%token  colon           :
%token  query			query
%token  mutation		mutation
%token  fragment		fragment
%token	on				on
%token  dollar			\$
%token  exclamation		!
%token  equals			=
%token  true            true
%token  false           false
%token  null			null
%token  at				@
%token  threeDots		\.\.\.

#Document:
	Definition()*

#Definition:
	(OperationDefinition() | FragmentDefinition())

#OperationDefinition:
	(OperationType() Name()? VariableDefinitions()? Directives()? SelectionSet() | SelectionSet())

OperationType:
	(<query> | <mutation>)

Name:
	<name>

#FragmentDefinition:
	::fragment:: FragmentName() TypeCondition() Directives() SelectionSet()

#FragmentName:
	Name()
// TODO Name but no "on" 

#TypeCondition:
	Name() ::on::

VariableDefinitions:
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

number:
	<number>

#Value:
	Variable() | number() | Name() | BooleanValue() | EnumValue() | ListValue() | ObjectValue()

BooleanValue:
	<true> | <false>

#EnumValue:
	Name()*
// but not null, true or false

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

#FragmentDefinition:
	::fragment:: FragmentName() TypeCondition() Directives()? SelectionSet()

#Field:
	Alias()? Name() Arguments()? Directives()? SelectionSet()?	

#Alias:
	Name() ::colon::
