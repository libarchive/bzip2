/*
	minibz2
		libbz2.dll test program.
		by Yoshioka Tsuneo(QWF00133@nifty.ne.jp/tsuneo-y@is.aist-nara.ac.jp)
		This file is Public Domain.
		welcome any email to me.

	usage: minibz2 [-d] [-{1,2,..9}] [[srcfilename] destfilename]
*/

#define BZ_IMPORT
#include "bzlib.h"
#include <stdio.h>
#include <stdlib.h>
#ifdef _WIN32
#include <io.h>
#endif


#ifdef _WIN32

#include <windows.h>
static int BZ2DLLLoaded = 0;
static HINSTANCE BZ2DLLhLib;
int BZ2DLLLoadLibrary(void)
{
	HINSTANCE hLib;

	if(BZ2DLLLoaded==1){return 0;}
	hLib=LoadLibrary("libbz2.dll");
	if(hLib == NULL){
		puts("Can't load libbz2.dll");
		return -1;
	}
	BZ2DLLLoaded=1;
	BZ2DLLhLib=hLib;
	bzlibVersion=GetProcAddress(hLib,"bzlibVersion");
	bzopen=GetProcAddress(hLib,"bzopen");
	bzdopen=GetProcAddress(hLib,"bzdopen");
	bzread=GetProcAddress(hLib,"bzread");
	bzwrite=GetProcAddress(hLib,"bzwrite");
	bzflush=GetProcAddress(hLib,"bzflush");
	bzclose=GetProcAddress(hLib,"bzclose");
	bzerror=GetProcAddress(hLib,"bzerror");
	return 0;

}
int BZ2DLLFreeLibrary(void)
{
	if(BZ2DLLLoaded==0){return 0;}
	FreeLibrary(BZ2DLLhLib);
	BZ2DLLLoaded=0;
}
#endif /* WIN32 */

void usage(void)
{
	puts("usage: minibz2 [-d] [-{1,2,..9}] [[srcfilename] destfilename]");
}

void main(int argc,char *argv[])
{
	int decompress = 0;
	int level = 9;
	char *fn_r,*fn_w;

#ifdef _WIN32
	if(BZ2DLLLoadLibrary()<0){
		puts("can't load dll");
		exit(1);
	}
#endif
	while(++argv,--argc){
		if(**argv =='-' || **argv=='/'){
			char *p;

			for(p=*argv+1;*p;p++){
				if(*p=='d'){
					decompress = 1;
				}else if('1'<=*p && *p<='9'){
					level = *p - '0';
				}else{
					usage();
					exit(1);
				}
			}
		}else{
			break;
		}
	}
	if(argc>=1){
		fn_r = *argv;
		argc--;argv++;
	}else{
		fn_r = NULL;
	}
	if(argc>=1){
		fn_w = *argv;
		argc--;argv++;
	}else{
		fn_w = NULL;
	}
	{
		int len;
		char buff[0x1000];
		char mode[10];

		if(decompress){
			BZFILE *BZ2fp_r;
			FILE *fp_w;

			if(fn_w){
				if((fp_w = fopen(fn_w,"wb"))==NULL){
					printf("can't open [%s]\n",fn_w);
					perror("reason:");
					exit(1);
				}
			}else{
				fp_w = stdout;
			}
			if((BZ2fp_r == NULL && (BZ2fp_r = bzdopen(fileno(stdin),"rb"))==NULL)
				|| (BZ2fp_r != NULL && (BZ2fp_r = bzopen(fn_r,"rb"))==NULL)){
				printf("can't bz2openstream\n");
				exit(1);
			}
			while((len=bzread(BZ2fp_r,buff,0x1000))>0){
				fwrite(buff,1,len,fp_w);
			}
			bzclose(BZ2fp_r);
			if(fp_w != stdout) fclose(fp_w);
		}else{
			BZFILE *BZ2fp_w;
			FILE *fp_r;

			if(fn_r){
				if((fp_r = fopen(fn_r,"rb"))==NULL){
					printf("can't open [%s]\n",fn_r);
					perror("reason:");
					exit(1);
				}
			}else{
				fp_r = stdin;
			}
			mode[0]='w';
			mode[1] = '0' + level;
			mode[2] = '\0';

			if((fn_w == NULL && (BZ2fp_w = bzdopen(fileno(stdout),mode))==NULL)
				|| (fn_w !=NULL && (BZ2fp_w = bzopen(fn_w,mode))==NULL)){
				printf("can't bz2openstream\n");
				exit(1);
			}
			while((len=fread(buff,1,0x1000,fp_r))>0){
				bzwrite(BZ2fp_w,buff,len);
			}
			bzclose(BZ2fp_w);
			if(fp_r!=stdin)fclose(fp_r);
		}
	}
#ifdef _WIN32
	BZ2DLLFreeLibrary();
#endif
}
