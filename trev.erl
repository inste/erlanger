-module(trev).
-export([remap_list/1, do_solve/2]).


remap_list([Head | Tail]) ->
    [lists:last([Head | Tail]) | lists:delete(length([Head | Tail]), [Head | Tail])].

do_check(X, X) -> io:format("Your number is: ~w~n", [list_to_integer(X)]);
do_check(X, Y) -> io:format("Numbers: ~w ~w ~n", [list_to_integer(X), list_to_integer(Y)]).

do_solve(Current, Max) when Current < Max ->
    do_check(remap_list(integer_to_list(Current)), integer_to_list(Current * 5)),
    do_solve(Current + 10, Max);

do_solve(Current, Max) when Current >= Max ->
    io:format("No answer till ~w~n", [Current]).
