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
  | MOD
  | MULT
  | DIV
  | IF
  | THEN
  | ELSEIF
  | ELSE
  | LT
  | GT
  | LE
  | GE
  | EQUAL
  | NOTEQUAL
  | WHEN
  | OTHERWISE
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


let rec set_var_or_get v nv =
	if(get_var(v) != -1) then SET_VAR(get_var(v), nv) else SET_VAR(declare_var(v), nv)

(** When assignment for var.
	@param v	Value to assign.
	@param lw	Sequence of (condition, expression).
	@return		Built expression. *)
let rec when_assign v lw =
	match lw with
	| [(NO_COND, nv)] -> set_var_or_get v nv
	| (c, nv)::t ->
		IF_THEN(c, set_var_or_get v nv, when_assign v t)

(** When assignment for cell.
	@param lw	Sequence of (condition, expression).
	@return		Built expression. *)
let rec when_assign_cell lw =
	match lw with
	| [(NO_COND, nv)] -> SET_CELL(0, nv)
	| (c, nv)::t ->
		IF_THEN(c, SET_CELL(0, nv), when_assign_cell t)

(* Debug Mode *)
let debug = false

# 87 "parser.ml"
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
  270 (* MOD *);
  271 (* MULT *);
  272 (* DIV *);
  273 (* IF *);
  274 (* THEN *);
  275 (* ELSEIF *);
  276 (* ELSE *);
  277 (* LT *);
  278 (* GT *);
  279 (* LE *);
  280 (* GE *);
  281 (* EQUAL *);
  282 (* NOTEQUAL *);
  283 (* WHEN *);
  284 (* OTHERWISE *);
    0|]

let yytransl_block = [|
  285 (* ID *);
  286 (* INT *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\004\000\004\000\005\000\003\000\003\000\
\006\000\006\000\007\000\007\000\007\000\007\000\007\000\012\000\
\012\000\012\000\011\000\011\000\011\000\011\000\011\000\011\000\
\008\000\010\000\010\000\009\000\009\000\009\000\013\000\013\000\
\013\000\013\000\014\000\014\000\014\000\015\000\015\000\015\000\
\015\000\000\000"

let yylen = "\002\000\
\007\000\003\000\001\000\001\000\003\000\005\000\000\000\001\000\
\002\000\001\000\003\000\003\000\003\000\003\000\006\000\000\000\
\002\000\005\000\003\000\003\000\003\000\003\000\003\000\003\000\
\005\000\002\000\005\000\001\000\003\000\003\000\001\000\003\000\
\003\000\003\000\001\000\002\000\002\000\001\000\001\000\001\000\
\003\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\042\000\000\000\000\000\000\000\000\000\
\000\000\000\000\004\000\000\000\000\000\000\000\000\000\000\000\
\002\000\000\000\000\000\000\000\000\000\008\000\000\000\000\000\
\005\000\000\000\000\000\000\000\000\000\000\000\040\000\039\000\
\038\000\000\000\000\000\000\000\031\000\035\000\000\000\001\000\
\009\000\000\000\006\000\000\000\000\000\036\000\037\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\013\000\000\000\014\000\000\000\
\041\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\034\000\032\000\033\000\000\000\026\000\025\000\
\000\000\000\000\000\000\000\000\000\000\017\000\015\000\000\000\
\000\000\000\000\027\000\000\000\018\000"

let yydgoto = "\002\000\
\004\000\009\000\021\000\010\000\011\000\022\000\023\000\033\000\
\034\000\061\000\035\000\083\000\036\000\037\000\038\000"

let yysindex = "\019\000\
\251\254\000\000\040\255\000\000\051\255\233\254\053\255\039\255\
\065\255\056\255\000\000\044\255\054\255\002\255\041\255\087\255\
\000\000\068\255\004\255\076\255\099\000\000\000\002\255\096\255\
\000\000\071\255\097\255\004\255\022\255\022\255\000\000\000\000\
\000\000\070\255\085\255\050\255\000\000\000\000\004\255\000\000\
\000\000\004\255\000\000\074\255\046\255\000\000\000\000\004\255\
\004\255\004\255\004\255\004\255\004\255\004\255\004\255\002\255\
\004\255\004\255\004\255\010\255\000\000\010\255\000\000\098\255\
\000\000\050\255\050\255\064\255\064\255\064\255\064\255\064\255\
\064\255\059\255\000\000\000\000\000\000\004\255\000\000\000\000\
\004\255\002\255\104\255\102\255\090\255\000\000\000\000\004\255\
\002\255\010\255\000\000\059\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\107\255\000\000\000\000\000\000\110\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\013\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\085\000\000\000\090\000\000\000\000\000\
\000\000\029\000\057\000\253\254\000\255\006\255\009\255\021\255\
\035\255\109\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\109\255\000\000"

let yygindex = "\000\000\
\000\000\000\000\000\000\000\000\097\000\236\255\000\000\242\255\
\249\255\218\255\238\255\021\000\038\000\014\000\059\000"

let yytablesize = 375
let yytable = "\024\000\
\028\000\021\000\041\000\063\000\022\000\007\000\008\000\018\000\
\024\000\018\000\023\000\028\000\010\000\024\000\021\000\029\000\
\030\000\022\000\019\000\001\000\045\000\048\000\049\000\023\000\
\003\000\019\000\024\000\018\000\029\000\028\000\020\000\060\000\
\031\000\032\000\062\000\074\000\078\000\079\000\019\000\020\000\
\005\000\024\000\068\000\069\000\070\000\071\000\072\000\073\000\
\013\000\091\000\031\000\032\000\020\000\006\000\065\000\012\000\
\030\000\048\000\049\000\084\000\015\000\086\000\085\000\057\000\
\058\000\059\000\014\000\024\000\092\000\007\000\075\000\076\000\
\077\000\016\000\024\000\048\000\049\000\081\000\082\000\039\000\
\090\000\048\000\049\000\017\000\012\000\066\000\067\000\046\000\
\047\000\011\000\050\000\051\000\052\000\053\000\054\000\055\000\
\026\000\027\000\040\000\042\000\043\000\044\000\056\000\064\000\
\080\000\087\000\088\000\089\000\003\000\007\000\016\000\025\000\
\093\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
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
\000\000\000\000\028\000\000\000\000\000\028\000\028\000\000\000\
\000\000\028\000\000\000\000\000\028\000\028\000\010\000\000\000\
\000\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
\028\000\028\000\028\000\028\000\028\000\028\000\029\000\010\000\
\010\000\029\000\029\000\000\000\000\000\029\000\000\000\000\000\
\029\000\029\000\000\000\000\000\000\000\029\000\029\000\029\000\
\029\000\029\000\029\000\029\000\029\000\029\000\029\000\029\000\
\029\000\029\000\030\000\000\000\000\000\030\000\030\000\000\000\
\000\000\030\000\000\000\000\000\030\000\030\000\000\000\000\000\
\000\000\030\000\030\000\030\000\030\000\030\000\030\000\030\000\
\030\000\030\000\030\000\030\000\030\000\030\000\012\000\000\000\
\000\000\000\000\012\000\011\000\000\000\000\000\000\000\011\000\
\000\000\000\000\000\000\000\000\000\000\012\000\000\000\012\000\
\012\000\000\000\011\000\000\000\011\000\011\000\000\000\000\000\
\000\000\012\000\000\000\000\000\000\000\000\000\011\000"

let yycheck = "\014\000\
\000\000\005\001\023\000\042\000\005\001\029\001\030\001\006\001\
\023\000\006\001\005\001\008\001\000\000\005\001\018\001\012\001\
\013\001\018\001\017\001\001\000\028\000\012\001\013\001\018\001\
\030\001\005\001\018\001\006\001\000\000\008\001\029\001\039\000\
\029\001\030\001\042\000\056\000\027\001\028\001\018\001\005\001\
\001\001\056\000\050\000\051\000\052\000\053\000\054\000\055\000\
\010\001\088\000\029\001\030\001\018\001\003\001\009\001\003\001\
\000\000\012\001\013\001\078\000\005\001\082\000\081\000\014\001\
\015\001\016\001\002\001\082\000\089\000\029\001\057\000\058\000\
\059\000\030\001\089\000\012\001\013\001\019\001\020\001\004\001\
\088\000\012\001\013\001\030\001\000\000\048\000\049\000\029\000\
\030\000\000\000\021\001\022\001\023\001\024\001\025\001\026\001\
\010\001\030\001\000\000\004\001\030\001\005\001\018\001\030\001\
\007\001\002\001\005\001\018\001\002\001\000\000\002\001\015\000\
\092\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
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
\255\255\255\255\002\001\255\255\255\255\005\001\006\001\255\255\
\255\255\009\001\255\255\255\255\012\001\013\001\002\001\255\255\
\255\255\017\001\018\001\019\001\020\001\021\001\022\001\023\001\
\024\001\025\001\026\001\027\001\028\001\029\001\002\001\019\001\
\020\001\005\001\006\001\255\255\255\255\009\001\255\255\255\255\
\012\001\013\001\255\255\255\255\255\255\017\001\018\001\019\001\
\020\001\021\001\022\001\023\001\024\001\025\001\026\001\027\001\
\028\001\029\001\002\001\255\255\255\255\005\001\006\001\255\255\
\255\255\009\001\255\255\255\255\012\001\013\001\255\255\255\255\
\255\255\017\001\018\001\019\001\020\001\021\001\022\001\023\001\
\024\001\025\001\026\001\027\001\028\001\029\001\002\001\255\255\
\255\255\255\255\006\001\002\001\255\255\255\255\255\255\006\001\
\255\255\255\255\255\255\255\255\255\255\017\001\255\255\019\001\
\020\001\255\255\017\001\255\255\019\001\020\001\255\255\255\255\
\255\255\029\001\255\255\255\255\255\255\255\255\029\001"

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
  MOD\000\
  MULT\000\
  DIV\000\
  IF\000\
  THEN\000\
  ELSEIF\000\
  ELSE\000\
  LT\000\
  GT\000\
  LE\000\
  GE\000\
  EQUAL\000\
  NOTEQUAL\000\
  WHEN\000\
  OTHERWISE\000\
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
# 119 "parser.mly"
 (
		if _1 != 2 then error "only 2 dimension accepted";
		(_4, _6)
	)
# 339 "parser.ml"
               : Ast.prog))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 127 "parser.mly"
  (
			if _1 >= _3 then error "illegal field values";
			[("", (0, (_1, _3)))]
		)
# 350 "parser.ml"
               : 'config))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'fields) in
    Obj.repr(
# 132 "parser.mly"
  ( set_fields _1 )
# 357 "parser.ml"
               : 'config))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'field) in
    Obj.repr(
# 137 "parser.mly"
  ( [_1] )
# 364 "parser.ml"
               : 'fields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'fields) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'field) in
    Obj.repr(
# 139 "parser.mly"
  (_3 :: _1 )
# 372 "parser.ml"
               : 'fields))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 144 "parser.mly"
  (
			if _3 >= _5 then error "illegal field values";
			(_1, (_3, _5))
		)
# 384 "parser.ml"
               : 'field))
; (fun __caml_parser_env ->
    Obj.repr(
# 152 "parser.mly"
  ( NOP )
# 390 "parser.ml"
               : 'opt_statements))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'statements) in
    Obj.repr(
# 154 "parser.mly"
  ( _1 )
# 397 "parser.ml"
               : 'opt_statements))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'statement) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'statements) in
    Obj.repr(
# 159 "parser.mly"
  ( SEQ (_1, _2) )
# 405 "parser.ml"
               : 'statements))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'statement) in
    Obj.repr(
# 162 "parser.mly"
  ( _1 )
# 412 "parser.ml"
               : 'statements))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'cell) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 166 "parser.mly"
  (
			if (fst _1) != 0 then error "assigned x must be 0";
			if (snd _1) != 0 then error "assigned Y must be 0";
			SET_CELL (0, _3)
		)
# 424 "parser.ml"
               : 'statement))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 172 "parser.mly"
  (
			if get_var(_1) != -1 then
				SET_VAR(get_var(_1), _3)
			else
				SET_VAR(declare_var(_1), _3);
		)
# 437 "parser.ml"
               : 'statement))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'when_loop) in
    Obj.repr(
# 179 "parser.mly"
  (
			when_assign _1 _3
		)
# 447 "parser.ml"
               : 'statement))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'cell) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'when_loop) in
    Obj.repr(
# 183 "parser.mly"
  (
			when_assign_cell _3
		)
# 457 "parser.ml"
               : 'statement))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'condition) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'statements) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'else_statement) in
    Obj.repr(
# 187 "parser.mly"
  (
			IF_THEN(_2, _4, _5)
		)
# 468 "parser.ml"
               : 'statement))
; (fun __caml_parser_env ->
    Obj.repr(
# 194 "parser.mly"
  ( NOP )
# 474 "parser.ml"
               : 'else_statement))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'statements) in
    Obj.repr(
# 196 "parser.mly"
  (
			_2
		)
# 483 "parser.ml"
               : 'else_statement))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'condition) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'statements) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'else_statement) in
    Obj.repr(
# 200 "parser.mly"
  (
			IF_THEN(_2, _4, _5)
		)
# 494 "parser.ml"
               : 'else_statement))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 207 "parser.mly"
  (
			if debug == true then
				printf "EQUAL\n";
			COMP(COMP_EQ, _1, _3);
		)
# 506 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 213 "parser.mly"
  (
			if debug == true then
				printf "NOTEQUAL\n";
			COMP(COMP_NE, _1, _3);
		)
# 518 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 219 "parser.mly"
  (
			if debug == true then
				printf "LT\n";
			COMP(COMP_LT, _1, _3);
		)
# 530 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 225 "parser.mly"
  (
			if debug == true then
				printf "GT\n";
			COMP(COMP_GT, _1, _3);
		)
# 542 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 231 "parser.mly"
  (
			if debug == true then
				printf "LE\n";
			COMP(COMP_LE, _1, _3);
		)
# 554 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 237 "parser.mly"
  (
			if debug == true then
				printf "GE\n";
			COMP(COMP_GE, _1, _3);
		)
# 566 "parser.ml"
               : 'condition))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : int) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : int) in
    Obj.repr(
# 245 "parser.mly"
  (
			if (_2 < -1) || (_2 > 1) then error "x out of range";
			if (_4 < -1) || (_4 > 1) then error "x out of range";
			(_2, _4)
		)
# 578 "parser.ml"
               : 'cell))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expression) in
    Obj.repr(
# 254 "parser.mly"
  ( [(NO_COND, _1)] )
# 585 "parser.ml"
               : 'when_loop))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'condition) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'when_loop) in
    Obj.repr(
# 256 "parser.mly"
  (
			(_3, _1)::_5
		)
# 596 "parser.ml"
               : 'when_loop))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 263 "parser.mly"
  ( _1 )
# 603 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 265 "parser.mly"
  (
			if debug == true then
				printf "+\n";
			BINOP(OP_ADD, _1, _3)
		)
# 615 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 271 "parser.mly"
  (
			if debug == true then
				printf "-\n";
			BINOP(OP_SUB, _1, _3)
		)
# 627 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'signed_expression) in
    Obj.repr(
# 280 "parser.mly"
  ( _1 )
# 634 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'signed_expression) in
    Obj.repr(
# 282 "parser.mly"
  (
			if debug == true then
				printf "*\n";
			BINOP(OP_MUL, _1, _3)
		)
# 646 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'signed_expression) in
    Obj.repr(
# 288 "parser.mly"
  (
			if debug == true then
				printf "/\n";
			BINOP(OP_DIV, _1, _3)
		)
# 658 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'signed_expression) in
    Obj.repr(
# 294 "parser.mly"
  (
			if debug == true then
				printf "MOD\n";
			BINOP(OP_MOD, _1, _3)
		)
# 670 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'raw_expression) in
    Obj.repr(
# 302 "parser.mly"
  (
			_1
		)
# 679 "parser.ml"
               : 'signed_expression))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'raw_expression) in
    Obj.repr(
# 306 "parser.mly"
  (
			if debug == true then
				printf "PLUS\n";
			_2
		)
# 690 "parser.ml"
               : 'signed_expression))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'raw_expression) in
    Obj.repr(
# 312 "parser.mly"
  (
			if debug == true then
				printf "MINUS\n";
			NEG (_2)
		)
# 701 "parser.ml"
               : 'signed_expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'cell) in
    Obj.repr(
# 320 "parser.mly"
  (
			if debug == true then
				printf "[%d, %d]\n" (fst _1) (snd _1);
			CELL (0, fst _1, snd _1)
		)
# 712 "parser.ml"
               : 'raw_expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 326 "parser.mly"
  (
			if debug == true then
				printf "%d\n" _1;
			CST (_1)
		)
# 723 "parser.ml"
               : 'raw_expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 332 "parser.mly"
  (
			if debug == true then
				printf "%s\n" _1;
			if get_var(_1) == -1 then
				error "undeclared variable"
			else
				VAR(get_var(_1));
		)
# 737 "parser.ml"
               : 'raw_expression))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expression) in
    Obj.repr(
# 341 "parser.mly"
  ( _2 )
# 744 "parser.ml"
               : 'raw_expression))
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
