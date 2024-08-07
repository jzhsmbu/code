#include "mpi.h"
#include "pt4.h"
#include <vector>

//using namespace std;
void Solve()
{
    Task("MPI6File1");
    int flag;
    MPI_Initialized(&flag);
    if (flag == 0)
        return;
    int rank, size;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	
	
	char name[12];
	if(rank == 0)
		pt >> name;
	MPI_Bcast(name, 12, MPI_CHAR, 0, MPI_COMM_WORLD);

	//////
	MPI_File f;
	MPI_File_open(MPI_COMM_WORLD, name, MPI_MODE_RDONLY, MPI_INFO_NULL, &f);
	/////
	
	int x;
	if(rank != 0)
	{
		int limit;
		pt >> limit;
		std::vector<int> num;
		for(int i = 0; i < limit; i++)
		{
			pt >> x;
			num.push_back(x);
		}	
		MPI_Status s;
		for(int i = 0; i < num.size(); i++)
		{
			////
			MPI_Offset offset = (num[i]-1)*sizeof(int);
			MPI_File_read_at(f, offset, &x, 1, MPI_INT, &s);
			int n;
			MPI_Get_count(&s,MPI_INT, &n);
			if(n != 0)
				pt << x;
		}
	}
	MPI_File_close(&f);
}
