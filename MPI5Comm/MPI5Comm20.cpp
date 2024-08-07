#include "pt4.h"
#include "mpi.h"

void Solve()
{
    Task("MPI5Comm20");
    int flag;
    MPI_Initialized(&flag);
    if (flag == 0)
        return;
    int rank, size;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm cart_comm, cart_comm1;
    int dims[3] = { 2,2,size / 4 };
    int periods[] = { 0,0,0 };
    MPI_Cart_create(MPI_COMM_WORLD, 3, dims, periods, 0, &cart_comm);
    int coords[3];
    MPI_Cart_coords(cart_comm, rank, 3, coords);
    Show(coords[0]);
    Show(coords[1]);
    Show(coords[2]);
    MPI_Comm_split(cart_comm, coords[2], rank, &cart_comm1);
    MPI_Comm_size(cart_comm1, &size);
    MPI_Comm_rank(cart_comm1, &rank);
    Show(size);
    Show(rank);
    int a;
    pt >> a;
    int* b = new int[size];
    MPI_Gather(&a, 1, MPI_INT, b, 1, MPI_INT, 0, cart_comm1);
    if (rank == 0)
        for (int i = 0; i < size; i++)
            pt << b[i];
}
