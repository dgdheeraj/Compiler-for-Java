#include<stdio.h>
#include<stdlib.h>
#include<string.h>


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
            // printf("%c\n",fil[j][i]);
            i++;
        }


        char v_n[20];
        int v_ind=-1;
        int start_ind;
        if(fil[j][i]==61)
        {
            i+=1;
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
                    printf("%s %d\n",v_n,start_ind);
                        
                }
                i+=1;
            }
        }
        j++;
    }

    
}