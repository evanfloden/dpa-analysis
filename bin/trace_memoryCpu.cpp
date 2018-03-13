#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iterator>
#include <sstream>
#include <algorithm>
#include <iomanip>
using namespace std;


    vector<string> tree_methods= {/*"NA",*/"CLUSTALO","MAFFT","MAFFT_PT","NJ","CLUSTALO_RND_LEAVES","MAFFT_RND"};	//MAFFT_RND -> need to check
    vector<string> align_methods= {"CLUSTALO","MAFFT","MAFFT_GINSI","UPP","PROBCONS","MSAPROBS","TCOFFEE"};  	//mafft_sparsecore -> need the CODE
    																											// MSA_DYNAMIC -> need to include
	vector< double > guide_tree_memory;
	vector< double > guide_tree_cpu;

	vector< std::vector<double> > df_memory_matrix;
	vector< std::vector<double> > df_cpu_matrix;

	vector< std::vector<double> > std_memory_matrix;
	vector< std::vector<double> > std_cpu_matrix;

//--DPA matrix
	//    vector<int> bucket_size={50,100,200,500,1000,2000,5000};
	vector< std::vector<double> > _50memory_matrix;
	vector< std::vector<double> > _50cpu_matrix;

	vector< std::vector<double> > _100memory_matrix;
	vector< std::vector<double> > _100cpu_matrix;

	vector< std::vector<double> > _200memory_matrix;
	vector< std::vector<double> > _200cpu_matrix;

	vector< std::vector<double> > _500memory_matrix;
	vector< std::vector<double> > _500cpu_matrix;

	vector< std::vector<double> > _1000memory_matrix;
	vector< std::vector<double> > _1000cpu_matrix;

	vector< std::vector<double> > _2000memory_matrix;
	vector< std::vector<double> > _2000cpu_matrix;

	vector< std::vector<double> > _5000memory_matrix;
	vector< std::vector<double> > _5000cpu_matrix;

//---
	double combine_mem=0;
	double combine_cpu=0;

	//double guide_mem=0;
	//double guide_cpu=0;

	double eval_mem=0;
	double eval_cpu=0;

	// check the the output of: print_header
	int procces_name_pos=3;
	int realtime_pos=8;
	int vmem_pos=11;

void split(const std::string &s, char delim, vector<string> &elems) {
    stringstream ss;
    ss.str(s);
    string item;
    while (getline(ss, item, delim)) {
        elems.push_back(item);
    }
}
void print_elements(vector<string> line){
	int i=0;
	for (auto element: line)	//parse all the lines into vectors
	{
	  	cout<<"pos: "<<i<<" - "<<element<<endl;
	  	i++;
	}
	cout<<endl;
}
void print_header(string line){
	vector<string> row_values;

	split(line, '\t', row_values);

	int i=0;
	for (auto element: row_values)	//parse all the lines into vectors
	{
	  	cout<<i<<" - "<<element<<"\t";
	  	i++;
	}
	cout<<endl;
}
void print_usedFields(string line){
	vector<string> row_values;

	split(line, '\t', row_values);
	cout<<"\n\nWe are using: \'"<<row_values[realtime_pos]<<"\' to calc the CPU usage and: \'"<<row_values[vmem_pos]<<"\' to calc the Memory footprint\n\n";
}
void expandMatrix(vector< std::vector<double> > &matrix){
	//expand ther matrix
    //https://stackoverflow.com/questions/1403150/how-do-you-dynamically-allocate-a-matrix
    int m = tree_methods.size();
    int n = align_methods.size();
    //Grow rows by m
    matrix.resize(m);
    for(int i = 0 ; i < m ; ++i)
    {
        //Grow Columns by n
        matrix[i].resize(n);
    } 
}
void printMatrix(vector< std::vector<double> > matrix){
	int i=0;
	for (auto tree: tree_methods)	//parse all the lines into vectors
	{
	  	cout<<tree<<"\t";
	  	i++;
	}
	cout<<endl;
	//-------------
	int t=0;
	for (auto align: align_methods)	//parse all the lines into vectors
	{
		cout<<align<<"\t";
		int j=0;
		for (auto tree: tree_methods)	//parse all the lines into vectors
		{
			if((t==1&&j==0)||(t==3&&j==0)||(t==6&&j==0)/*||(j==2)||(j==4)*/){cout<<"\t";} //format the matrix
		  	cout<<matrix[j][t]<<"\t";
		  	j++;
		}
		cout<<endl;
	  	t++;
	}
	cout<<endl;	
}
void printVector(vector< double> matrix){
	int i=0;
	for (auto tree: tree_methods)	//parse all the lines into vectors
	{
	  	cout<<tree<<"\t";
	  	i++;
	}
	cout<<endl;
	//-------------
	int t=0;
	for (auto element: matrix)	//parse all the lines into vectors
	{
	  	cout<<element<<"\t";
	  	i++;
	}
	cout<<endl;	
}
string removeExt(string s, string ext){
	if ( s != ext &&
	     s.size() > ext.size() &&
	     s.substr(s.size() - ext.size()) == ext )
	{
	   // if so then strip them off
	   s = s.substr(0, s.size() - ext.size());
	   return s;
	}
}
int getIndex(vector<string> myvec, string element){
	int pos = std::find(myvec.begin(), myvec.end(), element) - myvec.begin();
	return pos;
}
void proc_combine_seqs(vector<string> line){

	//string auxMem = removeExt(line[vmem_pos],"ms");
	//string auxCpu = removeExt(line[realtime_pos],"MB");

	combine_mem+=stod(line[vmem_pos]);
	combine_cpu+=stod(line[realtime_pos]);

	//print_elements(line);	 
}
void removeParentesis(string &word){
	int i = 0;
	while (i < word.size()) {
		if(word[i] == '(' || word[i] == ')')
		{
		    word.erase(i,1);
		} else {
		    i++;
		}
	}
}
void proc_guide_trees(vector<string> line){
	vector<string> aux;
	string strAux;
	string treeMethod;

	split(line[3],' ',aux);
	strAux=aux[1];
	aux={};
	split(strAux,'.',aux);
	//print_elements(aux);

	treeMethod=aux[1];
	removeParentesis(treeMethod);

	int index =getIndex(::tree_methods, treeMethod);

	guide_tree_memory[index]+=stod(line[vmem_pos]);
	guide_tree_cpu[index]+=stod(line[realtime_pos]);
}
void proc_dpa_alignment(vector<string> line){	
	vector<string> aux;
	string strAux;
	string alignMethod;
	string treeMethod;

	split(line[3],' ',aux);
	strAux=aux[1];
	aux={};
	split(strAux,'.',aux);

	alignMethod=aux[1];
	int bucket_size=stoi(aux[3]);
	treeMethod=aux[4];
	removeParentesis(treeMethod);

	//cout<<"dpa>>\talign: "<<alignMethod<<"\ttree: "<<treeMethod<<"\tbucket: "<<bucket_size<<endl;
	int row =getIndex(tree_methods, treeMethod); 
	int column =getIndex(align_methods,alignMethod);

	switch(bucket_size) { //{50,100,200,500,1000,2000,5000};
	    case 50 : {
	    	_50memory_matrix[row][column]= stod(line[vmem_pos]);
			_50cpu_matrix[row][column]+=stod(line[realtime_pos]);
			break; }
	    case 100 : {
	    	_100memory_matrix[row][column]= stod(line[vmem_pos]);
			_100cpu_matrix[row][column]+=stod(line[realtime_pos]);
			break; }			
	    case 200 :{
	    	_200memory_matrix[row][column]= stod(line[vmem_pos]);
			_200cpu_matrix[row][column]+=stod(line[realtime_pos]);
			break; }
	    case 500 : {
	    	_500memory_matrix[row][column]= stod(line[vmem_pos]);
			_500cpu_matrix[row][column]+=stod(line[realtime_pos]);
			break; }
	    case 1000 :{
	    	_1000memory_matrix[row][column]= stod(line[vmem_pos]);
			_1000cpu_matrix[row][column]+=stod(line[realtime_pos]);
			break; }
	    case 2000 :{
	    	_2000memory_matrix[row][column]= stod(line[vmem_pos]);
			_2000cpu_matrix[row][column]+=stod(line[realtime_pos]);
			break; }
	    case 5000 :{
	    	_5000memory_matrix[row][column]= stod(line[vmem_pos]);
			_5000cpu_matrix[row][column]+=stod(line[realtime_pos]);
			break; } 
	}
}
void proc_default_alignment(vector<string> line){
	vector<string> aux;
	string strAux;
	string alignMethod;
	string treeMethod = "NA";	// NA or the same as alignMethod ?
								//			treeMethod=aux[4];
	split(line[3],' ',aux);
	strAux=aux[1];
	aux={};
	split(strAux,'.',aux);

	alignMethod=aux[1];
	treeMethod=aux[4];
	removeParentesis(treeMethod);

	int row =getIndex(tree_methods, treeMethod); 
	int column =getIndex(align_methods,alignMethod);

	df_memory_matrix[row][column]= stod(line[vmem_pos]);
	df_cpu_matrix[row][column]+=stod(line[realtime_pos]);

	//cout<<"default>>\talign: "<<alignMethod<<"\ttree: "<<treeMethod<<endl;
}
void proc_std_alignment(vector<string> line){
	vector<string> aux;
	string strAux;
	string alignMethod;
	string treeMethod;	

	split(line[3],' ',aux);
	strAux=aux[1];
	aux={};
	split(strAux,'.',aux);

	alignMethod=aux[1];
	treeMethod=aux[4];
	removeParentesis(treeMethod);

	int row =getIndex(tree_methods, treeMethod);
	int column =getIndex(align_methods,alignMethod);

	std_memory_matrix[row][column]= stod(line[vmem_pos]);
	std_cpu_matrix[row][column]+=stod(line[realtime_pos]);

	//cout<<"std>>\talign: "<<alignMethod<<"\ttree: "<<treeMethod<<endl;
}
void proc_evaluate(vector<string> line){
	if(line[vmem_pos].compare("-")!=0){
		eval_mem+=stod(line[vmem_pos]);
	}
	if(line[realtime_pos].compare("-")!=0){
		eval_cpu+=stod(line[realtime_pos]);
	}
}
void correctTree(){
//CO_guidetree_real = CO_default - CO_standard
	int row =getIndex(tree_methods, "CLUSTALO");
	int column =getIndex(align_methods,"CLUSTALO");

	double CO_guidetree_memory = df_memory_matrix[row][column] - std_memory_matrix[row][column];
	double CO_guidetree_cpu = df_cpu_matrix[row][column] - std_cpu_matrix[row][column];

	guide_tree_memory[row]=CO_guidetree_memory;
	guide_tree_cpu[row]=CO_guidetree_cpu;
}
int main (int argc, char* argv[])
{
	string fileName=argv[1];
    char tab_delim ='\t';
    char space_delim =' ';
	
    guide_tree_memory.resize(tree_methods.size());
    guide_tree_cpu.resize(tree_methods.size());
    for(int i = 0 ; i < tree_methods.size() ; ++i)
    {
        guide_tree_memory[i]=0;
        guide_tree_cpu[i]=0;
    }

	expandMatrix(df_memory_matrix);
	expandMatrix(df_cpu_matrix);

	expandMatrix(std_memory_matrix);
	expandMatrix(std_cpu_matrix);

	//{50,100,200,500,1000,2000,5000};
	expandMatrix(_50memory_matrix);
	expandMatrix(_50cpu_matrix);
	expandMatrix(_100memory_matrix);
	expandMatrix(_100cpu_matrix);
	expandMatrix(_200memory_matrix);
	expandMatrix(_200cpu_matrix);
	expandMatrix(_500memory_matrix);
	expandMatrix(_500cpu_matrix);
	expandMatrix(_1000memory_matrix);
	expandMatrix(_1000cpu_matrix);
	expandMatrix(_2000memory_matrix);
	expandMatrix(_2000cpu_matrix);
	expandMatrix(_5000memory_matrix);
	expandMatrix(_5000cpu_matrix);


	// grep file to remove the FAILED
	system(("cat "+fileName+"| grep \"CACHED\\|COMPLETED\" > clean_trace.txt").c_str());
	//*******************************

    string line, lineAux;
	ifstream inFile,inFileAux;

	inFileAux.open(fileName);
	inFile.open("clean_trace.txt");

	//get header INFO
	std::getline(inFileAux, lineAux);
	print_usedFields(lineAux);

	while (std::getline(inFile, line))
    {
        vector<string> row_values;
        vector<string> line_values;

        split(line, tab_delim, row_values);

        int i=0;	//position of the field on the line
        for (auto vector: row_values)	//parse all the lines into vectors
        {
        	//cout<<"i value: "<<i<<"\t vector: "<<vector<<endl;

        	if (i==procces_name_pos){
        		split(vector, space_delim, line_values);	//parse the line depending on the process_name
				
        		if(line_values[0]=="combine_seqs"){proc_combine_seqs(row_values);}
        		else if(line_values[0]=="guide_trees"){proc_guide_trees(row_values);}
        		else if(line_values[0]=="dpa_alignment"){proc_dpa_alignment(row_values);}
        		else if(line_values[0]=="default_alignment"){proc_default_alignment(row_values);}
        		else if(line_values[0]=="std_alignment"){proc_std_alignment(row_values);}
        		else if(line_values[0]=="evaluate"){proc_evaluate(row_values);}
        	}
        	i++;
        }
    }     
	inFile.close();
	inFileAux.close();

	//remove auxiliar trace file
	system("rm clean_trace.txt");

	//adjust CO tree generation values
	correctTree();

	//format decimals to print --> avoid cinetific + 3 decimals
	cout << fixed;
	cout << setprecision(3);

	cout<<"::COMBINE SEQS::\tMemory:\t"<<combine_mem<<"\t\tCPU Usage:\t"<<combine_cpu<<endl;
	cout<<"\n::GUIDE TREE::\n\tMemory:\t\n";
		printVector(guide_tree_memory);
		cout<<"\tCPU Usage:\n";
		printVector(guide_tree_cpu);
	cout<<"\n::EVALUATE::\n\tMemory:\t"<<eval_mem<<"\t\tCPU Usage:\t"<<eval_cpu<<endl;

	//DEFAULT
	cout<<"\n::DEFAULT MEMORY MATRIX::\n\t\t";
	printMatrix(df_memory_matrix);	
	cout<<"\n::DEFAULT CPU MATRIX::\n\t\t";
	printMatrix(df_cpu_matrix);

	//STD
	cout<<"\n::STANDARD MEMORY MATRIX::\n\t\t";
	printMatrix(std_memory_matrix);	
	cout<<"\n::STANDARD CPU MATRIX::\n\t\t";
	printMatrix(std_cpu_matrix);

	//DPA 50,100,200,500,1000,2000,5000}
	cout<<"\n::DPA 50 MEMORY MATRIX::\n\t\t";
	printMatrix(_50memory_matrix);	
	cout<<"\n::DPA 50 CPU MATRIX::\n\t\t";
	printMatrix(_50cpu_matrix);

	cout<<"\n::DPA 100 MEMORY MATRIX::\n\t\t";
	printMatrix(_100memory_matrix);	
	cout<<"\n::DPA 100 CPU MATRIX::\n\t\t";
	printMatrix(_100cpu_matrix);

	cout<<"\n::DPA 200 MEMORY MATRIX::\n\t\t";
	printMatrix(_200memory_matrix);	
	cout<<"\n::DPA 200 CPU MATRIX::\n\t\t";
	printMatrix(_200cpu_matrix);

	cout<<"\n::DPA 500 MEMORY MATRIX::\n\t\t";
	printMatrix(_500memory_matrix);	
	cout<<"\n::DPA 500 CPU MATRIX::\n\t\t";
	printMatrix(_500cpu_matrix);

	cout<<"\n::DPA 1000 MEMORY MATRIX::\n\t\t";
	printMatrix(_1000memory_matrix);	
	cout<<"\n::DPA 1000 CPU MATRIX::\n\t\t";
	printMatrix(_1000cpu_matrix);

	cout<<"\n::DPA 2000 MEMORY MATRIX::\n\t\t";
	printMatrix(_2000memory_matrix);	
	cout<<"\n::DPA 2000 CPU MATRIX::\n\t\t";
	printMatrix(_2000cpu_matrix);

	cout<<"\n::DPA 5000 MEMORY MATRIX::\n\t\t";
	printMatrix(_5000memory_matrix);	
	cout<<"\n::DPA 5000 CPU MATRIX::\n\t\t";
	printMatrix(_5000cpu_matrix);

	return 0;
}
