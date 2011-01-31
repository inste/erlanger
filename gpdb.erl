%%%
%
%	Module : gpdb.erl
%	Desc : Database realization with using OTP behavour gen_server.
%	INSTE, 2011
%
%%%

-module(gpdb).

%%%	External user functions

-export([start_link/0, stop/0, write/2, delete/1, read/1, match/1]).

%%%	Internal gsm_server callbacks

-export([init/1, handle_call/3, handle_cast/2, terminate/2]). 

-behaviour(gen_server).

-record(item, {key, value}).

%%%  External interface definition


% :INTERFACE: Destroying DB and stopping the DB process
%	Args : none
%	Returns : ok.
stop() ->
	gen_server:cast(?MODULE, stop).

% :INTERFACE: Inserting a tuple
%	Args : Key, Element
%	Returns : ok.
write(Key, Element) -> 
	gen_server:call(?MODULE, {insert, #item{key = Key, value = Element}}).

% :INTERFACE: Removing
%	Args : Key (key of the couple)
%	Returns : ok.
delete(Key) ->
	gen_server:call(?MODULE, {delete, Key}).

% :INTERFACE: Reading
%	Args : Key (Key of requested data).
%	Returns : Element.
read(Key) ->
	Ref = make_ref(),
	{read_answer, Ref, Key, Answer} = gen_server:call(?MODULE, {read, Key, Ref}),
	Answer.

% :INTERFACE: Matching
%	Args : Element
%	Returns : List of keys, coupled with this Element
match(Element) ->
	Ref = make_ref(),
	{match_answer, Ref, Element, Answer} = gen_server:call(?MODULE, {match, Element, Ref}),
	Answer.


%%% Internal realization

% Inserting new element at the head of the list
insert(Value, []) -> [Value];
insert(Value, List) -> [Value | List].

% Deleting the element with key 'Key' from the db
deleteitem([], _, X) -> X;
deleteitem([#item{key = Key} | Tail], Key, NewDb) -> deleteitem(Tail, Key, NewDb);
deleteitem([Head | Tail], Key, NewDb) -> deleteitem(Tail, Key, [Head | NewDb]).

% Reading the element from Db
readthrough([], _Key) -> {error, instance};
readthrough([#item{key = Key, value = Element} | _Tail], Key) -> {ok, Element};
readthrough([_Head | Tail], Key) -> readthrough(Tail, Key).

% Matching the elements
matching([], _, Answer) -> Answer;
matching([#item{key = Key, value = Element} | Tail], Element, Answer) -> matching(Tail, Element, [Key | Answer]);
matching([_Head | Tail], Element, Answer) -> matching(Tail, Element, Answer).


%%% gen_server callbacks

% Starting the server
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init(_) ->
	{ok, []}.

terminate(_Reason, _Data) ->
	ok.

handle_call({insert, Value}, _From, LoopData) ->
	{reply, ok, insert(Value, LoopData)};

handle_call({delete, Key}, _From, LoopData) ->
	{reply, ok, deleteitem(LoopData, Key, [])};

handle_call({read, Key, Ref}, _From, LoopData) ->
	{reply, {read_answer, Ref, Key, readthrough(LoopData, Key)}, LoopData};

handle_call({match, Element, Ref}, _From, LoopData) ->
	{reply, {match_answer, Ref, Element, matching(LoopData, Element, [])}, LoopData}.

handle_cast(stop, LoopData) ->
	{stop, normal, LoopData}.


