type token =
  | EOF
  | DIMENSIONS
  | END
  | OF
  | ASSIGN
  | COMMA
  | LBRACKET
  | RBRACKET
  | LPARENT
  | RPARENT
  | DOT_DOT
  | DOT
  | PLUS
  | MINUS
  | MULT
  | DIV
  | MOD
  | IF
  | THEN
  | ELSEIF
  | ELSE
  | SI
  | SS
  | EI
  | ES
  | EQUAL
  | NOTEQUAL
  | ID of (string)
  | INT of (int)

open Parsing;;
let _ = parse_error;;
# 17 "parser.mly"

open Common
open Ast
open Printf
open Symbols

(** Raise a syntax error with the given message.
	@param msg	Message of the error. *)
let error msg =
	raise (SyntaxError msg)


(** Restructure the when assignment into selections.
	@param f	Function to build the assignment.
	@param v	Initial values.
	@param ws	Sequence of (condition, expression).
	@return		Built statement. *)
let rec make_when f v ws =
	match ws with
	| [] ->	f v
	| (c, nv)::t ->
		IF_THEN(c, f v, make_when f nv t)

(* Debug Mode *)
let debug = false

# 62 "parser.ml"
let yytransl_const = [|
    0 (* EOF *);
  257 (* DIMENSIONS *);
  258 (* END *);
  259 (* OF *);
  260 (* ASSIGN *);
  261 (* COMMA *);
  262 (* LBRACKET *);
  263 (* RBRACKET *);
  264 (* LPARENT *);
  265 (* RPARENT *);
  266 (* DOT_DOT *);
  267 (* DOT *);
  268 (* PLUS *);
  269 (* MINUS *);
  270 (* MULT *);
  271 (* DIV *);
  272 (* MOD *);
  273 (* IF *);
  274 (* THEN *);
  275 (* ELSEIF *);
  276 (* ELSE *);
  277 (* SI *);
  278 (* SS *);
  279 (* EI *);
  280 (* ES *);
  281 (* EQUAL *);
  282 (* NOTEQUAL *);
    0|]

let yytransl_block = [|
  283 (* ID *);
  284 (* INT *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\004\000\004\000\005\000\003\000\003\000\
\006\000\006\000\006\000\006\000\006\000\006\000\007\000\008\000\
\008\000\009\000\009\000\009\000\009\000\009\000\009\000\010\000\
\010\000\010\000\012\000\012\000\012\000\012\000\011\000\011\000\
\011\000\011\000\011\000\000\000"

let yylen = "\002\000\
\007\000\003\000\001\000\001\000\003\000\005\000\000\000\002\000\
\003\000\003\000\005\000\007\000\009\000\011\000\005\000\001\000\
\001\000\003\000\003\000\003\000\003\000\003\000\003\000\001\000\
\002\000\002\000\001\000\001\000\001\000\003\000\003\000\003\000\
\003\000\003\000\003\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\036\000\000\000\000\000\000\000\000\000\
\000\000\000\000\004\000\000\000\000\000\000\000\000\000\000\000\
\002\000\000\000\000\000\000\000\000\000\000\000\000\000\005\000\
\000\000\000\000\000\000\000\000\000\000\029\000\028\000\027\000\
\000\000\000\000\016\000\017\000\024\000\000\000\001\000\008\000\
\000\000\006\000\000\000\000\000\026\000\025\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\030\000\031\000\032\000\
\033\000\034\000\035\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\015\000\011\000\000\000\000\000\000\000\000\000\
\000\000\012\000\000\000\013\000\000\000\000\000\014\000"

let yydgoto = "\002\000\
\004\000\009\000\021\000\010\000\011\000\022\000\032\000\033\000\
\034\000\035\000\036\000\037\000"

let yysindex = "\012\000\
\240\254\000\000\015\255\000\000\019\255\238\254\020\255\014\255\
\044\255\045\255\000\000\027\255\028\255\254\254\021\255\047\255\
\000\000\031\255\041\255\056\255\062\000\254\254\062\255\000\000\
\042\255\072\255\041\255\255\254\255\254\000\000\000\000\000\000\
\060\255\061\255\000\000\000\000\000\000\041\255\000\000\000\000\
\041\255\000\000\050\255\078\255\000\000\000\000\255\254\255\254\
\255\254\255\254\255\254\041\255\041\255\041\255\041\255\041\255\
\041\255\254\254\083\255\083\255\073\255\000\000\000\000\000\000\
\000\000\000\000\000\000\083\255\083\255\083\255\083\255\083\255\
\083\255\016\255\000\000\000\000\041\255\254\254\070\255\087\255\
\254\254\000\000\017\255\000\000\254\254\098\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\099\255\000\000\000\000\000\000\102\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\011\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\032\255\001\000\006\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\085\255\086\255\088\255\089\255\090\255\
\091\255\000\000\000\000\000\000\000\000\103\255\000\000\000\000\
\043\255\000\000\000\000\000\000\103\255\000\000\000\000"

let yygindex = "\000\000\
\000\000\000\000\236\255\000\000\095\000\000\000\242\255\232\255\
\034\000\000\000\000\000\248\255"

let yytablesize = 289
let yytable = "\023\000\
\010\000\040\000\044\000\018\000\018\000\009\000\027\000\023\000\
\007\000\008\000\007\000\003\000\001\000\059\000\019\000\005\000\
\060\000\076\000\084\000\045\000\046\000\006\000\012\000\013\000\
\020\000\030\000\031\000\068\000\069\000\070\000\071\000\072\000\
\073\000\007\000\077\000\078\000\085\000\074\000\063\000\064\000\
\065\000\066\000\067\000\023\000\007\000\014\000\018\000\007\000\
\027\000\015\000\007\000\007\000\028\000\029\000\016\000\017\000\
\025\000\080\000\026\000\038\000\083\000\039\000\007\000\023\000\
\086\000\041\000\023\000\030\000\031\000\042\000\023\000\047\000\
\048\000\049\000\050\000\051\000\043\000\061\000\058\000\075\000\
\052\000\053\000\054\000\055\000\056\000\057\000\062\000\081\000\
\082\000\047\000\048\000\049\000\050\000\051\000\047\000\048\000\
\049\000\050\000\051\000\087\000\003\000\007\000\020\000\021\000\
\007\000\022\000\023\000\018\000\019\000\024\000\079\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\010\000\000\000\000\000\000\000\010\000\009\000\
\000\000\000\000\000\000\009\000\007\000\000\000\000\000\000\000\
\000\000\010\000\000\000\010\000\010\000\000\000\009\000\000\000\
\009\000\009\000\000\000\010\000\000\000\007\000\007\000\000\000\
\009\000"

let yycheck = "\014\000\
\000\000\022\000\027\000\006\001\006\001\000\000\008\001\022\000\
\027\001\028\001\000\000\028\001\001\000\038\000\017\001\001\001\
\041\000\002\001\002\001\028\000\029\000\003\001\003\001\010\001\
\027\001\027\001\028\001\052\000\053\000\054\000\055\000\056\000\
\057\000\002\001\019\001\020\001\020\001\058\000\047\000\048\000\
\049\000\050\000\051\000\058\000\002\001\002\001\006\001\027\001\
\008\001\005\001\019\001\020\001\012\001\013\001\028\001\028\001\
\010\001\078\000\028\001\004\001\081\000\000\000\020\001\078\000\
\085\000\004\001\081\000\027\001\028\001\028\001\085\000\012\001\
\013\001\014\001\015\001\016\001\005\001\028\001\018\001\007\001\
\021\001\022\001\023\001\024\001\025\001\026\001\009\001\018\001\
\002\001\012\001\013\001\014\001\015\001\016\001\012\001\013\001\
\014\001\015\001\016\001\002\001\002\001\000\000\018\001\018\001\
\002\001\018\001\018\001\018\001\018\001\015\000\077\000\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\002\001\255\255\255\255\255\255\006\001\002\001\
\255\255\255\255\255\255\006\001\002\001\255\255\255\255\255\255\
\255\255\017\001\255\255\019\001\020\001\255\255\017\001\255\255\
\019\001\020\001\255\255\027\001\255\255\019\001\020\001\255\255\
\027\001"

let yynames_const = "\
  EOF\000\
  DIMENSIONS\000\
  END\000\
  OF\000\
  ASSIGN\000\
  COMMA\000\
  LBRACKET\000\
  RBRACKET\000\
  LPARENT\000\
  RPARENT\000\
  DOT_DOT\000\
  DOT\000\
  PLUS\000\
  MINUS\000\
  MULT\000\
  DIV\000\
  MOD\000\
  IF\000\
  THEN\000\
  ELSEIF\000\
  ELSE\000\
  SI\000\
  SS\000\
  EI\000\
  ES\000\
  EQUAL\000\
  NOTEQUAL\000\
  "

let yynames_block = "\
  ID\000\
  INT\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 6 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'config) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'opt_statements) in
    Obj.repr(
# 88 "parser.mly"
 (
		if _1 != 2 then error "only 2 dimension accepted";
		(_4, _6)
	)
# 285 "parser.ml"
               : Ast.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 96 "parser.mly"
  (
			if _1 >= _3 then error "illegal field values";
			[("", (0, (_1, _3)))]
		)
# 296 "parser.ml"
               : 'config))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'fields) in
    Obj.repr(
# 101 "parser.mly"
  ( set_fields _1 )
# 303 "parser.ml"
               : 'config))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'field) in
    Obj.repr(
# 106 "parser.mly"
  ( [_1] )
# 310 "parser.ml"
               : 'fields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'fields) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'field) in
    Obj.repr(
# 108 "parser.mly"
  (_3 :: _1 )
# 318 "parser.ml"
               : 'fields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 113 "parser.mly"
  (
			if _3 >= _5 then error "illegal field values";
			(_1, (_3, _5))
		)
# 330 "parser.ml"
               : 'field))
; (fun __caml_parser_env ->
    Obj.repr(
# 121 "parser.mly"
  (
			if debug == true then
				printf "empty\n";
			NOP
		)
# 340 "parser.ml"
               : 'opt_statements))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'statement) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'opt_statements) in
    Obj.repr(
# 127 "parser.mly"
  (
			if debug == true then
				printf "opt_statements statement\n";
			SEQ (_1, _2)
		)
# 352 "parser.ml"
               : 'opt_statements))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'cell) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 137 "parser.mly"
  (
			if (fst _1) != 0 then error "assigned x must be 0";
			if (snd _1) != 0 then error "assigned Y must be 0";
			SET_CELL (0, _3)
		)
# 364 "parser.ml"
               : 'statement))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 143 "parser.mly"
  (
			printf "ASSIGN\n";
			if get_var(_1) != -1 then
				SET_VAR(get_var(_1), _3)
			else
				SET_VAR(declare_var(_1), _3);
		)
# 378 "parser.ml"
               : 'statement))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'condition) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'opt_statements) in
    Obj.repr(
# 151 "parser.mly"
  ( 
			IF_THEN(_2, _4, NOP)
		)
# 388 "parser.ml"
               : 'statement))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : 'condition) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'opt_statements) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'opt_statements) in
    Obj.repr(
# 155 "parser.mly"
  ( 
			IF_THEN(_2, _4, _6)
		)
# 399 "parser.ml"
               : 'statement))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 7 : 'condition) in
    let _4 = (Parsing.peek_val __caml_parser_env 5 : 'opt_statements) in
    let _6 = (Parsing.peek_val __caml_parser_env 3 : 'condition) in
    let _8 = (Parsing.peek_val __caml_parser_env 1 : 'opt_statements) in
    Obj.repr(
# 159 "parser.mly"
  ( 
			IF_THEN(_2, _4, IF_THEN(_6, _8, NOP))
		)
# 411 "parser.ml"
               : 'statement))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 9 : 'condition) in
    let _4 = (Parsing.peek_val __caml_parser_env 7 : 'opt_statements) in
    let _6 = (Parsing.peek_val __caml_parser_env 5 : 'condition) in
    let _8 = (Parsing.peek_val __caml_parser_env 3 : 'opt_statements) in
    let _10 = (Parsing.peek_val __caml_parser_env 1 : 'opt_statements) in
    Obj.repr(
# 163 "parser.mly"
  ( 
			IF_THEN(_2, _4, IF_THEN(_6, _8, _10))
		)
# 424 "parser.ml"
               : 'statement))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : int) in
    Obj.repr(
# 171 "parser.mly"
  (
			if (_2 < -1) || (_2 > 1) then error "x out of range";
			if (_4 < -1) || (_4 > 1) then error "x out of range";
			(_2, _4)
		)
# 436 "parser.ml"
               : 'cell))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'signe) in
    Obj.repr(
# 180 "parser.mly"
  ( _1 )
# 443 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'operator) in
    Obj.repr(
# 182 "parser.mly"
  ( _1 )
# 450 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 187 "parser.mly"
  (
			COMP(COMP_EQ, _1, _3);
		)
# 460 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 191 "parser.mly"
  (
			COMP(COMP_NE, _1, _3);
		)
# 470 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 195 "parser.mly"
  (
			COMP(COMP_LT, _1, _3);
		)
# 480 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 199 "parser.mly"
  (
			COMP(COMP_GT, _1, _3);
		)
# 490 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 203 "parser.mly"
  (
			COMP(COMP_LE, _1, _3);
		)
# 500 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 207 "parser.mly"
  (
			COMP(COMP_GE, _1, _3);
		)
# 510 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'raw_expression) in
    Obj.repr(
# 213 "parser.mly"
  (
			_1
		)
# 519 "parser.ml"
               : 'signe))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'raw_expression) in
    Obj.repr(
# 217 "parser.mly"
  (
			if debug == true then
				printf "MINUS\n";
			_2
		)
# 530 "parser.ml"
               : 'signe))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'raw_expression) in
    Obj.repr(
# 223 "parser.mly"
  (
			if debug == true then
				printf "PLUS\n";
			_2
		)
# 541 "parser.ml"
               : 'signe))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'cell) in
    Obj.repr(
# 231 "parser.mly"
  (
			if debug == true then
				printf "[%d, %d]\n" (fst _1) (snd _1);
			CELL (0, fst _1, snd _1)
		)
# 552 "parser.ml"
               : 'raw_expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 237 "parser.mly"
  (
			if debug == true then
				printf "%d\n" _1;
			CST _1
		)
# 563 "parser.ml"
               : 'raw_expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 243 "parser.mly"
  (
			if debug == true then
				printf "%s\n" _1;
			if get_var(_1) == -1 then error (sprintf "%s is undefined" _1 );
			VAR(get_var(_1))
		)
# 575 "parser.ml"
               : 'raw_expression))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expression) in
    Obj.repr(
# 250 "parser.mly"
  ( _2 )
# 582 "parser.ml"
               : 'raw_expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'raw_expression) in
    Obj.repr(
# 254 "parser.mly"
  (
			BINOP(OP_ADD, _1, _3)
		)
# 592 "parser.ml"
               : 'operator))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'raw_expression) in
    Obj.repr(
# 258 "parser.mly"
  (
			BINOP(OP_SUB, _1, _3)
		)
# 602 "parser.ml"
               : 'operator))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'raw_expression) in
    Obj.repr(
# 262 "parser.mly"
  (
			BINOP(OP_MUL, _1, _3)
		)
# 612 "parser.ml"
               : 'operator))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'raw_expression) in
    Obj.repr(
# 266 "parser.mly"
  (
			BINOP(OP_DIV, _1, _3)
		)
# 622 "parser.ml"
               : 'operator))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'raw_expression) in
    Obj.repr(
# 270 "parser.mly"
  (
			BINOP(OP_MOD, _1, _3)
		)
# 632 "parser.ml"
               : 'operator))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.prog)
