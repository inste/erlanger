-module(reverse).
-export([remap_list/1, do_solve/2]).


remap_list([Head | Tail]) ->
    [lists:last([Head | Tail]) | lists:delete(length([Head | Tail]), [Head | Tail])].


do_solve(Current, Max) ->
    CurrentReverseList = remap_list(integer_to_list(Current)),
    MulByFiveList = integer_to_list(Current * 5),
    
    if
	CurrentReverseList == MulByFiveList -> io:format("The your number is: ~w~n", [list_to_integer(CurrentReverseList)]);
	CurrentReverseList /= MulByFiveList ->
	    if 
		Current < Max -> do_solve(Current + 10, Max);
		Current >= Max -> io:format("No answer till ~w ~n", [Current])
	    end
    end.
