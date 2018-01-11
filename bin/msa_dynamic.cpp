#include <cstdlib>
#include <iostream>
#include <string>
#include <fstream>
#include <sys/stat.h>
#include <unistd.h>
using namespace std;

int count(0);
int max;
int min(0);
int finalBucket;
//Check if a file exist
inline bool exist (const std::string& name) {
	struct stat buffer;
	return (stat (name.c_str(), &buffer) == 0);
}
void cleanDirectory(string outFile, string outDir){
//ls | grep -v file.txt | xargs rm
	std::system (("mv "+outFile+" "+outDir).c_str());
	//std::system(("cd results | ls | grep -v "+outFile+" | xargs rm out_*").c_str());
}
string run_tc_msa(string seqFile, int bucketSize){
//string out_File="out_"+seqFile+"_"+to_string(bucketSize);
string out_File="out.aln";
cout<<"RUN TC with bucket size: "<<bucketSize<<endl;

        std::system(("t_coffee -dpa -dpa_method msa_msa \
        -seq "+seqFile+" -dpa_nseq "+to_string(bucketSize)+"  \
        -outfile "+out_File+" -n_core=1").c_str());
//        -outfile "+out_File+" -n_core=1 > /dev/null 2>&1").c_str());

	::count++;	
	return out_File;
}

bool check_tc(string seqFile, int x){
	string out_File=run_tc_msa(seqFile,x);
	if (exist(out_File)){
		//cout<<"The file EXIST"<<endl;
		//cout<<"X value (bucketACT): "<<x<<" N value (bucketINI): "<<n<<endl;
		if((::max-x)<=1){ //will never skip the == bc it will start from == and go downI
			finalBucket = x;
//			cout<<"The final bucket size is: "<<finalBucket<<" after "<<count<<" iterations\n max-x <=1 \tMAX: "<<::max<<endl;
			//cout<<"The numbers are the same "<<x<<endl;
//std::system(("cd results | ls | grep -v "+out_File+" | xargs rm").c_str());
			return true;
		}else{
			finalBucket=x;
			::min=x;
			x=(::max+x)/2;
			//cout<<"EXIST the numbers are NOT the same , new X value: "<<x<<endl;
			check_tc(seqFile,x);
		}
	}else{
//		cout<<"The file NOT EXIST"<<endl;
		if(((::max-x)<=1)&& ::count>1 ){
			//cout<<"NOT EXIST but same +/-1 X value: "<<x<<" - MAX "<<::max<<" - N: "<<n<<endl;
			cout<<"The final bucket size is: "<<finalBucket<<" after "<<count<<" iterations"<<
endl;
//std::system(("cd results | ls | grep -v "+out_File+" | xargs rm").c_str());
			return true;
		}else{
			::max = x;
			x = (::min+x)/2;
  //                      cout<<"NOT EXIST the numbers are NOT the same , new X value: "<<x<<" - MAX "<<::max<<" - N: "<<n<<endl;
			check_tc(seqFile,x);
		}
	}
	
}
int main(int argc, char *argv[]){

	string seqFile = argv[1];
	//string outDir = argv[2];
	int bucketSize = stoi(argv[2]);
	string out_File="";
	::max=bucketSize;
	bool tc_finish=false;
	
	//while(!tc_finish){
//		cout<<">>-- RUN WHILE CHECK_TC(x (bucketACT,bucketINI) "<< x <<" "<< n <<endl;
		tc_finish = check_tc(seqFile,bucketSize);		
//out_File="out_"+seqFile+"_"+to_string(finalBucket);
//cout<< "test: "<<out_File<<endl;
//		cleanDirectory(out_File, outDir);
	//}
	/*out_File=run_tc_msa(seqFile, bucketSize);

	if (exist(out_File)){
		cout << "File EXIST" << endl;
	        if(bucketSize==max){ //they are equals
	        	cout << "Both values are EQUAL : BS & max" <<endl;
	        }else{  //need to reduce lower boundary
	        	if ((bucketSize-max)<=1 || ((max-bucketSize)<=1)){
	                	cout << "diff btwn values BS & MAX lower than 1" <<endl;
	                }else{
	                        min = (max+min)/2;
	                        out_File=run_tc_msa(seqFile,min);
	                }
	        }

        }else{
	        cout << "File DOES NOT EXIT" << endl;
		max=(max+min)/2;
		out_File=run_tc_msa(seqFile,max);
	}*/
        cout << "DONE "<<finalBucket<< endl;

        return finalBucket;
	}
