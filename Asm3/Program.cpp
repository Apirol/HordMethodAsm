#include <stdlib.h>
#include <stdio.h>
#include <locale>
#include <iostream>

extern "C" {int HordMethod(float e, float* x); }

int main()
{
	setlocale(LC_CTYPE, "Russian");
	float eps, x;
	std::cout << "Enter precision" << std::endl;
	std::cin >> eps;
	int iteration = HordMethod(eps, &x);
	std::cout.precision(8);
	std::cout << "X = " << x << std::endl << "Number of iterations: " << iteration << std::endl;
	return 0;
}
