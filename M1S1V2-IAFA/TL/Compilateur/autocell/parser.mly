/*
 * autocell - AutoCell compiler and viewer
 * Copyright (C) 2021  University of Toulouse, France <casse@irit.fr>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

%{

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

%}



%token EOF

/* keywords */
%token DIMENSIONS

%token END
%token OF

/* symbols */
%token ASSIGN
%token COMMA
%token LBRACKET RBRACKET
%token LPARENT RPARENT
%token DOT_DOT
%token DOT
%token PLUS
%token MINUS
%token MOD
%token MULT
%token DIV


/* Conditional Statement */
%token IF
%token THEN
%token ELSEIF
%token ELSE
%token THEN
%token END
%token LT
%token GT
%token LE
%token GE
%token EQUAL
%token NOTEQUAL

%token WHEN
%token OTHERWISE

/* values */
%token <string> ID
%token<int> INT

%start program
%type<Ast.prog> program

%%

program: INT DIMENSIONS OF config END opt_statements EOF
	{
		if $1 != 2 then error "only 2 dimension accepted";
		($4, $6)
	}
;

config:
	INT DOT_DOT INT
		{
			if $1 >= $3 then error "illegal field values";
			[("", (0, ($1, $3)))]
		}
|	fields
		{ set_fields $1 }
;

fields:
	field
		{ [$1] }
|	fields COMMA field
		{$3 :: $1 }
;

field:
	ID OF INT DOT_DOT INT
		{
			if $3 >= $5 then error "illegal field values";
			($1, ($3, $5))
		}
;

opt_statements:
	/* empty */
		{ NOP }
|	statements
		{ $1 }
;

statements:
	statement statements
		{ SEQ ($1, $2) }
|
	statement
		{ $1 }

statement:
	cell ASSIGN expression
		{
			if (fst $1) != 0 then error "assigned x must be 0";
			if (snd $1) != 0 then error "assigned Y must be 0";
			SET_CELL (0, $3)
		}
|	ID ASSIGN expression
		{
			if get_var($1) != -1 then
				SET_VAR(get_var($1), $3)
			else
				SET_VAR(declare_var($1), $3);
		}
|	ID ASSIGN when_loop
		{
			when_assign $1 $3
		}
|	cell ASSIGN when_loop
		{
			when_assign_cell $3
		}
|	IF condition THEN statements else_statement END
		{
			IF_THEN($2, $4, $5)
		}
;

else_statement:
	// empty
		{ NOP }
|	ELSE statements
		{
			$2
		}
|	ELSEIF condition THEN statements else_statement
		{
			IF_THEN($2, $4, $5)
		}
;

condition:
	expression EQUAL expression
		{
			if debug == true then
				printf "EQUAL\n";
			COMP(COMP_EQ, $1, $3);
		}
|	expression NOTEQUAL expression
		{
			if debug == true then
				printf "NOTEQUAL\n";
			COMP(COMP_NE, $1, $3);
		}
|	expression LT expression
		{
			if debug == true then
				printf "LT\n";
			COMP(COMP_LT, $1, $3);
		}
|	expression GT expression
		{
			if debug == true then
				printf "GT\n";
			COMP(COMP_GT, $1, $3);
		}
|	expression LE expression
		{
			if debug == true then
				printf "LE\n";
			COMP(COMP_LE, $1, $3);
		}
|	expression GE expression
		{
			if debug == true then
				printf "GE\n";
			COMP(COMP_GE, $1, $3);
		}

cell:
	LBRACKET INT COMMA INT RBRACKET
		{
			if ($2 < -1) || ($2 > 1) then error "x out of range";
			if ($4 < -1) || ($4 > 1) then error "x out of range";
			($2, $4)
		}
;

when_loop:
	expression OTHERWISE
		{ [(NO_COND, $1)] }
|	expression WHEN condition COMMA when_loop
		{
			($3, $1)::$5
		}
;

expression:
	term
		{ $1 }
|	expression PLUS term
		{
			if debug == true then
				printf "+\n";
			BINOP(OP_ADD, $1, $3)
		}
|	expression MINUS term
		{
			if debug == true then
				printf "-\n";
			BINOP(OP_SUB, $1, $3)
		}
;

term:
	signed_expression
		{ $1 }
|	term MULT signed_expression
		{
			if debug == true then
				printf "*\n";
			BINOP(OP_MUL, $1, $3)
		}
|	term DIV signed_expression
		{
			if debug == true then
				printf "/\n";
			BINOP(OP_DIV, $1, $3)
		}
|	term MOD signed_expression
		{
			if debug == true then
				printf "MOD\n";
			BINOP(OP_MOD, $1, $3)
		}

signed_expression:
	raw_expression
		{
			$1
		}
|	PLUS raw_expression
		{
			if debug == true then
				printf "PLUS\n";
			$2
		}
|	MINUS raw_expression
		{
			if debug == true then
				printf "MINUS\n";
			NEG ($2)
		}

raw_expression:
	cell
		{
			if debug == true then
				printf "[%d, %d]\n" (fst $1) (snd $1);
			CELL (0, fst $1, snd $1)
		}
|	INT
		{
			if debug == true then
				printf "%d\n" $1;
			CST ($1)
		}
|	ID
		{
			if debug == true then
				printf "%s\n" $1;
			if get_var($1) == -1 then
				error "undeclared variable"
			else
				VAR(get_var($1));
		}
|	LPARENT expression RPARENT
		{ $2 }
;



