%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "header.h"

//---------SYMBOL TABLE STRUCTURE and DEFINTIONS------------
struct double_list
{
	struct double_list * next;
  	char name[30];
  	int type; // 0-int 1-float 2-char 
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

int fill(char* name,float value,int type);
int  fill_char(char* name,char value,int type);
int  fill_float(char* name,float value,int type);
d_list* lookupsymb(char *id);
void display();
int update(char* id,float value);

//-----MISC DEFINITIONS----------------
int yylex(void);
void yyerror(char *);
extern int yylineno;
int tempno=0;// Global Variable for 
int label=0;
int b_lbl=0;

//------------AST STRUCT AND DEF------------------
typedef struct node
{
    struct node* left;
    struct node* right;
    int type;// 0-leaf value 2-leaf variable 3-temp_variable 1-interior node
    char* token;
    char* tmp; //Name of tmp var
    float value;
    d_list* ptr;
}node; 

union leafval
{
	char val1[20];
	float val2;
}; 
node* initialize_node();
node* leaf(int type,union leafval f);
node* new_node(char* token,node* left,node* right);
void preorder(node* root);



%}

%union
{
    	float number;
        //float num;
    	char *string;
	struct node *tree;
//    	bool *boo;   	 
}

%token <number> T_NUM  
%token <string> T_ID
%type<tree> T_Const
%type<tree> cond
%type<tree> cond_stmts
%type<tree> stmt
%type<tree> stmts
%type<tree> var_decl
%type<tree> iter_stmts
%token <number> T_OParen
%token T_CParen
//%token <num> T_fConst
%type<tree> T_expr
%token T_PUBLIC T_STATIC T_VOID T_STRING T_ARGS
%token  T_WHILE T_MAIN  T_DO T_FOR T_IF T_ELSE
%token T_INT  T_CLASS  T_IMPORT T_FLOAT T_CHAR 
%token T_CHARV
%type<string> T_CHARV
%token T_U_INCR T_U_DECR
%token	T_S_PLUSEQ T_S_MINUSEQ T_S_MULTEQ T_S_DIVEQ TRUE FALSE T_S_DIV
%nonassoc  T_S_EQ
//%left T_S_PLUS T_S_MINUS 
//%left T_S_MULT T_ S_DIV
%right T_GEQ T_LEQ T_LE T_GE T_ASSG T_NE
%left '+' '-'
%left '%' '*' '/'


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
T_CLASS T_ID T_OParen main_stmt T_CParen   {/*display();*/}
;
modifier:
T_PUBLIC  
|T_STATIC
|T_VOID
;
main_stmt:
modifier modifier modifier  T_MAIN '(' T_STRING '[' ']' T_ARGS ')' T_OParen stmts T_CParen {/*preorder($12);*/}
;
stmts:
 stmts stmt {$$=new_node("MStmts",$1,$2);}
 | stmt {$$=$1;}
 ;
 
stmt:
  T_ID T_ASSG T_expr ';' { 
				if(lookupsymb($1)!=NULL)
				{
					union leafval f;
					strcpy(f.val1,$1); 					
					$$=new_node("EQUALS",leaf(2,f),$3);
					//Updating Symbol Table
					d_list* t=lookupsymb($1);	
					t->value.val=$3->value;			
					//Printing ICG
					if($3->type==0)
						printf("%s=%d\n",$1,(int)$3->value);
					else if($3->type==1)
						printf("%s=%s\n",$1,$3->tmp);
					else if($3->type==2)	
						printf("%s=%s\n",$1,$3->ptr->name);				
					
				}
				//Need to Update Symbol Table here
				
			 }  
  | var_decl
  | cond_stmts
  | iter_stmts
  ;

cond_stmts:
  T_IF '(' cond ')' {printf("t%d=not %s\n",tempno,$3->tmp);printf("if t%d goto L%d\n",tempno,label);} T_OParen stmts T_CParen { 
						$$=new_node("if",$3,$7);
						printf("L%d: ",label++);
						
					    }  
//  | T_IF '(' cond ')' T_OParen stmts T_CParen T_ELSE T_OParen stmts T_CParen
;


iter_stmts:
  T_WHILE '(' cond ')' {printf("t%d=not %s\n",tempno,$3->tmp); b_lbl=label;printf("if t%d goto L%d\n",tempno,label+1);printf("L%d : ",label++);} T_OParen stmts T_CParen { $$=new_node("while",$3,$7);
																printf("goto L%d\n",b_lbl);
																printf("L%d : ",label++);
															      }
  |T_FOR '(' var_decl cond ';' T_ID T_ASSG T_expr ')' {printf("t%d=not %s\n",tempno,$4->tmp); 
							b_lbl=label;
							printf("if t%d goto L%d\n",tempno,label+1);
							printf("L%d : ",label++);}    T_OParen stmts T_CParen { $$=new_node("for",$4,$12);
														printf("goto L%d\n",b_lbl);
														printf("L%d : ",label++);
													      }
;

/*
T_expr:
   T_Const T_S_PLUS T_Const {$$=$1+$3;}
   | T_Const T_S_MINUS T_Const {$$=$1-$3;}
   | T_Const T_S_MULT T_Const  {$$=$1*$3;}
   | T_Const T_S_DIV T_Const  {$$=$1/$3;}
    | T_Const {$$=$1;}
;*/
/*
T_expr:
   T_expr '+' T_expr {$$=$1+$3;}
   | T_expr '-' T_expr {$$=$1-$3;}
   | T_expr '*' T_expr  {$$=$1*$3;}
   | T_expr '/' T_expr  {$$=$1/$3;}
   | T_Const {$$=$1;}
;
*/
T_expr:
   T_expr '+' T_expr {
			$$=new_node("ADD",$1,$3); 
			/*if($1->type==2 || $1->type!=2)
				$$->value=$1->ptr->value.val+$3->value;
			else if($1->type!=2 || $1->type==2)
				$$->value=$1->value+$3->ptr->value.val;
			else if($1->type==2 || $1->type==2)
				$$->value=$1->ptr->value.val+$3->ptr->value.val;
			else*/
				$$->value=$1->value+$3->value;
			//if($1->type==2)			
			//printf("%d\n",$1->ptr->value.val);		
			sprintf($$->tmp, "t%d", tempno++);
			if($1->type==0 && $3->type==0)
				printf("%s=%d+%d\n",$$->tmp,(int)$1->value,(int)$3->value);
		      	else if($1->type==0 && $3->type==1)
				printf("%s=%d+%s\n",$$->tmp,(int)$1->value,$3->tmp);
		        else if($1->type==1 && $3->type==0)
				printf("%s=%s+%d\n",$$->tmp,$1->tmp,(int)$3->value);
		        else if($1->type==1 && $3->type==1)
				printf("%s=%s+%s\n",$$->tmp,$1->tmp,$3->tmp);
		        else if($1->type==0 && $3->type==2)
				printf("%s=%d+%s\n",$$->tmp,(int)$1->value,$3->ptr->name);
			else if($1->type==2 && $3->type==0)
				printf("%s=%s+%d\n",$$->tmp,$1->ptr->name,(int)$3->value);
			else if($1->type==1 && $3->type==2)
				printf("%s=%s+%s\n",$$->tmp,$1->tmp,$3->ptr->name);
			else if($1->type==2 && $3->type==1)
				printf("%s=%s+%s\n",$$->tmp,$1->ptr->name,$3->tmp);
			
		     }
   | T_expr '-' T_expr {
			$$=new_node("SUB",$1,$3); 
			/*if($1->type==2 || $1->type!=2)
				$$->value=$1->ptr->value.val-$3->value;
			if($1->type!=2 || $1->type==2)
				$$->value=$1->value-$3->ptr->value.val;
			if($1->type==2 || $1->type==2)
				$$->value=$1->ptr->value.val-$3->ptr->value.val;
			else*/
				$$->value=$1->value-$3->value;
			
			sprintf($$->tmp, "t%d", tempno++);
			if($1->type==0 && $3->type==0)
				printf("%s=%d-%d\n",$$->tmp,(int)$1->value,(int)$3->value);
		      	else if($1->type==0 && $3->type==1)
				printf("%s=%d-%s\n",$$->tmp,(int)$1->value,$3->tmp);
		        else if($1->type==1 && $3->type==0)
				printf("%s=%s-%d\n",$$->tmp,$1->tmp,(int)$3->value);
		        else if($1->type==1 && $3->type==1)
				printf("%s=%s-%s\n",$$->tmp,$1->tmp,$3->tmp);
		        else if($1->type==0 && $3->type==2)
				printf("%s=%d-%s\n",$$->tmp,(int)$1->value,$3->ptr->name);
			else if($1->type==2 && $3->type==0)
				printf("%s=%s-%d\n",$$->tmp,$1->ptr->name,(int)$3->value);
			else if($1->type==1 && $3->type==2)
				printf("%s=%s-%s\n",$$->tmp,$1->tmp,$3->ptr->name);
			else if($1->type==2 && $3->type==1)
				printf("%s=%s-%s\n",$$->tmp,$1->ptr->name,$3->tmp);
			
		     }
   | T_expr '*' T_expr{
			$$=new_node("MUL",$1,$3); 
			/*if($1->type==2 || $1->type!=2)
				$$->value=$1->ptr->value.val*$3->value;
			if($1->type!=2 || $1->type==2)
				$$->value=$1->value*$3->ptr->value.val;
			if($1->type==2 || $1->type==2)
				$$->value=$1->ptr->value.val*$3->ptr->value.val;
			else*/
				$$->value=$1->value*$3->value;
			
			sprintf($$->tmp, "t%d", tempno++);
			if($1->type==0 && $3->type==0)
				printf("%s=%d*%d\n",$$->tmp,(int)$1->value,(int)$3->value);
		      	else if($1->type==0 && $3->type==1)
				printf("%s=%d*%s\n",$$->tmp,(int)$1->value,$3->tmp);
		        else if($1->type==1 && $3->type==0)
				printf("%s=%s*%d\n",$$->tmp,$1->tmp,(int)$3->value);
		        else if($1->type==1 && $3->type==1)
				printf("%s=%s*%s\n",$$->tmp,$1->tmp,$3->tmp);
		        else if($1->type==0 && $3->type==2)
				printf("%s=%d*%s\n",$$->tmp,(int)$1->value,$3->ptr->name);
			else if($1->type==2 && $3->type==0)
				printf("%s=%s*%d\n",$$->tmp,$1->ptr->name,(int)$3->value);
			else if($1->type==1 && $3->type==2)
				printf("%s=%s*%s\n",$$->tmp,$1->tmp,$3->ptr->name);
			else if($1->type==2 && $3->type==1)
				printf("%s=%s*%s\n",$$->tmp,$1->ptr->name,$3->tmp);
			
		     }
   | T_expr '/' T_expr{
			$$=new_node("DIV",$1,$3); 
			/*if($1->type==2 || $1->type!=2)
				$$->value=$1->ptr->value.val/$3->value;
			if($1->type!=2 || $1->type==2)
				$$->value=$1->value/$3->ptr->value.val;
			if($1->type==2 || $1->type==2)
				$$->value=$1->ptr->value.val/$3->ptr->value.val;
			else*/
				$$->value=$1->value/$3->value;
			
			sprintf($$->tmp, "t%d", tempno++);
			if($1->type==0 && $3->type==0)
				printf("%s=%d/%d\n",$$->tmp,(int)$1->value,(int)$3->value);
		      	else if($1->type==0 && $3->type==1)
				printf("%s=%d/%s\n",$$->tmp,(int)$1->value,$3->tmp);
		        else if($1->type==1 && $3->type==0)
				printf("%s=%s/%d\n",$$->tmp,$1->tmp,(int)$3->value);
		        else if($1->type==1 && $3->type==1)
				printf("%s=%s/%s\n",$$->tmp,$1->tmp,$3->tmp);
		        else if($1->type==0 && $3->type==2)
				printf("%s=%d/%s\n",$$->tmp,(int)$1->value,$3->ptr->name);
			else if($1->type==2 && $3->type==0)
				printf("%s=%s/%d\n",$$->tmp,$1->ptr->name,(int)$3->value);
			else if($1->type==1 && $3->type==2)
				printf("%s=%s/%s\n",$$->tmp,$1->tmp,$3->ptr->name);
			else if($1->type==2 && $3->type==1)
				printf("%s=%s/%s\n",$$->tmp,$1->ptr->name,$3->tmp);
			
		     }
   | T_Const {	$$=$1; /*printf("%d\n",$$->type);*/ /*sprintf($$->tmp, "t%d", tempno++);if($$->type==1) printf("%s=%d\n",$$->tmp,(int)$1->value);*/}
;

T_Const:
//| T_NUM { $$=$1;}
T_NUM {union leafval f;f.val2=$1; $$=leaf(0,f);}
| T_ID {
		if(lookupsymb($1)!=NULL)
		 {
			union leafval f;
			strcpy(f.val1,$1); 
			$$=leaf(2,f);
			d_list* t=lookupsymb($1);
			$$->value=t->value.val;
		 }
	}
;

cond:
//TRUE 
//|FALSE
T_expr T_GEQ T_expr  {	$$=new_node(">=",$1,$3); 
			if($1->value>=$3->value) 
				$$->value=1; 
			else 
				$$->value=0;
			sprintf($$->tmp, "t%d", tempno++);
			if($1->type==0 && $3->type==0)
				printf("%s=%d>=%d\n",$$->tmp,(int)$1->value,(int)$3->value);
		      	else if($1->type==0 && $3->type==1)
				printf("%s=%d>=%s\n",$$->tmp,(int)$1->value,$3->tmp);
		        else if($1->type==1 && $3->type==0)
				printf("%s=%s>=%d\n",$$->tmp,$1->tmp,(int)$3->value);
		        else if($1->type==1 && $3->type==1)
				printf("%s=%s>=%s\n",$$->tmp,$1->tmp,$3->tmp);
		        else if($1->type==0 && $3->type==2)
				printf("%s=%d>=%s\n",$$->tmp,(int)$1->value,$3->ptr->name);
			else if($1->type==2 && $3->type==0)
				printf("%s=%s>=%d\n",$$->tmp,$1->ptr->name,(int)$3->value);
			else if($1->type==1 && $3->type==2)
				printf("%s=%s>=%s\n",$$->tmp,$1->tmp,$3->ptr->name);
			else if($1->type==2 && $3->type==1)
				printf("%s=%s>=%s\n",$$->tmp,$1->ptr->name,$3->tmp);
			else if($1->type==2 &&$3->type==2)
				printf("%s=%s>=%s\n",$$->tmp,$1->ptr->name,$3->ptr->name);
		     
		     }
|T_expr T_LEQ T_expr {
			$$=new_node("<=",$1,$3); 
			if($1->value<=$3->value) 
				$$->value=1; 
			else $$->value=0;
			sprintf($$->tmp, "t%d", tempno++);
			if($1->type==0 && $3->type==0)
				printf("%s=%d<=%d\n",$$->tmp,(int)$1->value,(int)$3->value);
		      	else if($1->type==0 && $3->type==1)
				printf("%s=%d<=%s\n",$$->tmp,(int)$1->value,$3->tmp);
		        else if($1->type==1 && $3->type==0)
				printf("%s=%s<=%d\n",$$->tmp,$1->tmp,(int)$3->value);
		        else if($1->type==1 && $3->type==1)
				printf("%s=%s<=%s\n",$$->tmp,$1->tmp,$3->tmp);
		        else if($1->type==0 && $3->type==2)
				printf("%s=%d<=%s\n",$$->tmp,(int)$1->value,$3->ptr->name);
			else if($1->type==2 && $3->type==0)
				printf("%s=%s<=%d\n",$$->tmp,$1->ptr->name,(int)$3->value);
			else if($1->type==1 && $3->type==2)
				printf("%s=%s<=%s\n",$$->tmp,$1->tmp,$3->ptr->name);
			else if($1->type==2 && $3->type==1)
				printf("%s=%s<=%s\n",$$->tmp,$1->ptr->name,$3->tmp);
			else if($1->type==2 &&$3->type==2)
				printf("%s=%s<=%s\n",$$->tmp,$1->ptr->name,$3->ptr->name);
		     
		     }
|T_expr T_GE T_expr  {
			$$=new_node(">",$1,$3);  
			if($1->value>$3->value) 
				$$->value=1; 
			else 
				$$->value=0;
			sprintf($$->tmp, "t%d", tempno++);
			if($1->type==0 && $3->type==0)
				printf("%s=%d>%d\n",$$->tmp,(int)$1->value,(int)$3->value);
		      	else if($1->type==0 && $3->type==1)
				printf("%s=%d>%s\n",$$->tmp,(int)$1->value,$3->tmp);
		        else if($1->type==1 && $3->type==0)
				printf("%s=%s>%d\n",$$->tmp,$1->tmp,(int)$3->value);
		        else if($1->type==1 && $3->type==1)
				printf("%s=%s>%s\n",$$->tmp,$1->tmp,$3->tmp);
		        else if($1->type==0 && $3->type==2)
				printf("%s=%d>%s\n",$$->tmp,(int)$1->value,$3->ptr->name);
			else if($1->type==2 && $3->type==0)
				printf("%s=%s>%d\n",$$->tmp,$1->ptr->name,(int)$3->value);
			else if($1->type==1 && $3->type==2)
				printf("%s=%s>%s\n",$$->tmp,$1->tmp,$3->ptr->name);
			else if($1->type==2 && $3->type==1)
				printf("%s=%s>%s\n",$$->tmp,$1->ptr->name,$3->tmp);
			else if($1->type==2 &&$3->type==2)
				printf("%s=%s>%s\n",$$->tmp,$1->ptr->name,$3->ptr->name);
		     }
|T_expr T_LE T_expr  {
			$$=new_node("<",$1,$3);  
			if($1->value<$3->value) 
				$$->value=1; 
			else 
				$$->value=0;
			sprintf($$->tmp, "t%d", tempno++);
			//printf("%d %d\n",$1->type,$3->type);
			if($1->type==0 && $3->type==0)
				printf("%s=%d<%d\n",$$->tmp,(int)$1->value,(int)$3->value);
		      	else if($1->type==0 && $3->type==1)
				printf("%s=%d<%s\n",$$->tmp,(int)$1->value,$3->tmp);
		        else if($1->type==1 && $3->type==0)
				printf("%s=%s<%d\n",$$->tmp,$1->tmp,(int)$3->value);
		        else if($1->type==1 && $3->type==1)
				printf("%s=%s<%s\n",$$->tmp,$1->tmp,$3->tmp);
		        else if($1->type==0 && $3->type==2)
				printf("%s=%d<%s\n",$$->tmp,(int)$1->value,$3->ptr->name);
			else if($1->type==2 && $3->type==0)
				printf("%s=%s<%d\n",$$->tmp,$1->ptr->name,(int)$3->value);
			else if($1->type==1 && $3->type==2)
				printf("%s=%s<%s\n",$$->tmp,$1->tmp,$3->ptr->name);
			else if($1->type==2 && $3->type==1)
				printf("%s=%s<%s\n",$$->tmp,$1->ptr->name,$3->tmp);
			else if($1->type==2 &&$3->type==2)
				printf("%s=%s<%s\n",$$->tmp,$1->ptr->name,$3->ptr->name);
		     
		     }
|T_expr T_S_EQ T_expr {
			$$=new_node("==",$1,$3);
			if($1->value==$3->value) 
				$$->value=1; 
			else 
				$$->value=0;
			sprintf($$->tmp, "t%d", tempno++);
			if($1->type==0 && $3->type==0)
				printf("%s=%d==%d\n",$$->tmp,(int)$1->value,(int)$3->value);
		      	else if($1->type==0 && $3->type==1)
				printf("%s=%d==%s\n",$$->tmp,(int)$1->value,$3->tmp);
		        else if($1->type==1 && $3->type==0)
				printf("%s=%s==%d\n",$$->tmp,$1->tmp,(int)$3->value);
		        else if($1->type==1 && $3->type==1)
				printf("%s=%s==%s\n",$$->tmp,$1->tmp,$3->tmp);
		        else if($1->type==0 && $3->type==2)
				printf("%s=%d==%s\n",$$->tmp,(int)$1->value,$3->ptr->name);
			else if($1->type==2 && $3->type==0)
				printf("%s=%s==%d\n",$$->tmp,$1->ptr->name,(int)$3->value);
			else if($1->type==1 && $3->type==2)
				printf("%s=%s==%s\n",$$->tmp,$1->tmp,$3->ptr->name);
			else if($1->type==2 && $3->type==1)
				printf("%s=%s==%s\n",$$->tmp,$1->ptr->name,$3->tmp);
			else if($1->type==2 &&$3->type==2)
				printf("%s=%s==%s\n",$$->tmp,$1->ptr->name,$3->ptr->name);
		     
		     } 
;

/* 
var_decl:
	T_INT T_ID ';' { fill($2,0,0);}
	|T_INT T_ID T_ASSG T_expr ';' {fill($2,$4,0);}
	|T_FLOAT T_ID ';' { fill($2,0.0,1);}
	|T_FLOAT T_ID T_ASSG T_expr ';' {fill($2,$4,1);}
	|T_CHAR T_ID ';' { fill_char($2,'a',2);}
	|T_CHAR T_ID T_ASSG T_CHARV ';' {fill_char($2,$4[1],2);}
       //| T_Const T_S_DIV T_Const  {$$=$1/$3;}
       ;
*/
var_decl:
	//T_INT T_ID ';' { fill($2,0,0);}
	T_INT T_ID T_ASSG T_expr ';' {  if($4->type==0)
						printf("%s=%d\n",$2,(int)$4->value);	
					else if($4->type==1)					
						printf("%s=%s\n",$2,$4->tmp);
					fill($2,$4->value,0);
					union leafval f;
					strcpy(f.val1,$2); 					
					$$=new_node("EQUALS",leaf(2,f),$4);				
				       }
	//|T_FLOAT T_ID ';' { fill($2,0.0,1);}
	//|T_FLOAT T_ID T_ASSG T_expr ';' {fill($2,$4,1);}
	//|T_CHAR T_ID ';' { fill_char($2,'a',2);}
	//|T_CHAR T_ID T_ASSG T_CHARV ';' {fill_char($2,$4[1],2);}
        //| T_Const T_S_DIV T_Const  {$$=$1/$3;}
       ;



%%

//------SYMBOL TABLE FUNCTIONS---------------------------------
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
  return 1;
}

int  fill_char(char* name,char value,int type){
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
  if(type==2)//Integer
  {
  	newnode->value.vale=value;
  	//printf("%c\n",newnode->value.vale);
  }
  else{
	printf("Error\n");
	yyerror("");
	return -1;
	exit(1);
  }
  newnode->next=head;
  head=newnode;
  return 1;
}

void display(){
  d_list* node;
  node=head;
  printf("\nLINE NUMBER  VARIABLE NAME \t   TYPE \t VALUE \t SCOPE\n");  
  while(node!=NULL)
  {
    if(node->type==0)
    printf("%d            %s           \t   %s \t\t  %d \t %d\n",node->l,node->name,"int",node->value.val,node->scope);
    //printf("var-name\t%s\tvalue\t%d\tint\tline %d\n",node->name,node->value.val,node->l);
    if(node->type==1)
    printf("%d            %s           \t   %s \t  %0.2f \t %d\n",node->l,node->name,"float",node->value.valu,node->scope);
    if(node->type==2)
    printf("%d            %s           \t   %s \t  %c \t %d\n",node->l,node->name,"char",node->value.vale,node->scope);
    node=node->next;
  }
  
}

d_list* lookupsymb(char *id){
  d_list* node;
  node=head;
  if(head==NULL){
    printf("Variable Not declared at line %d\n",yylineno);
    yyerror("");
    return NULL;
    exit(1);

  }
  while(node!=NULL){
    if(strcmp(id,node->name)==0){
      //return node->value.val;
      return node;
    }
    node=node->next;
  }
  if(node==NULL){
    printf("Variable Not declared at line %d\n",yylineno);
    yyerror("");
    return NULL;
    exit(1);
  }  
}

//--------------AST FUNCTIONS-------------------------------

node* initialize_node()
{
    node* tmp=(node*)malloc(sizeof(node));
    tmp->left=tmp->right=NULL;
    tmp->type=-1;
    tmp->value=0;
    tmp->tmp=(char*)malloc(sizeof(char)*30);
    tmp->token=(char*)malloc(sizeof(char)*30);
    return tmp;
}

node* leaf(int type,union leafval f)
{
    node* tmp=initialize_node();
    if(type==0)
    {
	tmp->value=f.val2;
    	tmp->type=0;//leaf nodes
    }
    if(type==2)
    {
       	tmp->ptr=lookupsymb(f.val1);
    	tmp->type=2;//leaf variable
    }

    return tmp;
}
node* new_node(char* token,node* left,node* right)
{
    node* t=initialize_node();
    t->type=1;//interior node
    strcpy(t->token,token);
    t->left=left;
    t->right=right;
    return t;
}
void preorder(node* root)
{
    if(root==NULL)
    {
	//printf("\n");
        return;
    }
    preorder(root->left);
    if(root->type==0)
        printf("%f ",root->value);
    if(root->type==1)
        printf("%s ",root->token);
    //Need to check if variable exists
    if(root->type==2)
        printf("%s ",root->ptr->name);
    preorder(root->right);
}

//------------OTHER FUNCTIONS-------------------------------
void yyerror(char *s) {
fprintf(stderr, "%s", s);
}
int main()
{
yyparse();

return 0;
}



