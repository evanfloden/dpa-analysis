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
inline bool exist (const std::string& name)
{
	struct stat buffer;
	return (stat (name.c_str(), &buffer) == 0);
}
void cleanDirectory(string outFile, string outDir)
{
	std::system (("mv "+outFile+" "+outDir).c_str());
}

bool run_tc_msa(string seqFile, int bucketSize)
{
	//Extract the seqName from the fileName
	string ext = ".fa";
    string seqName = seqFile.substr(0, seqFile.size() - ext.size());

	//define the default output name for TCcd ..
	string out_File="out.aln";

	cout<<"RUN TC with bucket size: "<<bucketSize<<endl;

    std::system(("t_coffee -dpa -dpa_method msa_msa -seq "+seqFile+" -dpa_nseq "+to_string(bucketSize)+" -dpa_tree codnd -outfile "+out_File+" -n_core=1").c_str());
	// -outfile "+out_File+" -n_core=1 > /dev/null 2>&1").c_str());

	::count++;

	//TODO Another option is to capture the exit status
	//if the outfile is diff we will think it is a ERROR
	if(exist(out_File)){
		cout<<"TC FINISHED with size "<<bucketSize<<endl;
		std::system(("mv out.aln "+seqName+"_"+to_string(bucketSize)+".aln").c_str());
		return true;
	}else{
		cout<<"TC NOT finished with size "<<bucketSize<<endl;
		return false;
	}
}

bool check_tc(string seqFile, int x)
{
	//string out_File=run_tc_msa(seqFile,x);
	if (run_tc_msa(seqFile,x))
	{
		cout<<"The file EXIST"<<endl;
		//cout<<"X value (bucketACT): "<<x<<" N value (bucketINI): "<<n<<endl;
		if((::max-x)<=1)	//will never skip the == bc it will start from == and go downI
		{
			finalBucket = x;
			//			cout<<"The final bucket size is: "<<finalBucket<<" after "<<count<<" iterations\n max-x <=1 \tMAX: "<<::max<<endl;
			cout<<"The numbers are the same "<<x<<endl;
			//std::system(("cd results | ls | grep -v "+out_File+" | xargs rm").c_str());
			return true;
		}else
		{
			finalBucket=x;
			::min=x;
			x=(::max+x)/2;
			cout<<"EXIST the numbers are NOT the same , new X value: "<<x<<" min value: "<<::min<<" finalBucket: "<<finalBucket<<endl;
			check_tc(seqFile,x);
		}
	}else
	{
		cout<<"The file NOT EXIST"<<endl;
		if(((::max-x)<=1)&& ::count>1 )
		{
			//cout<<"NOT EXIST but same +/-1 X value: "<<x<<" - MAX "<<::max<<" - N: "<<n<<endl;
			cout<<"The final bucket size is: "<<finalBucket<<" after "<<count<<" iterations"<<endl;
			//std::system(("cd results | ls | grep -v "+out_File+" | xargs rm").c_str());
			return true;
		}else
		{
			::max = x;
			x = (::min+x)/2;
  			cout<<"NOT EXIST the numbers are NOT the same , new X value: "<<x<<" min value: "<<::min<<" finalBucket: "<<finalBucket<<endl;
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

	int pid_value= getpid();

	std::system(("pkill -P "+to_string(pid_value)).c_str());
	std::system(("pkill  msa"));
    //return finalBucket;
    return 0;
	}
