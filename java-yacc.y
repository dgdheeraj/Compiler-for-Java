%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "header.h"

struct double_list
{
	struct double_list * next;
  	char name[30];
  	int type;
  	int l;//line number
  	int scope;  	
	union Value 
	{
    	int val;
    	char vale;
    	float valu;
  	}value;
};
typedef struct double_list d_list;
d_list* head=NULL;
int yylex(void);
void yyerror(char *);
extern int yylineno;
int fill(char*name,float value,int type);
int  fill_float(char* name,float value,int type);
int lookupsymb(char *id);
void display();
int update(char* id,float value);
%}

%union
{
    	float number;
        //float num;
    	char *string;
//    	bool *boo;   	 
}

%token <number> T_NUM  
%token <string> T_ID
%type<number> T_Const
%token <number> T_OParen
%token T_CParen
//%token <num> T_fConst
%type<number> T_expr
%token T_PUBLIC T_STATIC T_VOID T_STRING T_ARGS
%token  T_WHILE T_MAIN  T_DO T_FOR
%token T_INT  T_CLASS  T_IMPORT T_FLOAT T_CHAR 
%token T_CHARV
%type<string> T_CHARV
%token T_U_INCR T_U_DECR
%token	T_S_PLUSEQ T_S_MINUSEQ T_S_MULTEQ T_S_DIVEQ TRUE FALSE T_S_DIV
%nonassoc  T_S_EQ
%left T_S_PLUS T_S_MINUS T_S_MULT T_ S_DIV
%right T_GEQ T_LEQ T_LE T_GE T_ASSG T_NE


%%
/*start_aug:
import_stmt class_def {exit(0);}
| class_def  {exit(0);}
;
import_stmt:
 T_IMPORT T_ID
;*/
class_def:
modifier Class_head
;
Class_head:
T_CLASS T_ID T_OParen main_stmt T_CParen   {display();}
;
modifier:
T_PUBLIC  
|T_STATIC
|T_VOID
;
main_stmt:
modifier modifier modifier  T_MAIN '(' T_STRING '[' ']' T_ARGS ')' T_OParen stmts T_CParen 
;
stmts:
 stmts stmt
 | stmt
 ;
 
stmt:
  T_ID T_ASSG T_expr ';' {lookupsymb($1);update($1,$3);}  
  | var_decl
  |T_WHILE '(' cond ')' T_OParen stmts T_CParen
  | T_DO '{' stmts '}' T_WHILE'(' cond ')' ';'
;

T_expr:
   T_Const T_S_PLUS T_Const {$$=$1+$3;}
   | T_Const T_S_MINUS T_Const {$$=$1-$3;}
   | T_Const T_S_MULT T_Const  {$$=$1*$3;}
   | T_Const T_S_DIV T_Const  {$$=$1/$3;}
    | T_Const {$$=$1;}
;

T_Const:
T_ID {$$=lookupsymb($1);}
//| T_fConst { printf("%f\n",$1);$$=$1 ;}
| T_NUM { $$=$1;}
;

cond:
|TRUE 
|FALSE
|T_expr T_GEQ T_expr 
|T_expr T_LEQ T_expr
|T_expr T_GE T_expr
|T_expr T_LE T_expr
|T_expr T_S_EQ T_expr 
;

 
var_decl:
	T_INT T_ID ';' { fill($2,0,0);}
	|T_INT T_ID T_ASSG T_expr ';' {fill($2,$4,0);}
	|T_FLOAT T_ID ';' { fill($2,0.0,1);}
	|T_FLOAT T_ID T_ASSG T_expr ';' {fill($2,$4,1);}
	|T_CHAR T_ID ';' { printf("char\n");}
	|T_CHAR T_ID T_ASSG T_CHARV ';' {printf("char %c\n",$4[1]);}
       //| T_Const T_S_DIV T_Const  {$$=$1/$3;}
       ;




%%
int update(char*name,float value){
  d_list*node=head;
  while(node!=NULL)
  {
    if(strcmp(name,node->name)==0){
      if(node->type==0)
      	node->value.val=(int)value;
      if(node->type==1)
        node->value.valu=value;
      //printf("%s %d",node->name,node->value.val);
      node->l=yylineno;
      return 1;
      
    }
    node=node->next;

  }
   
  return 0;
  exit(1);

}

int  fill(char* name,float value,int type){
  d_list*node=head;
  //printf("%d\n",yylineno);
  while(node!=NULL){
    if(strcmp(name,node->name)==0){
      printf("Variable already declared at line %d\n",yylineno);
      yyerror("");
      return  -1;
      exit(1);
      
    }
    node=node->next;
  }
  node=head;
  d_list* newnode=(d_list*) malloc(sizeof(d_list));
  strcpy(newnode->name,name);
  newnode->type=type;
  newnode->scope=n.s;
  newnode->l=yylineno;
  if(type==0)//Integer
  	newnode->value.val=(int)value;
  if(type==1)//Float
  	newnode->value.valu=value;
  newnode->next=head;
  head=newnode;
   
}
int  fill_float(char* name,float value,int type){
  d_list*node=head;
  //printf("%f\n",value);
  while(node!=NULL){
    if(strcmp(name,node->name)==0){
      printf("Variable already declared at line %d\n",yylineno);
      yyerror("");
      return  -1;
      exit(1);
      
    }
    node=node->next;
  }
  node=head;
  d_list* newnode=(d_list*) malloc(sizeof(d_list));
  strcpy(newnode->name,name);
  newnode->type=type;
  newnode->l=yylineno;
  newnode->scope=n.s;
  newnode->value.valu=value;
  newnode->next=head;
  head=newnode;   
}

void display(){
  d_list* node;
  node=head;
  printf("LINE NUMBER  VARIABLE NAME \t   TYPE \t VALUE \t SCOPE\n");  
  while(node!=NULL)
  {
    if(node->type==0)
    printf("%d            %s           \t   %s \t\t  %d \t %d\n",node->l,node->name,"int",node->value.val,node->scope);
    //printf("var-name\t%s\tvalue\t%d\tint\tline %d\n",node->name,node->value.val,node->l);
    if(node->type==1)
    printf("%d            %s           \t   %s \t  %0.2f \t %d\n",node->l,node->name,"float",node->value.valu,node->scope);
    node=node->next;
  }
  
}
int lookupsymb(char *id){
  d_list* node;
  node=head;
  if(head==NULL){
    printf("Variable Not declared at line %d\n",yylineno);
    yyerror("");
    return -1;
    exit(1);

  }
  while(node!=NULL){
    if(strcmp(id,node->name)==0){
      return node->value.val;

    }
    node=node->next;
  }
  if(node==NULL){
    printf("Variable Not declared at line %d\n",yylineno);
    yyerror("");
    return -1;
    exit(1);
  }
  
}

void yyerror(char *s) {
fprintf(stderr, "%s", s);
}
int main()
{
yyparse();

return 0;
}



