#include "trapeze.h"

using namespace std;

int blub(int a) {
	return a;
}

double trapeze(const double func(double),const double start, const double stop, const int resolution) {
	double step = (stop - start) / resolution;
	double x = start;
	double sum = 0;
	for (int i = 1; i < resolution; i++) {
		sum += func(x += step) ;
	}
	sum *= 2;
	sum += func(start) + func(stop);
	return step * sum / 2.;
}

template<int T> double trapeze(const array<double, T> func, const double step) {
	int n = func.size()-1;
	double sum = func.front + func.back + \
		2 * accumulate(begin(func), end(func), 0, plus<int>());
	return step * sum / 2.;
}


double scalarProduct(const array<double, 2> a, const array<double,2> b) {
	vector<double> result;
	transform(a.begin(), a.end(), b.begin(), back_inserter(result), std::multiplies<double>());
	return accumulate(begin(result), end(result), 0, plus<int>());
}

template <int N> 
double scalarProduct(const std::array<double, N> a, const std::array<double, N> b) {
	std::vector<double> result;
	result.reserve(N);
	std::transform(a.begin(), a.end(), b.begin(),std::back_inserter(result), std::multiplies<double>());
	return accumulate(begin(result), end(result), 0, std::plus<int>());
}