#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int check(char* v_name,char** cp,int cpi)
{
    char* p;
    for(int i=0;i<=cpi;i++)
    {
        // printf("%s\n",cp[i]);
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
        // printf("%s\n",v);
        // printf("%d %s %s\n",strcmp(v_name,v),v_name,v);
        if(strcmp(v_name,v)==0)
        {
            printf("%s matches\n",v);
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
    char fil_p[100000][10];
    // char** fil_p=(char**)malloc(sizeof(char*)*10000);
    // for(int i=0;i<10000;i++)
            // fil_p[i]=(char*)malloc(sizeof(char)*100);
    char c[1000];
    FILE* fptr = fopen("sample.txt","r");

    int len=0;
    while (fscanf(fptr, "%s", c)!=EOF)
    {
        strcpy(fil_p[len],c);
        len++;
    }
    // for(int a=0;a<len;a++)
        // printf("%s\n",fil[a]);


    char** fil=(char**)malloc(sizeof(char*)*10000);
    for(int i=0;i<10000;i++)
    {
        fil[i]=(char*)malloc(sizeof(char)*100);
        strcpy(fil[i],fil_p[i]);
    }


    //Constant Propagation
    //Finding if the sentence has a constant
    // char cp[100][100];
    char** cp=(char**)malloc(sizeof(char*)*100);
    for(int i=0;i<100;i++)
            cp[i]=(char*)malloc(sizeof(char)*100);
    int cpi=-1;

    int i=0;
    int j=0;
    while(j<len)
    {
        i=0;
        while(i<strlen(fil[j]))
        {

            //Getting the variable name
            char var_name[20];
            int v_index=-1;
            while(fil[j][i]!=61)
            {
                v_index+=1;
                var_name[v_index]=fil[j][i];
                i++;
            }
            v_index+=1;
            var_name[v_index]='\0';

            
            char d[20];
            int s=-1;
            if(fil[j][i]==61)//ASCII for =
            {
                i+=1;
                //Getting the number
                while(i<strlen(fil[j]) && fil[j][i]>=48 && fil[j][i]<=57)
                {    
                    // printf("%c",fil[2][i]);
                    s+=1;
                    d[s]=fil[j][i];
                    i++;
                }
                s+=1;
                d[s]='\0';
                
            }
            if(fil[j][i]=='\0')
            {
                if(strlen(d)>=1)
                {
                    //Concatenating the name of the var and the value and storing in var_name
                    strcat(var_name,d);
                    //Storing all the constants in cpi
                    cpi+=1;
                    strcpy(cp[cpi],var_name);

                }
            }
            i++;
        }
        j++;
    }
    //Display all the constants present
    // printf("%c",cp[0][0]);
    // for(int q=0;q<=cpi;q++)
        // printf("%s\n",cp[q]);


    //Replace constants with values
    char new_s[1000][100];
    int new_ind=-1;
    j=0;
    i=0;
    while(j<len)
    {
        i=0;
        while(fil[j][i]!=61)
        {
            i++;
        }

        char v_n[20];
        int v_ind=-1;
        int start_ind;
        if(fil[j][i]==61)
        {
            i+=1;
            char* t;
            char* r=(char*)malloc(sizeof(char)*100);
            strcpy(r,fil[j]);
            // char t[100];
            while(i<strlen(fil[j]))      
            {
                if(fil[j][i]>=97 && fil[j][i]<=122)
                {
                    start_ind=i;
                    memset(v_n,' ',sizeof(v_n));
                    v_ind=-1;
                    while(i<strlen(fil[j]) && fil[j][i]>=97 && fil[j][i]<=122 || fil[j][i]>=48 && fil[j][i]<=57)
                    {
                        // printf("%c\n",fil[j][i]);
                        v_ind+=1;
                        v_n[v_ind]=fil[j][i];
                        i++;
                    }
                    v_ind+=1;
                    v_n[v_ind]='\0';
                    // printf("%s %d\n",v_n,start_ind);
                    int e=check(v_n,cp,cpi);
                    if(e!=-1)
                    {
                        //Get the number
                        char num[100];
                        int num_i=-1;
                        int rec=0;
                        while(rec<strlen(cp[e]) )
                        {
                            if( cp[e][rec]>=48 && cp[e][rec]<=57)
                            {
                                num_i+=1;
                                num[num_i]=cp[e][rec];
                            }
                            // printf("%c",cp[e][rec]);
                            rec++;
                        }
                        num_i+=1;
                        num[num_i]='\0';
                        t=replaceWord(r,v_n,num);
                        r=t;
                        // printf("%s %d\n",r,strlen(r));
                    }
                }
                i+=1;
            }
            new_ind+=1;
            strcpy(new_s[new_ind],r);
        }
        j++;
    }
    for(int i=0;i<new_ind;i++)
        printf("%s\n",new_s[i]);

    //Final result from Constant Folding is stored new_s(A 2d array of the entire ICG) and size of the array is new_ind(num of lines) 

    //Constant Folding
        
}