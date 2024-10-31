#include <iostream>
#include <vector>
#include <cmath>
#include <chrono>
#include <omp.h>
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
vector<vector<double>> u(nx, vector<double>(ny, 0.0));
vector<vector<double>> A(nx, vector<double>(ny, 0.0));
vector<vector<double>> B(nx, vector<double>(ny, 0.0));
vector<vector<double>> F(nx, vector<double>(ny, 0.0));
vector<vector<double>> w(nx, vector<double>(ny, 0.0));

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



void gauss_Seidel(int& iter) {
    double hx = 1.0 / (h_1 * h_1);
    double hy = 1.0 / (h_2 * h_2);
    bool converged = false;

    int max_iter = 50000; //最大迭代次数

    while (!converged && iter < max_iter) {
        converged = true;

#pragma omp parallel
        {
            bool thread_converged = true;
            // #pragma omp for 指定了一个并行 for 循环，OpenMP 会自动将循环中的工作分配给多个线程。
#pragma omp for collapse(2)         // collapse(2) 表示将嵌套的双重循环,同时并行展开，从而提高并行粒度，使得更多线程能够同时处理不同的 (i, j) 网格点。
            for (int i = 1; i < nx - 1; ++i) 
            {
                for (int j = 1; j < ny - 1; ++j) 
                {
                    double u_old = u[i][j];

                    u[i][j] = (u[i + 1][j] * A[i + 1][j] * hx + u[i - 1][j] * A[i][j] * hx +
                        u[i][j + 1] * B[i][j + 1] * hy + u[i][j - 1] * B[i][j] * hy + F[i][j]) /
                        (A[i + 1][j] * hx + A[i][j] * hx + B[i][j + 1] * hy + B[i][j] * hy);  // Gauss-Seidel 迭代法更新u[i][j]

                    if (fabs(u[i][j] - u_old) > accurate) 
                    {
                        thread_converged = false;
                    }
                }
            }
            // 同步全局收敛状态(Synchronizing the global convergence state)
#pragma omp critical
            converged &= thread_converged;
        }
        iter++;
    }
    if (iter >= max_iter) {
        cout << "Warning: Reached maximum iteration limit without full convergence." << endl;
    }

}


int main() {

    std::ostringstream filename;
    filename << "result_" << static_cast<int>(M) << "x" << static_cast<int>(N) << ".csv";
    std::ofstream outfile(filename.str()); // 创建 CSV 文件
    for (int i = 0; i < nx; ++i) {
        for (int j = 1; j < ny; ++j) {
            A[i][j] = l_y(xmin + i * h_1, ymin + j * h_2) / h_2 + (1 - l_y(xmin + i * h_1, ymin + j * h_2) / h_2) / eps;
            B[i][j] = l_x(xmin + i * h_1, ymin + j * h_2) / h_1 + (1 - l_x(xmin + i * h_1, ymin + j * h_2) / h_1) / eps;

            // 定义每个顶点的坐标
            double x_left = xmin + i * h_1 - 0.5 * h_1;
            double x_right = xmin + i * h_1 + 0.5 * h_1;
            double y_top = ymin + j * h_2 + 0.5 * h_2;
            double y_bottom = ymin + j * h_2 - 0.5 * h_2;

            // 判断四个顶点是否在椭圆内
            bool topLeftInEllipse = isInEllipse(x_left, y_top);
            bool bottomLeftInEllipse = isInEllipse(x_left, y_bottom);
            bool topRightInEllipse = isInEllipse(x_right, y_top);
            bool bottomRightInEllipse = isInEllipse(x_right, y_bottom);

            int inEllipseCount = topLeftInEllipse + bottomLeftInEllipse + topRightInEllipse + bottomRightInEllipse;

            if (inEllipseCount == 4) {
                F[i][j] = 1.0;  // 100% 面积在椭圆内
            }
            else if (inEllipseCount == 0) {
                F[i][j] = 0.0;  // 0% 面积在椭圆内
            }
            else if (inEllipseCount == 2) {
                //F[i][j] = 0.5;  
                double rectWidth = x_right - x_left;
                double rectHeight = y_top - y_bottom;
                double ellipseHalfWidth = sqrt(1 - 4 * y_bottom * y_bottom);  // 椭圆在y=y_bottom处的x坐标范围
                double ellipseHalfHeight = sqrt((1 - x_left * x_left) / 4);    // 椭圆在x=x_left处的y坐标范围

                // 左边两个点在椭圆外
                if (!topLeftInEllipse && !bottomLeftInEllipse && topRightInEllipse && bottomRightInEllipse) {
                    double areaInEllipse = abs((x_right + ellipseHalfWidth) * rectHeight);
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 右边两个点在椭圆外
                else if (topLeftInEllipse && bottomLeftInEllipse && !topRightInEllipse && !bottomRightInEllipse) {
                    double areaInEllipse = abs((ellipseHalfWidth - x_left) * rectHeight); // 假设左半边面积完全被覆盖
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 上边两个点在椭圆外
                else if (!topLeftInEllipse && !topRightInEllipse && bottomLeftInEllipse && bottomRightInEllipse) {
                    double areaInEllipse = abs((ellipseHalfHeight - y_bottom) * rectWidth); // 下半边被椭圆覆盖
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 下边两个点在椭圆外
                else if (topLeftInEllipse && topRightInEllipse && !bottomLeftInEllipse && !bottomRightInEllipse) {
                    double areaInEllipse = abs((y_top + ellipseHalfHeight) * rectWidth); // 上半边被椭圆覆盖
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }

            }
            else if (inEllipseCount == 1) {
                //F[i][j] = 0.25;  
                double rectWidth = x_right - x_left;
                double rectHeight = y_top - y_bottom;
                // 只有左上角的点在椭圆内
                if (topLeftInEllipse && !topRightInEllipse && !bottomLeftInEllipse && !bottomRightInEllipse) {
                    double x_intersect = sqrt(1 - 4 * y_top * y_top);     // 椭圆在 y = y_top 的 x 坐标范围
                    double y_intersect = -sqrt((1 - x_left * x_left) / 4); // 椭圆在 x = x_left 的 y 坐标范围
                    double areaInEllipse = abs((x_intersect - x_left) * (y_top - y_intersect) / 2); // 计算覆盖面积
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 只有右上角的点在椭圆内
                else if (topRightInEllipse && !topLeftInEllipse && !bottomLeftInEllipse && !bottomRightInEllipse) {
                    double x_intersect = -sqrt(1 - 4 * y_top * y_top);     
                    double y_intersect = -sqrt((1 - x_right * x_right) / 4); 
                    double areaInEllipse = abs((x_right - x_intersect) * (y_top - y_intersect) / 2);
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 只有左下角的点在椭圆内
                else if (bottomLeftInEllipse && !topLeftInEllipse && !topRightInEllipse && !bottomRightInEllipse) {
                    double x_intersect = sqrt(1 - 4 * y_bottom * y_bottom); 
                    double y_intersect = sqrt((1 - x_left * x_left) / 4);   
                    double areaInEllipse = abs((x_intersect - x_left) * (y_intersect - y_bottom) / 2);
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 只有右下角的点在椭圆内
                else if (bottomRightInEllipse && !topLeftInEllipse && !topRightInEllipse && !bottomLeftInEllipse) {
                    double x_intersect = -sqrt(1 - 4 * y_bottom * y_bottom); 
                    double y_intersect = sqrt((1 - x_right * x_right) / 4); 
                    double areaInEllipse = abs((x_right - x_intersect) * (y_intersect - y_bottom) / 2);
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }

            }
            else if (inEllipseCount == 3) {
                //F[i][j] = 0.75;  
                double rectWidth = x_right - x_left;
                double rectHeight = y_top - y_bottom;

                // 只有左上角的点在椭圆外
                if (!topLeftInEllipse && topRightInEllipse && bottomLeftInEllipse && bottomRightInEllipse) {
                    double x_intersect = -sqrt(1 - 4 * y_top * y_top);     // 椭圆在 y = y_top 的 x 坐标范围
                    double y_intersect = sqrt((1 - x_left * x_left) / 4);  // 椭圆在 x = x_left 的 y 坐标范围
                    double areaInEllipse = abs(rectWidth * rectHeight - (x_intersect - x_left) * (y_top - y_intersect) / 2);
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 只有右上角的点在椭圆外
                else if (topLeftInEllipse && !topRightInEllipse && bottomLeftInEllipse && bottomRightInEllipse) {
                    double x_intersect = sqrt(1 - 4 * y_top * y_top);      
                    double y_intersect = sqrt((1 - x_right * x_right) / 4); 
                    double areaInEllipse = abs(rectWidth * rectHeight - (x_right - x_intersect) * (y_top - y_intersect) / 2);
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 只有左下角的点在椭圆外
                else if (topLeftInEllipse && topRightInEllipse && !bottomLeftInEllipse && bottomRightInEllipse) {
                    double x_intersect = -sqrt(1 - 4 * y_bottom * y_bottom); 
                    double y_intersect = -sqrt((1 - x_left * x_left) / 4);   
                    double areaInEllipse = abs(rectWidth * rectHeight - (x_intersect - x_left) * (y_intersect - y_bottom) / 2);
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }
                // 只有右下角的点在椭圆外
                else if (topLeftInEllipse && topRightInEllipse && bottomLeftInEllipse && !bottomRightInEllipse) {
                    double x_intersect = sqrt(1 - 4 * y_bottom * y_bottom); 
                    double y_intersect = -sqrt((1 - x_right * x_right) / 4); 
                    double areaInEllipse = abs(rectWidth * rectHeight - (x_right - x_intersect) * (y_intersect - y_bottom) / 2);
                    F[i][j] = areaInEllipse / (rectWidth * rectHeight);
                }
            }

        }
    }

    int iter = 0;
    auto start = chrono::high_resolution_clock::now();
    gauss_Seidel(iter);
    auto duration = chrono::duration_cast<chrono::microseconds>(chrono::high_resolution_clock::now() - start);

    for (int i = 0; i < nx; ++i) {
        for (int j = 0; j < ny; ++j) {
            double x = xmin + i * h_1;
            double y = ymin + j * h_2;
            w[i][j] = isInEllipse(x, y) ? u[i][j] : 0; // 将值赋给 w[i][j]
            cout << w[i][j] << " "; // 直接输出 w[i][j]
        }
        cout << endl;
    }

    // 按矩阵形式写入数据
    for (int j = 0; j < ny; ++j) {
        for (int i = 0; i < nx; ++i) {
            if (isInEllipse(xmin + i * h_1, ymin + j * h_2)) {
                outfile << u[i][j]; // 写入 u 值
            }
            else {
                outfile << 0; // 写入 0 表示不在椭圆内的区域
            }
            if (i < nx - 1) outfile << ","; // 每个值之间用逗号分隔
        }
        outfile << "\n"; // 每一行结束换行
    }

    outfile.close(); // 关闭文件


    cout << "Time used: " << duration.count() / 1000.0 << " ms\n"
        << "Number of iterations: " << iter << endl;

    return 0;
}