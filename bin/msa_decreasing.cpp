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
bool increase=false;

//Check if a file exist
inline bool exist (const std::string& name)
{
	struct stat buffer;
	return (stat (name.c_str(), &buffer) == 0);
}
void cleanDirectory()
{
	std::system (("mv "+seqName+"_"+to_string(finalBucket)+".aln" "+outDir).c_str());

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

		if((count==1)||(::increase))	//we hit the OK in the fierst round
		{
			x++;
			::increase=true;
			check_tc(seqFile,x);
		}else
		{
			finalBucket = x;
			return true;
		}
	}else
	{
		cout<<"The file NOT EXIST and we FINISH"<<endl;
		//if(((::max-x)<=1)&& ::count>1 )
		if(x<=2)
		{
            finalBucket = x;
		    return true;
		}else if (!::increase)
		{
			//::max = x;
			//x = (::min+x)/2;
			x=x-1;
  			cout<<"NOT EXIST the numbers are NOT the same , new buckerSize value: "<<x<<endl;
			check_tc(seqFile,x);
		}
		else if (::increase)
		{
			finalBucket = x-1;
            return true;
		}
	}
}
int main(int argc, char *argv[]){

	string seqFile = argv[1];
	//string outDir = argv[2];
	int bucketSize = stoi(argv[2]);
	string out_File="";
	::max=bucketSize;

    check_tc(seqFile,bucketSize);

    cout << "DONE "<<finalBucket<< endl;
    cleanDirectory();
    return finalBucket;
    //return 0;
	}
