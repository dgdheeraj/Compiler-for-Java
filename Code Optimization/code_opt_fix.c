#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int check(char* v_name,char** cp,int cpi)
{
    char* p;
    for(int i=0;i<=cpi;i++)
    {
        //Get Var_name
        p=cp[i];
        int j=0;
        char v[10];
        int vi=-1;
        while(j<strlen(cp[i]) && cp[i][j]>=97 && cp[i][j]<=122)
        {
            vi+=1;
            v[vi]=cp[i][j];
            j++;
        }
        vi+=1;
        v[vi]='\0';
        if(strcmp(v_name,v)==0)
        {
            //printf("%s matches\n",v);
            return i;
        }
    }
    return -1;
}

char *replaceWord(const char *s, const char *oldW, 
                                 const char *newW) 
{ 
    char *result; 
    int i, cnt = 0; 
    int newWlen = strlen(newW); 
    int oldWlen = strlen(oldW); 
  
    // Counting the number of times old word 
    // occur in the string 
    for (i = 0; s[i] != '\0'; i++) 
    { 
        if (strstr(&s[i], oldW) == &s[i]) 
        { 
            cnt++; 
  
            // Jumping to index after the old word. 
            i += oldWlen - 1; 
        } 
    } 
  
    // Making new string of enough length 
    result = (char *)malloc(i + cnt * (newWlen - oldWlen) + 1); 
  
    i = 0; 
    while (*s) 
    { 
        // compare the substring with the result 
        if (strstr(s, oldW) == s) 
        { 
            strcpy(&result[i], newW); 
            i += newWlen; 
            s += oldWlen; 
        } 
        else
            result[i++] = *s++; 
    } 
  
    result[i] = '\0'; 
    return result; 
} 
  
int main()
{
    //Stores the content of the file(ICG)
    char fil_p[100000][10];
    char c[1000];
    FILE* fptr = fopen("sample.txt","r");

    int len=0;
    while (fscanf(fptr, "%s", c)!=EOF)
    {
        strcpy(fil_p[len],c);
        len++;
    }
    //Making a copy of the ICG and storing in fil
    //All modifications done on fil
    char** fil=(char**)malloc(sizeof(char*)*10000);
    for(int i=0;i<10000;i++)
    {
        fil[i]=(char*)malloc(sizeof(char)*100);
        strcpy(fil[i],fil_p[i]);
    }
    //for(int a=0;a<len;a++)
      //  printf("%s\n",fil[a]);

    
    //CONSTANT PROPAGATION
    //Finding if the sentence has a constant
    //cp is the 2d array having all the variables which are constants
    /*eg: a=1
          b=2
        in cp its stored as
        cp=[a1,b2]
    */
    char** cp=(char**)malloc(sizeof(char*)*100);
    for(int i=0;i<100;i++)
            cp[i]=(char*)malloc(sizeof(char)*100);
    int cpi=-1;

    int i=0;
    int j=0;
    while(j<len)
    {
        i=0;
	//Skip If statements
	if(fil[j][0]=='i' && fil[j][0]=='j')
	{
		j+=1;
		continue;
	} 
    //If Label is present skip it
    if(fil[j][0]=='L')
    {
        while(fil[j][i]!=' ')
            i++;
    }

	//LHS
	char var_name[20];
	int var_ind=-1;	
	while(fil[j][i]!=61)
	{
		var_ind+=1;
		var_name[var_ind]=fil[j][i];
		i+=1;
	}
	var_ind+=1;
	var_name[var_ind]='\0';
	//printf("%s\n",var_name);
        
	i+=1;
	
	char d[20];
	int d_ind=-1;
	//Getting the number
	while(i<strlen(fil[j]) && fil[j][i]>=48 && fil[j][i]<=57)
	{    
		d_ind+=1;
                d[d_ind]=fil[j][i];
                i++;
        }
	d_ind+=1;
	d[d_ind]='\0';
	
    //If the number is the last thing in the statement
    if(fil[j][i]=='\0')
	{
		//printf("Constant FOund\n");
		strcat(var_name,d);
		cpi+=1;		
		strcpy(cp[cpi],var_name);
	}	
	j++;
    }
    //Display all the constants present
    //for(int q=0;q<=cpi;q++)
        //printf("%s\n",cp[q]);


    
    //Replace the constants
    j=0;
    i=0;
    while(j<len)
    {
	char* tmp;
	char* r=(char*)malloc(sizeof(char)*100);
	strcpy(r,fil[j]);
	i=0;
	if(fil[j][0]=='i' && fil[j][1]=='f')
	{
		j+=1;
		continue;
	}
	while(fil[j][i]!=61)//Ascii value for =
	{
		i++;
	}
	i++;
	
    //RHS
	char var_name[20];
       	int var_ind=-1;
	while(i<strlen(fil[j]))
	{
		memset(var_name,' ',sizeof(var_name));
		var_ind=-1;
		//If it is a variable
		if(fil[j][i]>=97 && fil[j][i]<=122)
		{
			while(fil[j][i]>=97 && fil[j][i]<=122 || fil[j][i]>=48 && fil[j][i]<=57)
			{
				var_ind+=1;
				var_name[var_ind]=fil[j][i];
				i+=1;			
			}
			var_ind+=1;
			var_name[var_ind]='\0';
			int ch=check(var_name,cp,cpi);
			if(ch!=-1)
			{
				char d[20];
				int d_ind=-1;
      				int t=0;
				while(t<strlen(cp[ch]) )
      				{
					if(cp[ch][t]>=48 && cp[ch][t]<=57)
                                	{
                                		d_ind+=1;
                                		d[d_ind]=cp[ch][t];
                            		}
                            		// printf("%c",cp[e][rec]);
                            		t++;
				}
				d_ind+=1;
				d[d_ind]='\0';
				//printf("%s\n",d);
				tmp=replaceWord(r,var_name,d);
                        	r=tmp;
              		}
			//printf("%s\n",var_name);		
		}
		i+=1;
		
	}
	strcpy(fil[j],r);
	j+=1;    
    } 

    // for(int a=0;a<len;a++)
    //   printf("%s\n",fil[a]);





    //+-*/
    i=0;
    j=0;
    while(j<len)
    {
        i=0;
	//Skip If statements
	if(fil[j][0]=='i' && fil[j][0]=='j')
	{
		j+=1;
		continue;
	} 
    //If Label is present skip it
    if(fil[j][0]=='L')
    {
        while(fil[j][i]!=' ')
            i++;
    }

	//LHS
	char var_name[20];
	int var_ind=-1;	
	while(fil[j][i]!=61)
	{
		var_ind+=1;
		var_name[var_ind]=fil[j][i];
		i+=1;
	}
	var_ind+=1;
	var_name[var_ind]='\0';
	// printf("%s\n",var_name);
        
	i+=1;
	
	char d[20];
	int d_ind=-1;
	//Getting the number
	while(i<strlen(fil[j]) && fil[j][i]>=48 && fil[j][i]<=57)
	{    
		d_ind+=1;
                d[d_ind]=fil[j][i];
                i++;
        }
	d_ind+=1;
	d[d_ind]='\0';
	
    if(fil[j][i]=='+' || fil[j][i]=='-' || fil[j][i]=='*' || fil[j][i]=='/')
    {
        
        char op=fil[j][i];
        char d1[20];
	    int d_ind1=-1;
	    i+=1;
        //Getting the number
	    while(i<strlen(fil[j]) && fil[j][i]>=48 && fil[j][i]<=57)
	    {    
            d_ind1+=1;
            d1[d_ind1]=fil[j][i];
            i++;
        }
	    d_ind1+=1;
	    d1[d_ind1]='\0';

        int val;
        if(op=='+')
        {
            val=atoi(d)+atoi(d1);
            // printf("%d\n",);
        }
        char f[20];
        printf("%s + %s\n",d,d1);
        
    }
    //If the number is the last thing in the statement
    if(fil[j][i]=='\0')
	{
		//printf("Constant FOund\n");
		strcat(var_name,d);
		cpi+=1;		
		strcpy(cp[cpi],var_name);
	}	
	j++;
    }

}



