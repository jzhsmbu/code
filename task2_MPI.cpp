#include <iostream>
#include <vector>
#include <cmath>
#include <chrono>
#include <omp.h>
#include <mpi.h>
#include <stdexcept>
#include <iomanip>
#include <fstream>
#include <sstream> 

using namespace std;

const double M = 80;
const double N = 80;
const double xmin = -1.05, xmax = 1.05; //设置网格横坐标边界(Setting the Grid Horizontal Coordinate Boundary)
const double ymin = -0.55, ymax = 0.55; //设置网格纵坐标边界(Setting the grid vertical coordinate boundary)
const double h_1 = (xmax - xmin) / M;  //设置横坐标步长(Setting the horizontal coordinate step)
const double h_2 = (ymax - ymin) / N;  //设置纵坐标步长(Setting the vertical coordinate step)
const double accurate = 1e-6;
const double eps = 0.01;

int nx = static_cast<int>((xmax - xmin) / h_1) + 1;
int ny = static_cast<int>((ymax - ymin) / h_2) + 1;

// 全局定义的矩阵
vector<double> u(nx* ny, 0.0);
vector<double> w(nx* ny, 0.0);
vector<double> A(nx* ny, 0.0);
vector<double> B(nx* ny, 0.0);
vector<double> F(nx* ny, 0.0);

bool isInEllipse(double x, double y) {
    return (x * x + 4 * y * y < 1);
}

double l_x(double x, double y) {
    bool leftInEllipse = isInEllipse(x - 0.5 * h_1, y - 0.5 * h_2);
    bool rightInEllipse = isInEllipse(x + 0.5 * h_1, y - 0.5 * h_2);

    if (leftInEllipse && rightInEllipse) {
        return h_1;
    }
    if (!leftInEllipse && !rightInEllipse) {
        return 0;
    }
    if (leftInEllipse && !rightInEllipse) {
        return abs(sqrt(1 - 4 * (y - 0.5 * h_2) * (y - 0.5 * h_2)) - (x - 0.5 * h_1));
    }
    if (!leftInEllipse && rightInEllipse) {
        return abs(-sqrt(1 - 4 * (y - 0.5 * h_2) * (y - 0.5 * h_2)) - (x + 0.5 * h_1));
    }
}

double l_y(double x, double y) {
    bool topInEllipse = isInEllipse(x - 0.5 * h_1, y + 0.5 * h_2);
    bool bottomInEllipse = isInEllipse(x - 0.5 * h_1, y - 0.5 * h_2);

    if (topInEllipse && bottomInEllipse) {
        return h_2;
    }
    if (!topInEllipse && !bottomInEllipse) {
        return 0;
    }
    if (topInEllipse && !bottomInEllipse) {
        return abs(-sqrt((1 - (x - 0.5 * h_1) * (x - 0.5 * h_1)) / 4) - (y + 0.5 * h_2));
    }
    if (!topInEllipse && bottomInEllipse) {
        return abs(sqrt((1 - (x - 0.5 * h_1) * (x - 0.5 * h_1)) / 4) - (y - 0.5 * h_2));
    }
}

void createCartesianGrid(int size, MPI_Comm& cart_comm, int& local_nx, int& local_ny, int& x_offset, int& y_offset) {
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // 自动计算笛卡尔网格的划分方向
    int dims[2] = { 0, 0 };
    MPI_Dims_create(size, 2, dims); // dims[0]: x方向划分的进程数, dims[1]: y方向划分的进程数

    // 检查点数比例是否符合 [1/2, 2]
    double x_per_y_ratio = static_cast<double>(nx / dims[0]) / (ny / dims[1]);
    if (x_per_y_ratio < 0.5 || x_per_y_ratio > 2.0) {
        if (rank == 0) {
            std::cerr << "Error: Domain aspect ratio constraint not met." << std::endl;
        }
        MPI_Abort(MPI_COMM_WORLD, 1); // 强制结束程序
    }

    // 创建笛卡尔拓扑
    int periods[2] = { 0, 0 }; // 非周期边界
    MPI_Cart_create(MPI_COMM_WORLD, 2, dims, periods, 0, &cart_comm);

    // 确定当前进程的坐标
    int coords[2];
    MPI_Cart_coords(cart_comm, rank, 2, coords);

    // 每个子域的点数
    local_nx = nx / dims[0] + (coords[0] < nx % dims[0] ? 1 : 0); // 考虑余数
    local_ny = ny / dims[1] + (coords[1] < ny % dims[1] ? 1 : 0);
    x_offset = coords[0] * (nx / dims[0]) + std::min(coords[0], nx % dims[0]); // 起始点偏移量
    y_offset = coords[1] * (ny / dims[1]) + std::min(coords[1], ny % dims[1]);

    // 输出网格划分信息（调试用）
    if (rank == 0) {
        std::cout << "Cartesian grid: " << dims[0] << " x " << dims[1] << std::endl;
        std::cout << "Aspect ratio for each domain: " << x_per_y_ratio << std::endl;
    }
}

void Jacobi_MPI(int& iteration_count) {
    int rank, process_count;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &process_count);

    // 计算每个进程处理的行数及其起始和结束行
    int rows_per_process = nx / process_count;
    int start_row = rank * rows_per_process;
    int end_row = (rank == process_count - 1) ? nx : (rank + 1) * rows_per_process;

    // 步长的倒数平方
    double hx2_inv = 1.0 / (h_1 * h_1);
    double hy2_inv = 1.0 / (h_2 * h_2);

    // 为每个进程创建独立文件，用于保存其负责的数据
    std::ostringstream filename;
    filename << "result_rank_" << rank << ".csv";
    std::ofstream outfile(filename.str().c_str());
    if (!outfile) {
        std::cerr << "Error: Cannot open file: " << filename.str() << std::endl;
        MPI_Finalize();
        return;
    }

    bool is_converged = false;
    while (!is_converged) {
        double local_error = 0.0;

        // 非阻塞边界通信
        MPI_Request send_requests[2], recv_requests[2];
        MPI_Status statuses[4];

        // 上边界交换
        if (rank > 0) {
            MPI_Isend(&u[start_row * ny], ny, MPI_DOUBLE, rank - 1, 0, MPI_COMM_WORLD, &send_requests[0]);
            MPI_Irecv(&u[(start_row - 1) * ny], ny, MPI_DOUBLE, rank - 1, 0, MPI_COMM_WORLD, &recv_requests[0]);
        }
        // 下边界交换
        if (rank < process_count - 1) {
            MPI_Isend(&u[(end_row - 1) * ny], ny, MPI_DOUBLE, rank + 1, 0, MPI_COMM_WORLD, &send_requests[1]);
            MPI_Irecv(&u[end_row * ny], ny, MPI_DOUBLE, rank + 1, 0, MPI_COMM_WORLD, &recv_requests[1]);
        }

        // 忽略边界行的核心计算
        for (int i = std::max(1, start_row + 1); i < std::min(nx - 1, end_row - 1); ++i) {
            for (int j = 1; j < ny - 1; ++j) {
                double Ai_next = A[(i + 1) * ny + j] * hx2_inv;
                double Ai = A[i * ny + j] * hx2_inv;
                double Bj_next = B[i * ny + j + 1] * hy2_inv;
                double Bj = B[i * ny + j] * hy2_inv;

                double u_old = u[i * ny + j];
                w[i * ny + j] = (u[(i + 1) * ny + j] * Ai_next +
                    u[(i - 1) * ny + j] * Ai +
                    u[i * ny + j + 1] * Bj_next +
                    u[i * ny + j - 1] * Bj +
                    F[i * ny + j]) /
                    (Ai_next + Ai + Bj_next + Bj);

                local_error += fabs(w[i * ny + j] - u_old);
            }
        }

        // 等待边界通信完成后，处理首行和末行
        if (rank > 0) MPI_Wait(&recv_requests[0], &statuses[0]);
        if (rank < process_count - 1) MPI_Wait(&recv_requests[1], &statuses[1]);

        if (rank > 0) {
            int i = start_row;
            for (int j = 1; j < ny - 1; ++j) {
                double Ai_next = A[(i + 1) * ny + j] * hx2_inv;
                double Ai = A[i * ny + j] * hx2_inv;
                double Bj_next = B[i * ny + j + 1] * hy2_inv;
                double Bj = B[i * ny + j] * hy2_inv;

                double u_old = u[i * ny + j];
                w[i * ny + j] = (u[(i + 1) * ny + j] * Ai_next +
                    u[(i - 1) * ny + j] * Ai +
                    u[i * ny + j + 1] * Bj_next +
                    u[i * ny + j - 1] * Bj +
                    F[i * ny + j]) /
                    (Ai_next + Ai + Bj_next + Bj);

                local_error += fabs(w[i * ny + j] - u_old);
            }
        }

        if (rank < process_count - 1) {
            int i = end_row - 1;
            for (int j = 1; j < ny - 1; ++j) {
                double Ai_next = A[(i + 1) * ny + j] * hx2_inv;
                double Ai = A[i * ny + j] * hx2_inv;
                double Bj_next = B[i * ny + j + 1] * hy2_inv;
                double Bj = B[i * ny + j] * hy2_inv;

                double u_old = u[i * ny + j];
                w[i * ny + j] = (u[(i + 1) * ny + j] * Ai_next +
                    u[(i - 1) * ny + j] * Ai +
                    u[i * ny + j + 1] * Bj_next +
                    u[i * ny + j - 1] * Bj +
                    F[i * ny + j]) /
                    (Ai_next + Ai + Bj_next + Bj);

                local_error += fabs(w[i * ny + j] - u_old);
            }
        }

        // 等待发送完成
        if (rank > 0) MPI_Wait(&send_requests[0], &statuses[2]);
        if (rank < process_count - 1) MPI_Wait(&send_requests[1], &statuses[3]);

        // 全局误差计算
        double global_error = 0.0;
        MPI_Allreduce(&local_error, &global_error, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);

        // 判断是否收敛
        is_converged = (sqrt(global_error) < accurate);

        // 更新 u 和 w
        swap(u, w);
        iteration_count++;
    }

    // 数据收集到主进程
    vector<double> global_u;
    if (rank == 0) {
        global_u.resize(nx * ny);
    }
    MPI_Gather(&u[start_row * ny], rows_per_process * ny, MPI_DOUBLE,
        global_u.data(), rows_per_process * ny, MPI_DOUBLE,
        0, MPI_COMM_WORLD);

    // 写入该进程负责的数据
    for (int i = start_row; i < end_row; ++i) {
        for (int j = 0; j < ny; ++j) {
            outfile << (isInEllipse(xmin + i * h_1, ymin + j * h_2) ? u[i * ny + j] : 0);
            if (j < ny - 1) outfile << ",";
        }
        outfile << "\n";
    }
    outfile.close();

    // 主进程输出最终结果
    if (rank == 0) {
        for (int i = 0; i < nx; ++i) {
            for (int j = 0; j < ny; ++j) {
                std::cout << (isInEllipse(xmin + i * h_1, ymin + j * h_2) ? global_u[i * ny + j] : 0) << " ";
            }
            std::cout << std::endl;
        }
    }
}

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);
    int rank, size;

    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // createCartesianGrid(size, cart_comm, local_nx, local_ny, x_offset, y_offset);
    std::cout << "Total MPI processes: " << size << ", Rank: " << rank << std::endl;

    for (int i = 0; i < nx; ++i) {
        for (int j = 1; j < ny; ++j) {
            A[i * ny + j] = l_y(xmin + i * h_1, ymin + j * h_2) / h_2 + (1 - l_y(xmin + i * h_1, ymin + j * h_2) / h_2) / eps;
            B[i * ny + j] = l_x(xmin + i * h_1, ymin + j * h_2) / h_1 + (1 - l_x(xmin + i * h_1, ymin + j * h_2) / h_1) / eps;

            // 定义每个顶点的坐标(Define the coordinates of each vertex)
            double x_left = xmin + i * h_1 - 0.5 * h_1;
            double x_right = xmin + i * h_1 + 0.5 * h_1;
            double y_top = ymin + j * h_2 + 0.5 * h_2;
            double y_bottom = ymin + j * h_2 - 0.5 * h_2;

            // 判断四个顶点是否在椭圆内(Determine if the four vertices are inside the ellipse)
            bool topLeftInEllipse = isInEllipse(x_left, y_top);
            bool bottomLeftInEllipse = isInEllipse(x_left, y_bottom);
            bool topRightInEllipse = isInEllipse(x_right, y_top);
            bool bottomRightInEllipse = isInEllipse(x_right, y_bottom);

            int inEllipseCount = topLeftInEllipse + bottomLeftInEllipse + topRightInEllipse + bottomRightInEllipse;

            if (inEllipseCount == 4) {
                F[i * ny + j] = 1.0;  // 100% 面积在椭圆内
            }
            else if (inEllipseCount == 0) {
                F[i * ny + j] = 0.0;  // 0% 面积在椭圆内
            }
            else if (inEllipseCount == 2) {
                //F[i * ny + j] = 0.5;  
                double rectWidth = x_right - x_left;
                double rectHeight = y_top - y_bottom;
                double ellipseHalfWidth = sqrt(1 - 4 * y_bottom * y_bottom);  // 椭圆在y=y_bottom处的x坐标范围
                double ellipseHalfHeight = sqrt((1 - x_left * x_left) / 4);    // 椭圆在x=x_left处的y坐标范围

                // 左边两个点在椭圆外
                if (!topLeftInEllipse && !bottomLeftInEllipse && topRightInEllipse && bottomRightInEllipse) {
                    double areaInEllipse = abs((x_right + ellipseHalfWidth) * rectHeight);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 右边两个点在椭圆外
                else if (topLeftInEllipse && bottomLeftInEllipse && !topRightInEllipse && !bottomRightInEllipse) {
                    double areaInEllipse = abs((ellipseHalfWidth - x_left) * rectHeight);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 上边两个点在椭圆外
                else if (!topLeftInEllipse && !topRightInEllipse && bottomLeftInEllipse && bottomRightInEllipse) {
                    double areaInEllipse = abs((ellipseHalfHeight - y_bottom) * rectWidth);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 下边两个点在椭圆外
                else if (topLeftInEllipse && topRightInEllipse && !bottomLeftInEllipse && !bottomRightInEllipse) {
                    double areaInEllipse = abs((y_top + ellipseHalfHeight) * rectWidth);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }

            }
            else if (inEllipseCount == 1) {
                //F[i * ny + j] = 0.25;  
                double rectWidth = x_right - x_left;
                double rectHeight = y_top - y_bottom;
                // 只有左上角的点在椭圆内
                if (topLeftInEllipse && !topRightInEllipse && !bottomLeftInEllipse && !bottomRightInEllipse) {
                    double x_intersect = sqrt(1 - 4 * y_top * y_top);     // 椭圆在 y = y_top 的 x 坐标范围
                    double y_intersect = -sqrt((1 - x_left * x_left) / 4); // 椭圆在 x = x_left 的 y 坐标范围
                    double areaInEllipse = abs((x_intersect - x_left) * (y_top - y_intersect) / 2);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 只有右上角的点在椭圆内
                else if (topRightInEllipse && !topLeftInEllipse && !bottomLeftInEllipse && !bottomRightInEllipse) {
                    double x_intersect = -sqrt(1 - 4 * y_top * y_top);
                    double y_intersect = -sqrt((1 - x_right * x_right) / 4);
                    double areaInEllipse = abs((x_right - x_intersect) * (y_top - y_intersect) / 2);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 只有左下角的点在椭圆内
                else if (bottomLeftInEllipse && !topLeftInEllipse && !topRightInEllipse && !bottomRightInEllipse) {
                    double x_intersect = sqrt(1 - 4 * y_bottom * y_bottom);
                    double y_intersect = sqrt((1 - x_left * x_left) / 4);
                    double areaInEllipse = abs((x_intersect - x_left) * (y_intersect - y_bottom) / 2);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 只有右下角的点在椭圆内
                else if (bottomRightInEllipse && !topLeftInEllipse && !topRightInEllipse && !bottomLeftInEllipse) {
                    double x_intersect = -sqrt(1 - 4 * y_bottom * y_bottom);
                    double y_intersect = sqrt((1 - x_right * x_right) / 4);
                    double areaInEllipse = abs((x_right - x_intersect) * (y_intersect - y_bottom) / 2);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }

            }
            else if (inEllipseCount == 3) {
                //F[i * ny + j] = 0.75;  
                double rectWidth = x_right - x_left;
                double rectHeight = y_top - y_bottom;

                // 只有左上角的点在椭圆外
                if (!topLeftInEllipse && topRightInEllipse && bottomLeftInEllipse && bottomRightInEllipse) {
                    double x_intersect = -sqrt(1 - 4 * y_top * y_top);     // 椭圆在 y = y_top 的 x 坐标范围
                    double y_intersect = sqrt((1 - x_left * x_left) / 4);  // 椭圆在 x = x_left 的 y 坐标范围
                    double areaInEllipse = abs(rectWidth * rectHeight - (x_intersect - x_left) * (y_top - y_intersect) / 2);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }

                // 只有右上角的点在椭圆外
                else if (topLeftInEllipse && !topRightInEllipse && bottomLeftInEllipse && bottomRightInEllipse) {
                    double x_intersect = sqrt(1 - 4 * y_top * y_top);
                    double y_intersect = sqrt((1 - x_right * x_right) / 4);
                    double areaInEllipse = abs(rectWidth * rectHeight - (x_right - x_intersect) * (y_top - y_intersect) / 2);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }

                // 只有左下角的点在椭圆外
                else if (topLeftInEllipse && topRightInEllipse && !bottomLeftInEllipse && bottomRightInEllipse) {
                    double x_intersect = -sqrt(1 - 4 * y_bottom * y_bottom);
                    double y_intersect = -sqrt((1 - x_left * x_left) / 4);
                    double areaInEllipse = abs(rectWidth * rectHeight - (x_intersect - x_left) * (y_intersect - y_bottom) / 2);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }

                // 只有右下角的点在椭圆外
                else if (topLeftInEllipse && topRightInEllipse && bottomLeftInEllipse && !bottomRightInEllipse) {
                    double x_intersect = sqrt(1 - 4 * y_bottom * y_bottom);
                    double y_intersect = -sqrt((1 - x_right * x_right) / 4);
                    double areaInEllipse = abs(rectWidth * rectHeight - (x_right - x_intersect) * (y_intersect - y_bottom) / 2);
                    F[i * ny + j] = areaInEllipse / (rectWidth * rectHeight);
                }
            }

        }
    }

    // 打印总进程数和当前进程编号
    std::cout << "Total MPI processes: " << size << ", Rank: " << rank << std::endl;

    int iter = 0;

    // 记录运行时间
    auto start = chrono::high_resolution_clock::now();
    Jacobi_MPI(iter);
    auto end = chrono::high_resolution_clock::now();

    // 计算耗时
    auto TIME = chrono::duration_cast<chrono::milliseconds>(end - start).count();
    if (rank == 0) {
        cout << std::fixed << std::setprecision(2) // 设置固定小数点格式和精度
            << "Time: " << static_cast<double>(TIME) << " ms" << endl;
        cout << "Iterations: " << iter << endl;
    }

    MPI_Finalize();
    return 0;
}

