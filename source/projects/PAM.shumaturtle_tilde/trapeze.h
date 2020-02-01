#pragma once

#include<array>
#include<vector>
#include<numeric>



double trapeze(double func(const double, std::vector<double> ), const double start,\
	const double stop, const int resolution, std::vector<double> args) {
	double step = (stop - start) / resolution;
	double x = start;
	double sum = 0;
	for (int i = 1; i < resolution; i++) {
		sum += func(x += step,args);
	}
	sum *= 2;
	sum += func(start,args) + func(stop,args);
	return step * sum / 2.;
}


template <int N>
double scalarProduct(const std::array<double, N> &a, const std::array<double, N> &b) {
	int n = a.size();
	double result = 0.;
	while (n--) {
		result += a[n] * b[n];
	}
	return result;
}
