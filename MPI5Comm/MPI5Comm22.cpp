#include "mpi.h"
#include "pt4.h"

void Solve()
{
    Task("MPI5Comm22");
    int flag;
    MPI_Initialized(&flag);
    if (flag == 0) //
        return;
    int rank, size;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	
	MPI_Comm comm;
	int dims[] = { 2,2,size / 4 }, periods[] = { 0,0,0 };
	MPI_Cart_create(MPI_COMM_WORLD, 3, dims, periods, 0, &comm);
	
	MPI_Comm comm_sub;
	int remain_dims[] = { 1,1,0 };
	MPI_Cart_sub(comm, remain_dims, &comm_sub);
	MPI_Comm_size(comm_sub, &size); 
	MPI_Comm_rank(comm_sub, &rank);
	double sbuf,rbuf;
	pt >> sbuf;
	MPI_Allreduce(&sbuf, &rbuf, 1, MPI_DOUBLE, MPI_SUM, comm_sub);
	pt << rbuf;
}
