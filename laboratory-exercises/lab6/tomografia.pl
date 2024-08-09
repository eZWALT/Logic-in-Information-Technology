:- use_module(library(clpfd)).

ejemplo1( [0,0,8,2,6,4,5,3,7,0,0], [0,0,7,1,6,3,4,5,2,7,0,0] ).
ejemplo2( [10,4,8,5,6], [5,3,4,0,5,0,5,2,2,0,1,5,1] ).
ejemplo3( [11,5,4], [3,2,3,1,1,1,1,2,3,2,1] ).


p:-	ejemplo3(RowSums,ColSums),

	%1a:VARIABLES
	length(RowSums,NumRows),
	length(ColSums,NumCols),
	NVars is NumRows*NumCols,
	listVars(NVars,L),  % generate a list of Prolog vars (their names do not matter)

	%1b:DOMAIN
	L ins 0..1,
	%2:CONSTRAINST
	matrixByRows(L,NumCols,MatrixByRows),
	transpose(MatrixByRows, MatrixByColumns),

	declareConstraints(RowSums,ColSums,MatrixByRows,MatrixByColumns),

	%3:LABELING
	label(L),
	%4:WRITE
	pretty_print(RowSums,ColSums,MatrixByRows).


%%%%%%%%%%%%%%%%%%%%%%%funciones
	listVars(Nvars, L):- length(L, Nvars).

	matrixByRows([],_,[]):-!.
	matrixByRows(L,NumCols,[X|Matrix]):- length(X, NumCols), append(X,L1,L), matrixByRows(L1,NumCols,Matrix).

	declareConstraints(RSums, CSums, MRows, MColumns):-checkSum(RSums, MRows), checkSum(CSums, MColumns).

	checkSum([],[]):-!.
	checkSum([X|Sum], [Y|Matrix]):- sum(Y,#=,X), checkSum(Sum, Matrix).
	% sum(+Vars, +Rel, ?Expr) La suma de La LISTA=+VARS tiene la relacion=+Rel con ?Expr
	% Rel is one of #=, #\=, #<, #>, #=< or #>=.


pretty_print(_,ColSums,_):- write('     '), member(S,ColSums), writef('%2r ',[S]), fail.
pretty_print(RowSums,_,M):- nl,nth1(N,M,Row), nth1(N,RowSums,S), nl, writef('%3r   ',[S]), member(B,Row), wbit(B), fail.
pretty_print(_,_,_).
wbit(1):- write('*  '),!.
wbit(0):- write('   '),!.
