-module(index).
-export([do_count/3, do_index/2, do_fold/3, do_fold_list/2]).


do_count([], _, Answer) -> Answer;
do_count([Head | Tail], Head, Answer) -> do_count(Tail, Head, {Tail, Head});
do_count([Head | Tail], Val, Answer) -> Answer.

do_index([], Fold) -> Fold;
do_index([Head | Tail], Fold) ->
    {ToDo, ToFold} = do_count([Head | Tail], Head, []),
    do_index(ToDo, [ToFold | Fold]).

do_fold([], _, End) -> End;
do_fold([Head | Tail], Head, End) -> do_fold(Tail, Head + 1, Head);
do_fold(List, _, End) -> {List, End}.

do_fold_list([], Answer) -> Answer;
do_fold_list([Head | Tail], Answer) ->
    {ToDo, Current} = do_fold([Head | Tail], Head + 1, Head),
    do_fold_list(ToDo, [{Head, Current} | Answer]).
