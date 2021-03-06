-module(bowling_web).
-behaviour(spooky).
-export([init/1, get/2]).
-import(bowling_service).

init([])->
    register(bowl_svc, bowling_service:init()),
    [{port, 8000}].

get(_Req, ["add", Player, RollText])->
    io:format("Add ~s for ~s~n", [RollText, Player]),
    Score = bowling_service:append(Player, RollText, bowl_svc),
    {200, io_lib:format("~p", [Score])};

get(Req, [])-> get(Req, ["form.html"]);  % main page

get(_Req, Path)->  % other static pages
    Filename = filename:join(Path),
    case file:read_file(Filename) of
        {ok, PageBytes} -> {200, binary_to_list(PageBytes)};
        {error, Reason} -> {404, Reason}
    end.
