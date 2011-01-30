-module(btree).
-export([create/0, destroy/1, insert/2, height/1]).

-record(leaf, {right, left, value}).

create() -> #leaf{right = {}, left = {}, value = []}.

destroy(_) -> ok.

max(X, Y) when X >= Y -> X;
max(X, Y) when X < Y -> Y.

height(#leaf{right = {}, left = {}}) -> 1;
height(#leaf{right = Right, left = Left}) ->
    max(height(Right), height(Left)) + 1.

insert(#leaf{right = {}, left = {}, value = []}, Value) ->
    #leaf{right = {}, left = {}, value = Value};
    
insert(#leaf{right = {}, left = {}, value = Val}, Value) when Value < Val ->
    #leaf{right = create(), left = insert(create(), Value), value = Val};
    
insert(#leaf{right = {}, left = {}, value = Val}, Value) when Value > Val ->
    #leaf{right = insert(create(), Value), left = create(), value = Val};
    
insert(#leaf{right = Right, left = Left, value = Val}, Value) when Value < Val ->
    #leaf{right = Right, left = insert(Left, Value), value = Val};
    
insert(#leaf{right = Right, left = Left, value = Val}, Value) when Value > Val ->
    #leaf{right = insert(Right, Value), left = Left, value = Val}.
