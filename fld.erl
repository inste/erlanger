-module(fld).
-export([process/2, plc/2]).


process(List, Value) ->
    lists:foldl(fun 
		    (X, Y) when X =< Value->
			[X | Y];
		    (X, Y) when X > Value ->
			Y
		end, [], List).

plc([], Value) ->
    [];
plc(List, Value) ->
    [ X || X <- List, X =< Value ].

