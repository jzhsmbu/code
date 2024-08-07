#include "pt4.h"
#include "mpi.h"

void Solve()
{
    Task("MPI7Win4");
    int flag;
    MPI_Initialized(&flag);
    if (flag == 0)
        return;
    int rank, size;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    double* A = new double[size + 3];
    if (rank == 0)
    {
        for (int i = 0; i < size + 3; i++) pt >> A[i];
    }
    MPI_Win win;
    MPI_Win_create(A, (size + 3) * 8, 8, MPI_INFO_NULL, MPI_COMM_WORLD, &win);
    MPI_Win_fence(0, win);
    double get[5];
    if (rank != 0) {
        MPI_Get(get, 5, MPI_DOUBLE, 0, rank - 1, 5, MPI_DOUBLE, win);
    }
    MPI_Win_fence(0, win);
    if (rank != 0)
    {
        for (int i = 0; i < 5; i++)pt << get[i];
    }
}
