% utilities
sum([], 0).
sum([H|T], S) :- sum(T, N), S is H + N.

mul([], 1).
mul([H|T], M) :- mul(T, N), M is H * N.

size([], 0).
size([_|T], S) :- size(T, N), S is N + 1.

% ex 1.1
% search2(Elem, List)
% looks for two consecutive occurrences of Elem
search2(E, [E, E|_]) :- !.
search2(E, [_|T]) :- search2(E, T).

% ex 1.2
% search_two(Elem, List)
% looks for two occurrences of Elem with any element in between!
search_two(E, [E, _|T]) :- member(E, T), !.
search_two(E, [_|T]) :- search_two(E, T).

% ex 1.3
% count(List, E, N)
% N is the number of times E appears in List
% Is it fully relational? Yes because list would be generated (possibly looping)

% ex 1.4
% avg(List, Avg)
avg(L, A) :- sum(L, Sum), size(L, Size), A is Sum / Size.

% ex 1.5
% max(List, Max, Min)
% Max is the biggest element in List
% Min is the smallest element in List
% Suppose the list has at least one element
max([H], H, H).
max([H|T], H, OldMin) :- max(T, OldMax, OldMin), H > OldMax, !.
max([H|T], OldMax, H) :- max(T, OldMax, OldMin), H < OldMin, !.
max([H|T], OldMax, OldMin) :- max(T, OldMax, OldMin).

% ex 1.6
% split(List1, Elements, SubList1, SubList2)
% Splits a list into two sublists based on a given set of elements .
split(L, 0, [], L).
split([H|T], N, [H|L1], L2) :- P is N-1, split(T, P, L1, L2).

% ex 1.7
% rotate(List, RotatedList)
% Rotate a list, namely move the first element to the end of the list .
rotate([], []).
rotate([H|T], L) :- append(T, [H], L).

% ex 1.8
% dice (X)
% Generates all possible outcomes of throwing a dice
dice(X) :- X is 1.
dice(X) :- X is 2.
dice(X) :- X is 3.
dice(X) :- X is 4.
dice(X) :- X is 5.
dice(X) :- X is 6.
% (se c'è tempo provare una soluzione con interval + member)

% three_dice(L).
% Generates all possible outcomes of throwing three dices
% example: three_dice(L). -> L/[1,1,3]; L/[1,2,2];...; L/[3,1,1]
three_dice([D1, D2, D3]) :- dice(D1), dice(D2), dice(D3).

% distinct(List, DistinctList)
% DistinctList contains all distinct elements from List.
% example: distinct([1,2,3,2,4,1],L). -> L/[1,2,3,4]
distinct(L, D) :- distinct(L, D, []).
distinct([], D, D).
distinct([H|T], D, S) :- member(H, S), distinct(T, D, S), !.
distinct([H|T], D, S) :- append(S, [H], O), distinct(T, D, O).

% ex 2.2 (already implemented)
% dropAny(?Elem, ?List, ?OutList)
% eg dropAny(10,[10,20,10,30,10],L)
dropAny(X, [X|T], T).
dropAny(X, [H|Xs], [H|L]) :- dropAny(X, Xs, L).

% ex 2.3
dropFirst(X, [X|T], T) :- !.
dropFirst(X, [H|Xs], [H|L]) :- dropAny(X, Xs, L).

dropLast(X, L, O) :- dropLast(X, L, O, _).
dropLast(_, [], [], false).
dropLast(X, [X|Xs], L, true) :- dropLast(X, Xs, L, Dropped), Dropped=false, !.
dropLast(X, [H|Xs], [H|L], Dropped) :- dropLast(X, Xs, L, Dropped).

dropAll(_, [], []).
dropAll(X, [X|Xs], L) :- dropAll(X, Xs, L), !.
dropAll(X, [H|Xs], [H|L]) :- dropAll(X, Xs, L).

% ex 3.1 (already implemented)
% fromList(+List, -Graph)
fromList([_], []).
fromList([H1,H2|T], [e(H1, H2)|L]) :- fromList([H2|T], L).

% ex 3.2
% outDegree(+Graph, +Node, -Deg)
% Deg is the number of edges which start from Node
outDegree([], _, 0).
outDegree([e(N, _)|T], N, R) :- outDegree(T, N, O), !, R is O + 1.
outDegree([_|T], N, O) :- outDegree(T, N, O).

% ex 3.3
% reaching(+Graph, +Node, -List)
% all the nodes that can be reached in 1 step from Node
% possibly use findall, looking for e(Node ,_) combined
% with member(?Elem, ?List)
reaching(G, N, L) :- findall(D, member(e(N, D), G), L).

% ex 3.4
% nodes(+Graph, -Nodes)
% create a list of all nodes (no duplicates) in the graph (inverse of fromList)
nodes(G, N) :- nodes_with_duplicates(G, L), distinct(L, N).
nodes_with_duplicates([], []).
nodes_with_duplicates([e(N1, N2)|T], [N1, N2|T2]) :- nodes_with_duplicates(T, T2).

% ex 3.5
% anypath(+Graph, +Node1, +Node2, -ListPath)
% a path from Node1 to Node2
% if there are many path, they are showed 1-by-1
anypath([e(N1, N2)|_], N1, N2, [e(N1, N2)]).
anypath([e(N1, N3)|T], N1, N2, [e(N1, N3)|O]) :- anypath(T, N3, N2, O).
anypath([_|T], N1, N2, O) :- anypath(T, N1, N2, O).

% ex 3.5
% allreaching(+Graph, +Node, -List)
% all the nodes that can be reached from Node
% Suppose the graph is NOT circular!
% Use findall and anyPath!
allreaching(G, N, O) :- findall(Reached, anypath(G, N, Reached, _), B), distinct(B, O).